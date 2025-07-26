package Model;

import java.sql.Timestamp;
import java.util.Date;

public class Feedback {
    private int feedbackId;
    private int accountId;
    private int productId;
    private int rating;
    private String comment;
    private Integer orderId; // Nullable - for order-based feedback
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display purposes
    private String username;
    private String email;
    private String productTitle;
    private String productImage;
    private Double productPrice;
    private int imageCount;

    // Staff management fields
    private boolean isActive = true; // For hide/show functionality
    private String replyText; // Staff reply to feedback
    private String status; // VISIBLE, HIDDEN, etc.
    
    // Default constructor
    public Feedback() {
    }
    
    // Constructor with essential fields
    public Feedback(int accountId, int productId, int rating, String comment) {
        this.accountId = accountId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
    }
    
    // Constructor with order ID
    public Feedback(int accountId, int productId, int rating, String comment, Integer orderId) {
        this.accountId = accountId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
        this.orderId = orderId;
    }
    
    // Getters and Setters
    public int getFeedbackId() {
        return feedbackId;
    }
    
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }
    
    public int getAccountId() {
        return accountId;
    }
    
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public Integer getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getProductTitle() {
        return productTitle;
    }
    
    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }
    
    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public Double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(Double productPrice) {
        this.productPrice = productPrice;
    }

    public int getImageCount() {
        return imageCount;
    }

    public void setImageCount(int imageCount) {
        this.imageCount = imageCount;
    }

    // Getters and setters for staff management fields
    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getReplyText() {
        return replyText;
    }

    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    // Utility methods
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(createdAt);
        }
        return "";
    }
    
    public String getFormattedUpdatedAt() {
        if (updatedAt != null) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(updatedAt);
        }
        return "";
    }
    
    public String getRatingStars() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public boolean isEditable() {
        // Allow editing within 24 hours of creation
        if (createdAt != null) {
            long timeDiff = System.currentTimeMillis() - createdAt.getTime();
            return timeDiff < (24 * 60 * 60 * 1000); // 24 hours in milliseconds
        }
        return false;
    }
    
    public boolean hasComment() {
        return comment != null && !comment.trim().isEmpty();
    }
    
    public String getShortComment(int maxLength) {
        if (comment == null || comment.trim().isEmpty()) {
            return "";
        }
        
        String trimmedComment = comment.trim();
        if (trimmedComment.length() <= maxLength) {
            return trimmedComment;
        }
        
        return trimmedComment.substring(0, maxLength) + "...";
    }
    
    // Validation methods
    public boolean isValid() {
        return accountId > 0 && productId > 0 && rating >= 1 && rating <= 5;
    }
    
    public String getValidationError() {
        if (accountId <= 0) {
            return "Account ID is required";
        }
        if (productId <= 0) {
            return "Product ID is required";
        }
        if (rating < 1 || rating > 5) {
            return "Rating must be between 1 and 5";
        }
        return null;
    }
    
    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackId=" + feedbackId +
                ", accountId=" + accountId +
                ", productId=" + productId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", orderId=" + orderId +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", username='" + username + '\'' +
                ", productTitle='" + productTitle + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Feedback feedback = (Feedback) obj;
        return feedbackId == feedback.feedbackId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(feedbackId);
    }
}