package DAO;

import Model.Staff;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StaffDAO extends DBContext {
    
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private Connection conn = null;

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Chuyển đổi java.util.Date sang java.sql.Date
    private java.sql.Date convertToSqlDate(Date utilDate) {
        if (utilDate == null) return null;
        return new java.sql.Date(utilDate.getTime());
    }

    // Chuyển đổi java.sql.Date sang java.util.Date
    private Date convertToUtilDate(java.sql.Date sqlDate) {
        if (sqlDate == null) return null;
        return new Date(sqlDate.getTime());
    }

    // Lấy tất cả nhân viên (role = 2) với thông tin chi tiết
    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        String sql = """
            SELECT a.accountID, a.username, a.email, a.phone, a.isActive,
                   sd.startMonth, sd.endMonth, sd.salary
            FROM Account a
            LEFT JOIN StaffDetails sd ON a.accountID = sd.staffID
            WHERE a.role = 2
            ORDER BY a.accountID
            """;
        
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Staff staff = new Staff(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getBoolean("isActive"),
                    convertToUtilDate(rs.getDate("startMonth")),
                    convertToUtilDate(rs.getDate("endMonth")),
                    rs.getBigDecimal("salary")
                );
                staffList.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return staffList;
    }

    // Lấy nhân viên theo ID
    public Staff getStaffById(int staffID) {
        String sql = """
            SELECT a.accountID, a.username, a.email, a.phone, a.isActive,
                   sd.startMonth, sd.endMonth, sd.salary
            FROM Account a
            LEFT JOIN StaffDetails sd ON a.accountID = sd.staffID
            WHERE a.accountID = ? AND a.role = 2
            """;
        
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, staffID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Staff(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getBoolean("isActive"),
                    convertToUtilDate(rs.getDate("startMonth")),
                    convertToUtilDate(rs.getDate("endMonth")),
                    rs.getBigDecimal("salary")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        
        return null;
    }

    // Thêm nhân viên mới - CÓ CẢ NGÀY KẾT THÚC
    public boolean addStaff(String username, String password, String email, String phone,
                           Date startMonth, Date endMonth, BigDecimal salary) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // 1. Thêm vào bảng Account
            String accountSql = "INSERT INTO Account (username, password, role, email, phone, isActive) VALUES (?, ?, 2, ?, ?, TRUE)";
            PreparedStatement accountPs = conn.prepareStatement(accountSql, Statement.RETURN_GENERATED_KEYS);
            accountPs.setString(1, username);
            accountPs.setString(2, password);
            accountPs.setString(3, email);
            accountPs.setString(4, phone);
            
            int result = accountPs.executeUpdate();
            if (result > 0) {
                // Lấy ID vừa tạo
                ResultSet keys = accountPs.getGeneratedKeys();
                if (keys.next()) {
                    int staffID = keys.getInt(1);
                    
                    // 2. Thêm vào bảng StaffDetails
                    String staffSql = "INSERT INTO StaffDetails (staffID, startMonth, endMonth, salary) VALUES (?, ?, ?, ?)";
                    PreparedStatement staffPs = conn.prepareStatement(staffSql);
                    staffPs.setInt(1, staffID);
                    staffPs.setDate(2, convertToSqlDate(startMonth));
                    staffPs.setDate(3, convertToSqlDate(endMonth)); // Thêm endMonth
                    staffPs.setBigDecimal(4, salary);
                    
                    int staffResult = staffPs.executeUpdate();
                    if (staffResult > 0) {
                        conn.commit();
                        return true;
                    }
                }
            }
            
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
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
        }
    }

    // Cập nhật thông tin nhân viên
    public boolean updateStaff(int staffID, String username, String email, String phone,
                              Date startMonth, Date endMonth, BigDecimal salary) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // 1. Cập nhật bảng Account
            String accountSql = "UPDATE Account SET username = ?, email = ?, phone = ? WHERE accountID = ?";
            PreparedStatement accountPs = conn.prepareStatement(accountSql);
            accountPs.setString(1, username);
            accountPs.setString(2, email);
            accountPs.setString(3, phone);
            accountPs.setInt(4, staffID);
            
            int accountResult = accountPs.executeUpdate();
            
            // 2. Cập nhật hoặc thêm mới StaffDetails
            String checkSql = "SELECT COUNT(*) FROM StaffDetails WHERE staffID = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, staffID);
            ResultSet checkRs = checkPs.executeQuery();
            
            boolean hasStaffDetails = false;
            if (checkRs.next()) {
                hasStaffDetails = checkRs.getInt(1) > 0;
            }
            
            String staffSql;
            PreparedStatement staffPs;
            
            if (hasStaffDetails) {
                // Update existing record
                staffSql = "UPDATE StaffDetails SET startMonth = ?, endMonth = ?, salary = ? WHERE staffID = ?";
                staffPs = conn.prepareStatement(staffSql);
                staffPs.setDate(1, convertToSqlDate(startMonth));
                staffPs.setDate(2, convertToSqlDate(endMonth));
                staffPs.setBigDecimal(3, salary);
                staffPs.setInt(4, staffID);
            } else {
                // Insert new record
                staffSql = "INSERT INTO StaffDetails (staffID, startMonth, endMonth, salary) VALUES (?, ?, ?, ?)";
                staffPs = conn.prepareStatement(staffSql);
                staffPs.setInt(1, staffID);
                staffPs.setDate(2, convertToSqlDate(startMonth));
                staffPs.setDate(3, convertToSqlDate(endMonth));
                staffPs.setBigDecimal(4, salary);
            }
            
            int staffResult = staffPs.executeUpdate();
            
            if (accountResult >= 0 && staffResult > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
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
        }
    }
    // Kích hoạt/vô hiệu hóa nhân viên
    public boolean toggleStaffStatus(int staffID, boolean isActive) {
        String sql = "UPDATE Account SET isActive = ? WHERE accountID = ? AND role = 2";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, staffID);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Đếm tổng số nhân viên
    public int getTotalStaff() {
        String sql = "SELECT COUNT(*) FROM Account WHERE role = 2";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    // Đếm nhân viên đang hoạt động
    public int getActiveStaffCount() {
        String sql = "SELECT COUNT(*) FROM Account WHERE role = 2 AND isActive = TRUE";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    // Đếm nhân viên đang làm việc
    public int getCurrentlyWorkingStaffCount() {
        String sql = """
            SELECT COUNT(*) FROM Account a
            LEFT JOIN StaffDetails sd ON a.accountID = sd.staffID
            WHERE a.role = 2 AND a.isActive = TRUE 
            AND (sd.endMonth IS NULL OR sd.endMonth > CURDATE())
            """;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return 0;
    }

    // Kiểm tra username đã tồn tại
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Account WHERE username = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
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

    // Kiểm tra email đã tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Account WHERE email = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
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

    // Kiểm tra số điện thoại đã tồn tại
    public boolean isPhoneExists(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        
        String sql = "SELECT COUNT(*) FROM Account WHERE phone = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
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

    // Kiểm tra username đã tồn tại (loại trừ ID hiện tại)
    public boolean isUsernameExistsExcludeId(String username, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Account WHERE username = ? AND accountID != ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, excludeId);
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

    // Kiểm tra email đã tồn tại (loại trừ ID hiện tại)
    public boolean isEmailExistsExcludeId(String email, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Account WHERE email = ? AND accountID != ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setInt(2, excludeId);
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

    // Kiểm tra số điện thoại đã tồn tại (loại trừ ID hiện tại)
    public boolean isPhoneExistsExcludeId(String phone, int excludeId) {
        if (phone == null || phone.trim().isEmpty()) return false;
        
        String sql = "SELECT COUNT(*) FROM Account WHERE phone = ? AND accountID != ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, excludeId);
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
}
