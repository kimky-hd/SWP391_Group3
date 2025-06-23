package DAO;

import Model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import DAO.DBContext;
import Model.Cart;
import Model.CartItem;
import Model.ProductBatch;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp CartDAO (Data Access Object) chịu trách nhiệm tương tác với cơ sở dữ liệu
 * để quản lý các thao tác liên quan đến giỏ hàng của người dùng. Lớp này kế
 * thừa từ DBContext để có thể sử dụng kết nối cơ sở dữ liệu.
 */
public class CartDAO extends DBContext {

    /**
     * Thêm một sản phẩm vào giỏ hàng của người dùng. Nếu sản phẩm đã tồn tại
     * trong giỏ hàng, hàm này sẽ cập nhật số lượng. Nếu sản phẩm chưa có, hàm
     * sẽ thêm mới vào giỏ hàng.
     *
     * @param accountId ID của tài khoản người dùng.
     * @param productId ID của sản phẩm cần thêm.
     * @param quantity Số lượng sản phẩm muốn thêm.
     * @return true nếu thêm hoặc cập nhật giỏ hàng thành công, ngược lại là
     * false.
     */
    public boolean addToCart(int accountId, int productId, int quantity, boolean isUpdate) {
        String checkSql = "SELECT Quantity FROM Cart WHERE AccountID = ? AND ProductID = ?";
        try (Connection conn = getConnection(); PreparedStatement checkPs = conn.prepareStatement(checkSql)) {

            checkPs.setInt(1, accountId);
            checkPs.setInt(2, productId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Đã có sẵn trong giỏ
                    String updateSql = "UPDATE Cart SET Quantity = ? WHERE AccountID = ? AND ProductID = ?";
                    int newQuantity = isUpdate ? quantity : rs.getInt("Quantity") + quantity;

                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, newQuantity);
                        updatePs.setInt(2, accountId);
                        updatePs.setInt(3, productId);
                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    // Chưa có → insert
                    String insertSql = "INSERT INTO Cart (AccountID, ProductID, Quantity) VALUES (?, ?, ?)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, accountId);
                        insertPs.setInt(2, productId);
                        insertPs.setInt(3, quantity);
                        return insertPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy thông tin chi tiết của một sản phẩm dựa trên ID sản phẩm. Hàm này
     * được sử dụng để lấy thông tin sản phẩm đầy đủ từ bảng Product, thường là
     * để hiển thị thông tin sản phẩm trong giỏ hàng hoặc chi tiết sản phẩm.
     *
     * @param productId ID của sản phẩm cần lấy thông tin.
     * @return Một đối tượng Product chứa thông tin sản phẩm, hoặc null nếu
     * không tìm thấy hoặc có lỗi xảy ra.
     */
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Product WHERE productID = ?"; // Câu lệnh SQL để chọn sản phẩm theo ID
    
        Connection conn = getConnection(); // Lấy kết nối từ DBContext
        if (conn == null) {
            System.out.println("Không thể kết nối đến cơ sở dữ liệu");
            return null; // Trả về null nếu không thể kết nối
        }
    
        try (PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL
            ps.setInt(1, productId); // Thiết lập tham số productId
    
            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn và lấy kết quả
                if (rs.next()) { // Nếu tìm thấy một hàng kết quả
                    Product product = new Product(); // Tạo đối tượng Product mới
                    // Đặt các thuộc tính cho đối tượng Product từ dữ liệu trong ResultSet
                    product.setProductID(rs.getInt("productID"));
                    product.setTitle(rs.getString("title")); // Lấy từ cột 'title'
                    product.setPrice(rs.getDouble("price"));
                    product.setDescription(rs.getString("description"));
                    product.setImage(rs.getString("image"));
                    product.setColorID(rs.getInt("colorID"));
                    product.setSeasonID(rs.getInt("seasonID"));
                    
                    // Lấy danh sách các lô sản phẩm
                    String batchSql = "SELECT * FROM ProductBatch WHERE productID = ? AND dateExpire > CURRENT_DATE() AND status != 'Đã Héo' ORDER BY dateExpire ASC";
                    try (PreparedStatement batchPs = conn.prepareStatement(batchSql)) {
                        batchPs.setInt(1, product.getProductID());
                        try (ResultSet batchRs = batchPs.executeQuery()) {
                            List<ProductBatch> batches = new ArrayList<>();
                            
                            while (batchRs.next()) {
                                ProductBatch batch = new ProductBatch();
                                batch.setProductBatchID(batchRs.getInt("productBatchID"));
                                batch.setProductID(batchRs.getInt("productID"));
                                batch.setQuantity(batchRs.getInt("quantity"));
                                batch.setImportPrice(batchRs.getDouble("importPrice"));
                                batch.setDateImport(batchRs.getDate("dateImport"));
                                batch.setDateExpire(batchRs.getDate("dateExpire"));
                                batch.setStatus(batchRs.getString("status"));
                                
                                batches.add(batch);
                            }
                            
                            product.setBatches(batches); // Thiết lập danh sách batches cho sản phẩm
                        }
                    }
                    
                    return product; // Trả về đối tượng Product
                }
            }
        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đảm bảo đóng kết nối để tránh rò rỉ tài nguyên
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
        return null; // Trả về null nếu không tìm thấy sản phẩm hoặc có lỗi
    }

    /**
     * Kiểm tra xem một sản phẩm có đủ số lượng trong kho để đáp ứng yêu cầu hay
     * không.
     *
     * @param productId ID của sản phẩm cần kiểm tra.
     * @param requestedQuantity Số lượng sản phẩm được yêu cầu.
     * @return true nếu số lượng sản phẩm có sẵn trong kho đủ để đáp ứng yêu
     * cầu, ngược lại là false.
     */
    public boolean checkProductAvailability(int productId, int requestedQuantity) {
        String sql = "SELECT p.* FROM Product p WHERE p.productID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Lấy thông tin sản phẩm
                    Product product = new Product();
                    product.setProductID(rs.getInt("productID"));
                    product.setTitle(rs.getString("title"));
                    product.setPrice(rs.getDouble("price"));
                    product.setDescription(rs.getString("description"));
                    product.setImage(rs.getString("image"));
                    product.setColorID(rs.getInt("colorID"));
                    product.setSeasonID(rs.getInt("seasonID"));
                    
                    // Lấy danh sách các lô sản phẩm
                    String batchSql = "SELECT * FROM ProductBatch WHERE productID = ? AND dateExpire > CURRENT_DATE() AND status != 'Đã Héo' ORDER BY dateExpire ASC";
                    try (PreparedStatement batchPs = conn.prepareStatement(batchSql)) {
                        batchPs.setInt(1, product.getProductID());
                        try (ResultSet batchRs = batchPs.executeQuery()) {
                            List<ProductBatch> batches = new ArrayList<>();
                            int totalAvailableQuantity = 0;
                            
                            while (batchRs.next()) {
                                ProductBatch batch = new ProductBatch();
                                batch.setProductBatchID(batchRs.getInt("productBatchID"));
                                batch.setProductID(batchRs.getInt("productID"));
                                batch.setQuantity(batchRs.getInt("quantity"));
                                batch.setImportPrice(batchRs.getDouble("importPrice"));
                                batch.setDateImport(batchRs.getDate("dateImport"));
                                batch.setDateExpire(batchRs.getDate("dateExpire"));
                                batch.setStatus(batchRs.getString("status"));
                                
                                batches.add(batch);
                                totalAvailableQuantity += batch.getQuantity();
                            }
                            
                            product.setBatches(batches);
                            return totalAvailableQuantity >= requestedQuantity;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error checking product availability: " + e.getMessage());
            e.printStackTrace();
        }

        return false; // Trả về false nếu không tìm thấy sản phẩm hoặc có lỗi
    }

    /**
     * Cập nhật số lượng tồn kho của một sản phẩm trong các lô. Hàm này có thể được sử dụng
     * để tăng hoặc giảm số lượng sản phẩm trong kho.
     *
     * @param productId ID của sản phẩm cần cập nhật.
     * @param quantityChange Lượng thay đổi số lượng. Giá trị dương để tăng, giá
     * trị âm để giảm.
     * @return true nếu cập nhật số lượng thành công, ngược lại là false.
     */
    public boolean updateProductQuantity(int productId, int quantityChange) {
        try (Connection conn = getConnection()) {
            // Nếu tăng số lượng (trả lại hàng), cập nhật vào lô mới nhất
            if (quantityChange > 0) {
                String sql = "UPDATE ProductBatch SET quantity = quantity + ? " +
                             "WHERE productID = ? AND dateExpire > CURRENT_DATE() " +
                             "ORDER BY dateExpire DESC LIMIT 1";
                
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, quantityChange);
                    ps.setInt(2, productId);
                    
                    int rowsAffected = ps.executeUpdate();
                    return rowsAffected > 0;
                }
            } 
            // Nếu giảm số lượng (đặt hàng), ưu tiên lấy từ các lô có ngày hết hạn sớm nhất
            else if (quantityChange < 0) {
                int remainingQuantity = -quantityChange; // Chuyển thành số dương
                
                // Lấy danh sách các lô còn hạn, sắp xếp theo ngày hết hạn tăng dần
                String selectBatchesSql = "SELECT productBatchID, quantity FROM ProductBatch " +
                                         "WHERE productID = ? AND dateExpire > CURRENT_DATE() AND status != 'Đã Héo' " +
                                         "ORDER BY dateExpire ASC";
                
                List<Integer> batchIds = new ArrayList<>();
                List<Integer> quantitiesToDecrease = new ArrayList<>();
                
                try (PreparedStatement selectPs = conn.prepareStatement(selectBatchesSql)) {
                    selectPs.setInt(1, productId);
                    
                    try (ResultSet rs = selectPs.executeQuery()) {
                        while (rs.next() && remainingQuantity > 0) {
                            int batchId = rs.getInt("productBatchID");
                            int batchQuantity = rs.getInt("quantity");
                            
                            int decreaseAmount = Math.min(batchQuantity, remainingQuantity);
                            
                            batchIds.add(batchId);
                            quantitiesToDecrease.add(decreaseAmount);
                            
                            remainingQuantity -= decreaseAmount;
                        }
                    }
                }
                
                // Nếu không đủ số lượng trong các lô
                if (remainingQuantity > 0) {
                    return false;
                }
                
                // Cập nhật số lượng trong từng lô
                String updateBatchSql = "UPDATE ProductBatch SET quantity = quantity - ? WHERE productBatchID = ?";
                
                conn.setAutoCommit(false); // Bắt đầu transaction
                
                try {
                    try (PreparedStatement updatePs = conn.prepareStatement(updateBatchSql)) {
                        for (int i = 0; i < batchIds.size(); i++) {
                            updatePs.setInt(1, quantitiesToDecrease.get(i));
                            updatePs.setInt(2, batchIds.get(i));
                            updatePs.executeUpdate();
                        }
                    }
                    
                    conn.commit();
                    return true;
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            }
            
            return false; // Không có thay đổi số lượng
        } catch (SQLException e) {
            System.out.println("Error updating product batch quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Giảm số lượng sản phẩm trong kho khi chúng được "đặt trước" (ví dụ, khi
     * thêm vào giỏ hàng hoặc tạo đơn hàng). Hàm này sẽ kiểm tra tính khả dụng
     * trước khi giảm số lượng.
     *
     * @param orderId (Tham số này hiện không được sử dụng trực tiếp trong hàm
     * nhưng có thể hữu ích cho mục đích ghi nhật ký hoặc logic phức tạp hơn).
     * @param productId ID của sản phẩm cần đặt trước.
     * @param quantity Số lượng sản phẩm muốn đặt trước.
     * @return true nếu sản phẩm được đặt trước thành công (số lượng trong kho
     * được giảm), ngược lại là false.
     */
    public boolean reserveProducts(int orderId, int productId, int quantity) {
        // Bước 1: Kiểm tra xem số lượng sản phẩm có sẵn trong kho có đủ không
        if (!checkProductAvailability(productId, quantity)) {
            System.out.println("Không đủ số lượng sản phẩm có sẵn cho ProductID: " + productId);
            return false; // Trả về false nếu không đủ
        }

        // Bước 2: Nếu đủ, cập nhật số lượng sản phẩm trong kho bằng cách giảm đi số lượng đã đặt
        // Dùng -quantity để giảm số lượng
        return updateProductQuantity(productId, -quantity);
    }

    /**
     * Xóa một sản phẩm cụ thể khỏi giỏ hàng của người dùng.
     *
     * @param accountId ID của tài khoản người dùng.
     * @param productId ID của sản phẩm cần xóa khỏi giỏ hàng.
     * @return true nếu sản phẩm được xóa thành công, ngược lại là false.
     */
    public boolean removeFromCart(int accountId, int productId) {
        String sql = "DELETE FROM Cart WHERE AccountID = ? AND ProductID = ?"; // Câu lệnh SQL để xóa
        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL
            ps.setInt(1, accountId); // Thiết lập tham số AccountID
            ps.setInt(2, productId); // Thiết lập tham số ProductID
            return ps.executeUpdate() > 0; // Trả về true nếu có ít nhất một hàng bị xóa
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi
            return false; // Trả về false nếu có lỗi
        }
    }

    /**
     * Xóa tất cả các sản phẩm khỏi giỏ hàng của một người dùng cụ thể.
     *
     * @param accountId ID của tài khoản người dùng cần xóa giỏ hàng.
     * @return true nếu giỏ hàng được xóa thành công (hoặc không có gì để xóa),
     * ngược lại là false nếu có lỗi.
     */
    public boolean clearCart(int accountId) {
        String sql = "DELETE FROM Cart WHERE AccountID = ?"; // Câu lệnh SQL để xóa tất cả
        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL
            ps.setInt(1, accountId); // Thiết lập tham số AccountID
            // Trả về true ngay cả khi không có mục nào để xóa (rowsAffected = 0),
            // vì thao tác "clear cart" được coi là thành công trong trường hợp đó.
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi
            return false; // Trả về false nếu có lỗi
        }
    }

    /**
     * Lấy tổng số lượng các mặt hàng (không phải tổng số lượng sản phẩm, mà là
     * tổng số dòng sản phẩm duy nhất) trong giỏ hàng của một người dùng.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Tổng số mặt hàng trong giỏ hàng, hoặc 0 nếu không có mặt hàng nào
     * hoặc có lỗi.
     */
    public int getCartItemCount(int accountId) {
        String sql = "SELECT COUNT(*) FROM Cart WHERE AccountID = ?"; // Đếm số lượng dòng trong bảng Cart
        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL
            ps.setInt(1, accountId); // Thiết lập tham số AccountID
            ResultSet rs = ps.executeQuery(); // Thực thi truy vấn
            if (rs.next()) { // Nếu có kết quả
                return rs.getInt(1); // Lấy giá trị của cột đầu tiên (COUNT(*))
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi
        }
        return 0; // Trả về 0 nếu không có mặt hàng hoặc có lỗi
    }

    /**
     * Tính tổng giá trị của tất cả các sản phẩm trong giỏ hàng của một người
     * dùng. Tổng giá trị được tính bằng cách nhân số lượng từng sản phẩm với
     * giá của nó và cộng dồn.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Tổng giá trị của giỏ hàng, hoặc 0.0 nếu giỏ hàng trống hoặc có
     * lỗi.
     */
    public double getCartTotal(int accountId) {
        // Câu lệnh SQL JOIN giữa Cart và Product để lấy giá sản phẩm và tính tổng
        String sql = "SELECT SUM(c.Quantity * p.Price) as total "
                + "FROM Cart c JOIN Product p ON c.ProductID = p.ProductID "
                + "WHERE c.AccountID = ?";
        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL
            ps.setInt(1, accountId); // Thiết lập tham số AccountID
            ResultSet rs = ps.executeQuery(); // Thực thi truy vấn
            if (rs.next()) { // Nếu có kết quả
                return rs.getDouble("total"); // Lấy giá trị của cột 'total'
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi
        }
        return 0.0; // Trả về 0.0 nếu giỏ hàng trống hoặc có lỗi
    }

    /**
     * Lấy toàn bộ thông tin giỏ hàng của một người dùng, bao gồm thông tin chi
     * tiết về từng sản phẩm. Hàm này tạo một đối tượng Cart và điền vào đó các
     * CartItem tương ứng với các sản phẩm trong giỏ hàng của người dùng, lấy
     * thông tin từ bảng Cart và Product.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Một đối tượng Cart chứa danh sách các CartItem, hoặc một đối
     * tượng Cart rỗng nếu không có sản phẩm nào trong giỏ hàng hoặc có lỗi.
     */
    public Cart getCartByAccount_Id(int accountId) {
        Cart cart = new Cart(); // Khởi tạo một đối tượng Cart mới
        // Câu lệnh SQL JOIN giữa Cart và Product để lấy tất cả thông tin cần thiết cho CartItem
        String sql = "SELECT c.ProductID, c.Quantity, p.title as Name, p.price as Price, p.description as Description, p.image as Image " +
                "FROM Cart c JOIN Product p ON c.ProductID = p.productID " +
                "WHERE c.AccountID = ?";

        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, accountId); // Thiết lập tham số AccountID
            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn
                while (rs.next()) { // Duyệt qua từng hàng kết quả
                    Product product = new Product(); // Tạo đối tượng Product cho mỗi CartItem
                    // Đặt các thuộc tính cho đối tượng Product từ dữ liệu trong ResultSet
                    product.setProductID(rs.getInt("ProductID"));
                    product.setTitle(rs.getString("Name")); // Lấy tên sản phẩm (được alias là 'Name')
                    product.setPrice(rs.getDouble("Price"));
                    product.setDescription(rs.getString("Description"));
                    product.setImage(rs.getString("Image"));
                    
                    // Lấy danh sách các lô sản phẩm
                    String batchSql = "SELECT * FROM ProductBatch WHERE productID = ? AND dateExpire > CURRENT_DATE() AND status != 'Đã Héo' ORDER BY dateExpire ASC";
                    try (PreparedStatement batchPs = conn.prepareStatement(batchSql)) {
                        batchPs.setInt(1, product.getProductID()); // Sửa: Sử dụng product.getProductID() thay vì productId
                        try (ResultSet batchRs = batchPs.executeQuery()) {
                            List<ProductBatch> batches = new ArrayList<>();
                            
                            while (batchRs.next()) {
                                ProductBatch batch = new ProductBatch();
                                batch.setProductBatchID(batchRs.getInt("productBatchID"));
                                batch.setProductID(batchRs.getInt("productID"));
                                batch.setQuantity(batchRs.getInt("quantity"));
                                batch.setImportPrice(batchRs.getDouble("importPrice"));
                                batch.setDateImport(batchRs.getDate("dateImport"));
                                batch.setDateExpire(batchRs.getDate("dateExpire"));
                                batch.setStatus(batchRs.getString("status"));
                                
                                batches.add(batch);
                            }
                            
                            product.setBatches(batches); // Thiết lập danh sách batches cho sản phẩm
                        }
                    }

                    int quantity = rs.getInt("Quantity"); // Lấy số lượng sản phẩm trong giỏ hàng

                    CartItem item = new CartItem(product, quantity); // Tạo CartItem từ Product và số lượng
                    cart.addItem(item); // Thêm CartItem vào đối tượng Cart
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi
        }

        return cart; // Trả về đối tượng Cart đã được điền dữ liệu
    }

}
