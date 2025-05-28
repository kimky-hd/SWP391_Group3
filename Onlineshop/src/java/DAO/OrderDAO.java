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
        String orderSql = "INSERT INTO Orders (account_id, order_date, full_name, phone, email, address, payment_method, total, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        String detailSql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price, total) "
                + "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getAccountId());
                ps.setTimestamp(2, new java.sql.Timestamp(order.getOrderDate().getTime()));
                ps.setString(3, order.getFullName());
                ps.setString(4, order.getPhone());
                ps.setString(5, order.getEmail());
                ps.setString(6, order.getAddress());
                ps.setString(7, order.getPaymentMethod());
                ps.setDouble(8, order.getTotal());
                ps.setString(9, order.getStatus());
                
                int affectedRows = ps.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }
                
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1);
                        
                        // Insert order details
                        try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                            for (OrderDetail detail : orderDetails) {
                                detailPs.setInt(1, orderId);
                                detailPs.setInt(2, detail.getProductId());
                                detailPs.setInt(3, detail.getQuantity());
                                detailPs.setDouble(4, detail.getPrice());
                                detailPs.setDouble(5, detail.getTotal());
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
            return false;
        }
    }
    
    public List<Order> getOrdersByAccountId(int accountId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE account_id = ? ORDER BY order_date DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setAccountId(rs.getInt("account_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setFullName(rs.getString("full_name"));
                    order.setPhone(rs.getString("phone"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotal(rs.getDouble("total"));
                    order.setStatus(rs.getString("status"));
                    orders.add(order);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting orders: " + e.getMessage());
        }
        
        return orders;
    }
    
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE order_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setAccountId(rs.getInt("account_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setFullName(rs.getString("full_name"));
                    order.setPhone(rs.getString("phone"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotal(rs.getDouble("total"));
                    order.setStatus(rs.getString("status"));
                    return order;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting order: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE order_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setOrderDetailId(rs.getInt("order_detail_id"));
                    detail.setOrderId(rs.getInt("order_id"));
                    detail.setProductId(rs.getInt("product_id"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setPrice(rs.getDouble("price"));
                    detail.setTotal(rs.getDouble("total"));
                    details.add(detail);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting order details: " + e.getMessage());
        }
        
        return details;
    }
    
    public boolean cancelOrder(int orderId) {
        String sql = "UPDATE Orders SET status = 'Cancelled' WHERE order_id = ? AND status = 'Pending'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error cancelling order: " + e.getMessage());
            return false;
        }
    }
}