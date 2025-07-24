package Model;

import java.sql.Timestamp;

public class CustomOrderCart {

    private int customCartID;
    private int accountID;
    private String referenceImage;
    private String referenceImage2;
    private String referenceImage3;
    private String referenceImage4;
    private String referenceImage5;
    private String description;
    private int quantity;
    private String status;
    private Timestamp createdAt;
    private int statusID;
    // Thêm các trường thông tin liên hệ
    private String fullName;
    private String phone;
    private String email;
    // Thêm trường nhận xét của manager
    private String managerComment;
    // Thêm trường giá mong muốn
    private double desiredPrice;
    private double shippingFee;
    private String address;
    private String district;
    private String city;

    // Constructors
    public CustomOrderCart() {
    }

    public CustomOrderCart(int customCartID, int accountID, String referenceImage, String referenceImage2, String referenceImage3, String referenceImage4, String referenceImage5, String description, int quantity, String status, Timestamp createdAt, int statusID, String fullName, String phone, String email, double desiredPrice) {
        this.customCartID = customCartID;
        this.accountID = accountID;
        this.referenceImage = referenceImage;
        this.referenceImage2 = referenceImage2;
        this.referenceImage3 = referenceImage3;
        this.referenceImage4 = referenceImage4;
        this.referenceImage5 = referenceImage5;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
        this.createdAt = createdAt;
        this.statusID = statusID;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.desiredPrice = desiredPrice;
    }

    public CustomOrderCart(int accountID, String referenceImage, String referenceImage2, String referenceImage3, String referenceImage4, String referenceImage5, String description, int quantity, String status, String fullName, String phone, String email, double desiredPrice) {
        this.accountID = accountID;
        this.referenceImage = referenceImage;
        this.referenceImage2 = referenceImage2;
        this.referenceImage3 = referenceImage3;
        this.referenceImage4 = referenceImage4;
        this.referenceImage5 = referenceImage5;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.desiredPrice = desiredPrice;
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

    public String getReferenceImage2() {
        return referenceImage2;
    }

    public void setReferenceImage2(String referenceImage2) {
        this.referenceImage2 = referenceImage2;
    }

    public String getReferenceImage3() {
        return referenceImage3;
    }

    public void setReferenceImage3(String referenceImage3) {
        this.referenceImage3 = referenceImage3;
    }

    public String getReferenceImage4() {
        return referenceImage4;
    }

    public void setReferenceImage4(String referenceImage4) {
        this.referenceImage4 = referenceImage4;
    }

    public String getReferenceImage5() {
        return referenceImage5;
    }

    public void setReferenceImage5(String referenceImage5) {
        this.referenceImage5 = referenceImage5;
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

    // Thêm getters và setters cho các trường mới
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Thêm getter và setter cho trường mới
    public String getManagerComment() {
        return managerComment;
    }

    public void setManagerComment(String managerComment) {
        this.managerComment = managerComment;
    }

    // Thêm getter và setter cho trường giá mong muốn
    public double getDesiredPrice() {
        return desiredPrice;
    }

    public void setDesiredPrice(double desiredPrice) {
        this.desiredPrice = desiredPrice;
    }

    // Thêm getter và setter cho trường phí ship
    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }
// Thêm getter và setter cho trường address

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

// Thêm getter và setter cho trường district
    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

// Thêm getter và setter cho trường city
    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    @Override
    public String toString() {
        return "CustomOrderCart{"
                + "customCartID=" + customCartID
                + ", accountID=" + accountID
                + ", referenceImage='" + referenceImage + '\'' 
                + ", referenceImage2='" + referenceImage2 + '\'' 
                + ", referenceImage3='" + referenceImage3 + '\'' 
                + ", referenceImage4='" + referenceImage4 + '\'' 
                + ", referenceImage5='" + referenceImage5 + '\'' 
                + ", description='" + description + '\'' 
                + ", quantity=" + quantity 
                + ", status='" + status + '\'' 
                + ", createdAt=" + createdAt 
                + ", statusID=" + statusID 
                + ", fullName='" + fullName + '\'' 
                + ", phone='" + phone + '\'' 
                + ", email='" + email + '\'' 
                + ", address='" + address + '\'' 
                + ", district='" + district + '\'' 
                + ", city='" + city + '\'' 
                + ", managerComment='" + managerComment + '\'' 
                + ", desiredPrice=" + desiredPrice
                + ", shippingFee=" + shippingFee
                + '}';
    }
}
