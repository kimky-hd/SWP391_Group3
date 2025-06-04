package Model;

public class Blog {
    private int blogID;
    private int accountID;
    private String title;
    private String content;
    private String image;
    private String datePosted;

    public Blog(int blogID, int accountID, String title, String content, String image, String datePosted) {
        this.blogID = blogID;
        this.accountID = accountID;
        this.title = title;
        this.content = content;
        this.image = image;
        this.datePosted = datePosted;
    }

    public int getBlogID() { return blogID; }
    public int getAccountID() { return accountID; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public String getImage() { return image; }
    public String getDatePosted() { return datePosted; }
}