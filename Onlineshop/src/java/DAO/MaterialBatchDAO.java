/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.MaterialBatch;
import Model.Supplier;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

}
