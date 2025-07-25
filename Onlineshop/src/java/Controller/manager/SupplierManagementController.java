package Controller.manager;

import DAO.SupplierDAO;
import Model.Supplier;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SupplierManagementController", urlPatterns = {"/manager/supplier"})
public class SupplierManagementController extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        SupplierDAO supplierDAO = new SupplierDAO();

        switch (action) {
            case "list":
                handleListSuppliers(request, response, supplierDAO);
                break;
                
            case "showAdd":
                // Hiển thị trang thêm mới
                request.getRequestDispatcher("/manager/supplier_add.jsp").forward(request, response);
                break;
                
            case "view":
                handleViewSupplier(request, response, supplierDAO);
                return; // Không chuyển hướng sau khi xử lý JSON
                
            case "edit":
                handleEditSupplier(request, response, supplierDAO);
                return; // Không chuyển hướng sau khi xử lý JSON
                
            case "add":
                handleAddSupplier(request, response, supplierDAO);
                break; // Chuyển hướng sau khi xử lý
                
            case "update":
                handleUpdateSupplier(request, response, supplierDAO);
                return; // Không chuyển hướng để xử lý Ajax
                
            case "toggle":
                handleToggleStatus(request, response, supplierDAO);
                return; // Không chuyển hướng để xử lý Ajax
                
            case "search":
                handleSearchSuppliers(request, response, supplierDAO);
                break;
                
            default:
                response.sendRedirect("supplier?action=list");
                break;
        }
    }
    
    private void handleListSuppliers(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        System.out.println("=== LISTING SUPPLIERS ===");
        
        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Supplier> suppliers = supplierDAO.getAllSuppliersWithPaging(page, pageSize);
        int totalSuppliers = supplierDAO.getTotalSuppliers();
        int totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);

        System.out.println("Total suppliers: " + totalSuppliers);
        System.out.println("Current page: " + page);
        System.out.println("Total pages: " + totalPages);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/manager/suppliers.jsp").forward(request, response);
    }
    
    private void handleViewSupplier(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        try {
            int viewId = Integer.parseInt(request.getParameter("id"));
            Supplier viewSupplier = supplierDAO.getSupplierById(viewId);

            if (viewSupplier != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                Gson gson = new Gson();
                String jsonSupplier = gson.toJson(viewSupplier);

                response.getWriter().write(jsonSupplier);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Không tìm thấy nhà cung cấp\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
        }
    }
    
    private void handleEditSupplier(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        try {
            int editId = Integer.parseInt(request.getParameter("id"));
            Supplier editSupplier = supplierDAO.getSupplierById(editId);
            
            if (editSupplier != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                Gson gson = new Gson();
                String jsonSupplier = gson.toJson(editSupplier);

                response.getWriter().write(jsonSupplier);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Không tìm thấy nhà cung cấp\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
        }
    }
    
    private void handleAddSupplier(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        System.out.println("=== ADDING NEW SUPPLIER ===");
        
        Map<String, String> fieldErrors = new HashMap<>();
        Map<String, String> formData = new HashMap<>();
        HttpSession session = request.getSession();
        
        try {
            String supplierName = request.getParameter("supplierName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            
            // Lưu dữ liệu form để hiển thị lại nếu có lỗi
            formData.put("supplierName", supplierName != null ? supplierName : "");
            formData.put("phone", phone != null ? phone : "");
            formData.put("email", email != null ? email : "");
            formData.put("address", address != null ? address : "");
            
            System.out.println("Supplier Name: " + supplierName);
            System.out.println("Phone: " + phone);
            System.out.println("Email: " + email);
            System.out.println("Address: " + address);

            // Validate input
            boolean hasError = false;
            
            if (supplierName == null || supplierName.trim().isEmpty()) {
                fieldErrors.put("supplierName", "Tên nhà cung cấp không được để trống!");
                hasError = true;
            }
            
            if (email == null || email.trim().isEmpty()) {
                fieldErrors.put("email", "Email không được để trống!");
                hasError = true;
            } else if (!isValidEmail(email)) {
                fieldErrors.put("email", "Định dạng email không hợp lệ!");
                hasError = true;
            } else if (supplierDAO.checkEmailExist(email)) {
                fieldErrors.put("email", "Email đã tồn tại!");
                hasError = true;
            }

            if (hasError) {
                request.setAttribute("fieldErrors", fieldErrors);
                request.setAttribute("formData", formData);
                request.setAttribute("errorMessage", "Vui lòng kiểm tra lại thông tin!");
                request.getRequestDispatcher("/manager/supplier_add.jsp").forward(request, response);
                return;
            }

            Supplier newSupplier = new Supplier();
            newSupplier.setSupplierName(supplierName.trim());
            newSupplier.setPhone(phone != null ? phone.trim() : "");
            newSupplier.setEmail(email.trim());
            newSupplier.setAddress(address != null ? address.trim() : "");
            newSupplier.setIsActive(true);

            System.out.println("Supplier object created: " + newSupplier.toString());
            System.out.println("Attempting to save supplier to database...");

            boolean success = supplierDAO.addSupplier(newSupplier);

            if (success) {
                System.out.println("SUCCESS: Supplier added successfully!");
                session.setAttribute("message", "Thêm nhà cung cấp thành công!");
                response.sendRedirect(request.getContextPath() + "/manager/supplier");
            } else {
                System.out.println("ERROR: Failed to add supplier to database");
                request.setAttribute("errorMessage", "Thêm nhà cung cấp thất bại!");
                request.setAttribute("formData", formData);
                request.getRequestDispatcher("/manager/supplier_add.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("ERROR: Unexpected error - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.setAttribute("formData", formData);
            request.getRequestDispatcher("/manager/supplier_add.jsp").forward(request, response);
        }

        System.out.println("=== END ADDING SUPPLIER ===");
    }
    
    private void handleUpdateSupplier(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        System.out.println("=== UPDATING SUPPLIER ===");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        Map<String, String> errors = new HashMap<>();
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String supplierName = request.getParameter("supplierName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            
            System.out.println("Updating supplier ID: " + id);
            System.out.println("New values - Name: " + supplierName + ", Email: " + email);

            // Validate input
            boolean hasError = false;
            
            if (supplierName == null || supplierName.trim().isEmpty()) {
                errors.put("supplierName", "Tên nhà cung cấp không được để trống!");
                hasError = true;
            }
            
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email không được để trống!");
                hasError = true;
            } else if (!isValidEmail(email)) {
                errors.put("email", "Định dạng email không hợp lệ!");
                hasError = true;
            } else if (supplierDAO.checkEmailExistExclude(email, id)) {
                errors.put("email", "Email đã tồn tại!");
                hasError = true;
            }

            if (hasError) {
                jsonResponse.put("status", "error");
                jsonResponse.put("errors", errors);
                jsonResponse.put("message", "Vui lòng kiểm tra lại thông tin!");
                
                Gson gson = new Gson();
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            Supplier existingSupplier = supplierDAO.getSupplierById(id);
            if (existingSupplier != null) {
                existingSupplier.setSupplierName(supplierName.trim());
                existingSupplier.setPhone(phone != null ? phone.trim() : "");
                existingSupplier.setEmail(email.trim());
                existingSupplier.setAddress(address != null ? address.trim() : "");

                boolean updateSuccess = supplierDAO.updateSupplier(existingSupplier);

                if (updateSuccess) {
                    System.out.println("SUCCESS: Supplier updated successfully!");
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Cập nhật nhà cung cấp thành công!");
                } else {
                    System.out.println("ERROR: Failed to update supplier");
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Cập nhật nhà cung cấp thất bại!");
                }
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Không tìm thấy nhà cung cấp!");
            }
            
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi: " + e.getMessage());
        }

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            System.out.println("Toggling supplier " + supplierId + " status from " + status + " to " + !status);

            boolean toggleSuccess = supplierDAO.toggleSupplierStatus(supplierId, !status);

            if (toggleSuccess) {
                System.out.println("SUCCESS: Status changed successfully!");
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Thay đổi trạng thái thành công!");
            } else {
                System.out.println("ERROR: Failed to change status");
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Thay đổi trạng thái thất bại!");
            }
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Lỗi khi thay đổi trạng thái: " + e.getMessage());
        }

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    private void handleSearchSuppliers(HttpServletRequest request, HttpServletResponse response, SupplierDAO supplierDAO)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";
        
        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Supplier> suppliers = supplierDAO.searchSuppliers(keyword, page, pageSize);
        int totalSuppliers = supplierDAO.getTotalSearchResults(keyword);
        int totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);

        System.out.println("Search keyword: " + keyword);
        System.out.println("Total search results: " + totalSuppliers);
        System.out.println("Current page: " + page);
        System.out.println("Total pages: " + totalPages);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/manager/suppliers.jsp").forward(request, response);
    }
    
    // Utility method to validate email
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@gmail\\.com$");
    }
    
    private boolean isValidPhone(String phone) {
        return phone == null || phone.isEmpty() || phone.matches("^[0-9]{10,11}$");
    }
    
    // Thêm phương thức này vào các hàm xử lý form để kiểm tra dữ liệu
    private boolean validateSupplierData(HttpServletRequest request, Map<String, String> fieldErrors) {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        boolean isValid = true;
        
        if (!isValidEmail(email)) {
            fieldErrors.put("email", "Email không đúng định dạng @gmail.com");
            isValid = false;
        }
        
        if (phone != null && !phone.isEmpty() && !isValidPhone(phone)) {
            fieldErrors.put("phone", "Số điện thoại phải có 10-11 chữ số");
            isValid = false;
        }
        
        return isValid;
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
