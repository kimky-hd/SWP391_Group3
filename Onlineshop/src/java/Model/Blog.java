package Model;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public class Blog {

    private int blogID;
    private int accountID;
    private String title;
    private String content;
    private String note;
    private String blogStatus;
    private Date dateCreated;
    private List<BlogImg> blogImages;
    private String mainImage;

    // Constructor rỗng để set bằng setter
    public Blog() {
    }

    public Blog(int blogID, int accountID, String title, Date dateCreated) {
        this.blogID = blogID;
        this.accountID = accountID;
        this.title = title;
        this.dateCreated = dateCreated;
    }
    
    public Blog(int blogID, int accountID, String title, String content, Date dateCreated) {
        this.blogID = blogID;
        this.accountID = accountID;
        this.title = title;
        this.content = content;
        this.dateCreated = dateCreated;
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

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }
    
    public List<BlogImg> getBlogImages() {
        return blogImages;
    }

    public void setBlogImages(List<BlogImg> blogImages) {
        this.blogImages = blogImages;
    }
    
    public String getBlogStatus() {
        return blogStatus;
    }

    public void setBlogStatus(String blogStatus) {
        this.blogStatus = blogStatus;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
