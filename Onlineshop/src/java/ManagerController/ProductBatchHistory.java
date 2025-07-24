/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.ProductBatchDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Product;
import Model.ProductBatch;
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
public class ProductBatchHistory extends HttpServlet {

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

        ProductBatchDAO batchDAO = new ProductBatchDAO();
        ProductDAO productDAO = new ProductDAO();
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Lọc
        String productName = request.getParameter("productName");
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

        boolean hasFilter = (productName != null && !productName.isEmpty()) || dateFrom != null || dateTo != null;

        List<ProductBatch> list;
        int total;
        if (hasFilter) {
            list = batchDAO.getFilteredProductBatches(productName, dateFrom, dateTo);
            total = list.size(); // đã lọc nên không phân trang
        } else {
            String index = request.getParameter("index");
            if (index == null || index.isEmpty()) {
                index = "1";
            }
            int pageIndex = Integer.parseInt(index);

            list = batchDAO.getProductBatchesHistoryByIndex(pageIndex);
            total = batchDAO.countAllProductBatch();

            int endPage = total / 8;
            if (total % 8 != 0) {
                endPage++;
            }
            request.setAttribute("tag", pageIndex);
            request.setAttribute("endPage", endPage);
        }

        List<Product> productList = productDAO.getAllProduct();

        // Set thuộc tính
        request.setAttribute("productName", productName);
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);
        request.setAttribute("count", total);
        request.setAttribute("productBatchList", list);
        request.setAttribute("productList", productList);

        request.getRequestDispatcher("Manager_ProductBatchHistory.jsp").forward(request, response);
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
