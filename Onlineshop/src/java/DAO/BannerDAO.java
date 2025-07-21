package DAO;

import Model.Banner;
import java.sql.*;
import java.util.*;

public class BannerDAO extends DBContext {
    public List<Banner> getAllBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banner ORDER BY displayOrder ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Banner b = new Banner(
                    rs.getInt("bannerID"),
                    rs.getString("title"),
                    rs.getString("image"),
                    rs.getString("description"),
                    rs.getString("link"),
                    rs.getBoolean("isActive"),
                    rs.getInt("displayOrder")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Banner> getActiveBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banner WHERE isActive = TRUE ORDER BY displayOrder ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Banner b = new Banner(
                    rs.getInt("bannerID"),
                    rs.getString("title"),
                    rs.getString("image"),
                    rs.getString("description"),
                    rs.getString("link"),
                    rs.getBoolean("isActive"),
                    rs.getInt("displayOrder")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public void addBanner(Banner b) {
        String sql = "INSERT INTO Banner (title, image, description, link, isActive, displayOrder) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getImage());
            ps.setString(3, b.getDescription());
            ps.setString(4, b.getLink());
            ps.setBoolean(5, b.isActive());
            ps.setInt(6, b.getDisplayOrder());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateBanner(Banner b) {
        String sql = "UPDATE Banner SET title=?, image=?, description=?, link=?, isActive=?, displayOrder=? WHERE bannerID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getImage());
            ps.setString(3, b.getDescription());
            ps.setString(4, b.getLink());
            ps.setBoolean(5, b.isActive());
            ps.setInt(6, b.getDisplayOrder());
            ps.setInt(7, b.getBannerID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void deleteBanner(int id) {
        String sql = "DELETE FROM Banner WHERE bannerID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void setActive(int id, boolean active) {
        String sql = "UPDATE Banner SET isActive=? WHERE bannerID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public List<Banner> getBannersByPage(int page, int pageSize) {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM Banner ORDER BY displayOrder ASC LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Banner b = new Banner(
                    rs.getInt("bannerID"),
                    rs.getString("title"),
                    rs.getString("image"),
                    rs.getString("description"),
                    rs.getString("link"),
                    rs.getBoolean("isActive"),
                    rs.getInt("displayOrder")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public int countAllBanners() {
        String sql = "SELECT COUNT(*) FROM Banner";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}