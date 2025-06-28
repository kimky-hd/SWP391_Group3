package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Category;
import Model.Color;
import Model.Material;
import Model.Season;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

        // Validate dữ liệu đầu vào
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorTitle", "Vui lòng nhập tên sản phẩm.");
            hasError = true;
        }

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

        // Upload ảnh
        Part imagePart = request.getPart("image");
        String imagePath = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            String originalName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            // Thư mục lưu ảnh vật lý trong dự án (web/img)
            String uploadDir = getServletContext().getRealPath("/img");
            File folder = new File(uploadDir);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            // Lưu file vào thư mục img/ với đúng tên gốc (không lọc trùng)
            File file = new File(uploadDir, originalName);
            imagePart.write(file.getAbsolutePath());

            // Lưu tên ảnh (không có "img/") vào CSDL
            imagePath = originalName;
        } else {
            request.setAttribute("errorImage", "Vui lòng chọn ảnh.");
            hasError = true;
        }

        // Nếu có lỗi → load lại dữ liệu và forward về form
        if (hasError) {
            ProductDAO productDAO = new ProductDAO();
            MaterialDAO mateDAO = new MaterialDAO();

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

        // Nếu hợp lệ → lưu dữ liệu sản phẩm
        ProductDAO productDAO = new ProductDAO();
        int productID = productDAO.addProduct(title, imagePath, price, description, colorID, seasonID);

        // Lưu danh mục sản phẩm
        if (categoryID != null) {
            for (String catIDStr : categoryID) {
                try {
                    int catID = Integer.parseInt(catIDStr);
                    productDAO.addCategoryProduct(productID, catID);
                } catch (NumberFormatException ignored) {
                }
            }
        }

        // Lưu nguyên liệu
        List<Material> materials = new MaterialDAO().getAllMaterial();
        for (Material m : materials) {
            String qtyRaw = request.getParameter("material_" + m.getMaterialID());
            if (qtyRaw != null && !qtyRaw.trim().isEmpty()) {
                try {
                    int qty = Integer.parseInt(qtyRaw.trim());
                    if (qty > 0) {
                        productDAO.insertProductComponent(productID, m.getMaterialID(), qty);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }

        request.getSession().setAttribute("isactive", "Thêm sản phẩm thành công!");
        response.sendRedirect("managerproductlist");
    }

    @Override
    public String getServletInfo() {
        return "Add Product Controller";
    }
}
