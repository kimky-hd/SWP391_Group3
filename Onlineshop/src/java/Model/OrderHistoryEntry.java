package Model;

import java.math.BigDecimal;
import java.util.Date;

public class OrderHistoryEntry {

    private int maHD;
    private String username;
    private String fullName;
    private Date ngayXuat;
    private BigDecimal tongGia;
    private String status;
    private String productTitle;
    private BigDecimal productPrice;
    private int quantity;

    public OrderHistoryEntry(int maHD, String username, String fullName, Date ngayXuat,
            BigDecimal tongGia, String status, String productTitle,
            BigDecimal productPrice, int quantity) {
        this.maHD = maHD;
        this.username = username;
        this.fullName = fullName;
        this.ngayXuat = ngayXuat;
        this.tongGia = tongGia;
        this.status = status;
        this.productTitle = productTitle;
        this.productPrice = productPrice;
        this.quantity = quantity;
    }

    public int getMaHD() {
        return maHD;
    }

    public String getUsername() {
        return username;
    }

    public String getFullName() {
        return fullName;
    }

    public Date getNgayXuat() {
        return ngayXuat;
    }

    public BigDecimal getTongGia() {
        return tongGia;
    }

    public String getStatus() {
        return status;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public BigDecimal getProductPrice() {
        return productPrice;
    }

    public int getQuantity() {
        return quantity;
    }
}
