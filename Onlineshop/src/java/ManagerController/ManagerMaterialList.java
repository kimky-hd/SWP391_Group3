/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package ManagerController;

import DAO.MaterialBatchDAO;
import DAO.MaterialDAO;
import Model.Account;
import Model.Material;
import Model.Supplier;
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
public class ManagerMaterialList extends HttpServlet {
   
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
        MaterialDAO materialDAO = new MaterialDAO();
        
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
        
         //Gọi cập nhật trạng thái các lô sản phẩm
        
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);

        List<Material> listMaterialByIndex = materialDAO.getMaterialByIndex(indexPage);
        for (Material p : listMaterialByIndex) {
            p.setBatches(materialDAO.getBatchesByMaterialID(p.getMaterialID()));
        }
        
        MaterialBatchDAO matebDAO = new MaterialBatchDAO();
                
        List<Supplier> supplierList = matebDAO.getSupplierActive();

        int allMaterial = materialDAO.countAllMaterial();
        int endPage = allMaterial / 8;
        if (allMaterial % 8 != 0) {
            endPage++;
        }
        
        System.out.println(listMaterialByIndex);
        request.setAttribute("tag", indexPage);
        request.setAttribute("count", allMaterial);
        request.setAttribute("endPage", endPage);
        request.setAttribute("materialList", listMaterialByIndex);
        request.setAttribute("supplierList", supplierList);
        request.getRequestDispatcher("Manager_ListMaterial.jsp").forward(request, response);

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
