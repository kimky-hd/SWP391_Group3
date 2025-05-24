package DAO;

import java.sql.*;
import java.util.*;
import Model.Blog;

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
}
