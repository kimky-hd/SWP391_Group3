/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CommonController;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.AccountProfile;
import Model.Category;
import Model.Color;
import Model.Feedback;
import Model.Product;
import Model.ProductComponent;
import Model.Season;
import Model.WishList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ViewProductDetail extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        int id = Integer.parseInt(request.getParameter("productid"));
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO cateDAO = new CategoryDAO();
        Product p = productDAO.getProductById(id);
        if (p == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
            return;
        }
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
        
        List<ProductComponent> cpList = productDAO.getProductComponentsByProductID(id);
        List<Feedback> listAllFeedback = productDAO.getAllReviewByProductID(id);
        int countAllFeedback = listAllFeedback.size();
        float rate = productDAO.getRateByProductID(id);
        List<AccountProfile> listAllAccountprofile = productDAO.getAllAccountProfile();
        
        List<Category> cateList = cateDAO.getCategoryByProductID(id);
        List<Category> listAllCategory = productDAO.getAllCategory();
        List<Color> listAllColors = productDAO.getAllColor();
        List<Season> listAllSeasons = productDAO.getAllSeason();

        request.setAttribute("countWL", count);
        request.setAttribute("componentList", cpList);
        request.setAttribute("categoryList", cateList);
        request.setAttribute("listFeedback", listAllFeedback);
        request.setAttribute("detail", p);
        request.setAttribute("totalFeedback", countAllFeedback);
        request.setAttribute("listAccountProfile", listAllAccountprofile);
        request.setAttribute("rate", rate);
        
        request.setAttribute("listAllCategory", listAllCategory);
        request.setAttribute("listAllColors", listAllColors);
        request.setAttribute("listAllSeasons", listAllSeasons);

        request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
