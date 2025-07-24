package DAO;

import Model.ComplaintImage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintImageDAO extends DBContext {
    
    // Thêm nhiều ảnh cho 1 khiếu nại
    public boolean addImages(int complaintID, List<String> imagePaths) {
        String sql = "INSERT INTO ComplaintImages (complaintID, imagePath) VALUES (?, ?)";
        
        try {
            connection.setAutoCommit(false); // Bắt đầu transaction
            
            PreparedStatement st = connection.prepareStatement(sql);
            
            for (String imagePath : imagePaths) {
                st.setInt(1, complaintID);
                st.setString(2, imagePath);
                st.addBatch();
            }
            
            int[] results = st.executeBatch();
            connection.commit(); // Commit transaction
            
            // Kiểm tra xem tất cả ảnh đã được thêm thành công
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
            
        } catch (SQLException e) {
            try {
                connection.rollback(); // Rollback nếu có lỗi
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Error in addImages: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true); // Khôi phục auto commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Thêm 1 ảnh đơn lẻ
    public boolean addImage(int complaintID, String imagePath) {
        String sql = "INSERT INTO ComplaintImages (complaintID, imagePath) VALUES (?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaintID);
            st.setString(2, imagePath);
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in addImage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy tất cả ảnh của 1 khiếu nại
    public List<ComplaintImage> getImagesByComplaintId(int complaintID) {
    List<ComplaintImage> images = new ArrayList<>();
    String sql = "SELECT * FROM ComplaintImages WHERE complaintID = ? ORDER BY imageID";
    
    System.out.println("🔍 Searching images for complaint ID: " + complaintID);
    
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, complaintID);
        ResultSet rs = st.executeQuery();
        
        int count = 0;
        while (rs.next()) {
            ComplaintImage image = new ComplaintImage();
            image.setImageID(rs.getInt("imageID"));
            image.setComplaintID(rs.getInt("complaintID"));
            image.setImagePath(rs.getString("imagePath"));
            images.add(image);
            count++;
            
            System.out.println("  📷 Found image " + count + ": " + image.getImagePath());
        }
        
        System.out.println("✅ Total images loaded: " + images.size());
        
    } catch (SQLException e) {
        System.out.println("❌ Error in getImagesByComplaintId: " + e.getMessage());
        e.printStackTrace();
    }
    
    return images;
}

    
    // Lấy ảnh đầu tiên của khiếu nại (dùng làm ảnh đại diện)
    public String getFirstImageByComplaintId(int complaintID) {
        String sql = "SELECT imagePath FROM ComplaintImages WHERE complaintID = ? ORDER BY imageID LIMIT 1";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaintID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getString("imagePath");
            }
        } catch (SQLException e) {
            System.out.println("Error in getFirstImageByComplaintId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Đếm số ảnh của 1 khiếu nại
    public int countImagesByComplaintId(int complaintID) {
        String sql = "SELECT COUNT(*) FROM ComplaintImages WHERE complaintID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaintID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countImagesByComplaintId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Xóa ảnh theo ID
    public boolean deleteImage(int imageID) {
        String sql = "DELETE FROM ComplaintImages WHERE imageID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, imageID);
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in deleteImage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa tất cả ảnh của 1 khiếu nại
    public boolean deleteImagesByComplaintId(int complaintID) {
        String sql = "DELETE FROM ComplaintImages WHERE complaintID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaintID);
            
            int result = st.executeUpdate();
            return result >= 0; // >= 0 vì có thể không có ảnh nào để xóa
        } catch (SQLException e) {
            System.out.println("Error in deleteImagesByComplaintId: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy đường dẫn ảnh theo ID (để xóa file)
    public String getImagePathById(int imageID) {
        String sql = "SELECT imagePath FROM ComplaintImages WHERE imageID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, imageID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getString("imagePath");
            }
        } catch (SQLException e) {
            System.out.println("Error in getImagePathById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Lấy ảnh theo ID
    public ComplaintImage getImageById(int imageID) {
        String sql = "SELECT * FROM ComplaintImages WHERE imageID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, imageID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                ComplaintImage image = new ComplaintImage();
                image.setImageID(rs.getInt("imageID"));
                image.setComplaintID(rs.getInt("complaintID"));
                image.setImagePath(rs.getString("imagePath"));
                return image;
            }
        } catch (SQLException e) {
            System.out.println("Error in getImageById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}
