package Controller.manager;

import DAO.BlogDAO;
import Model.Account;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ManagerBlogActionController", urlPatterns = {"/manager/blog/action"})
public class ManagerBlogActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Manager role = 1)
        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String blogIdParam = request.getParameter("blogId");
        String action = request.getParameter("action");
        String note = request.getParameter("note");
        
        if (blogIdParam == null || blogIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID blog");
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
            return;
        }
        
        if (action == null || action.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy hành động");
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
            return;
        }

        try {
            int blogId = Integer.parseInt(blogIdParam);
            BlogDAO blogDAO = new BlogDAO();
            
            String newStatus;
            String message;
            
            if ("accept".equals(action)) {
                newStatus = "Approved";
                message = "Blog đã được phê duyệt thành công!";
            } else if ("reject".equals(action)) {
                if (note == null || note.trim().isEmpty()) {
                    request.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do từ chối");
                    response.sendRedirect(request.getContextPath() + "/manager/blog/detail?id=" + blogId);
                    return;
                }
                newStatus = "Rejected";
                message = "Blog đã bị từ chối!";
            } else {
                request.getSession().setAttribute("errorMessage", "Hành động không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/blogs");
                return;
            }
            
            // Cập nhật status và note
            boolean success = blogDAO.updateBlogStatus(blogId, newStatus, note);
            
            if (success) {
                request.getSession().setAttribute("successMessage", message);
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật blog");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
        }
    }
    
    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Account account = (Account) session.getAttribute("account");
            return account != null && account.getRole() == 1; // Manager role
        }
        return false;
    }
}
