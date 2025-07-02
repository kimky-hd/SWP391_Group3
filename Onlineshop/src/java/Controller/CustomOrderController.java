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
 * Servlet xử lý yêu cầu đặt hàng tùy chỉnh từ form CustomOrder.jsp
 * Cho phép người dùng tải lên hình ảnh mẫu, mô tả chi tiết và số lượng
 * Lưu thông tin vào bảng customordercart trong database
 */
@WebServlet(name = "CustomOrderController", urlPatterns = {"/submit-customize-request"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5)
public class CustomOrderController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Kiểm tra đăng nhập
        if (account == null) {
            // Lưu URL hiện tại để chuyển hướng lại sau khi đăng nhập
            session.setAttribute("redirectURL", "CustomOrder.jsp");
            session.setAttribute("message", "Vui lòng đăng nhập để gửi yêu cầu đặt hàng tùy chỉnh");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Kiểm tra kích thước file trước khi xử lý các tham số khác
            try {
                Part filePart = request.getPart("imageUpload");
                if (filePart != null && filePart.getSize() > 5 * 1024 * 1024) { // 5MB
                    session.setAttribute("message", "Kích thước file không được vượt quá 5MB");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("CustomOrder.jsp");
                    return;
                }
            } catch (IllegalStateException e) {
                // Bắt ngoại lệ khi file vượt quá kích thước cho phép
                session.setAttribute("message", "Kích thước file không được vượt quá 5MB");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            // Lấy các tham số từ form
            String description = request.getParameter("description");
            String quantityStr = request.getParameter("quantity");
            
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
            int quantity;
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

            // Xử lý upload file
            Part filePart = request.getPart("imageUpload");
            String fileName = getFileName(filePart);

            // Xác thực file ảnh
            if (fileName == null || fileName.trim().isEmpty()) {
                session.setAttribute("message", "Vui lòng tải lên hình ảnh mẫu");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            // Kiểm tra định dạng file
            String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            if (!fileExtension.equals("jpg") && !fileExtension.equals("jpeg") && 
                !fileExtension.equals("png") && !fileExtension.equals("gif")) {
                session.setAttribute("message", "Chỉ chấp nhận file hình ảnh có định dạng JPG, JPEG, PNG hoặc GIF");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }
            
            // Kiểm tra kích thước file (đã được giới hạn bởi @MultipartConfig)
            if (filePart.getSize() > 5 * 1024 * 1024) { // 5MB
                session.setAttribute("message", "Kích thước file không được vượt quá 5MB");
                session.setAttribute("messageType", "error");
                response.sendRedirect("CustomOrder.jsp");
                return;
            }

            // Tạo tên file duy nhất để tránh trùng lặp
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

            // Lưu file vào thư mục uploads
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Đường dẫn tương đối để lưu vào database
            String relativePath = "uploads/" + uniqueFileName;

            // Thay thế đoạn code này:
            // Lấy hoặc tạo cartID
            // int cartID = getCartIDByAccountID(account.getAccountID());
            // if (cartID == 0) {
            //     cartID = createNewCart(account.getAccountID());
            // }
            // int customOrderID = addCustomOrderToCart(cartID, relativePath, description, quantity);
            
            // Bằng đoạn code này:
            int customOrderID = addCustomOrderToCart(account.getAccountID(), relativePath, description, quantity);

            if (customOrderID > 0) {
                session.setAttribute("message", "Yêu cầu đặt hàng tùy chỉnh của bạn đã được gửi thành công. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Có lỗi xảy ra khi gửi yêu cầu. Vui lòng thử lại sau!");
                session.setAttribute("messageType", "error");
            }

            response.sendRedirect("CustomOrder.jsp");

        } catch (Exception e) {
            // Kiểm tra nếu là lỗi kích thước file
            if (e instanceof IllegalStateException && e.getMessage() != null && 
                e.getMessage().contains("size")) {
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
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
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
     * @param imagePath Đường dẫn đến hình ảnh mẫu
     * @param description Mô tả chi tiết
     * @param quantity Số lượng
     * @return ID của đơn hàng tùy chỉnh mới được tạo
     */
    private int addCustomOrderToCart(int accountID, String imagePath, String description, int quantity) {
        String sql = "INSERT INTO customordercart (accountID, referenceImage, description, quantity, status) "
                + "VALUES (?, ?, ?, ?, 'pending')";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, accountID);
            ps.setString(2, imagePath);
            ps.setString(3, description);
            ps.setInt(4, quantity);
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