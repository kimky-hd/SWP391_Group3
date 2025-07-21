/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CommonController;

import DAO.BannerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DAO.ProductDAO;
import Model.Product;
import java.util.List;
import DAO.CategoryDAO;
import Model.Banner;
import Model.Category;

/**
 * Servlet implementation for rendering the homepage.
 */
@WebServlet(name = "Homepage", urlPatterns = {"/Homepage"})
public class Homepage extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int page = 1;
        int productsPerPage = 8;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        BannerDAO bannerDAO = new BannerDAO();
        List<Banner> banners = bannerDAO.getActiveBanners();
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategory();
        request.setAttribute("categories", categories);
        String categoryId = request.getParameter("category");
        List<Product> featuredProducts;
        int totalProducts;
        if (categoryId != null && !categoryId.isEmpty()) {
            featuredProducts = productDAO.getProductByCategory(categoryId, page, productsPerPage);
            totalProducts = productDAO.countProductByCategory(categoryId);
            request.setAttribute("selectedCategory", categoryId);
        } else {
            featuredProducts = productDAO.getProductByIndex(page);
            totalProducts = productDAO.countAllProduct();
        }
        int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("banners", banners);

        request.getRequestDispatcher("Homepage.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Homepage servlet forwards to Homepage.jsp";
    }
}
