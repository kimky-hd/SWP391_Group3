//package Controller;
//
//import DAO.VoucherDAO;
//import Model.Account;
//import Model.Voucher;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.util.List;
//
//// Thêm các import sau
//import java.io.PrintWriter;
//import org.json.JSONObject;
//
//@WebServlet(name = "VoucherController", urlPatterns = {"/VoucherController"})
//public class VoucherController extends HttpServlet {
//    private VoucherDAO voucherDAO;
//    
//    @Override
//    public void init() {
//        voucherDAO = new VoucherDAO();
//    }
//    
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//    
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        HttpSession session = request.getSession();
//        Account account = (Account) session.getAttribute("account");
//        
//        if (account == null) {
//            response.sendRedirect("login.jsp");
//            return;
//        }
//        
//        if (action == null) {
//            loadVouchers(request, response, account);
//        } else if (action.equals("apply")) {
//            applyVoucher(request, response, account);
//        } else if (action.equals("delete")) {
//            deleteVoucher(request, response, account);
//        }
//    }
//
//    // Thêm phương thức xử lý xóa voucher
//    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
//            throws ServletException, IOException {
//        response.setContentType("application/json;charset=UTF-8");
//        PrintWriter out = response.getWriter();
//        JSONObject json = new JSONObject();
//        
//        try {
//            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
//            
//            // Kiểm tra voucher có tồn tại không
//            Voucher voucher = voucherDAO.getVoucherById(voucherId);
//            if (voucher == null) {
//                json.put("success", false);
//                json.put("message", "Voucher không tồn tại");
//                out.print(json.toString());
//                return;
//            }
//            
//            // Thực hiện xóa voucher
//            if (voucherDAO.deleteVoucher(voucherId)) {
//                json.put("success", true);
//                json.put("message", "Xóa voucher thành công");
//            } else {
//                json.put("success", false);
//                json.put("message", "Không thể xóa voucher");
//            }
//        } catch (NumberFormatException e) {
//            json.put("success", false);
//            json.put("message", "Mã voucher không hợp lệ");
//        } catch (Exception e) {
//            json.put("success", false);
//            json.put("message", "Có lỗi xảy ra khi xóa voucher");
//        }
//        
//        out.print(json.toString());
//    }
//    
//    private void loadVouchers(HttpServletRequest request, HttpServletResponse response, Account account)
//            throws ServletException, IOException {
//        List<Voucher> vouchers = voucherDAO.getVouchersByAccountId(account.getAccountID()); // Sử dụng phương thức đã có
//        request.setAttribute("vouchers", vouchers);
//        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
//    }
//    
//    private void applyVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
//            throws ServletException, IOException {
//        response.setContentType("application/json;charset=UTF-8");
//        PrintWriter out = response.getWriter();
//        JSONObject json = new JSONObject();
//        
//        try {
//            // Kiểm tra account có tồn tại không
//            if (account == null) {
//                json.put("success", false);
//                json.put("message", "Vui lòng đăng nhập để sử dụng voucher");
//                out.print(json.toString());
//                return;
//            }
//            
//            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
//            int maHD = Integer.parseInt(request.getParameter("maHD")); // Thêm dòng này
//            
//            Voucher voucher = voucherDAO.getVoucherById(voucherId);
//            if (voucher == null) {
//                json.put("success", false);
//                json.put("message", "Voucher không tồn tại");
//                out.print(json.toString());
//                return;
//            }
//            
//            // Kiểm tra các điều kiện sử dụng voucher
//            if (!voucher.isActive()) {
//                json.put("success", false);
//                json.put("message", "Voucher đã hết hạn hoặc không còn hiệu lực");
//            } else if (voucher.getUsedCount() >= voucher.getUsageLimit()) {
//                json.put("success", false);
//                json.put("message", "Voucher đã hết lượt sử dụng");
//            } else if (voucherDAO.applyVoucherToOrder(maHD, voucherId, account.getAccountID(), voucher.getDiscountAmount())) { // Sửa dòng này
//                json.put("success", true);
//                json.put("message", "Áp dụng voucher thành công");
//            } else {
//                json.put("success", false);
//                json.put("message", "Không thể áp dụng voucher");
//            }
//        } catch (NumberFormatException e) {
//            json.put("success", false);
//            json.put("message", "Dữ liệu không hợp lệ");
//        } catch (Exception e) {
//            json.put("success", false);
//            json.put("message", "Có lỗi xảy ra: " + e.getMessage());
//        }
//        out.print(json.toString());
//    }
//}