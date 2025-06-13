package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.Blog;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class BlogDAO extends DBContext {

    public BlogDAO() {
        super(); // Gọi tới constructor của DBContext để khởi tạo connection
    }

    // Lấy tất cả blog (không phân trang)
    public List<Blog> getAllBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY datePosted DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Blog(
                        rs.getInt("blogID"),
                        rs.getInt("accountID"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getString("datePosted")
                ));
            }
        }
        return list;
    }

    // Thêm blog mới
    public void addBlog(Blog blog) throws Exception {
        String sql = "INSERT INTO Blog(accountID, title, content, image) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blog.getAccountID());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getContent());
            ps.setString(4, blog.getImage());
            ps.executeUpdate();
        }
    }

    // Xóa blog theo ID
    public void deleteBlog(int blogID) throws Exception {
        String sql = "DELETE FROM Blog WHERE blogID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy Blog với ID = " + blogID + " để xóa.");
            }
        }
    }

    // Cập nhật blog
    public boolean updateBlog(Blog blog) throws SQLException {
        String query = "UPDATE Blog SET Title = ?, Content = ?, Image = ?, DatePosted = ? WHERE BlogID = ?";
        PreparedStatement ps = null;
        boolean success = false;

        try {
            ps = connection.prepareStatement(query);

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getImage());
            ps.setString(4, blog.getDatePosted()); // Set String directly
            ps.setInt(5, blog.getBlogID());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
            }
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                    System.err.println("Lỗi khi đóng PreparedStatement: " + e.getMessage());
                }
            }
        }
        return success;
    }

    // Lấy tổng số bản ghi trong bảng Blog
    public int getTotalBlogCount() throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM Blog";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // (pagination)
    // pageIndex: trang hiện tại (bắt đầu từ 1)
    // pageSize : số bản ghi trên mỗi trang
    public List<Blog> getBlogsByPage(int pageIndex, int pageSize) throws Exception {
        List<Blog> list = new ArrayList<>();
        // MySQL: LIMIT ? OFFSET ?
        String sql = "SELECT * FROM Blog ORDER BY datePosted DESC LIMIT ? OFFSET ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (pageIndex - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Blog(
                            rs.getInt("blogID"),
                            rs.getInt("accountID"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getString("datePosted")
                    ));
                }
            }
        }
        return list;
    }

    public Blog getBlogByID(int blogID) throws Exception {
        String sql = "SELECT * FROM Blog WHERE blogID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Giả sử trong Model.Blog có constructor:
                    // Blog(int blogID, int accountID, String title, String content, String image, String datePosted)
                    return new Blog(
                            rs.getInt("blogID"),
                            rs.getInt("accountID"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getString("datePosted")
                    );
                }
            }
        }
        return null; // nếu không tìm thấy bài nào với ID đó
    }

    public int getTotalBlogCountByTitle(String keyword) throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM Blog WHERE title LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    /**
     * Lấy danh sách Blog theo trang, với điều kiện title LIKE keyword, ORDER BY
     * datePosted DESC, LIMIT pageSize OFFSET (pageIndex-1)*pageSize.
     */
    public List<Blog> getBlogsByTitleByPage(String keyword, int pageIndex, int pageSize) throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog WHERE title LIKE ? ORDER BY datePosted DESC LIMIT ? OFFSET ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (pageIndex - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Blog(
                            rs.getInt("blogID"),
                            rs.getInt("accountID"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getString("datePosted")
                    ));
                }
            }
        }
        return list;
    }

// --- HÀM MAIN ĐỂ TEST CHỨC NĂNG ADD BLOG ---
//    public static void main(String[] args) {
//        BlogDAO dao = null; 
//        try {
//            dao = new BlogDAO();
//
//            System.out.println("--- BẮT ĐẦU TEST CHỨC NĂNG ADD BLOG ---");
//
//            int initialCount = dao.getTotalBlogCount();
//            System.out.println("Tổng số blog ban đầu: " + initialCount);
//
//            Blog newBlog = new Blog();
//            newBlog.setAccountID(1); 
//            newBlog.setTitle("Bài Blog Test " + System.currentTimeMillis()); 
//            newBlog.setContent("Đây là nội dung của bài blog test, được thêm từ hàm main.");
//            newBlog.setImage("test_image.jpg"); 
//
//            dao.addBlog(newBlog);
//            System.out.println("Đã thêm blog mới thành công!");
//
//            int finalCount = dao.getTotalBlogCount();
//            System.out.println("Tổng số blog sau khi thêm: " + finalCount);
//
//            if (finalCount == initialCount + 1) {
//                System.out.println("Kiểm tra thành công: Số lượng blog đã tăng thêm 1.");
//            } else {
//                System.err.println("Kiểm tra thất bại: Số lượng blog không tăng như mong đợi.");
//            }
//
//            System.out.println("\n--- Danh sách blog sau khi thêm (10 bài gần nhất): ---");
//            List<Blog> latestBlogs = dao.getBlogsByPage(1, 10);
//            for (Blog b : latestBlogs) {
//                System.out.printf("ID: %d | AccountID: %d | Title: \"%s\" | Date: %s%n",
//                        b.getBlogID(), b.getAccountID(), b.getTitle(), b.getDatePosted());
//            }
//
//            System.out.println("--- KẾT THÚC TEST CHỨC NĂNG ADD BLOG ---");
//
//        } catch (SQLException e) {
//            System.err.println("Lỗi SQL: " + e.getMessage());
//            e.printStackTrace();
//        } catch (Exception e) {
//            System.err.println("Đã xảy ra lỗi: " + e.getMessage());
//            e.printStackTrace();
//        } finally {
//            if (dao != null && dao.connection != null) {
//                try {
//                    dao.connection.close();
//                    System.out.println("Đã đóng kết nối cơ sở dữ liệu.");
//                } catch (SQLException e) {
//                    System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
//                }
//            }
//        }
//    }
    // --- HÀM MAIN ĐỂ TEST CHỨC NĂNG UPDATE (Phù hợp với Blog.java sử dụng String datePosted) ---
}
