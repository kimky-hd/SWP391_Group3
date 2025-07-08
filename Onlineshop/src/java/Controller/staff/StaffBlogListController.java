package Controller.staff;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffBlogListController", urlPatterns = {"/staff/blogs"})
public class StaffBlogListController extends HttpServlet {
    
    private static final int PAGE_SIZE = 8;
    
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
            BlogDAO blogDAO = new BlogDAO();
            
            switch (action) {
                case "search":
                    handleSearch(request, response, blogDAO);
                    break;
                default:
                    handleList(request, response, blogDAO);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-list.jsp").forward(request, response);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response, BlogDAO blogDAO) 
            throws ServletException, IOException, SQLException {
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Lấy danh sách blog
        List<Blog> blogs = blogDAO.getAllBlogs(page, PAGE_SIZE);
        int totalBlogs = blogDAO.getTotalBlogsCount();
        int totalPages = (int) Math.ceil((double) totalBlogs / PAGE_SIZE);
        
        // Set attributes
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("pageTitle", "Danh sách Blog");
        
        // Forward to JSP
        request.getRequestDispatcher("/staff/blog-list.jsp").forward(request, response);
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, BlogDAO blogDAO) 
            throws ServletException, IOException, SQLException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Tìm kiếm blog
        List<Blog> blogs = blogDAO.searchBlogs(keyword, page, PAGE_SIZE);
        int totalBlogs = blogDAO.getSearchResultCount(keyword);
        int totalPages = (int) Math.ceil((double) totalBlogs / PAGE_SIZE);
        
        // Set attributes
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("pageTitle", "Tìm kiếm Blog: " + keyword);
        
        // Forward to JSP
        request.getRequestDispatcher("/staff/blog-list.jsp").forward(request, response);
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
