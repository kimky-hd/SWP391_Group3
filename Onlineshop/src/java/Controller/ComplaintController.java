package Controller;

import DAO.ComplaintDAO;
import DAO.ComplaintImageDAO;
import DAO.OrderDAO;
import Model.Account;
import Model.Complaint;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "ComplaintController", urlPatterns = {"/complaint"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 50    // 50 MB
)
public class ComplaintController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "img";
    private static final int MAX_IMAGES = 5;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        int accountID = account.getAccountID();
        
        if (action == null) {
            action = "list";
        }
        
        ComplaintDAO complaintDAO = new ComplaintDAO();
        ComplaintImageDAO imageDAO = new ComplaintImageDAO();
        OrderDAO orderDAO = new OrderDAO();
        
        try {
            switch (action) {
                case "showForm":
                    handleShowForm(request, response, complaintDAO, orderDAO, accountID);
                    break;
                    
                case "create":
                    handleCreateComplaint(request, response, complaintDAO, imageDAO, orderDAO, accountID);
                    break;
                    
                case "list":
                    handleListComplaints(request, response, complaintDAO, imageDAO, accountID);
                    break;
                    
                case "detail":
                    handleComplaintDetail(request, response, complaintDAO, imageDAO, accountID);
                    break;
                    
                default:
                    response.sendRedirect("home");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

   private void handleShowForm(HttpServletRequest request, HttpServletResponse response, 
                           ComplaintDAO complaintDAO, OrderDAO orderDAO, int accountID) 
                           throws ServletException, IOException {
    System.out.println("===== THÔNG TIN CASE SHOWFORM =====");
    
    try {
        String maHDParam = request.getParameter("maHD");
        
        if (maHDParam == null || maHDParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Mã đơn hàng không được cung cấp.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        int maHD = Integer.parseInt(maHDParam);
        Order order = orderDAO.getOrderById(maHD);
        
        if (order == null || order.getAccountId() != accountID) {
            request.setAttribute("errorMessage", "Đơn hàng không tồn tại hoặc bạn không có quyền gửi khiếu nại cho đơn hàng này.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        boolean hasComplaint = complaintDAO.hasComplaintForOrder(maHD);
        if (hasComplaint) {
            // SỬA LẠI ĐOẠN NÀY
            Complaint existingComplaint = complaintDAO.getComplaintByOrderIdWithImages(maHD);
            request.setAttribute("complaint", existingComplaint);
            request.setAttribute("message", "Đơn hàng này đã có khiếu nại.");
            request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
            return;
        }
        
        boolean withinPeriod = complaintDAO.isWithinComplaintPeriod(maHD);
        if (!withinPeriod) {
            request.setAttribute("errorMessage", "Đã quá thời hạn gửi khiếu nại cho đơn hàng này.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("order", order);
        request.getRequestDispatcher("create-complaint.jsp").forward(request, response);
        
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
}


    private void handleCreateComplaint(HttpServletRequest request, HttpServletResponse response,
                                     ComplaintDAO complaintDAO, ComplaintImageDAO imageDAO,
                                     OrderDAO orderDAO, int accountID) 
                                     throws ServletException, IOException {
        System.out.println("===== BẮT ĐẦU XỬ LÝ TẠO KHIẾU NẠI =====");
        
        try {
            // Lấy thông tin cơ bản
            String maHDParam = request.getParameter("maHD");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            System.out.println("maHD: " + maHDParam);
            System.out.println("title: " + title);
            System.out.println("content: " + content);
            
            // Validate dữ liệu đầu vào
            if (maHDParam == null || maHDParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Mã đơn hàng không được cung cấp.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ tiêu đề và nội dung khiếu nại.");
                int orderID = Integer.parseInt(maHDParam);
                request.setAttribute("order", orderDAO.getOrderById(orderID));
                request.getRequestDispatcher("create-complaint.jsp").forward(request, response);
                return;
            }
            
            int orderID = Integer.parseInt(maHDParam);
            
            // Xử lý upload ảnh
            List<String> imagePaths = processImageUploads(request);
            System.out.println("Số lượng ảnh được upload thành công: " + imagePaths.size());
            
            if (imagePaths.size() > MAX_IMAGES) {
                request.setAttribute("errorMessage", "Bạn chỉ có thể upload tối đa " + MAX_IMAGES + " ảnh.");
                request.setAttribute("order", orderDAO.getOrderById(orderID));
                request.getRequestDispatcher("create-complaint.jsp").forward(request, response);
                return;
            }
            
            // Tạo đối tượng Complaint
            Complaint complaint = new Complaint();
            complaint.setMaHD(orderID);
            complaint.setAccountID(accountID);
            complaint.setTitle(title.trim());
            complaint.setContent(content.trim());
            complaint.setStatus("Đang xử lý");
            complaint.setDateCreated(new Timestamp(System.currentTimeMillis()));
            
            // Set ảnh chính (ảnh đầu tiên nếu có)
            if (!imagePaths.isEmpty()) {
                complaint.setImage(imagePaths.get(0));
            }
            
            System.out.println("===== THÔNG TIN COMPLAINT =====");
            System.out.println("OrderID: " + complaint.getMaHD());
            System.out.println("AccountID: " + complaint.getAccountID());
            System.out.println("Title: " + complaint.getTitle());
            System.out.println("Main Image: " + complaint.getImage());
            System.out.println("Total Images: " + imagePaths.size());
            
            // Tạo khiếu nại trong database
            int complaintID = complaintDAO.createComplaintWithValidation(complaint);
            System.out.println("Kết quả tạo complaint: " + complaintID);
            
            if (complaintID > 0) {
                // Thêm tất cả ảnh vào bảng ComplaintImages
                if (!imagePaths.isEmpty()) {
                    boolean imageResult = imageDAO.addImages(complaintID, imagePaths);
                    if (imageResult) {
                        System.out.println("Đã thêm thành công " + imagePaths.size() + " ảnh vào database");
                    } else {
                        System.out.println("Warning: Có lỗi khi thêm ảnh vào database");
                    }
                }
                
                System.out.println("Tạo khiếu nại thành công với ID: " + complaintID);
                request.setAttribute("successMessage", "Gửi khiếu nại thành công! Chúng tôi sẽ xem xét và phản hồi trong thời gian sớm nhất.");
                
                // Lấy khiếu nại với đầy đủ thông tin để hiển thị
                Complaint createdComplaint = complaintDAO.getComplaintWithImages(complaintID);
                request.setAttribute("complaint", createdComplaint);
                request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
                
            } else {
                handleCreateComplaintError(request, response, complaintID);
            }
            
        } catch (NumberFormatException e) {
            System.out.println("LỖI NumberFormatException: " + e.getMessage());
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("LỖI Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý upload nhiều ảnh từ form
     */
    /**
 * Xử lý upload nhiều ảnh từ form - PHIÊN BẢN ĐỠN GIẢN
 */
/**
 * Xử lý upload nhiều ảnh từ form - PHIÊN BẢN ĐỠN GIẢN GIỮ TÊN GỐC
 */
private List<String> processImageUploads(HttpServletRequest request) throws ServletException, IOException {
    List<String> imagePaths = new ArrayList<>();
    
    try {
        Collection<Part> allParts = request.getParts();
        
        // Tạo thư mục img nếu chưa tồn tại
        String uploadDir = getServletContext().getRealPath("/img");
        File folder = new File(uploadDir);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        
        // Lọc ra các part chứa ảnh
        for (Part imagePart : allParts) {
            if ("complaintImages".equals(imagePart.getName()) && 
                imagePart.getSize() > 0 && 
                imagePart.getContentType() != null && 
                imagePart.getContentType().startsWith("image/")) {
                
                // Lấy tên file gốc
                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                
                // Lưu file với tên gốc
                File file = new File(uploadDir, originalFileName);
                imagePart.write(file.getAbsolutePath());
                
                // Thêm đường dẫn với prefix "img/"
                String imagePathWithPrefix = "img/" + originalFileName;
                imagePaths.add(imagePathWithPrefix);
                
                System.out.println("Đã lưu ảnh: " + originalFileName + " -> " + imagePathWithPrefix);
            }
        }
        
    } catch (Exception e) {
        System.out.println("Lỗi khi upload ảnh: " + e.getMessage());
        e.printStackTrace();
    }
    
    return imagePaths;
}

    
    /**
     * Xử lý lỗi khi tạo complaint
     */
    private void handleCreateComplaintError(HttpServletRequest request, HttpServletResponse response, int errorCode) 
            throws ServletException, IOException {
        String errorMessage;
        switch (errorCode) {
            case -2:
                errorMessage = "Bạn không có quyền gửi khiếu nại cho đơn hàng này hoặc đơn hàng đã có khiếu nại.";
                break;
            case -3:
                errorMessage = "Đã quá thời hạn gửi khiếu nại cho đơn hàng này.";
                break;
            default:
                errorMessage = "Có lỗi xảy ra khi gửi khiếu nại. Vui lòng thử lại sau.";
                break;
        }
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }

    private void handleListComplaints(HttpServletRequest request, HttpServletResponse response,
                                    ComplaintDAO complaintDAO, ComplaintImageDAO imageDAO, int accountID) 
                                    throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        List<Complaint> userComplaints = complaintDAO.getComplaintsByAccountId(accountID, page, pageSize);
        
        // Thêm ảnh đầu tiên cho mỗi khiếu nại
        for (Complaint complaint : userComplaints) {
            if (complaint.getImage() == null || complaint.getImage().isEmpty()) {
                String firstImage = imageDAO.getFirstImageByComplaintId(complaint.getComplaintID());
                complaint.setImage(firstImage);
            }
        }
        
        int totalComplaints = complaintDAO.getTotalComplaintsByAccountId(accountID);
        int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);
        
        request.setAttribute("complaintList", userComplaints);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("user-complaints.jsp").forward(request, response);
    }

    private void handleComplaintDetail(HttpServletRequest request, HttpServletResponse response,
                             ComplaintDAO complaintDAO, ComplaintImageDAO imageDAO, int accountID) 
                             throws ServletException, IOException {
    try {
        int complaintID = Integer.parseInt(request.getParameter("id"));
        
        System.out.println("=== COMPLAINT DETAIL REQUEST ===");
        System.out.println("Complaint ID: " + complaintID);
        System.out.println("Account ID: " + accountID);
        
        // Chỉ cần gọi getComplaintById vì nó đã load images
        Complaint complaint = complaintDAO.getComplaintById(complaintID);
        
        if (complaint == null) {
            System.out.println("❌ Complaint not found!");
            request.setAttribute("errorMessage", "Khiếu nại không tồn tại.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Complaint loaded: " + complaint.getTitle());
        System.out.println("📷 Images in complaint: " + 
            (complaint.getImages() != null ? complaint.getImages().size() : "NULL"));
        
        if (complaint.getAccountID() != accountID) {
            System.out.println("❌ Access denied!");
            request.setAttribute("errorMessage", "Bạn không có quyền xem khiếu nại này.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("complaint", complaint);
        request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
        
    } catch (NumberFormatException e) {
        System.out.println("❌ Invalid complaint ID format");
        request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ.");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
}



    /**
     * Lấy tên file từ Part header
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            String[] items = contentDisp.split(";");
            for (String s : items) {
                if (s.trim().startsWith("filename")) {
                    String fileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                    return fileName.replace("\"", ""); // Remove quotes
                }
            }
        }
        return "";
    }
    
    /**
     * Lấy phần mở rộng của file
     */
    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.lastIndexOf('.') > 0) {
            return fileName.substring(fileName.lastIndexOf('.'));
        }
        return "";
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

    @Override
    public String getServletInfo() {
        return "Complaint Controller";
    }
}
