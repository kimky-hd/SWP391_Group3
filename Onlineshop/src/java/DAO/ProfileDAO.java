package DAO;

import Model.Profile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class ProfileDAO extends DBContext {
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private Connection conn = null;
    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Profile getProfileByAccountId(int accountId) {
        String query = "SELECT * FROM Profile WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Profile profile = new Profile();
                profile.setAccountId(rs.getInt("accountID"));
                profile.setFullName(rs.getString("fullName"));
                profile.setPhoneNumber(rs.getString("phoneNumber"));
                profile.setAddress(rs.getString("address"));
                profile.setImg(rs.getString("img"));
                profile.setDob(rs.getDate("DOB"));
                profile.setGender(rs.getString("gender"));
                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return null;
    }
    
    public boolean createProfile(Profile profile) {
        String query = "INSERT INTO Profile (fullName, phoneNumber, address, img, DOB, gender, accountID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, profile.getFullName());
            ps.setString(2, profile.getPhoneNumber());
            ps.setString(3, profile.getAddress());
            ps.setString(4, profile.getImg());
            ps.setDate(5, profile.getDob() != null ? new java.sql.Date(profile.getDob().getTime()) : null);
            ps.setString(6, profile.getGender());
            ps.setInt(7, profile.getAccountId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean updateProfile(Profile profile) {
        String query = "UPDATE Profile SET fullName = ?, phoneNumber = ?, address = ?, img = ?, DOB = ?, gender = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, profile.getFullName());
            ps.setString(2, profile.getPhoneNumber());
            ps.setString(3, profile.getAddress());
            ps.setString(4, profile.getImg());
            ps.setDate(5, profile.getDob() != null ? new java.sql.Date(profile.getDob().getTime()) : null);
            ps.setString(6, profile.getGender());
            ps.setInt(7, profile.getAccountId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean updateField(int accountId, String fieldName, String value) {
        String query = "UPDATE Profile SET " + fieldName + " = ? WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, value);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean profileExists(int accountId) {
        String query = "SELECT COUNT(*) FROM Profile WHERE accountID = ?";
        try {
            conn = getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
    
    public boolean saveOrUpdateProfile(Profile profile) {
        if (profileExists(profile.getAccountId())) {
            return updateProfile(profile);
        } else {
            return createProfile(profile);
        }
    }
}