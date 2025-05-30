package DAO;

import Model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import DAO.DBContext;
import Model.Cart;
import Model.CartItem;
import Model.Product;

public class CartDAO extends DBContext {
    
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Products WHERE product_id = ?";
        
        Connection conn = getConnection();
        if (conn == null) {
            System.out.println("Không thể kết nối đến cơ sở dữ liệu");
            return null;
        }
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setProductID(rs.getInt("product_id"));
                    product.setTitle(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setDescription(rs.getString("description"));
                    product.setImage(rs.getString("image"));
                    product.setQuantity(rs.getInt("quantity"));
                    return product;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
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
    
    public boolean removeFromCart(int accountId, int productId) {
        String sql = "DELETE FROM Cart WHERE AccountID = ? AND ProductID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean clearCart(int accountId) {
        String sql = "DELETE FROM Cart WHERE AccountID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            return ps.executeUpdate() >= 0; // Return true even if no items to delete
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getCartItemCount(int accountId) {
        String sql = "SELECT COUNT(*) FROM Cart WHERE AccountID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getCartTotal(int accountId) {
        String sql = "SELECT SUM(c.Quantity * p.Price) as total " +
                    "FROM Cart c JOIN Products p ON c.ProductID = p.ProductID " +
                    "WHERE c.AccountID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    
public Cart getCartByAccount_Id(int accountId) {
    Cart cart = new Cart();
    String sql = "SELECT c.ProductID, c.Quantity, p.Name, p.Price, p.Description, p.Image, p.Quantity AS StockQuantity " +
                 "FROM Cart c JOIN Products p ON c.ProductID = p.ProductID " +
                 "WHERE c.AccountID = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, accountId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setProductID(rs.getInt("ProductID"));
                product.setTitle(rs.getString("Name"));
                product.setPrice(rs.getDouble("Price"));
                product.setDescription(rs.getString("Description"));
                product.setImage(rs.getString("Image"));
                product.setQuantity(rs.getInt("StockQuantity"));
                // Xóa dòng setCategoryID vì không có trường này

                int quantity = rs.getInt("Quantity");

                CartItem item = new CartItem(product, quantity);
                cart.addItem(item);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return cart;
}


}