package Model;

import java.util.Date;

public class Order {
    // Thêm các trường mới phù hợp với cấu trúc bảng HoaDon
    private int maHD; // thay cho orderId
    private int statusID; // thay cho status (String)
    private Date ngayXuat; // thay cho orderDate
    private double tongGia; // thay cho total

    // Cập nhật các getter và setter tương ứng
    private int orderId;
    private int accountId;
    private Date orderDate;
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String paymentMethod;
    private double total;
    private String status;
    private Integer cardId; // Use Integer for nullable int
    private Double cardFee; // Use Double for nullable double
    
    // Shipper information
    private Integer shippingID;
    private String shipperName;
    private String shipperEmail;
    private String shipperPhone;

    public Order() {
    }

    public Order(int orderId, int accountId, Date orderDate, String fullName, String phone, String email, 
            String address, String paymentMethod, double total, String status, Integer cardId, Double cardFee) {
        this.orderId = orderId;
        this.accountId = accountId;
        this.orderDate = orderDate;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.paymentMethod = paymentMethod;
        this.total = total;
        this.status = status;
        this.cardId = cardId;
        this.cardFee = cardFee;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getStatusId() {
    return this.statusID;
}

public void setStatusId(int statusID) {
    this.statusID = statusID;
}

    public Integer getCardId() {
        return cardId;
    }

    public void setCardId(Integer cardId) {
        this.cardId = cardId;
    }

    public Double getCardFee() {
        return cardFee;
    }

    public void setCardFee(Double cardFee) {
        this.cardFee = cardFee;
    }
    
    // Shipper getter and setter methods
    public Integer getShippingID() {
        return shippingID;
    }
    
    public void setShippingID(Integer shippingID) {
        this.shippingID = shippingID;
    }
    
    public String getShipperName() {
        return shipperName;
    }
    
    public void setShipperName(String shipperName) {
        this.shipperName = shipperName;
    }
    
    public String getShipperEmail() {
        return shipperEmail;
    }
    
    public void setShipperEmail(String shipperEmail) {
        this.shipperEmail = shipperEmail;
    }
    
    public String getShipperPhone() {
        return shipperPhone;
    }
    
    public void setShipperPhone(String shipperPhone) {
        this.shipperPhone = shipperPhone;
    }
}
