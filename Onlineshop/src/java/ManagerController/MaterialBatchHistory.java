/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialBatchDAO;
import DAO.MaterialDAO;
import Model.Account;
import Model.Material;
import Model.MaterialBatch;
import Model.Supplier;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author Duccon
 */
public class MaterialBatchHistory extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        MaterialBatchDAO matebatchDAO = new MaterialBatchDAO();
        MaterialDAO mateDAO = new MaterialDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {

        String materialName = request.getParameter("materialName");
        String supplierName = request.getParameter("supplierName");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");

        Date dateFrom = null;
        Date dateTo = null;

        try {
            if (dateFromStr != null && !dateFromStr.trim().isEmpty()) {
                dateFrom = Date.valueOf(dateFromStr.trim());
            }
            if (dateToStr != null && !dateToStr.trim().isEmpty()) {
                dateTo = Date.valueOf(dateToStr.trim());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        boolean hasFilter = (materialName != null && !materialName.isEmpty())
                || (supplierName != null && !supplierName.isEmpty())
                || dateFrom != null || dateTo != null;
        List<MaterialBatch> list;
        int allMaterialBatch;
        if (hasFilter) {
            list = matebatchDAO.getMaterialBatchHistoryFiltered(materialName, dateFrom, dateTo, supplierName);
            allMaterialBatch = list.size(); // lọc xong rồi, nên không phân trang trong DAO
        } else {
            String index = request.getParameter("index");
            if (index == null || index.isEmpty()) {
                index = "1";
            }
            int indexPage = Integer.parseInt(index);
            list = matebatchDAO.getMaterialBatchHistoryByIndex(indexPage);
            allMaterialBatch = matebatchDAO.countAllMaterialBatch();
            int endPage = allMaterialBatch / 10;
            if (allMaterialBatch % 10 != 0) {
                endPage++;
            }
            request.setAttribute("tag", indexPage);
            request.setAttribute("endPage", endPage);
        }

        List<Material> materialList = mateDAO.getAllMaterial();
        List<Supplier> supplierList = matebatchDAO.getAllSupplier();

        request.setAttribute("materialName", materialName);
        request.setAttribute("supplierName", supplierName);
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);

        request.setAttribute("count", allMaterialBatch);

        request.setAttribute("materialBatchList", list);
        request.setAttribute("materialList", materialList);
        request.setAttribute("supplierList", supplierList);

        request.getRequestDispatcher("Manager_MaterialBatchHistory.jsp").forward(request, response);
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
