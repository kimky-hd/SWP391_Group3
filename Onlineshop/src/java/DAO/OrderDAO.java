package DAO;

import Model.Order;
import Model.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import DAO.DBContext;

public class OrderDAO extends DBContext {
    
    public boolean createOrder(Order order, List<OrderDetail> orderDetails) {
        // Câu lệnh SQL để chèn vào bảng HoaDon
        String orderSql = "INSERT INTO HoaDon (accountID, tongGia, ngayXuat, statusID) "
                + "VALUES (?, ?, ?, ?)";
        
        // Câu lệnh SQL để chèn vào bảng InforLine
        String infoSql = "INSERT INTO InforLine (maHD, name, email, address, phoneNumber) "
                + "VALUES (?, ?, ?, ?, ?)";
        
        // Câu lệnh SQL để chèn vào bảng OrderDetail
        String detailSql = "INSERT INTO OrderDetail (maHD, productID, price, quantity) "
                + "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getAccountId());
                ps.setDouble(2, order.getTotal());
                ps.setDate(3, new java.sql.Date(order.getOrderDate().getTime()));
                ps.setInt(4, 1); // Mặc định là "Đang Chuẩn Bị"
                
                int affectedRows = ps.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }
                
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1);
                        
                        // Chèn thông tin khách hàng
                        try (PreparedStatement infoPs = conn.prepareStatement(infoSql)) {
                            infoPs.setInt(1, orderId);
                            infoPs.setString(2, order.getFullName());
                            infoPs.setString(3, order.getEmail());
                            infoPs.setString(4, order.getAddress());
                            infoPs.setString(5, order.getPhone());
                            infoPs.executeUpdate();
                        }
                        
                        // Chèn chi tiết đơn hàng
                        try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                            for (OrderDetail detail : orderDetails) {
                                detailPs.setInt(1, orderId);
                                detailPs.setInt(2, detail.getProductId());
                                detailPs.setDouble(3, detail.getPrice());
                                detailPs.setInt(4, detail.getQuantity());
                                detailPs.addBatch();
                            }
                            detailPs.executeBatch();
                        }
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            System.out.println("Error creating order: " + e.getMessage());
            e.printStackTrace(); // In chi tiết lỗi để dễ dàng debug
            return false;
        }
    }
    
    public List<Order> getOrdersByAccountId(int accountId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, i.name, i.phoneNumber, i.email, i.address " +
                     "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD " +
                     "WHERE h.accountID = ? ORDER BY h.maHD DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setFullName(rs.getString("name"));
                    order.setPhone(rs.getString("phoneNumber"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    // Không có cột payment_method trong bảng HoaDon hoặc InforLine
                    // order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotal(rs.getDouble("tongGia"));
                    
                    // Chuyển đổi statusID thành chuỗi trạng thái
                    int statusID = rs.getInt("statusID");
                    String status;
                    switch (statusID) {
                        case 1:
                            status = "Pending";
                            break;
                        case 2:
                            status = "Completed";
                            break;
                        case 3:
                            status = "Cancelled";
                            break;
                        default:
                            status = "Unknown";
                    }
                    order.setStatus(status);
                    
                    orders.add(order);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting orders: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    public Order getOrderById(int orderId) {
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, i.name, i.phoneNumber, i.email, i.address " +
                     "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD " +
                     "WHERE h.maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setFullName(rs.getString("name"));
                    order.setPhone(rs.getString("phoneNumber"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    order.setTotal(rs.getDouble("tongGia"));
                    
                    // Chuyển đổi statusID thành chuỗi trạng thái
                    int statusID = rs.getInt("statusID");
                    String status;
                    switch (statusID) {
                        case 1:
                            status = "Pending";
                            break;
                        case 2:
                            status = "Completed";
                            break;
                        case 3:
                            status = "Cancelled";
                            break;
                        default:
                            status = "Unknown";
                    }
                    order.setStatus(status);
                    
                    return order;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting order: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetail WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    // Không có cột order_detail_id trong bảng OrderDetail
                    // detail.setOrderDetailId(rs.getInt("order_detail_id"));
                    detail.setOrderId(rs.getInt("maHD"));
                    detail.setProductId(rs.getInt("productID"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setPrice(rs.getDouble("price"));
                    // Tính tổng tiền nếu không có cột total
                    double total = rs.getDouble("price") * rs.getInt("quantity");
                    detail.setTotal(total);
                    details.add(detail);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting order details: " + e.getMessage());
            e.printStackTrace();
        }
        
        return details;
    }
    
    public boolean cancelOrder(int orderId) {
        String sql = "UPDATE HoaDon SET statusID = 3 WHERE maHD = ? AND statusID = 1";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error cancelling order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public int countOrdersByAccountId(int accountId) {
        String sql = "SELECT COUNT(*) FROM HoaDon WHERE accountID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error counting orders: " + e.getMessage());
        }
        
        return 0;
    }
    
    public boolean deleteOrder(int orderId) {
        // Xóa các chi tiết đơn hàng trước
        String deleteDetailsSQL = "DELETE FROM OrderDetail WHERE maHD = ?";
        // Xóa thông tin khách hàng
        String deleteInfoSQL = "DELETE FROM InforLine WHERE maHD = ?";
        // Sau đó xóa đơn hàng
        String deleteOrderSQL = "DELETE FROM HoaDon WHERE maHD = ?";
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // Xóa chi tiết đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(deleteDetailsSQL)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }
            
            // Xóa thông tin khách hàng
            try (PreparedStatement ps = conn.prepareStatement(deleteInfoSQL)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }
            
            // Xóa đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(deleteOrderSQL)) {
                ps.setInt(1, orderId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.out.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
}