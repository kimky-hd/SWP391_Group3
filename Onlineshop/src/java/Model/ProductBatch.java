/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author Duccon
 */
public class ProductBatch {

    private int batchID;
    private int productID;
    private int quantity;
    private double importPrice;
    private Date dateImport;
    private Date dateExpire;
    private String status;

    public ProductBatch() {
    }

    public ProductBatch(int batchID, int productID, int quantity, double price, Date dateImport, Date dateExpire, String status) {
        this.batchID = batchID;
        this.productID = productID;
        this.quantity = quantity;
        this.importPrice = price;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
        this.status = status;
    }

    public int getBatchID() {
        return batchID;
    }

    public void setBatchID(int batchID) {
        this.batchID = batchID;
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
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ProductBatch{" + "batchID=" + batchID + ", productID=" + productID + ", quantity=" + quantity + ", importPrice=" + importPrice + ", dateImport=" + dateImport + ", dateExpire=" + dateExpire + ", status=" + status + '}';
    }

    

}
