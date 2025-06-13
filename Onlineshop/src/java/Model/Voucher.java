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
    private boolean isUsed; // Trạng thái sử dụng của voucher với account hiện tại

    // Constructors, getters, setters

    // Getters and Setters
    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }
    
    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }
    
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    public boolean isActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
    
    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }
    
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public boolean isUsed() { return isUsed; }
    public void setIsUsed(boolean isUsed) { this.isUsed = isUsed; }
}