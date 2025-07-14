package Controller.staff;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;
import Model.BlogImg;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "StaffBlogCreateController", urlPatterns = {"/staff/blog/create"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StaffBlogCreateController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Staff role = 2)
        if (!isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        request.setAttribute("pageTitle", "Tạo Blog Mới");
        request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền truy cập (Staff role = 2)
        if (!isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Lấy thông tin từ form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            // Validation
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tiêu đề không được để trống");
                request.setAttribute("title", title);
                request.setAttribute("content", content);
                request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Nội dung không được để trống");
                request.setAttribute("title", title);
                request.setAttribute("content", content);
                request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
                return;
            }
            
            // Lấy account ID từ session
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            int accountID = account.getAccountID();
            
            // Tạo blog mới
            Blog blog = new Blog();
            blog.setAccountID(accountID);
            blog.setTitle(title.trim());
            blog.setContent(content.trim());
            
            BlogDAO blogDAO = new BlogDAO();
            int blogID = blogDAO.createBlog(blog);
            
            if (blogID > 0) {
                // Xử lý upload ảnh
                uploadImages(request, blogID, blogDAO);
                
                request.getSession().setAttribute("successMessage", "Tạo blog thành công!");
                response.sendRedirect(request.getContextPath() + "/staff/blog/detail?id=" + blogID);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo blog");
                request.setAttribute("title", title);
                request.setAttribute("content", content);
                request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/staff/blog-create.jsp").forward(request, response);
        }
    }
    
    private void uploadImages(HttpServletRequest request, int blogID, BlogDAO blogDAO) throws Exception {
        // Tạo thư mục upload nếu chưa có
        String uploadPath = getServletContext().getRealPath("/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        boolean isFirstImage = true;
        
        // Xử lý từng file upload
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = getFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file unique
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    // Lưu file
                    File file = new File(uploadDir, uniqueFileName);
                    part.write(file.getAbsolutePath());
                    
                    // Thêm record vào database
                    BlogImg blogImg = new BlogImg();
                    blogImg.setBlogID(blogID);
                    blogImg.setImage(uniqueFileName);
                    blogImg.setMain(isFirstImage); // Ảnh đầu tiên sẽ là ảnh chính
                    
                    blogDAO.addBlogImage(blogImg);
                    isFirstImage = false;
                }
            }
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
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
