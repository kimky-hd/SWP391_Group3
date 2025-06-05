package DAO;

import Model.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class VoucherDAO extends DBContext {
    
    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT v.* FROM Voucher v WHERE v.voucherId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
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
        } catch (SQLException e) {
            System.out.println("getVoucherById: " + e.getMessage());
        }
        return null;
    }

    public boolean applyVoucherToOrder(int maHD, int voucherId, int accountId, double discountAmount) {
        String sql = "INSERT INTO VoucherOrder (maHD, voucherId, accountId, discountAmount) VALUES (?, ?, ?, ?)";
        String updateAccountVoucher = "UPDATE AccountVoucher SET isUsed = true, usedDate = CURRENT_TIMESTAMP WHERE accountId = ? AND voucherId = ?";
        String updateVoucherUsage = "UPDATE Voucher SET usedCount = usedCount + 1 WHERE voucherId = ?";
        
        try {
            connection.setAutoCommit(false);
            
            // Thêm vào bảng VoucherOrder
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, maHD);
            ps.setInt(2, voucherId);
            ps.setInt(3, accountId);
            ps.setDouble(4, discountAmount);
            ps.executeUpdate();
            
            // Cập nhật trạng thái đã sử dụng trong AccountVoucher
            ps = connection.prepareStatement(updateAccountVoucher);
            ps.setInt(1, accountId);
            ps.setInt(2, voucherId);
            ps.executeUpdate();
            
            // Tăng số lượt sử dụng của voucher
            ps = connection.prepareStatement(updateVoucherUsage);
            ps.setInt(1, voucherId);
            ps.executeUpdate();
            
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Rollback failed: " + ex.getMessage());
            }
            System.out.println("applyVoucherToOrder: " + e.getMessage());
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Reset autoCommit failed: " + e.getMessage());
            }
        }
    }

    public List<Voucher> getVouchersByAccountId(int accountId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT v.* FROM Voucher v " +
                    "JOIN AccountVoucher av ON v.voucherId = av.voucherId " +
                    "WHERE av.accountId = ? AND av.isUsed = false AND v.isActive = true " +
                    "AND CURRENT_TIMESTAMP BETWEEN v.startDate AND v.endDate";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
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
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            System.out.println("getVouchersByAccountId: " + e.getMessage());
        }
        return vouchers;
    }
    
    public boolean deleteVoucher(int voucherId) {
        String deleteVoucherOrder = "DELETE FROM VoucherOrder WHERE voucherId = ?";
        String deleteAccountVoucher = "DELETE FROM AccountVoucher WHERE voucherId = ?";
        String deleteVoucher = "DELETE FROM Voucher WHERE voucherId = ?";
        
        try {
            connection.setAutoCommit(false);
            
            // Xóa các bản ghi liên quan trong VoucherOrder
            PreparedStatement ps = connection.prepareStatement(deleteVoucherOrder);
            ps.setInt(1, voucherId);
            ps.executeUpdate();
            
            // Xóa các bản ghi liên quan trong AccountVoucher
            ps = connection.prepareStatement(deleteAccountVoucher);
            ps.setInt(1, voucherId);
            ps.executeUpdate();
            
            // Xóa voucher
            ps = connection.prepareStatement(deleteVoucher);
            ps.setInt(1, voucherId);
            ps.executeUpdate();
            
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Rollback failed: " + ex.getMessage());
            }
            System.out.println("deleteVoucher: " + e.getMessage());
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Reset autoCommit failed: " + e.getMessage());
            }
        }
    }
    
    public boolean useVoucher(int voucherId, int accountId) {
        String sql = "UPDATE Voucher SET is_used = 1 WHERE voucher_id = ? AND account_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("useVoucher: " + e.getMessage());
            return false;
        }
    }
}