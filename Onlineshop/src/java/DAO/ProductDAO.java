/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.AccountProfile;
import Model.Category;
import Model.CategoryProduct;
import Model.Color;
import Model.Feedback;
import Model.Material;
import Model.Product;
import Model.ProductBatch;
import Model.ProductComponent;
import Model.Season;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import Model.WishList;
import java.time.LocalDateTime;
import java.util.Date;

/**
 *
 * @author Admin
 */
public class ProductDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

    public List<ProductBatch> getBatchesByProductID(int productID) {
        List<ProductBatch> list = new ArrayList<>();
        String sql = "SELECT * FROM ProductBatch WHERE productID = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, productID);
            ResultSet result = stm.executeQuery();
            while (result.next()) {
                list.add(new ProductBatch(result.getInt(1),
                        result.getInt(2),
                        result.getInt(3),
                        result.getDouble(4),
                        result.getDate(5),
                        result.getDate(6),
                        result.getString(7)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getBatchesByProductID : " + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByIndex(int indexPage) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product ORDER BY productID LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 8); // tính offset
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("getProductByIndex: " + e.getMessage());
        }
        return list;
    }

    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches)
                );
            }
        } catch (SQLException e) {
            System.out.println("getAllProduct" + e.getMessage());
        }
        return list;
    }

    public Product getProductById(String id) {
        String sql = "SELECT * FROM Product WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt("productID"));
                return new Product(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches
                );
            }
        } catch (SQLException e) {
            System.out.println("getProductById: " + e.getMessage());
        }
        return null;
    }

    public List<Product> getProductByCategory(String categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p\n"
                + "                JOIN CategoryProduct cb ON p.productID = cb.productID \n"
                + "                JOIN Category c ON c.categoryID = cb.categoryID \n"
                + "                WHERE c.categoryID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductByColor" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByColor(String colorId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p\n"
                + "                JOIN PhanLoaiTheoColor c ON p.colorID = c.colorID \n"
                + "                WHERE c.colorID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, colorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductByColor" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductBySeason(String seasonId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p "
                + "JOIN PhanLoaiTheoSeason s ON p.seasonID = s.seasonID "
                + "WHERE s.seasonID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, seasonId);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductBySeason" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByTitle(String txt) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE Title LIKE CONCAT('%" + txt + "%')";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductByTitle" + e.getMessage());
        }
        return list;
    }

    public void addCategoryProduct(int ProductID, int categoryID) {
        String sql = "INSERT INTO CategoryProduct \n"
                + "(productID, categoryID) \n"
                + "VALUES \n"
                + "(?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, ProductID);
            ps.setInt(2, categoryID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addCategoryPRoduct" + e.getMessage());
        }
    }

    public void updateCategoryProduct(int updatedProductID, int selectedCategoryID) {
        String sql = "UPDATE CategoryProduct \n"
                + "SET categoryID = ? \n"
                + "WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, updatedProductID);
            ps.setInt(2, selectedCategoryID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateCategoryProduct" + e.getMessage());
        }
    }

    public int addProduct(String title, String image, double price, String description, int colorID, int seasonID) {
    String sql = "INSERT INTO Product (title, image, price, description, colorID, seasonID) VALUES (?, ?, ?, ?, ?, ?)";
    int generatedId = 0;

    try {
        ps = connection.prepareStatement(sql);
        ps.setString(1, title);
        ps.setString(2, image);
        ps.setDouble(3, price);
        ps.setString(4, description);
        ps.setInt(5, colorID);
        ps.setInt(6, seasonID);

        int affectedRows = ps.executeUpdate();
        if (affectedRows > 0) {
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);  // Lấy ID vừa được insert
            }
        }
    } catch (SQLException e) {
        System.out.println("addProduct ERROR: " + e.getMessage());
    }
    return generatedId;
}


    public void addProductBatch(int productID, ProductBatch batch) {
        String sql = "INSERT INTO ProductBatch (\n"
                + "         productID,\n"
                + "         quantity,\n"
                + "          importPrice,\n"
                + "         dateImport,\n"
                + "         dateExpire\n"
                + "         ) VALUES (\n"
                + "         ?, ?, ?, CURRENT_DATE(), ?\n"
                + "         )";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, batch.getQuantity());
            ps.setDouble(3, batch.getImportPrice());
            ps.setDate(4, new java.sql.Date(batch.getDateExpire().getTime()));
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addProductBatch" + e.getMessage());
        }
    }

    public void deleteProduct(int productID) {
        String sql = "DELETE FROM PRODUCT Where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteProduct" + e.getMessage());
        }
    }

    public void updateProduct(Product updateproduct) {
        String sql = "UPDATE Product SET\n"
                + "            title = ?,\n"
                + "            image = ?,\n"
                + "            price = ?,\n"
                + "            description = ?,\n"
                + "            colorID = ?,\n"
                + "            seasonID = ?,\n"
                + "        WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, updateproduct.getTitle());
            ps.setString(2, updateproduct.getImage());
            ps.setDouble(3, updateproduct.getPrice());
            ps.setString(4, updateproduct.getDescription());
            ps.setInt(5, updateproduct.getColorID());
            ps.setInt(6, updateproduct.getSeasonID());
            ps.setInt(7, updateproduct.getProductID());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("updateProduct" + e.getMessage());
        }
    }

    public void addNewBatchToProduct(int productID, int quantityAdd, double importPrice, Date dateImpport, Date dateExpire) {
        String sql = "INSERT INTO ProductBatch (productID, quantity, importPrice, dateImport, dateExpire) VALUES (?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, quantityAdd);
            ps.setDouble(3, importPrice);
            ps.setDate(4, new java.sql.Date(dateImpport.getTime()));
            ps.setDate(5, new java.sql.Date(dateExpire.getTime()));
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addNewBatchToProduct" + e.getMessage());
        }
    }

    public void updateProductBatchStatus() {
        String sql = "UPDATE ProductBatch SET status = "
                + "CASE "
                + "   WHEN CURDATE() <= DATE_ADD(dateImport, INTERVAL 3 DAY) THEN 'Tươi mới' "
                + "   WHEN CURDATE() <= dateExpire THEN 'Lão hóa' "
                + "   ELSE 'Đã Héo' "
                + "END";
        try {
            ps = connection.prepareStatement(sql);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateProductBatchStatus: " + e.getMessage());
        }
    }

    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();
        String sql = "Select * from Category";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(rs.getInt(1),
                        rs.getString(2)));
            }
        } catch (SQLException e) {
            System.out.println("getAllCategory" + e.getMessage());
        }
        return list;
    }

    public List<CategoryProduct> getCategoryProduct() {
        List<CategoryProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM CategoryProduct";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CategoryProduct(rs.getInt(1), rs.getInt(2)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getCategoryProduct" + e.getMessage());
        }
        return list;
    }

    public List<Color> getAllColor() {
        List<Color> list = new ArrayList<>();
        String sql = "Select * from PhanLoaiTheoColor";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Color(rs.getInt(1),
                        rs.getString(2)));
            }
        } catch (SQLException e) {
            System.out.println("getAllColor" + e.getMessage());
        }
        return list;
    }

    public List<Season> getAllSeason() {
        List<Season> list = new ArrayList<>();
        String sql = "Select * from PhanLoaiTheoSeason";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Season(rs.getInt(1),
                        rs.getString(2)));
            }
        } catch (SQLException e) {
            System.out.println("getAllSeason" + e.getMessage());
        }
        return list;
    }

    public int countAllProduct() {
        String sql = "select count(*) from Product";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countAllProduct" + e.getMessage());
        }
        return 0;
    }

    public List<Product> searchPrice0to50() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product \n"
                + "WHERE price >= 0 AND price <= 50000";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("searchPrice0to50" + e.getMessage());
        }
        return list;
    }

    public List<Product> searchPriceAbove50() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product \n"
                + "WHERE price > 50000";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("searchPriceAbove50" + e.getMessage());
        }
        return list;
    }

    public List<Product> searchPriceMinToMax(String priceMin, String priceMax) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product \n"
                + "WHERE price >= ? AND price <= ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, priceMin);
            ps.setString(2, priceMax);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("searchPriceAbove50" + e.getMessage());
        }
        return list;
    }

    public List<Feedback> getAllReviewByProductID(int id) {
        List<Feedback> list = new ArrayList<>();
        String sql = "Select * from Feedback where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Feedback(rs.getInt(1),
                        rs.getFloat(5),
                        rs.getDate(6),
                        rs.getString(4),
                        rs.getInt(2),
                        rs.getInt(3)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllReviewByProductID" + e.getMessage());
        }
        return list;
    }

    public float getRateByProductID(int id) {
        String sql = "SELECT ROUND(AVG(Rate), 1) AS rate FROM Feedback WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getFloat(1);
            }
        } catch (SQLException e) {
            System.out.println("getRateByProductID" + e.getMessage());
        }
        return 0;
    }

    private static java.sql.Date getCurrentDate() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Date(today.getTime());
    }

    public void insertFeedback(int accountID, String productID, String comment, String rate, LocalDateTime currentDateTime) {
        String sql = "INSERT INTO Feedback (accountID, productID, comment, rate, dateReview)\n"
                + "VALUES \n"
                + "(?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            ps.setString(2, productID);
            ps.setString(3, comment);
            ps.setString(4, rate);
            ps.setDate(5, getCurrentDate());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insertFeedback" + e.getMessage());
        }
    }

    public List<AccountProfile> getAllAccountProfile() {
        List<AccountProfile> list = new ArrayList<>();
        String sql = "Select * from Profile";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new AccountProfile(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getDate(6),
                        rs.getString(7),
                        rs.getDate(8),
                        rs.getInt(9)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllAccontProfile" + e.getMessage());
        }
        return list;
    }

    public WishList checkWishListExist(int accountID, int productID) {
        String sql = "select * from WishList where accountID = ? and productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new WishList(rs.getInt(1),
                        rs.getInt(2),
                        rs.getInt(3));
            }
        } catch (SQLException e) {
            System.out.println("checkWishLishExist" + e.getMessage());
        }
        return null;
    }

    public void insertWishList(int accountID, int productID) {
        String sql = "insert WishList (accountID, productID) values(?,?) ";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insertWishList" + e.getMessage());
        }
    }

    public void removeWishList(int accountID, int productID) {
        String sql = "DELETE FROM WishList WHERE accountID = ? AND productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            ps.setInt(2, productID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("removeWishList" + e.getMessage());
        }
    }

    public void deleteWishList(int wishlistID) {
        String sql = "DELETE FROM WishList WHERE wishlistID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, wishlistID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteWishList" + e.getMessage());
        }
    }

    public List<Product> getListWishListProduct(int accountID) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT    \n"
                + "    p.productID,\n"
                + "    p.title,\n"
                + "    p.image,\n"
                + "    p.price,\n"
                + "    p.description,\n"
                + "    p.colorID,\n"
                + "    p.seasonID \n"
                + " FROM Product p \n"
                + " JOIN Wishlist wl ON p.productID = wl.productID \n"
                + " WHERE wl.AccountID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("getListWishListProduct" + e.getMessage());
        }
        return list;
    }

    public List<WishList> getWishListProductByAccount(int accountID) {
        List<WishList> list = new ArrayList<>();
        String sql = "Select * from WishList where accountID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new WishList(rs.getInt(1),
                        rs.getInt(2),
                        rs.getInt(3)));
            }
        } catch (SQLException e) {
            System.out.println("getWishListProductByAccount" + e.getMessage());
        }
        return list;
    }

    public int countProductWishLish(int accountID) {
        String sql = "SELECT COUNT(*) AS TotalProducts\n"
                + "FROM Product p\n"
                + "JOIN Wishlist wl ON p.productID = wl.productID\n"
                + "WHERE wl.accountID = ?;";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countProductWishLish" + e.getMessage());
        }
        return 0;
    }

    public List<Product> getSortProduct(String sortOrder, int pageIndex) {
        List<Product> list = new ArrayList<>();
        String order = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            order = "DESC";
        }
        String sql = "SELECT * FROM Product ORDER BY price " + order + " LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * 8);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt(1));
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getSortProduct: " + e.getMessage());
        }
        return list;
    }

    public boolean isTitleDuplicated(String title) {
        ProductDAO product = new ProductDAO();
        List<Product> listproduct = product.getAllProduct();
        for (Product p : listproduct) {
            if (p.getTitle().equalsIgnoreCase(title)) {
                return true;
            }
        }
        return false;
    }

    public Product getProductById(int productID) {
        String sql = "Select * from product where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            rs = ps.executeQuery();
            if (rs.next()) {
                List<ProductBatch> batches = getBatchesByProductID(rs.getInt("productID"));

                return new Product(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        batches
                );
            }
        } catch (SQLException e) {
            System.out.println("getProductById" + e.getMessage());
        }
        return null;
    }

    public List<ProductComponent> getProductComponentsByProductID(int productID) {
        List<ProductComponent> list = new ArrayList<>();
        String sql = "SELECT pc.productComponentID, pc.materialID, pc.materialQuantity, m.name, m.unit "
                + "          FROM ProductComponent pc "
                + "          JOIN Material m ON pc.materialID = m.materialID "
                + "          WHERE pc.productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            rs = ps.executeQuery();
            while (rs.next()) {
                Material material = new Material();
                material.setMaterialID(rs.getInt("materialID"));
                material.setName(rs.getString("name"));
                material.setUnit(rs.getString("unit"));

                ProductComponent pc = new ProductComponent();
                pc.setProductComponentID(rs.getInt("productComponentID"));
                pc.setMaterialID(rs.getInt("materialID"));
                pc.setMaterialQuantity(rs.getInt("materialQuantity"));
                pc.setMaterial(material);

                list.add(pc);
            }
        } catch (SQLException e) {
            System.out.println("getProductComponentsByProductID" + e.getMessage());
        }
        return list;
    }
    public void insertProductComponent(int productID, int materialID, int materialQuantity){
        String sql = "INSERT INTO ProductComponent("
                + "     productID,\n"
                + "     materialID,\n"
                + "     materialQuantity\n"
                + "     ) VALUES (?, ?, ?)";
        try{
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, materialID);
            ps.setInt(3, materialQuantity);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.println("insertProductComponent" + e.getMessage());
        }
    }
}
