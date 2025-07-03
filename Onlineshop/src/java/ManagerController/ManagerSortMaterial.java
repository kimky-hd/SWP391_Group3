/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package ManagerController;

import DAO.MaterialDAO;
import Model.Material;
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
public class ManagerSortMaterial extends HttpServlet {
   
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
        if (sortOrder == null) sortOrder = "asc";
        int index = 1;
        String indexParam = request.getParameter("index");
        if (indexParam != null) {
            index = Integer.parseInt(indexParam);
        }
        List<Material> listMaterialByIndex = mateDAO.getSortMaterial(sortOrder, index);
        for (Material p : listMaterialByIndex) {
            p.setBatches(mateDAO.getBatchesByMaterialID(p.getMaterialID()));
        }
        int allMaterial = mateDAO.countAllMaterial();
        int endPage = allMaterial / 8;
        if (allMaterial % 8 != 0) {
            endPage++;
        }
        request.setAttribute("tag", index);
        request.setAttribute("count", allMaterial);
        request.setAttribute("endPage", endPage);
        request.setAttribute("now", new java.util.Date());
        request.setAttribute("materialList", listMaterialByIndex);
        request.setAttribute("baseUrl", "SearchSortProduct");
        request.setAttribute("extraParams", "&sortOrder=" + sortOrder);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("Manager_ListMaterial.jsp").forward(request, response);

    
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
