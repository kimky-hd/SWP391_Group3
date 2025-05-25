package controller;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String userInput = request.getParameter("userInput");
        String password = request.getParameter("password");
        
        // Kiểm tra đầu vào
        if (userInput == null || password == null || userInput.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đăng nhập!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        AccountDAO dao = new AccountDAO();
        Account account = dao.login(userInput, password);
        
        if(account != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("account", account);
            session.setMaxInactiveInterval(30*60); // Session hết hạn sau 30 phút
            
            // Chuyển hướng về trang chủ sau khi đăng nhập thành công
            // Chuyển hướng về trang chủ sau khi đăng nhập thành công
            response.sendRedirect("Homepage");  // Giữ nguyên như vậy vì đã đúng với URL pattern
        } else {
            request.setAttribute("error", "Thông tin đăng nhập không đúng!");
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