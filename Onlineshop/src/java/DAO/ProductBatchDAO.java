package DAO;

import Model.ProductBatch;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for ProductBatch management
 */
public class ProductBatchDAO extends DBContext {
    
    /**
     * Get all product batches for a specific product
     * @param productId Product ID
     * @return List of ProductBatch objects
     */
    public List<ProductBatch> getProductBatchesByProductId(int productId) {
        List<ProductBatch> batches = new ArrayList<>();
        String sql = "SELECT * FROM productbatch WHERE productID = ? ORDER BY dateImport DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductBatch batch = new ProductBatch();
                batch.setProductBatchID(rs.getInt("productBatchID"));
                batch.setProductID(rs.getInt("productID"));
                batch.setQuantity(rs.getInt("quantity"));
                batch.setImportPrice(rs.getDouble("importPrice"));
                batch.setDateImport(rs.getDate("dateImport"));
                batch.setDateExpire(rs.getDate("dateExpire"));
                batch.setStatus(rs.getString("status"));
                
                batches.add(batch);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return batches;
    }
    
    /**
     * Add quantity back to product batch when order is cancelled
     * @param productId Product ID
     * @param quantity Quantity to add back
     * @return true if successful, false otherwise
     */
    public boolean addQuantityToProduct(int productId, int quantity) {
        System.out.println("=== Starting addQuantityToProduct ===");
        System.out.println("Product ID: " + productId + ", Quantity to add: " + quantity);
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // First, list ALL batches for this product
            String listSql = "SELECT productBatchID, quantity, status FROM productbatch WHERE productID = ? ORDER BY dateImport DESC";
            
            try (PreparedStatement listPs = conn.prepareStatement(listSql)) {
                listPs.setInt(1, productId);
                ResultSet rs = listPs.executeQuery();
                
                System.out.println("All batches for product " + productId + ":");
                boolean hasAnyBatch = false;
                while (rs.next()) {
                    hasAnyBatch = true;
                    System.out.println("  Batch ID: " + rs.getInt("productBatchID") + 
                                     ", Quantity: " + rs.getInt("quantity") + 
                                     ", Status: " + rs.getString("status"));
                }
                
                if (hasAnyBatch) {
                    // Update the OLDEST batch first (FIFO - same as when reducing quantity)
                    System.out.println("Using FIFO approach - updating oldest batch first");
                    String updateSql = "UPDATE productbatch SET quantity = quantity + ? WHERE productID = ? ORDER BY dateImport ASC LIMIT 1";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, quantity);
                        updatePs.setInt(2, productId);
                        
                        int rowsAffected = updatePs.executeUpdate();
                        System.out.println("Update result - rows affected: " + rowsAffected);
                        
                        if (rowsAffected > 0) {
                            conn.commit(); // Commit the transaction
                            System.out.println("✓ Transaction committed - Successfully updated most recent batch for product " + productId + " - added " + quantity + " units");
                            
                            // List batches again to verify
                            System.out.println("Batches after update:");
                            try (PreparedStatement verifyPs = conn.prepareStatement(listSql)) {
                                verifyPs.setInt(1, productId);
                                ResultSet verifyRs = verifyPs.executeQuery();
                                while (verifyRs.next()) {
                                    System.out.println("  Batch ID: " + verifyRs.getInt("productBatchID") + 
                                                     ", Quantity: " + verifyRs.getInt("quantity") + 
                                                     ", Status: " + verifyRs.getString("status"));
                                }
                            }
                            
                            return true;
                        } else {
                            conn.rollback();
                            System.out.println("✗ Failed to update existing batch - transaction rolled back");
                            return false;
                        }
                    }
                    
                } else {
                    // No existing batch found, create new one
                    System.out.println("No existing batch found for product " + productId + ", creating new batch");
                    
                    String insertSql = "INSERT INTO productbatch (productID, quantity, importPrice, dateImport, dateExpire, status) VALUES (?, ?, 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'Hoàn trả')";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, productId);
                        insertPs.setInt(2, quantity);
                        
                        int rowsAffected = insertPs.executeUpdate();
                        System.out.println("Insert result - rows affected: " + rowsAffected);
                        
