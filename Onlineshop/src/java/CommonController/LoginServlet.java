package CommonController;

import CommonController.*;
import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        System.out.println("Raw userInput: " + request.getParameter("userInput"));
        System.out.println("Raw password: " + request.getParameter("password"));
        System.out.println("\n=== Login Request ===\n");
        
        String userInput = request.getParameter("userInput");
        String password = request.getParameter("password");
        
        System.out.println("Received login request with username/email: " + userInput);
        
        AccountDAO dao = new AccountDAO();
        Account account = dao.login(userInput, password);
        
        if(account != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("account", account);
            session.setMaxInactiveInterval(30*60); // Session hết hạn sau 30 phút
            
            // Xử lý Remember Me
            String rememberMe = request.getParameter("rememberMe");
            if (rememberMe != null) {
                Cookie userCookie = new Cookie("userInput", userInput);
                Cookie passCookie = new Cookie("password", password); // Nên mã hóa mật khẩu trước khi lưu
                
                userCookie.setMaxAge(30 * 24 * 60 * 60); // Cookie tồn tại 30 ngày
                passCookie.setMaxAge(30 * 24 * 60 * 60);
                
                response.addCookie(userCookie);
                response.addCookie(passCookie);
            }
            
            // Chuyển hướng về trang chủ
            response.sendRedirect("Homepage");
        } else {
            request.setAttribute("error", "Thông tin đăng nhập không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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