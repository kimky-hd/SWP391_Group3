package Model;

import java.util.Date;

public class Voucher {
    private int voucherId;
    private int accountID;
    private String code;
    private double discountAmount;
    private Date expiryDate;
    private boolean isUsed;
    
    // Constructor
    public Voucher() {}
    
    // Getters and Setters
    public int getVoucherId() {
        return voucherId;
    }
    
    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }
    
    public int getAccountID() {
        return accountID;
    }
    
    public void setAccountID(int accountID) {
        this.accountID = accountID;
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
    
    public Date getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public boolean isIsUsed() {
        return isUsed;
    }
    
    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }
}