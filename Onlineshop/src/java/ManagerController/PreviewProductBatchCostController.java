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
import Model.ProductComponent;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Duccon
 */
public class PreviewProductBatchCostController extends HttpServlet {

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
            out.println("<title>Servlet PreviewProductBatchCostController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PreviewProductBatchCostController at " + request.getContextPath() + "</h1>");
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
            HttpSession session = request.getSession();

            // ✅ XÓA session cũ nếu có
            session.removeAttribute("materialUsageMap");
            session.removeAttribute("quantity");
            session.removeAttribute("errorQuantity");

            String quantityStr = request.getParameter("quantity");
            int productID = Integer.parseInt(request.getParameter("productID"));

            ProductDAO productDAO = new ProductDAO();
            MaterialDAO materialDAO = new MaterialDAO();
            Account a = (Account) session.getAttribute("account");
            if (a == null) {
                request.setAttribute("mess", "Bạn cần đăng nhập");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {

                Product product = productDAO.getProductById(productID);
                List<ProductComponent> components = productDAO.getProductComponentsByProductID(productID);

                Map<Material, List<MaterialBatch>> materialBatches = new HashMap<>();
                for (ProductComponent component : components) {
                    List<MaterialBatch> batches = materialDAO.getAvailableMaterialBatches(component.getMaterial().getMaterialID());
                    materialBatches.put(component.getMaterial(), batches);
                }

                // ✅ Validate số lượng
                int desiredQuantity = 0;
                try {
                    desiredQuantity = Integer.parseInt(quantityStr);
                    if (desiredQuantity <= 0) {
                        request.setAttribute("errorQuantity", "Số lượng phải là số nguyên dương.");
                        forwardBackToForm(request, response, product, productID, quantityStr, components, materialBatches);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorQuantity", "Số lượng không hợp lệ.");
                    forwardBackToForm(request, response, product, productID, quantityStr, components, materialBatches);
                    return;
                }

                // ✅ Tính chi phí dựa trên các batch theo FIFO
                Map<Material, List<MaterialBatchUsage>> materialUsageMap = new HashMap<>();
                double totalCost = 0.0;
                Date earliestExpire = null;

                for (ProductComponent pc : components) {
                    Material material = pc.getMaterial();
                    int totalRequired = desiredQuantity * pc.getMaterialQuantity();

                    List<MaterialBatch> batches = materialDAO.getMaterialBatchesFIFO(material.getMaterialID());
                    List<MaterialBatchUsage> usedBatches = new ArrayList<>();

                    for (MaterialBatch batch : batches) {
                        if (totalRequired <= 0) {
                            break;
                        }

                        int usedQty = Math.min(batch.getQuantity(), totalRequired);
                        usedBatches.add(new MaterialBatchUsage(batch.getMaterialBatchID(), usedQty, batch.getImportPrice()));

                        totalCost += usedQty * batch.getImportPrice();
                        totalRequired -= usedQty;

                        if (earliestExpire == null || batch.getDateExpire().before(earliestExpire)) {
                            earliestExpire = batch.getDateExpire();
                        }
                    }

                    materialUsageMap.put(material, usedBatches);
                }

                double estimatedUnitCost = desiredQuantity > 0 ? totalCost / desiredQuantity : 0;

                // ✅ Truyền kết quả đến view
                request.setAttribute("product", product);
                request.setAttribute("materialBatches", materialBatches);
                request.setAttribute("productID", productID);
                request.setAttribute("quantity", desiredQuantity);
                request.setAttribute("productComponents", components);
                request.setAttribute("materialUsageMap", materialUsageMap);
                request.setAttribute("totalCost", totalCost);
                request.setAttribute("estimatedUnitCost", estimatedUnitCost);
                request.setAttribute("earliestExpireDate", earliestExpire);

                // Nếu muốn lưu lại trên session để dùng sau, có thể dùng dòng này (nếu không thì xóa):
                session.setAttribute("materialUsageMap", materialUsageMap);
                request.getRequestDispatcher("Manager_AddProductBatch.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tính toán chi phí nhập lô sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("Manager_AddProductBatch.jsp").forward(request, response);
        }
    }

    private void forwardBackToForm(HttpServletRequest request, HttpServletResponse response,
            Product product, int productID, String quantityStr,
            List<ProductComponent> components,
            Map<Material, List<MaterialBatch>> materialBatches)
            throws ServletException, IOException {
        request.setAttribute("product", product);
        request.setAttribute("productID", productID);
        request.setAttribute("quantity", quantityStr);
        request.setAttribute("productComponents", components);
        request.setAttribute("materialBatches", materialBatches);
        request.getRequestDispatcher("Manager_AddProductBatch.jsp").forward(request, response);
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
