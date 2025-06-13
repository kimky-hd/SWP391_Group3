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

@WebServlet(name = "CustomerController", urlPatterns = {"/customers"})
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
                // Phân trang
                int page = 1;
                int pageSize = 10;
                
                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                }
                
                List<Account> customers = accountDAO.getCustomersWithPaging(page, pageSize);
                int totalCustomers = accountDAO.getTotalCustomers();
                int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
                
                request.setAttribute("customers", customers);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
                break;
                
            case "view":
                int viewId = Integer.parseInt(request.getParameter("id"));
                Account viewCustomer = accountDAO.getAccountById(viewId);
                request.setAttribute("viewCustomer", viewCustomer);
                request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
                break;
                
            case "add":
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                
                // Kiểm tra xem username, email hoặc phone đã tồn tại chưa
                if (accountDAO.checkAccountExist(username) != null) {
                    request.setAttribute("error", "Username đã tồn tại!");
                    request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
                    return;
                }
                
                if (accountDAO.checkEmailExist(email) != null) {
                    request.setAttribute("error", "Email đã tồn tại!");
                    request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
                    return;
                }
                
                Account newAccount = new Account(0, username, password, 0, email, phone, true);
                boolean success = accountDAO.addAccount(newAccount);
                
                if (success) {
                    request.setAttribute("message", "Thêm khách hàng thành công!");
                } else {
                    request.setAttribute("error", "Thêm khách hàng thất bại!");
                }
                
                response.sendRedirect("customers");
                break;
                
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Account editCustomer = accountDAO.getAccountById(editId);
                request.setAttribute("editCustomer", editCustomer);
                request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
                break;
                
            case "update":
                int id = Integer.parseInt(request.getParameter("id"));
                String updatedUsername = request.getParameter("username");
                String updatedEmail = request.getParameter("email");
                String updatedPhone = request.getParameter("phone");
                
                Account accountToUpdate = accountDAO.getAccountById(id);
                
                if (accountToUpdate != null) {
                    accountToUpdate.setUsername(updatedUsername);
                    accountToUpdate.setEmail(updatedEmail);
                    accountToUpdate.setPhone(updatedPhone);
                    
                    boolean updateSuccess = accountDAO.updateAccount(accountToUpdate);
                    
                    if (updateSuccess) {
                        request.setAttribute("message", "Cập nhật khách hàng thành công!");
                    } else {
                        request.setAttribute("error", "Cập nhật khách hàng thất bại!");
                    }
                }
                
                response.sendRedirect("customers");
                break;
                
            case "toggle":
                int accountId = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                
                boolean toggleSuccess = accountDAO.toggleAccountStatus(accountId, !status);
                
                if (toggleSuccess) {
                    request.setAttribute("message", "Thay đổi trạng thái thành công!");
                } else {
                    request.setAttribute("error", "Thay đổi trạng thái thất bại!");
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
