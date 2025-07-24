package Controller;

import DAO.AccountDAO;
import Model.Account;
import Utility.EmailSender;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerController", urlPatterns = {"/staff/customers"})
public class CustomerController extends HttpServlet {

    // Tạo ExecutorService với 5 thread để xử lý gửi email
    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(5);
    
    @Override
    public void destroy() {
        // Đảm bảo đóng ExecutorService khi servlet bị hủy
        if (emailExecutor != null && !emailExecutor.isShutdown()) {
            emailExecutor.shutdown();
        }
        super.destroy();
    }

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

            case "showAdd":
                // Hiển thị form thêm khách hàng mới
                String successParam = request.getParameter("success");
                if ("true".equals(successParam)) {
                    request.setAttribute("successMessage", "Thêm khách hàng thành công!");
                }
                request.getRequestDispatcher("/staff/customer_add.jsp").forward(request, response);
                break;

            case "add":
                // Xử lý thêm khách hàng mới
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                int role = Integer.parseInt(request.getParameter("role"));

                // Map để lưu lỗi validation
                Map<String, String> fieldErrors = new HashMap<>();
                Map<String, String> formData = new HashMap<>();

                // Lưu dữ liệu form để hiển thị lại khi có lỗi (lấy từ request hiện tại)
                formData.put("username", username != null ? username : "");
                formData.put("email", email != null ? email : "");
                formData.put("phone", phone != null ? phone : "");

                // Validation
                boolean hasErrors = false;

                if (username == null || username.trim().length() < 3) {
                    fieldErrors.put("username", "Tên đăng nhập phải có ít nhất 3 ký tự");
                    hasErrors = true;
                }

                if (password == null || password.trim().length() < 6) {
                    fieldErrors.put("password", "Mật khẩu phải có ít nhất 6 ký tự");
                    hasErrors = true;
                }

