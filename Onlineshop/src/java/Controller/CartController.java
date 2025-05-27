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

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final Gson gson = new Gson();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

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
    
    // Sửa displayCart để sử dụng đúng tên file
    private void displayCart(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    request.getRequestDispatcher("Cart.jsp").forward(request, response);
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("Cart.jsp").forward(request, response);
    }

    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }

    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        return response;
    }

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