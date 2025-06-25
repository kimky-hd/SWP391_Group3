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

    public Order() {
    }

    public Order(int orderId, int accountId, Date orderDate, String fullName, String phone, String email, 
            String address, String paymentMethod, double total, String status) {
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
}