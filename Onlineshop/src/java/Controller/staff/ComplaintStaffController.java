package Controller.staff;

import DAO.ComplaintDAO;
import DAO.OrderDAO;
import DAO.AccountDAO;
import DAO.ProfileDAO;
import Model.Complaint;
import Model.Order;
import Model.Account;
import Model.Profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "ComplaintStaffController", urlPatterns = {"/staff/complaints"})
public class ComplaintStaffController extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private OrderDAO orderDAO;
    private AccountDAO accountDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new ComplaintDAO();
        orderDAO = new OrderDAO();
        accountDAO = new AccountDAO();
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listComplaints(request, response);
                break;
            case "view":
                viewComplaint(request, response);
                break;
            case "respond":
                showRespondForm(request, response);
                break;
            case "search":
                searchComplaints(request, response);
                break;
            default:
                listComplaints(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "respond":
                respondToComplaint(request, response);
                break;
            case "updateStatus":
                updateComplaintStatus(request, response);
                break;
            case "search":
                searchComplaints(request, response);
                break;
            default:
                listComplaints(request, response);
                break;
        }
    }

    private void listComplaints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Xử lý phân trang
        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Xử lý lọc theo trạng thái nếu có
        String status = request.getParameter("status");
        List<Complaint> complaints;
        int totalComplaints;

        if (status != null && !status.isEmpty()) {
            complaints = complaintDAO.getComplaintsByStatus(status, page, pageSize);
            totalComplaints = complaintDAO.countComplaintsByStatus(status);
        } else {
            complaints = complaintDAO.getAllComplaintsWithPaging(page, pageSize);
            totalComplaints = complaintDAO.getTotalComplaints();
        }

        // Tính toán số trang
        int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);

        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
    }
// Trong phương thức viewComplaint của ComplaintStaffController

    private void viewComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int complaintID = Integer.parseInt(request.getParameter("id"));
            Complaint complaint = complaintDAO.getComplaintById(complaintID);

            if (complaint != null) {
                // Lấy thông tin đơn hàng liên quan
                Order order = orderDAO.getOrderById(complaint.getMaHD());
                request.setAttribute("order", order);

                // Lấy thông tin người gửi khiếu nại từ ProfileDAO
                Profile userProfile = profileDAO.getProfileByAccountId(complaint.getAccountID());
                request.setAttribute("userProfile", userProfile);

                request.setAttribute("complaint", complaint);
                request.getRequestDispatcher("/staff/complaint-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy khiếu nại!");
                request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ!");
            request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
        }
    }

// Tương tự, cập nhật phương thức showRespondForm
    private void showRespondForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int complaintID = Integer.parseInt(request.getParameter("id"));
            Complaint complaint = complaintDAO.getComplaintById(complaintID);

            if (complaint != null) {
                // Lấy thông tin đơn hàng liên quan
                Order order = orderDAO.getOrderById(complaint.getMaHD());
                request.setAttribute("order", order);

                // Lấy thông tin người gửi khiếu nại từ ProfileDAO
                Profile userProfile = profileDAO.getProfileByAccountId(complaint.getAccountID());
                request.setAttribute("userProfile", userProfile);

                request.setAttribute("complaint", complaint);
                request.getRequestDispatcher("/staff/complaint-respond.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy khiếu nại!");
                request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ!");
            request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
        }
    }

    private void respondToComplaint(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int complaintID = Integer.parseInt(request.getParameter("id"));
            String responseContent = request.getParameter("responseContent");
            String status = request.getParameter("status");

            // Kiểm tra dữ liệu đầu vào
            if (responseContent == null || responseContent.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Nội dung phản hồi không được để trống");
                showRespondForm(request, response);
                return;
            }

            // Gọi DAO để cập nhật phản hồi
            boolean success = complaintDAO.respondToComplaint(complaintID, responseContent, status);

            if (success) {
                request.setAttribute("successMessage", "Phản hồi khiếu nại thành công");
                response.sendRedirect(request.getContextPath() + "/staff/complaints?action=view&id=" + complaintID);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi phản hồi khiếu nại");
                showRespondForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ");
            request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
        }
    }

    private void updateComplaintStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int complaintID = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            // Kiểm tra dữ liệu đầu vào
            if (status == null || status.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Trạng thái không được để trống");
                viewComplaint(request, response);
                return;
            }

            // Gọi DAO để cập nhật trạng thái
            boolean success = complaintDAO.updateComplaintStatus(complaintID, status);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật trạng thái khiếu nại thành công");
                response.sendRedirect(request.getContextPath() + "/staff/complaints?action=view&id=" + complaintID);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật trạng thái khiếu nại");
                viewComplaint(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ");
            request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
        }
    }

    private void searchComplaints(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            listComplaints(request, response);
            return;
        }

        // Xử lý phân trang
        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Tìm kiếm khiếu nại theo từ khóa
        List<Complaint> complaints = complaintDAO.searchComplaints(keyword, page, pageSize);
        int totalComplaints = complaintDAO.getTotalSearchResults(keyword);

        // Tính toán số trang
        int totalPages = (int) Math.ceil((double) totalComplaints / pageSize);

        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/staff/complaints-list.jsp").forward(request, response);
    }
}
