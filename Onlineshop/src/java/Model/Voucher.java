package Model;

import java.util.Date;

public class Voucher {

    private int voucherId;
    private String code;
    private double discountAmount;
    private double minOrderValue;
    private Date startDate;
    private Date endDate;
    private boolean isActive;
    private int usageLimit;
    private int usedCount;
    private String description;
    private Date createdDate;  // Thêm thuộc tính mới
    private boolean isUsed; // Trạng thái sử dụng của voucher với account hiện tại
    private boolean isAdded;

    // Constructors
    public Voucher() {
    }
     public boolean isExpired() {
        return this.endDate.before(new Date());
    }
    
    // Method kiểm tra voucher có hiệu lực không (đã bắt đầu và chưa hết hạn)
    public boolean isValid() {
        Date now = new Date();
        return !now.before(this.startDate) && !now.after(this.endDate) && this.isActive;
    }
    
    // Method lấy trạng thái chi tiết
    public String getDetailedStatus() {
        Date now = new Date();
        if (now.after(this.endDate)) {
            return "Hết hạn";
        } else if (now.before(this.startDate)) {
            return "Chưa hiệu lực";
        } else if (this.isActive) {
            return "Hoạt động";
        } else {
            return "Vô hiệu hóa";
        }
    }
  

public boolean isNotStarted() {
    return this.startDate.after(new Date());
}

    public Voucher(String code, double discountAmount, double minOrderValue, 
                   Date startDate, Date endDate, int usageLimit, String description) {
        this.code = code;
        this.discountAmount = discountAmount;
        this.minOrderValue = minOrderValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.description = description;
        this.isActive = true;
        this.usedCount = 0;
        this.createdDate = new Date(); // Tự động set ngày hiện tại
    }

    // Getters and Setters
    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
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

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Getter và Setter cho createdDate
    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public boolean isAdded() {
        return isAdded;
    }

    public void setIsAdded(boolean isAdded) {
        this.isAdded = isAdded;
    }

    // Utility methods
    @Override
    public String toString() {
        return "Voucher{" +
                "voucherId=" + voucherId +
                ", code='" + code + '\'' +
                ", discountAmount=" + discountAmount +
                ", minOrderValue=" + minOrderValue +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", isActive=" + isActive +
                ", usageLimit=" + usageLimit +
                ", usedCount=" + usedCount +
                ", description='" + description + '\'' +
                ", createdDate=" + createdDate +
                ", isUsed=" + isUsed +
                ", isAdded=" + isAdded +
                '}';
    }
}
