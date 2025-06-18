/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Duccon
 */
public class CategoryProduct {
    private int productID;
    private int categoryID;

    public CategoryProduct() {
    }

    public CategoryProduct(int productID, int categoryID) {
        this.productID = productID;
        this.categoryID = categoryID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    @Override
    public String toString() {
        return "CategoryProduct{" + "productID=" + productID + ", categoryID=" + categoryID + '}';
    }
    
}
