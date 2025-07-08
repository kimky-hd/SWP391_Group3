package Controller.staff;

import DAO.BlogDAO;
import DAO.AccountDAO;
import Model.Account;
import Model.Blog;
import Model.BlogImg;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet(name = "StaffBlogDetailController", urlPatterns = {"/staff/blog/detail"})
public class StaffBlogDetailController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Staff role = 2)
        if (!isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String blogIdParam = request.getParameter("id");
        if (blogIdParam == null || blogIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID blog");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
            return;
        }
        
        try {
            int blogId = Integer.parseInt(blogIdParam);
            BlogDAO blogDAO = new BlogDAO();
            AccountDAO accountDAO = new AccountDAO();
            
            // Lấy thông tin blog
            Blog blog = blogDAO.getBlogById(blogId);
            if (blog == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy blog với ID: " + blogId);
                response.sendRedirect(request.getContextPath() + "/staff/blogs");
                return;
            }
            
            // Lấy thông tin tác giả
            Account author = accountDAO.getAccountById(blog.getAccountID());
            String authorName = (author != null) ? author.getUsername() : "Không xác định";
            
            // Lấy danh sách ảnh của blog
            List<BlogImg> blogImages = blogDAO.getBlogImages(blogId);
            blog.setBlogImages(blogImages);
            
            // Tìm ảnh chính
            String mainImage = null;
            for (BlogImg img : blogImages) {
                if (img.isMain()) {
                    mainImage = img.getImage();
                    break;
                }
            }
            blog.setMainImage(mainImage);
            
            // Set attributes
            request.setAttribute("blog", blog);
            request.setAttribute("authorName", authorName);
            request.setAttribute("pageTitle", "Chi tiết Blog: " + blog.getTitle());
            
            // Forward to JSP
            request.getRequestDispatcher("/staff/blog-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ: " + blogIdParam);
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-detail.jsp").forward(request, response);
        }
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
