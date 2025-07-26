package Controller.staff;

import Model.Account;
import DAO.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.JsonObject;

@WebServlet(name = "ReviewActionController", urlPatterns = {
    "/staff/reviews/hide", 
    "/staff/reviews/show", 
    "/staff/reviews/reply"
})
public class ReviewActionController extends HttpServlet {

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is staff
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Debug logging
        System.out.println("DEBUG - Account: " + (account != null ? account.getUsername() : "null"));
        System.out.println("DEBUG - Role: " + (account != null ? account.getRole() : "null"));

        if (account == null) {
            sendJsonResponse(response, false, "Bạn chưa đăng nhập!");
            return;
        }

        // Allow both admin (role 1) and staff (role 2) to perform actions
        if (account.getRole() != 1 && account.getRole() != 2) {
            sendJsonResponse(response, false, "Bạn không có quyền thực hiện thao tác này! Role: " + account.getRole());
            return;
        }
        
        String action = getActionFromPath(request.getRequestURI());
        String reviewIdStr = request.getParameter("reviewId");
        
        if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
            sendJsonResponse(response, false, "ID đánh giá không hợp lệ!");
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            
            switch (action) {
                case "hide":
                    handleHideReview(request, response, reviewId);
                    break;
                case "show":
                    handleShowReview(request, response, reviewId);
                    break;
                case "reply":
                    handleReplyReview(request, response, reviewId);
                    break;
                default:
                    sendJsonResponse(response, false, "Thao tác không hợp lệ!");
                    break;
            }
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID đánh giá không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    private String getActionFromPath(String requestURI) {
        if (requestURI.endsWith("/hide")) {
            return "hide";
        } else if (requestURI.endsWith("/show")) {
            return "show";
        } else if (requestURI.endsWith("/reply")) {
            return "reply";
        }
        return "";
    }
    
    private void handleHideReview(HttpServletRequest request, HttpServletResponse response, int reviewId) 
            throws IOException {
        try {
            // Update review status to hidden in database
            boolean success = feedbackDAO.updateReviewVisibility(reviewId, false);
            
            if (success) {
                sendJsonResponse(response, true, "Đánh giá đã được ẩn thành công!");
            } else {
                sendJsonResponse(response, false, "Không thể ẩn đánh giá. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Có lỗi xảy ra khi ẩn đánh giá!");
        }
    }
    
    private void handleShowReview(HttpServletRequest request, HttpServletResponse response, int reviewId) 
            throws IOException {
        try {
            // Update review status to visible in database
            boolean success = feedbackDAO.updateReviewVisibility(reviewId, true);
            
            if (success) {
                sendJsonResponse(response, true, "Đánh giá đã được hiện thành công!");
            } else {
                sendJsonResponse(response, false, "Không thể hiện đánh giá. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Có lỗi xảy ra khi hiện đánh giá!");
        }
    }
    
    private void handleReplyReview(HttpServletRequest request, HttpServletResponse response, int reviewId)
            throws IOException {
        try {
            String replyText = request.getParameter("replyText");
            String action = request.getParameter("action"); // "generate" or "send"

            if (replyText == null || replyText.trim().isEmpty()) {
                sendJsonResponse(response, false, "Nội dung trả lời không được để trống!");
                return;
            }

            // Get staff account info
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            // Create formatted reply
            String formattedReply = "Kính chào quý khách,\n\n" +
                                  "Cảm ơn quý khách đã dành thời gian đánh giá sản phẩm của chúng tôi.\n\n" +
                                  replyText.trim() + "\n\n" +
                                  "Trân trọng,\n" +
                                  "Đội ngũ chăm sóc khách hàng\n" +
                                  "Flower Shop";

            // If action is "send", save the reply to database
            if ("send".equals(action)) {
                boolean success = feedbackDAO.addStaffReplyToFeedback(reviewId, account.getAccountID(), replyText.trim());

                if (success) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    JsonObject jsonResponse = new JsonObject();
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Trả lời đã được gửi thành công!");

                    PrintWriter out = response.getWriter();
                    out.print(jsonResponse.toString());
                    out.flush();
                } else {
                    sendJsonResponse(response, false, "Không thể lưu trả lời. Vui lòng thử lại!");
                }
            } else {
                // Just generate formatted reply for preview
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Nội dung trả lời đã được tạo!");
                jsonResponse.addProperty("formattedReply", formattedReply);

                PrintWriter out = response.getWriter();
                out.print(jsonResponse.toString());
                out.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Có lỗi xảy ra khi xử lý trả lời!");
        }
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        
        PrintWriter out = response.getWriter();
        out.print(jsonResponse.toString());
        out.flush();
    }
}
