/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

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
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
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
        } catch (SQLException ex) {

        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "Select * from product where [productID] = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, 1);
            ResultSet rs = stm.executeQuery();
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

        }
        return null;

    }

    public List<Product> getProductByColor(String colorName) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p "
                + "JOIN PhanLoaiTheoColor c ON p.colorID = c.colorID "
                + "WHERE c.colorName = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, colorName);
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

        }
        return list;
    }

    public List<Product> getProductBySeason(String seasonName) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p "
                + "JOIN PhanLoaiTheoSeason s ON p.séasonID = s.seasonID "
                + "WHERE s.seasonName = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, seasonName);
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

        }

    }

    public void deleteProduct(int productID) {
        String sql = "DELETE FROM PRODUCT Where productID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            ps.executeUpdate();
        } catch (SQLException e) {

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
        try{
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
            
        }catch(SQLException e){
            
        }
    }

}
