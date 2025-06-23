/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Duccon
 */
public class ProductComponent {
    private int productComponentID;
    private int productID;
    private int materialID;
    private int materialQuantity;
    private Material material;

    public ProductComponent() {
    }

    public ProductComponent(int productComponentID, int productID, int materialID, int materialQuantity, Material material) {
        this.productComponentID = productComponentID;
        this.productID = productID;
        this.materialID = materialID;
        this.materialQuantity = materialQuantity;
        this.material = material;
    }

    public int getProductComponentID() {
        return productComponentID;
    }

    public void setProductComponentID(int productComponentID) {
        this.productComponentID = productComponentID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getMaterialID() {
        return materialID;
    }

    public void setMaterialID(int materialID) {
        this.materialID = materialID;
    }

    public int getMaterialQuantity() {
        return materialQuantity;
    }

    public void setMaterialQuantity(int materialQuantity) {
        this.materialQuantity = materialQuantity;
    }

    public Material getMaterial() {
        return material;
    }

    public void setMaterial(Material material) {
        this.material = material;
    }
    
    
}
