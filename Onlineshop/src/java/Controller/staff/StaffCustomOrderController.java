package Controller.staff;

import DAO.CustomOrderCartDAO;
import Model.Account;
import Model.CustomOrderCart;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xử lý các yêu cầu liên quan đến xem đơn hàng tự thiết kế từ phía nhân viên (staff).
 * Nhân viên chỉ có thể xem các đơn hàng đã được duyệt và không thể cập nhật trạng thái.
 */
@WebServlet(name = "StaffCustomOrderController", urlPatterns = {"/staff/staff_custom-orders"})
public class StaffCustomOrderController extends HttpServlet {

    private CustomOrderCartDAO customOrderCartDAO;
    
    @Override
    public void init() {
        customOrderCartDAO = new CustomOrderCartDAO();
    }

    /**
     * Xử lý các yêu cầu GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền nhân viên (staff)
        if (!checkStaffAccess(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                viewApprovedCustomOrders(request, response);
                break;
            case "detail":
                viewCustomOrderDetail(request, response);
                break;
            default:
                viewApprovedCustomOrders(request, response);
                break;
        }
    }

    /**
     * Kiểm tra quyền nhân viên (staff).
     */
    private boolean checkStaffAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null || account.getRole() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        
        return true;
    }
    
    /**
     * Hiển thị các đơn hàng tự thiết kế đã được duyệt.
     */
    private void viewApprovedCustomOrders(HttpServletRequest request, HttpServletResponse response)
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
        
        // Lấy danh sách tất cả đơn hàng tự thiết kế
        List<CustomOrderCart> allCustomOrders = customOrderCartDAO.getAllCustomOrderCarts();
        
        // Lọc chỉ lấy các đơn hàng đã được duyệt (statusID = 2 hoặc statusID = 7)
        List<CustomOrderCart> approvedCustomOrders = new ArrayList<>();
        for (CustomOrderCart order : allCustomOrders) {
            if (order.getStatusID() == 2 || order.getStatusID() == 7) {
                // Lọc theo tên khách hàng nếu có
                if (customerName == null || customerName.isEmpty() || 
                    (order.getFullName() != null && order.getFullName().toLowerCase().contains(customerName.toLowerCase()))) {
                    approvedCustomOrders.add(order);
                }
            }
        }
        
        // Tính toán phân trang
        int totalRecords = approvedCustomOrders.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Đặt thuộc tính cho JSP
        request.setAttribute("customOrders", approvedCustomOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("customerName", customerName);
        
        // Chuyển hướng đến trang JSP
        request.getRequestDispatcher("/staff/staff_custom_orders.jsp").forward(request, response);
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
            request.getRequestDispatcher("/staff/staff_custom_orders.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra xem đơn hàng có phải đã được duyệt không
        if (customOrder.getStatusID() != 2 && customOrder.getStatusID() != 7) {
            request.setAttribute("errorMessage", "Bạn chỉ có thể xem các đơn hàng đã được duyệt!");
            request.getRequestDispatcher("/staff/staff_custom_orders.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("customOrder", customOrder);
        request.getRequestDispatcher("/staff/staff_custom_order_detail.jsp").forward(request, response);
    }
}