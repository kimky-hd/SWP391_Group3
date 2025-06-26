package CommonController;

import DAO.AccountDAO;
import Model.Account;
import Utility.EmailSender;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AccountVerificationServlet", urlPatterns = {"/account-verification"})
public class AccountVerification extends HttpServlet {

    private final Gson gson = new Gson();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> jsonResponse = new HashMap<>();
        
        String action = request.getParameter("action");
        AccountDAO dao = new AccountDAO();
        
        try {
            if ("send".equals(action)) {
    // Xử lý gửi mã xác nhận
    String email = request.getParameter("email");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    
    // Kiểm tra khoảng trắng trong tên đăng nhập
    if (username != null && username.contains(" ")) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Tên đăng nhập không được chứa khoảng trắng!");
        out.print(gson.toJson(jsonResponse));
        return;
    }
    
   // Kiểm tra khoảng trắng trong email
    if (email != null && email.contains(" ")) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Email không được chứa khoảng trắng!");
        out.print(gson.toJson(jsonResponse));
        return;
    }
    
    if (phone != null && phone.contains(" ")) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Số điện thoại không được chứa khoảng trắng!");
        out.print(gson.toJson(jsonResponse));
        return;
    }
    
    if (password != null && password.contains(" ")) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Mật khẩu không được chứa khoảng trắng!");
        out.print(gson.toJson(jsonResponse));
        return;
    }
    
                
                // Trong phương thức processRequest, phần xử lý action "send"

// Kiểm tra email đã tồn tại chưa
Account checkEmail = dao.checkEmailExist(email);
if (checkEmail != null) {
    jsonResponse.put("success", false);
    jsonResponse.put("message", "Email đã được sử dụng!");
    out.print(gson.toJson(jsonResponse));
    return;
}

// Kiểm tra username đã tồn tại chưa
Account checkUser = dao.checkAccountExist(username);
if (checkUser != null) {
    jsonResponse.put("success", false);
    jsonResponse.put("message", "Tên đăng nhập đã tồn tại!");
    out.print(gson.toJson(jsonResponse));
    return;
}

// Kiểm tra định dạng số điện thoại
if (phone != null && !phone.isEmpty()) {
    // Loại bỏ khoảng trắng và dấu gạch ngang
    String cleanPhone = phone.replaceAll("\\s|-", "");
    
    // Kiểm tra chỉ chứa số
    if (!cleanPhone.matches("^\\d+$")) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Số điện thoại chỉ được chứa chữ số!");
        out.print(gson.toJson(jsonResponse));
        return;
    }
}
                
                // Tạo mã xác nhận
                String verificationCode = dao.generateResetToken(); // Sử dụng lại phương thức tạo token
                
                // Lưu thông tin đăng ký và mã xác nhận vào session
                HttpSession session = request.getSession();
                session.setAttribute("verificationCode", verificationCode);
                session.setAttribute("registerUsername", username);
                session.setAttribute("registerPassword", password);
                session.setAttribute("registerEmail", email);
                session.setAttribute("registerPhone", phone);
                session.setMaxInactiveInterval(10 * 60); // 10 phút
                
                // Gửi email chứa mã xác nhận
                boolean emailSent = EmailSender.sendRegistrationVerificationEmail(email, verificationCode, username);
                
                if (emailSent) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Mã xác nhận đã được gửi đến email của bạn.");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Không thể gửi email. Vui lòng thử lại sau!");
                }
            } else if ("verify".equals(action)) {
                // Xử lý xác minh mã
                String verificationCode = request.getParameter("verificationCode");
                String email = request.getParameter("email");
                
                HttpSession session = request.getSession();
                String storedCode = (String) session.getAttribute("verificationCode");
                String storedEmail = (String) session.getAttribute("registerEmail");
                
                if (storedCode == null || !storedCode.equals(verificationCode) || !storedEmail.equals(email)) {
                    // Mã xác nhận không hợp lệ hoặc đã hết hạn
                    response.setContentType("text/html;charset=UTF-8");
                    request.setAttribute("error", "Mã xác nhận không hợp lệ hoặc đã hết hạn!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                
                // Mã xác nhận hợp lệ, tiến hành đăng ký tài khoản
                String username = (String) session.getAttribute("registerUsername");
                String password = (String) session.getAttribute("registerPassword");
                String phone = (String) session.getAttribute("registerPhone");
                
                boolean success = dao.register(username, password, email, phone);
                
                if (success) {
                    // Xóa thông tin đăng ký khỏi session
                    session.removeAttribute("verificationCode");
                    session.removeAttribute("registerUsername");
                    session.removeAttribute("registerPassword");
                    session.removeAttribute("registerEmail");
                    session.removeAttribute("registerPhone");
                    session.setAttribute("autoFillUsername", username);
    session.setAttribute("autoFillEmail", email);
                    
                    // Chuyển hướng đến trang đăng nhập với thông báo thành công
                    session.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    response.sendRedirect("login.jsp");
                } else {
                    // Đăng ký thất bại
                    response.setContentType("text/html;charset=UTF-8");
                    request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            } else if ("resend".equals(action)) {
                // Xử lý gửi lại mã xác nhận
                String email = request.getParameter("email");
                HttpSession session = request.getSession();
                String username = (String) session.getAttribute("registerUsername");
                
                if (username == null || email == null) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Phiên làm việc đã hết hạn. Vui lòng thử lại!");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                
                // Tạo mã xác nhận mới
                String verificationCode = dao.generateResetToken();
                session.setAttribute("verificationCode", verificationCode);
                session.setMaxInactiveInterval(10 * 60); // 10 phút
                
                // Gửi email chứa mã xác nhận
               boolean emailSent = EmailSender.sendRegistrationVerificationEmail(email, verificationCode, username);
                
                if (emailSent) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Mã xác nhận mới đã được gửi đến email của bạn.");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Không thể gửi email. Vui lòng thử lại sau!");
                }
            }
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(gson.toJson(jsonResponse));
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

    @Override
    public String getServletInfo() {
        return "Account Verification Servlet";
    }
}