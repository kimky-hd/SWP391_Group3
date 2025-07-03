package Controller;

import DAO.CustomOrderCartDAO;
import Model.Account;
import Model.CustomOrderCart;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.List;
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
 * Servlet xử lý các yêu cầu liên quan đến giỏ hàng đặt hàng tùy chỉnh.
 */
@WebServlet(name = "CustomCartController", urlPatterns = {"/custom-cart"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5)
public class CustomCartController extends HttpServlet {

    private CustomOrderCartDAO customOrderCartDAO;
    
    @Override
    public void init() {
        customOrderCartDAO = new CustomOrderCartDAO();
        
        // Tạo thư mục uploads nếu chưa tồn tại
        String uploadPath = getServletContext().getRealPath("/uploads/");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    /**
     * Xử lý các yêu cầu GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Nếu action là "get", trả về thông tin chi tiết của một đơn hàng tùy chỉnh dưới dạng JSON
        if ("get".equals(action)) {
            int customCartId = Integer.parseInt(request.getParameter("customCartId"));
            CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            JsonObject jsonResponse = new JsonObject();
            
            if (customOrderCart != null && customOrderCart.getAccountID() == account.getAccountID()) {
                jsonResponse.addProperty("success", true);
                jsonResponse.add("customOrder", new Gson().toJsonTree(customOrderCart));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập.");
            }
            
            try (PrintWriter out = response.getWriter()) {
                out.print(jsonResponse.toString());
            }
            return;
        }
        
        // Mặc định: Hiển thị danh sách đơn hàng tùy chỉnh của người dùng
        List<CustomOrderCart> customOrderCarts = customOrderCartDAO.getCustomOrderCartsByAccountId(account.getAccountID());
        System.out.println("AccountID: " + account.getAccountID());
        System.out.println("Số lượng đơn hàng tùy chỉnh: " + (customOrderCarts != null ? customOrderCarts.size() : "null"));
        request.setAttribute("customOrderCarts", customOrderCarts);
        request.getRequestDispatcher("CustomCart.jsp").forward(request, response);
    }

    /**
     * Xử lý các yêu cầu POST.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Xử lý các hành động khác nhau
        switch (action) {
            case "update":
                updateCustomOrderCart(request, response, account);
                break;
            case "delete":
                deleteCustomOrderCart(request, response, account);
                break;
            default:
                response.sendRedirect("custom-cart");
                break;
        }
    }
    
    /**
     * Cập nhật thông tin đơn hàng tùy chỉnh.
     */
    private void updateCustomOrderCart(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        int customCartId = Integer.parseInt(request.getParameter("customCartId"));
        String description = request.getParameter("description");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // Kiểm tra xem đơn hàng có tồn tại và thuộc về người dùng hiện tại không
        CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        if (customOrderCart == null || customOrderCart.getAccountID() != account.getAccountID()) {
            sendJsonResponse(response, false, "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập.");
            return;
        }
        
        // Cập nhật thông tin
        customOrderCart.setDescription(description);
        customOrderCart.setQuantity(quantity);
        
        // Xử lý tải lên hình ảnh mới (nếu có)
        Part filePart = request.getPart("imageUpload");
        if (filePart != null && filePart.getSize() > 0) {
            // Kiểm tra kích thước và định dạng file
            if (filePart.getSize() > 5 * 1024 * 1024) { // 5MB
                sendJsonResponse(response, false, "Kích thước file quá lớn. Vui lòng chọn file nhỏ hơn 5MB.");
                return;
            }
            
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            
            if (!fileExtension.equals(".jpg") && !fileExtension.equals(".jpeg") && 
                !fileExtension.equals(".png") && !fileExtension.equals(".gif")) {
                sendJsonResponse(response, false, "Chỉ chấp nhận file hình ảnh (JPG, JPEG, PNG, GIF).");
                return;
            }
            
            // Tạo tên file duy nhất
            String uniqueFileName = UUID.randomUUID().toString() + "_" + UUID.randomUUID().toString() + fileExtension;
            String uploadPath = getServletContext().getRealPath("/uploads/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Lưu file
            filePart.write(uploadPath + File.separator + uniqueFileName);
            
            // Cập nhật đường dẫn hình ảnh
            // Thay đổi từ
            customOrderCart.setReferenceImage("uploads/" + uniqueFileName);
            
            // Thành
            customOrderCart.setReferenceImage("img/uploads/" + uniqueFileName);
        }
        
        // Lưu thay đổi vào cơ sở dữ liệu
        boolean success = customOrderCartDAO.updateCustomOrderCart(customOrderCart);
        
        if (success) {
            response.sendRedirect("custom-cart");
        } else {
            sendJsonResponse(response, false, "Không thể cập nhật đơn hàng. Vui lòng thử lại sau.");
        }
    }
    
    /**
     * Xóa đơn hàng tùy chỉnh.
     */
    private void deleteCustomOrderCart(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        int customCartId = Integer.parseInt(request.getParameter("customCartId"));
        
        // Kiểm tra xem đơn hàng có tồn tại và thuộc về người dùng hiện tại không
        CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        if (customOrderCart == null || customOrderCart.getAccountID() != account.getAccountID()) {
            sendJsonResponse(response, false, "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập.");
            return;
        }
        
        // Xóa đơn hàng
        boolean success = customOrderCartDAO.deleteCustomOrderCart(customCartId);
        
        sendJsonResponse(response, success, success ? "Đã xóa đơn hàng thành công." : "Không thể xóa đơn hàng. Vui lòng thử lại sau.");
    }
    
    /**
     * Gửi phản hồi JSON.
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse.toString());
        }
    }
}