package Controller.manager;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;



@WebServlet(name = "ManagerBlogListController", urlPatterns = {"/manager/blogs"})
public class ManagerBlogListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Manager role = 1)
        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            BlogDAO blogDAO = new BlogDAO();
            
            // Lấy tham số tìm kiếm và phân trang
            String searchKeyword = request.getParameter("keyword");
            String statusFilter = request.getParameter("status");
            String pageStr = request.getParameter("page");
            
            int page = 1;
            int pageSize = 12;
            
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Lấy danh sách blog theo filter
            List<Blog> blogs;
            int totalBlogs;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                blogs = blogDAO.searchBlogsByTitle(searchKeyword.trim(), page, pageSize);
                totalBlogs = blogDAO.countBlogsByTitle(searchKeyword.trim());
                request.setAttribute("searchKeyword", searchKeyword.trim());
            } else if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                blogs = blogDAO.getBlogsByStatus(statusFilter, page, pageSize);
                totalBlogs = blogDAO.countBlogsByStatus(statusFilter);
                request.setAttribute("statusFilter", statusFilter);
            } else {
                blogs = blogDAO.getAllBlogs(page, pageSize);
                totalBlogs = blogDAO.getTotalBlogsCount();
            }
            
            // Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
            
            // Set attributes
            request.setAttribute("blogs", blogs);
            request.setAttribute("totalBlogs", totalBlogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            
            // Forward to JSP
            request.getRequestDispatcher("/manager/blog-list.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/manager/blog-list.jsp").forward(request, response);
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