                        if (rowsAffected > 0) {
                            conn.commit(); // Commit the transaction
                            System.out.println("✓ Transaction committed - Successfully created new batch for product " + productId);
                            return true;
                        } else {
                            conn.rollback();
                            System.out.println("✗ Failed to create new batch - transaction rolled back");
                            return false;
                        }
                    }
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error in addQuantityToProduct: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                    System.out.println("Transaction rolled back due to error");
                }
            } catch (SQLException rollbackEx) {
                System.out.println("Error during rollback: " + rollbackEx.getMessage());
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset autocommit
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Create a new product batch for returned quantity
     * @param productId Product ID
     * @param quantity Quantity to add
     * @return true if successful, false otherwise
     */
    private boolean createNewBatch(int productId, int quantity) {
        System.out.println("=== Creating new batch (DEPRECATED - now handled in addQuantityToProduct) ===");
        System.out.println("Product ID: " + productId + ", Quantity: " + quantity);
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO productbatch (productID, quantity, importPrice, dateImport, dateExpire, status) VALUES (?, ?, 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'Hoàn trả')";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, productId);
                ps.setInt(2, quantity);
                
                System.out.println("Executing SQL: " + sql);
                System.out.println("Parameters: productID=" + productId + ", quantity=" + quantity);
                
                int rowsAffected = ps.executeUpdate();
                System.out.println("New batch creation result - rows affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    conn.commit();
                    System.out.println("✓ Transaction committed - Successfully created new batch for product " + productId);
                    return true;
                } else {
                    conn.rollback();
                    System.out.println("✗ Failed to create new batch - transaction rolled back");
                    return false;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error in createNewBatch: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                System.out.println("Error during rollback: " + rollbackEx.getMessage());
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Get total quantity for a product across all batches
     * @param productId Product ID
     * @return Total quantity
     */
    public int getTotalQuantityForProduct(int productId) {
        String sql = "SELECT SUM(quantity) as totalQuantity FROM productbatch WHERE productID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("totalQuantity");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Reduce quantity from product batch when order is placed
     * @param productId Product ID
     * @param quantity Quantity to reduce
     * @return true if successful, false otherwise
     */
    public boolean reduceQuantityFromProduct(int productId, int quantity) {
        String sql = "UPDATE productbatch SET quantity = quantity - ? WHERE productID = ? AND quantity >= ? ORDER BY dateImport ASC LIMIT 1";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if product batch exists for debugging
     * @param productId Product ID
     * @return true if exists, false otherwise
     */
    public boolean checkProductBatchExists(int productId) {
        String sql = "SELECT COUNT(*) as count FROM productbatch WHERE productID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("Product " + productId + " has " + count + " batches in database");
                return count > 0;
            }
            
        } catch (SQLException e) {
            System.out.println("Error checking product batch: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Test method to verify database operation
     * @param productId Product ID to test
     * @param quantity Quantity to test with
     */
    public void testDatabaseOperation(int productId, int quantity) {
        System.out.println("=== DATABASE TEST ===");
        
        try (Connection conn = getConnection()) {
            System.out.println("Database connection: " + (conn != null ? "SUCCESS" : "FAILED"));
            
            if (conn != null) {
                // Test 1: Check current batches
                String selectSql = "SELECT * FROM productbatch WHERE productID = ?";
                try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                    ps.setInt(1, productId);
                    ResultSet rs = ps.executeQuery();
                    
                    System.out.println("Current batches for product " + productId + ":");
                    boolean found = false;
                    while (rs.next()) {
                        found = true;
                        System.out.println("  Batch ID: " + rs.getInt("productBatchID") + 
                                         ", Quantity: " + rs.getInt("quantity") + 
                                         ", Status: " + rs.getString("status"));
                    }
                    
                    if (!found) {
                        System.out.println("  No batches found for product " + productId);
                    }
                }
                
                // Test 2: Try direct insert
                String insertSql = "INSERT INTO productbatch (productID, quantity, importPrice, dateImport, dateExpire, status) VALUES (?, ?, 999, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'TEST')";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, productId);
                    ps.setInt(2, quantity);
                    
                    int result = ps.executeUpdate();
                    System.out.println("Direct insert test result: " + result + " rows affected");
                    
                    // Clean up test record
                    String deleteSql = "DELETE FROM productbatch WHERE productID = ? AND status = 'TEST'";
                    try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                        deletePs.setInt(1, productId);
                        int deleteResult = deletePs.executeUpdate();
                        System.out.println("Cleanup: " + deleteResult + " test records deleted");
                    }
                }
            }
            
        } catch (Exception e) {
            System.out.println("Database test error: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== END DATABASE TEST ===");
    }
    
    /**
     * Simple test method to add quantity directly without checking existing batches
     * @param productId Product ID
     * @param quantity Quantity to add
     * @return true if successful
     */
    public boolean forceAddQuantity(int productId, int quantity) {
        System.out.println("=== FORCE ADD QUANTITY ===");
        System.out.println("Product ID: " + productId + ", Quantity: " + quantity);
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Just insert a new batch without checking
            String sql = "INSERT INTO productbatch (productID, quantity, importPrice, dateImport, dateExpire, status) VALUES (?, ?, 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'Force Add')";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, productId);
                ps.setInt(2, quantity);
                
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    System.out.println("✓ FORCE ADD SUCCESS - " + rowsAffected + " rows affected");
                    return true;
                } else {
                    conn.rollback();
                    System.out.println("✗ FORCE ADD FAILED");
                    return false;
                }
            }
            
        } catch (SQLException e) {
            System.out.println("FORCE ADD ERROR: " + e.getMessage());
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {}
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {}
            }
        }
    }
}
