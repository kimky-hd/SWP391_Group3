package DAO;

import Model.Order;
import Model.OrderDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import DAO.DBContext;

// Lớp OrderDAO kế thừa từ DBContext để có thể kết nối với cơ sở dữ liệu.
public class OrderDAO extends DBContext {

    /**
     * Tạo một đơn hàng mới và các chi tiết đơn hàng liên quan vào cơ sở dữ
     * liệu. Hàm này thực hiện một transaction để đảm bảo tính toàn vẹn dữ liệu:
     * nếu bất kỳ thao tác chèn nào thất bại, toàn bộ transaction sẽ được
     * rollback.
     *
     * @param order Đối tượng Order chứa thông tin tổng quát của đơn hàng.
     * @param orderDetails Danh sách các đối tượng OrderDetail chứa thông tin
     * chi tiết sản phẩm trong đơn hàng.
     * @return true nếu đơn hàng và chi tiết đơn hàng được tạo thành công, ngược
     * lại là false.
     */
    public boolean createOrder(Order order, List<OrderDetail> orderDetails) {
        // Câu lệnh SQL để chèn dữ liệu vào bảng HoaDon (Đơn hàng chính)
        String orderSql = "INSERT INTO HoaDon (accountID, tongGia, ngayXuat, statusID) "
                + "VALUES (?, ?, ?, ?)";

        // Câu lệnh SQL để chèn dữ liệu vào bảng InforLine (Thông tin người nhận/khách hàng)
        String infoSql = "INSERT INTO InforLine (maHD, name, email, address, phoneNumber) "
                + "VALUES (?, ?, ?, ?, ?)";

        // Câu lệnh SQL để chèn dữ liệu vào bảng OrderDetail (Chi tiết sản phẩm của đơn hàng)
        String detailSql = "INSERT INTO OrderDetail (maHD, productID, price, quantity) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection()) { // Lấy kết nối từ DBContext
            conn.setAutoCommit(false); // Tắt chế độ auto-commit để bắt đầu transaction

            // Chèn dữ liệu vào bảng HoaDon và lấy về ID của đơn hàng vừa tạo (maHD)
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                // Thiết lập các tham số cho câu lệnh SQL chèn vào bảng HoaDon
                ps.setInt(1, order.getAccountId());
                ps.setDouble(2, order.getTotal());
                ps.setDate(3, new java.sql.Date(order.getOrderDate().getTime()));
                ps.setInt(4, 1); // Đặt trạng thái mặc định là "Pending" (Đang chuẩn bị) (statusID = 1)

                int affectedRows = ps.executeUpdate(); // Thực thi câu lệnh chèn

                if (affectedRows == 0) {
                    // Nếu không có hàng nào bị ảnh hưởng, có nghĩa là không thể tạo đơn hàng
                    throw new SQLException("Creating order failed, no rows affected.");
                }

                // Lấy ID tự động tạo (maHD) của đơn hàng vừa chèn
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1); // Lấy maHD

                        // Chèn thông tin khách hàng vào bảng InforLine
                        try (PreparedStatement infoPs = conn.prepareStatement(infoSql)) {
                            infoPs.setInt(1, orderId); // Sử dụng maHD vừa lấy được
                            infoPs.setString(2, order.getFullName());
                            infoPs.setString(3, order.getEmail());
                            infoPs.setString(4, order.getAddress());
                            infoPs.setString(5, order.getPhone());
                            infoPs.executeUpdate(); // Thực thi câu lệnh chèn
                        }

