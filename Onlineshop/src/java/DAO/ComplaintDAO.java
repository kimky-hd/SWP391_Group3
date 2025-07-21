package DAO;

import Model.Complaint;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO extends DBContext {
    // Lấy tất cả khiếu nại
public List<Complaint> getAllComplaints() {
    List<Complaint> complaints = new ArrayList<>();
    String sql = "SELECT * FROM Complaint ORDER BY dateCreated DESC";
    
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        
        while (rs.next()) {
            Complaint complaint = new Complaint();
            complaint.setComplaintID(rs.getInt("complaintID"));
            complaint.setMaHD(rs.getInt("maHD"));
            complaint.setAccountID(rs.getInt("accountID"));
            complaint.setTitle(rs.getString("title"));
            complaint.setContent(rs.getString("content"));
            complaint.setImage(rs.getString("image"));
            complaint.setStatus(rs.getString("status"));
            complaint.setDateCreated(rs.getTimestamp("dateCreated"));
            complaint.setResponseContent(rs.getString("responseContent"));
            complaint.setDateResolved(rs.getTimestamp("dateResolved"));
            complaints.add(complaint);
        }
    } catch (SQLException e) {
        System.out.println("Error in getAllComplaints: " + e.getMessage());
        e.printStackTrace();
    }
    
    return complaints;
}

