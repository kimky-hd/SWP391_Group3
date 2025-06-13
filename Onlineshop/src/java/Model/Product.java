/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
/**
 *
 * @author Admin
 */
public class Product {
    private int productID;
    private String title;
    private String image;
    private double price;
    private int quantity;
    private String description;
    private int categoryID;
    private int colorID;
    private int seasonID;
    private String thanhphan;
    private Date dateImport;
    private Date dateExpire;
    private String status;

    public Product() {
    }
    
    public Product(int productID, String title, String image, double price, int quantity, String description, int categoryID, int colorID, int seasonID, String thanhphan, Date dateImport, Date dateExpire) {
        this.productID = productID;
        this.title = title;
        this.image = image;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.categoryID = categoryID;
        this.colorID = colorID;
        this.seasonID = seasonID;
        this.thanhphan = thanhphan;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
    }

    public Product(int productID, String title, String image, double price, int quantity, String description, int categoryID, int colorID, int seasonID, String thanhphan, Date dateImport, Date dateExpire, String status) {
        this.productID = productID;
        this.title = title;
        this.image = image;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.categoryID = categoryID;
        this.colorID = colorID;
        this.seasonID = seasonID;
        this.thanhphan = thanhphan;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
        this.status = status;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getColorID() {
        return colorID;
    }

    public void setColorID(int colorID) {
        this.colorID = colorID;
    }

    public int getSeasonID() {
        return seasonID;
    }

    public void setSeasonID(int seasonID) {
        this.seasonID = seasonID;
    }

    public String getThanhphan() {
        return thanhphan;
    }

    public void setThanhphan(String thanhphan) {
        this.thanhphan = thanhphan;
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
        return "Product{" + "productID=" + productID + ", title=" + title + ", image=" + image + ", price=" + price + ", quantity=" + quantity + ", description=" + description + ", categoryID=" + categoryID + ", colorID=" + colorID + ", seasonID=" + seasonID + ", thanhphan=" + thanhphan + ", dateImport=" + dateImport + ", dateExpire=" + dateExpire + ", status=" + status + '}';
    }
    
    

    
    
    
    
}
