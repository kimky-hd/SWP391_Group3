package Utility; // Package chứa lớp tiện ích gửi email

import java.util.Properties; // Dùng để cấu hình các thuộc tính gửi mail
import javax.mail.*;          // Lớp gốc để làm việc với email
import javax.mail.internet.*; // Hỗ trợ email dạng MIME (HTML)

public class EmailSender {

    // Khai báo thông tin email người gửi
    private static final String SENDER_EMAIL = "anhhoang30012004@gmail.com"; // Email người gửi
    private static final String SENDER_PASSWORD = "mjsp obnk obye jorx";      // Mật khẩu ứng dụng (App Password)
    private static final String SMTP_HOST = "smtp.gmail.com"; // Máy chủ SMTP của Gmail
    private static final String SMTP_PORT = "587"; // Cổng SMTP sử dụng TLS (không phải SSL)

    /**
     * Gửi email đặt lại mật khẩu đến người dùng
     * @param recipientEmail email người nhận
     * @param resetToken mã xác nhận OTP
     * @param username tên người dùng
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public static boolean sendResetPasswordEmail(String recipientEmail, String resetToken, String username) {
        // Cấu hình thuộc tính gửi email
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true"); // Bắt buộc xác thực người gửi
        props.put("mail.smtp.starttls.enable", "true"); // Sử dụng TLS bảo mật
        props.put("mail.smtp.host", SMTP_HOST); // Máy chủ gửi email
        props.put("mail.smtp.port", SMTP_PORT); // Cổng giao tiếp

        // Tạo session có xác thực với Gmail
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD); // Đăng nhập bằng email + mật khẩu
            }
        });

        try {
            // Tạo email mới (định dạng MIME)
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL)); // Địa chỉ người gửi
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail)); // Địa chỉ người nhận

            // Tiêu đề email (mã hoá UTF-8)
            message.setSubject(MimeUtility.encodeText("Đặt lại mật khẩu - Flower Shop", "UTF-8", "B"));

            // Nội dung HTML của email
            String emailContent = createResetPasswordEmailContent(username, resetToken);
            message.setContent(emailContent, "text/html; charset=UTF-8"); // Nội dung có định dạng HTML

            // Gửi email
            Transport.send(message);
            return true; // Thành công
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false; // Thất bại
        }
    }

    /**
     * Gửi email thông báo chung (đơn hàng, khuyến mãi, v.v.)
     */
    public static boolean sendNotificationEmail(String recipientEmail, String subject, String content) {
        // Cấu hình tương tự
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        // Session với xác thực người gửi
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B")); // Tiêu đề
            message.setContent(content, "text/html; charset=UTF-8"); // Nội dung HTML

            Transport.send(message);
            return true;
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tạo nội dung email đặt lại mật khẩu dạng HTML
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
     */
    public static boolean sendOrderConfirmationEmail(String recipientEmail, String orderDetails, String customerName, String orderId) {
        // Tiêu đề + nội dung
        String subject = "Xác nhận đơn hàng #" + orderId + " - Flower Shop";
        String content = createOrderConfirmationEmailContent(customerName, orderId, orderDetails);

        // Gửi bằng phương thức chung
        return sendNotificationEmail(recipientEmail, subject, content);
    }

    /**
     * Tạo nội dung HTML xác nhận đơn hàng
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