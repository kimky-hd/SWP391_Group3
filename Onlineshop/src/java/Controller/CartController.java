package Controller;

import DAO.CartDAO;
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
                    response.sendRedirect("cart.jsp");
                    break;
            }
        } else {
            response.sendRedirect("cart.jsp");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Product product = cartDAO.getProductById(productId);
            if (product != null && quantity > 0) {
                cart.addItem(product, quantity);
                sendJsonResponse(response, createSuccessResponse("Sản phẩm đã được thêm vào giỏ hàng"));
            } else {
                sendJsonResponse(response, createErrorResponse("Không thể thêm sản phẩm vào giỏ hàng"));
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity > 0) {
                CartItem item = cart.getItems().get(productId);
                if (item != null) {
                    item.setQuantity(quantity);
                    sendJsonResponse(response, createSuccessResponse("Giỏ hàng đã được cập nhật"));
                } else {
                    sendJsonResponse(response, createErrorResponse("Sản phẩm không tồn tại trong giỏ hàng"));
                }
            } else {
                removeFromCart(request, response, cart);
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.removeItem(productId);
            sendJsonResponse(response, createSuccessResponse("Sản phẩm đã được xóa khỏi giỏ hàng"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, createErrorResponse("Dữ liệu không hợp lệ"));
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        cart.clear();
        sendJsonResponse(response, createSuccessResponse("Giỏ hàng đã được xóa"));
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws ServletException, IOException {
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
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