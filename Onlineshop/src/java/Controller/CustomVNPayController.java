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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Servlet xử lý thanh toán qua VN Pay cho đơn hàng thiết kế riêng
 */
@WebServlet(name = "CustomVNPayController", urlPatterns = {"/custom-vnpay"})
public class CustomVNPayController extends HttpServlet {

    // Thông tin cấu hình VN Pay
    private final String VNP_TMN_CODE = "JG2WH0MM";
    private final String VNP_HASH_SECRET = "OHTHFZK5KHL6VL3HC0WULFUGMC8WU0X4";
    private final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private final CustomOrderCartDAO customOrderCartDAO = new CustomOrderCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ request
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan don hang thiet ke rieng";
        String orderType = "billpayment";
        String vnp_TxnRef = getRandomNumber(8);
        String vnp_IpAddr = getIpAddress(request);
        String vnp_TmnCode = VNP_TMN_CODE;

        // Lấy thông tin session và kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy customCartId từ request
        int customCartId = Integer.parseInt(request.getParameter("customCartId"));
        
        // Lấy thông tin đơn hàng thiết kế riêng
        CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        // Kiểm tra đơn hàng có tồn tại và thuộc về người dùng hiện tại không
        if (customOrderCart == null || customOrderCart.getAccountID() != account.getAccountID()) {
            response.sendRedirect("custom-cart");
            return;
        }
        
        // Kiểm tra trạng thái đơn hàng có phải là "Đã duyệt đơn hàng thiết kế riêng" không
        if (customOrderCart.getStatusID() != 7) {
            response.sendRedirect("custom-cart");
            return;
        }

        // Lưu thông tin vào session để sử dụng sau khi thanh toán
        session.setAttribute("custom_vnp_customCartId", customCartId);

        // Tạo các tham số cho VNPay
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);

        // Số tiền thanh toán (VNPay yêu cầu số tiền * 100)
        // Giả sử giá mỗi sản phẩm thiết kế riêng là 500,000 VND
        long amount = (long) (500000 * customOrderCart.getQuantity() * 100);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));

        // Thông tin đơn hàng
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        // Thiết lập ngày giao dịch
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        // Thiết lập ngày hết hạn
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // Thiết lập đơn vị tiền tệ VND
        vnp_Params.put("vnp_CurrCode", "VND");

        // Ngôn ngữ giao diện hiển thị - Tiếng Việt
        vnp_Params.put("vnp_Locale", "vn");

        // URL trả về sau khi thanh toán
        String vnp_ReturnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/custom-vnpay-return";
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);

        // Sắp xếp các tham số theo thứ tự a-z
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        // Tạo chuỗi hash data
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.name()));

                // Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.name()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.name()));

                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        // Tạo secure hash
        String vnp_SecureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=" + vnp_SecureHash);

        // Tạo URL thanh toán
        String paymentUrl = VNP_PAY_URL + "?" + query.toString();

        // Chuyển hướng đến trang thanh toán VNPay
        response.sendRedirect(paymentUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang giỏ hàng thiết kế riêng
        response.sendRedirect("custom-cart");
    }

    /**
     * Tạo chuỗi số ngẫu nhiên với độ dài xác định
     */
    private String getRandomNumber(int len) {
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt((int) (Math.random() * chars.length())));
        }
        return sb.toString();
    }

    /**
     * Lấy địa chỉ IP của client
     */
    private String getIpAddress(HttpServletRequest request) {
        String ipAddress;
        ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
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