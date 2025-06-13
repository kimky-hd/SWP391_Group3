/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CommonController;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.ProductDAO;
import Model.Account;
import Model.Category;
import Model.Product;
import Model.Color;
import Model.Season;
import Model.WishList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ViewListProductController extends HttpServlet {

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
        ProductDAO productDAO = new ProductDAO();
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);

        List<Product> listProductByIndex = productDAO.getProductByIndex(indexPage);
        //List<Product> listproducts = productDAO.getAllProduct();

        int allProduct = productDAO.countAllProduct();
        int endPage = allProduct / 8;
        if (allProduct % 8 != 0) {
            endPage++;
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
        
        
        List<Category> listAllCategory = productDAO.getAllCategory();
        List<Color> listAllColors = productDAO.getAllColor();
        List<Season> listAllSeasons = productDAO.getAllSeason();
        
        request.setAttribute("countWL", count);
        request.setAttribute("tag", indexPage);
        request.setAttribute("count", allProduct);
        request.setAttribute("endPage", endPage);
        request.setAttribute("productList", listProductByIndex);
        request.setAttribute("listAllCategory", listAllCategory);
        request.setAttribute("listAllColors", listAllColors);
        request.setAttribute("listAllSeasons", listAllSeasons);
        request.getRequestDispatcher("ProductList.jsp").forward(request, response);

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
