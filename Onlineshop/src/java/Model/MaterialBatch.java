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
    private int quantity;
    private double importPrice;
    private Date dateImport;
    private Date dateExpire;
    private String status;

    public MaterialBatch() {
    }
    
    public MaterialBatch(int id, String materialId, int quantity) {
    this.materialBatchID = materialBatchID;
    this.materialID = materialID;
    this.quantity = quantity;
}

    public MaterialBatch(int materialBatchID, int materialID, int quantity, double importPrice, Date dateImport, Date dateExpire, String status) {
        this.materialBatchID = materialBatchID;
        this.materialID = materialID;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
        this.status = status;
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
        return "MaterialBatch{" + "materialBatchID=" + materialBatchID + ", materialID=" + materialID + ", quantity=" + quantity + ", importPrice=" + importPrice + ", dateImport=" + dateImport + ", dateExpire=" + dateExpire + ", status=" + status + '}';
    }
    
    
}
