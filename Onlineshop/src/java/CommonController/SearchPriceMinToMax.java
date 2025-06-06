
///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CommonController;

import DAO.ProductDAO;
import Model.Color;
import Model.Product;
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
public class SearchPriceMinToMax extends HttpServlet {

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
        String priceMin = request.getParameter("priceMin").trim();
        String priceMax = request.getParameter("priceMax").trim();
        ProductDAO productDAO = new ProductDAO();
        if ((priceMin == null || priceMin.trim().isEmpty())
                && (priceMax == null || priceMax.trim().isEmpty())) {
            response.sendRedirect("productList");
        } else {
            if (!isNumeric(priceMin) || !isNumeric(priceMax)) {
                request.setAttribute("err", "Bạn cần nhập số lớn hơn 0!");
                request.getRequestDispatcher("productList").forward(request, response);
            }
            if (Integer.parseInt(priceMin) > Integer.parseInt(priceMax)) {
                request.setAttribute("err", "Bạn cần nhập giá Min nhỏ hơn giá Max!");
                request.getRequestDispatcher("productList").forward(request, response);
            }
            List<Product> list = productDAO.searchPriceMinToMax(priceMin, priceMax);
            List<Season> listAllSeasons = productDAO.getAllSeason();
            List<Color> listAllColors = productDAO.getAllColor();
            request.setAttribute("priceMin", priceMin);
            request.setAttribute("priceMax", priceMax);
            request.setAttribute("productList", list);
            request.setAttribute("listAllColors", listAllColors);
            request.setAttribute("listAllSeasons", listAllSeasons);
            request.getRequestDispatcher("ProductList.jsp").forward(request, response);

        }
    }
private boolean isNumeric(String str) {
    if (str == null || str.trim().isEmpty()) {
        return false;
    }
    try {
        Double.parseDouble(str); // hoặc Integer.parseInt nếu bạn chỉ cần số nguyên
        return true;
    } catch (NumberFormatException e) {
        return false;
    }
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

