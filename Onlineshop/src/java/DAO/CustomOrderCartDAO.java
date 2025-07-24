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
 * Lớp CustomOrderCartDAO (Data Access Object) chịu trách nhiệm tương tác với cơ
 * sở dữ liệu để quản lý các thao tác liên quan đến giỏ hàng đặt hàng tùy chỉnh
 * của người dùng. Lớp này kế thừa từ DBContext để có thể sử dụng kết nối cơ sở
 * dữ liệu.
 */
public class CustomOrderCartDAO extends DBContext {

    /**
     * Lấy danh sách tất cả các đơn hàng tùy chỉnh của một người dùng cụ thể.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Danh sách các đơn hàng tùy chỉnh, hoặc danh sách rỗng nếu không
     * có đơn hàng nào hoặc có lỗi.
     */
    public List<CustomOrderCart> getCustomOrderCartsByAccountId(int accountId) {
        List<CustomOrderCart> customOrderCarts = new ArrayList<>();
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c "
                + "JOIN status s ON c.statusID = s.statusID "
                + "WHERE c.accountID = ? ORDER BY c.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);

            // Trong phương thức getCustomOrderCartsByAccountId
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomOrderCart customOrderCart = new CustomOrderCart();
                    customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                    customOrderCart.setAccountID(rs.getInt("accountID"));
                    customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                    customOrderCart.setReferenceImage2(rs.getString("referenceImage2"));
                    customOrderCart.setReferenceImage3(rs.getString("referenceImage3"));
                    customOrderCart.setReferenceImage4(rs.getString("referenceImage4"));
                    customOrderCart.setReferenceImage5(rs.getString("referenceImage5"));
                    customOrderCart.setDescription(rs.getString("description"));
                    customOrderCart.setQuantity(rs.getInt("quantity"));
                    customOrderCart.setStatusID(rs.getInt("statusID"));
                    customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                    customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));

                    // Thêm thông tin liên hệ khách hàng
                    customOrderCart.setFullName(rs.getString("fullName"));
                    customOrderCart.setPhone(rs.getString("phone"));
                    customOrderCart.setEmail(rs.getString("email"));

                    // Thêm dòng này để lấy manager_comment
                    customOrderCart.setManagerComment(rs.getString("manager_comment"));

                    // Thêm dòng này để lấy desired_price
                    customOrderCart.setDesiredPrice(rs.getDouble("desired_price"));

                    // Thêm dòng này để lấy shipping_fee
                    try {
                        customOrderCart.setShippingFee(rs.getDouble("shipping_fee"));
                    } catch (SQLException ex) {
                        // Xử lý trường hợp cột chưa tồn tại
                        customOrderCart.setShippingFee(0);
                    }

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
     * @return Đối tượng CustomOrderCart chứa thông tin đơn hàng, hoặc null nếu
     * không tìm thấy hoặc có lỗi.
     */
    public CustomOrderCart getCustomOrderCartById(int customCartId) {
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c "
                + "JOIN status s ON c.statusID = s.statusID "
                + "WHERE c.customCartID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customCartId);

            // Trong phương thức getCustomOrderCartById
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomOrderCart customOrderCart = new CustomOrderCart();
                    customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                    customOrderCart.setAccountID(rs.getInt("accountID"));
                    customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                    customOrderCart.setReferenceImage2(rs.getString("referenceImage2"));
                    customOrderCart.setReferenceImage3(rs.getString("referenceImage3"));
                    customOrderCart.setReferenceImage4(rs.getString("referenceImage4"));
                    customOrderCart.setReferenceImage5(rs.getString("referenceImage5"));
                    customOrderCart.setDescription(rs.getString("description"));
                    customOrderCart.setQuantity(rs.getInt("quantity"));
                    customOrderCart.setStatusID(rs.getInt("statusID"));
                    customOrderCart.setStatus(rs.getString("status_name"));
                    customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));

                    // Thêm thông tin liên hệ khách hàng
                    customOrderCart.setFullName(rs.getString("fullName"));
                    customOrderCart.setPhone(rs.getString("phone"));
                    customOrderCart.setEmail(rs.getString("email"));

                    // Thêm thông tin địa chỉ
                    customOrderCart.setAddress(rs.getString("address"));
                    customOrderCart.setDistrict(rs.getString("district"));
                    customOrderCart.setCity(rs.getString("city"));

                    // Thêm dòng này để lấy manager_comment
                    customOrderCart.setManagerComment(rs.getString("manager_comment"));

                    // Thêm dòng này để lấy desired_price
                    customOrderCart.setDesiredPrice(rs.getDouble("desired_price"));

                    // Thêm dòng này để lấy shipping_fee
                    try {
                        customOrderCart.setShippingFee(rs.getDouble("shipping_fee"));
                    } catch (SQLException ex) {
                        // Xử lý trường hợp cột chưa tồn tại
                        customOrderCart.setShippingFee(0);
                    }

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
     * @param customOrderCart Đối tượng CustomOrderCart chứa thông tin đơn hàng
     * cần thêm.
     * @return true nếu thêm thành công, ngược lại là false.
     */
    public boolean addCustomOrderCart(CustomOrderCart customOrderCart) {
        String sql = "INSERT INTO customordercart (accountID, referenceImage, description, quantity, statusID, fullName, phone, email, desired_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customOrderCart.getAccountID());
            ps.setString(2, customOrderCart.getReferenceImage());
            ps.setString(3, customOrderCart.getDescription());
            ps.setInt(4, customOrderCart.getQuantity());
            ps.setInt(5, customOrderCart.getStatusID());
            ps.setString(6, customOrderCart.getFullName());
            ps.setString(7, customOrderCart.getPhone());
            ps.setString(8, customOrderCart.getEmail());
            ps.setDouble(9, customOrderCart.getDesiredPrice());

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
        // Sửa câu lệnh SQL trong phương thức updateCustomOrderCart để bao gồm các
        // trường địa chỉ
        String sql = "UPDATE customordercart SET referenceImage = ?, referenceImage2 = ?, referenceImage3 = ?, referenceImage4 = ?, referenceImage5 = ?, description = ?, quantity = ?, statusID = ?, manager_comment = ?, desired_price = ?, shipping_fee = ?, fullName = ?, phone = ?, email = ?, address = ?, district = ?, city = ? WHERE customCartID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customOrderCart.getReferenceImage());
            ps.setString(2, customOrderCart.getReferenceImage2());
            ps.setString(3, customOrderCart.getReferenceImage3());
            ps.setString(4, customOrderCart.getReferenceImage4());
            ps.setString(5, customOrderCart.getReferenceImage5());
            ps.setString(6, customOrderCart.getDescription());
            ps.setInt(7, customOrderCart.getQuantity());
            ps.setInt(8, customOrderCart.getStatusID());
            ps.setString(9, customOrderCart.getManagerComment());
            ps.setDouble(10, customOrderCart.getDesiredPrice());
            ps.setDouble(11, customOrderCart.getShippingFee());
            ps.setString(12, customOrderCart.getFullName());
            ps.setString(13, customOrderCart.getPhone());
            ps.setString(14, customOrderCart.getEmail());
            ps.setString(15, customOrderCart.getAddress());
            ps.setString(16, customOrderCart.getDistrict());
            ps.setString(17, customOrderCart.getCity());
            ps.setInt(18, customOrderCart.getCustomCartID());

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

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
     * @return Tổng số đơn hàng tùy chỉnh, hoặc 0 nếu không có đơn hàng nào hoặc
     * có lỗi.
     */
    public int getCustomOrderCartCount(int accountId) {
        String sql = "SELECT COUNT(*) FROM customordercart WHERE accountID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
     * Lấy danh sách tất cả các đơn hàng tùy chỉnh trong hệ thống. Phương thức
     * này thường được sử dụng bởi quản trị viên.
     *
     * @return Danh sách tất cả các đơn hàng tùy chỉnh, hoặc danh sách rỗng nếu
     * không có đơn hàng nào hoặc có lỗi.
     */
    public List<CustomOrderCart> getAllCustomOrderCarts() {
        List<CustomOrderCart> customOrderCarts = new ArrayList<>();
        String sql = "SELECT c.*, s.name as status_name FROM customordercart c "
                + "JOIN status s ON c.statusID = s.statusID "
                + "ORDER BY c.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CustomOrderCart customOrderCart = new CustomOrderCart();
                customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                customOrderCart.setAccountID(rs.getInt("accountID"));
                customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                customOrderCart.setReferenceImage2(rs.getString("referenceImage2"));
                customOrderCart.setReferenceImage3(rs.getString("referenceImage3"));
                customOrderCart.setReferenceImage4(rs.getString("referenceImage4"));
                customOrderCart.setReferenceImage5(rs.getString("referenceImage5"));
                customOrderCart.setDescription(rs.getString("description"));
                customOrderCart.setQuantity(rs.getInt("quantity"));
                customOrderCart.setStatusID(rs.getInt("statusID"));
                customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));

                // Thêm thông tin liên hệ khách hàng
                customOrderCart.setFullName(rs.getString("fullName"));
                customOrderCart.setPhone(rs.getString("phone"));
                customOrderCart.setEmail(rs.getString("email"));

                // Thêm dòng này để lấy manager_comment
                customOrderCart.setManagerComment(rs.getString("manager_comment"));

                // Thêm dòng này để lấy desired_price
                customOrderCart.setDesiredPrice(rs.getDouble("desired_price"));

                // Thêm dòng này để lấy shipping_fee
                try {
                    customOrderCart.setShippingFee(rs.getDouble("shipping_fee"));
                } catch (SQLException ex) {
                    // Xử lý trường hợp cột chưa tồn tại
                    customOrderCart.setShippingFee(0);
                }

                customOrderCarts.add(customOrderCart);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách tất cả đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }

        return customOrderCarts;
    }

    /**
     * Lấy danh sách đơn hàng tùy chỉnh theo các tiêu chí lọc.
     *
     * @param customCartId ID của đơn hàng tùy chỉnh (0 nếu không lọc theo ID)
     * @param customerName Tên khách hàng (null hoặc rỗng nếu không lọc theo
     * tên)
     * @param statusId ID trạng thái (0 nếu không lọc theo trạng thái)
     * @return Danh sách các đơn hàng tùy chỉnh phù hợp với tiêu chí lọc
     */
    public List<CustomOrderCart> getFilteredCustomOrderCarts(int customCartId, String customerName, int statusId) {
        List<CustomOrderCart> customOrderCarts = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT c.*, s.name as status_name FROM customordercart c "
                + "JOIN status s ON c.statusID = s.statusID WHERE 1=1");

        List<Object> parameters = new ArrayList<>();

        // Thêm điều kiện lọc theo ID đơn hàng
        if (customCartId > 0) {
            sqlBuilder.append(" AND c.customCartID = ?");
            parameters.add(customCartId);
        }

        // Thêm điều kiện lọc theo tên khách hàng
        if (customerName != null && !customerName.trim().isEmpty()) {
            sqlBuilder.append(" AND c.fullName LIKE ?");
            parameters.add("%" + customerName.trim() + "%");
        }

        // Thêm điều kiện lọc theo trạng thái
        if (statusId > 0) {
            sqlBuilder.append(" AND c.statusID = ?");
            parameters.add(statusId);
        }

        // Thêm sắp xếp theo thời gian tạo giảm dần
        sqlBuilder.append(" ORDER BY c.created_at DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sqlBuilder.toString())) {

            // Thiết lập các tham số
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomOrderCart customOrderCart = new CustomOrderCart();
                    customOrderCart.setCustomCartID(rs.getInt("customCartID"));
                    customOrderCart.setAccountID(rs.getInt("accountID"));
                    customOrderCart.setReferenceImage(rs.getString("referenceImage"));
                    customOrderCart.setReferenceImage2(rs.getString("referenceImage2"));
                    customOrderCart.setReferenceImage3(rs.getString("referenceImage3"));
                    customOrderCart.setReferenceImage4(rs.getString("referenceImage4"));
                    customOrderCart.setReferenceImage5(rs.getString("referenceImage5"));
                    customOrderCart.setDescription(rs.getString("description"));
                    customOrderCart.setQuantity(rs.getInt("quantity"));
                    customOrderCart.setStatusID(rs.getInt("statusID"));
                    customOrderCart.setStatus(rs.getString("status_name")); // Lấy tên trạng thái từ bảng status
                    customOrderCart.setCreatedAt(rs.getTimestamp("created_at"));

                    // Thêm thông tin liên hệ khách hàng
                    customOrderCart.setFullName(rs.getString("fullName"));
                    customOrderCart.setPhone(rs.getString("phone"));
                    customOrderCart.setEmail(rs.getString("email"));

                    // Thêm thông tin địa chỉ
                    customOrderCart.setAddress(rs.getString("address"));
                    customOrderCart.setDistrict(rs.getString("district"));
                    customOrderCart.setCity(rs.getString("city"));

                    // Thêm dòng này để lấy manager_comment
                    customOrderCart.setManagerComment(rs.getString("manager_comment"));

                    // Thêm dòng này để lấy desired_price
                    customOrderCart.setDesiredPrice(rs.getDouble("desired_price"));

                    // Thêm dòng này để lấy shipping_fee
                    try {
                        customOrderCart.setShippingFee(rs.getDouble("shipping_fee"));
                    } catch (SQLException ex) {
                        // Xử lý trường hợp cột chưa tồn tại
                        customOrderCart.setShippingFee(0);
                    }

                    customOrderCarts.add(customOrderCart);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lọc danh sách đơn hàng tùy chỉnh: " + e.getMessage());
            e.printStackTrace();
        }

        return customOrderCarts;
    }
}
