package Controller.staff;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;
import Model.BlogImg;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "StaffBlogEditController", urlPatterns = {"/staff/blog/edit"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StaffBlogEditController extends HttpServlet {
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
            loadBlogForEdit(request, response, blogId);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-edit.jsp").forward(request, response);
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
        
        String blogIdParam = request.getParameter("blogId");
        if (blogIdParam == null || blogIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID blog");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
            return;
        }
        
        try {
            int blogId = Integer.parseInt(blogIdParam);
            
            // Lấy thông tin từ form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            // Validation
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tiêu đề không được để trống");
                loadBlogForEdit(request, response, blogId);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Nội dung không được để trống");
                loadBlogForEdit(request, response, blogId);
                return;
            }
            
            BlogDAO blogDAO = new BlogDAO();
            
            // Cập nhật thông tin blog (BlogDAO sẽ tự set blogStatus = 'Pending')
            Blog blog = new Blog();
            blog.setBlogID(blogId);
            blog.setTitle(title.trim());
            blog.setContent(content.trim());
            
            boolean updateSuccess = blogDAO.updateBlog(blog);
            
            if (updateSuccess) {
                // Xử lý upload ảnh mới (nếu có)
                uploadNewImages(request, blogId, blogDAO);
                
                request.getSession().setAttribute("successMessage", "Cập nhật blog thành công!");
                response.sendRedirect(request.getContextPath() + "/staff/blogs");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật blog");
                loadBlogForEdit(request, response, blogId);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID blog không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
      
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
           
        }
    }
    
    private void loadBlogForEdit(HttpServletRequest request, HttpServletResponse response, int blogId)
            throws ServletException, IOException, SQLException {
        
        BlogDAO blogDAO = new BlogDAO();
        
        // Lấy thông tin blog
        Blog blog = blogDAO.getBlogById(blogId);
        if (blog == null) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy blog");
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
            return;
        }
        
        // Lấy danh sách ảnh của blog
        List<BlogImg> images = blogDAO.getBlogImages(blogId);
        
        request.setAttribute("blog", blog);
        request.setAttribute("images", images);
        request.setAttribute("pageTitle", "Chỉnh sửa: " + blog.getTitle());
        request.getRequestDispatcher("/staff/blog-edit.jsp").forward(request, response);
    }
    
    private void uploadNewImages(HttpServletRequest request, int blogId, BlogDAO blogDAO) throws Exception {
        // Đường dẫn upload
        String uploadPath = getServletContext().getRealPath("/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Lấy ảnh hiện tại để xác định ảnh chính
        List<BlogImg> currentImages = blogDAO.getBlogImages(blogId);
        boolean hasMainImage = currentImages.stream().anyMatch(img -> img.isMain());
        
        // Upload các ảnh mới
        boolean isFirstImage = !hasMainImage;
        
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file unique
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    // Lưu file
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    part.write(filePath);
                    
                    // Lưu vào database
                    BlogImg blogImg = new BlogImg();
                    blogImg.setBlogID(blogId);
                    blogImg.setImage(uniqueFileName);
                    blogImg.setMain(isFirstImage);
                    
                    blogDAO.addBlogImage(blogImg);
                    
                    // Chỉ ảnh đầu tiên mới là main
                    isFirstImage = false;
                }
            }
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private boolean isStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Account account = (Account) session.getAttribute("account");
            return account != null && account.getRole() == 2; // Staff role
        }
        return false;
    }
}
