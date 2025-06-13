package CommonController;

import DAO.AccountDAO;
import DAO.CartDAO;
import DAO.ProfileDAO;
import Model.Account;
import Model.Cart;
import Model.Profile;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Base64;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String userInput = request.getParameter("userInput");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        System.out.println("Received login request with username/email/phone: " + userInput);
        
        AccountDAO dao = new AccountDAO();
        Account account = dao.login(userInput, password);
        
        if(account != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("account", account);
            session.setMaxInactiveInterval(30*60);
            
            ProfileDAO profileDAO = new ProfileDAO();
            Profile profile = profileDAO.getProfileByAccountId(account.getAccountID());
            
            if (profile == null) {
                profile = new Profile();
                profile.setAccountId(account.getAccountID());
                profile.setEmail(account.getEmail());
                profile.setPhoneNumber(account.getPhone());
            }
            
            session.setAttribute("profile", profile);
            
            // Thêm đoạn code này để tải giỏ hàng từ database vào session
            CartDAO cartDAO = new CartDAO();
            Cart cart = cartDAO.getCartByAccount_Id(account.getAccountID());
            if (cart != null) {
                session.setAttribute("cart", cart);
            }
            
            // Xử lý Remember Me
            if (rememberMe != null) {
                String encodedUserInput = Base64.getEncoder().encodeToString(userInput.getBytes());
                String encodedPassword = Base64.getEncoder().encodeToString(password.getBytes());

                Cookie userCookie = new Cookie("savedUserInput", encodedUserInput);
                Cookie passCookie = new Cookie("savedPassword", encodedPassword);

                userCookie.setMaxAge(30 * 24 * 60 * 60);
                passCookie.setMaxAge(30 * 24 * 60 * 60);

                userCookie.setPath("/");
                passCookie.setPath("/");

                response.addCookie(userCookie);
                response.addCookie(passCookie);
            } else {
                Cookie userCookie = new Cookie("savedUserInput", "");
                Cookie passCookie = new Cookie("savedPassword", "");
                userCookie.setMaxAge(0);
                passCookie.setMaxAge(0);
                userCookie.setPath("/");
                passCookie.setPath("/");
                response.addCookie(userCookie);
                response.addCookie(passCookie);
            }
            
            // Kiểm tra role và chuyển hướng
            if(account.getRole() == 1) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("Homepage");
            }
        } else {
            request.setAttribute("error", "Sai thông tin đăng nhập!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
