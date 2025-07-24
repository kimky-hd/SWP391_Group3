package Controller.manager;

import DAO.ShipperDAO;
import Model.Shipper;
import Utility.EmailSender;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@WebServlet(name = "ManageShipperController", urlPatterns = {"/manager/shipper", "/manager/shipper/*"})
public class ManageShipperController extends HttpServlet {
    private ShipperDAO shipperDAO;
    // Tạo ExecutorService với 5 thread để xử lý gửi email
    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(5);
    
    @Override
    public void init() {
        shipperDAO = new ShipperDAO();
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
        try {
            String servletPath = request.getServletPath();
            String pathInfo = request.getPathInfo();
            
            System.out.println("ServletPath: " + servletPath);
            System.out.println("PathInfo: " + pathInfo);
            
            if (servletPath.equals("/manager/shipper") && pathInfo == null) {
                // Hiển thị danh sách shipper khi truy cập /manager/shipper
                listShippers(request, response);
            } else if (pathInfo == null || pathInfo.equals("/")) {
                // Hiển thị danh sách shipper khi truy cập /manager/shipper/
                listShippers(request, response);
            } else if (pathInfo.equals("/add")) {
                // Hiển thị form thêm shipper
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Hiển thị form chỉnh sửa shipper
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Xử lý xóa shipper
                deleteShipper(request, response);
            } else if (pathInfo.equals("/view")) {
                // Xem chi tiết shipper
                viewShipperDetails(request, response);
            } else if (pathInfo.equals("/toggle")) {
                // Thay đổi trạng thái hoạt động của shipper
                toggleShipperStatus(request, response);
            } else if (pathInfo.equals("/search")) {
                // Tìm kiếm shipper
                searchShippers(request, response);
            }  else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.out.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // Chuyển hướng đến trang danh sách
                response.sendRedirect(request.getContextPath() + "/manager/shipper");
            } else if (pathInfo.equals("/add")) {
                // Xử lý thêm shipper
                addShipper(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Xử lý cập nhật shipper
                updateShipper(request, response);
            } else if (pathInfo.equals("/search")) {
                // Xử lý tìm kiếm shipper
                searchShippers(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.out.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // Hiển thị danh sách shipper
    private void listShippers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing listShippers method");
            
            // Lấy thông tin phân trang
            int page = 1;
            int recordsPerPage = 5;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            
            // Lấy các tham số tìm kiếm và lọc
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String sort = request.getParameter("sort");
            
            // Lấy danh sách shipper với phân trang và lọc
            List<Shipper> shippers;
            int totalRecords;
            
            if (search != null && !search.isEmpty()) {
                // Tìm kiếm shipper theo từ khóa
                shippers = shipperDAO.searchShippers(search, status, sort, (page - 1) * recordsPerPage, recordsPerPage);
                totalRecords = shipperDAO.countSearchResults(search, status);
            } else if (status != null && !status.isEmpty()) {
                // Lọc theo trạng thái
                boolean isActive = status.equals("active");
                shippers = shipperDAO.getShippersByStatus(isActive, sort, (page - 1) * recordsPerPage, recordsPerPage);
                totalRecords = shipperDAO.countShippersByStatus(isActive);
            } else {
                // Lấy tất cả shipper
                shippers = shipperDAO.getAllShippersWithPaging(sort, (page - 1) * recordsPerPage, recordsPerPage);
                totalRecords = shipperDAO.getTotalShippers();
            }
            
            // Lấy thống kê
            int totalShippers = shipperDAO.getTotalShippers();
            int activeShippers = shipperDAO.getActiveShippersCount();
            int workingShippers = shipperDAO.getCurrentlyWorkingShippersCount();
            int inactiveShippers = totalShippers - activeShippers;
            
            // Đặt các thuộc tính cho JSP
            request.setAttribute("shippers", shippers);
            request.setAttribute("totalShippers", totalShippers);
            request.setAttribute("activeShippers", activeShippers);
            request.setAttribute("workingShippers", workingShippers);
            request.setAttribute("inactiveShippers", inactiveShippers);
            
            // Phân trang
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("recordsPerPage", recordsPerPage);
            
            // Lưu các tham số tìm kiếm và lọc để sử dụng trong phân trang
            request.setAttribute("search", search);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            
            // Hiển thị thông báo từ session nếu có
            HttpSession session = request.getSession();
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }
            
            request.getRequestDispatcher("/manager/shipper_list.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in listShippers: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách shipper: " + e.getMessage());
            request.getRequestDispatcher("/manager/shipper_list.jsp").forward(request, response);
        }
    }
    
    // Hiển thị form thêm shipper
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing showAddForm method");
            request.getRequestDispatcher("/manager/shipper_add.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error in showAddForm: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi hiển thị form thêm shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Hiển thị form chỉnh sửa shipper
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing showEditForm method");
            int shipperId = Integer.parseInt(request.getParameter("id"));
            Shipper shipper = shipperDAO.getShipperById(shipperId);
            
            if (shipper != null) {
                request.setAttribute("shipper", shipper);
                request.getRequestDispatcher("/manager/shipper_edit.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy shipper với ID: " + shipperId);
                response.sendRedirect(request.getContextPath() + "/manager/shipper");
            }
        } catch (NumberFormatException e) {
            System.out.println("Error in showEditForm: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID shipper không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        } catch (Exception e) {
            System.out.println("Error in showEditForm: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi hiển thị form chỉnh sửa shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Xem chi tiết shipper
    private void viewShipperDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing viewShipperDetails method");
            int shipperId = Integer.parseInt(request.getParameter("id"));
            Shipper shipper = shipperDAO.getShipperById(shipperId);
            
            if (shipper != null) {
                // Tính toán thêm thông tin lương
                double totalSalary = shipper.getBaseSalary() + (shipper.getOrdersDelivered() * shipper.getBonusPerOrder());
                
                // Lấy thêm thông tin về đơn hàng của shipper nếu cần
                // int completedOrders = shipperDAO.getCompletedOrdersCount(shipperId);
                // int pendingOrders = shipperDAO.getPendingOrdersCount(shipperId);
                // request.setAttribute("completedOrders", completedOrders);
                // request.setAttribute("pendingOrders", pendingOrders);
                
                request.setAttribute("shipper", shipper);
                request.setAttribute("totalSalary", totalSalary);
                
                // Hiển thị thông báo từ session nếu có
                HttpSession session = request.getSession();
                if (session.getAttribute("successMessage") != null) {
                    request.setAttribute("successMessage", session.getAttribute("successMessage"));
                    session.removeAttribute("successMessage");
                }
                if (session.getAttribute("errorMessage") != null) {
                    request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                    session.removeAttribute("errorMessage");
                }
                
                request.getRequestDispatcher("/manager/shipper_details.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy shipper với ID: " + shipperId);
                response.sendRedirect(request.getContextPath() + "/manager/shipper");
            }
        } catch (NumberFormatException e) {
            System.out.println("Error in viewShipperDetails: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID shipper không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        } catch (Exception e) {
            System.out.println("Error in viewShipperDetails: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi xem chi tiết shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Xử lý thêm shipper mới
    // Xử lý thêm shipper mới
private void addShipper(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        System.out.println("Executing addShipper method");
        
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        String endDateStr = request.getParameter("endDate");
        Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? Date.valueOf(endDateStr) : null;
        
        // Thiết lập giá trị mặc định
        double baseSalary = 0.0;
        double bonusPerOrder = 0.0;
        boolean isActive = true; // Mặc định là hoạt động
        
        // Map để lưu lỗi cho từng field
        Map<String, String> fieldErrors = new HashMap<>();
        
        // Kiểm tra validation
        if (username == null || username.trim().isEmpty()) {
            fieldErrors.put("username", "Tên đăng nhập không được để trống");
        } else if (username.trim().length() < 3) {
            fieldErrors.put("username", "Tên đăng nhập phải có ít nhất 3 ký tự");
        } else if (shipperDAO.isUsernameExists(username)) {
            fieldErrors.put("username", "Tên đăng nhập đã tồn tại");
        }
        
        if (password == null || password.length() < 6) {
            fieldErrors.put("password", "Mật khẩu phải có ít nhất 6 ký tự");
        }
        
        if (email == null || email.trim().isEmpty()) {
            fieldErrors.put("email", "Email không được để trống");
        } else if (shipperDAO.isEmailExists(email)) {
            fieldErrors.put("email", "Email đã tồn tại");
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            fieldErrors.put("phone", "Số điện thoại không được để trống");
        } else if (!phone.matches("^[0-9]{10,11}$")) {
            fieldErrors.put("phone", "Số điện thoại phải có 10-11 chữ số");
        } else if (shipperDAO.isPhoneExists(phone)) {
            fieldErrors.put("phone", "Số điện thoại đã tồn tại");
        }
        
        if (startDate == null) {
            fieldErrors.put("startDate", "Ngày bắt đầu không được để trống");
        }
        
        // Nếu có lỗi, quay lại form với thông báo lỗi
        if (!fieldErrors.isEmpty()) {
            request.setAttribute("fieldErrors", fieldErrors);
            
            // Tạo object để giữ lại dữ liệu form
            Map<String, String> formData = new HashMap<>();
            formData.put("username", username);
            formData.put("email", email);
            formData.put("phone", phone);
            formData.put("startDate", request.getParameter("startDate"));
            formData.put("endDate", endDateStr);
            
            request.setAttribute("formData", formData);
            request.getRequestDispatcher("/manager/shipper_add.jsp").forward(request, response);
            return;
        }
        
        // Tạo đối tượng Shipper
        Shipper shipper = new Shipper();
        shipper.setUsername(username.trim());
        // Không set password ở đây nếu Shipper không có field password
        shipper.setEmail(email.trim());
        shipper.setPhone(phone.trim());
        shipper.setStartDate(startDate);
        shipper.setEndDate(endDate);
        shipper.setBaseSalary(baseSalary);
        shipper.setBonusPerOrder(bonusPerOrder);
        shipper.setOrdersDelivered(0); // Mặc định 0 đơn hàng đã giao
        shipper.setActive(isActive);
        
        // Lưu vào database với password
        boolean success = shipperDAO.addShipper(shipper, password); // Truyền password riêng
        
        if (success) {
                // Gửi email thông báo cho shipper mới trong thread pool
                final String finalEmail = email.trim();
                final String finalUsername = username.trim();
                final String finalPassword = password.trim();
                final Date finalStartDate = startDate;
                final Date finalEndDate = endDate;
                final double finalBaseSalary = baseSalary;
                final double finalBonusPerOrder = bonusPerOrder;
                
                // Gửi email bất đồng bộ sử dụng ExecutorService
                emailExecutor.submit(() -> {
                    try {
                        System.out.println("Đang gửi email thông báo đến shipper mới: " + finalEmail);
                        boolean emailSent = EmailSender.sendNewShipperAccountEmail(
                            finalEmail,
                            finalUsername,
                            finalPassword,
                            finalStartDate,
                            finalEndDate
                            
                        );
                        
                        if (emailSent) {
                            System.out.println("Email đã được gửi thành công đến shipper: " + finalEmail);
                        } else {
                            System.err.println("Không thể gửi email đến shipper: " + finalEmail);
                        }
                    } catch (Exception e) {
                        System.err.println("Lỗi khi gửi email đến shipper: " + e.getMessage());
                        e.printStackTrace();
                    }
                });
                
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Thêm shipper mới thành công! Email thông báo đang được gửi.");
                response.sendRedirect(request.getContextPath() + "/manager/shipper");
            
        } else {
            request.setAttribute("errorMessage", "Không thể thêm shipper. Vui lòng thử lại.");
            
            // Tạo object để giữ lại dữ liệu form
            Map<String, String> formData = new HashMap<>();
            formData.put("username", username);
            formData.put("email", email);
            formData.put("phone", phone);
            formData.put("startDate", request.getParameter("startDate"));
            formData.put("endDate", endDateStr);
            
            request.setAttribute("formData", formData);
            request.getRequestDispatcher("/manager/shipper_add.jsp").forward(request, response);
        }
    } catch (IllegalArgumentException e) {
        System.out.println("Error in addShipper: " + e.getMessage());
        request.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
        request.getRequestDispatcher("/manager/shipper_add.jsp").forward(request, response);
    } catch (Exception e) {
        System.out.println("Error in addShipper: " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("errorMessage", "Lỗi khi thêm shipper: " + e.getMessage());
        request.getRequestDispatcher("/manager/shipper_add.jsp").forward(request, response);
    }
}

    
    // Xử lý cập nhật shipper
    private void updateShipper(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing updateShipper method");
            // Lấy dữ liệu từ form
            int shipperId = Integer.parseInt(request.getParameter("shipperId"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            String endDateStr = request.getParameter("endDate");
            Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? Date.valueOf(endDateStr) : null;
            double baseSalary = Double.parseDouble(request.getParameter("baseSalary"));
            String ordersDeliveredStr = request.getParameter("ordersDelivered");
            int ordersDelivered = (ordersDeliveredStr != null && !ordersDeliveredStr.isEmpty()) 
                ? Integer.parseInt(ordersDeliveredStr) : 0;
            String bonusPerOrderStr = request.getParameter("bonusPerOrder");
            double bonusPerOrder = (bonusPerOrderStr != null && !bonusPerOrderStr.isEmpty()) 
                ? Double.parseDouble(bonusPerOrderStr) : 0;
            boolean isActive = request.getParameter("isActive") != null;
            
            // Lấy shipper hiện tại để kiểm tra
            Shipper currentShipper = shipperDAO.getShipperById(shipperId);
            
            // Kiểm tra dữ liệu
            StringBuilder errorMessage = new StringBuilder();
            if (!username.equals(currentShipper.getUsername()) && shipperDAO.isUsernameExists(username)) {
                errorMessage.append("Tên đăng nhập đã tồn tại. ");
            }
            if (!email.equals(currentShipper.getEmail()) && shipperDAO.isEmailExists(email)) {
                errorMessage.append("Email đã tồn tại. ");
            }
            if (!phone.equals(currentShipper.getPhone()) && shipperDAO.isPhoneExists(phone)) {
                errorMessage.append("Số điện thoại đã tồn tại. ");
            }
            
            // Thêm kiểm tra định dạng email
            if (!isValidEmail(email)) {
                errorMessage.append("Email không đúng định dạng @gmail.com. ");
            }
            
            if (errorMessage.length() > 0) {
                request.setAttribute("errorMessage", errorMessage.toString());
                request.setAttribute("shipper", currentShipper);
                request.getRequestDispatcher("/manager/shipper_edit.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật thông tin shipper
            Shipper shipper = new Shipper();
            shipper.setShipperID(shipperId);
            shipper.setUsername(username);
            shipper.setEmail(email);
            shipper.setPhone(phone);
            shipper.setStartDate(startDate);
            shipper.setEndDate(endDate);
            shipper.setBaseSalary(baseSalary);
            shipper.setOrdersDelivered(ordersDelivered);
            shipper.setBonusPerOrder(bonusPerOrder);
            shipper.setActive(isActive);
            
            // Lưu vào database
            boolean success = shipperDAO.updateShipper(shipper);
            
            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Cập nhật thông tin shipper thành công!");
                
                // Kiểm tra nếu có tham số "redirect" để quay lại trang chi tiết nếu cần
                String redirect = request.getParameter("redirect");
                if (redirect != null && redirect.equals("details")) {
                    response.sendRedirect(request.getContextPath() + "/manager/shipper/view?id=" + shipperId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/manager/shipper");
                }
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thông tin shipper. Vui lòng thử lại.");
                request.setAttribute("shipper", shipper);
                request.getRequestDispatcher("/manager/shipper_edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error in updateShipper: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Xử lý xóa shipper (đánh dấu không hoạt động)
    private void deleteShipper(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing deleteShipper method");
            int shipperId = Integer.parseInt(request.getParameter("id"));
            boolean success = shipperDAO.deleteShipper(shipperId);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("successMessage", "Xóa shipper thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa shipper. Vui lòng thử lại.");
            }
            
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        } catch (NumberFormatException e) {
            System.out.println("Error in deleteShipper: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID shipper không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        } catch (Exception e) {
            System.out.println("Error in deleteShipper: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi xóa shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Xử lý thay đổi trạng thái hoạt động của shipper
    private void toggleShipperStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing toggleShipperStatus method");
            int shipperId = Integer.parseInt(request.getParameter("id"));
            boolean currentStatus = Boolean.parseBoolean(request.getParameter("status"));
            boolean newStatus = !currentStatus;
            
            boolean success = shipperDAO.toggleShipperStatus(shipperId, newStatus);
            
            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("successMessage", 
                    "Đã " + (newStatus ? "kích hoạt" : "vô hiệu hóa") + " shipper thành công.");
            } else {
                session.setAttribute("errorMessage", 
                    "Không thể thay đổi trạng thái shipper. Vui lòng thử lại.");
            }
            
            // Kiểm tra nếu có tham số "redirect" để quay lại trang chi tiết nếu cần
            String redirect = request.getParameter("redirect");
            if (redirect != null && redirect.equals("details")) {
                response.sendRedirect(request.getContextPath() + "/manager/shipper/view?id=" + shipperId);
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/shipper");
            }
        } catch (NumberFormatException e) {
            System.out.println("Error in toggleShipperStatus: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID shipper không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        } catch (Exception e) {
            System.out.println("Error in toggleShipperStatus: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi thay đổi trạng thái shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Tìm kiếm shipper
    private void searchShippers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Executing searchShippers method");
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            
            // Chuyển hướng đến trang danh sách với các tham số tìm kiếm
            response.sendRedirect(request.getContextPath() + "/manager/shipper?search=" + 
                    (keyword != null ? keyword : "") + 
                    (status != null && !status.isEmpty() ? "&status=" + status : ""));
        } catch (Exception e) {
            System.out.println("Error in searchShippers: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi khi tìm kiếm shipper: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/shipper");
        }
    }
    
    // Kiểm tra định dạng email
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$");
    }
}

