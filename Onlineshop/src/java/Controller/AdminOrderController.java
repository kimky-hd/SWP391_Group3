package Controller;

import DAO.CartDAO;
import DAO.DBContext;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.ShipperDAO;
import Model.Order;
import Model.OrderDetail;
import Model.Product;
import Model.Account;
import Utility.EmailSender;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/orders"})
public class AdminOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final ShipperDAO shipperDAO = new ShipperDAO();
    private final Gson gson = new Gson();

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    if (!checkAdminAccess(request, response)) return;
    
    String action = request.getParameter("action");
    if (action == null) action = "list";
    
    try {
        switch (action) {
    case "list":
        handleFilterOrders(request, response);
        break;
    case "detail":
        viewOrderDetail(request, response);
        break;
    case "print":
        printOrder(request, response);
        break;
    case "searchCustomers":
        searchCustomers(request, response);
        break;
    case "quickSearch":
        handleQuickSearch(request, response);
        break;
    case "getOrderDetails":  
    getOrderDetailsForNotification(request, response); 
    break;
    case "getShippers":
        getShippers(request, response);
        break;  
default:
    handleFilterOrders(request, response);
    break;
}
    } catch (Exception e) {
        handleError(request, response, e);
    }
}


private void searchCustomers(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        String query = request.getParameter("query");
        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("{\"customers\":[]}");
            return;
        }
        
        // Tìm kiếm khách hàng theo tên
       List<Order> orders = orderDAO.getFilteredOrders(null, null, null, query, 1, 10, "date_desc");
        
        // Tạo danh sách khách hàng unique
        Map<String, CustomerInfo> uniqueCustomers = new HashMap<>();
        
        for (Order order : orders) {
            String customerKey = order.getFullName() + "_" + order.getEmail();
            if (!uniqueCustomers.containsKey(customerKey)) {
                CustomerInfo customer = new CustomerInfo();
                customer.setFullName(order.getFullName());
                customer.setEmail(order.getEmail());
                customer.setOrderCount(1);
                uniqueCustomers.put(customerKey, customer);
            } else {
                uniqueCustomers.get(customerKey).incrementOrderCount();
            }
        }
        
        // Chuyển đổi sang JSON
        List<CustomerInfo> customerList = new ArrayList<>(uniqueCustomers.values());
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("customers", customerList);
        
        response.getWriter().write(gson.toJson(jsonResponse));
        
    } catch (Exception e) {
        sendJsonError(response, "Lỗi tìm kiếm: " + e.getMessage());
    }
}

// Thêm class helper
class CustomerInfo {
    private String fullName;
    private String email;
    private int orderCount;
    
    // Getters and setters
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public int getOrderCount() { return orderCount; }
    public void setOrderCount(int orderCount) { this.orderCount = orderCount; }
    
    public void incrementOrderCount() { this.orderCount++; }
}



private void handleFilterOrders(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Lấy tham số filter
        String customerName = request.getParameter("customerName");
        if (customerName != null) {
            customerName = customerName.trim();
            if (customerName.isEmpty()) {
                customerName = null;
            }
        }
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String sortBy = request.getParameter("sortBy");
if (sortBy == null || sortBy.isEmpty()) {
    sortBy = "order_id"; // Mặc định sắp xếp theo ID đơn hàng tăng dần
}
        // In ra các tham số để debug
        System.out.println("Filter parameters: customerName=" + customerName + ", status=" + status + ", dateFrom=" + dateFrom + ", dateTo=" + dateTo);
        
        // Tham số phân trang
        int page = 1;
        int size = 10;
        
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
            String sizeParam = request.getParameter("size");
            if (sizeParam != null && !sizeParam.isEmpty()) {
                size = Integer.parseInt(sizeParam);
            }
        } catch (NumberFormatException e) {
            // Sử dụng giá trị mặc định
        }
        
        // Lấy danh sách đơn hàng đã lọc
        List<Order> orders;
        int totalOrders = 0;
        
       orders = orderDAO.getFilteredOrders(status, dateFrom, dateTo, customerName, page, size, sortBy);
