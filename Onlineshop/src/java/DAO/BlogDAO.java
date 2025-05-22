package dao;

import java.sql.*;
import java.util.*;
import Model.Blog;

public class BlogDAO {

    private Connection getConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/flowershop";
        String user = "root";
        String pass = "";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }

    public List<Blog> getAllBlogs() throws Exception {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Blog(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("author"),
                        rs.getString("created_at")
                ));
            }
        }
        return list;
    }

    public void addBlog(Blog blog) throws Exception {
        String sql = "INSERT INTO Blog(title, content, author) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getAuthor());
            ps.executeUpdate();
        }
    }
}
