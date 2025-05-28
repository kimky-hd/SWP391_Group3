package CommonController;

import DAO.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import Model.Account;
@WebServlet(name = "AccountController", urlPatterns = {"/account"})
public class AccountController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");       
        String action = request.getParameter("action");
        AccountDAO dao = new AccountDAO();     
        
         if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email"); 
            String phone = request.getParameter("phone");
            
             if (password == null || !isValidPassword(password)) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số! ");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
             }
             
            if (phone == null || !isValidVietnamesePhoneNumber(phone)) {
        request.setAttribute("error", "Số điện thoại không hợp lệ! Vui lòng nhập đúng định dạng số điện thoại. ");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
            Account checkUser = dao.checkAccountExist(username);
            Account checkEmail = dao.checkEmailExist(email);            
            if (checkUser != null) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else if (checkEmail != null) {
                request.setAttribute("error", "Email đã được sử dụng!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                boolean success = dao.register(username, password, email, phone);
                if (success) {
                   HttpSession session = request.getSession();
                    session.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            }
        }  
    }
    private boolean isValidPassword(String password) {
        // Kiểm tra độ dài tối thiểu 8 ký tự
        if (password.length() < 8) {
            return false;}
        if (!password.matches(".*[A-Z].*")) {
            return false;
        }
        if (!password.matches(".*[a-z].*")) {
            return false;
        }
        if (!password.matches(".*\\d.*")) {
            return false;
        }
        return true;
    }
        
    private boolean isValidVietnamesePhoneNumber(String phone) {
    // Loại bỏ khoảng trắng và dấu gạch ngang nếu có
    phone = phone.replaceAll("\\s|-", "");
    
    // Kiểm tra độ dài (10 hoặc 11 số)
    if (phone.length() != 10 && phone.length() != 11) {
        return false;
    }
    
    // Kiểm tra chỉ chứa chữ số
    if (!phone.matches("\\d+")) {
        return false;
    }
    
    // Kiểm tra đầu số Việt Nam
    String[] validPrefixes = {
        // Viettel
        "032", "033", "034", "035", "036", "037", "038", "039",
        // Vinaphone
        "081", "082", "083", "084", "085", "086", "088", "089",
        // Mobifone
        "070", "076", "077", "078", "079",
        // Vietnamobile
        "056", "058", "059",
        // Gmobile
        "099", "059",
        // Cố định (thêm các mã vùng nếu cần)
        "024", "028"
    };
    
    // Kiểm tra số bắt đầu bằng 0
    if (!phone.startsWith("0")) {
        return false;
    }
    
    // Kiểm tra đầu số
    for (String prefix : validPrefixes) {
        if (phone.startsWith(prefix)) {
            return true;
        }
    }
    
    return false;
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

