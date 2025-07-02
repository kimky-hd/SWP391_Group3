package DAO;

import Model.CustomOrderCart;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp CustomOrderCartDAO (Data Access Object) chịu trách nhiệm tương tác với cơ sở dữ liệu
 * để quản lý các thao tác liên quan đến giỏ hàng đặt hàng tùy chỉnh của người dùng.
 * Lớp này kế thừa từ DBContext để có thể sử dụng kết nối cơ sở dữ liệu.
 */
public class CustomOrderCartDAO extends DBContext {

    /**
     * Lấy danh sách tất cả các đơn hàng tùy chỉnh của một người dùng cụ thể.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Danh sách các đơn hàng tùy chỉnh, hoặc danh sách rỗng nếu không có đơn hàng nào hoặc có lỗi.
     */
    public List<CustomOrderCart> getCustomOrderCartsByAccountId(int accountId) {
        List<CustomOrderCart> customOrderCarts = new ArrayList<>();
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c " +
                    "JOIN status s ON c.statusID = s.statusID " +
                    "WHERE c.accountID = ? ORDER BY c.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            
            // Trong phương thức getCustomOrderCartsByAccountId
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomOrderCart customOrderCart = new CustomOrderCart();
                    customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                    customOrderCart.setAccountID(rs.getInt("accountID"));
                    customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                    customOrderCart.setDescription(rs.getString("description"));
                    customOrderCart.setQuantity(rs.getInt("quantity"));
                    customOrderCart.setStatusID(rs.getInt("statusID")); 
                    customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                    customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    customOrderCarts.add(customOrderCart);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customOrderCarts;
    }
    
    /**
     * Lấy thông tin chi tiết của một đơn hàng tùy chỉnh dựa trên ID.
     *
     * @param customCartId ID của đơn hàng tùy chỉnh cần lấy thông tin.
     * @return Đối tượng CustomOrderCart chứa thông tin đơn hàng, hoặc null nếu không tìm thấy hoặc có lỗi.
     */
    public CustomOrderCart getCustomOrderCartById(int customCartId) {
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c " +
                    "JOIN status s ON c.statusID = s.statusID " +
                    "WHERE c.customCartID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customCartId);
            
            // Trong phương thức getCustomOrderCartById
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomOrderCart customOrderCart = new CustomOrderCart();
                    customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                    customOrderCart.setAccountID(rs.getInt("accountID"));
                    customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                    customOrderCart.setDescription(rs.getString("description"));
                    customOrderCart.setQuantity(rs.getInt("quantity"));
                    customOrderCart.setStatusID(rs.getInt("statusID")); 
                    customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                    customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    return customOrderCart;
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy thông tin đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thêm một đơn hàng tùy chỉnh mới vào cơ sở dữ liệu.
     *
     * @param customOrderCart Đối tượng CustomOrderCart chứa thông tin đơn hàng cần thêm.
     * @return true nếu thêm thành công, ngược lại là false.
     */
    public boolean addCustomOrderCart(CustomOrderCart customOrderCart) {
        String sql = "INSERT INTO customordercart (accountID, referenceImage, description, quantity, statusID) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customOrderCart.getAccountID());
            ps.setString(2, customOrderCart.getReferenceImage());
            ps.setString(3, customOrderCart.getDescription());
            ps.setInt(4, customOrderCart.getQuantity());
            ps.setInt(5, customOrderCart.getStatusID()); // Thay đổi từ status sang statusID
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật thông tin của một đơn hàng tùy chỉnh trong cơ sở dữ liệu.
     *
     * @param customOrderCart Đối tượng CustomOrderCart chứa thông tin cập nhật.
     * @return true nếu cập nhật thành công, ngược lại là false.
     */
    public boolean updateCustomOrderCart(CustomOrderCart customOrderCart) {
        String sql = "UPDATE customordercart SET referenceImage = ?, description = ?, quantity = ?, statusID = ? WHERE customCartID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customOrderCart.getReferenceImage());
            ps.setString(2, customOrderCart.getDescription());
            ps.setInt(3, customOrderCart.getQuantity());
            ps.setInt(4, customOrderCart.getStatusID()); // Thay đổi từ status sang statusID
            ps.setInt(5, customOrderCart.getCustomCartID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa một đơn hàng tùy chỉnh khỏi cơ sở dữ liệu.
     *
     * @param customCartId ID của đơn hàng tùy chỉnh cần xóa.
     * @return true nếu xóa thành công, ngược lại là false.
     */
    public boolean deleteCustomOrderCart(int customCartId) {
        String sql = "DELETE FROM customordercart WHERE customCartID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customCartId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy tổng số đơn hàng tùy chỉnh của một người dùng.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Tổng số đơn hàng tùy chỉnh, hoặc 0 nếu không có đơn hàng nào hoặc có lỗi.
     */
    public int getCustomOrderCartCount(int accountId) {
        String sql = "SELECT COUNT(*) FROM customordercart WHERE accountID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi đếm số đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy danh sách tất cả các đơn hàng tùy chỉnh trong hệ thống.
     * Phương thức này thường được sử dụng bởi quản trị viên.
     *
     * @return Danh sách tất cả các đơn hàng tùy chỉnh, hoặc danh sách rỗng nếu không có đơn hàng nào hoặc có lỗi.
     */
    public List<CustomOrderCart> getAllCustomOrderCarts() {
        List<CustomOrderCart> customOrderCarts = new ArrayList<>();
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c " +
                    "JOIN status s ON c.statusID = s.statusID " +
                    "ORDER BY c.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CustomOrderCart customOrderCart = new CustomOrderCart();
                customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                customOrderCart.setAccountID(rs.getInt("accountID"));
                customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                customOrderCart.setDescription(rs.getString("description"));
                customOrderCart.setQuantity(rs.getInt("quantity"));
                customOrderCart.setStatusID(rs.getInt("statusID"));
                customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));
                
                customOrderCarts.add(customOrderCart);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách tất cả đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customOrderCarts;
    }
}