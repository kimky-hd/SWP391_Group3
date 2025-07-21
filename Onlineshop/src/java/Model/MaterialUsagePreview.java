/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Duccon
 */
public class MaterialUsagePreview {
    private int materialBatchID;
    private int quantityUsed;
    private double importPrice;

    public MaterialUsagePreview() {
    }

    public MaterialUsagePreview(int materialBatchID, int quantityUsed, double importPrice) {
        this.materialBatchID = materialBatchID;
        this.quantityUsed = quantityUsed;
        this.importPrice = importPrice;
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
    
    
}
