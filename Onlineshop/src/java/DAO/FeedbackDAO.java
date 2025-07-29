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

                // Process comment to separate original comment and staff reply
                String fullComment = rs.getString("comment");
                String originalComment = getOriginalComment(fullComment);
                String staffReply = getStaffReply(fullComment);

                // Debug logging
                System.out.println("DEBUG ProductDetail - Feedback ID: " + rs.getInt("feedback_id"));
                System.out.println("DEBUG ProductDetail - Full comment: " + fullComment);
                System.out.println("DEBUG ProductDetail - Staff reply: " + staffReply);

                feedback.setComment(originalComment); // Set only original comment
                feedback.setReplyText(staffReply); // Set staff reply separately
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

    // Update product feedback using feedbacks table
    public boolean updateProductFeedback(int feedbackId, int accountId, int rating, String comment) {
        String sql = "UPDATE feedbacks SET rating = ?, comment = ? WHERE feedback_id = ? AND accountID = ? AND feedback_type = 'PRODUCT'";

        System.out.println("=== DEBUG updateProductFeedback ===");
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
            System.err.println("Error updating product feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Delete product feedback by ID using feedbacks table
    public boolean deleteProductFeedbackById(int feedbackId, int accountId) {
        String sql = "DELETE FROM feedbacks WHERE feedback_id = ? AND accountID = ? AND feedback_type = 'PRODUCT'";

        System.out.println("=== DEBUG deleteProductFeedbackById ===");
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
            System.err.println("Error deleting product feedback: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Get product feedback by ID from feedbacks table
    public Feedback getProductFeedbackById(int feedbackId) {
        String sql = "SELECT f.feedback_id, f.accountID, f.target_id as productId, f.rating, f.comment, " +
                    "f.created_date, a.username " +
                    "FROM feedbacks f " +
                    "JOIN Account a ON f.accountID = a.accountID " +
                    "WHERE f.feedback_id = ? AND f.feedback_type = 'PRODUCT'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setAccountId(rs.getInt("accountID"));
                feedback.setProductId(rs.getInt("productId"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));
                feedback.setCreatedAt(rs.getTimestamp("created_date"));
                feedback.setUsername(rs.getString("username"));
                return feedback;
            }

        } catch (SQLException e) {
            System.err.println("Error getting product feedback by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Get all product feedbacks for staff management
    public List<Feedback> getAllProductFeedbacksForStaff() {
        List<Feedback> feedbacks = new ArrayList<>();

        // Query with JOINs to get user and product info
        String sql1 = "SELECT f.feedback_id, f.accountID, f.target_id, f.rating, f.comment, " +
                     "f.created_date, f.is_active, " +
                     "a.username, a.email, " +
                     "COALESCE(p.title, 'Sản phẩm đã bị xóa') as productTitle, " +
                     "COALESCE(p.price, 0) as price, " +
                     "COALESCE(p.image, 'default.jpg') as productImage " +
                     "FROM feedbacks f " +
                     "JOIN Account a ON f.accountID = a.accountID " +
                     "LEFT JOIN Product p ON f.target_id = p.productID " +
                     "WHERE f.feedback_type = 'PRODUCT' " +
                     "ORDER BY f.created_date DESC";

        // System.out.println("=== DEBUG getAllProductFeedbacksForStaff ===");
        // System.out.println("SQL: " + sql1);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql1)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                try {
                    Feedback feedback = new Feedback();
                    feedback.setFeedbackId(rs.getInt("feedback_id"));
                    feedback.setAccountId(rs.getInt("accountID"));
                    feedback.setProductId(rs.getInt("target_id"));
                    feedback.setRating(rs.getInt("rating"));

                    // Process comment to separate original comment and staff reply
                    String fullComment = rs.getString("comment");
                    String originalComment = getOriginalComment(fullComment);
                    String staffReply = getStaffReply(fullComment);

                    // Debug logging
                    System.out.println("DEBUG - Feedback ID: " + rs.getInt("feedback_id"));
                    System.out.println("DEBUG - Full comment: " + fullComment);
                    System.out.println("DEBUG - Staff reply: " + staffReply);

                    feedback.setComment(originalComment); // Set only original comment
                    feedback.setReplyText(staffReply); // Set staff reply separately
                    feedback.setCreatedAt(rs.getTimestamp("created_date"));

                    // Set user info from JOIN
                    feedback.setUsername(rs.getString("username"));
                    feedback.setEmail(rs.getString("email"));

                    // Set product info from JOIN
                    feedback.setProductTitle(rs.getString("productTitle"));
                    feedback.setProductPrice(rs.getDouble("price"));
                    feedback.setProductImage(rs.getString("productImage"));

                    // Set random image count for demo (0-5 images)
                    // TODO: Replace with actual count from feedback_images table
                    feedback.setImageCount((int)(Math.random() * 6));

                    // Set status based on is_active
                    boolean isActive = rs.getBoolean("is_active");
                    feedback.setActive(isActive);
                    feedback.setStatus(isActive ? "VISIBLE" : "HIDDEN");

                    feedbacks.add(feedback);

                    // System.out.println("Found feedback: ID=" + feedback.getFeedbackId() +
                    //                  ", Customer=" + feedback.getUsername() +
                    //                  ", Product=" + feedback.getProductTitle() +
                    //                  ", Rating=" + feedback.getRating());
                } catch (SQLException e) {
                    System.err.println("Error processing feedback row: " + e.getMessage());
                    e.printStackTrace();
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting feedbacks from 'feedbacks' table: " + e.getMessage());

            // If feedbacks table fails, try the old feedback table
            String sql2 = "SELECT f.feedback_id, f.account_id as accountID, f.product_id as productId, f.rating, f.comment, " +
                         "f.created_at as created_date, " +
                         "a.username, a.email, " +
                         "p.title as productTitle, p.price, p.img " +
                         "FROM feedback f " +
                         "JOIN Account a ON f.account_id = a.accountID " +
                         "JOIN Product p ON f.product_id = p.productID " +
                         "ORDER BY f.created_at DESC";

            try (Connection conn2 = getConnection();
                 PreparedStatement ps2 = conn2.prepareStatement(sql2)) {

                ResultSet rs2 = ps2.executeQuery();

                while (rs2.next()) {
                    Feedback feedback = new Feedback();
                    feedback.setFeedbackId(rs2.getInt("feedback_id"));
                    feedback.setAccountId(rs2.getInt("accountID"));
                    feedback.setProductId(rs2.getInt("productId"));
                    feedback.setRating(rs2.getInt("rating"));
                    feedback.setComment(rs2.getString("comment"));
                    feedback.setCreatedAt(rs2.getTimestamp("created_date"));

                    // Additional info for staff view
                    feedback.setUsername(rs2.getString("username"));
                    feedback.setProductTitle(rs2.getString("productTitle"));
                    feedback.setProductImage(rs2.getString("img"));

                    feedbacks.add(feedback);
                }

            } catch (SQLException e2) {
                System.err.println("Error getting feedbacks from 'feedback' table: " + e2.getMessage());
                e2.printStackTrace();
            }
        }

        // System.out.println("Found " + feedbacks.size() + " feedbacks for staff management");
        return feedbacks;
    }

    // Update review visibility (hide/show)
    public boolean updateReviewVisibility(int feedbackId, boolean isVisible) {
        String sql = "UPDATE feedbacks SET is_active = ? WHERE feedback_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isVisible);
            ps.setInt(2, feedbackId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating review visibility: " + e.getMessage());
            return false;
        }
    }



    // Check if review is visible
    public boolean isReviewVisible(int feedbackId) {
        String sql = "SELECT is_active FROM feedbacks WHERE feedback_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBoolean("is_active");
            }

        } catch (SQLException e) {
            System.err.println("Error checking review visibility: " + e.getMessage());
        }

        return true; // Default to visible if error
    }

    // Add staff reply to feedback by appending to comment field
    public boolean addStaffReplyToFeedback(int feedbackId, int staffAccountId, String replyText) {
        // First get current comment
        String currentComment = getCurrentFeedbackComment(feedbackId);
        if (currentComment == null) {
            return false;
        }

        // Create reply format with clear separation
        String staffReply = "\n\n=== PHẢN HỒI TỪ SHOP ===\n" + replyText.trim() + "\n=== HẾT PHẢN HỒI ===";
        String updatedComment = currentComment + staffReply;

        // Update the comment field
        String sql = "UPDATE feedbacks SET comment = ? WHERE feedback_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, updatedComment);
            ps.setInt(2, feedbackId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding staff reply to feedback: " + e.getMessage());
            return false;
        }
    }

    // Get current comment of a feedback
    private String getCurrentFeedbackComment(int feedbackId) {
        String sql = "SELECT comment FROM feedbacks WHERE feedback_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("comment");
            }

        } catch (SQLException e) {
            System.err.println("Error getting current feedback comment: " + e.getMessage());
        }

        return null;
    }

    // Check if feedback has staff reply
    public boolean hasStaffReply(String comment) {
        return comment != null && comment.contains("=== PHẢN HỒI TỪ SHOP ===");
    }

    // Extract original comment (without staff reply)
    public String getOriginalComment(String comment) {
        if (comment == null) return "";

        int replyIndex = comment.indexOf("\n\n=== PHẢN HỒI TỪ SHOP ===");
        if (replyIndex > 0) {
            return comment.substring(0, replyIndex);
        }

        return comment;
    }

    // Extract staff reply from comment
    public String getStaffReply(String comment) {
        if (comment == null) return null;

        int startIndex = comment.indexOf("\n\n=== PHẢN HỒI TỪ SHOP ===\n");
        if (startIndex >= 0) {
            int contentStart = startIndex + "\n\n=== PHẢN HỒI TỪ SHOP ===\n".length();
            int endIndex = comment.indexOf("\n=== HẾT PHẢN HỒI ===", contentStart);

            if (endIndex > contentStart) {
                return comment.substring(contentStart, endIndex);
            } else {
                // Fallback if no end marker
                return comment.substring(contentStart);
            }
        }

        return null;
    }
}