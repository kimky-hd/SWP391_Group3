package Controller;

import DAO.CustomOrderCartDAO;
import DAO.VoucherDAO;
import Model.Account;
import Model.CustomOrderCart;
import Model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;

/**
 * Servlet CustomCheckOutController xử lý các yêu cầu liên quan đến trang thanh toán (checkout) cho đơn hàng tùy chỉnh.
 * Nó đảm bảo rằng người dùng đã đăng nhập và đơn hàng tùy chỉnh đã được duyệt (statusID = 7) trước khi cho phép họ truy cập trang thanh toán.
 * URL pattern "/custom-checkout" ánh xạ các yêu cầu đến servlet này.
 */
@WebServlet(name = "CustomCheckOutController", urlPatterns = {"/custom-checkout"})
public class CustomCheckOutController extends HttpServlet {

    private final CustomOrderCartDAO customOrderCartDAO = new CustomOrderCartDAO();
    
    /**
     * Phương thức `processRequest` là nơi chứa logic chính để xử lý cả yêu cầu GET và POST.
     * Nó kiểm tra trạng thái đơn hàng tùy chỉnh và trạng thái đăng nhập của người dùng.
     *
     * @param request Đối tượng HttpServletRequest chứa yêu cầu từ client.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi về client.
     * @throws ServletException Nếu có lỗi xảy ra trong quá trình xử lý servlet.
     * @throws IOException Nếu có lỗi I/O xảy ra.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(); // Lấy phiên làm việc hiện tại của người dùng
        
        // Lấy ID của đơn hàng tùy chỉnh từ request
        String customCartIdStr = request.getParameter("customCartId");
        if (customCartIdStr == null || customCartIdStr.trim().isEmpty()) {
            // Nếu không có ID đơn hàng, đặt thông báo lỗi vào session
            session.setAttribute("message", "Không tìm thấy thông tin đơn hàng tùy chỉnh");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng về trang đơn hàng tùy chỉnh
            response.sendRedirect("custom-cart");
            return; // Dừng xử lý
        }
        
        int customCartId;
        try {
            customCartId = Integer.parseInt(customCartIdStr);
        } catch (NumberFormatException e) {
            // Nếu ID không phải là số hợp lệ, đặt thông báo lỗi vào session
            session.setAttribute("message", "ID đơn hàng tùy chỉnh không hợp lệ");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng về trang đơn hàng tùy chỉnh
            response.sendRedirect("custom-cart");
            return; // Dừng xử lý
        }

        // --- Bước 1: Kiểm tra trạng thái đăng nhập ---
        // Lấy thông tin tài khoản người dùng từ session
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            // Nếu người dùng chưa đăng nhập, đặt thông báo lỗi vào session
            session.setAttribute("message", "Vui lòng đăng nhập để tiến hành thanh toán");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng đến trang đăng nhập (login.jsp)
            response.sendRedirect("login.jsp");
            return; // Dừng xử lý
        }

        // --- Bước 2: Lấy thông tin đơn hàng tùy chỉnh ---
        CustomOrderCart customOrderCart = customOrderCartDAO.getCustomOrderCartById(customCartId);
        
        // Kiểm tra xem đơn hàng có tồn tại và thuộc về người dùng hiện tại không
        if (customOrderCart == null || customOrderCart.getAccountID() != account.getAccountID()) {
            // Nếu đơn hàng không tồn tại hoặc không thuộc về người dùng hiện tại, đặt thông báo lỗi vào session
            session.setAttribute("message", "Không tìm thấy thông tin đơn hàng tùy chỉnh hoặc bạn không có quyền truy cập");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng về trang đơn hàng tùy chỉnh
            response.sendRedirect("custom-cart");
            return; // Dừng xử lý
        }
        
        // --- Bước 3: Kiểm tra trạng thái đơn hàng ---
        if (customOrderCart.getStatusID() != 7) { // Giả sử 7 là trạng thái "Đã duyệt"
            // Nếu đơn hàng chưa được duyệt, đặt thông báo lỗi vào session
            session.setAttribute("message", "Đơn hàng tùy chỉnh chưa được duyệt, không thể thanh toán");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng về trang đơn hàng tùy chỉnh
            response.sendRedirect("custom-cart");
            return; // Dừng xử lý
        }

        // --- Bước 4: Truyền dữ liệu và chuyển hướng ---
        // Nếu đơn hàng hợp lệ và người dùng đã đăng nhập,
        // truyền đối tượng đơn hàng tùy chỉnh vào request để trang CustomCheckOut.jsp có thể truy cập
        request.setAttribute("customOrderCart", customOrderCart);
        
        // Lấy danh sách voucher hợp lệ cho người dùng
        VoucherDAO vdao = new VoucherDAO();
        List<Voucher> vouchers = vdao.getValidVouchersByAccountId(account.getAccountID(), customOrderCart.getDesiredPrice());
        request.setAttribute("vouchers", vouchers);

        // Chuyển tiếp yêu cầu đến trang CustomCheckOut.jsp để hiển thị giao diện thanh toán
        request.getRequestDispatcher("CustomCheckOut.jsp").forward(request, response);
    }

    /**
     * Xử lý các yêu cầu HTTP GET.
     * Phương thức này đơn giản gọi `processRequest` để xử lý logic chung.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Xử lý các yêu cầu HTTP POST.
     * Phương thức này cũng gọi `processRequest` để xử lý logic chung,
     * vì trong trường hợp này, cả GET và POST đều dẫn đến việc hiển thị trang thanh toán
     * sau khi kiểm tra đơn hàng tùy chỉnh và đăng nhập.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /**
     * Gửi phản hồi dạng JSON về client.
     * Hàm này thiết lập Content-Type là "application/json" và sử dụng thư viện Gson
     * để chuyển đổi Map dữ liệu thành chuỗi JSON và ghi vào output stream của response.
     *
     * @param response Đối tượng HttpServletResponse để gửi phản hồi.
     * @param data Dữ liệu cần gửi, dưới dạng một Map<String, Object>.
     * @throws IOException Nếu có lỗi I/O khi ghi dữ liệu.
     */
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json"); // Đặt Content-Type là JSON
        response.setCharacterEncoding("UTF-8"); // Đặt mã hóa ký tự là UTF-8
        // Chuyển đổi Map data thành chuỗi JSON và ghi vào response
        response.getWriter().write(new Gson().toJson(data));
    }

    /**
     * Tạo một đối tượng Map đại diện cho phản hồi thành công.
     * Hàm này hữu ích khi muốn gửi các thông báo thành công về client dưới dạng JSON,
     * đặc biệt trong các cuộc gọi AJAX.
     *
     * @param message Thông báo thành công muốn gửi.
     * @return Một Map chứa khóa "success" là true và "message" là thông báo thành công.
     */
    private Map<String, Object> createSuccessResponse(String message) {
        Map<String, Object> response = new HashMap<>(); // Tạo một HashMap mới
        response.put("success", true); // Đặt trạng thái thành công
        response.put("message", message); // Đặt thông báo
        return response; // Trả về Map
    }

    /**
     * Tạo một đối tượng Map đại diện cho phản hồi lỗi.
     * Hàm này tương tự như `createSuccessResponse` nhưng dùng để báo lỗi,
     * cũng rất hữu ích cho các phản hồi JSON trong AJAX.
     *
     * @param message Thông báo lỗi muốn gửi.
     * @return Một Map chứa khóa "success" là false và "message" là thông báo lỗi.
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>(); // Tạo một HashMap mới
        response.put("success", false); // Đặt trạng thái thất bại
        response.put("message", message); // Đặt thông báo lỗi
        return response; // Trả về Map
    }
}