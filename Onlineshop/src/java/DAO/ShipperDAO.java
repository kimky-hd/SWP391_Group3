package DAO;

import Model.Shipper;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShipperDAO {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    // Lấy danh sách tất cả shipper (accounts có role = 3)
    public List<Shipper> getAllShippers() {
        List<Shipper> list = new ArrayList<>();
        String query = "SELECT accountID, username, email, phone, isActive " +
                      "FROM Account " +
                      "WHERE role = 3";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Shipper shipper = new Shipper();
                shipper.setShipperID(rs.getInt("accountID"));
                shipper.setUsername(rs.getString("username"));
                shipper.setEmail(rs.getString("email"));
                shipper.setPhone(rs.getString("phone"));
                shipper.setActive(rs.getBoolean("isActive"));
                list.add(shipper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return list;
    }
    
    // Lấy thông tin shipper theo ID
    public Shipper getShipperById(int shipperId) {
        String query = "SELECT a.accountID, a.username, a.email, a.phone, s.startDate, s.endDate, " +
                      "s.baseSalary, s.ordersDelivered, s.bonusPerOrder, s.isActive " +
                      "FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
                      "WHERE a.accountID = ? AND a.role = 3";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, shipperId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Shipper(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getDate("startDate"),
                    rs.getDate("endDate"),
                    rs.getDouble("baseSalary"),
                    rs.getInt("ordersDelivered"),
                    rs.getDouble("bonusPerOrder"),
                    rs.getBoolean("isActive")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
    
    // Thêm shipper mới
    public boolean addShipper(Shipper shipper, String password) {
        conn = new DBContext().getConnection();
        try {
            // Bắt đầu transaction
            conn.setAutoCommit(false);
            
            // Thêm vào bảng Account
            String accountQuery = "INSERT INTO Account (username, password, role, email, phone, isActive) VALUES (?, ?, 3, ?, ?, ?)";
            ps = conn.prepareStatement(accountQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, shipper.getUsername());
            ps.setString(2, password);
            ps.setString(3, shipper.getEmail());
            ps.setString(4, shipper.getPhone());
            ps.setBoolean(5, shipper.isActive());
            
            int accountRowsAffected = ps.executeUpdate();
            if (accountRowsAffected == 0) {
                conn.rollback();
                return false;
            }
            
            // Lấy ID được tạo tự động
            rs = ps.getGeneratedKeys();
            int newAccountId;
            if (rs.next()) {
                newAccountId = rs.getInt(1);
            } else {
                conn.rollback();
                return false;
            }
            
            // Thêm vào bảng ShipperDetails
            String shipperQuery = "INSERT INTO ShipperDetails (shipperID, startDate, endDate, baseSalary, ordersDelivered, bonusPerOrder, isActive) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(shipperQuery);
            ps.setInt(1, newAccountId);
            ps.setDate(2, shipper.getStartDate());
            ps.setDate(3, shipper.getEndDate());
            ps.setDouble(4, shipper.getBaseSalary());
            ps.setInt(5, shipper.getOrdersDelivered());
            ps.setDouble(6, shipper.getBonusPerOrder());
            ps.setBoolean(7, shipper.isActive());
            
            int shipperRowsAffected = ps.executeUpdate();
            
            if (shipperRowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
    }
    
    // Cập nhật thông tin shipper
    public boolean updateShipper(Shipper shipper) {
        conn = new DBContext().getConnection();
        try {
            conn.setAutoCommit(false);
            
            // Cập nhật thông tin trong bảng Account
            String accountQuery = "UPDATE Account SET username = ?, email = ?, phone = ?, isActive = ? WHERE accountID = ? AND role = 3";
            ps = conn.prepareStatement(accountQuery);
            ps.setString(1, shipper.getUsername());
            ps.setString(2, shipper.getEmail());
            ps.setString(3, shipper.getPhone());
            ps.setBoolean(4, shipper.isActive());
            ps.setInt(5, shipper.getShipperID());
            
            int accountRowsAffected = ps.executeUpdate();
            
            // Cập nhật thông tin trong bảng ShipperDetails
            String shipperQuery = "UPDATE ShipperDetails SET startDate = ?, endDate = ?, baseSalary = ?, ordersDelivered = ?, bonusPerOrder = ?, isActive = ? WHERE shipperID = ?";
            ps = conn.prepareStatement(shipperQuery);
            ps.setDate(1, shipper.getStartDate());
            ps.setDate(2, shipper.getEndDate());
            ps.setDouble(3, shipper.getBaseSalary());
            ps.setInt(4, shipper.getOrdersDelivered());
            ps.setDouble(5, shipper.getBonusPerOrder());
            ps.setBoolean(6, shipper.isActive());
            ps.setInt(7, shipper.getShipperID());
            
            int shipperRowsAffected = ps.executeUpdate();
            
            if (accountRowsAffected > 0 && shipperRowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
    }
    
    // Xóa shipper (hoặc đánh dấu là không hoạt động)
    public boolean deleteShipper(int shipperId) {
        // Thay vì xóa, chúng ta sẽ đánh dấu shipper là không hoạt động
        String query = "UPDATE ShipperDetails SET isActive = false WHERE shipperID = ?; " +
                      "UPDATE Account SET isActive = false WHERE accountID = ? AND role = 3";
        
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            ps = conn.prepareStatement(query);
            ps.setInt(1, shipperId);
            ps.setInt(2, shipperId);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources();
        }
    }
    
    // Kiểm tra xem username đã tồn tại chưa
    public boolean isUsernameExists(String username) {
        String query = "SELECT COUNT(*) FROM Account WHERE username = ?";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Kiểm tra xem email đã tồn tại chưa
    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM Account WHERE email = ?";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Kiểm tra xem số điện thoại đã tồn tại chưa
    public boolean isPhoneExists(String phone) {
        String query = "SELECT COUNT(*) FROM Account WHERE phone = ?";
        
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, phone);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Đóng các tài nguyên
    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // Phương thức đếm tổng số shipper
public int getTotalShippers() {
    String query = "SELECT COUNT(*) FROM Account WHERE role = 3";
    int count = 0;
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return count;
}

// Phương thức đếm số shipper đang hoạt động
public int getActiveShippersCount() {
    String query = "SELECT COUNT(*) FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
                  "WHERE a.role = 3 AND s.isActive = true";
    int count = 0;
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return count;
}

// Phương thức đếm số shipper đang làm việc (chưa đến ngày kết thúc)
public int getCurrentlyWorkingShippersCount() {
    String query = "SELECT COUNT(*) FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
                  "WHERE a.role = 3 AND s.isActive = true AND " +
                  "(s.endDate IS NULL OR s.endDate >= CURRENT_DATE())";
    int count = 0;
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return count;
}

// Phương thức thay đổi trạng thái hoạt động của shipper
public boolean toggleShipperStatus(int shipperId, boolean newStatus) {
    conn = new DBContext().getConnection();
    try {
        conn.setAutoCommit(false);
        
        // Cập nhật trạng thái trong bảng Account
        String accountQuery = "UPDATE Account SET isActive = ? WHERE accountID = ? AND role = 3";
        ps = conn.prepareStatement(accountQuery);
        ps.setBoolean(1, newStatus);
        ps.setInt(2, shipperId);
        
        int accountRowsAffected = ps.executeUpdate();
        
        // Cập nhật trạng thái trong bảng ShipperDetails
        String shipperQuery = "UPDATE ShipperDetails SET isActive = ? WHERE shipperID = ?";
        ps = conn.prepareStatement(shipperQuery);
        ps.setBoolean(1, newStatus);
        ps.setInt(2, shipperId);
        
        int shipperRowsAffected = ps.executeUpdate();
        
        if (accountRowsAffected > 0 && shipperRowsAffected > 0) {
            conn.commit();
            return true;
        } else {
            conn.rollback();
            return false;
        }
    } catch (SQLException e) {
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
        return false;
    } finally {
        try {
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        closeResources();
    }
}
// Lấy danh sách shipper có phân trang và sắp xếp
public List<Shipper> getAllShippersWithPaging(String sort, int offset, int limit) {
    List<Shipper> list = new ArrayList<>();
    
    // Tạo câu lệnh SQL cơ bản
    StringBuilder queryBuilder = new StringBuilder(
        "SELECT a.accountID, a.username, a.email, a.phone, s.startDate, s.endDate, " +
        "s.baseSalary, s.ordersDelivered, s.bonusPerOrder, s.isActive " +
        "FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
        "WHERE a.role = 3");
    
    // Thêm phần sắp xếp nếu có
    if (sort != null && !sort.isEmpty()) {
        switch (sort) {
            case "name":
                queryBuilder.append(" ORDER BY a.username");
                break;
            case "salary":
                queryBuilder.append(" ORDER BY s.baseSalary DESC");
                break;
            case "orders":
                queryBuilder.append(" ORDER BY s.ordersDelivered DESC");
                break;
            case "date":
                queryBuilder.append(" ORDER BY s.startDate DESC");
                break;
            default:
                queryBuilder.append(" ORDER BY a.accountID");
                break;
        }
    } else {
        queryBuilder.append(" ORDER BY a.accountID");
    }
    
    // Thêm phần phân trang
    queryBuilder.append(" LIMIT ? OFFSET ?");
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(queryBuilder.toString());
        ps.setInt(1, limit);
        ps.setInt(2, offset);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Shipper shipper = new Shipper(
                rs.getInt("accountID"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getDate("startDate"),
                rs.getDate("endDate"),
                rs.getDouble("baseSalary"),
                rs.getInt("ordersDelivered"),
                rs.getDouble("bonusPerOrder"),
                rs.getBoolean("isActive")
            );
            list.add(shipper);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return list;
}

// Lấy danh sách shipper theo trạng thái
public List<Shipper> getShippersByStatus(boolean isActive, String sort, int offset, int limit) {
    List<Shipper> list = new ArrayList<>();
    
    // Tạo câu lệnh SQL cơ bản
    StringBuilder queryBuilder = new StringBuilder(
        "SELECT a.accountID, a.username, a.email, a.phone, s.startDate, s.endDate, " +
        "s.baseSalary, s.ordersDelivered, s.bonusPerOrder, s.isActive " +
        "FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
        "WHERE a.role = 3 AND s.isActive = ?");
    
    // Thêm phần sắp xếp nếu có
    if (sort != null && !sort.isEmpty()) {
        switch (sort) {
            case "name":
                queryBuilder.append(" ORDER BY a.username");
                break;
            case "salary":
                queryBuilder.append(" ORDER BY s.baseSalary DESC");
                break;
            case "orders":
                queryBuilder.append(" ORDER BY s.ordersDelivered DESC");
                break;
            case "date":
                queryBuilder.append(" ORDER BY s.startDate DESC");
                break;
            default:
                queryBuilder.append(" ORDER BY a.accountID");
                break;
        }
    } else {
        queryBuilder.append(" ORDER BY a.accountID");
    }
    
    // Thêm phần phân trang
    queryBuilder.append(" LIMIT ? OFFSET ?");
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(queryBuilder.toString());
        ps.setBoolean(1, isActive);
        ps.setInt(2, limit);
        ps.setInt(3, offset);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Shipper shipper = new Shipper(
                rs.getInt("accountID"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getDate("startDate"),
                rs.getDate("endDate"),
                rs.getDouble("baseSalary"),
                rs.getInt("ordersDelivered"),
                rs.getDouble("bonusPerOrder"),
                rs.getBoolean("isActive")
            );
            list.add(shipper);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return list;
}

// Tìm kiếm shipper theo từ khóa
public List<Shipper> searchShippers(String keyword, String statusFilter, String sort, int offset, int limit) {
    List<Shipper> list = new ArrayList<>();
    
    // Tạo câu lệnh SQL cơ bản
    StringBuilder queryBuilder = new StringBuilder(
        "SELECT a.accountID, a.username, a.email, a.phone, s.startDate, s.endDate, " +
        "s.baseSalary, s.ordersDelivered, s.bonusPerOrder, s.isActive " +
        "FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
        "WHERE a.role = 3 AND (a.username LIKE ? OR a.email LIKE ? OR a.phone LIKE ?)");
    
    // Thêm điều kiện lọc theo trạng thái nếu có
    if (statusFilter != null && !statusFilter.isEmpty()) {
        boolean isActive = statusFilter.equals("active");
        queryBuilder.append(" AND s.isActive = ?");
    }
    
    // Thêm phần sắp xếp nếu có
    if (sort != null && !sort.isEmpty()) {
        switch (sort) {
            case "name":
                queryBuilder.append(" ORDER BY a.username");
                break;
            case "salary":
                queryBuilder.append(" ORDER BY s.baseSalary DESC");
                break;
            case "orders":
                queryBuilder.append(" ORDER BY s.ordersDelivered DESC");
                break;
            case "date":
                queryBuilder.append(" ORDER BY s.startDate DESC");
                break;
            default:
                queryBuilder.append(" ORDER BY a.accountID");
                break;
        }
    } else {
        queryBuilder.append(" ORDER BY a.accountID");
    }
    
    // Thêm phần phân trang
    queryBuilder.append(" LIMIT ? OFFSET ?");
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(queryBuilder.toString());
        
        String searchPattern = "%" + keyword + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        ps.setString(3, searchPattern);
        
        int paramIndex = 4;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            boolean isActive = statusFilter.equals("active");
            ps.setBoolean(paramIndex++, isActive);
        }
        
        ps.setInt(paramIndex++, limit);
        ps.setInt(paramIndex, offset);
        
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Shipper shipper = new Shipper(
                rs.getInt("accountID"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getDate("startDate"),
                rs.getDate("endDate"),
                rs.getDouble("baseSalary"),
                rs.getInt("ordersDelivered"),
                rs.getDouble("bonusPerOrder"),
                rs.getBoolean("isActive")
            );
            list.add(shipper);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return list;
}

// Đếm số lượng shipper theo trạng thái
public int countShippersByStatus(boolean isActive) {
    String query = "SELECT COUNT(*) FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
                  "WHERE a.role = 3 AND s.isActive = ?";
    int count = 0;
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        ps.setBoolean(1, isActive);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return count;
}

// Đếm số lượng kết quả tìm kiếm
public int countSearchResults(String keyword, String statusFilter) {
    StringBuilder queryBuilder = new StringBuilder(
        "SELECT COUNT(*) FROM Account a JOIN ShipperDetails s ON a.accountID = s.shipperID " +
        "WHERE a.role = 3 AND (a.username LIKE ? OR a.email LIKE ? OR a.phone LIKE ?)");
    
    // Thêm điều kiện lọc theo trạng thái nếu có
    if (statusFilter != null && !statusFilter.isEmpty()) {
        boolean isActive = statusFilter.equals("active");
        queryBuilder.append(" AND s.isActive = ?");
    }
    
    int count = 0;
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(queryBuilder.toString());
        
        String searchPattern = "%" + keyword + "%";
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);
        ps.setString(3, searchPattern);
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            boolean isActive = statusFilter.equals("active");
            ps.setBoolean(4, isActive);
        }
        
        rs = ps.executeQuery();
        
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return count;
}

// Lấy danh sách shipper đang hoạt động (chỉ từ bảng Account)
public List<Shipper> getActiveShippers() {
    List<Shipper> list = new ArrayList<>();
    String query = "SELECT accountID, username, email, phone, isActive " +
                  "FROM Account " +
                  "WHERE role = 3 AND isActive = true " +
                  "ORDER BY username";
    
    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Shipper shipper = new Shipper();
            shipper.setShipperID(rs.getInt("accountID"));
            shipper.setUsername(rs.getString("username"));
            shipper.setEmail(rs.getString("email"));
            shipper.setPhone(rs.getString("phone"));
            shipper.setActive(rs.getBoolean("isActive"));
            list.add(shipper);
        }
    } catch (SQLException e) {
        System.err.println("Error in getActiveShippers: " + e.getMessage());
        e.printStackTrace();
    } finally {
        closeResources();
    }
    
    return list;
}

}
