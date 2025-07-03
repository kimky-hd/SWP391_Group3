package Controller;

import DAO.CustomOrderCartDAO;
import Model.Account;
import Model.CustomOrderCart;
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
 * Servlet xử lý kết quả trả về từ VN Pay cho đơn hàng thiết kế riêng
 */
@WebServlet(name = "CustomVNPayReturnController", urlPatterns = {"/custom-vnpay-return"})
public class CustomVNPayReturnController extends HttpServlet {

    private final String VNP_HASH_SECRET = "OHTHFZK5KHL6VL3HC0WULFUGMC8WU0X4";
    private final CustomOrderCartDAO customOrderCartDAO = new CustomOrderCartDAO();

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
                // Giao dịch thành công, cập nhật trạng thái đơn hàng
                Account account = (Account) session.getAttribute("account");
                Integer customCartId = (Integer) session.getAttribute("custom_vnp_customCartId");
                
                if (account != null && customCartId != null) {
                    // Lấy thông tin đơn hàng thiết kế riêng
                    CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
                    
                    if (customOrderCart != null && customOrderCart.getAccountID() == account.getAccountID()) {
                        // Cập nhật trạng thái đơn hàng thành "Đã thanh toán"
                        customOrderCart.setStatusID(5); // Giả sử 8 là trạng thái "Đã thanh toán"
                        
                        if (customOrderCartDAO.updateCustomOrderCart(customOrderCart)) {
                            // Xóa thông tin tạm thời
                            session.removeAttribute("custom_vnp_customCartId");
                            
                            // Đặt thông báo thành công
                            session.setAttribute("message", "Thanh toán thành công! Đơn hàng thiết kế riêng của bạn đang được xử lý.");
                            session.setAttribute("messageType", "success");
                        } else {
                            // Lỗi khi cập nhật trạng thái đơn hàng
                            session.setAttribute("message", "Có lỗi xảy ra khi xử lý đơn hàng. Vui lòng liên hệ với chúng tôi.");
                            session.setAttribute("messageType", "error");
                        }
                    } else {
                        // Không tìm thấy đơn hàng hoặc đơn hàng không thuộc về người dùng hiện tại
                        session.setAttribute("message", "Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    // Không có thông tin tài khoản hoặc đơn hàng
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
        
        // Chuyển hướng về trang giỏ hàng thiết kế riêng
        response.sendRedirect("custom-cart");
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
                    Logger.getLogger(CustomVNPayReturnController.class.getName()).log(Level.SEVERE, null, ex);
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