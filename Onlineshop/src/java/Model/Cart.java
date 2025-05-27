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

    public void addItem(CartItem item) {
        if (item == null || item.getProduct() == null) {
            return;
        }
        
        int productId = item.getProduct().getProductID();
        if (items.containsKey(productId)) {
            CartItem existingItem = items.get(productId);
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            items.put(productId, item);
        }
        calculateTotal();
    }

    public void updateItem(int productId, int quantity) {
        if (quantity <= 0) {
            removeItem(productId);
            return;
        }
        
        if (items.containsKey(productId)) {
            CartItem item = items.get(productId);
            item.setQuantity(quantity);
            calculateTotal();
        }
    }

    public void removeItem(int productId) {
        boolean removed = items.remove(productId) != null;
        if (removed) {
            calculateTotal();
        }
    }

    public void clear() {
        items.clear();
        total = 0.0;
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
        total = items.values().stream()
                .mapToDouble(CartItem::getTotal)
                .sum();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public boolean containsProduct(int productId) {
        return items.containsKey(productId);
    }

    public int getTotalItems() {
        return items.values().stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }
}