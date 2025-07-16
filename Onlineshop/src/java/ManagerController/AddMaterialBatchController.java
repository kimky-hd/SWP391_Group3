/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import Model.Account;
import Model.Material;
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
public class AddMaterialBatchController extends HttpServlet {

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
            out.println("<title>Servlet AddMaterialBatchController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddMaterialBatchController at " + request.getContextPath() + "</h1>");
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

        String importPriceRaw = request.getParameter("importPrice");
        String quantityRaw = request.getParameter("quantity");
        String dateImportRaw = request.getParameter("dateImport");
        String dateExpireRaw = request.getParameter("dateExpire");
        String materialIDRaw = request.getParameter("materialID");

        boolean hasError = false;

        Double importPrice = null;
        Integer quantity = null;
        Date dateImport = null;
        Date dateExpire = null;

        MaterialDAO mateDAO = new MaterialDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {

            if (importPriceRaw == null || importPriceRaw.trim().isEmpty()) {
                request.setAttribute("errorPrice", "Vui lòng nhập giá nhập.");
                hasError = true;
            } else {
                try {
                    importPriceRaw = importPriceRaw.replace(",", "").trim(); // loại bỏ dấu phẩy
                    importPrice = Double.parseDouble(importPriceRaw);
                    if (importPrice <= 0) {
                        request.setAttribute("errorPrice", "Giá nhập phải lớn hơn 0.");
                        hasError = true;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorPrice", "Giá nhập phải là số.");
                    hasError = true;
                }
            }

            if (quantityRaw == null || quantityRaw.trim().isEmpty()) {
                request.setAttribute("errorQuantity", "Vui lòng nhập số lượng.");
                hasError = true;
            } else {
                try {
                    quantity = Integer.parseInt(quantityRaw);
                    if (quantity <= 0) {
                        request.setAttribute("errorQuantity", "Số lượng phải lớn hơn 0.");
                        hasError = true;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorQuantity", "Số lượng phải là số nguyên.");
                    hasError = true;
                }
            }

            if (dateImportRaw == null || dateImportRaw.isEmpty()) {
                request.setAttribute("errorDateImport", "Vui lòng chọn ngày nhập.");
                hasError = true;
            } else {
                dateImport = Date.valueOf(dateImportRaw);
            }

            if (dateExpireRaw == null || dateExpireRaw.isEmpty()) {
                request.setAttribute("errorDateExpire", "Vui lòng chọn ngày hết hạn.");
                hasError = true;
            } else {
                dateExpire = Date.valueOf(dateExpireRaw);
            }

            if (dateImport != null && dateExpire != null && dateExpire.before(dateImport)) {
                request.setAttribute("errorDateExpire", "Ngày hết hạn không được trước ngày nhập.");
                hasError = true;
            }

            if (hasError) {

                request.setAttribute("importPrice", importPriceRaw);
                request.setAttribute("quantity", quantityRaw);
                request.setAttribute("dateImport", dateImportRaw);
                request.setAttribute("dateExpire", dateExpireRaw);
                request.setAttribute("showModal", true);

                String index = request.getParameter("index");
                if (index == null || index.isEmpty()) {
                    index = "1";
                }
                int indexPage = Integer.parseInt(index);

                List<Material> listMaterialByIndex = mateDAO.getMaterialByIndex(indexPage);
                for (Material p : listMaterialByIndex) {
                    p.setBatches(mateDAO.getBatchesByMaterialID(p.getMaterialID()));
                }

                int allMaterial = mateDAO.countAllMaterial();
                int endPage = allMaterial / 10;
                if (allMaterial % 10 != 0) {
                    endPage++;
                }

                System.out.println(listMaterialByIndex);
                request.setAttribute("tag", indexPage);
                request.setAttribute("count", allMaterial);
                request.setAttribute("endPage", endPage);
                request.setAttribute("materialList", listMaterialByIndex);

                request.getRequestDispatcher("Manager_ListMaterial.jsp").forward(request, response);
                return;
            }

            int materialID = Integer.parseInt(materialIDRaw);

            mateDAO.addNewBatchToMaterial(materialID, quantity, importPrice, dateImport, dateExpire);

            request.getSession().setAttribute("isactive", "Bổ sung nguyên liệu thành công!");
            response.sendRedirect("managermateriallist");
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
