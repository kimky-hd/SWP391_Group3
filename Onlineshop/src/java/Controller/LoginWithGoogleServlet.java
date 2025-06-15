package Controller;

import DAO.AccountDAO;
import Model.Account;
import Utility.GoogleUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

@WebServlet(name = "LoginWithGoogleServlet", urlPatterns = {"/LoginWithGoogle"})
public class LoginWithGoogleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String code = request.getParameter("code");
            
            if (code == null || code.isEmpty()) {
                response.sendRedirect(GoogleUtils.getGoogleLoginUrl());
                return;
            }

            String accessToken = GoogleUtils.getToken(code);

            JSONObject userInfo = GoogleUtils.getUserInfo(accessToken);
            
            String email = (String) userInfo.get("email");
            String name = (String) userInfo.get("name");
            String picture = (String) userInfo.get("picture");
            
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.checkEmailExist(email);
            
            if (account == null) {

                String username = email.split("@")[0];

                String password = generateRandomPassword();

                boolean success = accountDAO.register(username, password, email, null);
                
                if (success) {

                    account = accountDAO.checkEmailExist(email);
                } else {
                    request.setAttribute("error", "Không thể đăng ký tài khoản mới.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("account", account);

            response.sendRedirect("Homepage");
            
        } catch (IOException | ParseException e) {
            request.setAttribute("error", "Đăng nhập bằng Google thất bại: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 12; i++) {
            int index = random.nextInt(chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
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
