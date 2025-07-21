/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CustomerController;

import DAO.ProductDAO;
import Model.Account;
import Model.Category;
import Model.Color;
import Model.Product;
import Model.Season;
import Model.WishList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ManageWishListController extends HttpServlet {

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
        ProductDAO productDAO = new ProductDAO();
        
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        
        // Xử lý action=add từ Homepage
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            if (a == null) {
                request.setAttribute("mess", "Bạn cần đăng nhập");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            String productId = request.getParameter("productId");
            if (productId != null && !productId.isEmpty()) {
                int productID = Integer.parseInt(productId);
                int accountID = a.getAccountID();
                
                WishList wishListExisted = productDAO.checkWishListExist(accountID, productID);
                if (wishListExisted != null) {
                    productDAO.removeWishList(accountID, productID);
                    session.setAttribute("mess", "Đã xóa sản phẩm khỏi mục ưa thích");
                } else {
                    productDAO.insertWishList(accountID, productID);
                    session.setAttribute("mess", "Đã thêm sản phẩm vào mục ưa thích");
                }
            }
        }
        
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);

        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            List<Product> ListWishLishProduct = productDAO.getListWishListProduct(a.getAccountID(), indexPage);
            int count = productDAO.countProductWishLish(a.getAccountID());
            int allWishList = productDAO.countProductWishLish(a.getAccountID());
            int endPage = allWishList / 8;
            if (allWishList % 8 != 0) {
                endPage++;
            }
            List<WishList> ListWishListProductByAccount = productDAO.getWishListProductByAccount(a.getAccountID());
            List<Category> listAllCategory = productDAO.getAllCategory();
            List<Color> listAllColors = productDAO.getAllColor();
            List<Season> listAllSeasons = productDAO.getAllSeason();
            request.setAttribute("countWL", count);
            request.setAttribute("tag", indexPage);
            request.setAttribute("count", allWishList);
            request.setAttribute("endPage", endPage);
            request.setAttribute("listWLByAcc", ListWishListProductByAccount);
            request.setAttribute("listWL", ListWishLishProduct);

            request.setAttribute("listAllCategory", listAllCategory);
            request.setAttribute("listAllColors", listAllColors);
            request.setAttribute("listAllSeasons", listAllSeasons);
            request.getRequestDispatcher("WishList.jsp").forward(request, response);
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
        ProductDAO productDAO = new ProductDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        String index = request.getParameter("index");
        if (index == null || index.isEmpty()) {
            index = "1";
        }
        int indexPage = Integer.parseInt(index);
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            String WishListID_raw = request.getParameter("wlid");
            int wlId = Integer.parseInt(WishListID_raw);
            productDAO.deleteWishList(wlId);
            List<Product> ListWishLishProduct = productDAO.getListWishListProduct(a.getAccountID(), indexPage);
            int count = productDAO.countProductWishLish(a.getAccountID());
            List<WishList> ListWishListProductByAccount = productDAO.getWishListProductByAccount(a.getAccountID());
            List<Category> listAllCategory = productDAO.getAllCategory();
            List<Color> listAllColors = productDAO.getAllColor();
            List<Season> listAllSeasons = productDAO.getAllSeason();
            request.setAttribute("listAllCategory", listAllCategory);
            request.setAttribute("listAllColors", listAllColors);
            request.setAttribute("listAllSeasons", listAllSeasons);
            request.setAttribute("countWL", count);
            request.setAttribute("listWLByAcc", ListWishListProductByAccount);
            request.setAttribute("listWL", ListWishLishProduct);
            request.setAttribute("mess", "Xóa thành công");
            request.getRequestDispatcher("WishList.jsp").forward(request, response);
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
