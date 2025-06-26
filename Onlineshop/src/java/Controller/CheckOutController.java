package Controller;

import DAO.VoucherDAO;
import Model.Account;
import Model.Cart;
import Model.Voucher;
import com.google.gson.Gson; // Thư viện để chuyển đổi đối tượng Java sang JSON và ngược lại
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

/**
 * Servlet CheckOutController xử lý các yêu cầu liên quan đến trang thanh toán (checkout).
 * Nó đảm bảo rằng người dùng đã đăng nhập và giỏ hàng không trống trước khi cho phép họ truy cập trang thanh toán.
 * URL pattern "/checkout" ánh xạ các yêu cầu đến servlet này.
 */
@WebServlet(name = "CheckOutController", urlPatterns = { "/checkout" })
public class CheckOutController extends HttpServlet {

    /**
     * Phương thức `processRequest` là nơi chứa logic chính để xử lý cả yêu cầu GET và POST.
     * Nó kiểm tra trạng thái giỏ hàng và trạng thái đăng nhập của người dùng.
     *
     * @param request Đối tượng HttpServletRequest chứa yêu cầu từ client.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi về client.
     * @throws ServletException Nếu có lỗi xảy ra trong quá trình xử lý servlet.
     * @throws IOException Nếu có lỗi I/O xảy ra.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(); // Lấy phiên làm việc hiện tại của người dùng
        Cart cart = (Cart) session.getAttribute("cart"); // Lấy đối tượng giỏ hàng từ session

        // --- Bước 1: Kiểm tra giỏ hàng ---
        // Kiểm tra xem giỏ hàng có tồn tại (không null) và có sản phẩm nào bên trong không.
        if (cart == null || cart.isEmpty()) {
            // Nếu giỏ hàng trống, đặt thông báo lỗi vào session
            session.setAttribute("message", "Giỏ hàng trống, vui lòng thêm sản phẩm trước khi thanh toán");
            session.setAttribute("messageType", "error");
            // Chuyển hướng người dùng về trang giỏ hàng (Cart.jsp)
            response.sendRedirect("Cart.jsp");
            return; // Dừng xử lý
        }

        // --- Bước 2: Kiểm tra trạng thái đăng nhập ---
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

        // --- Bước 3: Truyền dữ liệu và chuyển hướng ---
        // Nếu giỏ hàng hợp lệ và người dùng đã đăng nhập,
        // truyền đối tượng giỏ hàng vào request để trang CheckOut.jsp có thể truy cập
        request.setAttribute("cart", cart);
        
        //get all valid voucher
        VoucherDAO vdao = new VoucherDAO();
        List<Voucher> vouchers = vdao.getValidVouchersByAccountId(account.getAccountID(), cart.getTotal());
        request.setAttribute("vouchers", vouchers);

        // Chuyển tiếp yêu cầu đến trang CheckOut.jsp để hiển thị giao diện thanh toán
        request.getRequestDispatcher("CheckOut.jsp").forward(request, response);
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
     * sau khi kiểm tra giỏ hàng và đăng nhập.
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