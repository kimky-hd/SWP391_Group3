package DAO;

import Model.Feedback;
import Model.FeedbackImage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeedbackDAO extends DBContext {
    
    // Create new feedback
    public boolean createFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (account_id, product_id, rating, comment, order_id, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, feedback.getAccountId());
            ps.setInt(2, feedback.getProductId());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            
            if (feedback.getOrderId() != null) {
                ps.setInt(5, feedback.getOrderId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setFeedbackId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Create new feedback for order
    public boolean createOrderFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (accountID, target_id, feedback_type, rating, comment, created_date, is_active) VALUES (?, ?, 'ORDER', ?, ?, NOW(), 1)";

        System.out.println("=== DEBUG createOrderFeedback ===");
        System.out.println("AccountID: " + feedback.getAccountId());
        System.out.println("OrderID: " + feedback.getOrderId());
        System.out.println("Rating: " + feedback.getRating());
        System.out.println("Comment: " + feedback.getComment());
        System.out.println("SQL: " + sql);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, feedback.getAccountId());
            ps.setInt(2, feedback.getOrderId());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());

            System.out.println("Executing SQL...");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setFeedbackId(rs.getInt(1));
                    System.out.println("Generated feedback ID: " + feedback.getFeedbackId());
                }
                System.out.println("SUCCESS: Feedback created successfully");
                return true;
            } else {
                System.out.println("ERROR: No rows affected");
            }

        } catch (SQLException e) {
            System.err.println("ERROR creating order feedback: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        return false;
    }

    // Create new feedback for product using feedbacks table
    public boolean createProductFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (accountID, target_id, feedback_type, rating, comment, created_date, is_active) VALUES (?, ?, 'PRODUCT', ?, ?, CURRENT_TIMESTAMP, 1)";

        System.out.println("=== DEBUG createProductFeedback ===");
        System.out.println("AccountID: " + feedback.getAccountId());
        System.out.println("ProductID: " + feedback.getProductId());
        System.out.println("Rating: " + feedback.getRating());
        System.out.println("Comment: " + feedback.getComment());
        System.out.println("SQL: " + sql);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, feedback.getAccountId());
            ps.setInt(2, feedback.getProductId()); // target_id is productId for PRODUCT type
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());

            System.out.println("Executing SQL...");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setFeedbackId(rs.getInt(1));
                    System.out.println("Generated feedback ID: " + feedback.getFeedbackId());
                }
                System.out.println("SUCCESS: Product feedback created successfully");
                return true;
            }

        } catch (SQLException e) {
            System.err.println("ERROR creating product feedback: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());

            // Check if it's a duplicate key error (user already rated this product)
            if (e.getMessage().contains("Duplicate entry") || e.getMessage().contains("unique constraint") ||
                e.getSQLState().equals("23000")) {
                System.err.println("User has already rated this product");
            }
            e.printStackTrace();
        }

        return false;
    }

    // Get feedback by ID
    public Feedback getFeedbackById(int feedbackId) {
        String sql = "SELECT f.*, a.username FROM feedbacks f " +
                    "JOIN Account a ON f.accountID = a.id " +
                    "WHERE f.feedback_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToFeedback(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get all feedbacks for a product from feedbacks table
    public List<Feedback> getFeedbacksByProductId(int productId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.accountID, f.target_id as product_id, f.rating, f.comment, f.created_date as created_at, a.username " +
                    "FROM feedbacks f " +
                    "JOIN Account a ON f.accountID = a.accountID " +
                    "WHERE f.target_id = ? AND f.feedback_type = 'PRODUCT' AND f.is_active = 1 " +
                    "ORDER BY f.created_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setAccountId(rs.getInt("accountID"));
                feedback.setProductId(rs.getInt("product_id"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                feedback.setUsername(rs.getString("username"));
                feedbacks.add(feedback);
            }

        } catch (SQLException e) {
            System.err.println("Error getting feedbacks for product " + productId + ": " + e.getMessage());
            e.printStackTrace();
        }

        return feedbacks;
    }
    
    // Get feedbacks by account ID
    public List<Feedback> getFeedbacksByAccountId(int accountId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, a.username, p.title as product_title FROM feedback f " +
                    "JOIN Account a ON f.account_id = a.id " +
                    "JOIN Product p ON f.product_id = p.id " +
                    "WHERE f.account_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setProductTitle(rs.getString("product_title"));
                feedbacks.add(feedback);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Update feedback
    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE feedback SET rating = ?, comment = ?, updated_at = GETDATE() WHERE feedback_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, feedback.getRating());
            ps.setString(2, feedback.getComment());
            ps.setInt(3, feedback.getFeedbackId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Delete feedback
    public boolean deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedback WHERE feedback_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, feedbackId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if user has already given feedback for a product
    public boolean hasFeedback(int accountId, int productId) {
        String sql = "SELECT COUNT(*) FROM feedbacks WHERE accountID = ? AND target_id = ? AND feedback_type = 'PRODUCT'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Check if user has already given feedback for an order
    public boolean checkFeedbackExists(int accountId, int orderId) {
        String sql = "SELECT COUNT(*) FROM feedbacks WHERE accountID = ? AND target_id = ? AND feedback_type = 'ORDER'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ps.setInt(2, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Get feedback statistics for a product
    public Map<String, Object> getFeedbackStats(int productId) {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = "SELECT " +
                    "COUNT(*) as total_reviews, " +
                    "AVG(CAST(rating AS FLOAT)) as average_rating, " +
                    "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as five_star, " +
                    "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as four_star, " +
                    "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as three_star, " +
                    "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as two_star, " +
                    "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as one_star " +
                    "FROM feedbacks WHERE target_id = ? AND feedback_type = 'PRODUCT'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                stats.put("totalReviews", rs.getInt("total_reviews"));
                stats.put("averageRating", rs.getDouble("average_rating"));
                stats.put("fiveStar", rs.getInt("five_star"));
                stats.put("fourStar", rs.getInt("four_star"));
                stats.put("threeStar", rs.getInt("three_star"));
                stats.put("twoStar", rs.getInt("two_star"));
                stats.put("oneStar", rs.getInt("one_star"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
    
    // Get feedbacks by order ID
    public List<Feedback> getFeedbacksByOrderId(int orderId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, a.username, p.title as product_title FROM feedback f " +
                    "JOIN Account a ON f.account_id = a.id " +
                    "JOIN Product p ON f.product_id = p.id " +
                    "WHERE f.order_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setProductTitle(rs.getString("product_title"));
                feedbacks.add(feedback);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Check if order has been rated by user
    public boolean hasOrderBeenRated(int accountId, int orderId) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE account_id = ? AND order_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, accountId);
            ps.setInt(2, orderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Get recent feedbacks (for admin dashboard)
    public List<Feedback> getRecentFeedbacks(int limit) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT TOP (?) f.*, a.username, p.title as product_title FROM feedback f " +
                    "JOIN Account a ON f.account_id = a.id " +
                    "JOIN Product p ON f.product_id = p.id " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setProductTitle(rs.getString("product_title"));
                feedbacks.add(feedback);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Get all feedbacks with pagination
    public List<Feedback> getAllFeedbacks(int page, int pageSize) {
        List<Feedback> feedbacks = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT f.*, a.username, p.title as product_title FROM feedback f " +
                    "JOIN Account a ON f.account_id = a.id " +
                    "JOIN Product p ON f.product_id = p.id " +
                    "ORDER BY f.created_at DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = mapResultSetToFeedback(rs);
                feedback.setProductTitle(rs.getString("product_title"));
                feedbacks.add(feedback);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Get total feedback count
    public int getTotalFeedbackCount() {
        String sql = "SELECT COUNT(*) FROM feedback";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Helper method to map ResultSet to Feedback object
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setAccountId(rs.getInt("account_id"));
        feedback.setProductId(rs.getInt("product_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComment(rs.getString("comment"));
        
        // Handle nullable order_id
        int orderId = rs.getInt("order_id");
        if (!rs.wasNull()) {
            feedback.setOrderId(orderId);
        }
        
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            feedback.setUpdatedAt(updatedAt);
        }
        
        // Set username if available
        try {
            feedback.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            // Username column might not be available in all queries
        }
        
        return feedback;
    }

    // Delete order feedback for testing
    public boolean deleteOrderFeedback(int accountId, int orderId) {
        String sql = "DELETE FROM feedbacks WHERE accountID = ? AND target_id = ? AND feedback_type = 'ORDER'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ps.setInt(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting order feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Update order feedback
    public boolean updateOrderFeedback(int feedbackId, int accountId, int rating, String comment) {
        String sql = "UPDATE feedbacks SET rating = ?, comment = ? WHERE feedback_id = ? AND accountID = ? AND feedback_type = 'ORDER'";

        System.out.println("=== DEBUG updateOrderFeedback ===");
        System.out.println("FeedbackID: " + feedbackId);
        System.out.println("AccountID: " + accountId);
        System.out.println("Rating: " + rating);
        System.out.println("Comment: " + comment);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, feedbackId);
            ps.setInt(4, accountId);

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating order feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Delete order feedback by ID
    public boolean deleteOrderFeedbackById(int feedbackId, int accountId) {
        String sql = "DELETE FROM feedbacks WHERE feedback_id = ? AND accountID = ? AND feedback_type = 'ORDER'";

        System.out.println("=== DEBUG deleteOrderFeedbackById ===");
        System.out.println("FeedbackID: " + feedbackId);
        System.out.println("AccountID: " + accountId);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ps.setInt(2, accountId);

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting order feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}