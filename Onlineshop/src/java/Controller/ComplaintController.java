package Controller;

import DAO.ComplaintDAO;
import DAO.OrderDAO; // Giả sử có OrderDAO để lấy thông tin đơn hàng
import Model.Account;
import Model.Complaint;
import Model.Order; // Giả sử có model Order
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
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "ComplaintController", urlPatterns = {"/complaint"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ComplaintController extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "img";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Kiểm tra người dùng đã đăng nhập chưa
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Lấy accountID từ đối tượng account thay vì trực tiếp từ session
        int accountID = account.getAccountID();
        
        if (action == null) {
            action = "list"; // Mặc định hiển thị danh sách khiếu nại
        }
        
        ComplaintDAO complaintDAO = new ComplaintDAO();
        OrderDAO orderDAO = new OrderDAO();
        
        try {
            switch (action) {
                case "showForm":
                    // Hiển thị form gửi khiếu nại
                    System.out.println("===== THÔNG TIN CASE SHOWFORM =====");
                    System.out.println("Request parameter maHD: " + request.getParameter("maHD"));
                    
                    try {
                        String maHDParam = request.getParameter("maHD");
                        System.out.println("Giá trị maHD trước khi parse: " + maHDParam);
                        
                        if (maHDParam == null || maHDParam.trim().isEmpty()) {
                            System.out.println("LỖI: maHD là null hoặc rỗng!");
                            request.setAttribute("errorMessage", "Mã đơn hàng không được cung cấp.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                        
                        int maHD = Integer.parseInt(maHDParam);
                        System.out.println("maHD sau khi parse: " + maHD);
                        
                        System.out.println("Gọi orderDAO.getOrderById(" + maHD + ")");
                        Order order = orderDAO.getOrderById(maHD);
                        
                        if (order == null) {
                            System.out.println("LỖI: Order không tồn tại với maHD = " + maHD);
                            request.setAttribute("errorMessage", "Đơn hàng không tồn tại.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                        
                        System.out.println("Thông tin order:");
                        System.out.println("Order ID: " + order.getOrderId());
                        System.out.println("Account ID của order: " + order.getAccountId());
                        System.out.println("Account ID hiện tại: " + accountID);
                        
                        if (order.getAccountId() != accountID) {
                            // Đơn hàng không thuộc về người dùng này
                            System.out.println("LỖI: Order không thuộc về người dùng hiện tại");
                            request.setAttribute("errorMessage", "Đơn hàng không tồn tại hoặc bạn không có quyền gửi khiếu nại cho đơn hàng này.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                        
                        // Kiểm tra xem đơn hàng đã có khiếu nại chưa
                        System.out.println("Kiểm tra đơn hàng đã có khiếu nại chưa");
                        boolean hasComplaint = complaintDAO.hasComplaintForOrder(maHD);
                        System.out.println("Đơn hàng đã có khiếu nại: " + hasComplaint);
                        
                        if (hasComplaint) {
                            System.out.println("Đơn hàng đã có khiếu nại, lấy thông tin khiếu nại hiện có");
                            Complaint existingComplaint = complaintDAO.getComplaintByOrderId(maHD);
                            System.out.println("Thông tin khiếu nại hiện có:");
                            System.out.println("Complaint ID: " + existingComplaint.getComplaintID());
                            System.out.println("Title: " + existingComplaint.getTitle());
                            System.out.println("Status: " + existingComplaint.getStatus());
                            System.out.println("Image: " + existingComplaint.getImage());
                            
                            request.setAttribute("complaint", existingComplaint);
                            request.setAttribute("message", "Đơn hàng này đã có khiếu nại. Bạn có thể xem chi tiết khiếu nại dưới đây.");
                            request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
                            return;
                        }
                        
                        // Kiểm tra thời gian cho phép khiếu nại
                        System.out.println("Kiểm tra thời gian cho phép khiếu nại");
                        boolean withinPeriod = complaintDAO.isWithinComplaintPeriod(maHD);
                        System.out.println("Trong thời gian cho phép khiếu nại: " + withinPeriod);
                        
                        if (!withinPeriod) {
                            System.out.println("LỖI: Quá thời hạn gửi khiếu nại");
                            request.setAttribute("errorMessage", "Đã quá thời hạn gửi khiếu nại cho đơn hàng này (7 ngày sau khi giao hàng).");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                        
                        System.out.println("Chuyển đến trang tạo khiếu nại với order: " + order.getOrderId());
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("create-complaint.jsp").forward(request, response);
                    } catch (NumberFormatException e) {
                        System.out.println("LỖI NumberFormatException: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                    } catch (Exception e) {
                        System.out.println("LỖI Exception khác: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                    }
                    break;
                    
                case "create":
                    // Xử lý gửi khiếu nại
                    try {
                        // In ra tất cả các tham số từ request
                        System.out.println("===== THÔNG TIN FORM KHIẾU NẠI =====");
                        System.out.println("maHD parameter: " + request.getParameter("maHD"));
                        System.out.println("title parameter: " + request.getParameter("title"));
                        System.out.println("content parameter: " + request.getParameter("content"));
                        
                        // In ra thông tin session
                        System.out.println("===== THÔNG TIN SESSION =====");
                        System.out.println("Account trong session: " + session.getAttribute("account"));
                        System.out.println("AccountID từ đối tượng account: " + accountID);
                        
                        // Parse maHD và in ra
                        String maHDParam = request.getParameter("maHD");
                        System.out.println("Giá trị maHD trước khi parse: " + maHDParam);
                        
                        if (maHDParam == null || maHDParam.trim().isEmpty()) {
                            System.out.println("LỖI: maHD là null hoặc rỗng!");
                            request.setAttribute("errorMessage", "Mã đơn hàng không được cung cấp.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                            return;
                        }
                        
                        int orderID = Integer.parseInt(maHDParam);
                        System.out.println("orderID sau khi parse: " + orderID);
                        
                        String title = request.getParameter("title");
                        String content = request.getParameter("content");
                        
                        // Kiểm tra dữ liệu đầu vào
                        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                            System.out.println("LỖI: title hoặc content rỗng!");
                            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ tiêu đề và nội dung khiếu nại.");
                            request.setAttribute("order", orderDAO.getOrderById(orderID));
                            request.getRequestDispatcher("create-complaint.jsp").forward(request, response);
                            return;
                        }
                        
                        // Xử lý upload hình ảnh
                        // Xử lý upload hình ảnh
String imagePath = null;
Part filePart = request.getPart("complaintImage"); // Lấy file từ form
if (filePart != null && filePart.getSize() > 0) {
    String fileName = getFileName(filePart);
    if (fileName != null && !fileName.isEmpty()) {
        // Tạo tên file duy nhất để tránh trùng lặp
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        
        // Lấy đường dẫn thực đến thư mục gốc của ứng dụng web
        String applicationPath = request.getServletContext().getRealPath("/");
        
        // Xác định đường dẫn đến thư mục img
        String uploadPath = applicationPath + UPLOAD_DIRECTORY;
        
        // Đảm bảo thư mục tồn tại
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Lưu file
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        
        // Đường dẫn tương đối để lưu vào database và hiển thị
        imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
        System.out.println("Đã tải lên hình ảnh: " + imagePath);
        System.out.println("Đường dẫn đầy đủ: " + filePath);
    }
}
 else {
                            System.out.println("Không có hình ảnh được tải lên");
                        }
                        
                        // Tạo đối tượng Complaint
                        Complaint complaint = new Complaint();
                        complaint.setMaHD(orderID);
                        complaint.setAccountID(accountID);
                        complaint.setTitle(title);
                        complaint.setContent(content);
                        complaint.setImage(imagePath); // Thêm đường dẫn hình ảnh
                        complaint.setStatus("Đang xử lý");
                        complaint.setDateCreated(new Timestamp(System.currentTimeMillis()));
                        
                        // In ra thông tin đối tượng complaint
                        System.out.println("===== THÔNG TIN ĐỐI TƯỢNG COMPLAINT =====");
                        System.out.println("MaHD: " + complaint.getMaHD());
                        System.out.println("AccountID: " + complaint.getAccountID());
                        System.out.println("Title: " + complaint.getTitle());
                        System.out.println("Content: " + complaint.getContent());
                        System.out.println("Image: " + complaint.getImage());
                        System.out.println("Status: " + complaint.getStatus());
                        System.out.println("DateCreated: " + complaint.getDateCreated());
                        
                        // Gọi phương thức tạo khiếu nại với kiểm tra đầy đủ
                        System.out.println("Gọi complaintDAO.createComplaintWithValidation()...");
                        int result = complaintDAO.createComplaintWithValidation(complaint);
                        System.out.println("Kết quả từ createComplaintWithValidation: " + result);
                        
                        if (result > 0) {
                            // Thành công - chuyển đến trang xem chi tiết khiếu nại
                            System.out.println("Tạo khiếu nại thành công với ID: " + result);
                            request.setAttribute("successMessage", "Gửi khiếu nại thành công! Chúng tôi sẽ xem xét và phản hồi trong thời gian sớm nhất.");
                            Complaint createdComplaint = complaintDAO.getComplaintById(result);
                            request.setAttribute("complaint", createdComplaint);
                            request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
                        } else if (result == -2) {
                            System.out.println("Lỗi: Không có quyền hoặc đơn hàng đã có khiếu nại");
                            request.setAttribute("errorMessage", "Bạn không có quyền gửi khiếu nại cho đơn hàng này hoặc đơn hàng đã có khiếu nại.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                        } else if (result == -3) {
                            System.out.println("Lỗi: Quá thời hạn gửi khiếu nại");
                            request.setAttribute("errorMessage", "Đã quá thời hạn gửi khiếu nại cho đơn hàng này.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                        } else {
                            System.out.println("Lỗi không xác định khi tạo khiếu nại, mã lỗi: " + result);
                            request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi khiếu nại. Vui lòng thử lại sau.");
                            request.getRequestDispatcher("error.jsp").forward(request, response);
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("LỖI NumberFormatException: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                    } catch (Exception e) {
                        System.out.println("LỖI Exception khác: " + e.getMessage());
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                    }
                    break;
                    
                case "list":
                    // Hiển thị danh sách khiếu nại của người dùng
                    int page = 1;
                    int pageSize = 10;
                    
                    if (request.getParameter("page") != null) {
                        page = Integer.parseInt(request.getParameter("page"));
                    }
                    
                    List<Complaint> userComplaints = complaintDAO.getComplaintsByAccountId(accountID, page, pageSize);
                    int totalComplaints = complaintDAO.getTotalComplaintsByAccountId(accountID);
                    int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);
                    
                    request.setAttribute("complaintList", userComplaints);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("currentPage", page);
                    request.getRequestDispatcher("user-complaints.jsp").forward(request, response);
                    break;
                    
                case "detail":
                    // Xem chi tiết khiếu nại
                    int complaintID = Integer.parseInt(request.getParameter("id"));
                    Complaint complaint = complaintDAO.getComplaintById(complaintID);
                    
                    if (complaint == null || complaint.getAccountID() != accountID) {
                        request.setAttribute("errorMessage", "Khiếu nại không tồn tại hoặc bạn không có quyền xem khiếu nại này.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                        return;
                    }
                    
                    request.setAttribute("complaint", complaint);
                    request.getRequestDispatcher("view-complaint.jsp").forward(request, response);
                    break;
                    
                default:
                    response.sendRedirect("home");
                    break;
            }
        } catch (Exception e) {
            // Xử lý ngoại lệ tổng quát
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // Phương thức hỗ trợ để lấy tên file từ Part
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
