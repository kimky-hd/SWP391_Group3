/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.MaterialBatch;
import Model.MaterialBatchUsage;
import Model.MaterialReplacement;
import Model.ProductBatch;
import Model.ProductComponent;
import Model.Supplier;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Duccon
 */
public class MaterialBatchDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

    public List<MaterialBatch> getMaterialBatchByIndex(int indexPage) {
        List<MaterialBatch> list = new ArrayList<>();
        String sql = "SELECT mb.*, m.name AS materialName, s.supplierName AS supplierName\n"
                + "FROM MaterialBatch mb\n"
                + "JOIN Material m ON mb.materialID = m.materialID\n"
                + "JOIN Supplier s ON mb.supplierID = s.supplierID\n"
                + "ORDER BY mb.materialBatchID\n"
                + "LIMIT ?, 10";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, (indexPage - 1) * 10);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new MaterialBatch(rs.getInt(1),
                        rs.getInt(2),
                        rs.getString(8),
                        rs.getInt(3),
                        rs.getDouble(4),
                        rs.getDate(5),
                        rs.getDate(6),
                        rs.getInt(7),
                        rs.getString(9))
                );
            }
        } catch (SQLException e) {
            System.out.println("getMaterialBatchByIndex : " + e.getMessage());
        }
        return list;
    }

    public MaterialBatch getMaterialBatchByID(int materialBatchID) throws SQLException {
        String sql = "SELECT * FROM MaterialBatch WHERE materialBatchID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, materialBatchID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MaterialBatch mb = new MaterialBatch(rs.getInt(1),
                        rs.getInt(2),
                        rs.getInt(3),
                        rs.getDouble(4),
                        rs.getDate(5),
                        rs.getDate(6));
                return mb;
            }
        } catch (SQLException e) {
            System.out.println("getMaterialBatchByID " + e.getMessage());
        }
        return null;
    }

    public int countAllMaterialBatch() {
        String sql = "select count(*) from MaterialBatch";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countAllMaterialBatch" + e.getMessage());
        }
        return 0;
    }

    public List<Supplier> getSupplierActive() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier WHERE isActive = TRUE";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Supplier(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getBoolean(6)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getSupplierActive " + e.getMessage());
        }
        return list;
    }

    public List<Supplier> getAllSupplier() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Supplier(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getBoolean(6)
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllSupplier " + e.getMessage());
        }
        return list;
    }

    public List<MaterialBatch> getMaterialBatchHistoryFiltered(String materialName, Date dateFrom, Date dateTo, String supplierName) {
        List<MaterialBatch> list = new ArrayList<>();
        String sql = "SELECT mb.materialBatchID, mb.materialID, m.name AS materialName, mb.quantity, mb.importPrice, "
                + "mb.dateImport, mb.dateExpire, mb.supplierID, s.supplierName AS supplierName "
                + "FROM MaterialBatch mb "
                + "JOIN Material m ON mb.materialID = m.materialID "
                + "JOIN Supplier s ON mb.supplierID = s.supplierID "
                + "WHERE 1=1 ";

        // Gắn thêm điều kiện động
        if (materialName != null && !materialName.isEmpty()) {
            sql += "AND m.name LIKE ? ";
        }
        if (dateFrom != null) {
            sql += "AND mb.dateImport >= ? ";
        }
        if (dateTo != null) {
            sql += "AND mb.dateImport <= ? ";
        }
        if (supplierName != null && !supplierName.isEmpty()) {
            sql += "AND s.supplierName LIKE ? ";
        }

        try {
            ps = connection.prepareStatement(sql);
            int index = 1;

            if (materialName != null && !materialName.isEmpty()) {
                ps.setString(index++, "%" + materialName + "%");
            }
            if (dateFrom != null) {
                ps.setDate(index++, new java.sql.Date(dateFrom.getTime()));
            }
            if (dateTo != null) {
                ps.setDate(index++, new java.sql.Date(dateTo.getTime()));
            }
            if (supplierName != null && !supplierName.isEmpty()) {
                ps.setString(index++, "%" + supplierName + "%");
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new MaterialBatch(rs.getInt(1),
                        rs.getInt(2),
                        rs.getString(3),
                        rs.getInt(4),
                        rs.getDouble(5),
                        rs.getDate(6),
                        rs.getDate(7),
                        rs.getInt(8),
                        rs.getString(9))
                );
            }
        } catch (SQLException e) {
            System.out.println("getMaterialBatchHistoryFiltered " + e.getMessage());
        }
        return list;
    }

    public List<MaterialBatchUsage> getMaterialUsageByProductBatchID(int productBatchID) throws SQLException {
        List<MaterialBatchUsage> list = new ArrayList<>();
        String sql = "SELECT * FROM MaterialBatchUsage WHERE productBatchID = ?";

        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, productBatchID);
            rs = ps.executeQuery();
            while (rs.next()) {
                MaterialBatchUsage usage = new MaterialBatchUsage();
                usage.setProductBatchID(rs.getInt("productBatchID"));
                usage.setMaterialBatchID(rs.getInt("materialBatchID"));
                usage.setQuantityUsed(rs.getInt("quantityUsed"));
                list.add(usage);
            }
        } catch (SQLException e) {
            System.out.println("getMaterialUsageByProductBatchID " + e.getMessage());
        }
        return list;
    }

    public boolean autoReplaceWiltedMaterials(int productBatchID) throws SQLException {
        String selectWilted = "SELECT mb.materialID, mbu.materialBatchID, mbu.quantityUsed "
                + "FROM MaterialBatchUsage mbu "
                + "JOIN MaterialBatch mb ON mbu.materialBatchID = mb.materialBatchID "
                + "WHERE mb.dateExpire < CURDATE() AND mbu.productBatchID = ?";

        String selectReplacement = "SELECT materialBatchID, quantity "
                + "FROM MaterialBatch "
                + "WHERE materialID = ? AND quantity > 0 AND dateExpire >= CURDATE() "
                + "ORDER BY dateImport ASC";

        String updateOldBatch = "UPDATE MaterialBatch SET quantity = quantity + ? WHERE materialBatchID = ?";
        String updateNewBatch = "UPDATE MaterialBatch SET quantity = quantity - ? WHERE materialBatchID = ?";
        String updateUsage = "UPDATE MaterialBatchUsage SET materialBatchID = ? WHERE productBatchID = ? AND materialBatchID = ?";
        String insertReplacement = "INSERT INTO MaterialReplacement (productBatchID, oldMaterialBatchID, newMaterialBatchID, materialID, quantityReplaced, dateReplaced) "
                + "VALUES (?, ?, ?, ?, ?, CURDATE())";

        boolean success = true;
        connection.setAutoCommit(false);

        try (PreparedStatement psSelectWilted = connection.prepareStatement(selectWilted); PreparedStatement psSelectReplacement = connection.prepareStatement(selectReplacement); PreparedStatement psUpdateOld = connection.prepareStatement(updateOldBatch); PreparedStatement psUpdateNew = connection.prepareStatement(updateNewBatch); PreparedStatement psUpdateUsage = connection.prepareStatement(updateUsage); PreparedStatement psInsertReplacement = connection.prepareStatement(insertReplacement)) {

            psSelectWilted.setInt(1, productBatchID);
            ResultSet rsWilted = psSelectWilted.executeQuery();

            while (rsWilted.next()) {
                int materialID = rsWilted.getInt("materialID");
                int oldBatchID = rsWilted.getInt("materialBatchID");
                int quantityNeeded = rsWilted.getInt("quantityUsed");

                // Tìm batch mới thay thế
                psSelectReplacement.setInt(1, materialID);
                ResultSet rsNewBatch = psSelectReplacement.executeQuery();

                boolean foundReplacement = false;
                while (rsNewBatch.next()) {
                    int newBatchID = rsNewBatch.getInt("materialBatchID");
                    int availableQuantity = rsNewBatch.getInt("quantity");

                    if (availableQuantity >= quantityNeeded) {
                        // 1. Trả lại vào lô cũ
                        psUpdateOld.setInt(1, quantityNeeded);
                        psUpdateOld.setInt(2, oldBatchID);
                        psUpdateOld.executeUpdate();

                        // 2. Trừ từ lô mới
                        psUpdateNew.setInt(1, quantityNeeded);
                        psUpdateNew.setInt(2, newBatchID);
                        psUpdateNew.executeUpdate();

                        // 3. Cập nhật usage
                        psUpdateUsage.setInt(1, newBatchID);
                        psUpdateUsage.setInt(2, productBatchID);
                        psUpdateUsage.setInt(3, oldBatchID);
                        psUpdateUsage.executeUpdate();

                        // 4. Ghi log replacement
                        psInsertReplacement.setInt(1, productBatchID);
                        psInsertReplacement.setInt(2, oldBatchID);
                        psInsertReplacement.setInt(3, newBatchID);
                        psInsertReplacement.setInt(4, materialID);
                        psInsertReplacement.setInt(5, quantityNeeded);
                        psInsertReplacement.executeUpdate();

                        foundReplacement = true;
                        break;
                    }
                }

                if (!foundReplacement) {
                    success = false;
                    break; // Không tìm được nguyên liệu thay thế -> hủy toàn bộ
                }
            }

            if (success) {
                connection.commit();
            } else {
                connection.rollback();
            }

        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }

        return success;
    }

    public List<MaterialReplacement> autoReplaceWiltedMaterial(int productBatchID) throws SQLException {
        List<MaterialReplacement> replacements = new ArrayList<>();

        // 1. Lấy ProductBatch
        ProductBatchDAO pbdao = new ProductBatchDAO();
        ProductBatch batch = pbdao.getProductBatchByID(productBatchID);
        if (batch == null) {
            return replacements;
        }

        int productID = batch.getProductID();
        int quantityToRecover = batch.getQuantity();

        // 2. Lấy công thức sản phẩm
        ProductDAO pdao = new ProductDAO();
        List<ProductComponent> components = pdao.getProductComponentsByProductID(productID);

        for (ProductComponent pc : components) {
            int materialID = pc.getMaterial().getMaterialID();
            int totalNeeded = pc.getMaterialQuantity() * quantityToRecover;

            // 3. Lấy các MaterialBatch còn sử dụng được theo FIFO
            MaterialDAO mbdao = new MaterialDAO();
            List<MaterialBatch> availableBatches = mbdao.getAvailableMaterialBatches(materialID); // status = 'Tươi mới', quantity > 0

            for (MaterialBatch batchAvailable : availableBatches) {
                if (totalNeeded <= 0) {
                    break;
                }

                int deductQty = Math.min(totalNeeded, batchAvailable.getQuantity());

                // Trừ số lượng trong batch
                updateMaterialBatchQuantity(batchAvailable.getMaterialBatchID(), batchAvailable.getQuantity() - deductQty);

                // Ghi nhận thay thế
                MaterialReplacement rep = new MaterialReplacement();
                rep.setProductBatchID(productBatchID);
                rep.setMaterialID(materialID);
                rep.setOldMaterialBatchID(0); // Không cần nếu chỉ quan tâm thay mới
                rep.setNewMaterialBatchID(batchAvailable.getMaterialBatchID());
                rep.setQuantity(deductQty);
                replacements.add(rep);

                totalNeeded -= deductQty;
            }

            // Nếu không đủ nguyên liệu thay thế, rollback những gì đã trừ
            if (totalNeeded > 0) {
                for (MaterialReplacement rep : replacements) {
                    int batchID = rep.getNewMaterialBatchID();
                    MaterialBatch mb = getMaterialBatchByID(batchID);
                    updateMaterialBatchQuantity(batchID, mb.getQuantity() + rep.getQuantity());
                }
                return new ArrayList<>(); // Trả về rỗng để báo lỗi
            }
        }

        return replacements;
    }

    public void updateMaterialBatchQuantity(int batchID, int newQty) throws SQLException {
        String sql = "UPDATE MaterialBatch SET quantity = ? WHERE materialBatchID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, newQty);
            ps.setInt(2, batchID);
            ps.executeUpdate();
        }catch(SQLException e){
            System.out.println("updateMaterialBatchQuantity : " + e.getMessage());
        }
    }

}
