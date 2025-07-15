package Model;

import java.sql.Date;

public class Shipper {
    private int shipperID;
    private String username;
    private String email;
    private String phone;
    private Date startDate;
    private Date endDate;
    private double baseSalary;
    private int ordersDelivered;
    private double bonusPerOrder;
    private boolean isActive;

    // Constructor đầy đủ
    public Shipper(int shipperID, String username, String email, String phone, Date startDate, Date endDate, 
                  double baseSalary, int ordersDelivered, double bonusPerOrder, boolean isActive) {
        this.shipperID = shipperID;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.startDate = startDate;
        this.endDate = endDate;
        this.baseSalary = baseSalary;
        this.ordersDelivered = ordersDelivered;
        this.bonusPerOrder = bonusPerOrder;
        this.isActive = isActive;
    }
    
    // Constructor không có endDate (cho shipper đang làm việc)
    public Shipper(int shipperID, String username, String email, String phone, Date startDate, 
                  double baseSalary, int ordersDelivered, double bonusPerOrder, boolean isActive) {
        this.shipperID = shipperID;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.startDate = startDate;
        this.baseSalary = baseSalary;
        this.ordersDelivered = ordersDelivered;
        this.bonusPerOrder = bonusPerOrder;
        this.isActive = isActive;
    }
    
    // Constructor rỗng
    public Shipper() {
    }

    // Getters và Setters
    public int getShipperID() {
        return shipperID;
    }

    public void setShipperID(int shipperID) {
        this.shipperID = shipperID;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public double getBaseSalary() {
        return baseSalary;
    }

    public void setBaseSalary(double baseSalary) {
        this.baseSalary = baseSalary;
    }

    public int getOrdersDelivered() {
        return ordersDelivered;
    }

    public void setOrdersDelivered(int ordersDelivered) {
        this.ordersDelivered = ordersDelivered;
    }

    public double getBonusPerOrder() {
        return bonusPerOrder;
    }

    public void setBonusPerOrder(double bonusPerOrder) {
        this.bonusPerOrder = bonusPerOrder;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
    
    // Phương thức tính tổng lương
    public double calculateTotalSalary() {
        return baseSalary + (ordersDelivered * bonusPerOrder);
    }
    
    @Override
    public String toString() {
        return "Shipper{" +
                "shipperID=" + shipperID +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", baseSalary=" + baseSalary +
                ", ordersDelivered=" + ordersDelivered +
                ", bonusPerOrder=" + bonusPerOrder +
                ", isActive=" + isActive +
                '}';
    }
}
