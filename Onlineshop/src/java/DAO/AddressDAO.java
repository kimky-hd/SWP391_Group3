package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import DAO.DBContext;

public class AddressDAO extends DBContext {
    
    public List<Map<String, Object>> getCities() {
        List<Map<String, Object>> cities = new ArrayList<>();
        String sql = "SELECT city_id, city_name FROM Cities";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> city = new HashMap<>();
                city.put("id", rs.getString("city_id"));
                city.put("name", rs.getString("city_name"));
                cities.add(city);
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting cities: " + e.getMessage());
        }
        
        return cities;
    }
    
    public List<Map<String, Object>> getDistricts(String cityId) {
        List<Map<String, Object>> districts = new ArrayList<>();
        String sql = "SELECT district_id, district_name FROM Districts WHERE city_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, cityId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> district = new HashMap<>();
                    district.put("id", rs.getString("district_id"));
                    district.put("name", rs.getString("district_name"));
                    districts.add(district);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting districts: " + e.getMessage());
        }
        
        return districts;
    }
    
    public List<Map<String, Object>> getWards(String districtId) {
        List<Map<String, Object>> wards = new ArrayList<>();
        String sql = "SELECT ward_id, ward_name FROM Wards WHERE district_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, districtId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> ward = new HashMap<>();
                    ward.put("id", rs.getString("ward_id"));
                    ward.put("name", rs.getString("ward_name"));
                    wards.add(ward);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error getting wards: " + e.getMessage());
        }
        
        return wards;
    }
}