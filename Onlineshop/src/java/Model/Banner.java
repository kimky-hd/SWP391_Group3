package Model;

public class Banner {
    private int bannerID;
    private String title;
    private String image;
    private String description;
    private String link;
    private boolean isActive;
    private int displayOrder;

    public Banner(int bannerID, String title, String image, String description, String link, boolean isActive, int displayOrder) {
        this.bannerID = bannerID;
        this.title = title;
        this.image = image;
        this.description = description;
        this.link = link;
        this.isActive = isActive;
        this.displayOrder = displayOrder;
    }

    public int getBannerID() { return bannerID; }
    public void setBannerID(int bannerID) { this.bannerID = bannerID; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
