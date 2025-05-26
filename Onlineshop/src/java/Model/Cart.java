package Model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items;
    private double total;

    public Cart() {
        items = new HashMap<>();
        total = 0;
    }

    public void addItem(Product product, int quantity) {
        if (product != null && quantity > 0) {
            if (items.containsKey(product.getProductID())) {
                CartItem item = items.get(product.getProductID());
                item.setQuantity(item.getQuantity() + quantity);
            } else {
                CartItem item = new CartItem(product, quantity);
                items.put(product.getProductID(), item);
            }
            calculateTotal();
        }
    }

    public void updateItem(int productId, int quantity) {
        if (items.containsKey(productId)) {
            if (quantity > 0) {
                CartItem item = items.get(productId);
                item.setQuantity(quantity);
            } else {
                removeItem(productId);
            }
            calculateTotal();
        }
    }

    public void removeItem(int productId) {
        items.remove(productId);
        calculateTotal();
    }

    public void clear() {
        items.clear();
        total = 0;
    }

    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }

    public CartItem getItem(int productId) {
        return items.get(productId);
    }

    public int getItemCount() {
        return items.size();
    }

    public double getTotal() {
        return total;
    }

    private void calculateTotal() {
        total = 0;
        for (CartItem item : items.values()) {
            total += item.getTotal();
        }
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public boolean containsProduct(int productId) {
        return items.containsKey(productId);
    }
}