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
        this.calculateTotal();
    }
    
    private void calculateTotal() {
        this.total = this.product.getPrice() * this.quantity;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
        calculateTotal();
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
    
    @Override
    public String toString() {
        return "CartItem{" + "product=" + product + ", quantity=" + quantity + ", total=" + total + "}";
    }
}