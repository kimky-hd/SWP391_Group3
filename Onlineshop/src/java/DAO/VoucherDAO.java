package DAO;

import Model.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

    // Lấy danh sách voucher của account
    public List<Voucher> getVouchersByAccountId(int accountId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = """
                    SELECT v.* 
                    FROM Voucher v 
                    JOIN AccountVoucher av ON v.voucherId = av.voucherId 
                    WHERE av.accountId = ? 
                    AND av.isUsed = false 
                    AND v.isActive = true 
                    AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate
                    """;
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                vouchers.add(mapVoucher(rs));
            }
        } catch (SQLException e) {
            System.out.println("getVouchersByAccountId: " + e.getMessage());
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

    // Helper method để map ResultSet thành Voucher object
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
        return voucher;
    }
}
