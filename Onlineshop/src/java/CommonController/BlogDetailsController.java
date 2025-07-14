package CommonController;

import DAO.BlogDAO;
import Model.Blog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet to handle displaying details of an approved blog
 * @author dungb
 */
@WebServlet(name = "BlogDetailsController", urlPatterns = {"/blog-detail"})
public class BlogDetailsController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method to display details of an approved blog.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogDAO blogDAO = new BlogDAO();
        String blogIdStr = request.getParameter("bid");

        try {
            // Validate blog ID
            int blogId;
            try {
                blogId = Integer.parseInt(blogIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid blog ID");
                return;
            }

            // Retrieve blog by ID
            Blog blog = blogDAO.getBlogById(blogId);

            // Check if blog exists and is approved
            if (blog != null && "Approved".equals(blog.getBlogStatus())) {
                request.setAttribute("blog", blog);
                request.getRequestDispatcher("/BlogDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Blog not found or not approved");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving blog details");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method (not implemented for this case).
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for displaying approved blog details for customers";
    }
}