/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CustomerController;

import DAO.ProductDAO;
import Model.Account;
import Model.WishList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class AddWishlistController extends HttpServlet {

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

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Lấy pid và from từ request
        String id = request.getParameter("pid");
        String from = request.getParameter("from"); // detail hoặc null
        String indexParam = request.getParameter("index");
        String index = (indexParam != null && !indexParam.isEmpty()) ? indexParam : "1";

        // Kiểm tra đăng nhập
        if (account == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra id
        if (id == null || id.isEmpty()) {
            session.setAttribute("mess", "Không tìm thấy sản phẩm");
            if ("detail".equals(from)) {
                response.sendRedirect("ViewProductDetail"); // fallback
            } else {
                response.sendRedirect("ViewListProductController?index=" + index);
            }
            return;
        }

        int productID = Integer.parseInt(id);
        int accountID = account.getAccountID();

        ProductDAO productDAO = new ProductDAO();
        WishList wishListExisted = productDAO.checkWishListExist(accountID, productID);

        if (wishListExisted != null) {
            productDAO.removeWishList(accountID, productID);
            session.setAttribute("mess", "Đã xóa sản phẩm khỏi mục ưa thích");
        } else {
            productDAO.insertWishList(accountID, productID);
            session.setAttribute("mess", "Đã thêm sản phẩm vào mục ưa thích");
        }

        // ✅ Điều hướng lại đúng trang
        if ("detail".equals(from)) {
            response.sendRedirect("ViewProductDetail?productid=" + productID);
        } else {
            response.sendRedirect("ViewListProductController?index=" + index);
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