// Cập nhật phản hồi khiếu nại
public boolean updateComplaintResponse(Complaint complaint) {
    String sql = "UPDATE Complaint SET responseContent = ?, dateResolved = ?, status = ? WHERE complaintID = ?";
    
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        
        st.setString(1, complaint.getResponseContent());
        st.setTimestamp(2, complaint.getDateResolved());
        st.setString(3, complaint.getStatus());
        st.setInt(4, complaint.getComplaintID());
        
        int result = st.executeUpdate();
        return result > 0;
    } catch (SQLException e) {
        System.out.println("Error in updateComplaintResponse: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    // Tạo khiếu nại mới (chi tiết hơn)
    public int createComplaint(Complaint complaint) {
        String sql = "INSERT INTO Complaint (maHD, accountID, title, content, image, status, dateCreated) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            // Sử dụng PreparedStatement với RETURN_GENERATED_KEYS để lấy ID của khiếu nại vừa tạo
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, complaint.getMaHD());
            st.setInt(2, complaint.getAccountID());
            st.setString(3, complaint.getTitle());
            st.setString(4, complaint.getContent());
            st.setString(5, complaint.getImage()); // Thêm image vào câu lệnh SQL
            st.setString(6, complaint.getStatus() != null ? complaint.getStatus() : "Đang xử lý");
            
            // Nếu dateCreated được cung cấp, sử dụng nó; nếu không, sử dụng thời gian hiện tại
            if (complaint.getDateCreated() != null) {
                st.setTimestamp(7, complaint.getDateCreated());
            } else {
                st.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }
            
            int affectedRows = st.executeUpdate();
            
            if (affectedRows > 0) {
                // Lấy ID của khiếu nại vừa được tạo
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in createComplaint: " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu tạo khiếu nại thất bại
    }

    // Kiểm tra xem người dùng có quyền tạo khiếu nại cho đơn hàng không
    public boolean canCreateComplaint(int maHD, int accountID) {
        // Kiểm tra xem đơn hàng có thuộc về người dùng không
        String sql = "SELECT COUNT(*) FROM HoaDon WHERE maHD = ? AND accountID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maHD);
            st.setInt(2, accountID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Kiểm tra xem đơn hàng đã có khiếu nại chưa
                return !hasComplaintForOrder(maHD);
            }
        } catch (SQLException e) {
            System.out.println("Error in canCreateComplaint: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra thời gian cho phép tạo khiếu nại (ví dụ: chỉ cho phép tạo khiếu nại trong vòng 7 ngày sau khi đơn hàng được giao)
    public boolean isWithinComplaintPeriod(int maHD) {
        String sql = "SELECT ngayXuat, statusID FROM HoaDon WHERE maHD = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maHD);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                // Chỉ cho phép khiếu nại đơn hàng đã giao (statusID = 4: Đã Giao)
                if (rs.getInt("statusID") != 4) {
                    return false;
                }
                
                // Lấy ngày từ database
                java.sql.Date sqlOrderDate = rs.getDate("ngayXuat");
                if (sqlOrderDate != null) {
                    // Chuyển đổi sang LocalDate để tính toán chính xác hơn
                    LocalDate orderDate = sqlOrderDate.toLocalDate();
                    LocalDate currentDate = LocalDate.now();
                    
                    // Tính số ngày giữa hai ngày
                    long daysBetween = ChronoUnit.DAYS.between(orderDate, currentDate);
                    
                    // Debug để kiểm tra
                    System.out.println("Order Date: " + orderDate);
                    System.out.println("Current Date: " + currentDate);
                    System.out.println("Days Between: " + daysBetween);
                    
                    // Cho phép khiếu nại trong vòng 7 ngày
                    return daysBetween <= 7;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in isWithinComplaintPeriod: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Tạo khiếu nại với kiểm tra điều kiện đầy đủ
    public int createComplaintWithValidation(Complaint complaint) {
        // Kiểm tra xem người dùng có quyền tạo khiếu nại cho đơn hàng này không
        if (!canCreateComplaint(complaint.getMaHD(), complaint.getAccountID())) {
            return -2; // Không có quyền hoặc đã có khiếu nại
        }
        
        // Kiểm tra thời gian cho phép khiếu nại
        if (!isWithinComplaintPeriod(complaint.getMaHD())) {
            return -3; // Ngoài thời gian cho phép khiếu nại
        }
        
        // Nếu mọi điều kiện đều hợp lệ, tạo khiếu nại
        return createComplaint(complaint);
    }

    // Lấy tất cả khiếu nại với phân trang
    public List<Complaint> getAllComplaintsWithPaging(int page, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint ORDER BY dateCreated DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            // Skip to the correct page
            int skipCount = (page - 1) * pageSize;
            int currentCount = 0;
            
            while (rs.next()) {
                if (currentCount < skipCount) {
                    currentCount++;
                    continue;
                }
                
                if (complaints.size() >= pageSize) {
                    break;
                }
                
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllComplaintsWithPaging: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }
    
    // Lấy khiếu nại theo ID
    public Complaint getComplaintById(int id) {
        String sql = "SELECT * FROM Complaint WHERE complaintID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                return complaint;
            }
        } catch (SQLException e) {
            System.out.println("Error in getComplaintById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy danh sách khiếu nại theo accountID (khiếu nại của một người dùng cụ thể)
    public List<Complaint> getComplaintsByAccountId(int accountId, int page, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint WHERE accountID = ? ORDER BY dateCreated DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, accountId);
            ResultSet rs = st.executeQuery();
            
            // Skip to the correct page
            int skipCount = (page - 1) * pageSize;
            int currentCount = 0;
            
            while (rs.next()) {
                if (currentCount < skipCount) {
                    currentCount++;
                    continue;
                }
                
                if (complaints.size() >= pageSize) {
                    break;
                }
                
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            System.out.println("Error in getComplaintsByAccountId: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }
    
    // Đếm tổng số khiếu nại
    public int getTotalComplaints() {
        String sql = "SELECT COUNT(*) FROM Complaint";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalComplaints: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Đếm tổng số khiếu nại của một người dùng
    public int getTotalComplaintsByAccountId(int accountId) {
        String sql = "SELECT COUNT(*) FROM Complaint WHERE accountID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, accountId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTotalComplaintsByAccountId: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Thêm khiếu nại mới
    public boolean addComplaint(Complaint complaint) {
        String sql = "INSERT INTO Complaint (maHD, accountID, title, content, image, status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaint.getMaHD());
            st.setInt(2, complaint.getAccountID());
            st.setString(3, complaint.getTitle());
            st.setString(4, complaint.getContent());
            st.setString(5, complaint.getImage()); // Thêm image vào câu lệnh SQL
            st.setString(6, complaint.getStatus() != null ? complaint.getStatus() : "Đang xử lý");
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in addComplaint: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Phản hồi khiếu nại
    public boolean respondToComplaint(int complaintId, String responseContent, String status) {
        String sql = "UPDATE Complaint SET responseContent = ?, status = ?, dateResolved = ? WHERE complaintID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, responseContent);
            st.setString(2, status);
            st.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            st.setInt(4, complaintId);
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in respondToComplaint: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật trạng thái khiếu nại
    public boolean updateComplaintStatus(int complaintId, String status) {
        String sql = "UPDATE Complaint SET status = ? WHERE complaintID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, complaintId);
            
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateComplaintStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Tìm kiếm khiếu nại
    public List<Complaint> searchComplaints(String keyword, int page, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT c.* FROM Complaint c " +
                     "JOIN HoaDon h ON c.maHD = h.maHD " +
                     "JOIN Account a ON c.accountID = a.accountID " +
                     "WHERE c.title LIKE ? OR c.content LIKE ? OR a.username LIKE ? " +
                     "ORDER BY c.dateCreated DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String searchKeyword = "%" + keyword + "%";
            st.setString(1, searchKeyword);
            st.setString(2, searchKeyword);
            st.setString(3, searchKeyword);
            
            ResultSet rs = st.executeQuery();
            
            // Skip to the correct page
            int skipCount = (page - 1) * pageSize;
            int currentCount = 0;
            
            while (rs.next()) {
                if (currentCount < skipCount) {
                    currentCount++;
                    continue;
                }
                
                if (complaints.size() >= pageSize) {
                    break;
                }
                
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            System.out.println("Error in searchComplaints: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }
    
    // Đếm kết quả tìm kiếm
    public int getTotalSearchResults(String keyword) {
        String sql = "SELECT COUNT(*) FROM Complaint c " +
                     "JOIN HoaDon h ON c.maHD = h.maHD " +
                     "JOIN Account a ON c.accountID = a.accountID " +
                     "WHERE c.title LIKE ? OR c.content LIKE ? OR a.username LIKE ?";
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
    
    // Kiểm tra xem đơn hàng đã có khiếu nại chưa
    public boolean hasComplaintForOrder(int maHD) {
        String sql = "SELECT COUNT(*) FROM Complaint WHERE maHD = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maHD);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error in hasComplaintForOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy khiếu nại theo mã hóa đơn
    public Complaint getComplaintByOrderId(int maHD) {
        String sql = "SELECT * FROM Complaint WHERE maHD = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, maHD);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                return complaint;
            }
        } catch (SQLException e) {
            System.out.println("Error in getComplaintByOrderId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy danh sách khiếu nại theo trạng thái
    public List<Complaint> getComplaintsByStatus(String status, int page, int pageSize) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM Complaint WHERE status = ? ORDER BY dateCreated DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            
            // Skip to the correct page
            int skipCount = (page - 1) * pageSize;
            int currentCount = 0;
            
            while (rs.next()) {
                if (currentCount < skipCount) {
                    currentCount++;
                    continue;
                }
                
                if (complaints.size() >= pageSize) {
                    break;
                }
                
                Complaint complaint = new Complaint();
                complaint.setComplaintID(rs.getInt("complaintID"));
                complaint.setMaHD(rs.getInt("maHD"));
                complaint.setAccountID(rs.getInt("accountID"));
                complaint.setTitle(rs.getString("title"));
                complaint.setContent(rs.getString("content"));
                complaint.setImage(rs.getString("image")); // Lấy giá trị image từ database
                complaint.setStatus(rs.getString("status"));
                complaint.setResponseContent(rs.getString("responseContent"));
                complaint.setDateCreated(rs.getTimestamp("dateCreated"));
                complaint.setDateResolved(rs.getTimestamp("dateResolved"));
                
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            System.out.println("Error in getComplaintsByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }
    
    // Đếm số lượng khiếu nại theo trạng thái
    public int countComplaintsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Complaint WHERE status = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countComplaintsByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
