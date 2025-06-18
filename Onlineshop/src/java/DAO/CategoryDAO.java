/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Category;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Duccon
 */
public class CategoryDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

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

    public boolean createCategory(String categoryName) {
        String sql = "INSERT INTO Category (categoryName)\n"
                + "VALUES (?)";
        try{
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryName);
            ps.executeUpdate();
            return true;
        }catch (SQLException e){
            System.out.println("createCategory" + e.getMessage());
        }
        return false;
    }
    public boolean CheckDuplicateCategory(String categoryName){
        CategoryDAO cate = new CategoryDAO();
        List<Category> listcate = cate.getAllCategory();
        for(Category o : listcate){
            if(o.getCategoryName().equalsIgnoreCase(categoryName)){
                return true;
            }
        }
        return false;
    }
    
    public boolean deleteCategoryProduct(int categoryID){
        String sql = "DELETE FROM CategoryProduct WHERE categoryID = ?";
        try{
        ps = connection.prepareStatement(sql);
        ps.setInt(1, categoryID);
        ps.executeUpdate();
        return true;
    }catch(SQLException e){
            System.out.println("deleteCategoryProduct" + e.getMessage());
    }
        return false;
    }
    
    public boolean deleteCategory(int categoryID){
        String sql = "DELETE FROM Category WHERE categoryID = ?";
        try{
        ps = connection.prepareStatement(sql);
        ps.setInt(1, categoryID);
        ps.executeUpdate();
        return true;
    }catch(SQLException e){
            System.out.println("deleteCategory" + e.getMessage());
    }
        return false;
    }
    
    public boolean update(int categoryID, String categoryName){
        String sql = "UPDATE Category SET categoryName = ?"
                + "WHERE categoryID = ?";
        try{
            ps = connection.prepareStatement(sql);
            ps.setString(1, categoryName);
            ps.setInt(2, categoryID);
            int rowsUpdated = ps.executeUpdate();
            return true;
        }catch(SQLException e){
            System.out.println("update" + e.getMessage());
        }
        return false;
    }
    
    public List<Category> getCategoryByName(String txt) {
        List<Category> list = new ArrayList<>();
        String sql = "Select * from Category WHERE categoryName LIKE CONCAT('%" + txt + "%') ";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(rs.getInt(1),
                        rs.getString(2)));
            }
        } catch (SQLException e) {
            System.out.println("getCategoryByName" + e.getMessage());
        }
        return list;
    }
}
