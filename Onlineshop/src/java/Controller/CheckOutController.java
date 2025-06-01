package Controller;

import Model.Account;
import Model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CheckOutController", urlPatterns = {"/checkout"})
public class CheckOutController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        // Kiểm tra giỏ hàng có tồn tại và có sản phẩm không
        if (cart == null || cart.isEmpty()) {
            request.getSession().setAttribute("message", "Giỏ hàng trống, vui lòng thêm sản phẩm trước khi thanh toán");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("Cart.jsp");
            return;
        }
        
        // Kiểm tra người dùng đã đăng nhập chưa
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            request.getSession().setAttribute("message", "Vui lòng đăng nhập để tiến hành thanh toán");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Truyền thông tin giỏ hàng vào request để hiển thị trên trang thanh toán
        request.setAttribute("cart", cart);
        
        // Chuyển hướng đến trang thanh toán
        request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
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