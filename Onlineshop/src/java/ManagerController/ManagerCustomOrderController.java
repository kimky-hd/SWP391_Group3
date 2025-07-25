package ManagerController;

import DAO.CustomOrderCartDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.CustomOrderCart;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý các yêu cầu liên quan đến quản lý đơn hàng tự thiết kế từ phía manager.
 */
@WebServlet(name = "ManagerCustomOrderController", urlPatterns = {"/custom-orders"})
public class ManagerCustomOrderController extends HttpServlet {

    private CustomOrderCartDAO customOrderCartDAO;
    private ProductDAO productDAO;
    
    @Override
    public void init() {
        customOrderCartDAO = new CustomOrderCartDAO();
        productDAO = new ProductDAO();
    }

    /**
     * Xử lý các yêu cầu GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền manager
        if (!checkManagerAccess(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                viewAllCustomOrders(request, response);
                break;
            case "detail":
                viewCustomOrderDetail(request, response);
                break;
            default:
                viewAllCustomOrders(request, response);
                break;
        }
    }

    /**
     * Xử lý các yêu cầu POST.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền manager
        if (!checkManagerAccess(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "updateStatus":
                updateCustomOrderStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/custom-orders");
                break;
        }
    }
    
    /**
     * Kiểm tra quyền manager.
     */
    private boolean checkManagerAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null || account.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        
        return true;
    }
    
    /**
     * Hiển thị tất cả đơn hàng tự thiết kế.
     */
    private void viewAllCustomOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số phân trang
        int page = 1;
        int recordsPerPage = 10;
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        // Lấy tham số lọc
        String orderIdStr = request.getParameter("orderId");
        String customerName = request.getParameter("customerName");
        String statusStr = request.getParameter("status");
        
        int orderId = 0;
        int statusId = 0;
        
        // Chuyển đổi tham số lọc
        try {
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                orderId = Integer.parseInt(orderIdStr.trim());
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        try {
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                statusId = Integer.parseInt(statusStr.trim());
            }
        } catch (NumberFormatException e) {
            // Giữ giá trị mặc định
        }
        
        // Lấy danh sách đơn hàng tự thiết kế theo bộ lọc
        List<CustomOrderCart> customOrders = customOrderCartDAO.getFilteredCustomOrderCarts(orderId, customerName, statusId);
        
        // Tính toán phân trang
        int totalRecords = customOrders.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Đặt thuộc tính cho JSP
        request.setAttribute("customOrders", customOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("orderId", orderIdStr);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", statusStr);
        
        // Chuyển hướng đến trang JSP
        request.getRequestDispatcher("/manager/custom_orders.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết đơn hàng tự thiết kế.
     */
    private void viewCustomOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customCartId = Integer.parseInt(request.getParameter("id"));
        CustomOrderCart customOrder = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        if (customOrder == null) {
            request.setAttribute("errorMessage", "Không tìm thấy đơn hàng tự thiết kế!");
            request.getRequestDispatcher("manager/custom_orders.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("customOrder", customOrder);
        request.getRequestDispatcher("/manager/custom_order_detail.jsp").forward(request, response);
    }
    
    /**
     * Cập nhật trạng thái đơn hàng tự thiết kế.
     */
    private void updateCustomOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int customCartId = Integer.parseInt(request.getParameter("customCartId"));
        int statusId = Integer.parseInt(request.getParameter("statusId"));
        String managerComment = request.getParameter("managerComment");
        
        CustomOrderCart customOrder = customOrderCartDAO.getCustomOrderCartById(customCartId);
        if (customOrder == null) {
            sendJsonResponse(response, false, "Không tìm thấy đơn hàng!");
            return;
        }
        
        customOrder.setStatusID(statusId);
        customOrder.setManagerComment(managerComment);
        
        // Cập nhật trạng thái dựa trên statusId
        switch (statusId) {
            case 1: // Chờ duyệt
                customOrder.setStatus("Chờ duyệt");
                break;
            case 7: // Đã duyệt đơn hàng thiết kế riêng
                customOrder.setStatus("Đã duyệt đơn hàng thiết kế riêng");
                break;
            case 8: // Đơn hàng thiết kế riêng bị từ chối
                customOrder.setStatus("Đơn hàng thiết kế riêng bị từ chối");
                break;
            default:
                customOrder.setStatus("Chờ duyệt");
                break;
        }
        
        boolean success = customOrderCartDAO.updateCustomOrderCart(customOrder);
        
        if (success) {
            // Gửi email thông báo cho khách hàng nếu có nhận xét
            if (customOrder.getEmail() != null && !customOrder.getEmail().isEmpty() 
                    && managerComment != null && !managerComment.isEmpty()) {
                sendStatusUpdateEmail(customOrder);
            }
            
            sendJsonResponse(response, true, "Cập nhật trạng thái đơn hàng thành công!");
        } else {
            sendJsonResponse(response, false, "Không thể cập nhật trạng thái đơn hàng!");
        }
    }
    
    /**
     * Gửi phản hồi JSON.
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse.toString());
        }
    }
    
    /**
     * Gửi email thông báo cập nhật trạng thái cho khách hàng.
     */
    private void sendStatusUpdateEmail(CustomOrderCart customOrder) {
        String subject = "[Cập nhật] Đơn hàng thiết kế riêng #" + customOrder.getCustomCartID();
        
        String statusText = "";
        switch (customOrder.getStatusID()) {
            case 7:
                statusText = "đã được duyệt: hãy tiến hành đặt hàng và thanh toán";
                break;
            case 8:
                statusText = "đã bị từ chối: vui lòng sửa lại đơn hàng để có thể duyệt lại!";
                break;
            default:
                statusText = "đã được cập nhật sang trạng thái: " + customOrder.getStatus();
                break;
        }
        
        String content = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>"
                + "<h2 style='color: #4CAF50;'>Cập nhật đơn hàng thiết kế riêng</h2>"
                + "<p>Xin chào " + customOrder.getFullName() + ",</p>"
                + "<p>Đơn hàng thiết kế riêng #" + customOrder.getCustomCartID() + " của bạn " + statusText + ".</p>"
                + "<p><strong>Nhận xét từ quản lý:</strong></p>"
                + "<div style='background-color: #f9f9f9; padding: 15px; border-left: 4px solid #4CAF50; margin: 10px 0;'>"
                + "<p>" + customOrder.getManagerComment() + "</p>"
                + "</div>"
                + "<p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.</p>"
                + "<p>Trân trọng,<br>Đội ngũ hỗ trợ khách hàng</p>"
                + "</div>";
        
        // Gửi email sử dụng lớp EmailSender
        Utility.EmailSender.sendNotificationEmail(customOrder.getEmail(), subject, content);
    }
}