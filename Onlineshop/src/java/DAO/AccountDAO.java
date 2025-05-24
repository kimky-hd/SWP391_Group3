package DAO;

import Model.Account;
import java.sql.*;

public class AccountDAO extends DBContext {
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    public Account login(String userInput, String password) {
        try {
            // Kiểm tra đầu vào
            if (userInput == null || password == null || userInput.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Thông tin đăng nhập trống");
                return null;
            }
            
            String query = "SELECT * FROM Account WHERE (email = ? OR username = ?) AND password = ?";
            ps = connection.prepareStatement(query);
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
                    rs.getString("email")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
