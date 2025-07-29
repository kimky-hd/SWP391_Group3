package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Category;
import Model.Color;
import Model.Material;
import Model.Season;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig
public class AddProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        MaterialDAO mateDAO = new MaterialDAO();

        request.setAttribute("colorList", productDAO.getAllColor());
        request.setAttribute("seasonList", productDAO.getAllSeason());
        request.setAttribute("categoryList", productDAO.getAllCategory());
        request.setAttribute("materialList", mateDAO.getAllMaterial());

        request.getRequestDispatcher("Manager_CreateProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String priceRaw = request.getParameter("price");
        String description = request.getParameter("description");
        String[] categoryID = request.getParameterValues("categoryID");
        String colorIDRaw = request.getParameter("colorID");
        String seasonIDRaw = request.getParameter("seasonID");

        boolean hasError = false;
        double price = 0;
        int colorID = 0, seasonID = 0;

        ProductDAO productDAO = new ProductDAO();
        MaterialDAO mateDAO = new MaterialDAO();
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {


        // --- Validate tên sản phẩm ---
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorTitle", "Vui lòng nhập tên sản phẩm.");
            hasError = true;
        } else if (productDAO.isTitleDuplicated(title.trim())) {
            request.setAttribute("errorTitle", "Tên sản phẩm đã tồn tại.");
            hasError = true;
        }
        
        if(description == null || description.trim().isEmpty()){
            request.setAttribute("errorDiscript", "Vui lòng nhập mô tả");
            hasError = true;
        }else if(description.length()>200){
            request.setAttribute("errorDiscript", "Mô tả không được quá 200 ký tự. Vui lòng nhập lại.");
            hasError = true;
        }

        // --- Validate giá ---
        if (priceRaw == null || priceRaw.trim().isEmpty()) {
            request.setAttribute("errorPrice", "Vui lòng nhập giá.");
            hasError = true;
        } else {
            try {
                price = Double.parseDouble(priceRaw.trim());
                if (price <= 0) {
                    request.setAttribute("errorPrice", "Giá phải lớn hơn 0.");
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorPrice", "Giá không hợp lệ.");
                hasError = true;
            }
        }

        // --- Validate màu và mùa ---
        try {
            colorID = Integer.parseInt(colorIDRaw);
        } catch (NumberFormatException e) {
            request.setAttribute("errorColor", "Màu không hợp lệ.");
            hasError = true;
        }

        try {
            seasonID = Integer.parseInt(seasonIDRaw);
        } catch (NumberFormatException e) {
            request.setAttribute("errorSeason", "Mùa không hợp lệ.");
            hasError = true;
        }

        // --- Validate ảnh ---
        Part imagePart = request.getPart("image");
        String imagePath = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            String originalName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uploadDir = getServletContext().getRealPath("/img");
            File folder = new File(uploadDir);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            File file = new File(uploadDir, originalName);
            imagePart.write(file.getAbsolutePath());
            imagePath = originalName;
        } else {
            request.setAttribute("errorImage", "Vui lòng chọn ảnh.");
            hasError = true;
        }

        // --- Validate nguyên liệu ---
        List<Material> materials = mateDAO.getAllMaterial();
        boolean hasValidMaterial = false;
        for (Material m : materials) {
            String qtyRaw = request.getParameter("material_" + m.getMaterialID());
            if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                try {
                    int qty = Integer.parseInt(qtyRaw.trim());
                    if (qty > 0) {
                        hasValidMaterial = true;
                        break;
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        if (!hasValidMaterial) {
            request.setAttribute("errorMaterial", "Vui lòng chọn ít nhất 1 nguyên liệu với số lượng > 0.");
            hasError = true;
        }

        // --- Nếu có lỗi: forward lại form + giữ dữ liệu ---
        if (hasError) {
            request.setAttribute("title", title);
            request.setAttribute("price", priceRaw);
            request.setAttribute("description", description);
            request.setAttribute("colorID", colorIDRaw);
            request.setAttribute("seasonID", seasonIDRaw);
            request.setAttribute("categoryIDs", categoryID);

            request.setAttribute("colorList", productDAO.getAllColor());
            request.setAttribute("seasonList", productDAO.getAllSeason());
            request.setAttribute("categoryList", productDAO.getAllCategory());
            request.setAttribute("materialList", mateDAO.getAllMaterial());

            request.getRequestDispatcher("Manager_CreateProduct.jsp").forward(request, response);
            return;
        }

        // --- Lưu dữ liệu sản phẩm ---
        int productID = productDAO.addProduct(title, imagePath, price, description, colorID, seasonID);

        // --- Lưu danh mục ---
        if (categoryID != null) {
            for (String catIDStr : categoryID) {
                try {
                    int catID = Integer.parseInt(catIDStr);
                    productDAO.addCategoryProduct(productID, catID);
                } catch (NumberFormatException ignored) {}
            }
        }

        // --- Lưu nguyên liệu ---
        for (Material m : materials) {
            String qtyRaw = request.getParameter("material_" + m.getMaterialID());
            if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                try {
                    int qty = Integer.parseInt(qtyRaw.trim());
                    if (qty > 0) {
                        productDAO.insertProductComponent(productID, m.getMaterialID(), qty);
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        request.getSession().setAttribute("isactive", "Thêm sản phẩm thành công!");
        response.sendRedirect("managerproductlist");
    }
    }
    @Override
    public String getServletInfo() {
        return "Add Product Controller with validation for duplicate title and ingredients";
    }
}