                        // Chèn chi tiết đơn hàng vào bảng OrderDetail
                        try (PreparedStatement detailPs = conn.prepareStatement(detailSql)) {
                            for (OrderDetail detail : orderDetails) {
                                // Thiết lập các tham số cho mỗi chi tiết đơn hàng
                                detailPs.setInt(1, orderId); // Sử dụng maHD
                                detailPs.setInt(2, detail.getProductId());
                                detailPs.setDouble(3, detail.getPrice());
                                detailPs.setInt(4, detail.getQuantity());
                                detailPs.addBatch(); // Thêm vào batch để thực thi hàng loạt, cải thiện hiệu suất
                            }
                            detailPs.executeBatch(); // Thực thi tất cả các câu lệnh trong batch
                        }
                    } else {
                        // Nếu không lấy được ID, ném ngoại lệ
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            conn.commit(); // Nếu tất cả các thao tác thành công, commit transaction
            return true; // Trả về true báo hiệu thành công

        } catch (SQLException e) {
            // Xử lý lỗi nếu có bất kỳ ngoại lệ SQL nào xảy ra
            System.out.println("Error creating order: " + e.getMessage());
            e.printStackTrace(); // In stack trace để debug
            return false; // Trả về false báo hiệu thất bại
        }
    }

    /**
     * Lấy danh sách các đơn hàng (Order) dựa trên ID tài khoản của người dùng.
     * Hàm này trả về thông tin tổng quát của các đơn hàng và thông tin người
     * nhận.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Một List các đối tượng Order thuộc về accountId này. Trả về danh
     * sách rỗng nếu không tìm thấy đơn hàng nào hoặc có lỗi.
     */
    public List<Order> getOrdersByAccountId(int accountId) {
        List<Order> orders = new ArrayList<>(); // Khởi tạo danh sách để lưu trữ các đơn hàng
        // Câu lệnh SQL JOIN giữa HoaDon và InforLine để lấy thông tin đơn hàng và thông tin người nhận
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, i.name, i.phoneNumber, i.email, i.address "
                + "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD "
                + "WHERE h.accountID = ? ORDER BY h.maHD DESC"; // Sắp xếp theo maHD giảm dần

        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, accountId); // Đặt tham số accountID vào câu lệnh SQL

            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn và lấy kết quả
                while (rs.next()) { // Duyệt qua từng hàng kết quả
                    Order order = new Order(); // Tạo đối tượng Order mới
                    // Set các thuộc tính cho đối tượng Order từ dữ liệu trong ResultSet
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setFullName(rs.getString("name"));
                    order.setPhone(rs.getString("phoneNumber"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    // Lưu ý: Cột payment_method không có trong SQL hiện tại, nên dòng này bị comment
                    // order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotal(rs.getDouble("tongGia"));

                    // Chuyển đổi statusID dạng số thành chuỗi trạng thái dễ đọc
                    int statusID = rs.getInt("statusID");
                    String status;
                    switch (statusID) {
                        case 1:
                            status = "Pending"; // Đang chờ xử lý
                            break;
                        case 2:
                            status = "Completed"; // Đã hoàn thành
                            break;
                        case 3:
                            status = "Cancelled"; // Đã hủy
                            break;
                        default:
                            status = "Unknown"; // Trạng thái không xác định
                    }
                    order.setStatus(status); // Set trạng thái cho đối tượng Order

                    orders.add(order); // Thêm Order vào danh sách
                }
            }

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error getting orders: " + e.getMessage());
            e.printStackTrace();
        }

        return orders; // Trả về danh sách các đơn hàng
    }

    /**
     * Lấy thông tin chi tiết của một đơn hàng (Order) dựa trên ID đơn hàng. Hàm
     * này tương tự như getOrdersByAccountId nhưng chỉ lấy một đơn hàng cụ thể.
     *
     * @param orderId ID của đơn hàng cần lấy.
     * @return Đối tượng Order nếu tìm thấy, ngược lại là null.
     */
    public Order getOrderById(int orderId) {
        // Câu lệnh SQL JOIN giữa HoaDon và InforLine để lấy thông tin đơn hàng và thông tin người nhận
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, i.name, i.phoneNumber, i.email, i.address "
                + "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD "
                + "WHERE h.maHD = ?"; // Lọc theo maHD

        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, orderId); // Đặt tham số orderId

            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn
                if (rs.next()) { // Nếu tìm thấy một hàng kết quả
                    Order order = new Order(); // Tạo đối tượng Order
                    // Set các thuộc tính tương tự như hàm getOrdersByAccountId
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setFullName(rs.getString("name"));
                    order.setPhone(rs.getString("phoneNumber"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    order.setTotal(rs.getDouble("tongGia"));

                    // Chuyển đổi statusID dạng số thành chuỗi trạng thái
                    int statusID = rs.getInt("statusID");
                    String status;
                    switch (statusID) {
                        case 1:
                            status = "Pending";
                            break;
                        case 2:
                            status = "Completed";
                            break;
                        case 3:
                            status = "Cancelled";
                            break;
                        default:
                            status = "Unknown";
                    }
                    order.setStatus(status);

                    return order; // Trả về đối tượng Order tìm được
                }
            }

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error getting order: " + e.getMessage());
            e.printStackTrace();
        }

        return null; // Trả về null nếu không tìm thấy đơn hàng hoặc có lỗi
    }

    /**
     * Lấy danh sách các chi tiết đơn hàng (OrderDetail) dựa trên ID của đơn
     * hàng.
     *
     * @param orderId ID của đơn hàng mà các chi tiết thuộc về.
     * @return Một List các đối tượng OrderDetail của đơn hàng. Trả về danh sách
     * rỗng nếu không tìm thấy chi tiết nào hoặc có lỗi.
     */
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> details = new ArrayList<>(); // Khởi tạo danh sách chi tiết đơn hàng
        String sql = "SELECT * FROM OrderDetail WHERE maHD = ?"; // Câu lệnh SQL để lấy tất cả chi tiết của một đơn hàng

        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, orderId); // Đặt tham số maHD

            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn
                while (rs.next()) { // Duyệt qua từng hàng kết quả
                    OrderDetail detail = new OrderDetail(); // Tạo đối tượng OrderDetail mới
                    // Lưu ý: Cột order_detail_id không có trong SQL hiện tại, nên dòng này bị comment
                    // detail.setOrderDetailId(rs.getInt("order_detail_id"));
                    detail.setOrderId(rs.getInt("maHD"));
                    detail.setProductId(rs.getInt("productID"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setPrice(rs.getDouble("price"));
                    // Tính tổng tiền cho từng chi tiết đơn hàng (giá * số lượng)
                    double total = rs.getDouble("price") * rs.getInt("quantity");
                    detail.setTotal(total);
                    details.add(detail); // Thêm chi tiết vào danh sách
                }
            }

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error getting order details: " + e.getMessage());
            e.printStackTrace();
        }

        return details; // Trả về danh sách chi tiết đơn hàng
    }

    /**
     * Hủy một đơn hàng bằng cách cập nhật trạng thái của nó trong cơ sở dữ
     * liệu. Chỉ những đơn hàng có trạng thái "Pending" (statusID = 1) mới có
     * thể được hủy.
     *
     * @param orderId ID của đơn hàng cần hủy.
     * @return true nếu đơn hàng được hủy thành công (trạng thái được cập nhật),
     * ngược lại là false.
     */
    public boolean cancelOrder(int orderId) {
        // Câu lệnh SQL để cập nhật statusID của đơn hàng thành 3 (Cancelled)
        // Chỉ cập nhật nếu statusID hiện tại là 1 (Pending)
        String sql = "UPDATE HoaDon SET statusID = 3 WHERE maHD = ? AND statusID = 1";

        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, orderId); // Đặt tham số orderId

            int rowsAffected = ps.executeUpdate(); // Thực thi cập nhật và lấy số hàng bị ảnh hưởng
            return rowsAffected > 0; // Trả về true nếu có ít nhất một hàng bị ảnh hưởng (cập nhật thành công)

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error cancelling order: " + e.getMessage());
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi
        }
    }

    /**
     * Đếm tổng số đơn hàng của một tài khoản cụ thể.
     *
     * @param accountId ID của tài khoản người dùng.
     * @return Số lượng đơn hàng của tài khoản đó. Trả về 0 nếu không có hoặc có
     * lỗi.
     */
    public int countOrdersByAccountId(int accountId) {
        String sql = "SELECT COUNT(*) FROM HoaDon WHERE accountID = ?"; // Câu lệnh SQL để đếm số lượng
        try (Connection conn = getConnection(); // Lấy kết nối
                 PreparedStatement ps = conn.prepareStatement(sql)) { // Chuẩn bị câu lệnh SQL

            ps.setInt(1, accountId); // Đặt tham số accountId

            try (ResultSet rs = ps.executeQuery()) { // Thực thi truy vấn
                if (rs.next()) { // Nếu có kết quả
                    return rs.getInt(1); // Lấy giá trị của cột đầu tiên (COUNT(*))
                }
            }

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error counting orders: " + e.getMessage());
        }

        return 0; // Trả về 0 nếu không có đơn hàng hoặc có lỗi
    }

    /**
     * Xóa một đơn hàng cùng với tất cả các chi tiết liên quan (OrderDetail và
     * InforLine) khỏi cơ sở dữ liệu. Hàm này thực hiện một transaction để đảm
     * bảo rằng tất cả các thao tác xóa đều thành công hoặc không có thao tác
     * nào được thực hiện nếu có lỗi.
     *
     * @param orderId ID của đơn hàng cần xóa.
     * @return true nếu đơn hàng và các chi tiết liên quan được xóa thành công,
     * ngược lại là false.
     */
    public boolean deleteOrder(int orderId) {
        // Câu lệnh SQL để xóa các chi tiết đơn hàng
        String deleteDetailsSQL = "DELETE FROM OrderDetail WHERE maHD = ?";
        // Câu lệnh SQL để xóa thông tin khách hàng liên quan đến đơn hàng
        String deleteInfoSQL = "DELETE FROM InforLine WHERE maHD = ?";
        // Câu lệnh SQL để xóa đơn hàng chính
        String deleteOrderSQL = "DELETE FROM HoaDon WHERE maHD = ?";

        Connection conn = null; // Khởi tạo Connection là null
        try {
            conn = getConnection(); // Lấy kết nối
            conn.setAutoCommit(false); // Tắt auto-commit để bắt đầu transaction

            // Xóa chi tiết đơn hàng trước
            try (PreparedStatement ps = conn.prepareStatement(deleteDetailsSQL)) {
                ps.setInt(1, orderId);
                ps.executeUpdate(); // Thực thi xóa
            }

            // Xóa thông tin khách hàng liên quan đến đơn hàng
            try (PreparedStatement ps = conn.prepareStatement(deleteInfoSQL)) {
                ps.setInt(1, orderId);
                ps.executeUpdate(); // Thực thi xóa
            }

            // Xóa đơn hàng chính
            try (PreparedStatement ps = conn.prepareStatement(deleteOrderSQL)) {
                ps.setInt(1, orderId);
                int rowsAffected = ps.executeUpdate(); // Thực thi xóa và lấy số hàng bị ảnh hưởng

                if (rowsAffected > 0) {
                    conn.commit(); // Nếu xóa thành công đơn hàng chính, commit transaction
                    return true;
                } else {
                    conn.rollback(); // Nếu không có hàng nào bị ảnh hưởng (không tìm thấy đơn hàng), rollback
                    return false;
                }
            }

        } catch (SQLException e) {
            // Xử lý lỗi nếu có ngoại lệ SQL
            System.out.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction nếu có lỗi
                } catch (SQLException ex) {
                    System.out.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            return false;
        } finally {
            // Đảm bảo rằng kết nối được đóng và auto-commit được đặt lại
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Đặt lại auto-commit về true
                    conn.close(); // Đóng kết nối
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
}
