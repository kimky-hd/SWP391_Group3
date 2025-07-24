package Controller.manager;

import Utility.EmailSender;
import DAO.StaffDAO;
import Model.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@WebServlet(name = "StaffController", urlPatterns = {"/manager/staff"})
public class StaffController extends HttpServlet {

    private StaffDAO staffDAO;
    // Tạo ExecutorService với 5 thread để xử lý gửi email
    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(5);

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }
    
    @Override
    public void destroy() {
        // Đảm bảo đóng ExecutorService khi servlet bị hủy
        if (emailExecutor != null && !emailExecutor.isShutdown()) {
            emailExecutor.shutdown();
        }
        super.destroy();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập (chỉ manager mới được truy cập)
        HttpSession session = request.getSession();
        if (session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                showStaffList(request, response);
                break;
            case "add":
                showAddStaffForm(request, response);
                break;
            case "edit":
                showEditStaffForm(request, response);
                break;
            case "toggle":
                toggleStaffStatus(request, response);
                break;
            case "detail":
                viewStaffDetails(request, response);
                break;
            case "delete":
                deleteStaff(request, response);
                break;
            default:
                showStaffList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addStaff(request, response);
                break;
            case "update":
                updateStaff(request, response);
                break;
            
            default:
                showStaffList(request, response);
                break;
        }
    }

    // ==================== READ OPERATIONS ====================
    
    // Hiển thị danh sách nhân viên
    private void showStaffList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Staff> staffList = staffDAO.getAllStaff();

            // Thống kê
            int totalStaff = staffDAO.getTotalStaff();
            int activeStaff = staffDAO.getActiveStaffCount();
            int workingStaff = staffDAO.getCurrentlyWorkingStaffCount();
            int inactiveStaff = totalStaff - activeStaff;

            request.setAttribute("staffList", staffList);
            request.setAttribute("totalStaff", totalStaff);
            request.setAttribute("activeStaff", activeStaff);
            request.setAttribute("workingStaff", workingStaff);
            request.setAttribute("inactiveStaff", inactiveStaff);

            request.getRequestDispatcher("/manager/staff.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách nhân viên: " + e.getMessage());
            request.getRequestDispatcher("/manager/staff.jsp").forward(request, response);
        }
    }

    // Xem chi tiết nhân viên
    private void viewStaffDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                request.setAttribute("error", "ID nhân viên không hợp lệ!");
                showStaffList(request, response);
                return;
            }

            int staffID = Integer.parseInt(idStr);
            Staff staff = staffDAO.getStaffById(staffID);

            if (staff == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên!");
                showStaffList(request, response);
                return;
            }

            // Lấy thông báo từ URL parameters (nếu có)
            String message = request.getParameter("message");
            String error = request.getParameter("error");

            if (message != null && !message.trim().isEmpty()) {
                request.setAttribute("message", message);
            }

            if (error != null && !error.trim().isEmpty()) {
                request.setAttribute("error", error);
            }

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/manager/staff_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showStaffList(request, response);
        }
    }

    // ==================== CREATE OPERATIONS ====================
    
    // Hiển thị form thêm nhân viên
    private void showAddStaffForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/manager/staff_add.jsp").forward(request, response);
    }

    // Thêm nhân viên mới
    private void addStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String startMonthStr = request.getParameter("startMonth");
            String endMonthStr = request.getParameter("endMonth");

            // Validation
            StringBuilder errors = new StringBuilder();

            if (username == null || username.trim().isEmpty()) {
                errors.append("Tên đăng nhập không được để trống. ");
            } else if (username.trim().length() < 3) {
                errors.append("Tên đăng nhập phải có ít nhất 3 ký tự. ");
            } else if (staffDAO.isUsernameExists(username.trim())) {
                errors.append("Tên đăng nhập đã tồn tại. ");
            }

            if (password == null || password.trim().isEmpty()) {
                errors.append("Mật khẩu không được để trống. ");
            } else if (password.trim().length() < 6) {
                errors.append("Mật khẩu phải có ít nhất 6 ký tự. ");
            }

            if (email == null || email.trim().isEmpty()) {
                errors.append("Email không được để trống. ");
            } else if (!isValidEmail(email.trim())) {
                errors.append("Email không đúng định dạng. ");
            } else if (staffDAO.isEmailExists(email.trim())) {
                errors.append("Email đã tồn tại. ");
            }

            if (phone != null && !phone.trim().isEmpty()) {
                if (!isValidPhone(phone.trim())) {
                    errors.append("Số điện thoại không đúng định dạng. ");
                } else if (staffDAO.isPhoneExists(phone.trim())) {
                    errors.append("Số điện thoại đã tồn tại. ");
                }
            }

            Date startMonth = null;
            if (startMonthStr == null || startMonthStr.trim().isEmpty()) {
                errors.append("Ngày bắt đầu làm việc không được để trống. ");
            } else {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    startMonth = sdf.parse(startMonthStr);
                } catch (ParseException e) {
                    errors.append("Ngày bắt đầu làm việc không đúng định dạng. ");
                }
            }

            Date endMonth = null;
            if (endMonthStr == null || endMonthStr.trim().isEmpty()) {
                errors.append("Ngày kết thúc hợp đồng không được để trống. ");
            } else {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    endMonth = sdf.parse(endMonthStr);
                    if (startMonth != null && endMonth.before(startMonth)) {
                        errors.append("Ngày kết thúc phải sau ngày bắt đầu. ");
                    }
                } catch (ParseException e) {
                    errors.append("Ngày kết thúc hợp đồng không đúng định dạng. ");
                }
            }

            // SET LƯƠNG MẶC ĐỊNH LÀ 0
            BigDecimal salary = BigDecimal.ZERO;

            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                request.getRequestDispatcher("/manager/staff_add.jsp").forward(request, response);
                return;
            }

            // Thêm nhân viên với lương mặc định là 0
            boolean success = staffDAO.addStaff(
                    username.trim(),
                    password.trim(),
                    email.trim(),
                    phone != null ? phone.trim() : null,
                    startMonth,
                    endMonth,
                    salary // BigDecimal.ZERO
            );
            
            if (success) {
                // Gửi email thông báo cho nhân viên mới trong thread pool
                final String finalEmail = email.trim();
                final String finalUsername = username.trim();
                final String finalPassword = password.trim();
                final Date finalStartMonth = startMonth;
                final Date finalEndMonth = endMonth;
                
                // Gửi email bất đồng bộ sử dụng ExecutorService
                emailExecutor.submit(() -> {
                    try {
                        System.out.println("Đang gửi email thông báo đến nhân viên mới: " + finalEmail);
                        boolean emailSent = Utility.EmailSender.sendNewStaffAccountEmail(
                            finalEmail,
                            finalUsername,
                            finalPassword,
                            finalStartMonth,
                            finalEndMonth
                        );
                        
                        if (emailSent) {
                            System.out.println("Email đã được gửi thành công đến: " + finalEmail);
                        } else {
                            System.err.println("Không thể gửi email đến: " + finalEmail);
                        }
                    } catch (Exception e) {
                        System.err.println("Lỗi khi gửi email: " + e.getMessage());
                        e.printStackTrace();
                    }
                });
                
                // Redirect về trang danh sách với thông báo thành công
                response.sendRedirect("staff?message=" + java.net.URLEncoder.encode(
                    "Thêm nhân viên thành công! Lương mặc định được thiết lập là 0 VNĐ. Email thông báo đang được gửi.", 
                    "UTF-8"));
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm nhân viên!");
                request.getRequestDispatcher("/manager/staff_add.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/manager/staff_add.jsp").forward(request, response);
        }
    }

    // ==================== UPDATE OPERATIONS ====================
    
    // Hiển thị form chỉnh sửa nhân viên
    private void showEditStaffForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                request.setAttribute("error", "ID nhân viên không hợp lệ!");
                showStaffList(request, response);
                return;
            }

            int staffID = Integer.parseInt(idStr);
            Staff staff = staffDAO.getStaffById(staffID);

            if (staff == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên!");
                showStaffList(request, response);
                return;
            }

            // Lấy thông báo từ URL parameters (nếu có)
            String message = request.getParameter("message");
            String error = request.getParameter("error");

            if (message != null && !message.trim().isEmpty()) {
                request.setAttribute("message", message);
            }

            if (error != null && !error.trim().isEmpty()) {
                request.setAttribute("error", error);
            }

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/manager/staff_edit.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showStaffList(request, response);
        }
    }

    // Cập nhật thông tin nhân viên
    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String startMonthStr = request.getParameter("startMonth");
            String endMonthStr = request.getParameter("endMonth");
            String salaryStr = request.getParameter("salary");

            int staffID = Integer.parseInt(idStr);

            // Validation
            StringBuilder errors = new StringBuilder();

            if (username == null || username.trim().isEmpty()) {
                errors.append("Tên đăng nhập không được để trống. ");
            } else if (username.trim().length() < 3) {
                errors.append("Tên đăng nhập phải có ít nhất 3 ký tự. ");
            } else if (staffDAO.isUsernameExistsExcludeId(username.trim(), staffID)) {
                errors.append("Tên đăng nhập đã tồn tại. ");
            }

            if (email == null || email.trim().isEmpty()) {
                errors.append("Email không được để trống. ");
            } else if (!isValidEmail(email.trim())) {
                errors.append("Email không đúng định dạng. ");
            } else if (staffDAO.isEmailExistsExcludeId(email.trim(), staffID)) {
                errors.append("Email đã tồn tại. ");
            }

            if (phone != null && !phone.trim().isEmpty()) {
                if (!isValidPhone(phone.trim())) {
                    errors.append("Số điện thoại không đúng định dạng. ");
                } else if (staffDAO.isPhoneExistsExcludeId(phone.trim(), staffID)) {
                    errors.append("Số điện thoại đã tồn tại. ");
                }
            }

            Date startMonth = null;
            if (startMonthStr != null && !startMonthStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    startMonth = sdf.parse(startMonthStr);
                } catch (ParseException e) {
                    errors.append("Ngày bắt đầu làm việc không đúng định dạng. ");
                }
            }

            Date endMonth = null;
            if (endMonthStr != null && !endMonthStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    endMonth = sdf.parse(endMonthStr);
                    if (startMonth != null && endMonth.before(startMonth)) {
                        errors.append("Ngày kết thúc phải sau ngày bắt đầu. ");
                    }
                } catch (ParseException e) {
                    errors.append("Ngày kết thúc làm việc không đúng định dạng. ");
                }
            }

            BigDecimal salary = null;
            if (salaryStr != null && !salaryStr.trim().isEmpty()) {
                try {
                    salary = new BigDecimal(salaryStr.trim());
                    if (salary.compareTo(BigDecimal.ZERO) < 0) {
                        errors.append("Lương không được âm. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Lương phải là số. ");
                }
            }

            if (errors.length() > 0) {
                // Kiểm tra nguồn request để redirect đúng trang
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("action=edit")) {
                    response.sendRedirect("staff?action=edit&id=" + staffID + "&error=" + java.net.URLEncoder.encode(errors.toString(), "UTF-8"));
                } else if (referer != null && referer.contains("action=detail")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&error=" + java.net.URLEncoder.encode(errors.toString(), "UTF-8"));
                } else {
                    request.setAttribute("error", errors.toString());
                    showStaffList(request, response);
                }
                return;
            }

            // Cập nhật nhân viên
            boolean success = staffDAO.updateStaff(
                    staffID,
                    username.trim(),
                    email.trim(),
                    phone != null ? phone.trim() : null,
                    startMonth,
                    endMonth,
                    salary
            );

            if (success) {
                String successMsg = "Cập nhật thông tin nhân viên thành công!";
                
                // Kiểm tra nguồn request để redirect đúng trang
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("action=edit")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&message=" + java.net.URLEncoder.encode(successMsg, "UTF-8"));
                } else if (referer != null && referer.contains("action=detail")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&message=" + java.net.URLEncoder.encode(successMsg, "UTF-8"));
                } else {
                    request.setAttribute("message", successMsg);
                    showStaffList(request, response);
                }
            } else {
                String errorMsg = "Có lỗi xảy ra khi cập nhật thông tin nhân viên!";
                
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("action=edit")) {
                    response.sendRedirect("staff?action=edit&id=" + staffID + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                } else if (referer != null && referer.contains("action=detail")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                } else {
                    request.setAttribute("error", errorMsg);
                    showStaffList(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showStaffList(request, response);
        }
    }

    // Kích hoạt/vô hiệu hóa tài khoản nhân viên
    private void toggleStaffStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            String statusStr = request.getParameter("status");
            String referer = request.getHeader("Referer");

            if (idStr == null || statusStr == null) {
                request.setAttribute("error", "Thông tin không hợp lệ!");
                showStaffList(request, response);
                return;
            }

            int staffID = Integer.parseInt(idStr);
            boolean currentStatus = Boolean.parseBoolean(statusStr);
            boolean newStatus = !currentStatus;

            boolean success = staffDAO.toggleStaffStatus(staffID, newStatus);

            if (success) {
                String action = newStatus ? "kích hoạt" : "vô hiệu hóa";
                String message = "Đã " + action + " tài khoản nhân viên thành công!";

                // Kiểm tra nếu request từ staff_detail.jsp
                if (referer != null && referer.contains("action=detail")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                } else {
                    response.sendRedirect("staff?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                }
            } else {
                String errorMsg = "Có lỗi xảy ra khi thay đổi trạng thái nhân viên!";

                if (referer != null && referer.contains("action=detail")) {
                    response.sendRedirect("staff?action=detail&id=" + staffID + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                } else {
                    response.sendRedirect("staff?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "Có lỗi xảy ra: " + e.getMessage();
            response.sendRedirect("staff?error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }


    // ==================== DELETE OPERATIONS ====================
    
    // Xóa nhân viên (soft delete - chỉ vô hiệu hóa)
    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            String confirm = request.getParameter("confirm");

            if (idStr == null) {
                response.sendRedirect("staff?error=" + java.net.URLEncoder.encode("ID nhân viên không hợp lệ!", "UTF-8"));
                return;
            }

            int staffID = Integer.parseInt(idStr);

            // Kiểm tra xác nhận
            if (!"true".equals(confirm)) {
                response.sendRedirect("staff?error=" + java.net.URLEncoder.encode("Vui lòng xác nhận việc xóa nhân viên!", "UTF-8"));
                return;
            }

            // Kiểm tra nhân viên có tồn tại không
            Staff staff = staffDAO.getStaffById(staffID);
            if (staff == null) {
                response.sendRedirect("staff?error=" + java.net.URLEncoder.encode("Không tìm thấy nhân viên!", "UTF-8"));
                return;
            }

            // Thực hiện soft delete (vô hiệu hóa tài khoản)
            boolean success = staffDAO.toggleStaffStatus(staffID, false);

            if (success) {
                response.sendRedirect("staff?message=" + java.net.URLEncoder.encode("Đã vô hiệu hóa tài khoản nhân viên thành công!", "UTF-8"));
            } else {
                response.sendRedirect("staff?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra khi xóa nhân viên!", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff?error=" + java.net.URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    // ==================== VALIDATION HELPER METHODS ====================
    
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$");
    }
    
    private boolean isValidPhone(String phone) {
        return phone == null || phone.isEmpty() || phone.matches("^[0-9]{10,11}$");
    }
    
    // Thêm phương thức này vào các hàm xử lý form để kiểm tra dữ liệu
    private boolean validateStaffData(HttpServletRequest request, Map<String, String> fieldErrors) {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        boolean isValid = true;
        
        if (!isValidEmail(email)) {
            fieldErrors.put("email", "Email không đúng định dạng @gmail.com");
            isValid = false;
        }
        
        if (!isValidPhone(phone)) {
            fieldErrors.put("phone", "Số điện thoại phải có 10-11 chữ số");
            isValid = false;
        }
        
        return isValid;
    }
}
