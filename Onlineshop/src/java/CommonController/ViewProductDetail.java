/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CommonController;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import Model.AccountProfile;
import Model.Category;
import Model.Color;
import Model.Feedback;
import Model.Product;
import Model.ProductComponent;
import Model.Season;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);

        List<ProductComponent> cpList = productDAO.getProductComponentsByProductID(id);
        List<Feedback> listAllFeedback = productDAO.getAllReviewByProductID(id, indexPage);
        int countAllFeedback = productDAO.countAllFeedback();
        int endPage = countAllFeedback / 3;
        if (countAllFeedback % 3 != 0) {
            endPage++;
        }
        float rate = productDAO.getRateByProductID(id);
        List<AccountProfile> listAllAccountprofile = productDAO.getAllAccountProfile();
        List<Category> cateList = cateDAO.getCategoryByProductID(id);
        
        System.out.println(rate);
        System.out.println(p);
        System.out.println(listAllAccountprofile);
        System.out.println(listAllFeedback);
        System.out.println(countAllFeedback);
        List<Category> listAllCategory = productDAO.getAllCategory();
        List<Color> listAllColors = productDAO.getAllColor();
        List<Season> listAllSeasons = productDAO.getAllSeason();
        request.setAttribute("listAllCategory", listAllCategory);
        request.setAttribute("listAllColors", listAllColors);
        request.setAttribute("listAllSeasons", listAllSeasons);
        request.setAttribute("componentList", cpList);
        request.setAttribute("categoryList", cateList);
        request.setAttribute("listFeedback", listAllFeedback);
        request.setAttribute("detail", p);
        request.setAttribute("tag", indexPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("totalFeedback", countAllFeedback);
        request.setAttribute("listAccountProfile", listAllAccountprofile);
        request.setAttribute("rate", rate);

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
