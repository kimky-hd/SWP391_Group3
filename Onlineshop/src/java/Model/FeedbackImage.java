package Model;

import java.sql.Timestamp;

public class FeedbackImage {
    private int imageId;
    private int feedbackId;
    private String imagePath;
    private String imageName;
    private long imageSize;
    private Timestamp uploadDate;
    private boolean isActive;
    
    // Constructors
    public FeedbackImage() {
    }
    
    public FeedbackImage(int feedbackId, String imagePath, String imageName, long imageSize) {
        this.feedbackId = feedbackId;
        this.imagePath = imagePath;
        this.imageName = imageName;
        this.imageSize = imageSize;
        this.isActive = true;
    }
    
    // Getters and Setters
    public int getImageId() {
        return imageId;
    }
    
    public void setImageId(int imageId) {
        this.imageId = imageId;
    }
    
    public int getFeedbackId() {
        return feedbackId;
    }
    
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public String getImageName() {
        return imageName;
    }
    
    public void setImageName(String imageName) {
        this.imageName = imageName;
    }
    
    public long getImageSize() {
        return imageSize;
    }
    
    public void setImageSize(long imageSize) {
        this.imageSize = imageSize;
    }
    
    public Timestamp getUploadDate() {
        return uploadDate;
    }
    
    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    // Utility methods
    public String getFormattedSize() {
        if (imageSize < 1024) {
            return imageSize + " B";
        } else if (imageSize < 1024 * 1024) {
            return String.format("%.1f KB", imageSize / 1024.0);
        } else {
            return String.format("%.1f MB", imageSize / (1024.0 * 1024.0));
        }
    }
    
    public String getFileExtension() {
        if (imageName != null && imageName.contains(".")) {
            return imageName.substring(imageName.lastIndexOf(".")).toLowerCase();
        }
        return "";
    }
    
    public boolean isValidImageExtension() {
        String ext = getFileExtension();
        return ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || 
               ext.equals(".gif") || ext.equals(".webp");
    }
    
    @Override
    public String toString() {
        return "FeedbackImage{" +
                "imageId=" + imageId +
                ", feedbackId=" + feedbackId +
                ", imagePath='" + imagePath + '\'' +
                ", imageName='" + imageName + '\'' +
                ", imageSize=" + imageSize +
                ", uploadDate=" + uploadDate +
                ", isActive=" + isActive +
                '}';
    }
}
