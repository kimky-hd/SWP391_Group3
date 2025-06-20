package DAO;

import java.sql.*;
import java.util.*;
import Model.RevenueByMonth;
import DAO.DBContext;

public class RevenueDAO extends DBContext {

    public List<RevenueByMonth> getRevenuePerMonth() {
        List<RevenueByMonth> list = new ArrayList<>();
        String sql = "SELECT MONTH(ngayXuat) AS thang, SUM(tongGia) AS doanhThu "
                + "FROM HoaDon WHERE statusID = 2 GROUP BY MONTH(ngayXuat)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int month = rs.getInt("thang");
                double revenue = rs.getDouble("doanhThu");
                list.add(new RevenueByMonth(month, revenue));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
