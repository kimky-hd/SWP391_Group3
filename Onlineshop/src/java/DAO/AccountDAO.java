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
            String query = "SELECT * FROM Account WHERE (email = ? OR username = ?) AND password = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, userInput.trim());
            ps.setString(2, userInput.trim());
            ps.setString(3, password);
            
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
            ps = connection.prepareStatement(query);
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
