package Controller;

import DAO.VoucherDAO;
import Model.Voucher;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VoucherManagementController", urlPatterns = {"/vouchers"})
public class VoucherManagementController extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        VoucherDAO voucherDAO = new VoucherDAO();

        switch (action) {

            case "list":
                // Phân trang
                int page = 1;
                int pageSize = 10;

                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                }

                List<Voucher> vouchers = voucherDAO.getAllVouchersWithPaging(page, pageSize);

                int totalVouchers = voucherDAO.getTotalVouchers();
                System.out.println("Total vouchers: " + totalVouchers);
                int totalPages = (int) Math.ceil((double) totalVouchers / pageSize);

                request.setAttribute("vouchers", vouchers);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/manager/vouchers.jsp").forward(request, response);
                break;

            case "view":
                int viewId = Integer.parseInt(request.getParameter("id"));
                Voucher viewVoucher = voucherDAO.getVoucherById(viewId);

                if (viewVoucher != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    // Sử dụng Gson với DateFormat để xử lý Date objects
                    Gson gson = new GsonBuilder()
                            .setDateFormat("yyyy-MM-dd HH:mm:ss")
                            .create();
                    String jsonVoucher = gson.toJson(viewVoucher);

                    response.getWriter().write(jsonVoucher);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Không tìm thấy voucher\"}");
                }
                return;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Voucher editVoucher = voucherDAO.getVoucherById(editId);
                
                if (editVoucher != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    // Sử dụng Gson với DateFormat để xử lý Date objects
                    Gson gson = new GsonBuilder()
                            .setDateFormat("yyyy-MM-dd HH:mm:ss")
                            .create();
                    String jsonVoucher = gson.toJson(editVoucher);

                    response.getWriter().write(jsonVoucher);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\":\"Không tìm thấy voucher\"}");
                }
                return;

            case "add":
                String code = request.getParameter("code");
                double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                String description = request.getParameter("description");

                // Kiểm tra xem mã voucher đã tồn tại chưa
                if (voucherDAO.checkVoucherCodeExist(code)) {
                    request.getSession().setAttribute("error", "Mã voucher đã tồn tại!");
                    response.sendRedirect("vouchers");
                    return;
                }

                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    dateFormat.setLenient(false);

                    System.out.println("Start date string: " + startDateStr);
                    System.out.println("End date string: " + endDateStr);

                    Date startDate = dateFormat.parse(startDateStr);
                    Date endDate = dateFormat.parse(endDateStr);
                  
                    // Kiểm tra ngày bắt đầu phải trước ngày kết thúc
                    if (startDate.after(endDate)) {
                        request.getSession().setAttribute("error", "Ngày bắt đầu phải trước ngày kết thúc!");
                        response.sendRedirect("vouchers");
                        return;
                    }

                    // Kiểm tra ngày bắt đầu không được trong quá khứ (trừ trong ngày hiện tại)
                    Date now = new Date();
                    Date today = new Date(now.getYear(), now.getMonth(), now.getDate());
                    if (startDate.before(today)) {
                        request.getSession().setAttribute("error", "Ngày bắt đầu không được trong quá khứ!");
                        response.sendRedirect("vouchers");
                        return;
                    }

                    Timestamp startTimestamp = new Timestamp(startDate.getTime());
                    Timestamp endTimestamp = new Timestamp(endDate.getTime());
                
                    Voucher newVoucher = new Voucher();
                    newVoucher.setCode(code);
                    newVoucher.setDiscountAmount(discountAmount);
                    newVoucher.setMinOrderValue(minOrderValue);
                    newVoucher.setStartDate(startTimestamp);
                    newVoucher.setEndDate(endTimestamp);
                    newVoucher.setIsActive(true);
                    newVoucher.setUsageLimit(usageLimit);
                    newVoucher.setUsedCount(0);
                    newVoucher.setDescription(description);
                    // created_date sẽ được tự động set trong database

                    boolean success = voucherDAO.addVoucher(newVoucher);

                    if (success) {
                        request.getSession().setAttribute("message", "Thêm voucher thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Thêm voucher thất bại!");
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("error", "Định dạng ngày tháng không hợp lệ: " + e.getMessage());
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Dữ liệu số không hợp lệ!");
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
                }

                response.sendRedirect("vouchers");
                break;

            case "update":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String updatedCode = request.getParameter("code");
                    double updatedDiscountAmount = Double.parseDouble(request.getParameter("discountAmount"));
                    double updatedMinOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
                    String updatedStartDateStr = request.getParameter("startDate");
                    String updatedEndDateStr = request.getParameter("endDate");
                    int updatedUsageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                    String updatedDescription = request.getParameter("description");

                    // Kiểm tra xem mã voucher đã tồn tại chưa (nếu đã thay đổi)
                    Voucher existingVoucher = voucherDAO.getVoucherById(id);
                    if (!existingVoucher.getCode().equals(updatedCode) && voucherDAO.checkVoucherCodeExist(updatedCode)) {
                        request.getSession().setAttribute("error", "Mã voucher đã tồn tại!");
                        response.sendRedirect("vouchers");
                        return;
                    }

                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    Date startDate = dateFormat.parse(updatedStartDateStr);
                    Date endDate = dateFormat.parse(updatedEndDateStr);

                    // Kiểm tra ngày bắt đầu phải trước ngày kết thúc
                    if (startDate.after(endDate)) {
                        request.getSession().setAttribute("error", "Ngày bắt đầu phải trước ngày kết thúc!");
                        response.sendRedirect("vouchers");
                        return;
                    }

                    Timestamp startTimestamp = new Timestamp(startDate.getTime());
                    Timestamp endTimestamp = new Timestamp(endDate.getTime());

                    if (existingVoucher != null) {
                        existingVoucher.setCode(updatedCode);
                        existingVoucher.setDiscountAmount(updatedDiscountAmount);
                        existingVoucher.setMinOrderValue(updatedMinOrderValue);
                        existingVoucher.setStartDate(startTimestamp);
                        existingVoucher.setEndDate(endTimestamp);
                        existingVoucher.setUsageLimit(updatedUsageLimit);
                        existingVoucher.setDescription(updatedDescription);
                        // Không cập nhật created_date

                        boolean updateSuccess = voucherDAO.updateVoucher(existingVoucher);

                        if (updateSuccess) {
                            request.getSession().setAttribute("message", "Cập nhật voucher thành công!");
                        } else {
                            request.getSession().setAttribute("error", "Cập nhật voucher thất bại!");
                        }
                    } else {
                        request.getSession().setAttribute("error", "Không tìm thấy voucher!");
                    }
                } catch (ParseException e) {
                    request.getSession().setAttribute("error", "Định dạng ngày tháng không hợp lệ!");
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Dữ liệu số không hợp lệ!");
                } catch (Exception e) {
                    request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
                }

                response.sendRedirect("vouchers");
                break;

            case "toggle":
                int voucherId = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                boolean toggleSuccess = voucherDAO.toggleVoucherStatus(voucherId, !status);

                if (toggleSuccess) {
                    request.setAttribute("message", "Thay đổi trạng thái thành công!");
                } else {
                    request.setAttribute("error", "Thay đổi trạng thái thất bại!");
                }

                response.sendRedirect("vouchers");
                break;

            // **METHOD MỚI**: Lấy vouchers mới nhất
            case "recent":
                int limit = 5; // Lấy 5 voucher mới nhất
                if (request.getParameter("limit") != null) {
                    limit = Integer.parseInt(request.getParameter("limit"));
                }
                
                List<Voucher> recentVouchers = voucherDAO.getRecentVouchers(limit);
                request.setAttribute("recentVouchers", recentVouchers);
                request.getRequestDispatcher("/manager/recent_vouchers.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("vouchers");
                break;
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
