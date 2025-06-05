package Controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import Model.Cart;
import Model.CartItem;
import Model.Order;
import Model.OrderDetail;
import Model.Account;
import Model.Product;
import Model.Voucher;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final Gson gson = new Gson();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if (action != null) {
            switch (action) {
                case "place":
                    placeOrder(request, response, session);
                    break;
                case "view":
                    viewOrder(request, response, session);
                    break;
                case "cancel":
                    cancelOrder(request, response, session);
                    break;
                default:
                    response.sendRedirect("cart.jsp");
                    break;
            }
        } else {
            response.sendRedirect("cart.jsp");
        }
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            // Kiểm tra đăng nhập
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập để đặt hàng"));
                return;
            }

            // Lấy thông tin giỏ hàng
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                sendJsonResponse(response, createErrorResponse("Giỏ hàng trống"));
                return;
            }

            // Lấy thông tin địa chỉ giao hàng
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            String paymentMethod = request.getParameter("paymentMethod");

            // Kiểm tra thông tin bắt buộc
            if (fullName == null || phone == null || address == null ||
                city == null || district == null || paymentMethod == null) {
                sendJsonResponse(response, createErrorResponse("Vui lòng điền đầy đủ thông tin"));
                return;
            }

            // Tạo đơn hàng mới
            Order order = new Order();
            order.setAccountId(account.getAccountID());
            order.setOrderDate(new Date());
            order.setFullName(fullName);
            order.setPhone(phone);
            order.setEmail(email);
            
            // Ghép các trường địa chỉ thành một chuỗi
            String fullAddress = address + ", " + district + ", " + city;
            order.setAddress(fullAddress);
            
            order.setPaymentMethod(paymentMethod);
            order.setTotal(cart.getTotal() + 30000); // Thêm phí vận chuyển 30,000 VND
            order.setStatus("Pending");

            // Tạo chi tiết đơn hàng
            List<OrderDetail> orderDetails = new ArrayList<>();
            for (CartItem item : cart.getItems()) {
                // Kiểm tra số lượng tồn kho
                if (!cartDAO.checkProductAvailability(item.getProduct().getProductID(), item.getQuantity())) {
                    sendJsonResponse(response, createErrorResponse("Sản phẩm " + item.getProduct().getTitle() + " không đủ số lượng"));
                    return;
                }

                OrderDetail detail = new OrderDetail();
                detail.setProductId(item.getProduct().getProductID());
                detail.setQuantity(item.getQuantity());
                detail.setPrice(item.getProduct().getPrice());
                detail.setTotal(item.getTotal());
                orderDetails.add(detail);
            }

            // Lưu đơn hàng vào database
            if (orderDAO.createOrder(order, orderDetails)) {
                // Cập nhật số lượng sản phẩm
                for (OrderDetail detail : orderDetails) {
                    cartDAO.updateProductQuantity(detail.getProductId(), -detail.getQuantity());
                }

                // Xóa giỏ hàng
                session.removeAttribute("cart");

                sendJsonResponse(response, createSuccessResponse("Đặt hàng thành công"));
            } else {
                sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra khi đặt hàng"));
            }

        } catch (Exception e) {
            sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy danh sách đơn hàng
        List<Order> orders = orderDAO.getOrdersByAccountId(account.getAccountID());
        
        // Lấy chi tiết cho mỗi đơn hàng
        for (Order order : orders) {
            List<OrderDetail> details = orderDAO.getOrderDetails(order.getOrderId());
            
            // Lấy thông tin sản phẩm cho mỗi chi tiết đơn hàng
            for (OrderDetail detail : details) {
                Product product = new ProductDAO().getProductById(String.valueOf(detail.getProductId()));
                detail.setProduct(product);
            }
            
            // Lấy thông tin voucher nếu có
            // Giả sử có một trường voucherId trong Order
//            if (model.getVoucherId() > 0) {
//                Voucher voucher = new VoucherDAO().getVoucherById(order.getVoucherId());
//                request.setAttribute("voucher_" + order.getOrderId(), voucher);
//            }
            
            request.setAttribute("details_" + order.getOrderId(), details);
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập"));
                return;
            }

            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getAccountId() != account.getAccountID()) {
                sendJsonResponse(response, createErrorResponse("Không tìm thấy đơn hàng"));
                return;
            }

            if (!order.getStatus().equals("Pending")) {
                sendJsonResponse(response, createErrorResponse("Không thể hủy đơn hàng này"));
                return;
            }

            if (orderDAO.cancelOrder(orderId)) {
                // Hoàn trả số lượng sản phẩm
                List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
                for (OrderDetail detail : details) {
                    cartDAO.updateProductQuantity(detail.getProductId(), detail.getQuantity());
                }

                sendJsonResponse(response, createSuccessResponse("Hủy đơn hàng thành công"));
            } else {
                sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra khi hủy đơn hàng"));
            }

        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Mã đơn hàng không hợp lệ"));
        } catch (Exception e) {
            sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra: " + e.getMessage()));
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }

    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        return response;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
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