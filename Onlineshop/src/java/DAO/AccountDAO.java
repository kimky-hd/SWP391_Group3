package DAO;

import Model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO extends DBContext {
    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Đăng nhập bằng username hoặc email và password.
     */
    public Account login(String userInput, String password) {
        try {
            if (userInput == null || password == null || userInput.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Thông tin đăng nhập trống");
                return null;
            }

            String query = "SELECT * FROM Account WHERE (email = ? OR username = ?) AND password = ?";
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, userInput.trim());
            ps.setString(2, userInput.trim());
            ps.setString(3, password);
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
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Đăng ký tài khoản mới.
     */
   public String register(String username, String password, String email, String phone) {
    String query = "INSERT INTO Account (username, password, role, email, phone) VALUES (?, ?, 0, ?, ?)";
    try {
        conn = new DBContext().getConnection();
        if (conn == null) {
            return "Không thể kết nối đến cơ sở dữ liệu";
        }
        ps = conn.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, password);
        ps.setString(3, email);
        ps.setString(4, phone);
        int result = ps.executeUpdate();
        if (result > 0) {
            return "success";
        } else {
            return "Đăng ký không thành công";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        if (e.getMessage().contains("Duplicate entry")) {
            if (e.getMessage().contains("username")) {
                return "Tên đăng nhập đã tồn tại";
            } else if (e.getMessage().contains("email")) {
                return "Email đã tồn tại";
            }
        }
        return "Lỗi: " + e.getMessage();
    } finally {
        closeResources();
    }
}

    /**
     * Kiểm tra username đã tồn tại chưa.
     */
    public Account checkAccountExist(String username) {
        String query = "SELECT * FROM Account WHERE username = ?";
        try {
            conn = new DBContext().getConnection();
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

    /**
     * Kiểm tra email đã tồn tại chưa.
     */
    public Account checkEmailExist(String email) {
        String query = "SELECT * FROM Account WHERE email = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
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
}
