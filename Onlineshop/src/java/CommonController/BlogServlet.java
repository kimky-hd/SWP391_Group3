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
        try {
            List<Blog> blogs = dao.getAllBlogs();
            req.setAttribute("blogs", blogs);
            req.getRequestDispatcher("BlogList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi lấy dữ liệu blog");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String image = req.getParameter("image"); // Nếu có upload ảnh thì lấy từ multipart, ở đây tạm lấy từ form
        int accountID = 1; // Tạm thời gán cứng, nếu có đăng nhập thì lấy từ session
        BlogDAO dao = new BlogDAO();
        try {
            Blog blog = new Blog(0, accountID, title, content, image, null);
            dao.addBlog(blog);
            resp.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi thêm blog");
        }
    }
}