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
public class MaterialReplacement {
    private int replacementID;
    private int productBatchID;
    private int oldMaterialBatchID;
    private int newMaterialBatchID;
    private int materialID;
    private int quantity;
    private Date dateReplaced;
    private String note;

    public MaterialReplacement() {
    }

    public MaterialReplacement(int replacementID, int productBatchID, int oldMaterialBatchID, int newMaterialBatchID, int materialID, int quantity, Date dateReplaced, String note) {
        this.replacementID = replacementID;
        this.productBatchID = productBatchID;
        this.oldMaterialBatchID = oldMaterialBatchID;
        this.newMaterialBatchID = newMaterialBatchID;
        this.materialID = materialID;
        this.quantity = quantity;
        this.dateReplaced = dateReplaced;
        this.note = note;
    }

    public int getReplacementID() {
        return replacementID;
    }

    public void setReplacementID(int replacementID) {
        this.replacementID = replacementID;
    }

    public int getProductBatchID() {
        return productBatchID;
    }

    public void setProductBatchID(int productBatchID) {
        this.productBatchID = productBatchID;
    }

    public int getOldMaterialBatchID() {
        return oldMaterialBatchID;
    }

    public void setOldMaterialBatchID(int oldMaterialBatchID) {
        this.oldMaterialBatchID = oldMaterialBatchID;
    }

    public int getNewMaterialBatchID() {
        return newMaterialBatchID;
    }

    public void setNewMaterialBatchID(int newMaterialBatchID) {
        this.newMaterialBatchID = newMaterialBatchID;
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

    public Date getDateReplaced() {
        return dateReplaced;
    }

    public void setDateReplaced(Date dateReplaced) {
        this.dateReplaced = dateReplaced;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    
}
