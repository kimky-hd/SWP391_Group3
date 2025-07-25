/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.staff;

import DAO.MaterialBatchDAO;
import DAO.ProductBatchDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.MaterialBatch;
import Model.MaterialReplacement;
import Model.ProductBatch;
import Model.ProductComponent;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.sql.Date;
import java.util.Map;

/**
 *
 * @author Duccon
 */
public class ReplaceWiltedMaterialController extends HttpServlet {

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
            out.println("<title>Servlet ReplaceWiltedMaterialController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReplaceWiltedMaterialController at " + request.getContextPath() + "</h1>");
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
        int productBatchID = Integer.parseInt(request.getParameter("productBatchID"));
        MaterialBatchDAO matedao = new MaterialBatchDAO();
        ProductBatchDAO pbdao = new ProductBatchDAO();
        ProductDAO productDAO = new ProductDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            try {
                
                
                List<MaterialReplacement> replacements = matedao.autoReplaceWiltedMaterial(productBatchID);

                if (replacements != null && !replacements.isEmpty()) {
                    ProductBatch oldBatch = pbdao.getProductBatchByID(productBatchID);
                    int productID = oldBatch.getProductID();

                    // Tính số lượng mới có thể tạo từ nguyên liệu đã thay
                    List<ProductComponent> components = productDAO.getProductComponentsByProductID(productID);
                    Map<Integer, Integer> materialQuantityMap = new HashMap<>();
                    for (MaterialReplacement rep : replacements) {
                        materialQuantityMap.merge(rep.getMaterialID(), rep.getQuantity(), Integer::sum);
                    }

                    int maxQuantity = Integer.MAX_VALUE;
                    for (ProductComponent pc : components) {
                        int materialID = pc.getMaterial().getMaterialID();
                        int requiredPerProduct = pc.getMaterialQuantity();
                        int available = materialQuantityMap.getOrDefault(materialID, 0);
                        maxQuantity = Math.min(maxQuantity, available / requiredPerProduct);
                    }

                    // Tính tổng cost
                    double totalCost = 0;
                    for (MaterialReplacement rep : replacements) {
                        MaterialBatch batch = matedao.getMaterialBatchByID(rep.getNewMaterialBatchID());
                        totalCost += rep.getQuantity() * batch.getImportPrice();
                    }

                    Date newExpireDate = null;
                    for (MaterialReplacement rep : replacements) {
                        MaterialBatch batch = matedao.getMaterialBatchByID(rep.getNewMaterialBatchID());
                        Date batchExpire = (Date) batch.getDateExpire();
                        if (newExpireDate == null || batchExpire.before(newExpireDate)) {
                            newExpireDate = batchExpire;
                        }
                    }

                    // Tạo lô sản phẩm mới
                    ProductBatch newBatch = new ProductBatch();
                    newBatch.setProductID(productID);
                    newBatch.setQuantity(maxQuantity);
                    newBatch.setImportPrice(totalCost);
                    newBatch.setDateImport(new java.sql.Date(System.currentTimeMillis()));
                    newBatch.setDateExpire(newExpireDate); // Hoặc tính lại nếu cần
                    
                    matedao.restoreWiltedMaterialBatchQuantity(oldBatch.getProductID());
                    productDAO.insertProductBatchHistory(productID, maxQuantity, totalCost, new java.sql.Date(System.currentTimeMillis()), newExpireDate);
                    productDAO.insertProductBatch(productID, maxQuantity, totalCost, new java.sql.Date(System.currentTimeMillis()), newExpireDate);
                    productDAO.deleteProductBatch(oldBatch.getProductID());
                    
                    
                    request.getSession().setAttribute("successMessage", "Cập nhật nguyên liệu thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Không đủ nguyên liệu thay thế!");
                }

                response.sendRedirect("listwiltedbatches");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi tạo lô mới: " + e.getMessage());
                request.getRequestDispatcher("Staff_WiltedProductBatches.jsp").forward(request, response);
            }
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