totalOrders = orderDAO.countTotalFilteredOrders(status, dateFrom, dateTo, customerName, sortBy);
        
        // Tính toán thông tin phân trang
        int totalPages = (int) Math.ceil((double) totalOrders / size);
        
        // Tính toán thống kê
        Map<String, Object> statistics = orderDAO.getOrderStatistics();
        
        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("statistics", statistics);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalOrders);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", status);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("sortBy", sortBy);
        
        // Thêm thông báo nếu không tìm thấy kết quả
        if (orders.isEmpty() && (customerName != null || status != null || dateFrom != null || dateTo != null)) {
            request.setAttribute("noResultsMessage", "Không tìm thấy đơn hàng nào phù hợp với bộ lọc.");
        }
        
        request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
        
    } catch (Exception e) {
        System.out.println("Error in handleFilterOrders: " + e.getMessage());
        e.printStackTrace();
        handleError(request, response, e);
    }
}

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // Kiểm tra quyền admin
    if (!checkAdminAccess(request, response)) return;
    
    String action = request.getParameter("action");
    
    try {
        switch (action) {
            case "update":
            case "updateStatus":  // Thêm case này
                updateOrderStatus(request, response);
                break;
            
            case "notify":  // THÊM CASE NÀY
                sendCustomNotification(request, response);
                break;
            case "assignShipper":
                assignShipper(request, response);
                break;
            
            default:
                sendJsonError(response, "Hành động không được hỗ trợ");
                break;
        }
    } catch (Exception e) {
        sendJsonError(response, "Lỗi hệ thống: " + e.getMessage());
    }
}

    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() != 2) {
            response.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }

    private void viewAllOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Lấy thông tin đơn hàng
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng");
                viewAllOrders(request, response);
                return;
            }
            
            // Set phương thức thanh toán mặc định
            if (order.getPaymentMethod() == null || order.getPaymentMethod().isEmpty()) {
                order.setPaymentMethod("Thanh toán khi nhận hàng (COD)");
            }
            
            // Lấy chi tiết đơn hàng và gán thông tin sản phẩm
            List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
            for (OrderDetail detail : details) {
                try {
                    Product product = productDAO.getProductById(String.valueOf(detail.getProductId()));
                    if (product != null) {
                        detail.setProduct(product);
                    } else {
                        // Tạo product dummy
                        Product dummyProduct = new Product();
                        dummyProduct.setProductID(detail.getProductId());
                        dummyProduct.setTitle("Sản phẩm không tồn tại");
                        dummyProduct.setImage("/img/no-image.jpg");
                        dummyProduct.setPrice(detail.getPrice());
                        detail.setProduct(dummyProduct);
                    }
                } catch (Exception e) {
                    // Tạo product dummy cho trường hợp lỗi
                    Product dummyProduct = new Product();
                    dummyProduct.setProductID(detail.getProductId());
                    dummyProduct.setTitle("Lỗi tải sản phẩm");
                    dummyProduct.setImage("/img/no-image.jpg");
                    dummyProduct.setPrice(detail.getPrice());
                    detail.setProduct(dummyProduct); 
                }
            }
            
            // Tính toán thông tin bổ sung
            double subtotal = details.stream().mapToDouble(OrderDetail::getTotal).sum();
            double shippingFee = 30000;
            
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", details);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            
            request.getRequestDispatcher("admin/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ");
            viewAllOrders(request, response);
        }
    }
