package DAO;

import java.sql.*;
import Model.Blog;
import java.util.List;
import java.util.ArrayList;

public class BlogDAO extends DBContext {

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

    public void deleteBlog(int blogID) throws Exception {
        String sql = "DELETE FROM Blog WHERE blogID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            ps.executeUpdate();
        }
    }

    public void updateBlog(Blog blog) throws Exception {
        String sql = "UPDATE Blog SET title = ?, content = ?, image = ? WHERE blogID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getImage());
            ps.setInt(4, blog.getBlogID());
            ps.executeUpdate();
        }
    }
}
