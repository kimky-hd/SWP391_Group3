package DAO;

import Model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private Connection conn = null;

    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
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
            // Sửa câu query để thêm điều kiện phone và isActive
            String query = "SELECT * FROM Account WHERE (email = ? OR username = ? OR phone = ?) AND password = ? AND isActive = TRUE";
            ps = conn.prepareStatement(query);
            ps.setString(1, userInput.trim());
            ps.setString(2, userInput.trim());
            ps.setString(3, userInput.trim());
            ps.setString(4, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                return new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // Phương thức đăng ký tài khoản

    public boolean register(String username, String password, String email, String phone) {
        String query = "INSERT INTO Account (username, password, role, email, phone, isActive) VALUES (?, ?, 0, ?, ?, TRUE)";
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
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
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
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
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
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
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
        String updateQuery = "UPDATE Account SET password = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(updateQuery);
            ps.setString(1, newPassword);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
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

    // Phương thức kiểm tra tài khoản Google đã tồn tại chưa
    public Account checkGoogleAccountExist(String email) {
        String query = "SELECT * FROM Account WHERE email = ? AND googleId IS NOT NULL";
        try {
            conn = getConnection();
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
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    // Phương thức đăng ký tài khoản Google mới
    public Account registerGoogleAccount(String email, String name, String googleId, String picture) {
        // Tạo username dựa trên email (loại bỏ phần @...)
        String username = email.split("@")[0];

        // Tạo mật khẩu ngẫu nhiên (sẽ không được sử dụng vì đăng nhập qua Google)
        String password = generateRandomPassword();

        String query = "INSERT INTO Account (username, password, role, email, googleId, img, isActive) VALUES (?, ?, 0, ?, ?, ?, TRUE)";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, googleId);
            ps.setString(5, picture);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int accountID = rs.getInt(1);
                    return new Account(accountID, username, password, 0, email, null, true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    // Phương thức cập nhật thông tin Google ID cho tài khoản đã tồn tại
    public boolean updateGoogleId(String email, String googleId, String picture) {
        String query = "UPDATE Account SET googleId = ?, img = ? WHERE email = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, googleId);
            ps.setString(2, picture);
            ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Phương thức tạo mật khẩu ngẫu nhiên
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 12; i++) {
            int index = random.nextInt(chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    // Phương thức đăng nhập bằng Google
    public Account loginWithGoogle(String email, String googleId) {
        String query = "SELECT * FROM Account WHERE email = ? AND googleId = ? AND isActive = TRUE";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, googleId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        String query = "SELECT * FROM Account";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account account = new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return accounts;
    }

    // Lấy tất cả tài khoản khách hàng (role = 0)
    public List<Account> getAllCustomers() {
        List<Account> customers = new ArrayList<>();
        String query = "SELECT * FROM Account WHERE role = 0";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account account = new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
                customers.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return customers;
    }

    // Lấy thông tin tài khoản theo ID
    public Account getAccountById(int accountID) {
        String query = "SELECT * FROM Account WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
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

    // Thêm tài khoản mới
    public boolean addAccount(Account account) {
        String query = "INSERT INTO Account (username, password, role, email, phone, isActive) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setInt(3, account.getRole());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setBoolean(6, account.isIsActive());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Cập nhật tài khoản
    public boolean updateAccount(Account account) {
        String query = "UPDATE Account SET username = ?, password = ?, role = ?, email = ?, phone = ?, isActive = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setInt(3, account.getRole());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setBoolean(6, account.isIsActive());
            ps.setInt(7, account.getAccountID());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Thay đổi trạng thái active của tài khoản thay vì xóa
    public boolean toggleAccountStatus(int accountID, boolean isActive) {
        String query = "UPDATE Account SET isActive = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setBoolean(1, isActive);
            ps.setInt(2, accountID);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Xóa tài khoản (giữ lại nhưng không nên sử dụng)
    public boolean deleteAccount(int accountID) {
        String query = "DELETE FROM Account WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountID);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }

    // Phân trang tài khoản
    public List<Account> getAccountsWithPaging(int page, int pageSize) {
        List<Account> accounts = new ArrayList<>();
        String query = "SELECT * FROM Account LIMIT ?, ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account account = new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return accounts;
    }

    // Phân trang khách hàng (role = 0)
    public List<Account> getCustomersWithPaging(int page, int pageSize) {
        List<Account> customers = new ArrayList<>();
        String query = "SELECT * FROM Account WHERE role = 0 LIMIT ?, ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account account = new Account(
                        rs.getInt("accountID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getInt("role"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getBoolean("isActive")
                );
                customers.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return customers;
    }

    // Đếm tổng số tài khoản
    public int getTotalAccounts() {
        String query = "SELECT COUNT(*) FROM Account";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
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

    // Đếm tổng số khách hàng (role = 0)
    public int getTotalCustomers() {
        String query = "SELECT COUNT(*) FROM Account WHERE role = 0";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
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
}
