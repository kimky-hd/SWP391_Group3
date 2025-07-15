package Model;

import java.math.BigDecimal;
import java.util.Date;

public class Staff {
    private int staffID;
    private String username;
    private String email;
    private String phone;
    private boolean isActive;
    private Date startMonth;
    private Date endMonth;
    private BigDecimal salary;
    
    // Constructor mặc định
    public Staff() {}
    
    // Constructor đầy đủ
    public Staff(int staffID, String username, String email, String phone, 
                boolean isActive, Date startMonth, Date endMonth, BigDecimal salary) {
        this.staffID = staffID;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.isActive = isActive;
        this.startMonth = startMonth;
        this.endMonth = endMonth;
        this.salary = salary;
    }
    
    // Constructor cho Account thông thường
    public Staff(int staffID, String username, String email, String phone, boolean isActive) {
        this.staffID = staffID;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.isActive = isActive;
    }

    // Getters và Setters
    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Date getStartMonth() {
        return startMonth;
    }

    public void setStartMonth(Date startMonth) {
        this.startMonth = startMonth;
    }

    public Date getEndMonth() {
        return endMonth;
    }

    public void setEndMonth(Date endMonth) {
        this.endMonth = endMonth;
    }

    public BigDecimal getSalary() {
        return salary;
    }

    public void setSalary(BigDecimal salary) {
        this.salary = salary;
    }

    // Phương thức kiểm tra trạng thái làm việc dựa trên hợp đồng
    public String getWorkStatus() {
        Date currentDate = new Date();
        
        // Nếu tài khoản bị vô hiệu hóa
        if (!isActive) {
            return "Tài khoản bị khóa";
        }
        
        // Nếu chưa có thông tin hợp đồng
        if (startMonth == null) {
            return "Chưa có hợp đồng";
        }
        
        // Nếu chưa đến ngày bắt đầu
        if (currentDate.before(startMonth)) {
            return "Chưa bắt đầu";
        }
        
        // Nếu có ngày kết thúc và đã quá hạn
        if (endMonth != null && currentDate.after(endMonth)) {
            return "Nghỉ việc";
        }
        
        // Nếu đang trong thời gian hợp đồng
        return "Đang làm việc";
    }
    
    // Phương thức kiểm tra có đang làm việc không
    public boolean isCurrentlyWorking() {
        return "Đang làm việc".equals(getWorkStatus());
    }
    
    // Phương thức lấy CSS class cho trạng thái
    public String getStatusClass() {
        String status = getWorkStatus();
        switch (status) {
            case "Đang làm việc":
                return "bg-success";
            case "Nghỉ việc":
                return "bg-danger";
            case "Chưa bắt đầu":
                return "bg-warning";
            case "Tài khoản bị khóa":
                return "bg-secondary";
            default:
                return "bg-light text-dark";
        }
    }

    @Override
    public String toString() {
        return "Staff{" +
                "staffID=" + staffID +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", isActive=" + isActive +
                ", startMonth=" + startMonth +
                ", endMonth=" + endMonth +
                ", salary=" + salary +
                '}';
    }
}
