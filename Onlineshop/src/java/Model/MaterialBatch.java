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
public class MaterialBatch {

    private int materialBatchID;
    private int materialID;
    private String materialName;
    private int quantity;
    private double importPrice;
    private Date dateImport;
    private Date dateExpire;
    private int supplierID;
    private String supplierName;

    public MaterialBatch() {
    }

    public MaterialBatch(int id, String materialId, int quantity) {
        this.materialBatchID = materialBatchID;
        this.materialID = materialID;
        this.quantity = quantity;
    }
    
    public MaterialBatch(int materialBatchID, int materialID, int quantity, double importPrice, Date dateImport, Date dateExpire) {
        this.materialBatchID = materialBatchID;
        this.materialID = materialID;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
    }

    public MaterialBatch(int materialBatchID, int materialID, String materialName, int quantity, double importPrice, Date dateImport, Date dateExpire, int supplierID, String supplierName) {
        this.materialBatchID = materialBatchID;
        this.materialID = materialID;
        this.materialName = materialName;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
        this.supplierID = supplierID;
        this.supplierName = supplierName;
    }

    public int getMaterialBatchID() {
        return materialBatchID;
    }

    public void setMaterialBatchID(int materialBatchID) {
        this.materialBatchID = materialBatchID;
    }

    public int getMaterialID() {
        return materialID;
    }

    public void setMaterialID(int materialID) {
        this.materialID = materialID;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
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

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    @Override
    public String toString() {
        return "MaterialBatch{" + "materialBatchID=" + materialBatchID + ", materialID=" + materialID + ", materialName=" + materialName + ", quantity=" + quantity + ", importPrice=" + importPrice + ", dateImport=" + dateImport + ", dateExpire=" + dateExpire + ", supplierID=" + supplierID + ", supplierName=" + supplierName + '}';
    }
    
}
