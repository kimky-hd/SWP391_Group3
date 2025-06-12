package Controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import Model.Cart;
import Model.Order;
import Model.OrderDetail;
import Model.CartItem;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Servlet xử lý kết quả trả về từ VN Pay
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {

    private final String VNP_HASH_SECRET = "OHTHFZK5KHL6VL3HC0WULFUGMC8WU0X4";
    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các tham số trả về từ VNPay
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        // Xác thực chữ ký từ VNPay
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // Kiểm tra chữ ký hợp lệ
        String signValue = hashAllFields(fields);
        boolean checkSignature = signValue.equals(vnp_SecureHash);

        // Lấy kết quả giao dịch từ VNPay
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");

        HttpSession session = request.getSession();
        
        // Kiểm tra kết quả giao dịch từ VNPay
        if (checkSignature) {
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                // Giao dịch thành công, tạo đơn hàng
                Account account = (Account) session.getAttribute("account");
                Cart cart = (Cart) session.getAttribute("cart");
                
                if (account != null && cart != null && !cart.isEmpty()) {
                    // Lấy thông tin giao hàng từ session
                    String fullName = (String) session.getAttribute("vnp_fullName");
                    String phone = (String) session.getAttribute("vnp_phone");
                    String email = (String) session.getAttribute("vnp_email");
                    String address = (String) session.getAttribute("vnp_address");
                    String district = (String) session.getAttribute("vnp_district");
                    String city = (String) session.getAttribute("vnp_city");
                    
                    // Tạo đối tượng Order
                    Order order = new Order();
                    order.setAccountId(account.getAccountID());
                    order.setOrderDate(new Date());
                    order.setFullName(fullName);
                    order.setPhone(phone);
                    order.setEmail(email);
                    
                    // Ghép các trường địa chỉ thành một chuỗi đầy đủ
                    String fullAddress = address + ", " + district + ", " + city;
                    order.setAddress(fullAddress);
                    
                    order.setPaymentMethod("VN Pay");
                    order.setTotal(cart.getTotal() + 30000);
                    order.setStatus("Paid"); // Đơn hàng đã thanh toán
                    
                    // Tạo danh sách OrderDetail từ CartItem
                    List<OrderDetail> orderDetails = new ArrayList<>();
                    for (CartItem item : cart.getItems()) {
                        OrderDetail detail = new OrderDetail();
                        detail.setProductId(item.getProduct().getProductID());
                        detail.setQuantity(item.getQuantity());
                        detail.setPrice(item.getProduct().getPrice());
                        detail.setTotal(item.getTotal());
                        orderDetails.add(detail);
                    }
                    
                    // Lưu đơn hàng vào database
                    if (orderDAO.createOrder(order, orderDetails)) {
                        // Cập nhật giảm số lượng sản phẩm trong kho
                        for (OrderDetail detail : orderDetails) {
                            cartDAO.updateProductQuantity(detail.getProductId(), -detail.getQuantity());
                        }
                        
                        // Xóa giỏ hàng khỏi session
                        session.removeAttribute("cart");
                        session.setAttribute("cartItemCount", 0);
                        
                        // Xóa thông tin giao hàng tạm thời
                        session.removeAttribute("vnp_fullName");
                        session.removeAttribute("vnp_phone");
                        session.removeAttribute("vnp_email");
                        session.removeAttribute("vnp_address");
                        session.removeAttribute("vnp_district");
                        session.removeAttribute("vnp_city");
                        
                        // Đặt thông báo thành công
                        session.setAttribute("message", "Thanh toán thành công! Đơn hàng của bạn đang được xử lý.");
                        session.setAttribute("messageType", "success");
                    } else {
                        // Lỗi khi lưu đơn hàng
                        session.setAttribute("message", "Có lỗi xảy ra khi xử lý đơn hàng. Vui lòng liên hệ với chúng tôi.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    // Không có thông tin tài khoản hoặc giỏ hàng
                    session.setAttribute("message", "Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.");
                    session.setAttribute("messageType", "error");
                }
            } else {
                // Giao dịch thất bại
                session.setAttribute("message", "Thanh toán không thành công. Mã lỗi: " + vnp_ResponseCode);
                session.setAttribute("messageType", "error");
            }
        } else {
            // Chữ ký không hợp lệ
            session.setAttribute("message", "Có lỗi xảy ra trong quá trình xử lý (Chữ ký không hợp lệ)");
            session.setAttribute("messageType", "error");
        }
        
        // Chuyển hướng về trang đơn hàng
        response.sendRedirect("order?action=view");
    }

    /**
     * Tạo chuỗi hash từ các tham số
     */
    private String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                try {
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.name()));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(VNPayReturnController.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        return hmacSHA512(VNP_HASH_SECRET, hashData.toString());
    }

    /**
     * Tạo mã HMAC_SHA512
     */
    private String hmacSHA512(String key, String data) {
        try {
            Mac sha512_HMAC = Mac.getInstance("HmacSHA512");
            SecretKeySpec secret_key = new SecretKeySpec(key.getBytes(), "HmacSHA512");
            sha512_HMAC.init(secret_key);
            byte[] hash = sha512_HMAC.doFinal(data.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}