package Model;

import java.sql.Timestamp;

public class CustomOrderCart {

    private int customCartID;
    private int accountID;
    private String referenceImage;
    private String description;
    private int quantity;
    private String status;
    private Timestamp createdAt;
    private int statusID;

    // Constructors
    public CustomOrderCart() {
    }

    public CustomOrderCart(int customCartID, int accountID, String referenceImage, String description, int quantity, String status, Timestamp createdAt, int statusID) {
        this.customCartID = customCartID;
        this.accountID = accountID;
        this.referenceImage = referenceImage;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
        this.createdAt = createdAt;
        this.statusID = statusID;
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

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    @Override
    public String toString() {
        return "CustomOrderCart{"
                + "customCartID=" + customCartID
                + ", accountID=" + accountID
                + ", referenceImage='" + referenceImage + '\''
                + ", description='" + description + '\''
                + ", quantity=" + quantity
                + ", status='" + status + '\''
                + ", createdAt=" + createdAt
                + ", statusID=" + statusID
                + '}';
    }
}
