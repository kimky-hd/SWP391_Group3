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
import java.util.Map;
import java.util.HashMap;

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
        String orderSql = "INSERT INTO HoaDon (accountID, tongGia, ngayXuat, statusID, payment_method, cardId, cardFee) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

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
                ps.setString(5, order.getPaymentMethod()); // Thêm phương thức thanh toán
                if (order.getCardId() != null) {
                    ps.setInt(6, order.getCardId());
                } else {
                    ps.setNull(6, java.sql.Types.INTEGER);
                }
                if (order.getCardFee() != null) {
                    ps.setDouble(7, order.getCardFee());
                } else {
                    ps.setNull(7, java.sql.Types.DECIMAL);
                }

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
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, h.payment_method, h.cardId, h.cardFee, h.shippingID, "
                + "i.name, i.phoneNumber, i.email, i.address, "
                + "s.username as shipperName, s.email as shipperEmail, s.phone as shipperPhone "
                + "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD "
                + "LEFT JOIN Account s ON h.shippingID = s.accountID AND s.role = 3 "
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
                    // Bỏ comment dòng này để lấy phương thức thanh toán
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setTotal(rs.getDouble("tongGia"));
                    
                    // Set cardId and cardFee
                    order.setCardId(rs.getObject("cardId") != null ? rs.getInt("cardId") : null);
                    order.setCardFee(rs.getObject("cardFee") != null ? rs.getDouble("cardFee") : null);
                    
                    // Set shipper information
                    order.setShippingID(rs.getObject("shippingID") != null ? rs.getInt("shippingID") : null);
                    order.setShipperName(rs.getString("shipperName"));
                    order.setShipperEmail(rs.getString("shipperEmail"));
                    order.setShipperPhone(rs.getString("shipperPhone"));

                    // Chuyển đổi statusID dạng số thành chuỗi trạng thái dễ đọc
                    int statusID = rs.getInt("statusID");
                    String status;
                    switch (statusID) {
                        case 1:
                            status = "Chờ duyệt";
                            break;
                        case 2:
                            status = "Đơn hàng đã được duyệt và tiến hành đóng gói";
                            break;
                        case 3:
                            status = "Đơn hàng đang được vận chuyển";
                            break;
                        case 4:
                            status = "Đã giao hàng thành công";
                            break;
                        case 5:
                            status = "Đã thanh toán thành công";
                            break;
                        case 6:
                            status = "Đã hủy";
                            break;
                        case 7:
                            status = "Đã duyệt đơn hàng thiết kế riêng";
                            break;
                        case 8:
                            status = "Đơn hàng thiết kế riêng bị từ chối";
                            break;
                        default:
                            status = "Unknown";
                            break;
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
        String sql = "SELECT h.maHD, h.accountID, h.tongGia, h.ngayXuat, h.statusID, h.payment_method, h.cardId, h.cardFee, h.shippingID, "
                + "i.name, i.email, i.address, i.phoneNumber, "
                + "s.username as shipperName, s.email as shipperEmail, s.phone as shipperPhone "
                + "FROM HoaDon h LEFT JOIN InforLine i ON h.maHD = i.maHD "
                + "LEFT JOIN Account s ON h.shippingID = s.accountID AND s.role = 3 "
                + "WHERE h.maHD = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setTotal(rs.getDouble("tongGia"));

                    // Xử lý an toàn cho các trường có thể null từ bảng InforLine
                    order.setFullName(rs.getString("name") != null ? rs.getString("name") : "Khách hàng");
                    order.setPhone(rs.getString("phoneNumber") != null ? rs.getString("phoneNumber") : "N/A");
                    order.setEmail(rs.getString("email") != null ? rs.getString("email") : "N/A");
                    order.setAddress(rs.getString("address") != null ? rs.getString("address") : "N/A");
                    
                    // Set cardId and cardFee
                    order.setCardId(rs.getObject("cardId") != null ? rs.getInt("cardId") : null);
                    order.setCardFee(rs.getObject("cardFee") != null ? rs.getDouble("cardFee") : null);
                    
                    // Set shipper information
                    order.setShippingID(rs.getObject("shippingID") != null ? rs.getInt("shippingID") : null);
                    order.setShipperName(rs.getString("shipperName"));
                    order.setShipperEmail(rs.getString("shipperEmail"));
                    order.setShipperPhone(rs.getString("shipperPhone"));

                    // Chuyển đổi statusID thành chuỗi trạng thái
                    int statusID = rs.getInt("statusID");
                    order.setStatusId(statusID);
                    String statusText;
                    switch (statusID) {
                        case 1:
                            statusText = "Chờ duyệt";
                            break;
                        case 2:
                            statusText = "Đơn hàng đã được duyệt và tiến hành đóng gói";
                            break;
                        case 3:
                            statusText = "Đơn hàng đang được vận chuyển";
                            break;
                        case 4:
                            statusText = "Đã giao hàng thành công";
                            break;
                        case 5:
                            statusText = "Đã thanh toán thành công";
                            break;
                        case 6:
                            statusText = "Đã hủy";
                            break;
                        case 7:
                            statusText = "Đã duyệt đơn hàng thiết kế riêng";
                            break;
                        case 8:
                            statusText = "Đơn hàng thiết kế riêng bị từ chối";
                            break;
                        default:
                            statusText = "Unknown";
                    }
                    order.setStatus(statusText);
                    return order;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error getting order by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Lấy danh sách các chi tiết đơn hàng (OrderDetail) dựa trên ID của đơn
     * hàng.
     *
     * @param orderId ID của đơn hàng mà các chi tiết thuộc về.
     * @return Một List các đối tượng OrderDetail của đơn hàng. Trả về danh sách
     * rỗng nếu không tìm thấy chi tiết nào hoặc có lỗi.
     */
    /**
     * Lấy tất cả đơn hàng từ cơ sở dữ liệu.
     *
     * @return Danh sách tất cả đơn hàng.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, h.payment_method, h.cardId, h.cardFee, i.name, i.phoneNumber, i.email, i.address "
                + "FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD "
                + "ORDER BY h.ngayXuat DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("maHD"));
                order.setAccountId(rs.getInt("accountID"));
                order.setOrderDate(rs.getDate("ngayXuat"));
                order.setTotal(rs.getDouble("tongGia"));

                // Chuyển đổi statusID thành chuỗi trạng thái
                int statusID = rs.getInt("statusID");
                String status;
                switch (statusID) {
                    case 1:
                        status = "Chờ duyệt";
                        break;
                    case 2:
                        status = "Đơn hàng đã được duyệt và tiến hành đóng gói";
                        break;
                    case 3:
                        status = "Đơn hàng đang được vận chuyển";
                        break;
                    case 4:
                        status = "Đã giao hàng thành công";
                        break;
                    case 5:
                        status = "Đã thanh toán thành công";
                        break;
                    case 6:
                        status = "Đã hủy";
                        break;
                    case 7:
                        status = "Đã duyệt đơn hàng thiết kế riêng";
                        break;
                    case 8:
                        status = "Đơn hàng thiết kế riêng bị từ chối";
                        break;
                    default:
                        status = "Unknown";
                        break;
                }
                order.setStatus(status);

                // Thiết lập thông tin người nhận
                order.setFullName(rs.getString("name"));
                order.setPhone(rs.getString("phoneNumber"));
                order.setEmail(rs.getString("email"));
                order.setAddress(rs.getString("address"));
                
                // Set cardId and cardFee
                order.setCardId(rs.getObject("cardId") != null ? rs.getInt("cardId") : null);
                order.setCardFee(rs.getObject("cardFee") != null ? rs.getDouble("cardFee") : null);

                orders.add(order);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all orders: " + e.getMessage());
            e.printStackTrace();
        }

        return orders;
    }

    /**
     * Cập nhật trạng thái đơn hàng.
     *
     * @param orderId ID của đơn hàng cần cập nhật.
     * @param statusId ID trạng thái mới.
     * @return true nếu cập nhật thành công, ngược lại là false.
     */
    public boolean updateOrderStatus(int orderId, int statusId) {
        String sql = "UPDATE HoaDon SET statusID = ? WHERE maHD = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, statusId);
            ps.setInt(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

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
        // Câu lệnh SQL để cập nhật statusID của đơn hàng thành 6 (Cancelled)
        // Chỉ cập nhật nếu statusID hiện tại là 1 (Pending)
        String sql = "UPDATE HoaDon SET statusID = 6 WHERE maHD = ? AND statusID = 1";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error cancelling order: " + e.getMessage());
            e.printStackTrace();
            return false;
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

    public int countTotalFilteredOrders(String status, String dateFrom, String dateTo, String customerName, String sortBy) {

        int count = 0;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total ");
        sql.append("FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Thêm điều kiện lọc
        if (status != null && !status.isEmpty()) {
            // Chuyển đổi status từ chuỗi sang số
            int statusId;
            switch (status.toLowerCase()) { // Đảm bảo chuyển đổi sang chữ thường để so sánh
                case "chờ duyệt":
                    statusId = 1;
                    break;
                case "đơn hàng đã được duyệt và tiến hành đóng gói":
                    statusId = 2;
                    break;
                case "đơn hàng đang được vận chuyển":
                    statusId = 3;
                    break;
                case "đã giao hàng thành công":
                    statusId = 4;
                    break;
                case "đã thanh toán thành công":
                    statusId = 5;
                    break;
                case "đã hủy":
                    statusId = 6;
                    break;
                case "đã duyệt đơn hàng thiết kế riêng":
                    statusId = 7;
                    break;
                case "đơn hàng thiết kế riêng bị từ chối":
                    statusId = 8;
                    break;
                // Giữ lại các case tiếng Anh để tương thích ngược
                case "pending":
                    statusId = 1;
                    break;
                case "completed":
                    statusId = 2;
                    break;
                case "cancelled":
                    statusId = 6;
                    break;
                case "delivered":
                    statusId = 4;
                    break;
                case "paid":
                    statusId = 5;
                    break;
                case "refunded":
                    statusId = 6;
                    break;
                default:
                    statusId = -1; // Không lọc nếu không khớp
                    break;
            }
            if (statusId > 0) {
                sql.append("AND h.statusID = ? ");
                params.add(statusId);
            }
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append("AND CONVERT(date, h.ngayXuat) >= ? ");
            params.add(dateFrom);
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append("AND CONVERT(date, h.ngayXuat) <= ? ");
            params.add(dateTo);
        }

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append("AND LOWER(i.name) LIKE LOWER(?) ");
            params.add("%" + customerName.trim() + "%");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            System.out.println("Error counting filtered orders: " + e.getMessage());
            e.printStackTrace();
        }

        return count;
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

    public Map<String, Object> getOrderStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        String sql = "SELECT "
                + "COUNT(*) as totalOrders, "
                + "SUM(CASE WHEN statusID = 1 THEN 1 ELSE 0 END) as pendingOrders, "
                + "SUM(CASE WHEN statusID = 2 THEN 1 ELSE 0 END) as completedOrders, "
                + "SUM(CASE WHEN statusID = 3 THEN 1 ELSE 0 END) as cancelledOrders, "
                + "SUM(CASE WHEN statusID = 4 THEN 1 ELSE 0 END) as deliveredOrders, "
                + "SUM(CASE WHEN statusID = 5 THEN 1 ELSE 0 END) as paidOrders, "
                + "SUM(CASE WHEN statusID = 6 THEN 1 ELSE 0 END) as refundedOrders, "
                + "SUM(tongGia) as totalRevenue "
                + "FROM HoaDon";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                statistics.put("totalOrders", rs.getInt("totalOrders"));
                statistics.put("pendingOrders", rs.getInt("pendingOrders"));
                statistics.put("completedOrders", rs.getInt("completedOrders"));
                statistics.put("cancelledOrders", rs.getInt("cancelledOrders"));
                statistics.put("deliveredOrders", rs.getInt("deliveredOrders"));
                statistics.put("paidOrders", rs.getInt("paidOrders"));
                statistics.put("refundedOrders", rs.getInt("refundedOrders"));
                statistics.put("totalRevenue", rs.getDouble("totalRevenue"));
            }

        } catch (SQLException e) {
            System.out.println("Error getting order statistics: " + e.getMessage());
            e.printStackTrace();
            // Trả về statistics rỗng nếu có lỗi
            statistics.put("totalOrders", 0);
            statistics.put("pendingOrders", 0);
            statistics.put("completedOrders", 0);
            statistics.put("cancelledOrders", 0);
            statistics.put("deliveredOrders", 0);
            statistics.put("paidOrders", 0);
            statistics.put("refundedOrders", 0);
            statistics.put("totalRevenue", 0.0);
        }

        return statistics;
    }

    public List<Order> getFilteredOrders(String status, String dateFrom, String dateTo, String customerName, int page, int size, String sortBy) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.maHD, h.accountID, h.ngayXuat, h.tongGia, h.statusID, h.cardId, h.cardFee, h.shippingID, ");
        sql.append("i.name, i.phoneNumber, i.email, i.address, ");
        sql.append("s.username as shipperName, s.email as shipperEmail, s.phone as shipperPhone ");
        sql.append("FROM HoaDon h JOIN InforLine i ON h.maHD = i.maHD ");
        sql.append("LEFT JOIN Account s ON h.shippingID = s.accountID AND s.role = 3 ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Thêm điều kiện lọc
        if (status != null && !status.isEmpty()) {
            // Chuyển đổi status từ chuỗi sang số
            int statusId;
            switch (status.toLowerCase()) { // Đảm bảo chuyển đổi sang chữ thường để so sánh
                case "Chờ duyệt":
                    statusId = 1;
                    break;
                case "Đơn hàng đã được duyệt và tiến hành đóng gói":
                    statusId = 2;
                    break;
                case "Đơn hàng đang được vận chuyển":
                    statusId = 3;
                    break;
                case "Đã giao hàng thành công":
                    statusId = 4;
                    break;
                case "Đã thanh toán thành công":
                    statusId = 5;
                    break;
                case "Đã hủy":
                    statusId = 6;
                    break;
                case "Đã duyệt đơn hàng thiết kế riêng":
                    statusId = 7;
                    break;
                case "Đơn hàng thiết kế riêng bị từ chối":
                    statusId = 8;
                    break;
                default:
                    statusId = -1; // Không lọc nếu không khớp
                    break;
            }
            if (statusId > 0) {
                sql.append("AND h.statusID = ? ");
                params.add(statusId);
            }
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            // Bỏ CONVERT function vì ngayXuat đã là kiểu DATE
            sql.append("AND h.ngayXuat >= ? ");
            params.add(dateFrom);
        }

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append("AND LOWER(i.name) LIKE LOWER(?) ");
            params.add("%" + customerName.trim() + "%");
        }

        // In ra câu truy vấn để debug
        System.out.println("SQL Query: " + sql.toString());
        System.out.println("Parameters: " + params);

        // Thêm ORDER BY clause dựa trên sortBy
        String orderClause = "";
        switch (sortBy) {
            case "date_asc":
                orderClause = " ORDER BY h.ngayXuat ASC";
                break;
            case "total_desc":
                orderClause = " ORDER BY h.tongGia DESC";
                break;
            case "total_asc":
                orderClause = " ORDER BY h.tongGia ASC";
                break;
            case "status":
                orderClause = " ORDER BY h.statusID, h.ngayXuat DESC";
                break;
            case "order_id":
                orderClause = " ORDER BY h.maHD DESC";
                break;
            default: // date_desc - sắp xếp theo mã đơn lớn nhất (đơn mới nhất)
                orderClause = " ORDER BY h.maHD DESC";
                break;
        }
        sql.append(orderClause);
        sql.append(" ");

        // Thêm phân trang
        int offset = (page - 1) * size;
        sql.append("LIMIT ? OFFSET ?");  // MySQL sử dụng LIMIT thay vì FETCH
        params.add(size);
        params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
                System.out.println("Param " + (i + 1) + ": " + params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("maHD"));
                    order.setAccountId(rs.getInt("accountID"));
                    order.setOrderDate(rs.getTimestamp("ngayXuat"));
                    order.setTotal(rs.getDouble("tongGia"));
                    order.setFullName(rs.getString("name"));
                    order.setPhone(rs.getString("phoneNumber"));
                    order.setEmail(rs.getString("email"));
                    order.setAddress(rs.getString("address"));
                    
                    // Set cardId and cardFee
                    order.setCardId(rs.getObject("cardId") != null ? rs.getInt("cardId") : null);
                    order.setCardFee(rs.getObject("cardFee") != null ? rs.getDouble("cardFee") : null);
                    
                    // Set shipper information
                    order.setShippingID(rs.getObject("shippingID") != null ? rs.getInt("shippingID") : null);
                    order.setShipperName(rs.getString("shipperName"));
                    order.setShipperEmail(rs.getString("shipperEmail"));
                    order.setShipperPhone(rs.getString("shipperPhone"));

                    // Chuyển đổi statusID thành chuỗi trạng thái
                    int statusID = rs.getInt("statusID");
                    order.setStatusId(statusID);
                    String statusText;
                    switch (statusID) {
                        case 1:
                            statusText = "Pending";
                            break;
                        case 2:
                            statusText = "Completed";
                            break;
                        case 3:
                            statusText = "Cancelled";
                            break;
                        case 4:
                            statusText = "Delivered";
                            break;
                        case 5:
                            statusText = "Paid";
                            break;
                        case 6:
                            statusText = "Refunded";
                            break;
                        default:
                            statusText = "Unknown";
                    }
                    order.setStatus(statusText);

                    orders.add(order);
                }

                // In ra số lượng kết quả tìm được
                System.out.println("Found " + orders.size() + " orders");
            }

        } catch (SQLException e) {
            System.out.println("Error getting filtered orders: " + e.getMessage());
            e.printStackTrace();
        }

        return orders;
    }

    public Map<String, String> getOrderInfoForNotification(int orderId) {
        String sql = "SELECT h.maHD, h.tongGia, h.ngayXuat, h.statusID, s.name as statusName, i.name, i.email, i.address, i.phoneNumber "
                + "FROM HoaDon h "
                + "LEFT JOIN InforLine i ON h.maHD = i.maHD "
                + "LEFT JOIN status s ON h.statusID = s.statusID "
                + "WHERE h.maHD = ?";

        Map<String, String> result = new HashMap<>();

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                result.put("name", rs.getString("name"));
                result.put("email", rs.getString("email"));
                result.put("address", rs.getString("address"));
                result.put("phoneNumber", rs.getString("phoneNumber"));
                result.put("status", rs.getString("statusName")); // Sử dụng alias statusName
                result.put("statusId", String.valueOf(rs.getInt("statusID")));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    
    // Cập nhật shippingID cho đơn hàng
    public boolean updateShippingID(int orderId, int shipperId) {
        String sql = "UPDATE HoaDon SET shippingID = ? WHERE maHD = ?";
        
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shipperId);
            ps.setInt(2, orderId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
