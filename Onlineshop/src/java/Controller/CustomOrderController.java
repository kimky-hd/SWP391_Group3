package Controller;

import DAO.CartDAO;
import DAO.DBContext;
import Model.Account;
import Model.Cart;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet xử lý yêu cầu đặt hàng tùy chỉnh từ form CustomOrder.jsp Cho phép
 * người dùng tải lên hình ảnh mẫu, mô tả chi tiết và số lượng Lưu thông tin vào
 * bảng customordercart trong database
 */
@WebServlet(name = "CustomOrderController", urlPatterns = {"/submit-customize-request"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5)
public class CustomOrderController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    
    @Override
    public void init() {
        // Tạo thư mục img/uploads/Custome_img nếu chưa tồn tại
        String uploadPath = getServletContext().getRealPath("/img/uploads/Custome_img");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }
    
    /**
     * Xử lý yêu cầu POST từ form đặt hàng tùy chỉnh
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException nếu xảy ra lỗi servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            session.setAttribute("message", "Vui lòng đăng nhập để sử dụng tính năng này!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy thông tin từ form
            String description = request.getParameter("description");
            String quantityStr = request.getParameter("quantity");
            String desiredPriceStr = request.getParameter("desiredPrice");
            // Lấy thông tin liên hệ từ form
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            int quantity;
            double desiredPrice = 0.0; // Khởi tạo giá trị mặc định
            
            // Chuyển đổi giá mong muốn từ chuỗi sang số
            if (desiredPriceStr != null && !desiredPriceStr.trim().isEmpty()) {
                try {
                    desiredPrice = Double.parseDouble(desiredPriceStr);
                    if (desiredPrice < 0) {
                        desiredPrice = 0.0; // Đặt về 0 nếu giá âm
                    }
                } catch (NumberFormatException e) {
                    // Nếu không thể chuyển đổi, giữ giá trị mặc định là 0
                    System.out.println("Error parsing desired price: " + e.getMessage());
                }
            }

            // Lưu thông tin vào session để giữ lại khi có lỗi
            session.setAttribute("savedDescription", description);
            session.setAttribute("savedQuantity", quantityStr);
            session.setAttribute("savedDesiredPrice", desiredPriceStr);
            session.setAttribute("savedFullName", fullName);
            session.setAttribute("savedPhone", phone);
            session.setAttribute("savedEmail", email);

            // Xác thực mô tả
            if (description == null || description.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng nhập mô tả chi tiết");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            if (description.length() < 10) {
                session.setAttribute("message", "Mô tả quá ngắn, vui lòng cung cấp thông tin chi tiết hơn");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            if (description.length() > 1000) {
                session.setAttribute("message", "Mô tả quá dài, vui lòng tóm tắt trong 1000 ký tự");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            // Xác thực số lượng
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    session.setAttribute("message", "Số lượng phải lớn hơn 0");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("CustomOrder.jsp");
                    return;
                }

                if (quantity > 100) {
                    session.setAttribute("message", "Số lượng tối đa cho đơn hàng tùy chỉnh là 100");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("CustomOrder.jsp");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("message", "Số lượng không hợp lệ");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            // Xác thực thông tin liên hệ
            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng nhập họ tên");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng nhập số điện thoại");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng nhập email");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            // Xử lý upload file chính
            Part filePart = request.getPart("imageUpload");
            String fileName = getFileName(filePart);

            // Xác thực file ảnh chính
            if (fileName == null || fileName.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng tải lên ít nhất một hình ảnh mẫu");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            // Kiểm tra định dạng file
            String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!fileExtension.equals("jpg") && !fileExtension.equals("jpeg")
                    && !fileExtension.equals("png") && !fileExtension.equals("gif")) {
                session.setAttribute("message", "Chỉ chấp nhận file hình ảnh có định dạng JPG, JPEG, PNG hoặc GIF");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            // Tạo tên file duy nhất để tránh trùng lặp
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

            // Lưu file vào thư mục img/uploads/Custome_img
            String uploadPath = getServletContext().getRealPath("/img/uploads/Custome_img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Đường dẫn tương đối để lưu vào database
            String relativePath = "img/uploads/Custome_img/" + uniqueFileName;

            // Xử lý các file ảnh bổ sung
            String relativePath2 = null;
            String relativePath3 = null;
            String relativePath4 = null;
            String relativePath5 = null;

            // Xử lý file 2
            Part filePart2 = request.getPart("imageUpload2");
            if (filePart2 != null && filePart2.getSize() > 0) {
                String fileName2 = getFileName(filePart2);
                if (fileName2 != null && !fileName2.trim().isEmpty()) {
                    String fileExtension2 = fileName2.substring(fileName2.lastIndexOf(".") + 1).toLowerCase();
                    if (fileExtension2.equals("jpg") || fileExtension2.equals("jpeg")
                            || fileExtension2.equals("png") || fileExtension2.equals("gif")) {
                        String uniqueFileName2 = UUID.randomUUID().toString() + "_" + fileName2;
                        String filePath2 = uploadPath + File.separator + uniqueFileName2;
                        filePart2.write(filePath2);
                        relativePath2 = "img/uploads/Custome_img/" + uniqueFileName2;
                    }
                }
            }

            // Xử lý file 3
            Part filePart3 = request.getPart("imageUpload3");
            if (filePart3 != null && filePart3.getSize() > 0) {
                String fileName3 = getFileName(filePart3);
                if (fileName3 != null && !fileName3.trim().isEmpty()) {
                    String fileExtension3 = fileName3.substring(fileName3.lastIndexOf(".") + 1).toLowerCase();
                    if (fileExtension3.equals("jpg") || fileExtension3.equals("jpeg")
                            || fileExtension3.equals("png") || fileExtension3.equals("gif")) {
                        String uniqueFileName3 = UUID.randomUUID().toString() + "_" + fileName3;
                        String filePath3 = uploadPath + File.separator + uniqueFileName3;
                        filePart3.write(filePath3);
                        relativePath3 = "img/uploads/Custome_img/" + uniqueFileName3;
                    }
                }
            }

            // Xử lý file 4
            Part filePart4 = request.getPart("imageUpload4");
            if (filePart4 != null && filePart4.getSize() > 0) {
                String fileName4 = getFileName(filePart4);
                if (fileName4 != null && !fileName4.trim().isEmpty()) {
                    String fileExtension4 = fileName4.substring(fileName4.lastIndexOf(".") + 1).toLowerCase();
                    if (fileExtension4.equals("jpg") || fileExtension4.equals("jpeg")
                            || fileExtension4.equals("png") || fileExtension4.equals("gif")) {
                        String uniqueFileName4 = UUID.randomUUID().toString() + "_" + fileName4;
                        String filePath4 = uploadPath + File.separator + uniqueFileName4;
                        filePart4.write(filePath4);
                        relativePath4 = "img/uploads/Custome_img/" + uniqueFileName4;
                    }
                }
            }

            // Xử lý file 5
            Part filePart5 = request.getPart("imageUpload5");
            if (filePart5 != null && filePart5.getSize() > 0) {
                String fileName5 = getFileName(filePart5);
                if (fileName5 != null && !fileName5.trim().isEmpty()) {
                    String fileExtension5 = fileName5.substring(fileName5.lastIndexOf(".") + 1).toLowerCase();
                    if (fileExtension5.equals("jpg") || fileExtension5.equals("jpeg")
                            || fileExtension5.equals("png") || fileExtension5.equals("gif")) {
                        String uniqueFileName5 = UUID.randomUUID().toString() + "_" + fileName5;
                        String filePath5 = uploadPath + File.separator + uniqueFileName5;
                        filePart5.write(filePath5);
                        relativePath5 = "img/uploads/Custome_img/" + uniqueFileName5;
                    }
                }
            }

            // Thêm đơn hàng tùy chỉnh với nhiều hình ảnh và thông tin liên hệ
            quantity = Integer.parseInt(quantityStr);
            int customOrderID = addCustomOrderToCart(account.getAccountID(), relativePath, relativePath2, relativePath3, relativePath4, relativePath5, description, quantity, fullName, phone, email, desiredPrice);

            if (customOrderID > 0) {
                session.setAttribute("message", "Yêu cầu đặt hàng tùy chỉnh của bạn đã được gửi thành công. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất!");
                session.setAttribute("messageType", "success");
                // Xóa các giá trị đã lưu khi gửi thành công
                session.removeAttribute("savedDescription");
                session.removeAttribute("savedQuantity");
                session.removeAttribute("savedDesiredPrice");
                session.removeAttribute("savedFullName");
                session.removeAttribute("savedPhone");
                session.removeAttribute("savedEmail");
            } else {
                session.setAttribute("message", "Có lỗi xảy ra khi gửi yêu cầu. Vui lòng thử lại sau!");
                session.setAttribute("messageType", "error");
            }

            response.sendRedirect("CustomOrder.jsp");

        } catch (Exception e) {
            // Kiểm tra nếu là lỗi kích thước file
            if (e instanceof IllegalStateException && e.getMessage() != null
                    && e.getMessage().contains("size")) {
                session.setAttribute("message", "Kích thước file không được vượt quá 5MB");
            } else {
                session.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            }
            session.setAttribute("messageType", "error");
            response.sendRedirect("CustomOrder.jsp");
        }
    }

    /**
     * Lấy tên file từ Part
     *
     * @param part Part chứa file
     * @return Tên file
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    /**
     * Lấy cartID dựa vào accountID
     *
     * @param accountId ID của tài khoản
     * @return cartID nếu tồn tại, 0 nếu không tìm thấy
     */
    private int getCartIDByAccountID(int accountId) {
        String sql = "SELECT cartID FROM cart WHERE accountID = ? LIMIT 1";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cartID");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting cartID: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tạo giỏ hàng mới cho người dùng
     *
     * @param accountId ID của tài khoản
     * @return cartID mới được tạo
     */
    private int createNewCart(int accountId) {
        String sql = "INSERT INTO cart (accountID, status) VALUES (?, 0)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, accountId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating new cart: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Thêm đơn hàng tùy chỉnh vào giỏ hàng
     *
     * @param accountID ID của tài khoản
     * @param imagePath Đường dẫn đến hình ảnh mẫu chính
     * @param imagePath2 Đường dẫn đến hình ảnh mẫu thứ 2
     * @param imagePath3 Đường dẫn đến hình ảnh mẫu thứ 3
     * @param imagePath4 Đường dẫn đến hình ảnh mẫu thứ 4
     * @param imagePath5 Đường dẫn đến hình ảnh mẫu thứ 5
     * @param description Mô tả chi tiết
     * @param quantity Số lượng
     * @param fullName Họ tên khách hàng
     * @param phone Số điện thoại khách hàng
     * @param email Email khách hàng
     * @return ID của đơn hàng tùy chỉnh mới được tạo
     */
    private int addCustomOrderToCart(int accountID, String imagePath, String imagePath2, String imagePath3, String imagePath4, String imagePath5, String description, int quantity, String fullName, String phone, String email, double desiredPrice) {
        String sql = "INSERT INTO customordercart (accountID, referenceImage, referenceImage2, referenceImage3, referenceImage4, referenceImage5, description, quantity, statusID, fullName, phone, email, desired_price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?)";  // Sử dụng statusID = 1 (tương ứng với trạng thái 'pending')
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, accountID);
            ps.setString(2, imagePath);
            ps.setString(3, imagePath2);
            ps.setString(4, imagePath3);
            ps.setString(5, imagePath4);
            ps.setString(6, imagePath5);
            ps.setString(7, description);
            ps.setInt(8, quantity);
            ps.setString(9, fullName);
            ps.setString(10, phone);
            ps.setString(11, email);
            ps.setDouble(12, desiredPrice);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding custom order: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Xử lý yêu cầu GET (chuyển hướng đến trang đặt hàng tùy chỉnh)
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException nếu xảy ra lỗi servlet
     * @throws IOException nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("CustomOrder.jsp");
    }
}
