package DAO;

import Model.Blog;
import Model.BlogImg;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext {
    
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    
    private void closeResources() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Tạo blog mới - trả về ID của blog vừa tạo
    public int createBlog(Blog blog) throws SQLException {
        String sql = "INSERT INTO blog (accountID, title, content, blogStatus, dateCreated) VALUES (?, ?, ?, 'Pending', NOW())";
        try {
            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, blog.getAccountID());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getContent());
            
            int result = ps.executeUpdate();
            if (result > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về ID của blog vừa tạo
                }
            }
        } finally {
            closeResources();
        }
        return -1;
    }
    
    // Lấy tất cả blog với phân trang
    public List<Blog> getAllBlogs(int page, int pageSize) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT b.*, (SELECT bi.image FROM blogImg bi WHERE bi.blogID = b.blogID AND bi.IsMain = 1 LIMIT 1) as mainImage " +
                     "FROM blog b ORDER BY b.dateCreated DESC LIMIT ? OFFSET ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setNote(rs.getString("note"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                blog.setMainImage(rs.getString("mainImage"));
                blogs.add(blog);
            }
        } finally {
            closeResources();
        }
        return blogs;
    }
    
    // Tìm kiếm blog theo title
    public List<Blog> searchBlogsByTitle(String keyword, int page, int pageSize) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blog WHERE title LIKE ? ORDER BY dateCreated DESC LIMIT ? OFFSET ?";
        
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setNote(rs.getString("note"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                
                // Lấy ảnh chính của blog
                List<BlogImg> images = getBlogImages(blog.getBlogID());
                if (!images.isEmpty()) {
                    for (BlogImg img : images) {
                        if (img.isMain()) {
                            blog.setMainImage(img.getImage());
                            break;
                        }
                    }
                    if (blog.getMainImage() == null) {
                        blog.setMainImage(images.get(0).getImage());
                    }
                }
                
                blogs.add(blog);
            }
        } finally {
            closeResources();
        }
        return blogs;
    }
    
    // Đếm số blog theo title
    public int countBlogsByTitle(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blog WHERE title LIKE ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Lấy blog theo status
    public List<Blog> getBlogsByStatus(String status, int page, int pageSize) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blog WHERE blogStatus = ? ORDER BY dateCreated DESC LIMIT ? OFFSET ?";
        
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setNote(rs.getString("note"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                
                // Lấy ảnh chính của blog
                List<BlogImg> images = getBlogImages(blog.getBlogID());
                if (!images.isEmpty()) {
                    for (BlogImg img : images) {
                        if (img.isMain()) {
                            blog.setMainImage(img.getImage());
                            break;
                        }
                    }
                    if (blog.getMainImage() == null) {
                        blog.setMainImage(images.get(0).getImage());
                    }
                }
                
                blogs.add(blog);
            }
        } finally {
            closeResources();
        }
        return blogs;
    }
    
    // Đếm số blog theo status
    public int countBlogsByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blog WHERE blogStatus = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Đếm tổng số blog
    public int getTotalBlogsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM blog";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Lấy blog theo ID
    public Blog getBlogById(int blogID) throws SQLException {
        String sql = "SELECT * FROM blog WHERE blogID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setNote(rs.getString("note"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                
                // Lấy danh sách ảnh của blog
                blog.setBlogImages(getBlogImages(blogID));
                
                // Lấy ảnh chính của blog nếu có
                List<BlogImg> mainImages = getBlogImages(blogID);
                if (!mainImages.isEmpty()) {
                    for (BlogImg img : mainImages) {
                        if (img.isMain()) {
                            blog.setMainImage(img.getImage());
                            break;
                        }
                    }
                    if (blog.getMainImage() == null && !mainImages.isEmpty()) {
                        blog.setMainImage(mainImages.get(0).getImage());
                    }
                }
                
                return blog;
            }
        } finally {
            closeResources();
        }
        return null;
    }
    
    // Cập nhật blog
    public boolean updateBlog(Blog blog) throws SQLException {
        String sql = "UPDATE blog SET title = ?, content = ?, blogStatus = 'Pending' WHERE blogID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setInt(3, blog.getBlogID());
            
            return ps.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }
    
    // Cập nhật status và note của blog (cho Manager)
    public boolean updateBlogStatus(int blogID, String status, String note) throws SQLException {
        String sql = "UPDATE blog SET blogStatus = ?, Note = ? WHERE blogID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, blogID);
            
            return ps.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }
    
    // Xóa blog và tất cả ảnh liên quan
    public boolean deleteBlog(int blogID) throws SQLException {
        String sql = "DELETE FROM blog WHERE blogID = ?";
        try {
            // Ảnh sẽ tự động bị xóa do CASCADE constraint
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogID);
            
            return ps.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }
    
    // Thêm ảnh vào blog
    public boolean addBlogImage(BlogImg blogImg) throws SQLException {
        String sql = "INSERT INTO blogImg (blogID, image, IsMain, datePosted) VALUES (?, ?, ?, NOW())";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogImg.getBlogID());
            ps.setString(2, blogImg.getImage());
            ps.setBoolean(3, blogImg.isMain());
            
            return ps.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }
    
    // Lấy tất cả ảnh của blog
    public List<BlogImg> getBlogImages(int blogID) throws SQLException {
        List<BlogImg> images = new ArrayList<>();
        String sql = "SELECT * FROM blogImg WHERE blogID = ? ORDER BY IsMain DESC, datePosted ASC";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogID);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                BlogImg img = new BlogImg();
                img.setBlogImgID(rs.getInt("blogImgID"));
                img.setBlogID(rs.getInt("blogID"));
                img.setImage(rs.getString("image"));
                img.setMain(rs.getBoolean("IsMain"));
                img.setDatePosted(rs.getTimestamp("datePosted"));
                images.add(img);
            }
        } finally {
            closeResources();
        }
        return images;
    }
    
    // Xóa ảnh cụ thể
    public boolean deleteBlogImage(int blogImgID) throws SQLException {
        String sql = "DELETE FROM blogImg WHERE blogImgID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogImgID);
            
            return ps.executeUpdate() > 0;
        } finally {
            closeResources();
        }
    }
    
    // Đặt ảnh chính
    public boolean setMainImage(int blogID, int blogImgID) throws SQLException {
        try {
            connection.setAutoCommit(false);
            
            // Bỏ main của tất cả ảnh trong blog
            String sql1 = "UPDATE blogImg SET IsMain = 0 WHERE blogID = ?";
            ps = connection.prepareStatement(sql1);
            ps.setInt(1, blogID);
            ps.executeUpdate();
            ps.close();
            
            // Đặt ảnh được chọn làm main
            String sql2 = "UPDATE blogImg SET IsMain = 1 WHERE blogImgID = ?";
            ps = connection.prepareStatement(sql2);
            ps.setInt(1, blogImgID);
            int result = ps.executeUpdate();
            
            connection.commit();
            return result > 0;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
            closeResources();
        }
    }
    
    // Tìm kiếm blog theo title
    public List<Blog> searchBlogs(String keyword, int page, int pageSize) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT b.*, (SELECT bi.image FROM blogImg bi WHERE bi.blogID = b.blogID AND bi.IsMain = 1 LIMIT 1) as mainImage " +
                     "FROM blog b WHERE b.title LIKE ? ORDER BY b.dateCreated DESC LIMIT ? OFFSET ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setNote(rs.getString("note"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                blog.setMainImage(rs.getString("mainImage"));
                blogs.add(blog);
            }
        } finally {
            closeResources();
        }
        return blogs;
    }
    
    // Đếm số blog tìm được
    public int getSearchResultCount(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM blog WHERE title LIKE ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            closeResources();
        }
        return 0;
    }
    
    // Lấy ảnh theo ID
    public BlogImg getBlogImageById(int blogImgID) throws SQLException {
        String sql = "SELECT * FROM blogImg WHERE blogImgID = ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, blogImgID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                BlogImg img = new BlogImg();
                img.setBlogImgID(rs.getInt("blogImgID"));
                img.setBlogID(rs.getInt("blogID"));
                img.setImage(rs.getString("image"));
                img.setMain(rs.getBoolean("IsMain"));
                img.setDatePosted(rs.getTimestamp("datePosted"));
                return img;
            }
        } finally {
            closeResources();
        }
        return null;
    }
    public List<Blog> getAllBlogsForGuest(int page, int pageSize) throws SQLException {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT b.*, (SELECT bi.image FROM blogImg bi WHERE bi.blogID = b.blogID AND bi.IsMain = 1 LIMIT 1) as mainImage " +
                     "FROM blog b WHERE b.blogStatus = 'Approved' ORDER BY b.dateCreated DESC LIMIT ? OFFSET ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("blogID"));
                blog.setAccountID(rs.getInt("accountID"));
                blog.setTitle(rs.getString("title"));
                blog.setContent(rs.getString("content"));
                blog.setBlogStatus(rs.getString("blogStatus"));
                blog.setNote(rs.getString("note"));
                blog.setDateCreated(rs.getTimestamp("dateCreated"));
                blog.setMainImage(rs.getString("mainImage"));
                blogs.add(blog);
            }
        } finally {
            closeResources();
        }
        return blogs;
    }
}
