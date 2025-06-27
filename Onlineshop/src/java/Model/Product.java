/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
public class Product {

    private int productID;
    private String title;
    private String image;
    private double price;
    private String description;
    private int colorID;
    private int seasonID;
    private List<ProductBatch> batches;

    public Product() {
        this.batches = new ArrayList<>();
    }

    public Product(int productID, String title, String image, double price, String description, int colorID, int seasonID, List<ProductBatch> batches) {
        this.productID = productID;
        this.title = title;
        this.image = image;
        this.price = price;
        this.description = description;
        this.colorID = colorID;
        this.seasonID = seasonID;
        this.batches = batches;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public List<ProductBatch> getBatches() {
        return batches;
    }

    public void setBatches(List<ProductBatch> batches) {
        this.batches = batches;
    }

    public int getQuantity() {
        if (batches == null || batches.isEmpty()) {
            return 0;
        }

        Date now = new Date(); // Ngày hiện tại

        return batches.stream()
                .filter(batch -> batch.getDateExpire().after(now)) // Chỉ lấy các lô chưa hết hạn
                .mapToInt(ProductBatch::getQuantity)
                .sum();
    }

    public String getStatus() {
        if (batches == null || batches.isEmpty()) {
            return "Không có lô";
        }

        // Lọc ra các lô chưa hết hạn
        List<ProductBatch> validBatches = batches.stream()
                .filter(batch -> batch.getDateExpire().after(new Date()))
                .toList();

        if (validBatches.isEmpty()) {
            return "Đã Héo";
        }

        // Tìm lô nhập hàng lâu nhất (sớm nhất) trong số các lô chưa hết hạn
        ProductBatch oldestValidBatch = validBatches.stream()
                .min(Comparator.comparing(ProductBatch::getDateImport))
                .orElse(null);

        if (oldestValidBatch == null) {
            return "Không xác định";
        }

        Date today = new Date();
        long day = 24 * 60 * 60 * 1000;
        Date datePlus3 = new Date(oldestValidBatch.getDateImport().getTime() + 3 * day);

        if (today.compareTo(datePlus3) <= 0) {
            return "Tươi mới";
        } else {
            return "Lão hóa";
        }
    }

    @Override
    public String toString() {
        return "Product{" + "productID=" + productID + ", title=" + title + ", image=" + image + ", price=" + price + ", description=" + description + ", colorID=" + colorID + ", seasonID=" + seasonID + ", batches=" + batches + '}';
    }

}
