package Controller;

import DAO.BlogDAO;
import Model.Account;
import Model.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet(name = "BlogListServlet", urlPatterns = {"/blogs"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class BlogListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private boolean hasManagePermission(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        if (acc == null) {
            return false;
        }
        int role = acc.getRole();  // giả sử trong lớp Account có getRole() trả int
        return role == 1 || role == 2;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showBlogList(request, response);
                    break;
                case "detail":
                    showBlogDetail(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "create":
                    createBlog(request, response);
                    break;
                case "search":
                    searchBlogs(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateBlogData(request, response);
                    break;
                case "delete":
                    deleteBlog(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/blogs?action=list");
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xử lý BlogServlet");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, Exception {
    if (!hasManagePermission(request)) {
        response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Bạn không có quyền chỉnh sửa.");
        return;
    }

        String bidParam = request.getParameter("bid");
        if (bidParam == null || bidParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Không tìm thấy Blog ID để chỉnh sửa.");
            return;
        }

        try {
            int blogID = Integer.parseInt(bidParam);
            BlogDAO dao = new BlogDAO();
            Blog blog = dao.getBlogByID(blogID); // Lấy thông tin blog từ DB

            if (blog == null) {
                response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Bài viết không tồn tại.");
                return;
            }

            request.setAttribute("blogToEdit", blog); // Đặt đối tượng blog vào request
            request.getRequestDispatcher("blogEdit.jsp").forward(request, response); // Chuyển đến trang chỉnh sửa

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Blog ID không hợp lệ.");
        }
    }

   private void updateBlogData(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, Exception {
    if (!hasManagePermission(request)) {
        response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Bạn không có quyền cập nhật.");
        return;
    }

        // Lấy các tham số từ form
        String blogIDParam = request.getParameter("blogID"); // Lấy blogID từ hidden input
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String oldImage = request.getParameter("oldImage"); // Lấy tên ảnh cũ (nếu có)

        int blogID;
        try {
            blogID = Integer.parseInt(blogIDParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Blog ID không hợp lệ.");
            request.getRequestDispatcher("blogEdit.jsp").forward(request, response); // Chuyển về trang edit với lỗi
            return;
        }

        // VALIDATION CƠ BẢN
        if (title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề và nội dung không được để trống.");
            // Giữ lại dữ liệu đã nhập và đối tượng blog gốc để hiển thị lại form
            BlogDAO dao = new BlogDAO();
            Blog blogToEdit = dao.getBlogByID(blogID); // Lấy lại blog gốc để hiển thị lại form
            // Gán lại giá trị đã nhập vào nếu người dùng sửa nhưng bị lỗi validate
            if (blogToEdit != null) {
                blogToEdit.setTitle(title);
                blogToEdit.setContent(content);
            }
            request.setAttribute("blogToEdit", blogToEdit);
            request.getRequestDispatcher("blogEdit.jsp").forward(request, response);
            return;
        }

        String newImageName = oldImage; // Mặc định giữ ảnh cũ
        try {
            Part filePart = request.getPart("image"); // Lấy Part từ name="image"
            if (filePart != null && filePart.getSize() > 0) { // Nếu có file mới được chọn
                String submittedFileName = getFileName(filePart);
                if (submittedFileName != null && !submittedFileName.isEmpty()) {
                    String ext = "";
                    int i = submittedFileName.lastIndexOf('.');
                    if (i > 0) {
                        ext = submittedFileName.substring(i);
                    }
                    newImageName = "blog_" + System.currentTimeMillis() + ext; // Tạo tên file mới duy nhất

                    String uploadPath = request.getServletContext().getRealPath("/img");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    File file = new File(uploadDir, newImageName);

                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    System.out.println("Đã upload file mới: " + file.getAbsolutePath()); // Debug log

                    // Tùy chọn: Xóa ảnh cũ nếu có và ảnh mới đã được upload thành công
                    if (oldImage != null && !oldImage.isEmpty() && !oldImage.equals("no_image.jpg")) { // Tránh xóa ảnh mặc định
                        File oldFile = new File(uploadDir, oldImage);
                        if (oldFile.exists()) {
                            Files.delete(oldFile.toPath());
                            System.out.println("Đã xóa ảnh cũ: " + oldFile.getAbsolutePath());
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi upload file ảnh mới hoặc xóa ảnh cũ: " + e.getMessage());
            e.printStackTrace();
            // Nếu có lỗi upload, giữ lại ảnh cũ
            newImageName = oldImage;
        }

        // Tạo đối tượng Blog để cập nhật
        BlogDAO dao = new BlogDAO();
        Blog blogToUpdate = new Blog();
        blogToUpdate.setBlogID(blogID);
        blogToUpdate.setTitle(title);
        blogToUpdate.setContent(content);
        blogToUpdate.setImage(newImageName);

        dao.updateBlog(blogToUpdate);

        request.getSession().setAttribute("successMessage", "Bài blog \"" + title + "\" đã được cập nhật thành công!");
        response.sendRedirect(request.getContextPath() + "/blogs?action=detail&bid=" + blogID);
    }

    private void searchBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = ""; // Đảm bảo keyword không bao giờ là null
        }

        String pageParam = request.getParameter("page");
        int pageIndex;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        } else {
            pageIndex = 1;
        }

        BlogDAO dao = new BlogDAO();
        int totalCount = dao.getTotalBlogCountByTitle(keyword);
        int totalPages = (int) Math.ceil(totalCount * 1.0 / PAGE_SIZE);

        if (pageIndex > totalPages && totalPages > 0) {
            pageIndex = totalPages;
        } else if (totalPages == 0) {
            pageIndex = 1;
        }

        List<Blog> listPage = dao.getBlogsByTitleByPage(keyword, pageIndex, PAGE_SIZE);

        request.setAttribute("blogList", listPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("blogList.jsp").forward(request, response);
    }

    private void showBlogList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String pageParam = request.getParameter("page");
        int pageIndex;
        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        } else {
            pageIndex = 1;
        }

        BlogDAO dao = new BlogDAO();
        int totalCount = dao.getTotalBlogCount();
        int totalPages = (int) Math.ceil(totalCount * 1.0 / PAGE_SIZE);

        if (pageIndex > totalPages && totalPages > 0) {
            pageIndex = totalPages;
        }

        List<Blog> listPage = dao.getBlogsByPage(pageIndex, PAGE_SIZE);

        request.setAttribute("blogList", listPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("keyword", "");

        request.getRequestDispatcher("blogList.jsp").forward(request, response);
    }

    private void showBlogDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String bidParam = request.getParameter("bid");
        if (bidParam == null) {
            response.sendRedirect(request.getContextPath() + "/blogs?action=list");
            return;
        }

        try {
            int blogID = Integer.parseInt(bidParam);
            BlogDAO dao = new BlogDAO();
            Blog blog = dao.getBlogByID(blogID);

            if (blog == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bài viết không tồn tại");
                return;
            }

            request.setAttribute("blog", blog);
            request.getRequestDispatcher("blogDetail.jsp").forward(request, response);

        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/blog?action=list");
        }
    }

  private void showAddForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    if (!hasManagePermission(request)) {
        response.sendRedirect(request.getContextPath() + "/blogs?action=list");
        return;
    }
    request.getRequestDispatcher("blogAdd.jsp").forward(request, response);
}

    /**
     * Xử lý tạo mới bài blog (upload ảnh + lưu DB)
     */
   private void createBlog(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
    if (!hasManagePermission(request)) {
        response.sendRedirect(request.getContextPath() + "/blogs?action=list");
        return;
    }

        // 2. Lấy title và content
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // 3. Validate không được để trống
        if (title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề và nội dung không được để trống.");
            request.getRequestDispatcher("blogAdd.jsp").forward(request, response);
            return;
        }

        // 4. Lấy phần upload file
        Part filePart = request.getPart("image");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            // 4.1. Lấy tên file gốc
            String submittedFileName = getFileName(filePart);
            // 4.2. Cắt path, chỉ lấy tên
            String fullName = submittedFileName;
            int lastSlash = Math.max(fullName.lastIndexOf('/'), fullName.lastIndexOf('\\'));
            if (lastSlash >= 0) {
                fullName = fullName.substring(lastSlash + 1);
            }
            // 4.3. Tách phần extension
            String ext = "";
            int i = fullName.lastIndexOf('.');
            if (i > 0) {
                ext = fullName.substring(i);
            }
            // 4.4. Đặt tên file mới: blog_<timestamp>.ext
            fileName = "blog_" + System.currentTimeMillis() + ext;

            // 4.5. Lưu file vào folder /webapp/img/
            String uploadPath = request.getServletContext().getRealPath("/img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            File file = new File(uploadDir, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath());
            }
        }

        // 5. Lấy accountID từ session
        HttpSession session = request.getSession(false);
        int accountID = 1; // mặc định (trong trường hợp session null)
        if (session != null) {
            Account acc = (Account) session.getAttribute("account");
            if (acc != null) {
                accountID = acc.getAccountID();
            }
        }

        // 6. Tạo Blog và gọi DAO
        BlogDAO dao = new BlogDAO();
        Blog newBlog = new Blog();
        newBlog.setAccountID(accountID);
        newBlog.setTitle(title);
        newBlog.setContent(content);
        newBlog.setImage(fileName); // có thể là null nếu không upload ảnh
        dao.addBlog(newBlog);

        // 7. Redirect về list
        response.sendRedirect(request.getContextPath() + "/blogs?action=list");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return null;
        }
        for (String token : contentDisp.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf(File.separator) + 1);
            }
        }
        return null;
    }

   private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, Exception {
    if (!hasManagePermission(request)) {
        response.sendRedirect(request.getContextPath() + "/blogs?action=list&error=Bạn không có quyền xóa bài viết.");
        return;
    }

        String blogIDParam = request.getParameter("bid");
        int blogID = 0;
        String message = "";
        String imageToDelete = null;

        if (blogIDParam != null && !blogIDParam.isEmpty()) {
            try {
                blogID = Integer.parseInt(blogIDParam);
                BlogDAO blogDAO = new BlogDAO();

                Blog blogToDelete = blogDAO.getBlogByID(blogID);
                if (blogToDelete != null) {
                    imageToDelete = blogToDelete.getImage();
                }

                blogDAO.deleteBlog(blogID);
                message = "Xóa blog có ID " + blogID + " thành công!";
                System.out.println(message);

                // xóa ảnh
                if (imageToDelete != null && !imageToDelete.isEmpty() && !imageToDelete.equals("no_image.jpg")) {
                    String uploadPath = request.getServletContext().getRealPath("/img");
                    File file = new File(uploadPath, imageToDelete);
                    if (file.exists()) {
                        Files.delete(file.toPath());
                        System.out.println("Đã xóa file ảnh: " + file.getAbsolutePath());
                    }
                }

                request.getSession().setAttribute("successMessage", message);
                response.sendRedirect(request.getContextPath() + "/blogs?action=list");
                return;
            } catch (NumberFormatException e) {
                message = "ID Blog không hợp lệ: " + blogIDParam;
                System.err.println(message + ": " + e.getMessage());
                request.getSession().setAttribute("errorMessage", message);
            } catch (Exception e) {
                message = "Lỗi không xác định khi xóa blog: " + e.getMessage();
                System.err.println(message);
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", message);
            }
        } else {
            message = "Không có Blog ID để xóa.";
            System.err.println(message);
            request.getSession().setAttribute("errorMessage", message);
        }

        response.sendRedirect(request.getContextPath() + "/blogs?action=list");
    }

}
