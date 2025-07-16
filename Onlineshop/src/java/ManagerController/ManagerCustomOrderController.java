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
@WebServlet(name = "ManagerCustomOrderController", urlPatterns = {"/manager/custom-orders"})
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
                response.sendRedirect(request.getContextPath() + "/manager/custom-orders");
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
        String customerName = request.getParameter("customerName");
        String status = request.getParameter("status");
        
        // Lấy danh sách đơn hàng tự thiết kế
        List<CustomOrderCart> customOrders = customOrderCartDAO.getAllCustomOrderCarts();
        
        // Tính toán phân trang
        int totalRecords = customOrders.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Đặt thuộc tính cho JSP
        request.setAttribute("customOrders", customOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", status);
        
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
            request.getRequestDispatcher("/manager/custom_orders.jsp").forward(request, response);
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
        
        CustomOrderCart customOrder = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        if (customOrder == null) {
            sendJsonResponse(response, false, "Không tìm thấy đơn hàng tự thiết kế!");
            return;
        }
        
        // Cập nhật trạng thái
        customOrder.setStatusID(statusId);
        
        // Cập nhật trạng thái dựa vào statusId
        switch (statusId) {
            case 1: // Chờ duyệt
                customOrder.setStatus("Chờ duyệt");
                break;
            case 2: // Đơn hàng đã được duyệt và tiến hành đóng gói
                customOrder.setStatus("Đơn hàng đã được duyệt và tiến hành đóng gói");
                break;
            case 3: // Đơn hàng đang được vận chuyển
                customOrder.setStatus("Đơn hàng đang được vận chuyển");
                break;
            case 4: // Đã giao hàng thành công
                customOrder.setStatus("Đã giao hàng thành công");
                break;
            case 5: // Đã thanh toán thành công
                customOrder.setStatus("Đã thanh toán thành công");
                break;
            case 6: // Đã hủy
                customOrder.setStatus("Đã hủy");
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
            // Gửi email thông báo cho khách hàng (nếu cần)
            // sendStatusUpdateEmail(customOrder);
            
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
}