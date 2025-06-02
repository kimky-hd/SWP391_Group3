package Controller;

import DAO.VoucherDAO;
import Model.Account;
import Model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VoucherController", urlPatterns = {"/VoucherController"})
public class VoucherController extends HttpServlet {
    private VoucherDAO voucherDAO;
    
    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        if (action == null) {
            viewVouchers(request, response, session);
        } else switch (action) {
            case "delete":
                deleteVoucher(request, response, session);
                break;
            case "use":
                useVoucher(request, response, session);
                break;
            default:
                viewVouchers(request, response, session);
                break;
        }
    }
    
    private void viewVouchers(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Voucher> vouchers = voucherDAO.getVouchersByAccountId(account.getAccountID());
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }
    
    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            voucherDAO.deleteVoucher(voucherId, account.getAccountID());
            response.sendRedirect("voucher");
        } catch (NumberFormatException e) {
            response.sendRedirect("voucher");
        }
    }
    
    private void useVoucher(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            voucherDAO.useVoucher(voucherId, account.getAccountID());
            response.sendRedirect("voucher");
        } catch (NumberFormatException e) {
            response.sendRedirect("voucher");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}