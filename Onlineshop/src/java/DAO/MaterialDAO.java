/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Material;
import Model.MaterialBatch;
import Model.MaterialBatchUsage;
import Model.Supplier;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Duccon
 */
public class MaterialDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

    public List<MaterialBatch> getBatchesByMaterialID(int materialID) {
        List<MaterialBatch> list = new ArrayList<>();
        String sql = "SELECT * FROM MaterialBatch WHERE materialID = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, materialID);
            ResultSet result = stm.executeQuery();
            while (result.next()) {
                list.add(new MaterialBatch(result.getInt(1),
                        result.getInt(2),
                        result.getInt(3),
                        result.getDouble(4),
                        result.getDate(5),
                        result.getDate(6)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getBatchesByMaterialID : " + e.getMessage());
        }
        return list;
    }

    public List<Material> getMaterialByIndex(int indexPage) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM Material ORDER BY materialID LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 8);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getBoolean(4),
                        batches
                ));
            }
        } catch (SQLException e) {
            System.out.println("getMaterialByIndex : " + e.getMessage());
        }
        return list;
    }

    public List<Material> getAllMaterial() {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM Material WHERE isActive = 1";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getBoolean(4),
                        batches
                ));
            }
        } catch (SQLException e) {
            System.out.println("getMaterialByIndex : " + e.getMessage());
        }
        return list;
    }

    public int countAllMaterial() {
        String sql = "select count(*) from Material";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countAllMaterial" + e.getMessage());
        }
        return 0;
    }

