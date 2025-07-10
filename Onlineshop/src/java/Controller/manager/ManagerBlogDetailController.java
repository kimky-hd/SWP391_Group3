package Controller.manager;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;
import Model.BlogImg;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ManagerBlogDetailController", urlPatterns = {"/manager/blog/detail"})
public class ManagerBlogDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Manager role = 1)
        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String blogIdParam = request.getParameter("id");
        if (blogIdParam == null || blogIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID blog");
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
            return;
        }

        try {
            int blogId = Integer.parseInt(blogIdParam);
            BlogDAO blogDAO = new BlogDAO();
            
            // Lấy thông tin blog
            Blog blog = blogDAO.getBlogById(blogId);
            if (blog == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy blog");
                response.sendRedirect(request.getContextPath() + "/manager/blogs");
                return;
            }
            
            // Lấy danh sách ảnh của blog
            List<BlogImg> images = blogDAO.getBlogImages(blogId);
            
            request.setAttribute("blog", blog);
            request.setAttribute("images", images);
            request.setAttribute("pageTitle", "Chi tiết: " + blog.getTitle());
            
            request.getRequestDispatcher("/manager/blog-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/blogs");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/manager/blog-detail.jsp").forward(request, response);
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
