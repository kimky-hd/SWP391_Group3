/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Material;
import Model.MaterialBatch;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.util.Date;
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
                        result.getDate(6),
                        result.getString(7)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getBatchesByMaterialID : " + e.getMessage());
        }
        return list;
    }

    public List<Material> getMaterialByIndex(int indexPage) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM Material ORDER BY materialID LIMIT ?, 10";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 10);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getBoolean(5),
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
        String sql = "SELECT * FROM Material";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                List<MaterialBatch> batches = getBatchesByMaterialID(rs.getInt(1));
                list.add(new Material(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getBoolean(5),
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

    public void updateMaterialBatchStatus() {
        String sql = "UPDATE MaterialBatch SET status = "
                + "CASE "
                + "WHEN CURDATE() <= DATE_ADD(dateImport, INTERVAL 3 DAY) THEN 'Tươi mới' "
                + "WHEN CURDATE() <= dateExpire THEN 'Lão hóa' "
                + "ELSE 'Đã Héo' END";
        try {
            ps = connection.prepareStatement(sql);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("updateMaterialBatchStatus() " + e.getMessage());
        }
    }

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
                        rs.getDouble(4),
                        rs.getBoolean(5),
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
                        rs.getDouble(4),
                        rs.getBoolean(5),
                        batches
                ));
            }
        } catch (SQLException e) {
            System.out.println("getMaterialByName" + e.getMessage());
        }
        return list;
    }

    public void addNewBatchToMaterial(int materialID, int quantity, double importPrice, Date dateImpport, Date dateExpire) {
        String sql = "INSERT INTO MaterialBatch (materialID, quantity, importPrice, dateImport, dateExpire) VALUES (?, ?, ?, ?, ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialID);
            ps.setInt(2, quantity);
            ps.setDouble(3, importPrice);
            ps.setDate(4, new java.sql.Date(dateImpport.getTime()));
            ps.setDate(5, new java.sql.Date(dateExpire.getTime()));
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addNewBatchToMaterial" + e.getMessage());
        }
    }

    public int CreateMaterial(String name, double pricePerUnit) {
        String sql = "INSERT INTO Material (\n"
                + "     name,\n"
                + "     unit,\n "
                + "     pricePerUnit) \n"
                + "     VALUES (?,'cành', ?)";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            ps.setDouble(2, pricePerUnit);
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

    public Map<Integer, Integer> getMaterialNeeded(int productID, int quantityToAdd) {
        Map<Integer, Integer> result = new HashMap<>();
        String sql = "SELECT materialID, materialQuantity FROM ProductComponent WHERE productID = ?";
        try{
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productID);
            rs = ps.executeQuery();
            while (rs.next()) {
                int mid = rs.getInt("materialID");
                int perProductQantity = rs.getInt("materialQuantity");
                result.put(mid, perProductQantity * quantityToAdd);
            }
        } catch (SQLException e) {
            System.out.println("getMaterialNeeded" + e.getMessage());
        }
        return result;
    }

    public boolean checkEnoughMaterialStock(Map<Integer, Integer> materialNeed) {
        for (Map.Entry<Integer, Integer> entry : materialNeed.entrySet()) {
            int materialID = entry.getKey();
            int neededQty = entry.getValue();
            String sql = "SELECT SUM(quantity) FROM MaterialBatch WHERE materialID = ? AND quantity > 0";
            try  {
                ps = connection.prepareStatement(sql);
                ps.setInt(1, materialID);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) < neededQty) {
                    return false;
                }
            } catch (SQLException e) {
                System.out.println("checkEnoughMaterialStock" + e.getMessage());
            }
        }
        return true;
    }

    public void deductMaterialFromBatch(Map<Integer, Integer> materialNeed) {
        for (Map.Entry<Integer, Integer> entry : materialNeed.entrySet()) {
            int materialID = entry.getKey();
            int qtyToDeduct = entry.getValue();
            String select = "SELECT materialBatchID, quantity FROM MaterialBatch "
                    + "WHERE materialID = ? AND quantity > 0 ORDER BY dateImport ASC";
            try {
                ps = connection.prepareStatement(select, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
                ps.setInt(1, materialID);
                rs = ps.executeQuery();
                while (rs.next() && qtyToDeduct > 0) {
                    int available = rs.getInt("quantity");
                    int deduct = Math.min(available, qtyToDeduct);
                    rs.updateInt("quantity", available - deduct);
                    rs.updateRow();
                    qtyToDeduct -= deduct;
                }
            } catch (SQLException e) {
                System.out.println("deductMaterialFromBatch" + e.getMessage());
            }
        }
    }

    

}
