package DAO;

import Model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;

public class AccountDAO extends DBContext {
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private Connection conn = null;
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            // Không đóng connection vì nó được quản lý bởi DBContext
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Account login(String userInput, String password) {
        try {
            // Kiểm tra đầu vào
            if (userInput == null || password == null || userInput.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Thông tin đăng nhập trống");
                return null;
            }
            
            conn = getConnection();
            // Sửa câu query để thêm điều kiện phone.
            String query = "SELECT * FROM Account WHERE (email = ? OR username = ? OR phone = ?) AND password = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, userInput.trim());
            ps.setString(2, userInput.trim());
            ps.setString(3, userInput.trim());
            ps.setString(4, password);
            
            rs = ps.executeQuery();
            
            if(rs.next()) {
                return new Account(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("role"),
                    rs.getString("email"),
                    rs.getString("phone")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
     // Phương thức đăng ký tài khoản
    public boolean register(String username, String password, String email, String phone) {
        String query = "INSERT INTO Account (username, password, role, email, phone) VALUES (?, ?, 0, ?, ?)";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    public Account checkAccountExist(String username) {
        String query = "SELECT * FROM Account WHERE username = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("role"),
                    rs.getString("email"),
                    rs.getString("phone")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    public Account checkEmailExist(String email) {
        String query = "SELECT * FROM Account WHERE email = ?";
        try {
             conn = getConnection();
            ps = conn.prepareStatement(query); // Đã sửa từ connection thành conn
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("role"),
                    rs.getString("email"),
                    rs.getString("phone")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
     public Account findAccountByEmailOrPhone(String emailOrPhone) {
        String query = "SELECT * FROM Account WHERE email = ? OR phone = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, emailOrPhone);
            ps.setString(2, emailOrPhone);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Account(
                    rs.getInt("accountID"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("role"),
                    rs.getString("email"),
                    rs.getString("phone")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
     
     // Phương thức cập nhật mật khẩu
    public boolean updatePassword(String email, String newPassword) {
        String query = "UPDATE Account SET password = ? WHERE email = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Phương thức kiểm tra mật khẩu cũ trước khi đổi
    public boolean checkOldPassword(int accountID, String oldPassword) {
        String query = "SELECT * FROM Account WHERE accountID = ? AND password = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountID);
            ps.setString(2, oldPassword);
            rs = ps.executeQuery();
            return rs.next(); 
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    // Phương thức đổi mật khẩu
     public boolean changePassword(int accountID, String currentPassword, String newPassword) {
        // Đầu tiên kiểm tra mật khẩu hiện tại có đúng không
        String checkQuery = "SELECT * FROM Account WHERE accountID = ? AND password = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(checkQuery);
            ps.setInt(1, accountID);
            ps.setString(2, currentPassword);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Mật khẩu hiện tại đúng, tiến hành cập nhật mật khẩu mới
                String updateQuery = "UPDATE Account SET password = ? WHERE accountID = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newPassword);
                ps.setInt(2, accountID);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    // ... existing code ...

// Phương thức kiểm tra mật khẩu mới có giống mật khẩu cũ không
     public boolean isPasswordSameAsOld(String email, String newPassword) {
        String query = "SELECT * FROM Account WHERE email = ? AND password = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, newPassword);
            rs = ps.executeQuery();
        return rs.next(); // Trả về true nếu mật khẩu mới giống mật khẩu cũ
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return false;
}

    // Phương thức tạo mã xác nhận ngẫu nhiên
    public String generateResetToken() {
        // Tạo mã xác nhận ngẫu nhiên 6 chữ số
        return String.format("%06d", new java.util.Random().nextInt(999999));
    }

    public boolean changePassword(int accountID, String newPassword) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    // Phương thức cập nhật một trường cụ thể của tài khoản
    public boolean updateField(int accountID, String fieldName, String value) {
        String query = "UPDATE Account SET " + fieldName + " = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, value);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    // Thêm phương thức này vào cuối file, trước dấu } cuối cùng
public boolean updateProfileImage(int accountID, String imageUrl) {
    String query = "UPDATE Account SET img = ? WHERE accountID = ?";
    try {
        conn = getConnection();
        ps = conn.prepareStatement(query);
        ps.setString(1, imageUrl);
        ps.setInt(2, accountID);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return false;
}
}

