package Model;

public class CardTemplate {
    private int cardId;
    private String cardName;
    private String description;
    private double price;
    private String image; // New field for card image
    private boolean isActive;

    public CardTemplate() {
    }

    public CardTemplate(int cardId, String cardName, String description, double price, String image, boolean isActive) {
        this.cardId = cardId;
        this.cardName = cardName;
        this.description = description;
        this.price = price;
        this.image = image;
        this.isActive = isActive;
    }

    public int getCardId() {
        return cardId;
    }

    public void setCardId(int cardId) {
        this.cardId = cardId;
    }

    public String getCardName() {
        return cardName;
    }

    public void setCardName(String cardName) {
        this.cardName = cardName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "CardTemplate{" + "cardId=" + cardId + ", cardName=" + cardName + ", description=" + description + ", price=" + price + ", image=" + image + ", isActive=" + isActive + '}';
    }
}
