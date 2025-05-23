package Model;

public class Blog {

    private int id;
    private String title;
    private String content;
    private String author;
    private String createdAt;
    // Getter, Setter, Constructor

    public Blog(int id, String title, String content, String author, String createdAt) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.createdAt = createdAt;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getAuthor() {
        return author;
    }

    public int getId() {
        return id;
    }

    public String getCreatedAt() {
        return createdAt;
    }
}