//    public void updateMaterialBatchStatus() {
//        String sql = "UPDATE MaterialBatch SET status = "
//                + "CASE "
//                + "WHEN CURDATE() <= DATE_ADD(dateImport, INTERVAL 3 DAY) THEN 'Tươi mới' "
//                + "WHEN CURDATE() <= dateExpire THEN 'Lão hóa' "
//                + "ELSE 'Đã Héo' END";
//        try {
//            ps = connection.prepareStatement(sql);
//            ps.executeUpdate();
//            
//        } catch (SQLException e) {
//            System.out.println("updateMaterialBatchStatus() " + e.getMessage());
//        }
//    }
    public Material getMaterialByID(int materialID) {
        List<Material> list = new ArrayList<>();
        String sql = "Select * from Material WHERE materialID = ? ";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                return new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getBoolean(4),
                        batches
                );
            }
        } catch (SQLException e) {
            System.out.println("getMaterialByName" + e.getMessage());
        }
        return null;
    }

    public List<Material> getMaterialByName(String txt) {
        List<Material> list = new ArrayList<>();
        String sql = "Select * from Material WHERE name LIKE CONCAT('%" + txt + "%') ";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getBoolean(4),
                        batches
                ));
            }
        } catch (SQLException e) {
            System.out.println("getMaterialByName" + e.getMessage());
        }
        return list;
    }

    public void addNewBatchToMaterial(int materialID, int quantity, double importPrice, Date dateImpport, Date dateExpire, int supplierID) {
        String sql = "INSERT INTO MaterialBatch (materialID, quantity, importPrice, dateImport, dateExpire, supplierID) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            ps.setInt(2, quantity);
            ps.setDouble(3, importPrice);
            ps.setDate(4, new java.sql.Date(dateImpport.getTime()));
            ps.setDate(5, new java.sql.Date(dateExpire.getTime()));
            ps.setInt(6, supplierID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addNewBatchToMaterial" + e.getMessage());
        }
    }

    public int CreateMaterial(String name) {
        String sql = "INSERT INTO Material (\n"
                + "     name,\n"
                + "     unit) \n"
                + "     VALUES (?,'cành', ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("CreateMaterial : " + e.getMessage());
        }
        return 0;
    }

    public boolean CheckDuplicateMaterial(String name) {
        MaterialDAO mateDAO = new MaterialDAO();
        List<Material> listmate = mateDAO.getAllMaterial();
        for (Material m : listmate) {
            if (m.getName().equalsIgnoreCase(name)) {
                return true;
            }
        }
        return false;
    }

    public void updateMaterialIsActive(int materialID, boolean isActive) {
        String sql = "UPDATE Material SET isActive = ? WHERE materialID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, materialID);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateMaterialIsActive : " + e.getMessage());
        }
    }

    public int getAvailableMaterial(int materialID) {
        String sql = "SELECT SUM(quantity) FROM MaterialBatch"
                + "   WHERE materialID = ? AND quantity > 0 ORDER BY dateImport ASC";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getAvailableMaterial" + e.getMessage());
        }
        return 0;
    }

    public List<MaterialBatchUsage> consumeMaterialFIFO(int materialID, int quantity, int productBatchID) throws SQLException {
        List<MaterialBatchUsage> usageList = new ArrayList<>();
        boolean originalAutoCommit = connection.getAutoCommit();
        connection.setAutoCommit(false);

        try {
            String sql = "SELECT materialBatchID, quantity, importPrice, dateImport, dateExpire "
                    + "FROM MaterialBatch "
                    + "WHERE materialID = ? AND quantity > 0 "
                    + "ORDER BY dateImport ASC";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            rs = ps.executeQuery();

            while (rs.next() && quantity > 0) {
                int batchID = rs.getInt("materialBatchID");
                int available = rs.getInt("quantity");
                int consume = Math.min(quantity, available);
                double unitPrice = rs.getDouble("importPrice");
                Date dateImport = rs.getDate("dateImport");
                Date dateExpire = rs.getDate("dateExpire");

                // Trừ lượng nguyên liệu trong MaterialBatch
                try (PreparedStatement update = connection.prepareStatement(
                        "UPDATE MaterialBatch SET quantity = quantity - ? WHERE materialBatchID = ?")) {
                    update.setInt(1, consume);
                    update.setInt(2, batchID);
                    update.executeUpdate();
                }

                // Chèn vào bảng MaterialBatchUsage
                int usageID = 0;
                try (PreparedStatement insert = connection.prepareStatement(
                        "INSERT INTO MaterialBatchUsage (materialBatchID, productBatchID, materialID, quantityUsed, importPrice, dateImport, dateExpire) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                    insert.setInt(1, batchID);
                    insert.setInt(2, productBatchID);
                    insert.setInt(3, materialID);
                    insert.setInt(4, consume);
                    insert.setDouble(5, unitPrice);
                    insert.setDate(6, dateImport);
                    insert.setDate(7, dateExpire);
                    insert.executeUpdate();

                    // Lấy usageID vừa insert
                    try (ResultSet generatedKeys = insert.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            usageID = generatedKeys.getInt(1);
                        }
                    }
                }

                // Thêm vào danh sách trả về
                usageList.add(new MaterialBatchUsage(
                        usageID,
                        batchID,
                        materialID,
                        consume,
                        unitPrice,
                        dateImport,
                        dateExpire
                ));

                quantity -= consume;
            }

            if (quantity > 0) {
                connection.rollback();
                throw new SQLException("Không đủ nguyên liệu để tiêu thụ.");
            }

            connection.commit();
            return usageList;

        } catch (Exception ex) {
            connection.rollback();
            throw ex;
        } finally {
            connection.setAutoCommit(originalAutoCommit);
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
        }
    }

    public List<Material> getSortMaterial(String sortOrder, int pageIndex) {
        List<Material> list = new ArrayList<>();
        String order = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            order = "DESC";
        }
        String sql = "SELECT * FROM Material ORDER BY pricePerUnit " + order + " LIMIT ?, 8";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * 8);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getBoolean(4),
                        batches
                ));
            }
        } catch (SQLException e) {
            System.out.println("getSortMaterial: " + e.getMessage());
        }
        return list;
    }

    public List<MaterialBatch> getMaterialBatchesFIFO(int materialID) {
        List<MaterialBatch> list = new ArrayList<>();
        String sql = "SELECT * FROM MaterialBatch WHERE materialID = ? AND quantity > 0 ORDER BY dateImport ASC";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new MaterialBatch(rs.getInt(1),
                        rs.getInt(2),
                        rs.getInt(3),
                        rs.getDouble(4),
                        rs.getDate(5),
                        rs.getDate(6))
                );
            }
        } catch (SQLException e) {
            System.out.println("getMaterialBatchesFIFO: " + e.getMessage());
        }
        return list;
    }
    
    

}
