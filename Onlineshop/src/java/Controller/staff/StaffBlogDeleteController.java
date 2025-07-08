package Controller.staff;

import DAO.BlogDAO;
import Model.Account;
import Model.BlogImg;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffBlogDeleteController", urlPatterns = {"/staff/blog/delete"})
public class StaffBlogDeleteController extends HttpServlet {
    
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
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID blog cần xóa");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
            return;
        }
        
        try {
            int blogId = Integer.parseInt(blogIdParam);
            BlogDAO blogDAO = new BlogDAO();
            
            // Lấy danh sách ảnh trước khi xóa để có thể xóa file
            List<BlogImg> blogImages = blogDAO.getBlogImages(blogId);
            
            // Xóa blog từ database (ảnh sẽ tự động bị xóa do CASCADE)
            boolean deleteSuccess = blogDAO.deleteBlog(blogId);
            
            if (deleteSuccess) {
                // Xóa các file ảnh từ hệ thống file
                deleteImageFiles(blogImages, request);
                
                request.getSession().setAttribute("successMessage", "Xóa blog thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể xóa blog. Vui lòng thử lại!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ: " + blogIdParam);
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa blog: " + e.getMessage());
        }
        
        // Redirect về danh sách blog
        response.sendRedirect(request.getContextPath() + "/staff/blogs");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST request thành GET request
        doGet(request, response);
    }
    
    private void deleteImageFiles(List<BlogImg> blogImages, HttpServletRequest request) {
        if (blogImages == null || blogImages.isEmpty()) {
            return;
        }
        
        String uploadPath = getServletContext().getRealPath("/img/blog");
        File uploadDir = new File(uploadPath);
        
        if (!uploadDir.exists()) {
            return; // Thư mục không tồn tại, không cần xóa
        }
        
        int deletedCount = 0;
        for (BlogImg blogImg : blogImages) {
            if (blogImg.getImage() != null && !blogImg.getImage().trim().isEmpty()) {
                File imageFile = new File(uploadDir, blogImg.getImage());
                if (imageFile.exists()) {
                    try {
                        if (imageFile.delete()) {
                            deletedCount++;
                        } else {
                            System.err.println("Không thể xóa file: " + imageFile.getAbsolutePath());
                        }
                    } catch (Exception e) {
                        System.err.println("Lỗi khi xóa file " + imageFile.getAbsolutePath() + ": " + e.getMessage());
                    }
                }
            }
        }
        
        System.out.println("Đã xóa " + deletedCount + "/" + blogImages.size() + " file ảnh");
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
