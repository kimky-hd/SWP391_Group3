package Controller.staff;

import Model.Account;
import Model.Feedback;
import DAO.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffReviewController", urlPatterns = {"/staff/reviews"})
public class StaffReviewController extends HttpServlet {

    private FeedbackDAO feedbackDAO;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Staff role = 2)
        if (!isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "search":
                    handleSearch(request, response);
                    break;
                case "view":
                    handleViewDetail(request, response);
                    break;
                case "reply":
                    handleReply(request, response);
                    break;
                case "hide":
                    handleHideReview(request, response);
                    break;
                default:
                    handleList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/staff/reviews.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Staff role = 2)
        if (!isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "reply":
                    handleSubmitReply(request, response);
                    break;
                case "editReply":
                    handleEditReply(request, response);
                    break;
                case "deleteReply":
                    handleDeleteReply(request, response);
                    break;
                default:
                    handleList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/staff/reviews.jsp").forward(request, response);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // System.out.println("=== DEBUG StaffReviewController.handleList ===");

        // Initialize DAO if not already done
        if (feedbackDAO == null) {
            feedbackDAO = new FeedbackDAO();
        }

        // Get all product feedbacks from database
        List<Feedback> allFeedbacks = feedbackDAO.getAllProductFeedbacksForStaff();

        // System.out.println("Retrieved " + allFeedbacks.size() + " feedbacks from DAO");

        // Set attributes for JSP
        request.setAttribute("pageTitle", "Quản lý Đánh giá");
        request.setAttribute("feedbackList", allFeedbacks);
        request.setAttribute("totalReviews", allFeedbacks.size());

        // Calculate basic statistics
        if (!allFeedbacks.isEmpty()) {
            double avgRating = allFeedbacks.stream()
                    .mapToInt(Feedback::getRating)
                    .average()
                    .orElse(0.0);
            request.setAttribute("avgRating", Math.round(avgRating * 10.0) / 10.0);
        } else {
            request.setAttribute("avgRating", 0.0);
        }

        request.setAttribute("repliedReviews", 0); // Will implement in later tasks
        request.setAttribute("visibleReviews", allFeedbacks.size());

        // Forward to JSP
        request.getRequestDispatcher("/staff/reviews.jsp").forward(request, response);
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String rating = request.getParameter("rating");
        String replyStatus = request.getParameter("replyStatus");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        // Tạm thời chỉ forward với thông tin tìm kiếm
        // Sau này sẽ thêm logic tìm kiếm từ database
        
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("ratingFilter", rating);
        request.setAttribute("replyFilter", replyStatus);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("pageTitle", "Tìm kiếm Đánh giá");
        
        // Forward to JSP
        request.getRequestDispatcher("/staff/reviews.jsp").forward(request, response);
    }
    
    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reviewId = request.getParameter("id");
        
        // Tạm thời chỉ log và redirect
        // Sau này sẽ thêm logic lấy chi tiết đánh giá từ database
        
        // System.out.println("Viewing review detail: " + reviewId);
        
        // Redirect back to list with success message
        request.getSession().setAttribute("successMessage", "Xem chi tiết đánh giá #" + reviewId);
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }
    
    private void handleReply(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reviewId = request.getParameter("id");
        
        // Tạm thời chỉ log
        // Sau này sẽ thêm logic hiển thị form phản hồi
        
        // System.out.println("Replying to review: " + reviewId);
        
        // Redirect back to list
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }
    
    private void handleHideReview(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reviewId = request.getParameter("id");
        
        // Tạm thời chỉ log
        // Sau này sẽ thêm logic ẩn đánh giá trong database
        
        // System.out.println("Hiding review: " + reviewId);

        // Redirect back to list with success message
        request.getSession().setAttribute("successMessage", "Đã ẩn đánh giá #" + reviewId);
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }

    private void handleSubmitReply(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reviewId = request.getParameter("reviewId");
        String replyContent = request.getParameter("replyContent");

        // Tạm thời chỉ log
        // Sau này sẽ thêm logic lưu phản hồi vào database

        // System.out.println("Submitting reply for review " + reviewId + ": " + replyContent);

        // Redirect back to list with success message
        request.getSession().setAttribute("successMessage", "Đã gửi phản hồi cho đánh giá #" + reviewId);
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }

    private void handleEditReply(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reviewId = request.getParameter("reviewId");
        String replyContent = request.getParameter("replyContent");

        // Tạm thời chỉ log
        // Sau này sẽ thêm logic cập nhật phản hồi trong database

        // System.out.println("Editing reply for review " + reviewId + ": " + replyContent);

        // Redirect back to list with success message
        request.getSession().setAttribute("successMessage", "Đã cập nhật phản hồi cho đánh giá #" + reviewId);
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }

    private void handleDeleteReply(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reviewId = request.getParameter("reviewId");

        // Tạm thời chỉ log
        // Sau này sẽ thêm logic xóa phản hồi trong database

        // System.out.println("Deleting reply for review: " + reviewId);
        
        // Redirect back to list with success message
        request.getSession().setAttribute("successMessage", "Đã xóa phản hồi cho đánh giá #" + reviewId);
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }
    
    private boolean isStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Account account = (Account) session.getAttribute("account");
            return account != null && account.getRole() == 2;
        }
        return false;
    }
}
