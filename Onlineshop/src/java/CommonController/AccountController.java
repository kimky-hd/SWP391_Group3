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

        if ("changePassword".equals(action)) {
            // Kiểm tra người dùng đã đăng nhập chưa
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            if (account == null) {
                // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
                response.sendRedirect("login.jsp");
                return;
            }

            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Kiểm tra mật khẩu mới có hợp lệ không
            if (newPassword == null || !isValidPassword(newPassword)) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số!");
                request.getRequestDispatcher("changepassword.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu xác nhận có khớp không
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("changepassword.jsp").forward(request, response);
                return;
            }

            // Tiến hành đổi mật khẩu
            boolean success = dao.changePassword(account.getAccountID(), currentPassword, newPassword);

            if (success) {
                // Cập nhật thông tin tài khoản trong session
                account.setPassword(newPassword);
                session.setAttribute("account", account);

                request.setAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            }

            request.getRequestDispatcher("changepassword.jsp").forward(request, response);
            return;
        }

        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm-password"); // Lấy mật khẩu xác nhận
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Kiểm tra khoảng trắng trong tên đăng nhập
            if (username != null && username.contains(" ")) {
                request.setAttribute("error", "Tên đăng nhập không được chứa khoảng trắng!");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra định dạng email phải là @gmail.com
            if (email == null || !email.toLowerCase().endsWith("@gmail.com")) {
                request.setAttribute("error", "Email phải có định dạng @gmail.com!");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("username", username);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu xác nhận phải khớp với mật khẩu
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp với mật khẩu!");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (password == null || !isValidPassword(password)) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số! ");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (phone == null || !isValidVietnamesePhoneNumber(phone)) {
                request.setAttribute("error", "Số điện thoại không hợp lệ! Vui lòng nhập đúng định dạng số điện thoại. ");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            Account checkUser = dao.checkAccountExist(username);
            Account checkEmail = dao.checkEmailExist(email);
            if (checkUser != null) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else if (checkEmail != null) {
                request.setAttribute("error", "Email đã được sử dụng!");
                // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                request.setAttribute("username", username);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                boolean success = dao.register(username, password, email, phone);
                if (success) {
                    HttpSession session = request.getSession();
                    session.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
                    // Lưu lại các giá trị đã nhập để hiển thị lại trên form
                    request.setAttribute("username", username);
                    request.setAttribute("email", email);
                    request.setAttribute("phone", phone);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            }
        }
    }

    private boolean isValidPassword(String password) {
        // Kiểm tra độ dài tối thiểu 8 ký tự
        if (password.length() < 8) {
            return false;
        }
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
            "032", "033", "034", "035", "036", "037", "038", "039", "086", "096", "097", "098",
            // Vinaphone
            "081", "082", "083", "084", "085", "088", "091", "094",
            // Mobifone
            "070", "076", "077", "078", "079", "089", "090", "093",
            // Vietnamobile
            "052", "056", "058", "092",
            // Gmobile
            "059", "099",
            // Cố định (có thể bổ sung thêm mã vùng)
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
