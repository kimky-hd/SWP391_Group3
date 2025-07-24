package Model;

public class ComplaintImage {
    private int imageID;
    private int complaintID;
    private String imagePath;
    
    // Constructors
    public ComplaintImage() {}
    
    public ComplaintImage(int complaintID, String imagePath) {
        this.complaintID = complaintID;
        this.imagePath = imagePath;
    }
    
    public ComplaintImage(int imageID, int complaintID, String imagePath) {
        this.imageID = imageID;
        this.complaintID = complaintID;
        this.imagePath = imagePath;
    }
    
    // Getters và Setters
    public int getImageID() {
        return imageID;
    }
    
    public void setImageID(int imageID) {
        this.imageID = imageID;
    }
    
    public int getComplaintID() {
        return complaintID;
    }
    
    public void setComplaintID(int complaintID) {
        this.complaintID = complaintID;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    @Override
    public String toString() {
        return "ComplaintImage{" +
                "imageID=" + imageID +
                ", complaintID=" + complaintID +
                ", imagePath='" + imagePath + '\'' +
                '}';
    }
}
