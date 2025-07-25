/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.AccountProfile;
import Model.Category;
import Model.CategoryProduct;
import Model.Color;

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
import java.sql.Date;
import java.sql.Statement;

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
                        result.getDate(6)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getBatchesByProductID : " + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByIndex(int indexPage) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE isActive = TRUE ORDER BY productID LIMIT ?, 8";
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
                        rs.getBoolean(8),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("getProductByIndex: " + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByIndexForManage(int indexPage) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product ORDER BY productID LIMIT ?, 5";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 5); // tính offset
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
                        rs.getBoolean(8),
                        batches));

            }
        } catch (SQLException e) {
            System.out.println("getProductByIndexForManage: " + e.getMessage());
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
                        rs.getBoolean(8),
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

                return new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
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
            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
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
            System.out.println("addProduct : " + e.getMessage());
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

    public void updateProduct(int id, String title, String image, double price, String description, int colorID, int seasonID) {
        String sql = "UPDATE Product SET\n"
                + "            title = ?,\n"
                + "            image = ?,\n"
                + "            price = ?,\n"
                + "            description = ?,\n"
                + "            colorID = ?,\n"
                + "            seasonID = ? \n"
                + "        WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, image);
            ps.setDouble(3, price);
            ps.setString(4, description);
            ps.setInt(5, colorID);
            ps.setInt(6, seasonID);
            ps.setInt(7, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("updateProduct" + e.getMessage());
        }
    }

    public void updateCateForProduct(int productID, List<Integer> categoryID) {
        String deleteSQL = "DELETE FROM CategoryProduct WHERE productID = ?";
        String insertSQL = "INSERT INTO CategoryProduct (productID, categoryID) VALUES (?, ?)";

        try {
            PreparedStatement delps = connection.prepareStatement(deleteSQL);
            delps.setInt(1, productID);
            delps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("delete cate : " + e.getMessage());
        }

        try {
            PreparedStatement insps = connection.prepareStatement(insertSQL);
            for (int cateID : categoryID) {
                insps.setInt(1, productID);
                insps.setInt(2, cateID);
                insps.addBatch();;
            }
            insps.executeBatch();
        } catch (SQLException e) {
            System.out.println("insert new cate : " + e.getMessage());
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("searchPriceAbove50" + e.getMessage());
        }
        return list;
    }





    private static java.sql.Date getCurrentDate() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Date(today.getTime());
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

    public List<Product> getListWishListProduct(int accountID, int indexPage) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT    \n"
                + "    p.productID,\n"
                + "    p.title,\n"
                + "    p.image,\n"
                + "    p.price,\n"
                + "    p.description,\n"
                + "    p.colorID,\n"
                + "    p.seasonID,\n"
                + "    p.isActive \n"
                + " FROM Product p \n"
                + " JOIN Wishlist wl ON p.productID = wl.productID \n"
                + " WHERE wl.AccountID = ? ORDER BY wl.wishlistID LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            ps.setInt(2, (indexPage - 1) * 8);
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
                        rs.getBoolean(8),
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getSortProduct: " + e.getMessage());
        }
        return list;
    }

    public List<Product> getSortProductManager(String sortOrder, int pageIndex) {
        List<Product> list = new ArrayList<>();
        String order = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            order = "DESC";
        }
        String sql = "SELECT * FROM Product ORDER BY price " + order + " LIMIT ?, 5";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * 5);
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getSortProduct: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get top 4 cheapest products for homepage
     * @return List of top 4 cheapest products
     */
    public List<Product> getTop4CheapestProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE isActive = TRUE ORDER BY price ASC LIMIT 4";
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getTop4CheapestProducts: " + e.getMessage());
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

                Product product = new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getString(5),
                        rs.getInt(6),
                        rs.getInt(7),
                        rs.getBoolean(8),
                        batches
                );
                List<ProductComponent> components = getProductComponentsByProductID(productID);
                product.setComponents(components);

                return product;
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

    public void insertProductComponent(int productID, int materialID, int materialQuantity) {
        String sql = "INSERT INTO ProductComponent("
                + "     productID,\n"
                + "     materialID,\n"
                + "     materialQuantity\n"
                + "     ) VALUES (?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, materialID);
            ps.setInt(3, materialQuantity);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insertProductComponent" + e.getMessage());
        }
    }

    public String getColorNameByID(int colorID) {
        String sql = "SELECT colorName FROM Color WHERE colorID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, colorID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("colorName");
            }
        } catch (SQLException e) {
            System.out.println("getColorNameByID: " + e.getMessage());
        }
        return null;
    }

    public String getSeasonNameByID(int seasonID) {
        String sql = "SELECT seasonName FROM Season WHERE seasonID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, seasonID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("seasonName");
            }
        } catch (SQLException e) {
            System.out.println("getSeasonNameByID: " + e.getMessage());
        }
        return null;
    }

    public void updateProductIsActive(int productID, boolean isActive) {
        String sql = "UPDATE Product SET isActive = ? WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, productID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateProductIsActive : " + e.getMessage());
        }
    }

    public void insertProductBatch(int productID, int quantity, double importPrice, Date dateImport, Date dateExpire) {
        String sql = "INSERT INTO ProductBatch (productID, quantity, importPrice, dateImport, dateExpire) VALUES (?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, quantity);
            ps.setDouble(3, importPrice);
            ps.setDate(4, dateImport);
            ps.setDate(5, dateExpire);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insertProductBatch : " + e.getMessage());
        }
    }
    
    public void insertProductBatchHistory(int productID, int quantity, double importPrice, Date dateImport, Date dateExpire) {
        String sql = "INSERT INTO ProductBatchHistory (productID, quantity, importPrice, dateImport, dateExpire) VALUES (?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.setInt(2, quantity);
            ps.setDouble(3, importPrice);
            ps.setDate(4, dateImport);
            ps.setDate(5, dateExpire);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("insertProductBatchHistory : " + e.getMessage());
        }
    }

    public boolean deleteProductBatch(int productBatchID) {
        String deleteUsageSQL = "DELETE FROM MaterialBatchUsage WHERE productBatchID = ?";
        String deleteBatchSQL = "DELETE FROM ProductBatch WHERE productBatchID = ?";
        try {
            ps = connection.prepareStatement(deleteUsageSQL);
            ps.setInt(1, productBatchID);
            ps.executeUpdate();
            ps = connection.prepareStatement(deleteBatchSQL);
            ps.setInt(1, productBatchID);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteProductBatch: " + e.getMessage());
        }
        return false;
    }

    public List<ProductComponent> getProductComponentsWithMaterial(int productID) {
        List<ProductComponent> list = new ArrayList<>();
        String sql = "SELECT pc.*, m.name, m.unit, m.pricePerUnit, m.isActive "
                + "FROM ProductComponent pc JOIN Material m ON pc.materialID = m.materialID "
                + "WHERE pc.productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            rs = ps.executeQuery();
            MaterialDAO matedao = new MaterialDAO();
            while (rs.next()) {
                Material mate = new Material();
                mate.setMaterialID(rs.getInt("materialID"));
                mate.setName(rs.getString("name"));
                mate.setUnit(rs.getString("unit"));
                mate.setIsActive(rs.getBoolean("isActive"));

                // Gán danh sách batch cho nguyên liệu
                mate.setBatches(matedao.getBatchesByMaterialID(mate.getMaterialID()));

                ProductComponent pc = new ProductComponent();
                pc.setProductComponentID(rs.getInt("productComponentID"));
                pc.setProductID(rs.getInt("productID"));
                pc.setMaterialID(rs.getInt("materialID"));
                pc.setMaterialQuantity(rs.getInt("materialQuantity"));
                pc.setMaterial(mate);

                list.add(pc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo category có phân trang
    public List<Product> getProductByCategory(String categoryId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p JOIN CategoryProduct cb ON p.productID = cb.productID WHERE cb.categoryID = ? AND p.isActive = TRUE ORDER BY p.productID LIMIT ? OFFSET ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductByCategory (paged): " + e.getMessage());
        }
        return list;
    }

    // Đếm số sản phẩm theo category
    public int countProductByCategory(String categoryId) {
        String sql = "SELECT COUNT(*) FROM Product p JOIN CategoryProduct cb ON p.productID = cb.productID WHERE cb.categoryID = ? AND p.isActive = TRUE";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countProductByCategory: " + e.getMessage());
        }
        return 0;
    }

    public void updateImportPrice(int productBatchID, double avgImportPrice) {
        String sql = "UPDATE ProductBatch SET importPrice = ? WHERE productBatchID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setDouble(1, avgImportPrice);
            ps.setInt(2, productBatchID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateImportPrice" + e.getMessage());
        }
    }
    // Lấy sản phẩm theo category với phân trang

    public List<Product> getProductByCategoryAndIndex(int categoryID, int index) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p "
                + "JOIN CategoryProduct cp ON p.productID = cp.productID "
                + "WHERE cp.categoryID = ? AND p.isActive = TRUE "
                + "ORDER BY p.productID LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryID);
            ps.setInt(2, (index - 1) * 8); // tính offset
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
                        rs.getBoolean(8),
                        batches));
            }
        } catch (SQLException e) {
            System.out.println("getProductByCategoryAndIndex: " + e.getMessage());
        }
        return list;
    }

    // Đếm số sản phẩm theo category
    public int countProductByCategory(int categoryID) {
        String sql = "SELECT COUNT(*) FROM Product p "
                + "JOIN CategoryProduct cp ON p.productID = cp.productID "
                + "WHERE cp.categoryID = ? AND p.isActive = TRUE";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countProductByCategory: " + e.getMessage());
        }
        return 0;
    }
}
