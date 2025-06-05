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

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            // Người dùng chưa đăng nhập
            response.sendRedirect("login.jsp");
            return;
        }
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Kiểm tra mật khẩu cũ
        AccountDAO dao = new AccountDAO();
        if (!dao.checkOldPassword(account.getAccountID(), oldPassword)) {
            request.setAttribute("error", "Mật khẩu hiện tại không chính xác!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu mới hợp lệ
        if (!isValidPassword(newPassword)) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        // Cập nhật mật khẩu mới
        boolean success = dao.changePassword(account.getAccountID(), newPassword);
        
        if (success) {
            // Cập nhật thông tin tài khoản trong session
            account.setPassword(newPassword);
            session.setAttribute("account", account);
            
            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
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