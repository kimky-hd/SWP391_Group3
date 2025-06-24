package Controller;

import DAO.OrderDAO;
import DAO.ProductDAO;
import Model.Order;
import Model.OrderDetail;
import Model.Product;
import Model.Account;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AdminOrderController là một Servlet chịu trách nhiệm xử lý các yêu cầu liên quan đến quản lý đơn hàng từ phía admin.
 * Nó bao gồm các chức năng như xem danh sách đơn hàng, cập nhật trạng thái đơn hàng và xóa đơn hàng.
 */
@WebServlet(name = "AdminOrderController", urlPatterns = {"/orders"})
public class AdminOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final Gson gson = new Gson();

    /**
     * Phương thức processRequest xử lý các yêu cầu GET và POST.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Kiểm tra quyền admin
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() != 1) { // Giả sử role=1 là admin
            response.sendRedirect("login.jsp");
            return;
        }

        if (action == null) {
            // Hiển thị trang quản lý đơn hàng mặc định
            viewAllOrders(request, response);
        } else {
            switch (action) {
                case "view":
                    viewAllOrders(request, response);
                    break;
                case "detail":
                    viewOrderDetail(request, response);
                    break;
                case "update":
                    updateOrderStatus(request, response);
                    break;
                case "delete":
                    deleteOrder(request, response);
                    break;
                default:
                    viewAllOrders(request, response);
                    break;
            }
        }
    }

    /**
     * Hiển thị danh sách tất cả đơn hàng cho admin.
     */
    private void viewAllOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả đơn hàng từ database
        List<Order> orders = orderDAO.getAllOrders(); // Cần thêm phương thức này vào OrderDAO
        
        // Đặt danh sách đơn hàng vào request attribute
        request.setAttribute("orders", orders);
        
        // Chuyển tiếp đến trang admin/orders.jsp
        request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
    }

    /**
     * Hiển thị chi tiết một đơn hàng cụ thể.
     */
    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Lấy thông tin đơn hàng
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng");
                request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
                return;
            }
            
            // Lấy chi tiết đơn hàng
            List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
            
            // Gán thông tin sản phẩm cho từng chi tiết đơn hàng
            for (OrderDetail detail : details) {
                Product product = productDAO.getProductById(String.valueOf(detail.getProductId()));
                detail.setProduct(product);
            }
            
            // Đặt thông tin vào request attribute
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", details);
            
            // Chuyển tiếp đến trang chi tiết đơn hàng
            request.getRequestDispatcher("admin/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ");
            request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng.
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int statusId = Integer.parseInt(request.getParameter("statusId"));
            
            // Cập nhật trạng thái đơn hàng
            boolean success = orderDAO.updateOrderStatus(orderId, statusId); // Cần thêm phương thức này vào OrderDAO
            
            // Chuẩn bị phản hồi JSON
            Map<String, Object> jsonResponse = new HashMap<>();
            if (success) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Cập nhật trạng thái đơn hàng thành công");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể cập nhật trạng thái đơn hàng");
            }
            
            // Gửi phản hồi JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ");
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }

    /**
     * Xóa đơn hàng.
     */
    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            
            // Xóa đơn hàng
            boolean success = orderDAO.deleteOrder(orderId);
            
            // Chuẩn bị phản hồi JSON
            Map<String, Object> jsonResponse = new HashMap<>();
            if (success) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Xóa đơn hàng thành công");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Không thể xóa đơn hàng");
            }
            
            // Gửi phản hồi JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (NumberFormatException e) {
            Map<String, Object> jsonResponse = new HashMap<>();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã đơn hàng không hợp lệ");
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}