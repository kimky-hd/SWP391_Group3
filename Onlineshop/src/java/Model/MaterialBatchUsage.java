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
public class MaterialBatchUsage {

    private int usageID;
    private int productBatchID;
    private int materialBatchID;
    private int quantityUsed;
    private double importPrice;
    private Date dateImport;
    private Date dateExpire;

    public MaterialBatchUsage() {
    }
    
    public MaterialBatchUsage(int usageID, int materialBatchID, int quantityUsed, double importPrice, Date dateImport, Date dateExpire) {
        this.usageID = usageID;
        this.materialBatchID = materialBatchID;
        this.quantityUsed = quantityUsed;
        this.importPrice = importPrice;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
    }

    public MaterialBatchUsage(MaterialBatch batch, int quantityUsed) {
        this.materialBatchID = batch.getMaterialBatchID();
        this.importPrice = batch.getImportPrice();
        this.dateImport = batch.getDateImport();
        this.dateExpire = batch.getDateExpire();
        this.quantityUsed = quantityUsed;
    }

    public MaterialBatchUsage(int materialBatchID, int quantityUsed, double importPrice) {
        this.materialBatchID = materialBatchID;
        this.quantityUsed = quantityUsed;
        this.importPrice = importPrice;
    }

    public int getUsageID() {
        return usageID;
    }

    public void setUsageID(int usageID) {
        this.usageID = usageID;
    }

    public int getMaterialBatchID() {
        return materialBatchID;
    }

    public void setMaterialBatchID(int materialBatchID) {
        this.materialBatchID = materialBatchID;
    }

    public int getQuantityUsed() {
        return quantityUsed;
    }

    public void setQuantityUsed(int quantityUsed) {
        this.quantityUsed = quantityUsed;
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

    public int getProductBatchID() {
        return productBatchID;
    }

    public void setProductBatchID(int productBatchID) {
        this.productBatchID = productBatchID;
    }
    
}
