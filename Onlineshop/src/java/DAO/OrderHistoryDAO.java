package DAO;

import java.sql.*;
import java.util.*;
import Model.OrderHistoryEntry;



public class OrderHistoryDAO extends DBContext {
    public List<OrderHistoryEntry> getAllOrderHistory() {
        List<OrderHistoryEntry> list = new ArrayList<>();
        String query = """
            SELECT hd.maHD, a.username, hd.ngayXuat, hd.tongGia, s.name AS status,
                   pr.title, od.price, od.quantity
            FROM HoaDon hd
            JOIN Account a ON hd.accountID = a.accountID
            JOIN Status s ON hd.statusID = s.statusID
            JOIN OrderDetail od ON hd.maHD = od.maHD
            JOIN Product pr ON od.productID = pr.productID
            ORDER BY hd.ngayXuat DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderHistoryEntry entry = new OrderHistoryEntry(
                    rs.getInt("maHD"),
                    rs.getString("username"),
                    null,
                    rs.getDate("ngayXuat"),
                    rs.getBigDecimal("tongGia"),
                    rs.getString("status"),
                    rs.getString("title"),
                    rs.getBigDecimal("price"),
                    rs.getInt("quantity")
                );
                list.add(entry);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static void main(String[] args) {
    OrderHistoryDAO dao = new OrderHistoryDAO();
    List<OrderHistoryEntry> history = dao.getAllOrderHistory();
    
    if (history.isEmpty()) {
        System.out.println("Không có lịch sử đơn hàng nào.");
    } else {
        for (OrderHistoryEntry entry : history) {
            System.out.println("Mã HĐ: " + entry.getMaHD());
            System.out.println("Username: " + entry.getUsername());
            System.out.println("Ngày xuất: " + entry.getNgayXuat());
            System.out.println("Trạng thái: " + entry.getStatus());
            System.out.println("Sản phẩm: " + entry.getProductTitle());
            System.out.println("Đơn giá: " + entry.getProductPrice());
            System.out.println("Số lượng: " + entry.getQuantity());
            System.out.println("Tổng đơn: " + entry.getTongGia());
            System.out.println("-----------------------------");
        }
    }
}
} 

