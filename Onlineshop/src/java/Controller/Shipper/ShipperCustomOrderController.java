package Controller.Shipper;

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
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.PrintWriter;

/**
 * Servlet xử lý các yêu cầu liên quan đến xem và cập nhật đơn hàng tự thiết kế từ phía shipper.
 * Shipper có thể xem các đơn hàng đã được duyệt và sẵn sàng giao, cập nhật trạng thái giao hàng.
 */
@WebServlet(name = "ShipperCustomOrderController", urlPatterns = {"/shipper/custom-orders"})
public class ShipperCustomOrderController extends HttpServlet {

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

        // Kiểm tra quyền shipper
        if (!checkShipperAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                viewCustomOrdersForShipper(request, response);
                break;
            case "detail":
                viewCustomOrderDetail(request, response);
                break;
            default:
                viewCustomOrdersForShipper(request, response);
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

        // Kiểm tra quyền shipper
        if (!checkShipperAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            sendJsonResponse(response, false, "Không xác định được hành động!");
            return;
        }

        switch (action) {
            case "updateStatus":
                updateCustomOrderStatus(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Hành động không hợp lệ!");
                break;
        }
    }

    /**
     * Kiểm tra quyền shipper.
     */
    private boolean checkShipperAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || account.getRole() != 3) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }

        return true;
    }

    /**
     * Hiển thị các đơn hàng tự thiết kế sẵn sàng giao, đang giao hoặc đã giao thành công.
     */
    private void viewCustomOrdersForShipper(HttpServletRequest request, HttpServletResponse response)
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
        List<CustomOrderCart> filteredOrders = customOrderCartDAO.getFilteredCustomOrderCarts(orderId, customerName, statusId);

        // Lọc chỉ lấy các đơn hàng sẵn sàng giao, đang giao hoặc đã giao thành công (statusID = 9, 3 hoặc 4)
        List<CustomOrderCart> shipperCustomOrders = new ArrayList<>();
        for (CustomOrderCart order : filteredOrders) {
            if (order.getStatusID() == 9 || order.getStatusID() == 3 || order.getStatusID() == 4) {
                shipperCustomOrders.add(order);
            }
        }

        // Tính toán phân trang
        int totalRecords = shipperCustomOrders.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Đặt thuộc tính cho JSP
        request.setAttribute("customOrders", shipperCustomOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("orderId", orderIdStr);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", statusStr);

        // Chuyển hướng đến trang JSP
        request.getRequestDispatcher("/shipper/shipper_custom_orders.jsp").forward(request, response);
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
            request.getRequestDispatcher("/shipper/shipper_custom_orders.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem đơn hàng có phải sẵn sàng giao, đang giao hoặc đã giao thành công không
        if (customOrder.getStatusID() != 9 && customOrder.getStatusID() != 3 && customOrder.getStatusID() != 4) {
            request.setAttribute("errorMessage", "Bạn chỉ có thể xem các đơn hàng sẵn sàng giao, đang giao hoặc đã giao thành công!");
            request.getRequestDispatcher("/shipper/shipper_custom_orders.jsp").forward(request, response);
            return;
        }

        request.setAttribute("customOrder", customOrder);
        request.getRequestDispatcher("/shipper/shipper_custom_order_detail.jsp").forward(request, response);
    }

    /**
     * Cập nhật trạng thái đơn hàng tự thiết kế.
     */
    private void updateCustomOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customCartId = Integer.parseInt(request.getParameter("customCartId"));
        int statusId = Integer.parseInt(request.getParameter("statusId"));
        String note = request.getParameter("note"); // Cho trường hợp hủy đơn

        CustomOrderCart customOrder = customOrderCartDAO.getCustomOrderCartById(customCartId);
        if (customOrder == null) {
            sendJsonResponse(response, false, "Không tìm thấy đơn hàng!");
            return;
        }

        // Kiểm tra trạng thái hợp lệ cho shipper
        if (statusId != 3 && statusId != 4 && statusId != 6) {
            sendJsonResponse(response, false, "Trạng thái không hợp lệ cho shipper!");
            return;
        }

        // Kiểm tra chuyển đổi trạng thái hợp lệ
        boolean isValidTransition = false;
        switch (customOrder.getStatusID()) {
            case 9: // Sẵn sàng giao
                isValidTransition = (statusId == 3 || statusId == 6); // Chuyển sang đang giao hoặc hủy
                break;
            case 3: // Đang giao
                isValidTransition = (statusId == 4 || statusId == 6); // Chuyển sang đã giao hoặc hủy
                break;
            default:
                isValidTransition = false;
        }

        if (!isValidTransition) {
            sendJsonResponse(response, false, "Không thể chuyển từ trạng thái hiện tại sang trạng thái mới!");
            return;
        }

        // Nếu hủy đơn, yêu cầu ghi chú
        if (statusId == 6 && (note == null || note.trim().isEmpty())) {
            sendJsonResponse(response, false, "Vui lòng nhập lý do hủy đơn hàng!");
            return;
        }

        customOrder.setStatusID(statusId);
        
        // Cập nhật trạng thái dựa trên statusId
        switch (statusId) {
            case 3: // Đang vận chuyển
                customOrder.setStatus("Đang vận chuyển");
                break;
            case 4: // Đã giao hàng thành công
                customOrder.setStatus("Đã giao hàng thành công");
                break;
            case 6: // Đã hủy
                customOrder.setStatus("Đã hủy");
                customOrder.setManagerComment(note); // Lưu lý do hủy
                break;
            default:
                customOrder.setStatus("Chờ duyệt");
                break;
        }

        boolean success = customOrderCartDAO.updateCustomOrderCart(customOrder);

        if (success) {
            // Gửi email thông báo cho khách hàng nếu có email
            if (customOrder.getEmail() != null && !customOrder.getEmail().isEmpty()) {
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
        // Triển khai gửi email thông báo cập nhật trạng thái
        // Tương tự như trong StaffCustomOrderController
    }
}