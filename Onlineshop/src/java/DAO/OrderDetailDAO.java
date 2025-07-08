package DAO;

import Model.OrderDetail;
import Model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for OrderDetail management
 */
public class OrderDetailDAO extends DBContext {
    
    /**
     * Get all order details for a specific order
     * @param orderId Order ID (maHD)
     * @return List of OrderDetail objects
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT od.orderdetailID, od.maHD, od.productID, od.price, od.quantity, " +
                     "p.title, p.image, p.description " +
                     "FROM orderdetail od " +
                     "JOIN product p ON od.productID = p.productID " +
                     "WHERE od.maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderDetailId(rs.getInt("orderdetailID"));
                orderDetail.setOrderId(rs.getInt("maHD"));
                orderDetail.setProductId(rs.getInt("productID"));
                orderDetail.setPrice(rs.getDouble("price"));
                orderDetail.setQuantity(rs.getInt("quantity"));
                orderDetail.setTotal(rs.getDouble("price") * rs.getInt("quantity"));
                
                // Create product object
                Product product = new Product();
                product.setProductID(rs.getInt("productID"));
                product.setTitle(rs.getString("title"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                
                orderDetail.setProduct(product);
                orderDetails.add(orderDetail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orderDetails;
    }
    
    /**
     * Get order detail by ID
     * @param orderDetailId Order detail ID
     * @return OrderDetail object or null if not found
     */
    public OrderDetail getOrderDetailById(int orderDetailId) {
        String sql = "SELECT od.orderdetailID, od.maHD, od.productID, od.price, od.quantity, " +
                     "p.title, p.image, p.description " +
                     "FROM orderdetail od " +
                     "JOIN product p ON od.productID = p.productID " +
                     "WHERE od.orderdetailID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderDetailId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderDetailId(rs.getInt("orderdetailID"));
                orderDetail.setOrderId(rs.getInt("maHD"));
                orderDetail.setProductId(rs.getInt("productID"));
                orderDetail.setPrice(rs.getDouble("price"));
                orderDetail.setQuantity(rs.getInt("quantity"));
                orderDetail.setTotal(rs.getDouble("price") * rs.getInt("quantity"));
                
                // Create product object
                Product product = new Product();
                product.setProductID(rs.getInt("productID"));
                product.setTitle(rs.getString("title"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                
                orderDetail.setProduct(product);
                return orderDetail;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Add a new order detail
     * @param orderDetail OrderDetail object to add
     * @return true if successful, false otherwise
     */
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO orderdetail (maHD, productID, price, quantity) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderDetail.getOrderId());
            ps.setInt(2, orderDetail.getProductId());
            ps.setDouble(3, orderDetail.getPrice());
            ps.setInt(4, orderDetail.getQuantity());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing order detail
     * @param orderDetail OrderDetail object to update
     * @return true if successful, false otherwise
     */
    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "UPDATE orderdetail SET productID = ?, price = ?, quantity = ? WHERE orderdetailID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderDetail.getProductId());
            ps.setDouble(2, orderDetail.getPrice());
            ps.setInt(3, orderDetail.getQuantity());
            ps.setInt(4, orderDetail.getOrderDetailId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete an order detail
     * @param orderDetailId Order detail ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteOrderDetail(int orderDetailId) {
        String sql = "DELETE FROM orderdetail WHERE orderdetailID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderDetailId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get total amount for an order
     * @param orderId Order ID
     * @return Total amount
     */
    public double getTotalAmountByOrderId(int orderId) {
        String sql = "SELECT SUM(price * quantity) as totalAmount FROM orderdetail WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("totalAmount");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * Get total quantity for an order
     * @param orderId Order ID
     * @return Total quantity
     */
    public int getTotalQuantityByOrderId(int orderId) {
        String sql = "SELECT SUM(quantity) as totalQuantity FROM orderdetail WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("totalQuantity");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
