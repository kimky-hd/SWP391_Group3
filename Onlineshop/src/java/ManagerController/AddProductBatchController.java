/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.MaterialBatchUsage;
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
            String dateImportStr = request.getParameter("dateImport");
            String dateExpireStr = request.getParameter("dateExpire");

            request.setAttribute("productID", productID);
            request.setAttribute("quantityVal", quantityStr);
            request.setAttribute("dateImportVal", dateImportStr);
            request.setAttribute("dateExpireVal", dateExpireStr);

            boolean hasError = false;
            int quantity = 0;
            Date dateImport = null;
            Date dateExpire = null;

            // Validate số lượng
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("quantityError", "Số lượng phải là số dương.");
                hasError = true;
            }

            // Validate ngày nhập
            try {
                dateImport = Date.valueOf(dateImportStr);
            } catch (Exception e) {
                request.setAttribute("dateImportError", "Ngày nhập không hợp lệ.");
                hasError = true;
            }

            // Validate ngày hết hạn
            try {
                dateExpire = Date.valueOf(dateExpireStr);
            } catch (Exception e) {
                request.setAttribute("dateExpireError", "Ngày hết hạn không hợp lệ.");
                hasError = true;
            }

            if (dateImport != null && dateExpire != null && dateExpire.before(dateImport)) {
                request.setAttribute("dateExpireError", "Ngày hết hạn phải sau ngày nhập.");
                hasError = true;
            }

            if (hasError) {
                request.setAttribute("errorFlag", true);
                request.getRequestDispatcher("managerproductlist").forward(request, response);
                return;
            }

            // Lấy danh sách nguyên liệu cấu thành sản phẩm
            ProductDAO productDAO = new ProductDAO();
            List<ProductComponent> components = productDAO.getProductComponentsByProductID(productID);
            MaterialDAO materialDAO = new MaterialDAO();

            double totalImportCost = 0;

            // Kiểm tra đủ nguyên liệu không
            for (ProductComponent comp : components) {
                int requiredQty = comp.getMaterialQuantity() * quantity;
                int availableQty = materialDAO.getAvailableMaterial(comp.getMaterialID());
                if (availableQty < requiredQty) {
                    request.setAttribute("quantityError",
                            "Không đủ nguyên liệu: " + comp.getMaterial().getName()
                            + " (Cần: " + requiredQty + ", Có: " + availableQty + ")");
                    request.setAttribute("errorFlag", true);
                    request.getRequestDispatcher("managerproductlist").forward(request, response);
                    return;
                }
            }

            // Insert ProductBatch
            ProductBatch batch = new ProductBatch(productID, quantity, 0, dateImport, dateExpire);
            int productBatchID = productDAO.insertProductBatch(batch);

            // Consume nguyên liệu (FIFO) và tính tổng giá nhập
            for (ProductComponent comp : components) {
                int requiredQty = comp.getMaterialQuantity() * quantity;
                List<MaterialBatchUsage> usages = materialDAO.consumeMaterialFIFO(comp.getMaterialID(), requiredQty, productBatchID);

                for (MaterialBatchUsage usage : usages) {
                    totalImportCost += usage.getQuantityUsed() * usage.getImportPrice();
                }
            }

            // Tính giá nhập trung bình cho ProductBatch
            double avgImportPrice = totalImportCost / quantity;

            // Cập nhật giá nhập cho ProductBatch
            productDAO.updateImportPrice(productBatchID, avgImportPrice);

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
