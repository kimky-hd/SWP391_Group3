package Controller;

import Model.Account;
import Model.Cart;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CheckOutController", urlPatterns = { "/checkout" })
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
        
        //Kiểm tra người dùng đã đăng nhập chưa
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
    
    /**
     * Gửi response dạng JSON
     * 
     * @param response HTTP response
     * @param data     Dữ liệu cần gửi
     */
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(data));
    }

    /**
     * Tạo response thành công
     * 
     * @param message Thông báo thành công
     * @return Map chứa thông tin response
     */
    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        return response;
    }

    /**
     * Tạo response lỗi
     * 
     * @param message Thông báo lỗi
     * @return Map chứa thông tin response
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }
}