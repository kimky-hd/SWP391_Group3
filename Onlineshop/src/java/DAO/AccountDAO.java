package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Account;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import DAO.DBContext;
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
        public boolean register(String username, String password, String email, String phone) {
        String query = "INSERT INTO Account (username, password, role, email, phone) VALUES (?, ?, 1, ?, ?)";
        try {
            conn = this.connection;

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
           conn = this.connection; 
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
           conn = this.connection; 
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