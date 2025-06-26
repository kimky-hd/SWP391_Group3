/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.MaterialDAO;
import DAO.ProductDAO;
import Model.Category;
import Model.Color;
import Model.Material;
import Model.Season;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 *
 * @author Duccon
 */
@MultipartConfig
public class AddProductController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        MaterialDAO mateDAO = new MaterialDAO();

        List<Color> allcolor = productDAO.getAllColor();
        List<Season> allseason = productDAO.getAllSeason();
        List<Category> allcategory = productDAO.getAllCategory();
        List<Material> allmaterial = mateDAO.getAllMaterial();

        request.setAttribute("colorList", allcolor);
        request.setAttribute("seasonList", allseason);
        request.setAttribute("categoryList", allcategory);
        request.setAttribute("materialList", allmaterial);
        request.getRequestDispatcher("Manager_CreateProduct.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        int colorID = 0;
        int seasonID = 0;

        // Validate title
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorTitle", "Vui lòng nhập tên sản phẩm.");
            hasError = true;
        }

        // Validate price
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

        // Validate color
        try {
            colorID = Integer.parseInt(colorIDRaw);
        } catch (NumberFormatException e) {
            request.setAttribute("errorColor", "Màu không hợp lệ.");
            hasError = true;
        }

        // Validate season
        try {
            seasonID = Integer.parseInt(seasonIDRaw);
        } catch (NumberFormatException e) {
            request.setAttribute("errorSeason", "Mùa không hợp lệ.");
            hasError = true;
        }

        // Upload image
        Part imagePart = request.getPart("image");
        String imagePath = "";
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/img");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            imagePart.write(uploadPath + File.separator + fileName);
            imagePath = "img/" + fileName;
        } else {
            request.setAttribute("errorImage", "Vui lòng chọn ảnh.");
            hasError = true;
        }

        // Nếu có lỗi, load lại dữ liệu và forward về form
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

        // Nếu hợp lệ → lưu dữ liệu
        ProductDAO productDAO = new ProductDAO();
        int productID = productDAO.addProduct(title, imagePath, price, description, colorID, seasonID);

        // Lưu danh mục
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
        String[] selectedMaterials = request.getParameterValues("materials");
if (selectedMaterials != null) {
    for (String mIDStr : selectedMaterials) {
        try {
            int materialID = Integer.parseInt(mIDStr);
            String qtyParam = request.getParameter("materialQty_" + materialID);
            if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                int materialQuantity = Integer.parseInt(qtyParam.trim());
                if (materialQuantity > 0) {
                    productDAO.insertProductComponent(productID, materialID, materialQuantity);
                }
            }
        } catch (NumberFormatException ignored) {
        }
    }
}

        request.getSession().setAttribute("isactive", "Thêm sản phẩm thành công!");
        response.sendRedirect("managerproductlist");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
