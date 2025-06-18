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
import Model.Product;
import Model.Season;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import Model.WishList;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class ProductDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;
    private final String statuscase = "CASE "
            + " WHEN CURDATE() <= DATE_ADD(dateImport, INTERVAL 3 DAY) THEN 'Tươi mới' "
            + " WHEN CURDATE() <= dateExpire THEN 'Lão hóa' "
            + " ELSE 'Đã Héo' "
            + "END AS status";

    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT *, " + statuscase + "FROM Product";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllProduct" + e.getMessage());
        }
        return list;
    }

    public Product getProductById(String id) {
        String sql = "Select *," + statuscase + " from product where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12));
            }
        } catch (SQLException e) {
            System.out.println("getProductById" + e.getMessage());
        }
        return null;

    }

    public List<Product> getProductByCategory(String categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*," + statuscase + " FROM Product p\n"
                + "                JOIN CategoryProduct cb ON p.productID = cb.productID \n"
                + "                JOIN Category c ON c.categoryID = cb.categoryID \n"
                + "                WHERE c.categoryID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));
            }
        } catch (SQLException e) {
            System.out.println("getProductByColor" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByColor(String colorId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*," + statuscase + " FROM Product p\n"
                + "                JOIN PhanLoaiTheoColor c ON p.colorID = c.colorID \n"
                + "                WHERE c.colorID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, colorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));
            }
        } catch (SQLException e) {
            System.out.println("getProductByColor" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductBySeason(String seasonId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*," + statuscase + " FROM Product p "
                + "JOIN PhanLoaiTheoSeason s ON p.seasonID = s.seasonID "
                + "WHERE s.seasonID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, seasonId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));
            }
        } catch (SQLException e) {
            System.out.println("getProductBySeason" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByTitle(String txt) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT *," + statuscase + " FROM Product WHERE Title LIKE CONCAT('%" + txt + "%')";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));
            }
        } catch (SQLException e) {
            System.out.println("getProductByTitle" + e.getMessage());
        }
        return list;
    }

    public void addCategoryProduct(int insertedProductID, int categoryID) {
        String sql = "INSERT INTO CategoryProduct \n"
                + "(productID, categoryID) \n"
                + "VALUES \n"
                + "(?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, insertedProductID);
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

    public void addProduct(Product newproduct) {
        String sql = "INSERT INTO Product (\n"
                + "            title,\n"
                + "            image,\n"
                + "            price,\n"
                + "            quantity,\n"
                + "            description,\n"
                + "            colorID,\n"
                + "            seasonID,\n"
                + "            thanhphan,\n"
                + "            dateImport,\n"
                + "            dateExpire\n"
                + "        ) VALUES (\n"
                + "            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?\n"
                + "        )";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            ps.setString(1, newproduct.getTitle());
            ps.setString(2, newproduct.getImage());
            ps.setDouble(3, newproduct.getPrice());
            ps.setInt(4, newproduct.getQuantity());
            ps.setString(5, newproduct.getDescription());
            ps.setInt(6, newproduct.getColorID());
            ps.setInt(7, newproduct.getSeasonID());
            ps.setString(8, newproduct.getThanhphan());
            ps.setDate(9, new java.sql.Date(newproduct.getDateImport().getTime()));
            ps.setDate(10, new java.sql.Date(newproduct.getDateExpire().getTime()));
        } catch (SQLException e) {
            System.out.println("addProduct" + e.getMessage());
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
                + "            quantity = ?,\n"
                + "            description = ?,\n"
                + "            colorID = ?,\n"
                + "            seasonID = ?,\n"
                + "            thanhphan = ?,\n"
                + "            dateImport = ?,\n"
                + "            dateExpire = ?\n"
                + "        WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, updateproduct.getTitle());
            ps.setString(2, updateproduct.getImage());
            ps.setDouble(3, updateproduct.getPrice());
            ps.setInt(4, updateproduct.getQuantity());
            ps.setString(5, updateproduct.getDescription());
            ps.setInt(6, updateproduct.getColorID());
            ps.setInt(7, updateproduct.getSeasonID());
            ps.setString(8, updateproduct.getThanhphan());
            ps.setDate(9, new java.sql.Date(updateproduct.getDateImport().getTime()));
            ps.setDate(10, new java.sql.Date(updateproduct.getDateExpire().getTime()));
            ps.setInt(11, updateproduct.getProductID());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("updateProduct" + e.getMessage());
        }
    }

    public void updateAddQuantity(int quantityAdd, int productID) {
        String sql = "Update product set quantity = quantity + ? where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, quantityAdd);
            ps.setInt(2, productID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateAddQuantity" + e.getMessage());
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

    public List<Product> getProductByIndex(int indexPage) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT *," + statuscase + " FROM Product ORDER BY productID LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 8); // tính offset
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getProductByIndex: " + e.getMessage());
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
        String sql = "SELECT *," + statuscase + " FROM Product \n"
                + "WHERE price >= 0 AND price <= 50000";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));

            }
        } catch (SQLException e) {
            System.out.println("searchPrice0to50" + e.getMessage());
        }
        return list;
    }

    public List<Product> searchPriceAbove50() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT *," + statuscase + " FROM Product \n"
                + "WHERE price > 50000";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)));

            }
        } catch (SQLException e) {
            System.out.println("searchPriceAbove50" + e.getMessage());
        }
        return list;
    }

    public List<Product> searchPriceMinToMax(String priceMin, String priceMax) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT *," + statuscase + " FROM Product \n"
                + "WHERE price >= ? AND price <= ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, priceMin);
            ps.setString(2, priceMax);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)
                ));
            }
        } catch (SQLException e) {
            System.out.println("searchPriceAbove50" + e.getMessage());
        }
        return list;
    }

    public List<Feedback> getAllReviewByProductID(String id) {
        List<Feedback> list = new ArrayList<>();
        String sql = "Select * from Feedback where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, id);
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

    public float getRateByProductID(String id) {
        String sql = "SELECT ROUND(AVG(Rate), 1) AS rate FROM Feedback WHERE productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, id);
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
                + "    p.quantity,\n"
                + "    p.description,\n"
                + "    p.colorID,\n"
                + "    p.seasonID,\n"
                + "    p.thanhphan,\n"
                + "    p.dateImport,\n"
                + "    p.dateExpire\n"
                + " FROM Product p \n"
                + " JOIN Wishlist wl ON p.productID = wl.productID \n"
                + " WHERE wl.AccountID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, accountID);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12))
                );

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

    public List<Product> getSortProduct(String sortOrder) {
        List<Product> list = new ArrayList<>();
        String order = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            order = "DESC";
        }
        String sql = "SELECT *," + statuscase + " FROM Product ORDER BY price " + order;
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11),
                        rs.getString(12)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getSortProduct: " + e.getMessage());
        }
        return list;
    }

}
