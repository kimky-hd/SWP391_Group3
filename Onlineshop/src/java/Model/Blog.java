package Model;

import java.time.LocalDateTime;

public class Blog {

    private int blogID;
    private int accountID;
    private String title;
    private String content;
    private String image;
    private String datePosted;

    // Constructor rỗng để set bằng setter
    public Blog() {
    }

    public Blog(int blogID, int accountID, String title, String content, String image, String datePosted) {
        this.blogID = blogID;
        this.accountID = accountID;
        this.title = title;
        this.content = content;
        this.image = image;
        this.datePosted = datePosted;
    }

    // Getter + Setter
    public int getBlogID() {
        return blogID;
    }

    public void setBlogID(int blogID) {
        this.blogID = blogID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDatePosted() {
        return datePosted;
    }

    public void setDatePosted(String datePosted) {
        this.datePosted = datePosted;
    }
}
