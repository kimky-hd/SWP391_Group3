package DAO;

import Model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import DAO.DBContext;

public class CartDAO extends DBContext {
    
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Products WHERE product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setDescription(rs.getString("description"));
                    product.setImage(rs.getString("image"));
                    product.setQuantity(rs.getInt("quantity"));
                    product.setCategoryID(rs.getInt("category_id"));
                    return product;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    public boolean checkProductAvailability(int productId, int requestedQuantity) {
        String sql = "SELECT quantity FROM Products WHERE product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int availableQuantity = rs.getInt("quantity");
                    return availableQuantity >= requestedQuantity;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error checking product availability: " + e.getMessage());
        }
        
        return false;
    }
    
    public boolean updateProductQuantity(int productId, int quantityChange) {
        String sql = "UPDATE Products SET quantity = quantity + ? WHERE product_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantityChange);
            ps.setInt(2, productId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error updating product quantity: " + e.getMessage());
        }
        
        return false;
    }
    
    public boolean reserveProducts(int orderId, int productId, int quantity) {
        // Kiểm tra số lượng sản phẩm có sẵn
        if (!checkProductAvailability(productId, quantity)) {
            return false;
        }
        
        // Cập nhật số lượng sản phẩm
        return updateProductQuantity(productId, -quantity);
    }
}