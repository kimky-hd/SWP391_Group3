package DAO;

import java.sql.*;
import java.util.*;
import Model.RevenueByMonth;
import Model.RevenueByProduct;
import Model.RevenueByCustomer;

public class RevenueDAO extends DBContext {

    public List<RevenueByMonth> getRevenuePerMonth() {
        List<RevenueByMonth> list = new ArrayList<>();
        String sql = "SELECT MONTH(ngayXuat) AS thang, SUM(tongGia) AS doanhThu "
                + "FROM HoaDon WHERE statusID = 4 GROUP BY MONTH(ngayXuat)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

    // Tổng doanh thu toàn bộ sản phẩm đã bán
    public double getTotalRevenue() {
        String sql = "SELECT SUM(tongGia) AS total FROM HoaDon WHERE statusID = 4";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Tổng doanh thu theo tháng cụ thể  
    public double getTotalRevenueByMonth(int month) {
        String sql = "SELECT SUM(price * quantity) AS total FROM OrderDetail od "
                + "JOIN HoaDon hd ON od.maHD = hd.maHD WHERE hd.statusID = 4 AND MONTH(hd.ngayXuat) = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Tổng chi phí nhập hàng theo tháng
    public double getTotalImportCostByMonth(int month) {
        String sql = "SELECT SUM(mb.quantity * mb.importPrice) AS total " +
                     "FROM MaterialBatch mb WHERE MONTH(mb.dateImport) = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Tổng thiệt hại theo tháng
    public double getTotalDamagedCostByMonth(int month) {
        String sql = "SELECT SUM(mb.quantity * mb.importPrice) AS total " +
                     "FROM MaterialBatch mb WHERE mb.dateExpire < CURDATE() AND MONTH(mb.dateExpire) = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Thống kê số đơn theo trạng thái
    public Map<String, Integer> getOrderStatusSummary() {
        Map<String, Integer> summary = new LinkedHashMap<>();
        String sql = "SELECT s.name, COUNT(*) AS total FROM HoaDon hd "
                + "JOIN Status s ON hd.statusID = s.statusID GROUP BY s.name";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                summary.put(rs.getString("name"), rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }

    // Doanh thu theo từng sản phẩm
    public List<RevenueByProduct> getRevenueByProduct() {
        List<RevenueByProduct> list = new ArrayList<>();
        String sql = "SELECT p.title, SUM(od.quantity) AS totalSold, "
                + "SUM(od.price * od.quantity) AS totalRevenue "
                + "FROM OrderDetail od "
                + "JOIN Product p ON od.productID = p.productID "
                + "JOIN HoaDon hd ON od.maHD = hd.maHD "
                + "WHERE hd.statusID = 4 "
                + "GROUP BY p.title ORDER BY totalSold DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String title = rs.getString("title");
                int totalSold = rs.getInt("totalSold");
                double totalRevenue = rs.getDouble("totalRevenue");
                list.add(new RevenueByProduct(title, totalSold, totalRevenue));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Top khách hàng chi tiêu cao nhất
    public List<RevenueByCustomer> getTopCustomerSpending() {
        List<RevenueByCustomer> list = new ArrayList<>();
        String sql = "SELECT a.username, p.fullName, SUM(od.price * od.quantity) AS totalSpent "
                + "FROM Account a JOIN Profile p ON a.accountID = p.accountID "
                + "JOIN HoaDon hd ON a.accountID = hd.accountID "
                + "JOIN OrderDetail od ON hd.maHD = od.maHD "
                + "WHERE hd.statusID = 4 "
                + "GROUP BY a.username, p.fullName "
                + "ORDER BY totalSpent DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String username = rs.getString("username");
                String fullName = rs.getString("fullName");
                double totalSpent = rs.getDouble("totalSpent");
                list.add(new RevenueByCustomer(username, fullName, totalSpent));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RevenueByCustomer> getRevenueByCustomer() {
        List<RevenueByCustomer> list = new ArrayList<>();
        String sql = "SELECT a.username, il.name AS fullName, SUM(hd.tongGia) AS totalSpent "
                + "FROM HoaDon hd "
                + "JOIN InforLine il ON hd.maHD = il.maHD "
                + "JOIN Account a ON hd.accountID = a.accountID "
                + "WHERE hd.statusID = 4 "
                + "GROUP BY a.username, il.name "
                + "ORDER BY totalSpent DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String username = rs.getString("username");
                String fullName = rs.getString("fullName");
                double total = rs.getDouble("totalSpent");
                list.add(new RevenueByCustomer(username, fullName, total));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy doanh thu theo tháng (theo tháng được chọn trong dropdown)
    public List<RevenueByMonth> getRevenuePerMonthBySelectedMonth(int selectedMonth) {
        List<RevenueByMonth> list = new ArrayList<>();
        String sql = "SELECT MONTH(ngayXuat) AS thang, SUM(tongGia) AS doanhThu "
                + "FROM HoaDon WHERE statusID = 4 AND MONTH(ngayXuat) = ? "
                + "GROUP BY MONTH(ngayXuat)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, selectedMonth); // Thêm tháng vào query
            ResultSet rs = ps.executeQuery();
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

// Doanh thu theo sản phẩm tìm kiếm theo tên sản phẩm
    public List<RevenueByProduct> getRevenueByProductSearch(String productSearch) {
        List<RevenueByProduct> list = new ArrayList<>();
        String sql = "SELECT p.title, SUM(od.quantity) AS totalSold, "
                + "SUM(od.price * od.quantity) AS totalRevenue "
                + "FROM OrderDetail od "
                + "JOIN Product p ON od.productID = p.productID "
                + "JOIN HoaDon hd ON od.maHD = hd.maHD "
                + "WHERE hd.statusID = 4 AND p.title LIKE ? "
                + "GROUP BY p.title ORDER BY totalSold DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + productSearch + "%");  // Tìm kiếm theo tên sản phẩm
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String title = rs.getString("title");
                    int totalSold = rs.getInt("totalSold");
                    double totalRevenue = rs.getDouble("totalRevenue");
                    list.add(new RevenueByProduct(title, totalSold, totalRevenue));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<RevenueByCustomer> getRevenueByCustomerSearch(String userSearch) {
        List<RevenueByCustomer> list = new ArrayList<>();
        String sql = "SELECT a.username, il.name AS fullName, SUM(hd.tongGia) AS totalSpent "
                + "FROM HoaDon hd "
                + "JOIN InforLine il ON hd.maHD = il.maHD "
                + "JOIN Account a ON hd.accountID = a.accountID "
                + "WHERE hd.statusID = 4 AND (a.username LIKE ? OR il.name LIKE ?) "
                + "GROUP BY a.username, il.name "
                + "ORDER BY totalSpent DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + userSearch + "%");  // Tìm kiếm theo tên người dùng
            ps.setString(2, "%" + userSearch + "%");  // Tìm kiếm theo họ tên người dùng
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String username = rs.getString("username");
                    String fullName = rs.getString("fullName");
                    double totalSpent = rs.getDouble("totalSpent");
                    list.add(new RevenueByCustomer(username, fullName, totalSpent));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getOrderStatusSummaryByStatus(String statusSearch) {
        Map<String, Integer> summary = new LinkedHashMap<>();
        String sql = "SELECT s.name, COUNT(*) AS total FROM HoaDon hd "
                + "JOIN Status s ON hd.statusID = s.statusID "
                + "WHERE s.name LIKE ? GROUP BY s.name";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + statusSearch + "%");  // Tìm kiếm theo tên trạng thái
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    summary.put(rs.getString("name"), rs.getInt("total"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }

    // 5. Doanh thu hoa thiệt hại (hoa đã hết hạn)
    public Map<String, Object> getDamagedFlowerRevenue() {
        Map<String, Object> result = new HashMap<>();
        String sql = "SELECT m.name, mb.quantity, mb.importPrice, " +
                     "(mb.quantity * mb.importPrice) AS totalLoss " +
                     "FROM MaterialBatch mb " +
                     "JOIN Material m ON mb.materialID = m.materialID " +
                     "WHERE mb.dateExpire < CURDATE()";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            List<Map<String, Object>> details = new ArrayList<>();
            double totalLoss = 0;
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("materialName", rs.getString("name"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("importPrice", rs.getDouble("importPrice"));
                item.put("totalLoss", rs.getDouble("totalLoss"));
                details.add(item);
                totalLoss += rs.getDouble("totalLoss");
            }
            
            result.put("details", details);
            result.put("totalLoss", totalLoss);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 6. Doanh thu nhập hàng (từ bảng Material và MaterialBatch)
    public Map<String, Object> getImportRevenue() {
        Map<String, Object> result = new HashMap<>();
        String sql = "SELECT m.name, mb.quantity, mb.importPrice, " +
                     "(mb.quantity * mb.importPrice) AS totalImport, " +
                     "mb.dateImport " +
                     "FROM MaterialBatch mb " +
                     "JOIN Material m ON mb.materialID = m.materialID " +
                     "ORDER BY mb.dateImport DESC";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            List<Map<String, Object>> details = new ArrayList<>();
            double totalImport = 0;
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("materialName", rs.getString("name"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("importPrice", rs.getDouble("importPrice"));
                item.put("totalImport", rs.getDouble("totalImport"));
                item.put("dateImport", rs.getDate("dateImport"));
                details.add(item);
                totalImport += rs.getDouble("totalImport");
            }
            
            result.put("details", details);
            result.put("totalImport", totalImport);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // Doanh thu nhập hàng theo tháng
    public List<Map<String, Object>> getImportRevenueByMonth() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT MONTH(mb.dateImport) AS month, " +
                     "SUM(mb.quantity * mb.importPrice) AS totalImport " +
                     "FROM MaterialBatch mb " +
                     "GROUP BY MONTH(mb.dateImport) " +
                     "ORDER BY month";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("month", rs.getInt("month"));
                item.put("totalImport", rs.getDouble("totalImport"));
                list.add(item);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Doanh thu thiệt hại theo tháng
    public List<Map<String, Object>> getDamagedRevenueByMonth() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT MONTH(mb.dateExpire) AS month, " +
                     "SUM(mb.quantity * mb.importPrice) AS totalDamaged " +
                     "FROM MaterialBatch mb " +
                     "WHERE mb.dateExpire < CURDATE() " +
                     "GROUP BY MONTH(mb.dateExpire) " +
                     "ORDER BY month";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("month", rs.getInt("month"));
                item.put("totalDamaged", rs.getDouble("totalDamaged"));
                list.add(item);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
