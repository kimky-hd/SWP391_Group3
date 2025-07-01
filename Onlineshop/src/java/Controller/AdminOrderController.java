package Controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
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

@WebServlet(name = "AdminOrderController", urlPatterns = {"/orders"})
public class AdminOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
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
        List<Order> orders = orderDAO.getFilteredOrders(null, null, null, query, 1, 10);
        
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
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        
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
        
        if (customerName != null || status != null || dateFrom != null || dateTo != null) {
            orders = orderDAO.getFilteredOrders(status, dateFrom, dateTo, customerName, page, size);
            totalOrders = orderDAO.countTotalFilteredOrders(status, dateFrom, dateTo, customerName);
        } else {
            orders = orderDAO.getAllOrders();
            totalOrders = orders.size(); // Hoặc có thể gọi một phương thức đếm tổng số đơn hàng
        }
        
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
        if (account == null || account.getRole() != 1) {
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
    success = orderDAO.updateOrderStatus(orderId, statusId);
    
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
    private void testEmailConnection(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    PrintWriter out = response.getWriter();
    JsonObject json = new JsonObject();
    
    try {
        boolean connectionSuccess = EmailSender.testEmailConnection();
        
        if (connectionSuccess) {
            json.addProperty("success", true);
            json.addProperty("message", "Kết nối email thành công!");
        } else {
            json.addProperty("success", false);
            json.addProperty("message", "Không thể kết nối đến máy chủ email.");
        }
    } catch (Exception e) {
        json.addProperty("success", false);
        json.addProperty("message", "Lỗi kiểm tra kết nối email: " + e.getMessage());
        e.printStackTrace();
    }
    
    out.print(json.toString());
    out.flush();
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
    
}