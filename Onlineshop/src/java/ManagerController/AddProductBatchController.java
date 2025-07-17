/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.ProductBatch;
import Model.ProductComponent;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.Map;
import java.sql.Date;
import java.util.List;

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
        try {
            int productID = Integer.parseInt(request.getParameter("productID"));
            String quantityStr = request.getParameter("quantity");
            String importPriceStr = request.getParameter("importPrice");
            String dateImportStr = request.getParameter("dateImport");
            String dateExpireStr = request.getParameter("dateExpire");

            // Trả lại dữ liệu nếu có lỗi
            request.setAttribute("productID", productID);
            request.setAttribute("quantityVal", quantityStr);
            request.setAttribute("importPriceVal", importPriceStr);
            request.setAttribute("dateImportVal", dateImportStr);
            request.setAttribute("dateExpireVal", dateExpireStr);

            boolean hasError = false;

            // Validate
            if (quantityStr == null || quantityStr.isEmpty()) {
                request.setAttribute("quantityError", "Vui lòng nhập số lượng.");
                hasError = true;
            } else {
                try {
                    importPriceStr = importPriceStr.replace(",", "").trim();  // << THÊM DÒNG NÀY
                    if (Double.parseDouble(importPriceStr) < 0) {
                        request.setAttribute("priceError", "Giá nhập không được âm.");
                        hasError = true;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("priceError", "Giá nhập không hợp lệ.");
                    hasError = true;
                }
            }
            if (Integer.parseInt(quantityStr) <= 0) {
                request.setAttribute("quantityError", "Số lượng phải lớn hơn 0.");
                hasError = true;
            }

            if (importPriceStr == null || importPriceStr.isEmpty()) {
                request.setAttribute("priceError", "Vui lòng nhập giá nhập.");
                hasError = true;
            } else if (Double.parseDouble(importPriceStr) < 0) {
                request.setAttribute("priceError", "Giá nhập không được âm.");
                hasError = true;
            }

            if (dateImportStr == null || dateImportStr.isEmpty()) {
                request.setAttribute("dateImportError", "Vui lòng chọn ngày nhập.");
                hasError = true;
            }

            if (dateExpireStr == null || dateExpireStr.isEmpty()) {
                request.setAttribute("dateExpireError", "Vui lòng chọn ngày hết hạn.");
                hasError = true;
            }

            if (hasError) {
                request.setAttribute("errorFlag", true);
                request.getRequestDispatcher("managerproductlist").forward(request, response);
                return;
            }

            int quantity = Integer.parseInt(quantityStr);
            double importPrice = Double.parseDouble(importPriceStr);
            Date dateImport = Date.valueOf(dateImportStr);
            Date dateExpire = Date.valueOf(dateExpireStr);

            if (dateExpire.before(dateImport)) {
                request.setAttribute("dateExpireError", "Ngày hết hạn phải sau ngày nhập.");
                request.setAttribute("errorFlag", true);
                request.getRequestDispatcher("managerproductlist").forward(request, response);
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            MaterialDAO materialDAO = new MaterialDAO();
            List<ProductComponent> components = productDAO.getProductComponentsByProductID(productID);

            for (ProductComponent comp : components) {
                int requiredQty = comp.getMaterialQuantity() * quantity;
                int availableQty = materialDAO.getAvailableMaterial(comp.getMaterialID());
                if (availableQty < requiredQty) {
                    request.setAttribute("quantityError", "Không đủ nguyên liệu: " + comp.getMaterial().getName());
                    request.setAttribute("errorFlag", true);
                    request.getRequestDispatcher("managerproductlist").forward(request, response);
                    return;
                }
            }

            for (ProductComponent comp : components) {
                int requiredQty = comp.getMaterialQuantity() * quantity;
                materialDAO.consumeMaterialFIFO(comp.getMaterialID(), requiredQty);
            }

            ProductBatch batch = new ProductBatch(productID, quantity, importPrice, dateImport, dateExpire);
            productDAO.insertProductBatch(batch);

            request.getSession().setAttribute("isactive", "Nhập hàng thành công.");
            response.sendRedirect("managerproductlist");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi nhập hàng.");
            request.setAttribute("errorFlag", true);
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
