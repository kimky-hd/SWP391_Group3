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
import java.io.PrintWriter;
import java.util.List;
import org.json.JSONObject;

@WebServlet(name = "VoucherController", urlPatterns = {"/VoucherController"})
public class VoucherController extends HttpServlet {
    private VoucherDAO voucherDAO;
    
    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (action == null) {
            loadAllVouchers(request, response, account);
        } else if (action.equals("add")) {
            addVoucherToAccount(request, response, account);
        } else if (action.equals("apply")) {
            applyVoucher(request, response, account);
        } else if (action.equals("myVouchers")) {
            loadMyVouchers(request, response, account);
        }
    }
    
    // Load tất cả vouchers có sẵn
    private void loadAllVouchers(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getVouchersWithAccountStatus(account.getAccountID());
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("pageType", "all");
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }
    
    // Load vouchers của user
    private void loadMyVouchers(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getVouchersByAccountId(account.getAccountID());
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("pageType", "my");
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }
    
    // Thêm voucher vào tài khoản
    private void addVoucherToAccount(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            
            // Kiểm tra voucher có tồn tại không
            Voucher voucher = voucherDAO.getVoucherById(voucherId);
            if (voucher == null) {
                json.put("success", false);
                json.put("message", "Voucher không tồn tại");
                out.print(json.toString());
                return;
            }

            // Kiểm tra voucher đã được thêm vào account chưa
            if (voucherDAO.isVoucherAddedToAccount(account.getAccountID(), voucherId)) {
                json.put("success", false);
                json.put("message", "Bạn đã sở hữu voucher này rồi");
                out.print(json.toString());
                return;
            }

            // Thêm voucher vào account
            if (voucherDAO.addVoucherToAccount(account.getAccountID(), voucherId)) {
                json.put("success", true);
                json.put("message", "Thêm voucher thành công!");
            } else {
                json.put("success", false);
                json.put("message", "Không thể thêm voucher");
            }
            
        } catch (NumberFormatException e) {
            json.put("success", false);
            json.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        out.print(json.toString());
    }
    
    // Áp dụng voucher (sử dụng voucher)
    private void applyVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            
            // Kiểm tra voucher có tồn tại và hợp lệ không
            Voucher voucher = voucherDAO.getVoucherById(voucherId);
            if (voucher == null) {
                json.put("success", false);
                json.put("message", "Voucher không tồn tại");
                out.print(json.toString());
                return;
            }

            // Kiểm tra tính hợp lệ của voucher
            if (!voucherDAO.isVoucherValid(voucherId, account.getAccountID())) {
                json.put("success", false);
                json.put("message", "Voucher không hợp lệ hoặc đã được sử dụng");
                out.print(json.toString());
                return;
            }

            // Lưu voucher vào session để sử dụng ở trang giỏ hàng
            HttpSession session = request.getSession();
            session.setAttribute("appliedVoucher", voucher);
            
            json.put("success", true);
            json.put("message", "Áp dụng voucher thành công");
            
        } catch (NumberFormatException e) {
            json.put("success", false);
            json.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        out.print(json.toString());
    }
}
