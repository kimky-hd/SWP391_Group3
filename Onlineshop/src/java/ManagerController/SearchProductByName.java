/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package ManagerController;

import DAO.CategoryDAO;
import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Category;
import Model.Product;
import Model.ProductComponent;
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
public class SearchProductByName extends HttpServlet {
   
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SearchProductByName</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchProductByName at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        String txt = request.getParameter("txt").trim();
        ProductDAO productDAO = new ProductDAO();
        MaterialDAO mateDAO = new MaterialDAO();
        CategoryDAO cateDAO = new CategoryDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
        List<Product> product = productDAO.getProductByTitle(txt);
        for (Product p : product) {
            p.setBatches(productDAO.getBatchesByProductID(p.getProductID()));
            List<ProductComponent> components = productDAO.getProductComponentsByProductID(p.getProductID());
            for (ProductComponent c : components) {
                c.setMaterial(mateDAO.getMaterialByID(c.getMaterialID()));
            }
            p.setComponents(components);
            List<Category> categories = cateDAO.getCategoryByProductID(p.getProductID());
            p.setCategories(categories);
        }
        request.setAttribute("txt", txt);
        request.setAttribute("productList", product);
        request.getRequestDispatcher("Manager_ListProduct.jsp").forward(request, response);
    } 

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
