/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Duccon
 */
public class Material {
        private int materialID;
        private String name;
        private String unit;
        private double pricePerUnit;
        private boolean isActive;
        
        private List<MaterialBatch> batches;

    public Material() {
    }

    public Material(int materialID, String name, String unit, double pricePerUnit, boolean isActive, List<MaterialBatch> batches) {
        this.materialID = materialID;
        this.name = name;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
        this.isActive = isActive;
        this.batches = batches;
    }

    

    public int getMaterialID() {
        return materialID;
    }

    public void setMaterialID(int materialID) {
        this.materialID = materialID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }  

    public List<MaterialBatch> getBatches() {
        return batches;
    }

    public void setBatches(List<MaterialBatch> batches) {
        this.batches = batches;
    }
        
    public int getQuantity() {
        if (batches == null || batches.isEmpty()) {
            return 0;
        }
        Date now = new Date();
        return batches.stream()
                .filter(batch -> batch.getDateExpire().after(now))
                .mapToInt(MaterialBatch::getQuantity)
                .sum();
    }
    
public String getStatus() {
        if (batches == null || batches.isEmpty()) {
            return "Không có lô";
        }

        List<MaterialBatch> validBatches = batches.stream()
                .filter(batch -> batch.getDateExpire().after(new Date()))
                .toList();

        if (validBatches.isEmpty()) {
            return "Đã Héo";
        }

        MaterialBatch oldest = validBatches.stream()
                .min(Comparator.comparing(MaterialBatch::getDateImport))
                .orElse(null);

        if (oldest == null) {
            return "Không xác định";
        }

        long day = 24L * 60 * 60 * 1000;
        Date limit = new Date(oldest.getDateImport().getTime() + 3 * day);
        Date today = new Date();

        return today.compareTo(limit) <= 0 ? "Tươi mới" : "Lão hóa";
    }

    @Override
    public String toString() {
        return "Material{" + "materialID=" + materialID + ", name=" + name + ", unit=" + unit + ", pricePerUnit=" + pricePerUnit + ", isActive=" + isActive + ", batches=" + batches + '}';
    }

    




        
}
