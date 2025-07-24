package CommonController;

import DAO.BlogDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Blog;
import Model.Category;
import Model.Color;
import Model.Season;
import Model.WishList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet to handle blog listing
 *
 * @author dungb
 */
@WebServlet(name = "BlogsControllers", urlPatterns = {"/blogs-list"})
public class BlogsControllers extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method to display all approved blogs
     * with pagination.
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
        ProductDAO productDAO = new ProductDAO();
        int page = 1; // Default page
        int pageSize = 10; // Number of blogs per page

        // Get page parameter from request, if provided
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1; // Ensure page is at least 1
                }
            } catch (NumberFormatException e) {
                page = 1; // Fallback to page 1 if invalid
            }
        }

        try {
            // Retrieve approved blogs with main image
            List<Blog> blogs = blogDAO.getAllBlogsForGuest(page, pageSize);

            // Get total number of approved blogs for pagination
            int totalBlogs = blogDAO.countBlogsByStatus("Approved");
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);
            HttpSession session = request.getSession();
            Account a = (Account) session.getAttribute("account");
            int count;
            if (a == null) {
                count = 0;
            } else {
                count = productDAO.countProductWishLish(a.getAccountID());
                List<WishList> ListWishListProductByAccount = productDAO.getWishListProductByAccount(a.getAccountID());
                request.setAttribute("wishlistProductIDs", ListWishListProductByAccount);
            }

            request.setAttribute("countWL", count);

            List<Category> listAllCategory = productDAO.getAllCategory();
            List<Color> listAllColors = productDAO.getAllColor();
            List<Season> listAllSeasons = productDAO.getAllSeason();
            request.setAttribute("listAllCategory", listAllCategory);
            request.setAttribute("listAllColors", listAllColors);
            request.setAttribute("listAllSeasons", listAllSeasons);

            // Set attributes for JSP
            request.setAttribute("blogs", blogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Forward to JSP for rendering
            request.getRequestDispatcher("/BlogList.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle database error (e.g., redirect to error page or show message)
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving blogs");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method (not implemented for this
     * case).
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST functionality not required for this task
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for displaying approved blogs with main images";
    }
}