private String createOrderDetailsHtml(List<OrderDetail> orderDetails) {
    StringBuilder html = new StringBuilder();
    html.append("<table style='width: 100%; border-collapse: collapse;'>");
    html.append("<tr style='background-color: #f2f2f2;'>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: left;'>Sản phẩm</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: center;'>Số lượng</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Đơn giá</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Thành tiền</th>");
    html.append("</tr>");
    
    double totalAmount = 0;
    for (OrderDetail detail : orderDetails) {
        // Lấy thông tin sản phẩm
        Product product = productDAO.getProductById(detail.getProductId());
       String productName = (product != null) ? product.getTitle() : "Sản phẩm không xác định";
        
        double itemTotal = detail.getPrice() * detail.getQuantity();
        totalAmount += itemTotal;
        
        
        html.append("<tr>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px;'>").append(productName).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: center;'>").append(detail.getQuantity()).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", detail.getPrice())).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", itemTotal)).append("</td>");
        html.append("</tr>");
    }
    
    html.append("<tr style='background-color: #f9f9f9; font-weight: bold;'>");
    html.append("<td colspan='3' style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Tổng cộng:</td>");
    html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", totalAmount)).append("</td>");
    html.append("</tr>");
    html.append("</table>");
    
    return html.toString();
}
    
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        String orderIdParam = request.getParameter("orderId");
        String statusIdParam = request.getParameter("statusId");
        
        if (orderIdParam == null || statusIdParam == null) {
            sendJsonError(response, "Thiếu tham số");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        int statusId = Integer.parseInt(statusIdParam);
        
        if (statusId < 1 || statusId > 6) {
            sendJsonError(response, "Mã trạng thái không hợp lệ");
            return;
        }
        
        // Lấy trạng thái hiện tại của đơn hàng
        Order currentOrder = orderDAO.getOrderById(orderId);
        if (currentOrder == null) {
            sendJsonError(response, "Không tìm thấy đơn hàng");
            return;
        }
        
        boolean success = false;
        String message = "";
        if (statusId == 2 && currentOrder.getStatusId() != 2) {
    // Cập nhật trạng thái đơn hàng
    success = orderDAO.updateOrderStatus(orderId, statusId);
    
    if (success) {
        // Gửi email thông báo duyệt đơn hàng
        try {
            // Kiểm tra thông tin email trước khi gửi
            if (currentOrder.getEmail() == null || currentOrder.getEmail().trim().isEmpty()) {
                System.err.println("Email khách hàng không hợp lệ: " + currentOrder.getEmail());
                message = "Đơn hàng đã được duyệt nhưng không có email khách hàng để gửi thông báo";
            } else {
                // Lấy chi tiết đơn hàng để tạo nội dung email
                List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
                String orderDetailsHtml = createOrderDetailsHtml(orderDetails);
                
                System.out.println("Đang gửi email đến: " + currentOrder.getEmail());
                System.out.println("Tên khách hàng: " + currentOrder.getFullName());
                
                // Gửi email xác nhận
                boolean emailSent = EmailSender.sendOrderConfirmationEmail(
                    currentOrder.getEmail(),
                    orderDetailsHtml,
                    currentOrder.getFullName(),
                    String.valueOf(orderId)
                );
                
                if (emailSent) {
                    message = "Đơn hàng đã được duyệt và email thông báo đã được gửi";
                } else {
                    message = "Đơn hàng đã được duyệt nhưng không thể gửi email thông báo";
                }
            }
        } catch (Exception emailError) {
            System.err.println("Chi tiết lỗi khi gửi email: ");
            System.err.println("- Loại lỗi: " + emailError.getClass().getSimpleName());
            System.err.println("- Thông báo: " + emailError.getMessage());
            emailError.printStackTrace();
            message = "Đơn hàng đã được duyệt nhưng có lỗi khi gửi email: " + emailError.getMessage();
        }
    } else {
        message = "Cập nhật thất bại";
    }
}
        // Kiểm tra nếu chuyển sang trạng thái "Đã giao hàng thành công" (statusId = 4)
        else if (statusId == 4 && currentOrder.getStatusId() != 4) {
            // Cập nhật trạng thái đơn hàng
            success = orderDAO.updateOrderStatus(orderId, statusId);
            
            if (success) {
                // Xử lý số lượng sản phẩm: chuyển từ "đang được đặt" thành "đã bán ra"
                List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
                CartDAO cartDAO = new CartDAO();
                
                for (OrderDetail detail : orderDetails) {
                    // Cập nhật số lượng đã bán trong bảng thống kê (nếu có)
                    // Số lượng trong kho đã được trừ khi đặt hàng, giờ chỉ cần ghi nhận là đã bán
                    System.out.println("Sản phẩm ID: " + detail.getProductId() + 
                                     " - Số lượng: " + detail.getQuantity() + " chuyển từ 'đang được đặt' thành 'đã bán ra'");
                }
                
                message = "Đơn hàng đã được giao thành công. Số lượng sản phẩm đã chuyển từ trạng thái 'đang được đặt' thành 'đã bán ra'";
            } else {
                message = "Cập nhật thất bại";
            }
        }
        // Kiểm tra nếu chuyển sang trạng thái "Đã thanh toán thành công" (statusId = 5)
        else if (statusId == 5 && currentOrder.getStatusId() != 5) {
            // Cập nhật trạng thái đơn hàng
            success = orderDAO.updateOrderStatus(orderId, statusId);
            
            if (success) {
                // Xử lý số lượng sản phẩm: chuyển "số lượng đã được đặt" thành "số lượng đã bán ra"
                List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
                
                for (OrderDetail detail : orderDetails) {
                    // Ghi nhận sản phẩm đã hoàn thành việc bán
                    System.out.println("Đơn hàng hoàn thành - Sản phẩm ID: " + detail.getProductId() + 
                                     " - Số lượng: " + detail.getQuantity() + " chuyển từ 'đã được đặt' thành 'đã bán ra'");
                }
                
                message = "Đơn hàng đã hoàn thành. Số lượng sản phẩm đã chuyển từ 'đã được đặt' thành 'đã bán ra'";
            } else {
                message = "Cập nhật thất bại";
            }
        }
        // Kiểm tra nếu hủy đơn hàng (statusId = 6) - cần hoàn trả số lượng
// Trong phần xử lý statusId = 6 (hủy đơn hàng)
// Trong phần xử lý statusId = 6 (hủy đơn hàng)
else if (statusId == 6 && currentOrder.getStatusId() != 6) {
    success = orderDAO.cancelOrder(orderId);
    
    if (success) {
        // Hoàn trả số lượng sản phẩm về kho
        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
        CartDAO cartDAO = new CartDAO();
        
        boolean allProductsRestored = true;
        for (OrderDetail detail : orderDetails) {
            // Hoàn trả số lượng (số dương)
            boolean restored = cartDAO.updateProductQuantity(detail.getProductId(), detail.getQuantity());
            
            if (restored) {
                System.out.println("Đã hoàn trả " + detail.getQuantity() + " sản phẩm ID: " + detail.getProductId());
            } else {
                System.out.println("THẤT BẠI khi hoàn trả sản phẩm ID: " + detail.getProductId() + ", số lượng: " + detail.getQuantity());
                allProductsRestored = false;
            }
        }
        
        // Gửi email thông báo hủy đơn hàng
        try {
        if (currentOrder.getEmail() != null && !currentOrder.getEmail().trim().isEmpty()) {
                // Lấy chi tiết đơn hàng để tạo nội dung email
                String orderDetailsHtml = createOrderDetailsHtml(orderDetails);
                
                // Lấy lý do hủy đơn (nếu có)
                String cancelReason = request.getParameter("cancelReason");
                if (cancelReason == null || cancelReason.trim().isEmpty()) {
                    cancelReason = "Đơn hàng đã bị hủy bởi quản trị viên";
                }
                
System.out.println("Thông tin email người nhận: '" + currentOrder.getEmail() + "'");
                // Gửi email thông báo hủy đơn hàng
                boolean emailSent = EmailSender.sendOrderCancellationEmail(
                    currentOrder.getEmail(),
                    orderDetailsHtml,
                    currentOrder.getFullName(),
                    String.valueOf(orderId),
                    cancelReason
                );             
            if (emailSent) {
                System.out.println("Đã gửi email thông báo hủy đơn hàng thành công đến: " + currentOrder.getEmail());
                message = "Đơn hàng đã được hủy, số lượng sản phẩm đã được hoàn trả về kho và email thông báo đã được gửi";
            } else {
                System.out.println("Không thể gửi email thông báo hủy đơn hàng đến: " + currentOrder.getEmail());
                message = "Đơn hàng đã được hủy và số lượng sản phẩm đã được hoàn trả về kho, nhưng không thể gửi email thông báo";
            }
        } else {
            message = "Đơn hàng đã được hủy và số lượng sản phẩm đã được hoàn trả về kho, nhưng không có email khách hàng để gửi thông báo";
        }
        }  catch (Exception emailError) {
            System.err.println("Lỗi khi gửi email thông báo hủy đơn hàng: " + emailError.getMessage());
            emailError.printStackTrace();
            message = "Đơn hàng đã được hủy và số lượng sản phẩm đã được hoàn trả về kho, nhưng có lỗi khi gửi email: " + emailError.getMessage();
        }
        
        if (!allProductsRestored) {
            message += ", tuy nhiên một số sản phẩm không thể hoàn trả về kho";
        }
    } else {
        message = "Cập nhật thất bại";
    }
}
        // Các trạng thái khác chỉ cập nhật bình thường
                // Các trạng thái khác chỉ cập nhật bình thường
        else {
            success = orderDAO.updateOrderStatus(orderId, statusId);
            // CHỈ đặt message nếu chưa được đặt trước đó
            if (message == null || message.isEmpty()) {
                message = success ? "Cập nhật thành công" : "Cập nhật thất bại";
            }
        }
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
         
        
        response.getWriter().write(gson.toJson(jsonResponse));
        
    } catch (NumberFormatException e) {
        sendJsonError(response, "Dữ liệu số không hợp lệ");
    }
}
    // Thêm method test email
