package DAO;

import Model.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class VoucherDAO extends DBContext {
    
    public List<Voucher> getVouchersByAccountId(int accountId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE accountId = ? AND isUsed = 0";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherId(rs.getInt("voucherId"));
                voucher.setAccountId(rs.getInt("accountId"));
                voucher.setCode(rs.getString("code"));
                voucher.setDiscountAmount(rs.getDouble("discountAmount"));
                voucher.setExpiryDate(rs.getDate("expiryDate"));
                voucher.setIsUsed(rs.getBoolean("isUsed"));
                vouchers.add(voucher);
            }
        } catch (SQLException e) {
            System.out.println("getVouchersByAccountId: " + e.getMessage());
        }
        return vouchers;
    }
    
    public boolean deleteVoucher(int voucherId, int accountId) {
        String sql = "DELETE FROM Voucher WHERE voucher_id = ? AND account_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, voucherId);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteVoucher: " + e.getMessage());
            return false;
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