                if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$")) {
                    fieldErrors.put("email", "Email phải có định dạng @gmail.com");
                    hasErrors = true;
                }

                if (phone != null && !phone.trim().isEmpty() && !phone.matches("^[0-9]{10,11}$")) {
                    fieldErrors.put("phone", "Số điện thoại phải có 10-11 chữ số");
                    hasErrors = true;
                }

                // Kiểm tra trùng lặp
                if (!hasErrors) {
                    if (accountDAO.checkAccountExist(username.trim()) != null) {
                        fieldErrors.put("username", "Tên đăng nhập đã tồn tại");
                        hasErrors = true;
                    }

                    if (accountDAO.checkEmailExist(email.trim()) != null) {
                        fieldErrors.put("email", "Email đã tồn tại");
                        hasErrors = true;
                    }
                }

                if (hasErrors) {
                    request.setAttribute("fieldErrors", fieldErrors);
                    request.setAttribute("formData", formData);
                    request.setAttribute("errorMessage", "Vui lòng kiểm tra lại thông tin đã nhập");
                    request.getRequestDispatcher("/staff/customer_add.jsp").forward(request, response);
                    return;
                }

                // Trong case "add", sau khi thêm tài khoản thành công:
                // Thêm tài khoản mới
                Account newAccount = new Account(0, username.trim(), password.trim(), role, email.trim(),
                        phone != null ? phone.trim() : null, true);
                boolean success = accountDAO.addAccount(newAccount);

                if (success) {
                    // Gửi email thông báo tài khoản mới
                    final String finalUsername = username.trim();
                    final String finalPassword = password.trim();
                    final String finalEmail = email.trim();
                    
                    // Gửi email bất đồng bộ sử dụng ExecutorService
                    emailExecutor.submit(() -> {
                        try {
                            System.out.println("Đang gửi email thông báo đến khách hàng mới: " + finalEmail);
                            boolean emailSent = EmailSender.sendNewCustomerAccountEmail(
                                finalEmail,
                                finalUsername,
                                finalPassword
                            );
                            
                            if (emailSent) {
                                System.out.println("Email đã được gửi thành công đến khách hàng: " + finalEmail);
                            } else {
                                System.err.println("Không thể gửi email đến khách hàng: " + finalEmail);
                            }
                        } catch (Exception e) {
                            System.err.println("Lỗi khi gửi email đến khách hàng: " + e.getMessage());
                            e.printStackTrace();
                        }
                    });
                    
                    // Redirect về trang danh sách khách hàng với thông báo thành công
                    request.getSession().setAttribute("successMessage", "Thêm khách hàng thành công!");
                    response.sendRedirect(request.getContextPath() + "/staff/customers");
                } else {
                    request.setAttribute("errorMessage", "Thêm khách hàng thất bại! Vui lòng thử lại.");
                    request.setAttribute("formData", formData);
                    request.getRequestDispatcher("/staff/customer_add.jsp").forward(request, response);
                }
                break;

            case "edit":
                // Hiển thị form chỉnh sửa khách hàng
                int editId = Integer.parseInt(request.getParameter("id"));
                Account editUser = accountDAO.getAccountById(editId);

                if (editUser == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy khách hàng");
                    response.sendRedirect("customers");
                    return;
                }

                // Kiểm tra thông báo thành công
                String successParam1 = request.getParameter("success");
                if ("true".equals(successParam1)) {
                    request.setAttribute("successMessage", "Cập nhật thông tin khách hàng thành công!");
                }

                request.setAttribute("editUser", editUser);
                request.getRequestDispatcher("/staff/customer_edit.jsp").forward(request, response);
                break;

            case "update":
                // Xử lý cập nhật thông tin khách hàng
                int id = Integer.parseInt(request.getParameter("id"));
                String updatedUsername = request.getParameter("username");
                String updatedEmail = request.getParameter("email");
                String updatedPhone = request.getParameter("phone");
                int updatedRole = Integer.parseInt(request.getParameter("role"));

                Account accountToUpdate = accountDAO.getAccountById(id);

                if (accountToUpdate == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy khách hàng");
                    response.sendRedirect("customers");
                    return;
                }

                // Map để lưu lỗi validation
                Map<String, String> updateFieldErrors = new HashMap<>();
                Map<String, String> updateFormData = new HashMap<>();
                boolean hasUpdateErrors = false;

                // Lưu dữ liệu form để hiển thị lại khi có lỗi
                updateFormData.put("username", updatedUsername != null ? updatedUsername : "");
                updateFormData.put("email", updatedEmail != null ? updatedEmail : "");
                updateFormData.put("phone", updatedPhone != null ? updatedPhone : "");

                // Validation
                if (updatedUsername == null || updatedUsername.trim().length() < 3) {
                    updateFieldErrors.put("username", "Tên đăng nhập phải có ít nhất 3 ký tự");
                    hasUpdateErrors = true;
                }

                if (updatedEmail == null || !updatedEmail.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$")) {
                    updateFieldErrors.put("email", "Email phải có định dạng @gmail.com");
                    hasUpdateErrors = true;
                }

                if (updatedPhone != null && !updatedPhone.trim().isEmpty() && !updatedPhone.matches("^[0-9]{10,11}$")) {
                    updateFieldErrors.put("phone", "Số điện thoại phải có 10-11 chữ số");
                    hasUpdateErrors = true;
                }

                // Kiểm tra trùng lặp (trừ chính tài khoản đang sửa)
                if (!hasUpdateErrors) {
                    Account existingUsername = accountDAO.checkAccountExist(updatedUsername.trim());
                    if (existingUsername != null && existingUsername.getAccountID() != id) {
                        updateFieldErrors.put("username", "Tên đăng nhập đã tồn tại");
                        hasUpdateErrors = true;
                    }

                    Account existingEmail = accountDAO.checkEmailExist(updatedEmail.trim());
                    if (existingEmail != null && existingEmail.getAccountID() != id) {
                        updateFieldErrors.put("email", "Email đã tồn tại");
                        hasUpdateErrors = true;
                    }
                }

                if (hasUpdateErrors) {
                    // Tạo một object Account tạm để hiển thị dữ liệu user đã nhập
                    Account tempAccount = new Account();
                    tempAccount.setAccountID(id);
                    tempAccount.setUsername(updatedUsername);
                    tempAccount.setEmail(updatedEmail);
                    tempAccount.setPhone(updatedPhone);
                    tempAccount.setRole(updatedRole);
                    tempAccount.setIsActive(accountToUpdate.isIsActive()); // Giữ nguyên trạng thái

                    request.setAttribute("fieldErrors", updateFieldErrors);
                    request.setAttribute("formData", updateFormData);
                    request.setAttribute("errorMessage", "Vui lòng kiểm tra lại thông tin đã nhập");
                    request.setAttribute("editUser", tempAccount);
                    request.getRequestDispatcher("/staff/customer_edit.jsp").forward(request, response);
                    return;
                }

                // Cập nhật thông tin
                accountToUpdate.setUsername(updatedUsername.trim());
                accountToUpdate.setEmail(updatedEmail.trim());
                accountToUpdate.setPhone(updatedPhone != null ? updatedPhone.trim() : null);
                accountToUpdate.setRole(updatedRole);

                boolean updateSuccess = accountDAO.updateAccount(accountToUpdate);

                if (updateSuccess) {
                    // Redirect để tránh resubmit
                    response.sendRedirect(request.getContextPath() + "/staff/customers?action=edit&id=" + id + "&success=true");
                } else {
                    request.setAttribute("errorMessage", "Cập nhật thông tin khách hàng thất bại!");
                    request.setAttribute("formData", updateFormData);
                    request.setAttribute("editUser", accountToUpdate);
                    request.getRequestDispatcher("/staff/customer_edit.jsp").forward(request, response);
                }
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
