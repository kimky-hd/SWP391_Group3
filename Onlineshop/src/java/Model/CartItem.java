package Model;

public class CartItem {
    private Product product;
    private int quantity;
    private double total;
    
    public CartItem() {
    }
    
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        calculateTotal();
    }
    
    // Calculate total based on product price and quantity
    public void calculateTotal() {
        if (product != null) {
            this.total = this.product.getPrice() * this.quantity;
        } else {
            this.total = 0.0;
        }
    }
    
    // Getters and setters
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
        calculateTotal(); // Recalculate when product changes
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateTotal();
    }

    public double getTotal() {
        return total;
    }
    
    // Utility methods
    public double getUnitPrice() {
        return product != null ? product.getPrice() : 0.0;
    }
    
    public String getProductName() {
        return product != null ? product.getTitle(): "";
    }
    
    public int getProductId() {
        return product != null ? product.getProductID() : 0;
    }
    
    @Override
    public String toString() {
        return "CartItem{" + "product=" + product + ", quantity=" + quantity + ", total=" + total + "}";
    }
}