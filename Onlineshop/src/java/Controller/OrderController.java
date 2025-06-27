package Controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO; // Được thêm vào để lấy thông tin sản phẩm
import DAO.VoucherDAO; // Không được sử dụng trong mã hiện tại nhưng có thể hữu ích
import Model.Cart;
import Model.CartItem;
import Model.Order;
import Model.OrderDetail;
import Model.Account;
import Model.Product;
import Model.Voucher; // Không được sử dụng trong mã hiện tại
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
import Utility.EmailSender;

/**
 * **OrderController** là một Servlet chịu trách nhiệm xử lý các yêu cầu liên quan đến quản lý đơn hàng.
 * Nó bao gồm các chức năng như đặt hàng, xem danh sách đơn hàng và hủy đơn hàng.
 * Servlet này tương tác với `OrderDAO` để thực hiện các thao tác với cơ sở dữ liệu.
 */
@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

    // Khởi tạo các đối tượng DAO cần thiết để tương tác với cơ sở dữ liệu
    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();
    // Đối tượng Gson để chuyển đổi dữ liệu giữa Java Object và JSON, thường dùng cho các phản hồi AJAX
    private final Gson gson = new Gson();

    /**
     * Phương thức `processRequest` là nơi chứa logic chính để xử lý cả yêu cầu GET và POST.
     * Nó phân tích tham số `action` từ request để điều hướng đến các chức năng cụ thể của đơn hàng.
     *
     * @param request  Đối tượng HttpServletRequest chứa yêu cầu từ client.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi về client.
     * @throws ServletException Nếu có lỗi xảy ra trong quá trình xử lý servlet.
     * @throws IOException      Nếu có lỗi I/O xảy ra.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy giá trị của tham số 'action' từ request
        String action = request.getParameter("action");
        // Lấy đối tượng HttpSession hiện tại
        HttpSession session = request.getSession();

        // Kiểm tra và điều hướng dựa trên giá trị của 'action'
        if (action != null) {
            switch (action) {
                case "place": // Xử lý yêu cầu đặt hàng mới
                    placeOrder(request, response, session);
                    break;
                case "view": // Xử lý yêu cầu xem danh sách đơn hàng của người dùng
                    viewOrder(request, response, session);
                    break;
                case "cancel": // Xử lý yêu cầu hủy một đơn hàng
                    cancelOrder(request, response, session);
                    break;
                default: // Mặc định hoặc nếu 'action' không hợp lệ, chuyển hướng về trang giỏ hàng
                    response.sendRedirect("cart.jsp");
                    break;
            }
        } else {
            // Nếu không có 'action' được cung cấp, chuyển hướng về trang giỏ hàng
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * Xử lý logic đặt hàng mới.
     * Phương thức này thực hiện các bước sau:
     * 1. Kiểm tra trạng thái đăng nhập của người dùng.
     * 2. Lấy thông tin giỏ hàng từ session và kiểm tra xem giỏ hàng có trống không.
     * 3. Thu thập thông tin giao hàng từ form.
     * 4. Tạo đối tượng `Order` và `OrderDetail` từ thông tin giỏ hàng.
     * 5. **Quan trọng:** Kiểm tra lại số lượng tồn kho của từng sản phẩm trước khi tạo đơn hàng.
     * 6. Lưu đơn hàng và chi tiết đơn hàng vào cơ sở dữ liệu.
     * 7. Cập nhật giảm số lượng tồn kho của sản phẩm trong database.
     * 8. Xóa giỏ hàng khỏi session sau khi đặt hàng thành công.
     * 9. Gửi phản hồi JSON về client (thành công hoặc lỗi).
     *
     * @param request  HttpServletRequest chứa thông tin đơn hàng và giao hàng.
     * @param response HttpServletResponse để gửi phản hồi JSON.
     * @param session  HttpSession hiện tại.
     * @throws ServletException
     * @throws IOException
     */
    private void placeOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        try {
            // --- Bước 1: Kiểm tra đăng nhập ---
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                // Nếu chưa đăng nhập, gửi phản hồi lỗi JSON
                sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập để đặt hàng"));
                return;
            }

            // --- Bước 2: Lấy thông tin giỏ hàng ---
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                // Nếu giỏ hàng trống, gửi phản hồi lỗi JSON
                sendJsonResponse(response, createErrorResponse("Giỏ hàng trống, không thể đặt hàng"));
                return;
            }

            // --- Bước 3: Lấy thông tin địa chỉ giao hàng từ request ---
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            String paymentMethod = request.getParameter("paymentMethod");
            
            String selectedVoucherId = request.getParameter("selectedVoucherId");
            double totalAfterDiscount = Double.parseDouble(request.getParameter("totalAfterDiscount"));

            // --- Bước 4: Kiểm tra thông tin bắt buộc ---
            if (fullName == null || phone == null || address == null ||
                city == null || district == null || paymentMethod == null ||
                fullName.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty() ||
                city.trim().isEmpty() || district.trim().isEmpty() || paymentMethod.trim().isEmpty()) {
                sendJsonResponse(response, createErrorResponse("Vui lòng điền đầy đủ thông tin giao hàng"));
                return;
            }

            // --- Bước 5: Tạo đối tượng Order ---
            Order order = new Order();
            order.setAccountId(account.getAccountID()); // Gán ID tài khoản
            order.setOrderDate(new Date()); // Gán ngày đặt hàng là ngày hiện tại
            order.setFullName(fullName);
            order.setPhone(phone);
            order.setEmail(email);

            // Ghép các trường địa chỉ thành một chuỗi đầy đủ
            String fullAddress = address + ", " + district + ", " + city;
            order.setAddress(fullAddress);

            order.setPaymentMethod(paymentMethod);
            // Tính tổng tiền đơn hàng bao gồm phí vận chuyển (ví dụ: 30,000 VND)
            order.setTotal(totalAfterDiscount);
            order.setStatus("Pending"); // Đặt trạng thái ban đầu là "Pending"

            // --- Bước 6: Tạo danh sách OrderDetail từ CartItem ---
            List<OrderDetail> orderDetails = new ArrayList<>();
            for (CartItem item : cart.getItems()) {
                // Kiểm tra lại số lượng tồn kho cho từng sản phẩm trước khi xác nhận đơn hàng
                if (!cartDAO.checkProductAvailability(item.getProduct().getProductID(), item.getQuantity())) {
                    sendJsonResponse(response, createErrorResponse("Sản phẩm " + item.getProduct().getTitle() + " không đủ số lượng trong kho. Vui lòng kiểm tra lại giỏ hàng."));
                    return; // Dừng xử lý nếu không đủ hàng
                }

                OrderDetail detail = new OrderDetail();
                detail.setProductId(item.getProduct().getProductID());
                detail.setQuantity(item.getQuantity());
                detail.setPrice(item.getProduct().getPrice()); // Giá tại thời điểm đặt hàng
                detail.setTotal(item.getTotal()); // Tổng tiền cho mặt hàng này
                orderDetails.add(detail);
            }

            // --- Bước 7: Lưu đơn hàng vào database ---
            // Gọi phương thức `createOrder` của OrderDAO để lưu Order và OrderDetails
            if (orderDAO.createOrder(order, orderDetails)) {
                // --- Bước 8: Cập nhật giảm số lượng sản phẩm trong kho ---
                for (OrderDetail detail : orderDetails) {
                    // Giảm số lượng tồn kho của sản phẩm tương ứng trong bảng Product
                    cartDAO.updateProductQuantity(detail.getProductId(), -detail.getQuantity());
                }
                
                //update voucher and account voucher
                if(selectedVoucherId != null && !selectedVoucherId.trim().equals("")){
                    VoucherDAO vdao = new VoucherDAO();
                    int voucherId = Integer.parseInt(selectedVoucherId);
                    vdao.updateVoucherUsage(voucherId);
                    vdao.updateAccountVoucherStatus(account.getAccountID(), voucherId);
                }    

                // --- Bước mới: Xóa giỏ hàng từ database ---
                cartDAO.clearCart(account.getAccountID());

                // --- Bước 9: Xóa giỏ hàng khỏi session sau khi đặt hàng thành công ---
                session.removeAttribute("cart");
                // Cập nhật lại số lượng item trên header về 0
                session.setAttribute("cartItemCount", 0);


                // --- Bước 10: Gửi phản hồi thành công ---
                sendJsonResponse(response, createSuccessResponse("Đặt hàng thành công! Đơn hàng của bạn đang được xử lý."));
            } else {
                // Nếu có lỗi khi lưu đơn hàng vào DB
                sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại sau."));
            }

        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu có tham số không phải là số hợp lệ (ví dụ: productId, quantity)
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ. Vui lòng kiểm tra lại các trường thông tin."));
            e.printStackTrace(); // In stack trace để debug
        } catch (Exception e) {
            // Xử lý các ngoại lệ tổng quát khác
            sendJsonResponse(response, createErrorResponse("Đã xảy ra lỗi hệ thống: " + e.getMessage()));
            e.printStackTrace(); // In stack trace để debug
        }
    }

    /**
     * Xử lý logic để hiển thị danh sách các đơn hàng của người dùng.
     * 1. Kiểm tra trạng thái đăng nhập.
     * 2. Lấy danh sách các đơn hàng của tài khoản từ database.
     * 3. Với mỗi đơn hàng, lấy chi tiết đơn hàng (các sản phẩm trong đơn hàng).
     * 4. Gán thông tin sản phẩm cho từng `OrderDetail`.
     * 5. (Tùy chọn) Lấy thông tin voucher nếu có.
     * 6. Đặt các đối tượng `Order` và `OrderDetail` vào request attribute để JSP có thể hiển thị.
     * 7. Chuyển tiếp đến trang `orders.jsp`.
     *
     * @param request  HttpServletRequest
     * @param response HttpServletResponse
     * @param session  HttpSession hiện tại.
     * @throws ServletException
     * @throws IOException
     */
    private void viewOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        // --- Bước 1: Kiểm tra đăng nhập ---
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp"); // Chuyển hướng đến trang đăng nhập nếu chưa đăng nhập
            return;
        }

        // --- Bước 2: Lấy danh sách đơn hàng theo Account ID ---
        List<Order> orders = orderDAO.getOrdersByAccountId(account.getAccountID());

        // --- Bước 3 & 4: Lấy chi tiết và thông tin sản phẩm cho mỗi đơn hàng ---
        // Cần một ProductDAO để lấy thông tin chi tiết sản phẩm
        ProductDAO productDAO = new ProductDAO();

        for (Order order : orders) {
            // Lấy danh sách chi tiết đơn hàng (OrderDetail) cho từng Order
            List<OrderDetail> details = orderDAO.getOrderDetails(order.getOrderId());

            // Gán thông tin sản phẩm đầy đủ cho mỗi OrderDetail
            for (OrderDetail detail : details) {
                // Chú ý: `getProductById` của ProductDAO cần nhận `int` hoặc `String` tùy thuộc vào cách triển khai của nó.
                // Ở đây, giả định `getProductById` của ProductDAO nhận String. Nếu là int, bạn cần parseInt.
                Product product = productDAO.getProductById(String.valueOf(detail.getProductId()));
                detail.setProduct(product); // Thiết lập đối tượng Product vào OrderDetail
            }

            // --- Bước 5 (Tùy chọn): Lấy thông tin voucher nếu có ---
            // Phần này hiện đang bị comment, nếu có VoucherDAO và trường voucherId trong Model.Order,
            // bạn có thể uncomment và chỉnh sửa để lấy thông tin voucher.
            // Ví dụ:
            // if (order.getVoucherId() != null && order.getVoucherId() > 0) {
            //     Voucher voucher = new VoucherDAO().getVoucherById(order.getVoucherId());
            //     request.setAttribute("voucher_" + order.getOrderId(), voucher);
            // }

            // Đặt danh sách chi tiết đơn hàng vào request attribute để JSP có thể truy cập
            request.setAttribute("details_" + order.getOrderId(), details);
        }

        // --- Bước 6: Đặt danh sách đơn hàng vào request attribute ---
        request.setAttribute("orders", orders);
        // --- Bước 7: Chuyển tiếp đến trang `orders.jsp` để hiển thị ---
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }

    /**
     * Xử lý logic để hủy một đơn hàng.
     * 1. Kiểm tra trạng thái đăng nhập.
     * 2. Lấy ID đơn hàng từ request và kiểm tra quyền sở hữu đơn hàng.
     * 3. Kiểm tra trạng thái hiện tại của đơn hàng (chỉ cho phép hủy nếu là "Pending").
     * 4. Cập nhật trạng thái đơn hàng thành "Cancelled" trong database.
     * 5. Hoàn trả số lượng sản phẩm đã được đặt vào tồn kho.
     * 6. Gửi phản hồi JSON về client (thành công hoặc lỗi).
     *
     * @param request  HttpServletRequest chứa orderId cần hủy.
     * @param response HttpServletResponse để gửi phản hồi JSON.
     * @param session  HttpSession hiện tại.
     * @throws ServletException
     * @throws IOException
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, HttpSession session)
        throws ServletException, IOException {
    try {
        // --- Bước 1: Kiểm tra đăng nhập ---
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập để hủy đơn hàng"));
            return;
        }

        // --- Bước 2: Lấy Order ID và kiểm tra quyền sở hữu ---
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDAO.getOrderById(orderId); // Lấy thông tin đơn hàng từ DB

        // Kiểm tra xem đơn hàng có tồn tại và có thuộc về tài khoản hiện tại không
        if (order == null || order.getAccountId() != account.getAccountID()) {
            sendJsonResponse(response, createErrorResponse("Không tìm thấy đơn hàng hoặc bạn không có quyền hủy đơn hàng này."));
            return;
        }

        // --- Bước 3: Kiểm tra trạng thái đơn hàng (chỉ hủy đơn hàng đang "Pending") ---
        if (!order.getStatus().equals("Pending")) {
            sendJsonResponse(response, createErrorResponse("Không thể hủy đơn hàng này vì trạng thái không phải là 'Pending'."));
            return;
        }

        // --- Bước 4: Hủy đơn hàng trong database ---
        if (orderDAO.cancelOrder(orderId)) {
            // --- Bước 5: Hoàn trả số lượng sản phẩm vào tồn kho ---
            List<OrderDetail> details = orderDAO.getOrderDetails(orderId);
            for (OrderDetail detail : details) {
                // Tăng số lượng tồn kho của sản phẩm đã được đặt lại
                cartDAO.updateProductQuantity(detail.getProductId(), detail.getQuantity());
            }
            
            // --- Bước 6: Gửi email thông báo hủy đơn hàng ---
            if (order.getEmail() != null && !order.getEmail().isEmpty()) {
                try {
                    // Tạo HTML cho chi tiết đơn hàng
                    String orderDetailsHtml = EmailSender.createOrderDetailsHtml(details);
                    
                    // Gửi email thông báo hủy đơn hàng
                    boolean emailSent = EmailSender.sendOrderCancellationEmail(
                            order.getEmail(),
                            orderDetailsHtml,
                            order.getFullName(),
                            String.valueOf(orderId),
                            "Đơn hàng đã bị hủy bởi khách hàng");
                    
                    if (emailSent) {
                        System.out.println("Đã gửi email thông báo hủy đơn hàng thành công đến: " + order.getEmail());
                    } else {
                        System.out.println("Không thể gửi email thông báo hủy đơn hàng đến: " + order.getEmail());
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi khi gửi email thông báo hủy đơn hàng: " + e.getMessage());
                    e.printStackTrace();
                    // Không dừng quy trình nếu gửi email thất bại
                }
            }

            // --- Bước 7: Gửi phản hồi thành công ---
            sendJsonResponse(response, createSuccessResponse("Hủy đơn hàng thành công. Số lượng sản phẩm đã được hoàn lại kho."));
        } else {
            // Nếu có lỗi khi hủy đơn hàng trong DB
            sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra khi hủy đơn hàng. Vui lòng thử lại."));
        }

    } catch (NumberFormatException e) {
        // Xử lý lỗi nếu orderId không phải là số hợp lệ
        sendJsonResponse(response, createErrorResponse("Mã đơn hàng không hợp lệ."));
        e.printStackTrace();
    } catch (Exception e) {
        // Xử lý các lỗi khác
        sendJsonResponse(response, createErrorResponse("Có lỗi xảy ra: " + e.getMessage()));
        e.printStackTrace();
    }
}

    /**
     * Phương thức tiện ích để gửi phản hồi HTTP dưới dạng JSON.
     * Nó thiết lập `Content-Type` là `application/json` và sử dụng Gson để
     * chuyển đổi một `Map<String, Object>` thành chuỗi JSON.
     *
     * @param response Đối tượng HttpServletResponse để gửi phản hồi.
     * @param data     Dữ liệu dưới dạng Map cần chuyển đổi và gửi.
     * @throws IOException Nếu có lỗi I/O khi ghi dữ liệu.
     */
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json"); // Đặt kiểu nội dung là JSON
        response.setCharacterEncoding("UTF-8"); // Đặt mã hóa ký tự là UTF-8
        response.getWriter().write(gson.toJson(data)); // Chuyển đổi data thành JSON và ghi vào response
    }

    /**
     * Phương thức tiện ích để tạo một `Map` đại diện cho phản hồi thành công.
     * Thường được sử dụng để chuẩn hóa cấu trúc phản hồi JSON cho các yêu cầu AJAX.
     *
     * @param message Thông báo mô tả sự thành công.
     * @return Một `Map` chứa khóa "success" (true) và "message".
     */
    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true); // Đặt trạng thái thành công
        response.put("message", message); // Đặt thông báo
        return response;
    }

    /**
     * Phương thức tiện ích để tạo một `Map` đại diện cho phản hồi lỗi.
     * Tương tự như `createSuccessResponse`, dùng để chuẩn hóa cấu trúc phản hồi JSON cho các yêu cầu AJAX.
     *
     * @param message Thông báo mô tả lỗi.
     * @return Một `Map` chứa khóa "success" (false) và "message".
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false); // Đặt trạng thái thất bại
        response.put("message", message); // Đặt thông báo lỗi
        return response;
    }

    /**
     * Xử lý các yêu cầu HTTP GET bằng cách gọi phương thức `processRequest`.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Xử lý các yêu cầu HTTP POST bằng cách gọi phương thức `processRequest`.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}