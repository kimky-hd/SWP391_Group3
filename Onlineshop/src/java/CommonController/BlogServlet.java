package CommonController;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import Model.Blog;
import DAO.BlogDAO;

public class BlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BlogDAO dao = new BlogDAO();
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int blogId = Integer.parseInt(req.getParameter("id"));
                dao.deleteBlog(blogId);
                resp.sendRedirect("blog");
                return;
            }
            List<Blog> blogs = dao.getAllBlogs();
            req.setAttribute("blogs", blogs);
            // Tạm thời gán cứng giá trị isStaff là true để kiểm tra
            req.setAttribute("isStaff", true);
            req.getRequestDispatcher("BlogList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String blogIDStr = req.getParameter("blogID");
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String image = req.getParameter("image");
        int accountID = 1; // Tạm thời gán cứng, nếu có đăng nhập thì lấy từ session
        BlogDAO dao = new BlogDAO();
        try {
            if (blogIDStr != null && !blogIDStr.isEmpty()) {
                int blogID = Integer.parseInt(blogIDStr);
                Blog blog = new Blog(blogID, accountID, title, content, image, null);
                dao.updateBlog(blog);
            } else {
                Blog blog = new Blog(0, accountID, title, content, image, null);
                dao.addBlog(blog);
            }
            resp.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi xử lý blog");
        }

    }
}
