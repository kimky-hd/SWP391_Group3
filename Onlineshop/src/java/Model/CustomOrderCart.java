package Model;

import java.sql.Timestamp;

public class CustomOrderCart {
    private int customCartID;
    private int accountID; // Thay thế cartID bằng accountID
    private String referenceImage;
    private String description;
    private int quantity;
    private String status; // Đổi statusID thành status
    private Timestamp createdAt;

    // Constructors
    public CustomOrderCart() {
    }

    public CustomOrderCart(int customCartID, int accountID, String referenceImage, String description, int quantity, String status, Timestamp createdAt) {
        this.customCartID = customCartID;
        this.accountID = accountID;
        this.referenceImage = referenceImage;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
        this.createdAt = createdAt;
    }

    public CustomOrderCart(int accountID, String referenceImage, String description, int quantity, String status) {
        this.accountID = accountID;
        this.referenceImage = referenceImage;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
    }

    // Getters and Setters
    public int getCustomCartID() {
        return customCartID;
    }

    public void setCustomCartID(int customCartID) {
        this.customCartID = customCartID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getReferenceImage() {
        return referenceImage;
    }

    public void setReferenceImage(String referenceImage) {
        this.referenceImage = referenceImage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CustomOrderCart{" +
                "customCartID=" + customCartID +
                ", accountID=" + accountID +
                ", referenceImage='" + referenceImage + '\'' +
                ", description='" + description + '\'' +
                ", quantity=" + quantity +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
