package Controller;

import DAO.CartDAO;
import Model.Account;
import Model.Cart;
import Model.CartItem;
import Model.Product;
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

/**
 * CartController xử lý các thao tác liên quan đến giỏ hàng
 * 
 * Luồng xử lý chính:
 * 1. Kiểm tra session và khởi tạo giỏ hàng nếu chưa tồn tại
 * 2. Xử lý các action từ request:
 *    - add: Thêm sản phẩm vào giỏ
 *    - update: Cập nhật số lượng sản phẩm
 *    - remove: Xóa sản phẩm khỏi giỏ
 *    - clear: Xóa toàn bộ giỏ hàng
 *    - view: Hiển thị trang giỏ hàng
 * 3. Mỗi action đều kiểm tra:
 *    - Tính hợp lệ của dữ liệu đầu vào
 *    - Tồn tại của sản phẩm
 *    - Số lượng tồn kho
 *    - Trạng thái đăng nhập (với một số action)
 * 4. Kết quả trả về dưới dạng JSON hoặc chuyển hướng trang
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final Gson gson = new Gson();

    /**
     * Xử lý các request đến controller
     * 
     * @param request  HTTP request
     * @param response HTTP response
     * @throws ServletException
     * @throws IOException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // Khởi tạo giỏ hàng mới nếu chưa tồn tại trong session
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // Điều hướng các action
        if (action != null) {
            switch (action) {
                case "add":
                    addToCart(request, response, cart);
                    break;
                case "update":
                    updateCart(request, response, cart);
                    break;
                case "remove":
                    removeFromCart(request, response, cart);
                    break;
                case "clear":
                    clearCart(request, response, cart);
                    break;
                case "view":
                    viewCart(request, response, cart);
                    break;
                default:
                    displayCart(request, response);
                    break;
            }
        } else {
            displayCart(request, response);
        }
    }

    /**
     * Thêm sản phẩm vào giỏ hàng
     * 
     * Quy trình:
     * 1. Kiểm tra tính hợp lệ của productId và quantity
     * 2. Kiểm tra sự tồn tại của sản phẩm
     * 3. Kiểm tra số lượng trong giỏ hiện tại
     * 4. Kiểm tra số lượng tồn kho
     * 5. Thêm vào giỏ và trả về kết quả
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Validate input
            if (quantity <= 0) {
                sendJsonResponse(response, createErrorResponse("Số lượng phải lớn hơn 0"));
                return;
            }

            Product product = cartDAO.getProductById(productId);
            if (product == null) {
                sendJsonResponse(response, createErrorResponse("Sản phẩm không tồn tại"));
                return;
            }

            // Check current quantity in cart
            int currentQuantityInCart = 0;
            if (cart.containsProduct(productId)) {
                currentQuantityInCart = cart.getItem(productId).getQuantity();
            }

            // Check if total quantity exceeds available stock
            int totalQuantity = currentQuantityInCart + quantity;
            if (!cartDAO.checkProductAvailability(productId, totalQuantity)) {
                sendJsonResponse(response, createErrorResponse("Số lượng yêu cầu vượt quá số lượng có sẵn trong kho"));
                return;
            }

            cart.addItem(product, quantity);
            sendJsonResponse(response, createSuccessResponse("Sản phẩm đã được thêm vào giỏ hàng"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     * 
     * Quy trình:
     * 1. Kiểm tra tính hợp lệ của productId và quantity
     * 2. Nếu quantity <= 0, xóa sản phẩm khỏi giỏ
     * 3. Kiểm tra sự tồn tại của sản phẩm trong giỏ
     * 4. Kiểm tra số lượng tồn kho
     * 5. Cập nhật số lượng và trả về kết quả
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                removeFromCart(request, response, cart);
                return;
            }

            CartItem item = cart.getItem(productId);
            if (item == null) {
                sendJsonResponse(response, createErrorResponse("Sản phẩm không tồn tại trong giỏ hàng"));
                return;
            }

            // Check if new quantity exceeds available stock
            if (!cartDAO.checkProductAvailability(productId, quantity)) {
                sendJsonResponse(response, createErrorResponse("Số lượng yêu cầu vượt quá số lượng có sẵn trong kho"));
                return;
            }

            cart.updateItem(productId, quantity);
            sendJsonResponse(response, createSuccessResponse("Giỏ hàng đã được cập nhật"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     * 
     * Quy trình:
     * 1. Kiểm tra trạng thái đăng nhập
     * 2. Kiểm tra tính hợp lệ của productId
     * 3. Xóa sản phẩm từ database
     * 4. Cập nhật giỏ hàng trong session
     * 5. Trả về kết quả
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập"));
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            boolean success = cartDAO.removeFromCart(account.getAccount_ID(), productId);
            
            if (success) {
                cart.removeItem(productId);
                updateSessionCart(session, account.getAccount_ID());
                sendJsonResponse(response, createSuccessResponse("Đã xóa sản phẩm khỏi giỏ hàng"));
            } else {
                sendJsonResponse(response, createErrorResponse("Không thể xóa sản phẩm"));
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    /**
     * Xóa toàn bộ giỏ hàng
     * 
     * Quy trình:
     * 1. Kiểm tra trạng thái đăng nhập
     * 2. Xóa giỏ hàng từ database
     * 3. Xóa giỏ hàng trong session
     * 4. Trả về kết quả
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendJsonResponse(response, createErrorResponse("Vui lòng đăng nhập"));
            return;
        }
        
        boolean success = cartDAO.clearCart(account.getAccount_ID());
        
        if (success) {
            cart.clear();
            updateSessionCart(session, account.getAccount_ID());
            sendJsonResponse(response, createSuccessResponse("Đã xóa toàn bộ giỏ hàng"));
        } else {
            sendJsonResponse(response, createErrorResponse("Không thể xóa giỏ hàng"));
        }
    }
    
    /**
     * Cập nhật thông tin giỏ hàng trong session
     * 
     * Quy trình:
     * 1. Lấy giỏ hàng từ database theo accountId
     * 2. Cập nhật giỏ hàng vào session
     * 3. Cập nhật số lượng sản phẩm trong giỏ để hiển thị
     * 4. Xử lý trường hợp lỗi bằng cách tạo giỏ hàng trống
     */
    private void updateSessionCart(HttpSession session, int accountId) {
        try {
            Cart cart = cartDAO.getCartByAccount_Id(accountId);
            if (cart == null) {
                cart = new Cart();
            }
            session.setAttribute("cart", cart);
            
            // Also update cart item count for header display
            int itemCount = cartDAO.getCartItemCount(accountId);
            session.setAttribute("cartItemCount", itemCount);
        } catch (Exception e) {
            e.printStackTrace();
            // If error, create empty cart
            session.setAttribute("cart", new Cart());
            session.setAttribute("cartItemCount", 0);
        }
    }
    
    /**
     * Hiển thị trang giỏ hàng
     * Chuyển hướng người dùng đến trang Cart.jsp
     */
    private void displayCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Cart.jsp").forward(request, response);
    }

    /**
     * Xem giỏ hàng
     * 
     * Quy trình:
     * 1. Đặt giỏ hàng vào request attribute
     * 2. Chuyển hướng đến trang giỏ hàng
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("Cart.jsp").forward(request, response);
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
        response.getWriter().write(gson.toJson(data));
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