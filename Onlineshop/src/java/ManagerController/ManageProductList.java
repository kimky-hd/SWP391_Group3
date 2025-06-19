///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package ManagerController;
//
//import DAO.CategoryDAO;
//import DAO.ProductDAO;
//import Model.Category;
//import Model.Product;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.Part;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.time.LocalDate;
//import java.util.List;
//import java.sql.Date;
//
///**
// *
// * @author Admin
// */
//public class ManageProductList extends HttpServlet {
//
//    ProductDAO productDAO = new ProductDAO();
//    CategoryDAO cateDAO = new CategoryDAO();
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet ManageProductList</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet ManageProductList at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//        response.setContentType("text/html; charset=UTF-8");
//
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "viewAll";
//        }
//        switch (action) {
//            case "Add":
//                viewAddProductPage(request, response);
//                break;
//            case "viewAll":
//                viewAll(request, response);
//            case "viewUpdate":
//                viewUpdate(request, response);
//                break;
//            default:
//                viewAll(request, response);
//        }
//
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//        response.setContentType("text/html; charset=UTF-8");
//
//        String action = request.getParameter("action");
//
//        switch (action) {
//            case "Add":
//                addProduct(request, response);
//                break;
//            case "Update":
//                updateProduct(request, response);
//                break;
//            case "addQuantity":
//                addQuantity(request, response);
//                break;
//            case "delete":
//                deleteBook(request, response);
//                break;
//            default:
//                throw new AssertionError();
//        }
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//    private void viewAll(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String index = request.getParameter("index");
//        if (index == null || index.isEmpty()) {
//            index = "1";
//        }
//        int indexPage = Integer.parseInt(index);
//
//        List<Product> listProductByIndex = productDAO.getProductByIndex(indexPage);
//        //List<Product> listproducts = productDAO.getAllProduct();
//
//        int allProduct = productDAO.countAllProduct();
//        int endPage = allProduct / 8;
//        if (allProduct % 8 != 0) {
//            endPage++;
//        }
//
//        request.setAttribute("productList", listProductByIndex);
//        request.getRequestDispatcher("Manager_ListProduct.jsp").forward(request, response);
//    }
//
//    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String title = request.getParameter("productTitle").trim();
//        String image = handleImg(request, response);
//        double price = 0;
//        int quantity = 0;
//        String description = request.getParameter("description").trim();
//        int selectedCategoryID = Integer.parseInt(request.getParameter("categoryType"));
//        int color = Integer.parseInt(request.getParameter("color"));
//        int season = Integer.parseInt(request.getParameter("season"));
//        String thanhphan = request.getParameter("thanhphan");
//        Date dateImport = Date.valueOf(LocalDate.now());
//        Date dateExpire = Date.valueOf(request.getParameter("dateExpire"));
//
//        boolean hasError = false;
//        try {
//            price = Double.parseDouble(request.getParameter("price"));
//            if (price < 0 || price > 99999999) {
//                request.setAttribute("errorPrice", "Giá không được nhỏ hơn 0 và lớn hơn 99999999");
//                hasError = true;
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("errorPrice", "Giá phải là một số hợp lệ");
//            hasError = true;
//        }
//        try {
//            quantity = Integer.parseInt(request.getParameter("quantity"));
//            if (quantity < 0) {
//                request.setAttribute("errorQuantity", "Số lượng không được nhỏ hơn 0");
//                hasError = true;
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("errorQuantity",
//                    "Số lượng phải là một số nguyên hợp lệ nhỏ hơn " + Integer.MAX_VALUE);
//            hasError = true;
//        }
//        if (title.equals("")) {
//            request.setAttribute("errorTitle", "Không được để khoảng trắng");
//            hasError = true;
//        } else if (productDAO.isTitleDuplicated(title)) {
//            request.setAttribute("errorTitle", "Tên sản phẩm đã tồn tại");
//            hasError = true;
//        }
//        if (description.equals("")) {
//            request.setAttribute("errorDescription", "Không được để khoảng trắng");
//            hasError = true;
//        }
//        if (hasError) {
//            request.setAttribute("titleValue", title);
//            request.setAttribute("imageValue", image);
//            request.setAttribute("descriptionValue", description);
//            request.setAttribute("priceValue", price);
//            request.setAttribute("quantityValue", quantity);
//            request.setAttribute("selectedCategoryID", selectedCategoryID);
//            request.setAttribute("colorValue", color);
//            request.setAttribute("seasonValue", season);
//            request.setAttribute("thanhphanValue", thanhphan);
//            request.setAttribute("dateImportValue", dateImport);
//            request.setAttribute("dateExpireValue", dateExpire);
//            viewAddProductPage(request, response);
//            return;
//
//        }
//        Product newProduct = new Product(0, title, image, price, quantity, description, color, season, thanhphan, dateImport, dateExpire);
//
//        int insertedProductID = productDAO.addProduct(newProduct);
//
//        productDAO.addCategoryProduct(insertedProductID, selectedCategoryID);
//
//        response.sendRedirect("manageproductlist");
//    }
//
//    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String title = request.getParameter("productTitle").trim();
//        String image = handleImg(request, response);
//        double price = 0;
//        int quantity = 0;
//        String description = request.getParameter("description").trim();
//        int selectedCategoryID = Integer.parseInt(request.getParameter("categoryType"));
//        int color = Integer.parseInt(request.getParameter("color"));
//        int season = Integer.parseInt(request.getParameter("season"));
//        String thanhphan = request.getParameter("thanhphan");
//        Date dateImport = Date.valueOf(request.getParameter("dateImport"));
//        Date dateExpire = Date.valueOf(request.getParameter("dateExpire"));
//
//        int updatedProductID = Integer.parseInt(request.getParameter("idUpdateProduct"));
//
//        boolean hasError = false;
//
//        try {
//            price = Double.parseDouble(request.getParameter("price"));
//            if (price < 0 || price > 99999999) {
//                request.setAttribute("errorPrice", "Giá không được nhỏ hơn 0 và lớn hơn 99999999");
//                hasError = true;
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("errorPrice", "Giá phải là một số hợp lệ");
//            hasError = true;
//        }
//        try {
//            quantity = Integer.parseInt(request.getParameter("quantity"));
//            if (quantity < 0) {
//                request.setAttribute("errorQuantity", "Số lượng không được nhỏ hơn 0");
//                hasError = true;
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("errorQuantity",
//                    "Số lượng phải là một số nguyên hợp lệ nhỏ hơn " + Integer.MAX_VALUE);
//            hasError = true;
//        }
//        if (title.equals("")) {
//            request.setAttribute("errorTitle", "Không được để khoảng trắng");
//            hasError = true;
//        } else if (productDAO.isTitleDuplicated(title)) {
//            request.setAttribute("errorTitle", "Tên sản phẩm đã tồn tại");
//            hasError = true;
//        }
//        if (description.equals("")) {
//            request.setAttribute("errorDescription", "Không được để khoảng trắng");
//            hasError = true;
//        }
//
//        Product newProduct = new Product(updatedProductID, title, image, price, quantity, description, color, season, thanhphan, dateImport, dateExpire);
//
//        if (hasError) {
//            request.setAttribute("product", newProduct);
//            request.setAttribute("selectedCategoryID", selectedCategoryID);
//            List<Category> listCate = cateDAO.getAllCategory();
//            request.setAttribute("listCate", listCate);
//            request.getRequestDispatcher("Manager_UpdateProduct.jsp").forward(request, response);
//            return;
//        }
//
//        productDAO.updateProduct(newProduct);
//        productDAO.updateCategoryProduct(updatedProductID, selectedCategoryID);
//        response.sendRedirect("manageproductlist");
//    }
//
//    private String handleImg(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        Part productImage = request.getPart("image");
//
//        String realPath = request.getServletContext().getRealPath("/images");
//
//        String fileName = Path.of(productImage.getSubmittedFileName()).getFileName().toString();
//
//        if (!Files.exists(Path.of(realPath))) {
//            Files.createDirectory(Path.of(realPath));
//        }
//        productImage.write(realPath + "/" + fileName);
//
//        return fileName;
//    }
//
//    private void addQuantity(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int quantityAdd = Integer.parseInt(request.getParameter("quantity"));
//        int productID = Integer.parseInt(request.getParameter("productID"));
//
//        productDAO.updateAddQuantity(quantityAdd, productID);
//        viewAll(request, response);
//    }
//
//    private void deleteBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int productID = Integer.parseInt(request.getParameter("productID"));
//        productDAO.deleteProduct(productID);
//        viewAll(request, response);
//    }
//
//    private void viewAddProductPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        List<Category> listCate = cateDAO.getAllCategory();
//        request.setAttribute("listCate", listCate);
//        request.getRequestDispatcher("Manage_CreateProduct.jsp").forward(request, response);
//
//    }
//
//    private void viewUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int productID = Integer.parseInt(request.getParameter("productID"));
//        Product productUpdate = productDAO.getProductById(productID);
//        request.setAttribute("product", productUpdate);
//        List<Category> listCate = cateDAO.getAllCategory();
//        request.setAttribute("listCate", listCate);
//        int selectedCategoryID = cateDAO.getCategoryByProductID(productID);
//        request.setAttribute("selectedCategoryID", selectedCategoryID);
//        request.getRequestDispatcher("Manager_UpdateProduct.jsp").forward(request, response);
//    }
//
//}
