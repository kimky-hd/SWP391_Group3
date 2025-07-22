package DAO;

import Model.CardTemplate;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CardTemplateDAO extends DBContext { // Extend DBContext

    public List<CardTemplate> getAllActiveCardTemplates() {
        List<CardTemplate> cardTemplates = new ArrayList<>();
        String sql = "SELECT cardId, cardName, description, price, image, isActive FROM CardTemplate WHERE isActive = TRUE";
        try (Connection conn = getConnection(); // Use getConnection() from DBContext
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CardTemplate card = new CardTemplate();
                card.setCardId(rs.getInt("cardId"));
                card.setCardName(rs.getString("cardName"));
                card.setDescription(rs.getString("description"));
                card.setPrice(rs.getDouble("price"));
                card.setImage(rs.getString("image")); // Set the new image field
                card.setIsActive(rs.getBoolean("isActive"));
                cardTemplates.add(card);
            }
        } catch (SQLException e) { // Removed ClassNotFoundException as it's handled in DBContext
            e.printStackTrace();
        }
        return cardTemplates;
    }
    
    public CardTemplate getCardTemplateById(int cardId) {
        String sql = "SELECT cardId, cardName, description, price, image, isActive FROM CardTemplate WHERE cardId = ?";
        try (Connection conn = getConnection(); // Use getConnection() from DBContext
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cardId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CardTemplate card = new CardTemplate();
                    card.setCardId(rs.getInt("cardId"));
                    card.setCardName(rs.getString("cardName"));
                    card.setDescription(rs.getString("description"));
                    card.setPrice(rs.getDouble("price"));
                    card.setImage(rs.getString("image")); // Set the new image field
                    card.setIsActive(rs.getBoolean("isActive"));
                    return card;
                }
            }
        } catch (SQLException e) { // Removed ClassNotFoundException as it's handled in DBContext
            e.printStackTrace();
        }
        return null;
    }

    public boolean addCardTemplate(CardTemplate card) {
        String sql = "INSERT INTO CardTemplate (cardName, description, price, image, isActive) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, card.getCardName());
            ps.setString(2, card.getDescription());
            ps.setDouble(3, card.getPrice());
            ps.setString(4, card.getImage());
            ps.setBoolean(5, card.isIsActive());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCardTemplate(CardTemplate card) {
        String sql = "UPDATE CardTemplate SET cardName = ?, description = ?, price = ?, image = ?, isActive = ? WHERE cardId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, card.getCardName());
            ps.setString(2, card.getDescription());
            ps.setDouble(3, card.getPrice());
            ps.setString(4, card.getImage());
            ps.setBoolean(5, card.isIsActive());
            ps.setInt(6, card.getCardId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCardTemplateStatus(int cardId, boolean isActive) {
        String sql = "UPDATE CardTemplate SET isActive = ? WHERE cardId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, cardId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCardTemplate(int cardId) {
        String sql = "DELETE FROM CardTemplate WHERE cardId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cardId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
