package Utility; // Package chá»©a lá»›p tiá»‡n Ă­ch gá»­i email

import java.util.Properties; // DĂ¹ng Ä‘á»ƒ cáº¥u hĂ¬nh cĂ¡c thuá»™c tĂ­nh gá»­i mail
import javax.mail.*;          // Lá»›p gá»‘c Ä‘á»ƒ lĂ m viá»‡c vá»›i email
import javax.mail.internet.*; // Há»— trá»£ email dáº¡ng MIME (HTML)

public class EmailSender {

    // Khai bĂ¡o thĂ´ng tin email ngÆ°á»�i gá»­i
    private static final String SENDER_EMAIL = "anhhoang30012004@gmail.com"; // Email ngÆ°á»�i gá»­i
    private static final String SENDER_PASSWORD = "mjsp obnk obye jorx";      // Máº­t kháº©u á»©ng dá»¥ng (App Password)
    private static final String SMTP_HOST = "smtp.gmail.com"; // MĂ¡y chá»§ SMTP cá»§a Gmail
    private static final String SMTP_PORT = "587"; // Cá»•ng SMTP sá»­ dá»¥ng TLS (khĂ´ng pháº£i SSL)

    /**
     * Gá»­i email Ä‘áº·t láº¡i máº­t kháº©u Ä‘áº¿n ngÆ°á»�i dĂ¹ng
     * @param recipientEmail email ngÆ°á»�i nháº­n
     * @param resetToken mĂ£ xĂ¡c nháº­n OTP
     * @param username tĂªn ngÆ°á»�i dĂ¹ng
     * @return true náº¿u gá»­i thĂ nh cĂ´ng, false náº¿u tháº¥t báº¡i
     */
    public static boolean sendResetPasswordEmail(String recipientEmail, String resetToken, String username) {
        // Cáº¥u hĂ¬nh thuá»™c tĂ­nh gá»­i email
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true"); // Báº¯t buá»™c xĂ¡c thá»±c ngÆ°á»�i gá»­i
        props.put("mail.smtp.starttls.enable", "true"); // Sá»­ dá»¥ng TLS báº£o máº­t
        props.put("mail.smtp.host", SMTP_HOST); // MĂ¡y chá»§ gá»­i email
        props.put("mail.smtp.port", SMTP_PORT); // Cá»•ng giao tiáº¿p

        // Táº¡o session cĂ³ xĂ¡c thá»±c vá»›i Gmail
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD); // Ä�Äƒng nháº­p báº±ng email + máº­t kháº©u
            }
        });

        try {
            // Táº¡o email má»›i (Ä‘á»‹nh dáº¡ng MIME)
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL)); // Ä�á»‹a chá»‰ ngÆ°á»�i gá»­i
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail)); // Ä�á»‹a chá»‰ ngÆ°á»�i nháº­n

            // TiĂªu Ä‘á»� email (mĂ£ hoĂ¡ UTF-8)
            message.setSubject(MimeUtility.encodeText("Ä�áº·t láº¡i máº­t kháº©u - Flower Shop", "UTF-8", "B"));

            // Ná»™i dung HTML cá»§a email
            String emailContent = createResetPasswordEmailContent(username, resetToken);
            message.setContent(emailContent, "text/html; charset=UTF-8"); // Ná»™i dung cĂ³ Ä‘á»‹nh dáº¡ng HTML

            // Gá»­i email
            Transport.send(message);
            return true; // ThĂ nh cĂ´ng
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false; // Tháº¥t báº¡i
        }
    }

    /**
     * Gá»­i email thĂ´ng bĂ¡o chung (Ä‘Æ¡n hĂ ng, khuyáº¿n mĂ£i, v.v.)
     */
    public static boolean sendNotificationEmail(String recipientEmail, String subject, String content) {
        // Cáº¥u hĂ¬nh tÆ°Æ¡ng tá»±
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        // Session vá»›i xĂ¡c thá»±c ngÆ°á»�i gá»­i
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
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B")); // TiĂªu Ä‘á»�
            message.setContent(content, "text/html; charset=UTF-8"); // Ná»™i dung HTML

            Transport.send(message);
            return true;
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Táº¡o ná»™i dung email Ä‘áº·t láº¡i máº­t kháº©u dáº¡ng HTML
     */
    private static String createResetPasswordEmailContent(String username, String resetToken) {
        return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
                + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Ä�áº·t láº¡i máº­t kháº©u</h2>"
                + "<p>Xin chĂ o <b>" + username + "</b>,</p>"
                + "<p>ChĂºng tĂ´i nháº­n Ä‘Æ°á»£c yĂªu cáº§u Ä‘áº·t láº¡i máº­t kháº©u cho tĂ i khoáº£n cá»§a báº¡n.</p>"
                + "<p>MĂ£ xĂ¡c nháº­n cá»§a báº¡n lĂ : <b style='font-size: 18px; color: #FF69B4;'>" + resetToken + "</b></p>"
                + "<p>MĂ£ nĂ y sáº½ háº¿t háº¡n sau 10 phĂºt.</p>"
                + "<p>Náº¿u báº¡n khĂ´ng yĂªu cáº§u Ä‘áº·t láº¡i máº­t kháº©u, vui lĂ²ng bá»� qua email nĂ y.</p>"
                + "<p>TrĂ¢n trá»�ng,<br>Ä�á»™i ngÅ© Flower Shop</p>"
                + "</div>";
    }

    /**
     * Gá»­i email xĂ¡c nháº­n Ä‘Æ¡n hĂ ng
     */
    public static boolean sendOrderConfirmationEmail(String recipientEmail, String orderDetails, String customerName, String orderId) {
        // TiĂªu Ä‘á»� + ná»™i dung
        String subject = "XĂ¡c nháº­n Ä‘Æ¡n hĂ ng #" + orderId + " - Flower Shop";
        String content = createOrderConfirmationEmailContent(customerName, orderId, orderDetails);

        // Gá»­i báº±ng phÆ°Æ¡ng thá»©c chung
        return sendNotificationEmail(recipientEmail, subject, content);
    }

    /**
     * Táº¡o ná»™i dung HTML xĂ¡c nháº­n Ä‘Æ¡n hĂ ng
     */
    private static String createOrderConfirmationEmailContent(String customerName, String orderId, String orderDetails) {
        return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
                + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - XĂ¡c nháº­n Ä‘Æ¡n hĂ ng</h2>"
                + "<p>Xin chĂ o <b>" + customerName + "</b>,</p>"
                + "<p>Cáº£m Æ¡n báº¡n Ä‘Ă£ Ä‘áº·t hĂ ng táº¡i Flower Shop. Ä�Æ¡n hĂ ng cá»§a báº¡n Ä‘Ă£ Ä‘Æ°á»£c xĂ¡c nháº­n.</p>"
                + "<p><b>MĂ£ Ä‘Æ¡n hĂ ng:</b> #" + orderId + "</p>"
                + "<div style='background-color: #f9f9f9; padding: 15px; border-radius: 5px;'>"
                + "<h3 style='color: #FF69B4;'>Chi tiáº¿t Ä‘Æ¡n hĂ ng</h3>"
                + orderDetails
                + "</div>"
                + "<p>Náº¿u báº¡n cĂ³ báº¥t ká»³ cĂ¢u há»�i nĂ o, vui lĂ²ng liĂªn há»‡ vá»›i chĂºng tĂ´i.</p>"
                + "<p>TrĂ¢n trá»�ng,<br>Ä�á»™i ngÅ© Flower Shop</p>"
                + "</div>";
    }
}
