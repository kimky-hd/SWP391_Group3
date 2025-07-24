/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Material;
import Model.MaterialBatch;
import Model.MaterialBatchUsage;
import Model.Product;
import Model.ProductBatch;
import Model.ProductComponent;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.Map;
import java.sql.Date;
import java.util.HashMap;
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
        HttpSession session = request.getSession();
        int productID = Integer.parseInt(request.getParameter("productID"));
        ProductDAO productDAO = new ProductDAO();
        MaterialDAO materialDAO = new MaterialDAO();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {

        Product product = productDAO.getProductById(productID);
        Map<Material, List<MaterialBatch>> materialBatches = new HashMap<>();

        for (ProductComponent component : product.getComponents()) {
            Material material = component.getMaterial();
            List<MaterialBatch> batches = materialDAO.getAvailableMaterialBatches(material.getMaterialID());
            materialBatches.put(material, batches);
        }   
        session.removeAttribute("materialUsageMap");

        request.setAttribute("product", product);
        request.setAttribute("materialBatches", materialBatches);
        request.getRequestDispatcher("Manager_AddProductBatch.jsp").forward(request, response);
    }
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
            HttpSession session = request.getSession();
            int productID = Integer.parseInt(request.getParameter("productID"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double importPrice = Double.parseDouble(request.getParameter("importPrice"));
            Date dateImport = Date.valueOf(request.getParameter("dateImport"));
            Date dateExpire = Date.valueOf(request.getParameter("dateExpire"));

            ProductDAO productDAO = new ProductDAO();
            MaterialDAO materialDAO = new MaterialDAO();

            Product product = productDAO.getProductById(productID);
            List<ProductComponent> components = product.getComponents();

            Map<Material, List<MaterialBatch>> materialBatches = new HashMap<>();

            // Kiểm tra đủ nguyên liệu
            for (ProductComponent component : components) {
                Material material = component.getMaterial();
                int materialID = material.getMaterialID();
                int requiredQty = component.getMaterialQuantity() * quantity;

                List<MaterialBatch> availableBatches = materialDAO.getAvailableMaterialBatches(materialID);
                int totalAvailable = availableBatches.stream().mapToInt(MaterialBatch::getQuantity).sum();

                materialBatches.put(material, availableBatches);

                if (totalAvailable < requiredQty) {
                    request.setAttribute("errorMessage", "Không đủ nguyên liệu: " + material.getName());
                    request.setAttribute("product", product);
                    request.setAttribute("materialBatches", materialBatches);
                    request.setAttribute("quantity", quantity);
                    request.setAttribute("importPrice", importPrice);
                    request.setAttribute("dateImport", dateImport.toString());
                    request.setAttribute("dateExpire", dateExpire.toString());
                    request.getRequestDispatcher("Manager_AddProductBatch.jsp").forward(request, response);
                    return;
                }
            }

            // Đủ nguyên liệu => thêm batch sản phẩm
            productDAO.insertProductBatchHistory(productID, quantity, importPrice, dateImport, dateExpire);
            productDAO.insertProductBatch(productID, quantity, importPrice, dateImport, dateExpire);

            Map<Material, List<MaterialBatchUsage>> materialUsageMap
                    = (Map<Material, List<MaterialBatchUsage>>) session.getAttribute("materialUsageMap");

            if (materialUsageMap != null) {
                for (Map.Entry<Material, List<MaterialBatchUsage>> entry : materialUsageMap.entrySet()) {
                    for (MaterialBatchUsage usage : entry.getValue()) {
                        int batchID = usage.getMaterialBatchID();
                        int usedQty = usage.getQuantityUsed();
                        double price = usage.getImportPrice();
                        materialDAO.deductMaterialFromBatch(usage.getMaterialBatchID(), usage.getQuantityUsed());
                        materialDAO.insertMaterialBatchUsage(productID, batchID, usedQty, price);
                    }
                }
                session.removeAttribute("materialUsageMap");
            }
            session.setAttribute("isactive", "Nhập lô hàng sản phẩm thành công!");

            response.sendRedirect("managerproductlist");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lưu lô hàng: " + e.getMessage());
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
