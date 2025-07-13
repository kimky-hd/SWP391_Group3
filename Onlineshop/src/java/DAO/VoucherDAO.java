package DAO;

import Model.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class VoucherDAO extends DBContext {
    
    // Lấy voucher theo ID
    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT * FROM Voucher WHERE voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapVoucher(rs);
            }
        } catch (SQLException e) {
            System.out.println("getVoucherById: " + e.getMessage());
        }
        return null;
    }

    // Lấy tất cả vouchers có sẵn (chỉ những voucher đang active và chưa hết hạn)
    public List<Voucher> getAllAvailableVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = """
                    SELECT * FROM Voucher 
                    WHERE isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN startDate AND endDate
                    AND usedCount < usageLimit
                    ORDER BY created_date DESC, discountAmount DESC
                    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllAvailableVouchers: " + e.getMessage());
        }
        return vouchers;
    }

    // Lấy danh sách voucher với trạng thái đã thêm vào account hay chưa
    public List<Voucher> getVouchersWithAccountStatus(int accountId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = """
                    SELECT v.*, 
                           CASE WHEN av.accountId IS NOT NULL THEN true ELSE false END as isAdded,
                           CASE WHEN av.isUsed IS NOT NULL THEN av.isUsed ELSE false END as isUsed
                    FROM Voucher v 
                    LEFT JOIN AccountVoucher av ON v.voucherId = av.voucherId AND av.accountId = ?
                    WHERE v.isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate
                    AND v.usedCount < v.usageLimit
                    ORDER BY v.created_date DESC, v.discountAmount DESC
                    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher voucher = mapVoucher(rs);
                voucher.setIsUsed(rs.getBoolean("isUsed"));
                voucher.setIsAdded(rs.getBoolean("isAdded"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            System.out.println("getVouchersWithAccountStatus: " + e.getMessage());
        }
        return vouchers;
    }

    // Kiểm tra voucher đã được thêm vào account chưa
    public boolean isVoucherAddedToAccount(int accountId, int voucherId) {
        String sql = "SELECT 1 FROM AccountVoucher WHERE accountId = ? AND voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setInt(2, voucherId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("isVoucherAddedToAccount: " + e.getMessage());
            return false;
        }
    }

    // Thêm voucher vào tài khoản người dùng
    public boolean addVoucherToAccount(int accountId, int voucherId) {
        // Kiểm tra xem voucher đã được thêm vào account chưa
        if (isVoucherAddedToAccount(accountId, voucherId)) {
            return false; // Đã tồn tại
        }

        String sql = "INSERT INTO AccountVoucher (accountId, voucherId, isUsed, assignedDate) VALUES (?, ?, false, CURRENT_TIMESTAMP)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setInt(2, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("addVoucherToAccount: " + e.getMessage());
            return false;
        }
    }

    // Lấy danh sách voucher của account (đã thêm vào tài khoản)
    public List<Voucher> getVouchersByAccountId(int accountId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = """
                    SELECT v.*, av.isUsed 
                    FROM Voucher v 
                    JOIN AccountVoucher av ON v.voucherId = av.voucherId 
                    WHERE av.accountId = ? 
                    AND v.isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate
                    ORDER BY av.assignedDate DESC
                    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher voucher = mapVoucher(rs);
                voucher.setIsUsed(rs.getBoolean("isUsed"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            System.out.println("getVouchersByAccountId: " + e.getMessage());
        }
        return vouchers;
    }
    
    // Lấy danh sách voucher hợp lệ của account để sử dụng
    public List<Voucher> getValidVouchersByAccountId(int accountId, double total) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = """
                    SELECT v.* 
                    FROM Voucher v 
                    JOIN AccountVoucher av ON v.voucherId = av.voucherId 
                    WHERE av.accountId = ? 
                    AND av.isUsed = false 
                    AND v.isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate
                    AND v.usedCount < v.usageLimit
                    AND v.minOrderValue <= ?
                    ORDER BY v.discountAmount DESC
                    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setDouble(2, total);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getValidVouchersByAccountId: " + e.getMessage());
        }
        return vouchers;
    }

    // Cập nhật trạng thái sử dụng voucher
    public boolean updateVoucherUsage(int voucherId) {
        String sql = "UPDATE Voucher SET usedCount = usedCount + 1 WHERE voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateVoucherUsage: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật trạng thái AccountVoucher
    public boolean updateAccountVoucherStatus(int accountId, int voucherId) {
        String sql = "UPDATE AccountVoucher SET isUsed = true, usedDate = CURRENT_TIMESTAMP WHERE accountId = ? AND voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setInt(2, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateAccountVoucherStatus: " + e.getMessage());
            return false;
        }
    }

    // Kiểm tra voucher có hợp lệ không
    public boolean isVoucherValid(int voucherId, int accountId) {
        String sql = """
                    SELECT 1 FROM Voucher v 
                    JOIN AccountVoucher av ON v.voucherId = av.voucherId 
                    WHERE v.voucherId = ? 
                    AND av.accountId = ? 
                    AND av.isUsed = false 
                    AND v.isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate 
                    AND v.usedCount < v.usageLimit
                    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            ps.setInt(2, accountId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("isVoucherValid: " + e.getMessage());
            return false;
        }
    }

    // Helper method để map ResultSet thành Voucher object - CẬP NHẬT
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher voucher = new Voucher();
        voucher.setVoucherId(rs.getInt("voucherId"));
        voucher.setCode(rs.getString("code"));
        voucher.setDiscountAmount(rs.getDouble("discountAmount"));
        voucher.setMinOrderValue(rs.getDouble("minOrderValue"));
        voucher.setStartDate(rs.getTimestamp("startDate"));
        voucher.setEndDate(rs.getTimestamp("endDate"));
        voucher.setIsActive(rs.getBoolean("isActive"));
        voucher.setUsageLimit(rs.getInt("usageLimit"));
        voucher.setUsedCount(rs.getInt("usedCount"));
        voucher.setDescription(rs.getString("description"));
        voucher.setCreatedDate(rs.getTimestamp("created_date")); // Thêm dòng này
        return voucher;
    }

    // Lấy tất cả vouchers với phân trang - CẬP NHẬT
    public List<Voucher> getAllVouchersWithPaging(int page, int pageSize) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Voucher ORDER BY  voucherId ASC LIMIT ? OFFSET ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllVouchersWithPaging: " + e.getMessage());
        }
        return vouchers;
    }

    public int getTotalVouchers() {
        String sql = "SELECT COUNT(*) FROM Voucher";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getTotalVouchers: " + e.getMessage());
        }
        return 0;
    }

    public boolean checkVoucherCodeExist(String code) {
        String sql = "SELECT 1 FROM Voucher WHERE code = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("checkVoucherCodeExist: " + e.getMessage());
            return false;
        }
    }

    // Thêm voucher mới - CẬP NHẬT
    public boolean addVoucher(Voucher voucher) {
        String sql = "INSERT INTO Voucher (code, discountAmount, minOrderValue, startDate, endDate, isActive, usageLimit, usedCount, description, created_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, voucher.getCode());
            ps.setDouble(2, voucher.getDiscountAmount());
            ps.setDouble(3, voucher.getMinOrderValue());
            ps.setTimestamp(4, new Timestamp(voucher.getStartDate().getTime()));
            ps.setTimestamp(5, new Timestamp(voucher.getEndDate().getTime()));
            ps.setBoolean(6, voucher.isActive());
            ps.setInt(7, voucher.getUsageLimit());
            ps.setInt(8, voucher.getUsedCount());
            ps.setString(9, voucher.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in addVoucher: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật voucher - KHÔNG thay đổi created_date
    public boolean updateVoucher(Voucher voucher) {
        String sql = "UPDATE Voucher SET code = ?, discountAmount = ?, minOrderValue = ?, startDate = ?, endDate = ?, usageLimit = ?, description = ? WHERE voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, voucher.getCode());
            ps.setDouble(2, voucher.getDiscountAmount());
            ps.setDouble(3, voucher.getMinOrderValue());
            ps.setTimestamp(4, new Timestamp(voucher.getStartDate().getTime()));
            ps.setTimestamp(5, new Timestamp(voucher.getEndDate().getTime()));
            ps.setInt(6, voucher.getUsageLimit());
            ps.setString(7, voucher.getDescription());
            ps.setInt(8, voucher.getVoucherId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateVoucher: " + e.getMessage());
            return false;
        }
    }

    public boolean toggleVoucherStatus(int voucherId, boolean status) {
        String sql = "UPDATE Voucher SET isActive = ? WHERE voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, status);
            ps.setInt(2, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("toggleVoucherStatus: " + e.getMessage());
            return false;
        }
    }

    // Method mới: Lấy vouchers theo khoảng thời gian tạo
    public List<Voucher> getVouchersByDateRange(Date startDate, Date endDate) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE created_date BETWEEN ? AND ? ORDER BY created_date DESC";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setTimestamp(1, new Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new Timestamp(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getVouchersByDateRange: " + e.getMessage());
        }
        return vouchers;
    }

    // Method mới: Lấy vouchers mới nhất
    public List<Voucher> getRecentVouchers(int limit) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Voucher ORDER BY created_date DESC LIMIT ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getRecentVouchers: " + e.getMessage());
        }
        return vouchers;
    }
}
