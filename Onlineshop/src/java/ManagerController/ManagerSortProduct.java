/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package ManagerController;

import DAO.CategoryDAO;
import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Category;
import Model.Product;
import Model.ProductComponent;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Duccon
 */
public class ManagerSortProduct extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String sortOrder = request.getParameter("sortOrder");
        MaterialDAO mateDAO = new MaterialDAO();
        CategoryDAO cateDAO = new CategoryDAO();
        ProductDAO productDAO = new ProductDAO();
        if (sortOrder == null) sortOrder = "asc";
        int index = 1;
        String indexParam = request.getParameter("index");
        if (indexParam != null) {
            index = Integer.parseInt(indexParam);
        }
        
        List<Product> listProductAfterSort = productDAO.getSortProductManager(sortOrder, index);
        for (Product p : listProductAfterSort) {
            p.setBatches(productDAO.getBatchesByProductID(p.getProductID()));
            List<ProductComponent> components = productDAO.getProductComponentsByProductID(p.getProductID());
            for (ProductComponent c : components) {
                c.setMaterial(mateDAO.getMaterialByID(c.getMaterialID()));
            }
            p.setComponents(components);
            List<Category> categories = cateDAO.getCategoryByProductID(p.getProductID());
            p.setCategories(categories);
        }
        int allProduct = productDAO.countAllProduct();
        int endPage = allProduct / 8;
        if (allProduct % 8 != 0) {
            endPage++;
        }
        request.setAttribute("tag", index);
        request.setAttribute("count", allProduct);
        request.setAttribute("endPage", endPage);
        request.setAttribute("productList", listProductAfterSort);
        request.setAttribute("now", new java.util.Date());
        request.setAttribute("baseUrl", "SearchSortProduct");
        request.setAttribute("extraParams", "&sortOrder=" + sortOrder);
        request.setAttribute("sortOrder", sortOrder);
        
        request.getRequestDispatcher("Manager_ListProduct.jsp").forward(request, response);
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
