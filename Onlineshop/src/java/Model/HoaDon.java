package Model;

import java.util.Date;

/**
 * Model class representing HoaDon (Invoice/Order) entity
 */
public class HoaDon {
    private int maHD;
    private int accountID;
    private double tongGia;
    private Date ngayXuat;
    private int statusID;
    private String paymentMethod;
    private String note; // Thêm trường note để lưu lý do hủy
    private Integer shippingID; // ID của shipper được giao đơn hàng
    
    // Additional fields for joined data
    private String username;
    private String email;
    private String phone;
    private String statusName;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String customerAddress;
    
    // Constructors
    public HoaDon() {
    }
    
    public HoaDon(int maHD, int accountID, double tongGia, Date ngayXuat, int statusID, String paymentMethod) {
        this.maHD = maHD;
        this.accountID = accountID;
        this.tongGia = tongGia;
        this.ngayXuat = ngayXuat;
        this.statusID = statusID;
        this.paymentMethod = paymentMethod;
    }
    
    public HoaDon(int maHD, int accountID, double tongGia, Date ngayXuat, int statusID, String paymentMethod, String note) {
        this.maHD = maHD;
        this.accountID = accountID;
        this.tongGia = tongGia;
        this.ngayXuat = ngayXuat;
        this.statusID = statusID;
        this.paymentMethod = paymentMethod;
        this.note = note;
    }
    
    // Getters and Setters
    public int getMaHD() {
        return maHD;
    }
    
    public void setMaHD(int maHD) {
        this.maHD = maHD;
    }
    
    public int getAccountID() {
        return accountID;
    }
    
    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }
    
    public double getTongGia() {
        return tongGia;
    }
    
    public void setTongGia(double tongGia) {
        this.tongGia = tongGia;
    }
    
    public Date getNgayXuat() {
        return ngayXuat;
    }
    
    public void setNgayXuat(Date ngayXuat) {
        this.ngayXuat = ngayXuat;
    }
    
    public int getStatusID() {
        return statusID;
    }
    
    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getStatusName() {
        return statusName;
    }
    
    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getCustomerAddress() {
        return customerAddress;
    }
    
    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }
    
    public String getNote() {
        return note;
    }
    
    public void setNote(String note) {
        this.note = note;
    }
    
    public Integer getShippingID() {
        return shippingID;
    }
    
    public void setShippingID(Integer shippingID) {
        this.shippingID = shippingID;
    }
    
    // Convenience methods for compatibility with test JSPs
    public int getOrderID() {
        return maHD;
    }
    
    public double getTotalAmount() {
        return tongGia;
    }
    
    @Override
    public String toString() {
        return "HoaDon{" +
                "maHD=" + maHD +
                ", accountID=" + accountID +
                ", tongGia=" + tongGia +
                ", ngayXuat=" + ngayXuat +
                ", statusID=" + statusID +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", username='" + username + '\'' +
                ", statusName='" + statusName + '\'' +
                '}';
    }
}
