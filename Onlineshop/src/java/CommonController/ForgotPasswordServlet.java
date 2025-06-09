
package CommonController;

import DAO.AccountDAO;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import Utility.EmailSender;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/forgotpassword"})
public class ForgotPasswordServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("request".equals(action)) {
            // Xử lý yêu cầu lấy lại mật khẩu
            String email = request.getParameter("email");
            AccountDAO dao = new AccountDAO();
            Account account = dao.checkEmailExist(email);
            
            if (account == null) {
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
                return;
            }
            
            // Tạo mã xác nhận
            String resetToken = dao.generateResetToken();
            
            // Lưu mã xác nhận vào session
            HttpSession session = request.getSession();
            session.setAttribute("resetToken", resetToken);
            session.setAttribute("resetEmail", email);
            session.setMaxInactiveInterval(10 * 60); // 10 phút
            
            // Gửi email chứa mã xác nhận
           boolean emailSent = EmailSender.sendResetPasswordEmail(email, resetToken, account.getUsername());
            
            if (emailSent) {
                response.sendRedirect("resetpassword.jsp");
            } else {
                request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau!");
                request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
            }
        } else if ("verify".equals(action)) {
            // Xử lý xác minh mã token
            String token = request.getParameter("token");
            HttpSession session = request.getSession();
            String resetToken = (String) session.getAttribute("resetToken");
            
            if (resetToken == null || !resetToken.equals(token)) {
                request.setAttribute("error", "Mã xác nhận không hợp lệ hoặc đã hết hạn!");
                request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
                return;
            }
            
            // Mã xác nhận hợp lệ, chuyển đến trang đặt lại mật khẩu
            response.sendRedirect("newpassword.jsp");
            
        } else if ("reset".equals(action)) {
            // Xử lý đặt lại mật khẩu
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("resetEmail");
            
            if (email == null) {
                request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thử lại!");
                request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("newpassword.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra mật khẩu hợp lệ
            if (!isValidPassword(newPassword)) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!");
                request.getRequestDispatcher("newpassword.jsp").forward(request, response);
                return;
            }
             AccountDAO dao = new AccountDAO();
    if (dao.isPasswordSameAsOld(email, newPassword)) {
        request.setAttribute("error", "Mật khẩu mới không được giống mật khẩu cũ!");
        request.getRequestDispatcher("newpassword.jsp").forward(request, response);
        return;
    }
            
            // Cập nhật mật khẩu mới
            boolean success = dao.updatePassword(email, newPassword);
            
            if (success) {
                // Xóa thông tin reset khỏi session
                session.removeAttribute("resetToken");
                session.removeAttribute("resetEmail");
                
                // Chuyển hướng đến trang đăng nhập với thông báo thành công
                request.setAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại!");
                request.getRequestDispatcher("newpassword.jsp").forward(request, response);
            }
        }
    }
    
    private boolean isValidPassword(String password) {
        // Kiểm tra độ dài tối thiểu 8 ký tự
        if (password.length() < 8) {
            return false;
        }
        // Kiểm tra có ít nhất một chữ hoa
        if (!password.matches(".*[A-Z].*")) {
            return false;
        }
        // Kiểm tra có ít nhất một chữ thường
        if (!password.matches(".*[a-z].*")) {
            return false;
        }
        // Kiểm tra có ít nhất một chữ số
        if (!password.matches(".*\\d.*")) {
            return false;
        }
        return true;
    }
    
    private boolean sendResetEmail(String email, String resetToken, String username) {
        // Cấu hình thông tin email
        final String senderEmail = "anhhoang30012004@gmail.com"; // Thay bằng email của bạn
        final String senderPassword = "mjsp obnk obye jorx"; // Thay bằng mật khẩu ứng dụng
        
        // Thiết lập thuộc tính
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        // Tạo session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });
        
        try {
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Flower Shop");
            
            // Nội dung email
            String emailContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
                    + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Đặt lại mật khẩu</h2>"
                    + "<p>Xin chào <b>" + username + "</b>,</p>"
                    + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                    + "<p>Mã xác nhận của bạn là: <b style='font-size: 18px; color: #FF69B4;'>" + resetToken + "</b></p>"
                    + "<p>Mã này sẽ hết hạn sau 10 phút.</p>"
                    + "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>"
                    + "<p>Trân trọng,<br>Đội ngũ Flower Shop</p>"
                    + "</div>";
            
            message.setContent(emailContent, "text/html; charset=UTF-8");
            
            // Gửi email
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
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

