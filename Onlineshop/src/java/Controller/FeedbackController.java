package Controller;

import DAO.FeedbackDAO;
import DAO.OrderDAO;
import DAO.OrderDetailDAO;
import Model.Account;
import Model.Feedback;
import Model.Order;
import Model.OrderDetail;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "FeedbackController", urlPatterns = {"/FeedbackController"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class FeedbackController extends HttpServlet {
    
    private FeedbackDAO feedbackDAO;
    private OrderDAO orderDAO;
    private OrderDetailDAO orderDetailDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        feedbackDAO = new FeedbackDAO();
        orderDAO = new OrderDAO();
        orderDetailDAO = new OrderDetailDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "getOrderProducts":
                    getOrderProducts(request, response);
                    break;
                case "getFeedbacks":
                    getFeedbacks(request, response);
                    break;
                case "getFeedbackStats":
                    getFeedbackStats(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "submitRatings":
                    submitRatings(request, response);
                    break;
                case "submitRating":
                    submitSingleRating(request, response);
                    break;
                case "submitProductRating":
                    submitProductRating(request, response);
                    break;
                case "checkProductFeedback":
                    checkProductFeedback(request, response);
                    break;
                case "create":
                    createFeedback(request, response);
                    break;
                case "update":
                    updateFeedback(request, response);
                    break;
                case "delete":
                    deleteFeedback(request, response);
                    break;
                case "deleteOrderFeedback":
                    deleteOrderFeedback(request, response);
                    break;
                case "checkOrderFeedback":
                    checkOrderFeedback(request, response);
                    break;
                case "updateOrderFeedback":
                    updateOrderFeedback(request, response);
                    break;
                case "deleteOrderFeedbackById":
                    deleteOrderFeedbackById(request, response);
                    break;
                case "updateProductFeedback":
                    updateProductFeedback(request, response);
                    break;
                case "deleteProductFeedback":
                    deleteProductFeedback(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage());
        }
    }
    
    private void getOrderProducts(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            sendErrorResponse(response, "Mã đơn hàng không hợp lệ");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // Get order information
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                sendErrorResponse(response, "Không tìm thấy đơn hàng");
                return;
            }
            
            // Verify order belongs to current user
            if (order.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền truy cập đơn hàng này");
                return;
            }
            
            // Check if order is completed
            if (!"Đã giao hàng thành công".equals(order.getStatus())) {
                sendErrorResponse(response, "Chỉ có thể đánh giá đơn hàng đã giao thành công");
                return;
            }
            
            // Get order details (products)
            List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
            
            // Prepare response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("order", order);
            responseData.put("products", orderDetails);
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Mã đơn hàng không hợp lệ");
        }
    }
    
    private void submitRatings(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String ratingsJson = request.getParameter("ratings");
        
        if (orderIdStr == null || ratingsJson == null) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // Verify order belongs to current user
            Order order = orderDAO.getOrderById(orderId);
            if (order == null || order.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền đánh giá đơn hàng này");
                return;
            }
            
            // Parse ratings JSON
            JsonParser parser = new JsonParser();
            JsonArray ratingsArray = parser.parse(ratingsJson).getAsJsonArray();
            
            List<Feedback> feedbacks = new ArrayList<>();
            
            for (JsonElement element : ratingsArray) {
                JsonObject ratingObj = element.getAsJsonObject();
                
                int productId = ratingObj.get("productId").getAsInt();
                int rating = ratingObj.get("rating").getAsInt();
                String comment = ratingObj.has("comment") ? ratingObj.get("comment").getAsString() : "";
                
                // Check if feedback already exists for this product and user
                if (feedbackDAO.hasFeedback(account.getAccountID(), productId)) {
                    continue; // Skip if already rated
                }
                
                // Create feedback object
                Feedback feedback = new Feedback();
                feedback.setAccountId(account.getAccountID());
                feedback.setProductId(productId);
                feedback.setRating(rating);
                feedback.setComment(comment);
                feedback.setOrderId(orderId);
                
                feedbacks.add(feedback);
            }
            
            // Save all feedbacks
            boolean success = true;
            for (Feedback feedback : feedbacks) {
                if (!feedbackDAO.createFeedback(feedback)) {
                    success = false;
                    break;
                }
            }
            
            Map<String, Object> responseData = new HashMap<>();
            if (success && !feedbacks.isEmpty()) {
                responseData.put("success", true);
                responseData.put("message", "Đánh giá đã được gửi thành công!");
            } else if (feedbacks.isEmpty()) {
                responseData.put("success", false);
                responseData.put("message", "Bạn đã đánh giá tất cả sản phẩm trong đơn hàng này rồi");
            } else {
                responseData.put("success", false);
                responseData.put("message", "Có lỗi xảy ra khi lưu đánh giá");
            }
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    private void submitSingleRating(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        if (orderIdStr == null || ratingStr == null) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Verify order belongs to current user
            Order order = orderDAO.getOrderById(orderId);
            if (order == null || order.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền đánh giá đơn hàng này");
                return;
            }
            
            // Check if order is completed
            if (!"Đã giao hàng thành công".equals(order.getStatus())) {
                sendErrorResponse(response, "Chỉ có thể đánh giá đơn hàng đã giao thành công");
                return;
            }
            
            // Get products from the order
            List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderId);
            if (orderDetails.isEmpty()) {
                sendErrorResponse(response, "Không tìm thấy sản phẩm trong đơn hàng này");
                return;
            }

            // For now, rate the first product in the order (can be modified to rate all products)
            OrderDetail firstProduct = orderDetails.get(0);
            int productId = firstProduct.getProductId();

            // Check if feedback already exists for this product and user
            if (feedbackDAO.hasFeedback(account.getAccountID(), productId)) {
                // User already rated this product, redirect to product page
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Bạn đã đánh giá sản phẩm này rồi");
                responseData.put("productId", productId);
                responseData.put("redirectUrl", "ViewProductDetail?productid=" + productId);

                PrintWriter out = response.getWriter();
                out.print(gson.toJson(responseData));
                out.flush();
                return;
            }

            // Create feedback object for PRODUCT type
            Feedback feedback = new Feedback();
            feedback.setAccountId(account.getAccountID());
            feedback.setProductId(productId);
            feedback.setOrderId(orderId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");

            // Save feedback using the feedbacks table with PRODUCT type
            boolean success = feedbackDAO.createProductFeedback(feedback);

            Map<String, Object> responseData = new HashMap<>();
            if (success) {
                responseData.put("success", true);
                responseData.put("message", "Đánh giá đã được gửi thành công!");
                responseData.put("productId", productId); // Add product ID for redirect
                responseData.put("redirectUrl", "ViewProductDetail?productid=" + productId);
            } else {
                responseData.put("success", false);
                responseData.put("message", "Có lỗi xảy ra khi lưu đánh giá");
            }
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    private void getFeedbacks(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            sendErrorResponse(response, "Product ID is required");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            List<Feedback> feedbacks = feedbackDAO.getFeedbacksByProductId(productId);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("feedbacks", feedbacks);
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid product ID");
        }
    }
    
    private void getFeedbackStats(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            sendErrorResponse(response, "Product ID is required");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            Map<String, Object> stats = feedbackDAO.getFeedbackStats(productId);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("stats", stats);
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid product ID");
        }
    }
    
    private void createFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                sendErrorResponse(response, "Đánh giá phải từ 1 đến 5 sao");
                return;
            }
            
            // Check if user already rated this product
            if (feedbackDAO.hasFeedback(account.getAccountID(), productId)) {
                sendErrorResponse(response, "Bạn đã đánh giá sản phẩm này rồi");
                return;
            }
            
            Feedback feedback = new Feedback();
            feedback.setAccountId(account.getAccountID());
            feedback.setProductId(productId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");
            
            boolean success = feedbackDAO.createFeedback(feedback);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Đánh giá đã được gửi thành công!" : "Có lỗi xảy ra khi gửi đánh giá");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }
    
    private void updateFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                sendErrorResponse(response, "Đánh giá phải từ 1 đến 5 sao");
                return;
            }
            
            // Check ownership
            Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
            if (existingFeedback == null || existingFeedback.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền chỉnh sửa đánh giá này");
                return;
            }
            
            existingFeedback.setRating(rating);
            existingFeedback.setComment(comment != null ? comment : "");
            
            boolean success = feedbackDAO.updateFeedback(existingFeedback);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Đánh giá đã được cập nhật thành công!" : "Có lỗi xảy ra khi cập nhật đánh giá");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }
    
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }
        
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            
            // Check ownership
            Feedback existingFeedback = feedbackDAO.getFeedbackById(feedbackId);
            if (existingFeedback == null || existingFeedback.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền xóa đánh giá này");
                return;
            }
            
            boolean success = feedbackDAO.deleteFeedback(feedbackId);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Đánh giá đã được xóa thành công!" : "Có lỗi xảy ra khi xóa đánh giá");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }
    
    private void deleteOrderFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            sendErrorResponse(response, "Order ID is required");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Delete feedback from feedbacks table
            boolean success = feedbackDAO.deleteOrderFeedback(account.getAccountID(), orderId);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Đã xóa feedback thành công!" : "Không tìm thấy feedback để xóa");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid order ID");
        }
    }

    private void checkOrderFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            sendErrorResponse(response, "Order ID is required");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Check if feedback exists
            boolean exists = feedbackDAO.checkFeedbackExists(account.getAccountID(), orderId);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("exists", exists);
            responseData.put("message", exists ? "Feedback đã tồn tại" : "Chưa có feedback");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid order ID");
        }
    }

    private void updateOrderFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (feedbackIdStr == null || ratingStr == null) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);
            int rating = Integer.parseInt(ratingStr);

            // Validate rating
            if (rating < 1 || rating > 5) {
                sendErrorResponse(response, "Đánh giá phải từ 1 đến 5 sao");
                return;
            }

            // Update feedback
            boolean success = feedbackDAO.updateOrderFeedback(feedbackId, account.getAccountID(), rating, comment);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Cập nhật đánh giá thành công!" : "Không thể cập nhật đánh giá");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }

    private void deleteOrderFeedbackById(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        if (feedbackIdStr == null) {
            sendErrorResponse(response, "Feedback ID is required");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);

            // Delete feedback (only if it belongs to current user)
            boolean success = feedbackDAO.deleteOrderFeedbackById(feedbackId, account.getAccountID());

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Xóa đánh giá thành công!" : "Không thể xóa đánh giá");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid feedback ID");
        }
    }

    /**
     * Check if user has already provided feedback for a specific product
     */
    private void checkProductFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String orderIdStr = request.getParameter("orderId");

        if (productIdStr == null || orderIdStr == null) {
            sendErrorResponse(response, "Thiếu thông tin sản phẩm hoặc đơn hàng");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int orderId = Integer.parseInt(orderIdStr);

            // Check if feedback exists
            boolean hasFeedback = feedbackDAO.hasFeedback(account.getAccountID(), productId);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("hasFeedback", hasFeedback);

            if (hasFeedback) {
                // Get existing feedback details
                List<Feedback> feedbacks = feedbackDAO.getFeedbacksByProductId(productId);
                for (Feedback feedback : feedbacks) {
                    if (feedback.getAccountId() == account.getAccountID()) {
                        responseData.put("feedback", feedback);
                        break;
                    }
                }
            }

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Thông tin sản phẩm hoặc đơn hàng không hợp lệ");
        }
    }

    /**
     * Submit rating for individual product
     */
    private void submitProductRating(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (orderIdStr == null || productIdStr == null || ratingStr == null) {
            sendErrorResponse(response, "Thiếu thông tin cần thiết");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            // Verify order belongs to current user
            Order order = orderDAO.getOrderById(orderId);
            if (order == null || order.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền đánh giá đơn hàng này");
                return;
            }

            // Check if order is completed
            if (!"Đã giao hàng thành công".equals(order.getStatus())) {
                sendErrorResponse(response, "Chỉ có thể đánh giá đơn hàng đã giao thành công");
                return;
            }

            // Check if feedback already exists for this product and user
            if (feedbackDAO.hasFeedback(account.getAccountID(), productId)) {
                sendErrorResponse(response, "Bạn đã đánh giá sản phẩm này rồi");
                return;
            }

            // Create feedback object for PRODUCT type
            Feedback feedback = new Feedback();
            feedback.setAccountId(account.getAccountID());
            feedback.setProductId(productId);
            feedback.setOrderId(orderId);
            feedback.setRating(rating);
            feedback.setComment(comment != null ? comment : "");

            // Save feedback using the feedbacks table with PRODUCT type
            boolean success = feedbackDAO.createProductFeedback(feedback);

            // Check if this is an AJAX request or form submission
            String contentType = request.getContentType();
            String acceptHeader = request.getHeader("Accept");
            boolean isAjaxRequest = (acceptHeader != null && acceptHeader.contains("application/json")) ||
                                   "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

            if (success) {
                if (isAjaxRequest) {
                    // AJAX response
                    Map<String, Object> responseData = new HashMap<>();
                    responseData.put("success", true);
                    responseData.put("message", "Đánh giá sản phẩm thành công");
                    responseData.put("productId", productId);
                    responseData.put("redirectUrl", "ViewProductDetail?productid=" + productId);

                    PrintWriter out = response.getWriter();
                    out.print(gson.toJson(responseData));
                    out.flush();
                } else {
                    // Form submission - redirect to product detail page
                    response.sendRedirect("ViewProductDetail?productid=" + productId + "&highlight=latest");
                }
            } else {
                if (isAjaxRequest) {
                    // AJAX error response
                    Map<String, Object> responseData = new HashMap<>();
                    responseData.put("success", false);
                    responseData.put("message", "Không thể lưu đánh giá");

                    PrintWriter out = response.getWriter();
                    out.print(gson.toJson(responseData));
                    out.flush();
                } else {
                    // Form submission error - redirect back with error
                    response.sendRedirect("product-rating-simple.jsp?orderId=" + orderId + "&error=1");
                }
            }

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Thông tin không hợp lệ");
        }
    }

    /**
     * Update product feedback
     */
    private void updateProductFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (feedbackIdStr == null || ratingStr == null) {
            sendErrorResponse(response, "Thiếu thông tin cần thiết");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);
            int rating = Integer.parseInt(ratingStr);

            // Validate rating
            if (rating < 1 || rating > 5) {
                sendErrorResponse(response, "Đánh giá phải từ 1 đến 5 sao");
                return;
            }

            // Check ownership - get existing feedback first
            Feedback existingFeedback = feedbackDAO.getProductFeedbackById(feedbackId);
            if (existingFeedback == null || existingFeedback.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền sửa đánh giá này");
                return;
            }

            // Update feedback using feedbacks table
            boolean success = feedbackDAO.updateProductFeedback(feedbackId, account.getAccountID(), rating, comment != null ? comment.trim() : "");

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Cập nhật đánh giá thành công!" : "Không thể cập nhật đánh giá");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }

    /**
     * Delete product feedback
     */
    private void deleteProductFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            sendErrorResponse(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");

        if (feedbackIdStr == null) {
            sendErrorResponse(response, "Thiếu thông tin feedback ID");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);

            // Check ownership - get existing feedback first
            Feedback existingFeedback = feedbackDAO.getProductFeedbackById(feedbackId);
            if (existingFeedback == null || existingFeedback.getAccountId() != account.getAccountID()) {
                sendErrorResponse(response, "Bạn không có quyền xóa đánh giá này");
                return;
            }

            // Delete feedback using feedbacks table
            boolean success = feedbackDAO.deleteProductFeedbackById(feedbackId, account.getAccountID());

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", success ? "Xóa đánh giá thành công!" : "Không thể xóa đánh giá");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Dữ liệu không hợp lệ");
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("message", message);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(errorResponse));
        out.flush();
    }
}