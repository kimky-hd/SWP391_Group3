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

    public boolean addToCart(int accountId, int productId, int quantity) {
        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        String checkSql = "SELECT Quantity FROM Cart WHERE AccountID = ? AND ProductID = ?";
        try (Connection conn = getConnection(); PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, accountId);
            checkPs.setInt(2, productId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Sản phẩm đã tồn tại trong giỏ hàng, cập nhật số lượng
                    int currentQuantity = rs.getInt("Quantity");
                    String updateSql = "UPDATE Cart SET Quantity = ? WHERE AccountID = ? AND ProductID = ?";

                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, currentQuantity + quantity);
                        updatePs.setInt(2, accountId);
                        updatePs.setInt(3, productId);

                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    // Sản phẩm chưa có trong giỏ hàng, thêm mới
                    String insertSql = "INSERT INTO Cart (AccountID, ProductID, Quantity) VALUES (?, ?, ?)";

                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, accountId);
                        insertPs.setInt(2, productId);
                        insertPs.setInt(3, quantity);

                        return insertPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Product WHERE productID = ?";

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
                    product.setProductID(rs.getInt("productID")); // Đúng
                    product.setTitle(rs.getString("title")); // Sửa thành 'title'
                    product.setPrice(rs.getDouble("price")); // Đúng
                    product.setDescription(rs.getString("description")); // Đúng
                    product.setImage(rs.getString("image")); // Đúng
                    product.setQuantity(rs.getInt("quantity")); // Đúng
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
        String sql = "SELECT quantity FROM Product WHERE productID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        String sql = "UPDATE Product SET quantity = quantity + ? WHERE productID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            return ps.executeUpdate() >= 0; // Return true even if no items to delete
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getCartItemCount(int accountId) {
        String sql = "SELECT COUNT(*) FROM Cart WHERE AccountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        String sql = "SELECT SUM(c.Quantity * p.Price) as total "
                + "FROM Cart c JOIN Product p ON c.ProductID = p.ProductID "
                + "WHERE c.AccountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        String sql = "SELECT c.ProductID, c.Quantity, p.title as Name, p.Price, p.Description, p.Image, p.Quantity AS StockQuantity "
                + "FROM Cart c JOIN Product p ON c.ProductID = p.ProductID "
                + "WHERE c.AccountID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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