package CommonController;

import CommonController.*;
import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
            System.out.println("Login successful, creating session");
            HttpSession session = request.getSession(true);
            session.setAttribute("account", account);
            response.sendRedirect("Homepage");
        } else {
            System.out.println("Login failed, redirecting back to login page");
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