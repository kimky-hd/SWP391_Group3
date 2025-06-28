/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Duccon
 */
public class AddProductBatchController extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddProductBatchController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddProductBatchController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        String quantityStr = request.getParameter("quantity");
        String importPriceStr = request.getParameter("importPrice");
        String dateImportStr = request.getParameter("dateImport");
        String dateExpireStr = request.getParameter("dateExpire");

        List<String> errorList = new ArrayList<>();

        int productID = Integer.parseInt(request.getParameter("productID"));
        request.setAttribute("productID", productID); // để gửi lại modal đúng

        try {
            int quantity = Integer.parseInt(quantityStr);
            double importPrice = Double.parseDouble(importPriceStr);
            Date dateImport = Date.valueOf(dateImportStr);
            Date dateExpire = Date.valueOf(dateExpireStr);

            if (quantity <= 0) {
                errorList.add("Số lượng phải lớn hơn 0");
            }
            if (importPrice <= 0) {
                errorList.add("Giá nhập phải lớn hơn 0");
            }
            if (!dateExpire.after(dateImport)) {
                errorList.add("Ngày hết hạn phải sau ngày nhập");
            }

            if (!errorList.isEmpty()) {
                request.setAttribute("errorList", errorList);
                request.getRequestDispatcher("managerproductlist").forward(request, response);
                return;
            }

            // Thêm ProductBatch & xử lý nguyên liệu ở đây...
            request.getSession().setAttribute("success", "Đã bổ sung số lượng thành công!");
            response.sendRedirect("managerproductlist");

        } catch (Exception e) {
            errorList.add("Dữ liệu không hợp lệ hoặc thiếu!");
            request.setAttribute("errorList", errorList);
            request.getRequestDispatcher("managerproductlist").forward(request, response);
        }

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
