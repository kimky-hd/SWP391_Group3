package CommonController;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import Model.Blog;
import DAO.BlogDAO;

public class BlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BlogDAO dao = new BlogDAO();
        try {
            List<Blog> blogs = dao.getAllBlogs();
            req.setAttribute("blogs", blogs);
            req.getRequestDispatcher("blogList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi lấy dữ liệu blog");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String author = "test_staff"; // Lấy từ session nếu có đăng nhập staff
        BlogDAO dao = new BlogDAO();
        try {
            dao.addBlog(new Blog(0, title, content, author, null));
            resp.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi thêm blog");
        }
    }
}