private void testEmail(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        boolean connectionSuccess = EmailSender.testEmailConnection();
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", connectionSuccess);
        jsonResponse.put("message", connectionSuccess ? "Kết nối email thành công!" : "Không thể kết nối email");
        
        response.getWriter().write(gson.toJson(jsonResponse));
    } catch (Exception e) {
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Lỗi: " + e.getMessage());
        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
    

    private void printOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Thiếu mã đơn hàng");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Không tìm thấy đơn hàng");
                return;
            }
            
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
            
            // Gán thông tin sản phẩm
            for (OrderDetail detail : orderDetails) {
                Product product = productDAO.getProductById(String.valueOf(detail.getProductId()));
                detail.setProduct(product);
            }
            
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("admin/order-print.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Mã đơn hàng không hợp lệ");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.getWriter().write("{\"success\":false,\"message\":\"" + message + "\"}");
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        viewAllOrders(request, response);
    }
    private void handleQuickSearch(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Lấy tham số quickOrderId từ form
        String quickOrderIdParam = request.getParameter("quickOrderId");
        
        // Kiểm tra nếu tham số rỗng hoặc null
        if (quickOrderIdParam == null || quickOrderIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mã đơn hàng để tìm kiếm.");
            // Chuyển về trang orders với thông báo lỗi
            handleFilterOrders(request, response);
            return;
        }
        
        // Chuyển đổi string thành số nguyên
        int orderId;
        try {
            orderId = Integer.parseInt(quickOrderIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng phải là một số nguyên hợp lệ.");
            // Chuyển về trang orders với thông báo lỗi
            handleFilterOrders(request, response);
            return;
        }
        
        // Tìm kiếm đơn hàng theo ID
        Order order = orderDAO.getOrderById(orderId);
        
        if (order != null) {
            // Tìm thấy đơn hàng
            List<Order> orders = new ArrayList<>();
            orders.add(order);
            
            // Set attributes cho JSP
            request.setAttribute("orders", orders);
            request.setAttribute("successMessage", "Tìm thấy đơn hàng với mã: " + orderId);
            request.setAttribute("searchedOrderId", orderId);
            
            // Tính toán thống kê (có thể giữ nguyên hoặc tạo thống kê riêng)
            Map<String, Object> statistics = orderDAO.getOrderStatistics();
            request.setAttribute("statistics", statistics);
            
            // Set thông tin phân trang (chỉ có 1 kết quả)
            request.setAttribute("currentPage", 1);
            request.setAttribute("pageSize", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalItems", 1);
            
        } else {
            // Không tìm thấy đơn hàng
            request.setAttribute("orders", new ArrayList<>());
            request.setAttribute("warningMessage", "Không tìm thấy đơn hàng với mã: " + orderId);
            request.setAttribute("searchedOrderId", orderId);
            
            // Vẫn hiển thị thống kê tổng quan
            Map<String, Object> statistics = orderDAO.getOrderStatistics();
            request.setAttribute("statistics", statistics);
            
            // Set thông tin phân trang (0 kết quả)
            request.setAttribute("currentPage", 1);
            request.setAttribute("pageSize", 10);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalItems", 0);
        }
        
        // Chuyển đến trang orders.jsp để hiển thị kết quả
        request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
        
    } catch (Exception e) {
        System.out.println("Error in handleQuickSearch: " + e.getMessage());
        e.printStackTrace();
        handleError(request, response, e);
    }
}
    /**
 * Tạo template HTML đơn giản cho email thông báo đơn hàng
 */
private String createOrderNotificationEmailTemplate(Order order, String customMessage) {
    StringBuilder html = new StringBuilder();
    
    html.append("<!DOCTYPE html>")
        .append("<html lang='vi'>")
        .append("<head>")
        .append("<meta charset='UTF-8'>")
        .append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>")
        .append("<style>")
        .append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px; background-color: #f4f4f4; }")
        .append(".container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }")
        .append(".header { text-align: center; border-bottom: 2px solid #4CAF50; padding-bottom: 20px; margin-bottom: 20px; }")
        .append(".header h1 { color: #4CAF50; margin: 0; }")
        .append(".message { background: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0; }")
        .append(".order-info { margin: 20px 0; }")
        .append(".info-table { width: 100%; border-collapse: collapse; }")
        .append(".info-table td { padding: 8px; border-bottom: 1px solid #ddd; }")
        .append(".info-table td:first-child { font-weight: bold; width: 30%; }")
        .append(".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; }")
        .append("</style>")
        .append("</head>")
        .append("<body>");
    
    html.append("<div class='container'>");
    
    // Header đơn giản
    html.append("<div class='header'>")
        .append("<h1>Thông báo đơn hàng</h1>")
        .append("</div>");
    
    // Lời chào
    html.append("<p>Kính chào <strong>")
        .append(order.getFullName() != null ? order.getFullName() : "Quý khách")
        .append("</strong>,</p>");
    
    // Tin nhắn tùy chỉnh
    if (customMessage != null && !customMessage.trim().isEmpty()) {
        html.append("<div class='message'>")
            .append("<strong>Thông báo:</strong><br>")
            .append(customMessage.replace("\n", "<br>"))
            .append("</div>");
    }
    
    // Thông tin đơn hàng
    html.append("<div class='order-info'>")
        .append("<h3>Thông tin đơn hàng #").append(order.getOrderId()).append("</h3>")
        .append("<table class='info-table'>");
    
    html.append("<tr><td>Ngày đặt:</td><td>")
        .append(order.getOrderDate() != null ? order.getOrderDate().toString() : "N/A")
        .append("</td></tr>");
    
    html.append("<tr><td>Khách hàng:</td><td>")
        .append(order.getFullName() != null ? order.getFullName() : "N/A")
        .append("</td></tr>");
    
    html.append("<tr><td>Email:</td><td>")
        .append(order.getEmail() != null ? order.getEmail() : "N/A")
        .append("</td></tr>");
    
    html.append("<tr><td>Số điện thoại:</td><td>")
        .append(order.getPhone() != null ? order.getPhone() : "N/A")
        .append("</td></tr>");
    
    html.append("<tr><td>Địa chỉ:</td><td>")
        .append(order.getAddress() != null ? order.getAddress() : "N/A")
        .append("</td></tr>");
    
    html.append("<tr><td>Tổng tiền:</td><td>")
    .append(String.format("%,.0f VNĐ", order.getTotal())) 
    .append("</td></tr>");
    
    html.append("<tr><td>Trạng thái:</td><td>")
        .append(order.getStatus() != null ? order.getStatus() : "Pending")
        .append("</td></tr>");
    
    html.append("</table></div>");
    
    // Lời cảm ơn
    html.append("<p>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>");
    
    // Footer đơn giản
    html.append("<div class='footer'>")
        .append("<p><strong>Cửa hàng trực tuyến</strong></p>")
        .append("<p>Email: anhhoang30012004@gmail.com | Hotline: 0123 456 789</p>")
        .append("<p><small>Email này được gửi tự động, vui lòng không trả lời.</small></p>")
        .append("</div>");
    
    html.append("</div></body></html>");
    
    return html.toString();
}
    private void sendCustomNotification(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        String orderIdParam = request.getParameter("orderId");
        String customMessage = request.getParameter("message");
        
        if (orderIdParam == null || customMessage == null) {
            sendJsonError(response, "Thiếu thông tin cần thiết");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        
        // Lấy thông tin đơn hàng
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            sendJsonError(response, "Không tìm thấy đơn hàng");
            return;
        }
        
        // Kiểm tra email khách hàng
        if (order.getEmail() == null || order.getEmail().trim().isEmpty()) {
            sendJsonError(response, "Đơn hàng không có thông tin email khách hàng");
            return;
        }
        
          // Tạo tiêu đề email
        String subject = "🛍️ Thông báo về đơn hàng #" + orderId + " - Cửa hàng trực tuyến";
        
        // Tạo nội dung email HTML đẹp
        String htmlContent = createOrderNotificationEmailTemplate(order, customMessage);
        
        // Gửi email
        boolean emailSent = EmailSender.sendNotificationEmail(
            order.getEmail(),
            subject,
            htmlContent
        );
        
        Map<String, Object> jsonResponse = new HashMap<>();
        if (emailSent) {
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Thông báo đã được gửi thành công đến " + order.getEmail());
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Không thể gửi thông báo. Vui lòng thử lại.");
        }
        
        response.getWriter().write(gson.toJson(jsonResponse));
        
    } catch (NumberFormatException e) {
        sendJsonError(response, "Mã đơn hàng không hợp lệ");
    } catch (Exception e) {
        sendJsonError(response, "Lỗi hệ thống: " + e.getMessage());
        e.printStackTrace();
    }
}
 private void getOrderDetailsForNotification(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        Map<String, String> orderInfo = orderDAO.getOrderInfoForNotification(orderId);
        
        Map<String, Object> jsonResponse = new HashMap<>();
        
        if (orderInfo != null && !orderInfo.isEmpty()) {
            jsonResponse.put("success", true);
            jsonResponse.put("fullName", orderInfo.get("name") != null ? orderInfo.get("name") : "N/A");
            jsonResponse.put("email", orderInfo.get("email") != null ? orderInfo.get("email") : "N/A");
            jsonResponse.put("address", orderInfo.get("address") != null ? orderInfo.get("address") : "N/A");
            jsonResponse.put("phoneNumber", orderInfo.get("phoneNumber") != null ? orderInfo.get("phoneNumber") : "N/A");
            // THÊM CÁC DÒNG NÀY:
            jsonResponse.put("status", orderInfo.get("status") != null ? orderInfo.get("status") : "N/A");
            jsonResponse.put("statusId", orderInfo.get("statusId") != null ? orderInfo.get("statusId") : "N/A");
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("fullName", "N/A");
            jsonResponse.put("email", "N/A");
            jsonResponse.put("address", "N/A");
            jsonResponse.put("phoneNumber", "N/A");
            // THÊM CÁC DÒNG NÀY:
            jsonResponse.put("status", "N/A");
            jsonResponse.put("statusId", "N/A");
        }
        
        response.getWriter().write(gson.toJson(jsonResponse));
        
    } catch (Exception e) {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("fullName", "N/A");
        errorResponse.put("email", "N/A");
        errorResponse.put("address", "N/A");
        errorResponse.put("phoneNumber", "N/A");
        // THÊM CÁC DÒNG NÀY:
        errorResponse.put("status", "N/A");
        errorResponse.put("statusId", "N/A");
        response.getWriter().write(gson.toJson(errorResponse));
        e.printStackTrace();
    }
}

    // Lấy danh sách shipper
    private void getShippers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<Model.Shipper> shippers = shipperDAO.getAllShippers();
            List<Map<String, Object>> shipperList = new ArrayList<>();
            
            for (Model.Shipper shipper : shippers) {
                if (shipper.isActive()) { // Chỉ lấy shipper đang hoạt động
                    Map<String, Object> shipperInfo = new HashMap<>();
                    shipperInfo.put("accountID", shipper.getShipperID());
                    shipperInfo.put("fullName", shipper.getUsername());
                    shipperInfo.put("phone", shipper.getPhone());
                    shipperList.add(shipperInfo);
                }
            }
            
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", true);
            jsonResponse.put("shippers", shipperList);
            
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy danh sách shipper: " + e.getMessage());
            response.getWriter().write(gson.toJson(errorResponse));
        }
    }
    
    // Phân công shipper cho đơn hàng
    private void assignShipper(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int shipperId = Integer.parseInt(request.getParameter("shipperId"));
            
            // Cập nhật shippingID trong bảng HoaDon
            boolean success = orderDAO.updateShippingID(orderId, shipperId);
            
            Map<String, Object> jsonResponse = new HashMap<>();
            if (success) {
                // Lấy thông tin shipper để trả về
                Model.Shipper shipper = shipperDAO.getShipperById(shipperId);
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Phân công shipper thành công");
                if (shipper != null) {
                    jsonResponse.put("shipperName", shipper.getUsername());
                    jsonResponse.put("shipperPhone", shipper.getPhone());
                    jsonResponse.put("shipperEmail", shipper.getEmail());
                }
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể phân công shipper");
            }
            
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi phân công shipper: " + e.getMessage());
            response.getWriter().write(gson.toJson(errorResponse));
        }
    }
}
