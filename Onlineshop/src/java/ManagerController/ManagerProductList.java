/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package ManagerController;

import DAO.ProductDAO;
import Model.Product;
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
 * @author Duccon
 */
public class ManagerProductList extends HttpServlet {
   
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
        ProductDAO productDAO = new ProductDAO();
        
         //Gọi cập nhật trạng thái các lô sản phẩm
        productDAO.updateProductBatchStatus();
        
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);

        List<Product> listProductByIndex = productDAO.getProductByIndex(indexPage);
        for (Product p : listProductByIndex) {
            p.setBatches(productDAO.getBatchesByProductID(p.getProductID()));
        }

        int allProduct = productDAO.countAllProduct();
        int endPage = allProduct / 8;
        if (allProduct % 8 != 0) {
            endPage++;
        }
        
        System.out.println(listProductByIndex);
        request.setAttribute("tag", indexPage);
        request.setAttribute("count", allProduct);
        request.setAttribute("endPage", endPage);
        request.setAttribute("productList", listProductByIndex);
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
