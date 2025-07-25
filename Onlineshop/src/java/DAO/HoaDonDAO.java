package DAO;

import Model.HoaDon;
import Model.Status;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for HoaDon (Invoice/Order) management
 */
public class HoaDonDAO extends DBContext {
    
    /**
     * Get all orders with specified status with pagination
     * @param statusID Status ID to filter by
     * @param page Current page number (1-based)
     * @param pageSize Number of records per page
     * @param search Search keyword
     * @return List of HoaDon objects
     */
    public List<HoaDon> getOrdersByStatus(int statusID, int page, int pageSize, String search) {
        List<HoaDon> orders = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.note, h.shippingID, ");
        sql.append("a.username, a.email, a.phone, s.name as statusName, ");
        sql.append("i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress ");
        sql.append("FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("JOIN status s ON h.statusID = s.statusID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID = ? ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.username LIKE ? OR i.name LIKE ? OR i.phoneNumber LIKE ? OR i.email LIKE ? OR h.maHD LIKE ?) ");
        }
        
        sql.append("ORDER BY h.ngayXuat DESC ");
        sql.append("LIMIT ? OFFSET ?");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, statusID);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, offset);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setNote(rs.getString("note"));
                order.setShippingID(rs.getObject("shippingID", Integer.class));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println(">>> Số đơn hàng load được: " + orders.size());
        return orders;
    }
    
    /**
     * Get total count of orders with specified status
     * @param statusID Status ID to filter by
     * @param search Search keyword
     * @return Total count of orders
     */
    public int getTotalOrdersByStatus(int statusID, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) as total FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID = ? ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.username LIKE ? OR i.name LIKE ? OR i.phoneNumber LIKE ? OR i.email LIKE ? OR h.maHD LIKE ?) ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, statusID);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get total count of orders with specified status for a specific shipper
     * @param statusID Status ID to filter by
     * @param shipperID Shipper ID to filter by
     * @param search Search keyword
     * @return Total count of orders
     */
    public int getTotalOrdersByStatusAndShipper(int statusID, int shipperID, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) as total FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID = ? AND h.shippingID = ? ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.username LIKE ? OR i.name LIKE ? OR i.phoneNumber LIKE ? OR i.email LIKE ? OR h.maHD LIKE ?) ");
        }
        
        int count = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            ps.setInt(paramIndex++, statusID);
            ps.setInt(paramIndex++, shipperID);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    /**
     * Get order by ID
     * @param maHD Order ID
     * @return HoaDon object
     */
    public HoaDon getOrderById(int maHD) {
        String sql = "SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.note, h.ImageNote, h.shippingID, " +
                    "a.username, a.email, a.phone, s.name as statusName, " +
                    "i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress " +
                    "FROM hoadon h " +
                    "JOIN account a ON h.accountID = a.accountID " +
                    "JOIN status s ON h.statusID = s.statusID " +
                    "LEFT JOIN inforline i ON h.maHD = i.maHD " +
                    "WHERE h.maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maHD);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setNote(rs.getString("note"));
                order.setImageNote(rs.getString("ImageNote"));
                order.setShippingID(rs.getObject("shippingID", Integer.class));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update order status
     * @param maHD Order ID
     * @param statusID New status ID
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int maHD, int statusID) {
        String sql = "UPDATE hoadon SET statusID = ? WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setInt(2, maHD);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update order status with note (for cancellation)
     * @param maHD Order ID
     * @param statusID New status ID
     * @param note Note for cancellation reason
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatusWithNote(int maHD, int statusID, String note) {
        String sql = "UPDATE hoadon SET statusID = ?, note = ? WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setString(2, note);
            ps.setInt(3, maHD);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update order status with note and image (for delivery completion/failure)
     * @param maHD Order ID
     * @param statusID New status ID
     * @param note Note for the status change
     * @param imageNote Image path for evidence
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatusWithNoteAndImage(int maHD, int statusID, String note, String imageNote) {
        String sql = "UPDATE hoadon SET statusID = ?, note = ?, ImageNote = ? WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setString(2, note);
            ps.setString(3, imageNote);
            ps.setInt(4, maHD);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update order status with image only (for successful delivery)
     * @param maHD Order ID
     * @param statusID New status ID
     * @param imageNote Image path for evidence
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatusWithImage(int maHD, int statusID, String imageNote) {
        String sql = "UPDATE hoadon SET statusID = ?, ImageNote = ? WHERE maHD = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, statusID);
            ps.setString(2, imageNote);
            ps.setInt(3, maHD);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all status options
     * @return List of Status objects
     */
    public List<Status> getAllStatuses() {
        List<Status> statuses = new ArrayList<>();
        String sql = "SELECT statusID, name FROM status ORDER BY statusID";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Status status = new Status();
                status.setStatusID(rs.getInt("statusID"));
                status.setName(rs.getString("name"));
                statuses.add(status);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return statuses;
    }
    
    /**
     * Get shipper-specific statuses
     * @return List of Status objects for shipper
     */
    public List<Status> getShipperStatuses() {
        List<Status> statuses = new ArrayList<>();
        // Shipper can see orders with status: 2, 3, 4, 10
        String sql = "SELECT statusID, name FROM status WHERE statusID IN (2, 3, 4, 10) ORDER BY statusID";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Status status = new Status();
                status.setStatusID(rs.getInt("statusID"));
                status.setName(rs.getString("name"));
                statuses.add(status);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return statuses;
    }
    
    /**
     * Get orders by multiple status IDs for shipper dashboard
     * @param statusIDs Array of status IDs
     * @return List of HoaDon objects
     */
    public List<HoaDon> getOrdersByMultipleStatus(int[] statusIDs) {
        List<HoaDon> orders = new ArrayList<>();
        
        if (statusIDs == null || statusIDs.length == 0) {
            return orders;
        }
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, ");
        sql.append("a.username, a.email, a.phone, s.name as statusName, ");
        sql.append("i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress ");
        sql.append("FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("JOIN status s ON h.statusID = s.statusID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID IN (");
        
        for (int i = 0; i < statusIDs.length; i++) {
            sql.append("?");
            if (i < statusIDs.length - 1) {
                sql.append(",");
            }
        }
        
        sql.append(") ORDER BY h.ngayXuat DESC");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < statusIDs.length; i++) {
                ps.setInt(i + 1, statusIDs[i]);
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get orders by multiple status IDs for shipper dashboard
     * @param statusIDs Array of status IDs
     * @return List of HoaDon objects
     */
    public List<HoaDon> getOrdersByMultipleStatusForShipper(int[] statusIDs) {
        List<HoaDon> orders = new ArrayList<>();
        
        if (statusIDs == null || statusIDs.length == 0) {
            return orders;
        }
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.note, h.shippingID, ");
        sql.append("a.username, a.email, a.phone, s.name as statusName, ");
        sql.append("i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress ");
        sql.append("FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("JOIN status s ON h.statusID = s.statusID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID IN (");
        
        for (int i = 0; i < statusIDs.length; i++) {
            sql.append("?");
            if (i < statusIDs.length - 1) {
                sql.append(", ");
            }
        }
        sql.append(") ORDER BY h.ngayXuat DESC LIMIT 20");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < statusIDs.length; i++) {
                ps.setInt(i + 1, statusIDs[i]);
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setNote(rs.getString("note"));
                order.setShippingID(rs.getObject("shippingID", Integer.class));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get orders by multiple status IDs for a specific shipper dashboard
     * @param statusIDs Array of status IDs
     * @param shipperID Shipper ID to filter by
     * @return List of HoaDon objects
     */
    public List<HoaDon> getOrdersByMultipleStatusForSpecificShipper(int[] statusIDs, int shipperID) {
        List<HoaDon> orders = new ArrayList<>();
        
        if (statusIDs == null || statusIDs.length == 0) {
            return orders;
        }
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.note, h.shippingID, ");
        sql.append("a.username, a.email, a.phone, s.name as statusName, ");
        sql.append("i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress ");
        sql.append("FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("JOIN status s ON h.statusID = s.statusID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID IN (");
        
        for (int i = 0; i < statusIDs.length; i++) {
            sql.append("?");
            if (i < statusIDs.length - 1) {
                sql.append(", ");
            }
        }
        sql.append(") AND h.shippingID = ? ORDER BY h.ngayXuat DESC LIMIT 20");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            for (int i = 0; i < statusIDs.length; i++) {
                ps.setInt(paramIndex++, statusIDs[i]);
            }
            ps.setInt(paramIndex, shipperID);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setNote(rs.getString("note"));
                order.setShippingID(rs.getInt("shippingID"));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get all orders for shipper with multiple statuses (2,3,4,6)
     * @param page Current page number (1-based)
     * @param pageSize Number of records per page
     * @param search Search keyword
     * @return List of HoaDon objects
     */
    public List<HoaDon> getAllShipperOrders(int page, int pageSize, String search) {
        List<HoaDon> orders = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.note, ");
        sql.append("a.username, a.email, a.phone, s.name as statusName, ");
        sql.append("i.name as customerName, i.email as customerEmail, i.phoneNumber as customerPhone, i.address as customerAddress ");
        sql.append("FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("JOIN status s ON h.statusID = s.statusID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID IN (2, 3, 4, 6) ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.username LIKE ? OR i.name LIKE ? OR i.phoneNumber LIKE ? OR i.email LIKE ? OR h.maHD LIKE ?) ");
        }
        
        sql.append("ORDER BY h.ngayXuat DESC ");
        sql.append("LIMIT ? OFFSET ?");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, offset);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon order = new HoaDon();
                order.setMaHD(rs.getInt("maHD"));
                order.setAccountID(rs.getInt("accountID"));
                order.setTongGia(rs.getDouble("tongGia"));
                order.setNgayXuat(rs.getDate("ngayXuat"));
                order.setStatusID(rs.getInt("statusID"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setNote(rs.getString("note"));
                order.setUsername(rs.getString("username"));
                order.setEmail(rs.getString("email"));
                order.setPhone(rs.getString("phone"));
                order.setStatusName(rs.getString("statusName"));
                order.setCustomerName(rs.getString("customerName"));
                order.setCustomerEmail(rs.getString("customerEmail"));
                order.setCustomerPhone(rs.getString("customerPhone"));
                order.setCustomerAddress(rs.getString("customerAddress"));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Get total count of all shipper orders (2,3,4,6)
     * @param search Search keyword
     * @return Total count of orders
     */
    public int getTotalShipperOrders(String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) as total FROM hoadon h ");
        sql.append("JOIN account a ON h.accountID = a.accountID ");
        sql.append("LEFT JOIN inforline i ON h.maHD = i.maHD ");
        sql.append("WHERE h.statusID IN (2, 3, 4, 6) ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.username LIKE ? OR i.name LIKE ? OR i.phoneNumber LIKE ? OR i.email LIKE ? OR h.maHD LIKE ?) ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Get customer email from inforline table based on name and phone
     * @param customerName Customer name
     * @param customerPhone Customer phone
     * @return Customer email or null if not found
     */
    public String getCustomerEmailFromInforline(String customerName, String customerPhone) {
        String sql = "SELECT email FROM inforline WHERE name = ? AND phoneNumber = ? LIMIT 1";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customerName);
            ps.setString(2, customerPhone);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String email = rs.getString("email");
                System.out.println("Found email in inforline: " + email + " for customer: " + customerName + " | " + customerPhone);
                return email;
            } else {
                System.out.println("No email found in inforline for customer: " + customerName + " | " + customerPhone);
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting customer email from inforline: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Get shipper information from account table based on shippingID
     * @param shippingID Shipping ID (which is accountID of shipper)
     * @return Shipper username and phone in format "username - phone"
     */
    public String getShipperInfo(Integer shippingID) {
        if (shippingID == null) {
            return "Chưa phân công";
        }
        
        String sql = "SELECT username, phone FROM account WHERE accountID = ? AND role = 3";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shippingID);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String username = rs.getString("username");
                String phone = rs.getString("phone");
                String shipperInfo = username + " - " + (phone != null ? phone : "");
                System.out.println("Found shipper info: " + shipperInfo + " for shippingID: " + shippingID);
                return shipperInfo;
            } else {
                System.out.println("No shipper found for shippingID: " + shippingID);
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting shipper info: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "Chưa phân công";
    }
}
