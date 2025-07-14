package Controller;

import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerController", urlPatterns = {"/staff/customers"})
public class CustomerController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        AccountDAO accountDAO = new AccountDAO();

        switch (action) {
            case "list":
                // Lấy tham số trang từ request
                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                        if (page < 1) {
                            page = 1;
                        }
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }

                // Số lượng user mỗi trang
                int pageSize = 5;

                // Lấy tổng số khách hàng
                int totalCustomers = accountDAO.countCustomers();

                // Tính tổng số trang
                int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

                // Đảm bảo trang hiện tại không vượt quá tổng số trang
                if (page > totalPages && totalPages > 0) {
                    page = totalPages;
                }

                // Lấy danh sách khách hàng theo trang
                List<Account> pagedUsers = accountDAO.getUsersWithPaging(page, pageSize);

                // Đặt các thuộc tính vào request
                request.setAttribute("users", pagedUsers);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("pageSize", pageSize);

                request.getRequestDispatcher("/staff/customers.jsp").forward(request, response);
                break;

            case "view":
                int viewId = Integer.parseInt(request.getParameter("id"));
                Account viewUser = accountDAO.getAccountById(viewId);
                request.setAttribute("viewUser", viewUser);
                request.getRequestDispatcher("/staff/customers.jsp").forward(request, response);
                break;

            case "add":
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                int role = Integer.parseInt(request.getParameter("role")); // Thêm role

                // Kiểm tra xem username, email hoặc phone đã tồn tại chưa
                if (accountDAO.checkAccountExist(username) != null) {
                    request.getSession().setAttribute("error", "Username đã tồn tại!");
                    response.sendRedirect("customers");
                    return;
                }

                if (accountDAO.checkEmailExist(email) != null) {
                    request.getSession().setAttribute("error", "Email đã tồn tại!");
                    response.sendRedirect("customers");
                    return;
                }

                Account newAccount = new Account(0, username, password, role, email, phone, true);
                boolean success = accountDAO.addAccount(newAccount);

                if (success) {
                    request.getSession().setAttribute("message", "Thêm người dùng thành công!");
                } else {
                    request.getSession().setAttribute("error", "Thêm người dùng thất bại!");
                }

                response.sendRedirect("customers");
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Account editUser = accountDAO.getAccountById(editId);
                request.setAttribute("editUser", editUser);
                request.getRequestDispatcher("/staff/customers.jsp").forward(request, response);
                break;

            case "update":
                int id = Integer.parseInt(request.getParameter("id"));
                String updatedUsername = request.getParameter("username");
                String updatedEmail = request.getParameter("email");
                String updatedPhone = request.getParameter("phone");
                int updatedRole = Integer.parseInt(request.getParameter("role")); // Thêm role

                Account accountToUpdate = accountDAO.getAccountById(id);

                if (accountToUpdate != null) {
                    accountToUpdate.setUsername(updatedUsername);
                    accountToUpdate.setEmail(updatedEmail);
                    accountToUpdate.setPhone(updatedPhone);
                    accountToUpdate.setRole(updatedRole); // Cập nhật role

                    boolean updateSuccess = accountDAO.updateAccount(accountToUpdate);

                    if (updateSuccess) {
                        request.getSession().setAttribute("message", "Cập nhật người dùng thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Cập nhật người dùng thất bại!");
                    }
                }

                response.sendRedirect("customers");
                break;

            case "toggle":
                int accountId = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                boolean toggleSuccess = accountDAO.toggleAccountStatus(accountId, !status);

                if (toggleSuccess) {
                    request.getSession().setAttribute("message", "Thay đổi trạng thái thành công!");
                } else {
                    request.getSession().setAttribute("error", "Thay đổi trạng thái thất bại!");
                }

                response.sendRedirect("customers");
                break;

            default:
                response.sendRedirect("customers");
                break;
        }
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
}
