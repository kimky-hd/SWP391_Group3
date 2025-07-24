/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Date;

/**
 *
 * @author Duccon
 */
public class ProductBatch {

    private int productBatchID;
    private Product product;
    private int productID;
    private int quantity;
    private double importPrice;
    private Date dateImport;
    private Date dateExpire;

    public ProductBatch() {
    }
    
    public ProductBatch(int productID, int quantity, double price, Date dateImport, Date dateExpire) {
        this.productID = productID;
        this.quantity = quantity;
        this.importPrice = price;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
    }

    public ProductBatch(int productBatchID, int productID, int quantity, double price, Date dateImport, Date dateExpire) {
        this.productBatchID = productBatchID;
        this.productID = productID;
        this.quantity = quantity;
        this.importPrice = price;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
        //this.status = status;
    }

    public int getProductBatchID() {
        return productBatchID;
    }

    public void setProductBatchID(int productBatchID) {
        this.productBatchID = productBatchID;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(double importPrice) {
        this.importPrice = importPrice;
    }

    public Date getDateImport() {
        return dateImport;
    }

    public void setDateImport(Date dateImport) {
        this.dateImport = dateImport;
    }

    public Date getDateExpire() {
        return dateExpire;
    }

    public void setDateExpire(Date dateExpire) {
        this.dateExpire = dateExpire;
    }
    
    public String getStatus() {
        if (dateExpire == null || dateImport == null) {
            return "Không xác định";
        }

        java.util.Date today = new java.util.Date();

        // Nếu đã hết hạn
        if (dateExpire.before(today)) {
            return "Đã Héo";
        }

        long threeDaysInMillis = 3L * 24 * 60 * 60 * 1000;
        java.util.Date limit = new java.util.Date(dateImport.getTime() + threeDaysInMillis);

        if (today.compareTo(limit) <= 0) {
            return "Tươi mới";
        } else {
            return "Lão hóa";
        }
    }

    

}
