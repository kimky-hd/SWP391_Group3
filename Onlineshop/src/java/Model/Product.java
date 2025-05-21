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
    private String color;
    private String season;
    private String unit;
    private Date dateImport;
    private Date dateExpire;

    public Product() {
    }

    public Product(int productID, String title, String image, double price, int quantity, String description, String color, String season, String unit, Date dateImport, Date dateExpire) {
        this.productID = productID;
        this.title = title;
        this.image = image;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.color = color;
        this.season = season;
        this.unit = unit;
        this.dateImport = dateImport;
        this.dateExpire = dateExpire;
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

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSeason() {
        return season;
    }

    public void setSeason(String season) {
        this.season = season;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
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
    

    
    @Override
    public String toString(){
        return "Product{" + "productID=" + productID + "title=" + title + "image=" + image + "price=" + price + "quantity=" + quantity + "description=" + description + "color=" + color + "season=" + season + "unit=" + unit + "dateImport=" + dateImport + "dateExpire=" + dateExpire +"}";
    }
}
