package Model;

import java.util.Date;

public class BlogImg {
    private int blogImgID;
    private int blogID;
    private String image;
    private boolean isMain;
    private Date datePosted;

    // Constructor rỗng
    public BlogImg() {
    }

    // Constructor đầy đủ
    public BlogImg(int blogImgID, int blogID, String image, boolean isMain, Date datePosted) {
        this.blogImgID = blogImgID;
        this.blogID = blogID;
        this.image = image;
        this.isMain = isMain;
        this.datePosted = datePosted;
    }

    // Constructor không có ID (cho việc insert)
    public BlogImg(int blogID, String image, boolean isMain, Date datePosted) {
        this.blogID = blogID;
        this.image = image;
        this.isMain = isMain;
        this.datePosted = datePosted;
    }

    // Getters và Setters
    public int getBlogImgID() {
        return blogImgID;
    }

    public void setBlogImgID(int blogImgID) {
        this.blogImgID = blogImgID;
    }

    public int getBlogID() {
        return blogID;
    }

    public void setBlogID(int blogID) {
        this.blogID = blogID;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isMain() {
        return isMain;
    }
    
    public boolean getMain() {
        return isMain;
    }

    public void setMain(boolean isMain) {
        this.isMain = isMain;
    }

    public Date getDatePosted() {
        return datePosted;
    }

    public void setDatePosted(Date datePosted) {
        this.datePosted = datePosted;
    }
}
