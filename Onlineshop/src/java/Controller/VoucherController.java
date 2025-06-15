
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
            loadVouchers(request, response, account);
        } else if (action.equals("apply")) {
            applyVoucher(request, response, account);
        }
    }
    
    private void loadVouchers(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getVouchersByAccountId(account.getAccountID());
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }
    
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

            // Cập nhật trạng thái sử dụng
            if (voucherDAO.updateVoucherUsage(voucherId) && 
                voucherDAO.updateAccountVoucherStatus(account.getAccountID(), voucherId)) {
                
                // Lưu voucher vào session để sử dụng ở trang giỏ hàng
                HttpSession session = request.getSession();
                session.setAttribute("appliedVoucher", voucher);
                
                json.put("success", true);
                json.put("message", "Áp dụng voucher thành công");
            } else {
                json.put("success", false);
                json.put("message", "Không thể áp dụng voucher");
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
}
