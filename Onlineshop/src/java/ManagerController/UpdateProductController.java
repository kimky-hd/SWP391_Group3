/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ManagerController;

import DAO.CategoryDAO;
import DAO.ProductDAO;
import Model.Account;
import Model.Category;
import Model.Color;
import Model.Product;
import Model.Season;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 *
 * @author Duccon
 */
@MultipartConfig
public class UpdateProductController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateProductController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProductController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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
        int productID = Integer.parseInt(request.getParameter("productID"));
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO cateDAO = new CategoryDAO();

        Product product = productDAO.getProductById(productID);
        List<Category> categoryList = productDAO.getAllCategory();
        List<Category> selectedCategories = cateDAO.getCategoryByProductID(productID);

        List<Integer> selectedCategoryIDs = selectedCategories.stream()
                .map(Category::getCategoryID)
                .collect(Collectors.toList());

        request.setAttribute("product", product);
        request.setAttribute("colorList", productDAO.getAllColor());
        request.setAttribute("seasonList", productDAO.getAllSeason());
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("categoryIDs", selectedCategoryIDs);
        request.getRequestDispatcher("Manager_UpdateProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ProductDAO productDAO = new ProductDAO();
        
        HttpSession session = request.getSession();
        Account a = (Account) session.getAttribute("account");
        if (a == null) {
            request.setAttribute("mess", "Bạn cần đăng nhập");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
        int productID = Integer.parseInt(request.getParameter("productID"));
        String title = request.getParameter("title").trim();
        String description = request.getParameter("description").trim();
        String priceRaw = request.getParameter("price");
        int colorID = Integer.parseInt(request.getParameter("color"));
        int seasonID = Integer.parseInt(request.getParameter("season"));

        String[] categoryIDParams = request.getParameterValues("categoryID");
        List<Integer> selectedCategoryIDs = new ArrayList<>();
        if (categoryIDParams != null) {
            for (String id : categoryIDParams) {
                try {
                    selectedCategoryIDs.add(Integer.parseInt(id));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        Product oldProduct = productDAO.getProductById(productID);
        String oldImageName = oldProduct.getImage();
        String fileName = oldImageName;

        boolean hasError = false;

        // Validate tên sản phẩm
        if (title.isEmpty()) {
            request.setAttribute("errorTitle", "Tên sản phẩm không được để trống.");
            hasError = true;
        } else if (!title.equalsIgnoreCase(oldProduct.getTitle()) && productDAO.isTitleDuplicated(title)) {
            request.setAttribute("errorTitle", "Tên sản phẩm đã tồn tại.");
            hasError = true;
        }

        // Validate giá
        double price = 0;
        try {
            price = Double.parseDouble(priceRaw);
            if (price <= 0) {
                request.setAttribute("errorPrice", "Giá phải là số dương.");
                hasError = true;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorPrice", "Giá không hợp lệ.");
            hasError = true;
        }

        // Validate mô tả
        if (description.isEmpty()) {
            request.setAttribute("errorDescription", "Vui lòng nhập mô tả.");
            hasError = true;
        }

        // Nếu có lỗi → giữ nguyên dữ liệu
        if (hasError) {
            request.setAttribute("product", oldProduct);
            request.setAttribute("colorList", productDAO.getAllColor());
            request.setAttribute("seasonList", productDAO.getAllSeason());
            request.setAttribute("categoryList", productDAO.getAllCategory());
            request.setAttribute("categoryIDs", selectedCategoryIDs);
            request.getRequestDispatcher("Manager_UpdateProduct.jsp").forward(request, response);
            return;
        }

        // Xử lý ảnh nếu có ảnh mới
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String originalName = new File(filePart.getSubmittedFileName()).getName();
            String extension = originalName.substring(originalName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + extension;

            String uploadPath = request.getServletContext().getRealPath("/img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File newFile = new File(uploadPath, fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, newFile.toPath());
            }

            if (oldImageName != null && !oldImageName.equals("default.jpg")) {
                File oldFile = new File(uploadPath, oldImageName);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
        }

        // Cập nhật dữ liệu vào DB
        productDAO.updateProduct(productID, title, fileName, price, description, colorID, seasonID);
        productDAO.updateCateForProduct(productID, selectedCategoryIDs);

        request.getSession().setAttribute("isactive", "Cập nhật sản phẩm thành công!");
        response.sendRedirect("managerproductlist");
    }
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
