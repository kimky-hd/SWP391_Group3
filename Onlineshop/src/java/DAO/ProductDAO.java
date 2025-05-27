/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Color;
import Model.Product;
import Model.Season;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import Model.WishList;

/**
 *
 * @author Admin
 */
public class ProductDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<>();
        String sql = "Select * from Product";
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
                        rs.getDate(11)));
            }
        } catch (SQLException e) {
            System.out.println("getAllProduct" + e.getMessage());
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "Select * from product where [productID] = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, 1);
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
                        rs.getDate(11));
            }
        } catch (SQLException e) {
            System.out.println("getProductById" + e.getMessage());
        }
        return null;

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
                        rs.getDate(11)));
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
                        rs.getDate(11)));
            }
        } catch (SQLException e) {
            System.out.println("getProductBySeason" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByColorAndSeason(String colorName, String seasonName) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p "
                + "JOIN PhanLoaiTheoColor c ON p.colorID = c.colorID "
                + "JOIN PhanLoaiTheoSeason s ON p.seasonID = s.seasonID "
                + "WHERE c.colorName = ? AND s.seasonName = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, colorName);
            ps.setString(2, seasonName);
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
                        rs.getDate(11)));
            }
        } catch (SQLException e) {
            System.out.println("getProductByColorAndSeason" + e.getMessage());
        }
        return list;
    }

    public List<Product> getProductByTitle(String title) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE title LIKE ?";
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
                        rs.getDate(11)));
            }
        } catch (SQLException e) {
            System.out.println("getProductByTitle" + e.getMessage());
        }
        return list;
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
                + "            unit,\n"
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
            ps.setString(8, newproduct.getUnit());
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
                + "            unit = ?,\n"
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
            ps.setString(8, updateproduct.getUnit());
            ps.setDate(9, new java.sql.Date(updateproduct.getDateImport().getTime()));
            ps.setDate(10, new java.sql.Date(updateproduct.getDateExpire().getTime()));
            ps.setInt(11, updateproduct.getProductID());
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("updateProduct" + e.getMessage());
        }
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
        String sql = "SELECT * FROM Product ORDER BY productID LIMIT ?, 8";
        try {
            
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 8); // tính offset
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8),
                        rs.getString(9),
                        rs.getDate(10),
                        rs.getDate(11)
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
}
