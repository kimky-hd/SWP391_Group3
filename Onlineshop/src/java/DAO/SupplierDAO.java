package DAO;

import Model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext {
    
    // Lấy tất cả suppliers với phân trang
    public List<Supplier> getAllSuppliersWithPaging(int page, int pageSize) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM supplier ORDER BY supplierID ASC LIMIT ? OFFSET ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, pageSize);
            st.setInt(2, (page - 1) * pageSize);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("supplierID"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setEmail(rs.getString("email"));
                supplier.setAddress(rs.getString("address"));
                supplier.setIsActive(rs.getBoolean("isActive"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllSuppliersWithPaging: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }
    
    // Đếm tổng số suppliers
    public int getTotalSuppliers() {
        String sql = "SELECT COUNT(*) FROM supplier";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalSuppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy supplier theo ID
    public Supplier getSupplierById(int id) {
        String sql = "SELECT * FROM supplier WHERE supplierID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("supplierID"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setEmail(rs.getString("email"));
                supplier.setAddress(rs.getString("address"));
                supplier.setIsActive(rs.getBoolean("isActive"));
                return supplier;
            }
        } catch (SQLException e) {
            System.out.println("Error in getSupplierById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm supplier mới
    public boolean addSupplier(Supplier supplier) {
        String sql = "INSERT INTO supplier (supplierName, phone, email, address, isActive) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, supplier.getSupplierName());
            st.setString(2, supplier.getPhone());
            st.setString(3, supplier.getEmail());
            st.setString(4, supplier.getAddress());
            st.setBoolean(5, supplier.isIsActive());
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in addSupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật supplier
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE supplier SET supplierName = ?, phone = ?, email = ?, address = ?, isActive = ? WHERE supplierID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, supplier.getSupplierName());
            st.setString(2, supplier.getPhone());
            st.setString(3, supplier.getEmail());
            st.setString(4, supplier.getAddress());
            st.setBoolean(5, supplier.isIsActive());
            st.setInt(6, supplier.getSupplierID());
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateSupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Thay đổi trạng thái active/inactive
    public boolean toggleSupplierStatus(int supplierId, boolean status) {
        String sql = "UPDATE supplier SET isActive = ? WHERE supplierID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, status);
            st.setInt(2, supplierId);
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in toggleSupplierStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra email đã tồn tại
    public boolean checkEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM supplier WHERE email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in checkEmailExist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra email đã tồn tại (trừ supplier hiện tại)
    public boolean checkEmailExistExclude(String email, int excludeId) {
        String sql = "SELECT COUNT(*) FROM supplier WHERE email = ? AND supplierID != ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setInt(2, excludeId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in checkEmailExistExclude: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Tìm kiếm suppliers
    public List<Supplier> searchSuppliers(String keyword, int page, int pageSize) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM supplier WHERE supplierName LIKE ? OR email LIKE ? OR phone LIKE ? ORDER BY supplierID DESC LIMIT ? OFFSET ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String searchKeyword = "%" + keyword + "%";
            st.setString(1, searchKeyword);
            st.setString(2, searchKeyword);
            st.setString(3, searchKeyword);
            st.setInt(4, pageSize);
            st.setInt(5, (page - 1) * pageSize);
            
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("supplierID"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setEmail(rs.getString("email"));
                supplier.setAddress(rs.getString("address"));
                supplier.setIsActive(rs.getBoolean("isActive"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.out.println("Error in searchSuppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }
    
    // Đếm kết quả tìm kiếm
    public int getTotalSearchResults(String keyword) {
        String sql = "SELECT COUNT(*) FROM supplier WHERE supplierName LIKE ? OR email LIKE ? OR phone LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String searchKeyword = "%" + keyword + "%";
            st.setString(1, searchKeyword);
            st.setString(2, searchKeyword);
            st.setString(3, searchKeyword);
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalSearchResults: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Lấy tất cả suppliers hoạt động (để sử dụng trong dropdown)
    public List<Supplier> getAllActiveSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM supplier WHERE isActive = 1 ORDER BY supplierName ASC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("supplierID"));
                supplier.setSupplierName(rs.getString("supplierName"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setEmail(rs.getString("email"));
                supplier.setAddress(rs.getString("address"));
                supplier.setIsActive(rs.getBoolean("isActive"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllActiveSuppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }
}
