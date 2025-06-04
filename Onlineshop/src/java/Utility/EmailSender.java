package Utility;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

/**
 * Lớp tiện ích để gửi email trong ứng dụng
 * Cung cấp các phương thức tĩnh để gửi các loại email khác nhau
 */
public class EmailSender {
    // Thông tin cấu hình email
    private static final String SENDER_EMAIL = "anhhoang30012004@gmail.com"; // Thay bằng email của bạn
    private static final String SENDER_PASSWORD = "mjsp obnk obye jorx"; // Thay bằng mật khẩu ứng dụng
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    /**
     * Gửi email đặt lại mật khẩu
     * 
     * @param recipientEmail Email người nhận
     * @param resetToken Mã xác nhận đặt lại mật khẩu
     * @param username Tên người dùng
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendResetPasswordEmail(String recipientEmail, String resetToken, String username) {
        // Thiết lập thuộc tính
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        
        // Tạo session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
        
        try {
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Đặt lại mật khẩu - Flower Shop");
            
            // Nội dung email
            String emailContent = createResetPasswordEmailContent(username, resetToken);
            message.setContent(emailContent, "text/html; charset=UTF-8");
            
            // Gửi email
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email thông báo
     * 
     * @param recipientEmail Email người nhận
     * @param subject Tiêu đề email
     * @param content Nội dung email (HTML)
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendNotificationEmail(String recipientEmail, String subject, String content) {
        // Thiết lập thuộc tính
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        
        // Tạo session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
        
        try {
            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=UTF-8");
            
            // Gửi email
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tạo nội dung email đặt lại mật khẩu
     * 
     * @param username Tên người dùng
     * @param resetToken Mã xác nhận đặt lại mật khẩu
     * @return Nội dung email dạng HTML
     */
    private static String createResetPasswordEmailContent(String username, String resetToken) {
        return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
                + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Đặt lại mật khẩu</h2>"
                + "<p>Xin chào <b>" + username + "</b>,</p>"
                + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                + "<p>Mã xác nhận của bạn là: <b style='font-size: 18px; color: #FF69B4;'>" + resetToken + "</b></p>"
                + "<p>Mã này sẽ hết hạn sau 10 phút.</p>"
                + "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>"
                + "<p>Trân trọng,<br>Đội ngũ Flower Shop</p>"
                + "</div>";
    }
    
    /**
     * Gửi email xác nhận đơn hàng
     * 
     * @param recipientEmail Email người nhận
     * @param orderDetails Thông tin chi tiết đơn hàng
     * @param customerName Tên khách hàng
     * @param orderId Mã đơn hàng
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendOrderConfirmationEmail(String recipientEmail, String orderDetails, String customerName, String orderId) {
        String subject = "Xác nhận đơn hàng #" + orderId + " - Flower Shop";
        String content = createOrderConfirmationEmailContent(customerName, orderId, orderDetails);
        return sendNotificationEmail(recipientEmail, subject, content);
    }
    
    /**
     * Tạo nội dung email xác nhận đơn hàng
     * 
     * @param customerName Tên khách hàng
     * @param orderId Mã đơn hàng
     * @param orderDetails Thông tin chi tiết đơn hàng
     * @return Nội dung email dạng HTML
     */
    private static String createOrderConfirmationEmailContent(String customerName, String orderId, String orderDetails) {
        return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
                + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Xác nhận đơn hàng</h2>"
                + "<p>Xin chào <b>" + customerName + "</b>,</p>"
                + "<p>Cảm ơn bạn đã đặt hàng tại Flower Shop. Đơn hàng của bạn đã được xác nhận.</p>"
                + "<p><b>Mã đơn hàng:</b> #" + orderId + "</p>"
                + "<div style='background-color: #f9f9f9; padding: 15px; border-radius: 5px;'>"
                + "<h3 style='color: #FF69B4;'>Chi tiết đơn hàng</h3>"
                + orderDetails
                + "</div>"
                + "<p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.</p>"
                + "<p>Trân trọng,<br>Đội ngũ Flower Shop</p>"
                + "</div>";
    }
}