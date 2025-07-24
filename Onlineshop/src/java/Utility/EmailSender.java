package Utility; // Package chứa lớp tiện ích gửi email

import java.util.Properties; // Dùng để cấu hình các thuộc tính gửi mail
import javax.mail.*;          // Lớp gốc để làm việc với email
import javax.mail.internet.*; // Hỗ trợ email dạng MIME (HTML)

import Model.OrderDetail;
import Model.Product;
import DAO.ProductDAO;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class EmailSender {

    // Khai báo thông tin email người gửi
    private static final String SENDER_EMAIL = "anhhoang30012004@gmail.com"; // Email người gửi


    private static final String SENDER_PASSWORD = "eizk toxu knjm uqkz";      // Mật khẩu ứng dụng (App Password)



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
        
        // Thêm các cấu hình bảo mật và timeout
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.connectiontimeout", "10000"); // 10 giây timeout kết nối
        props.put("mail.smtp.timeout", "10000"); // 10 giây timeout đọc
        props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết

        
        // Thêm các cấu hình bảo mật và timeout
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.connectiontimeout", "10000"); // 10 giây timeout kết nối
        props.put("mail.smtp.timeout", "10000"); // 10 giây timeout đọc
        props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết


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


            System.out.println("Email đã được gửi thành công đến " + recipientEmail);


            return true; // Thành công
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            System.err.println("Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false; // Thất bại
        }
    }
    
   /**
 * Gửi email xác minh đăng ký tài khoản
 * @param recipientEmail email người nhận
 * @param verificationCode mã xác nhận
 * @param username tên người dùng
 * @return true nếu gửi thành công, false nếu thất bại
 */
public static boolean sendRegistrationVerificationEmail(String recipientEmail, String verificationCode, String username) {
    // Cấu hình thuộc tính gửi email
    Properties props = new Properties();
    props.put("mail.smtp.auth", "true"); // Bắt buộc xác thực người gửi
    props.put("mail.smtp.starttls.enable", "true"); // Sử dụng TLS bảo mật
    props.put("mail.smtp.host", SMTP_HOST); // Máy chủ gửi email
    props.put("mail.smtp.port", SMTP_PORT); // Cổng giao tiếp
    
    // Thêm các cấu hình bảo mật và timeout
    props.put("mail.smtp.ssl.trust", SMTP_HOST);
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.connectiontimeout", "10000"); // 10 giây timeout kết nối
    props.put("mail.smtp.timeout", "10000"); // 10 giây timeout đọc
    props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết

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
        message.setSubject(MimeUtility.encodeText("Xác minh đăng ký tài khoản - Flower Shop", "UTF-8", "B"));

        // Nội dung HTML của email
        String emailContent = createRegistrationVerificationEmailContent(username, verificationCode);
        message.setContent(emailContent, "text/html; charset=UTF-8"); // Nội dung có định dạng HTML

        // Gửi email
        Transport.send(message);
        System.out.println("Email đã được gửi thành công đến " + recipientEmail);
        return true; // Thành công
    } catch (MessagingException | java.io.UnsupportedEncodingException e) {
        System.err.println("Lỗi gửi email: " + e.getMessage());
        e.printStackTrace();
        return false; // Thất bại
    }
}

/**
 * Tạo nội dung email xác minh đăng ký dạng HTML
 */
private static String createRegistrationVerificationEmailContent(String username, String verificationCode) {
    return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
            + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Xác minh đăng ký tài khoản</h2>"
            + "<p>Xin chào <b>" + username + "</b>,</p>"
            + "<p>Cảm ơn bạn đã đăng ký tài khoản tại Flower Shop. Vui lòng xác minh email của bạn để hoàn tất quá trình đăng ký.</p>"
            + "<p>Mã xác nhận của bạn là: <b style='font-size: 18px; color: #FF69B4;'>" + verificationCode + "</b></p>"
            + "<p>Mã này sẽ hết hạn sau 10 phút.</p>"
            + "<p>Nếu bạn không yêu cầu đăng ký tài khoản, vui lòng bỏ qua email này.</p>"
            + "<p>Trân trọng,<br>Đội ngũ Flower Shop</p>"
            + "</div>";
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
    
    // Thêm các cấu hình bảo mật và timeout
    props.put("mail.smtp.ssl.trust", SMTP_HOST);
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.connectiontimeout", "15000"); // 15 giây timeout kết nối
    props.put("mail.smtp.timeout", "15000"); // 15 giây timeout đọc
    props.put("mail.debug", "true");

    System.out.println("Đang sử dụng SMTP Host: " + SMTP_HOST + ", Port: " + SMTP_PORT);
    System.out.println("Email người gửi: " + SENDER_EMAIL);
    System.out.println("Email người nhận: " + recipientEmail);


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
    System.out.println("Email đã được gửi thành công đến " + recipientEmail);
    return true;
    
} catch (MessagingException | java.io.UnsupportedEncodingException e) {
    System.err.println("Chi tiết lỗi khi gửi email: ");
    System.err.println("- Loại lỗi: " + e.getClass().getSimpleName());
    System.err.println("- Thông báo: " + e.getMessage());
    e.printStackTrace();
    return false;
}
    }
    /**
 * Kiểm tra kết nối đến máy chủ SMTP
 */
public static boolean testEmailConnection() {
    Properties props = new Properties();
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.host", SMTP_HOST);
    props.put("mail.smtp.port", SMTP_PORT);
    props.put("mail.smtp.connectiontimeout", "10000");
    props.put("mail.debug", "true");
    
    try {
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
        
        Transport transport = session.getTransport("smtp");
        transport.connect(SMTP_HOST, SENDER_EMAIL, SENDER_PASSWORD);
        transport.close();
        System.out.println("Kết nối email thành công!");
        return true;
    } catch (MessagingException e) {
        System.err.println("Lỗi kết nối email: " + e.getMessage());
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
    try {
        // Validate input
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Email người nhận không hợp lệ");
            return false;
        }
        
        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = "Khách hàng"; // Giá trị mặc định
        }
        
        // Tiêu đề + nội dung
        String subject = "Xác nhận đơn hàng #" + orderId + " - Flower Shop";
        String content = createOrderConfirmationEmailContent(customerName, orderId, orderDetails);
        
        System.out.println("Chuẩn bị gửi email đến: " + recipientEmail);
        System.out.println("Tiêu đề: " + subject);
        

        // Gửi bằng phương thức chung
        return sendNotificationEmail(recipientEmail, subject, content);
        
    } catch (Exception e) {
        System.err.println("Lỗi trong sendOrderConfirmationEmail: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
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
    
    /**
 * Gửi email thông báo hủy đơn hàng
 */
/**
 * Gửi email thông báo hủy đơn hàng
 */
public static boolean sendOrderCancellationEmail(String recipientEmail, String orderDetails, String customerName, String orderId, String cancelReason) {
    try {
        // Validate input
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            System.err.println("Email người nhận không hợp lệ");
            return false;
           
        }
        
        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = "Khách hàng"; // Giá trị mặc định
        }
        
        // Tiêu đề + nội dung
        String subject = "Thông báo hủy đơn hàng #" + orderId + " - Flower Shop";
        String content = createOrderCancellationEmailContent(customerName, orderId, orderDetails, cancelReason);
        
        System.out.println("Chuẩn bị gửi email hủy đơn hàng đến: " + recipientEmail);
        System.out.println("Tiêu đề: " + subject);
        
        // Gửi bằng phương thức chung
        return sendNotificationEmail(recipientEmail, subject, content);
        
    } catch (Exception e) {
        System.err.println("Lỗi trong sendOrderCancellationEmail: " + e.getMessage());
        e.printStackTrace();
        return false;
       
    }
}

/**
 * Tạo nội dung HTML thông báo hủy đơn hàng
 */
private static String createOrderCancellationEmailContent(String customerName, String orderId, String orderDetails, String cancelReason) {
    return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
            + "<h2 style='color: #FFB6C1; text-align: center;'>Flower Shop - Thông báo hủy đơn hàng</h2>"
            + "<p>Xin chào <b>" + customerName + "</b>,</p>"
            + "<p>Đơn hàng của bạn đã bị hủy.</p>"
            + "<p><b>Mã đơn hàng:</b> #" + orderId + "</p>"
            + (cancelReason != null && !cancelReason.isEmpty() ? "<p><b>Lý do hủy:</b> " + cancelReason + "</p>" : "")
            + "<div style='background-color: #f9f9f9; padding: 15px; border-radius: 5px;'>"
            + "<h3 style='color: #FF69B4;'>Chi tiết đơn hàng đã hủy</h3>"
            + orderDetails
            + "</div>"
            + "<p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.</p>"
            + "<p>Trân trọng,<br>Đội ngũ Flower Shop</p>"
            + "</div>";
}


/**
 * Tạo HTML cho chi tiết đơn hàng để hiển thị trong email
 * @param orderDetails Danh sách chi tiết đơn hàng
 * @return Chuỗi HTML chứa bảng chi tiết đơn hàng
 */
public static String createOrderDetailsHtml(List<OrderDetail> orderDetails) {
    StringBuilder html = new StringBuilder();
    html.append("<table style='width: 100%; border-collapse: collapse;'>");
    html.append("<tr style='background-color: #f2f2f2;'>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: left;'>Sản phẩm</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: center;'>Số lượng</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Đơn giá</th>");
    html.append("<th style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Thành tiền</th>");
    html.append("</tr>");
    
    double totalAmount = 0;
    ProductDAO productDAO = new ProductDAO(); // Tạo đối tượng ProductDAO để lấy thông tin sản phẩm
    
    for (OrderDetail detail : orderDetails) {
        // Lấy thông tin sản phẩm
        Product product = productDAO.getProductById(detail.getProductId());
        String productName = (product != null) ? product.getTitle() : "Sản phẩm không xác định";
        
        double itemTotal = detail.getPrice() * detail.getQuantity();
        totalAmount += itemTotal;
        
        html.append("<tr>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px;'>").append(productName).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: center;'>").append(detail.getQuantity()).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", detail.getPrice())).append("</td>");
        html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", itemTotal)).append("</td>");
        html.append("</tr>");
    }
    
    html.append("<tr style='background-color: #f9f9f9; font-weight: bold;'>");
    html.append("<td colspan='3' style='border: 1px solid #ddd; padding: 8px; text-align: right;'>Tổng cộng:</td>");
    html.append("<td style='border: 1px solid #ddd; padding: 8px; text-align: right;'>").append(String.format("%,.0f VNĐ", totalAmount)).append("</td>");
    html.append("</tr>");
    html.append("</table>");
    
    return html.toString();
}

/**
 * Gửi email thông báo tài khoản mới cho nhân viên
 * @param recipientEmail email của nhân viên
 * @param username tên đăng nhập
 * @param password mật khẩu
 * @param startDate ngày bắt đầu làm việc
 * @param endDate ngày kết thúc hợp đồng
 * @return true nếu gửi thành công, false nếu thất bại
 */
public static boolean sendNewStaffAccountEmail(String recipientEmail, String username, 
                                              String password, Date startDate, Date endDate) {
    // Cấu hình thuộc tính gửi email
    Properties props = new Properties();
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.host", SMTP_HOST);
    props.put("mail.smtp.port", SMTP_PORT);
    
    // Thêm các cấu hình bảo mật và timeout
    props.put("mail.smtp.ssl.trust", SMTP_HOST);
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.connectiontimeout", "10000");
    props.put("mail.smtp.timeout", "10000");
    props.put("mail.debug", "true");

    // Tạo session có xác thực với Gmail
    Session session = Session.getInstance(props, new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
        }
    });

    try {
        // Tạo email mới (định dạng MIME)
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));

        // Tiêu đề email (mã hoá UTF-8)
        message.setSubject(MimeUtility.encodeText("Thông tin tài khoản nhân viên mới", "UTF-8", "B"));

        // Nội dung HTML của email
        String emailContent = createNewStaffAccountEmailContent(username, password, startDate, endDate);
        message.setContent(emailContent, "text/html; charset=UTF-8");

        // Gửi email
        Transport.send(message);
        System.out.println("Email thông báo tài khoản nhân viên mới đã được gửi thành công đến " + recipientEmail);
        return true;
    } catch (MessagingException | java.io.UnsupportedEncodingException e) {
        System.err.println("Lỗi gửi email thông báo tài khoản nhân viên: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Tạo nội dung email thông báo tài khoản nhân viên mới
 */
private static String createNewStaffAccountEmailContent(String username, String password, 
                                                      Date startDate, Date endDate) {
    // Format ngày tháng
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
    String startDateStr = startDate != null ? sdf.format(startDate) : "Chưa xác định";
    String endDateStr = endDate != null ? sdf.format(endDate) : "Chưa xác định";
    
    return "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #f0f0f0; border-radius: 10px;'>"
            + "<h2 style='color: #4CAF50; text-align: center;'>Thông Tin Tài Khoản Nhân Viên Mới</h2>"
            + "<p>Xin chào <b>" + username + "</b>,</p>"
            + "<p>Chúc mừng bạn đã trở thành thành viên của công ty chúng tôi. Dưới đây là thông tin tài khoản của bạn:</p>"
            + "<div style='background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 15px 0;'>"
            + "<p><b>Tên đăng nhập:</b> " + username + "</p>"
            + "<p><b>Mật khẩu:</b> " + password + "</p>"
            + "<p><b>Ngày bắt đầu làm việc:</b> " + startDateStr + "</p>"
            + "<p><b>Ngày kết thúc hợp đồng:</b> " + endDateStr + "</p>"
            + "</div>"
            + "<p style='color: #FF5722; font-weight: bold;'>Lưu ý: Vui lòng đổi mật khẩu của bạn sau khi đăng nhập lần đầu để đảm bảo an toàn.</p>"
            + "<p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với quản lý trực tiếp của bạn.</p>"
            + "<p>Trân trọng,<br>Ban Quản Lý</p>"
            + "</div>";
}
/**
 * Gửi email thông báo tài khoản mới cho shipper
 * 
 * @param recipientEmail Email của shipper mới
 * @param username Tên đăng nhập của shipper
 * @param password Mật khẩu của shipper
 * @param startDate Ngày bắt đầu làm việc
 * @param endDate Ngày kết thúc hợp đồng (có thể null)
 * @return true nếu gửi email thành công, false nếu thất bại
 */
public static boolean sendNewShipperAccountEmail(String recipientEmail, String username, String password, 
                                               Date startDate, Date endDate) {
    // Cấu hình thuộc tính gửi email
    Properties props = new Properties();
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.host", SMTP_HOST);
    props.put("mail.smtp.port", SMTP_PORT);
    
    // Thêm các cấu hình bảo mật và timeout
    props.put("mail.smtp.ssl.trust", SMTP_HOST);
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.connectiontimeout", "10000");
    props.put("mail.smtp.timeout", "10000");
    props.put("mail.debug", "true");

    // Tạo session có xác thực với Gmail
    Session session = Session.getInstance(props, new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
        }
    });

    try {
        // Tạo email mới (định dạng MIME)
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));

        // Tiêu đề email (mã hoá UTF-8)
        message.setSubject(MimeUtility.encodeText("Chào mừng bạn trở thành Shipper mới của chúng tôi", "UTF-8", "B"));

        // Nội dung HTML của email
        String emailContent = createNewShipperAccountEmailContent(username, password, startDate, endDate);
        message.setContent(emailContent, "text/html; charset=UTF-8");

        // Gửi email
        Transport.send(message);
        System.out.println("Email thông báo tài khoản shipper mới đã được gửi thành công đến " + recipientEmail);
        return true;
    } catch (MessagingException | java.io.UnsupportedEncodingException e) {
        System.err.println("Lỗi gửi email thông báo tài khoản shipper: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Tạo nội dung HTML cho email thông báo tài khoản shipper mới
 */
private static String createNewShipperAccountEmailContent(String username, String password, 
                                                        Date startDate, Date endDate) {
    // Định dạng ngày tháng
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    String startDateStr = dateFormat.format(startDate);
    String endDateStr = endDate != null ? dateFormat.format(endDate) : "Không xác định";
    
    // Nội dung email
    return "<html>" +
           "<head>" +
           "    <style>" +
           "        body { font-family: Arial, sans-serif; line-height: 1.6; }" +
           "        .container { width: 80%; margin: 0 auto; padding: 20px; }" +
           "        .header { background-color: #4CAF50; color: white; padding: 10px; text-align: center; }" +
           "        .content { padding: 20px; border: 1px solid #ddd; }" +
           "        .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #777; }" +
           "        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }" +
           "        table, th, td { border: 1px solid #ddd; }" +
           "        th, td { padding: 10px; text-align: left; }" +
           "        th { background-color: #f2f2f2; }" +
           "        .highlight { font-weight: bold; color: #4CAF50; }" +
           "    </style>" +
           "</head>" +
           "<body>" +
           "    <div class='container'>" +
           "        <div class='header'>" +
           "            <h1>Chào mừng bạn trở thành Shipper của chúng tôi!</h1>" +
           "        </div>" +
           "        <div class='content'>" +
           "            <p>Xin chào <span class='highlight'>" + username + "</span>,</p>" +
           "            <p>Chúc mừng bạn đã trở thành một phần của đội ngũ Shipper của chúng tôi! Chúng tôi rất vui mừng được hợp tác với bạn.</p>" +
           "            <p>Dưới đây là thông tin tài khoản và công việc của bạn:</p>" +
           "            <table>" +
           "                <tr>" +
           "                    <th>Thông tin</th>" +
           "                    <th>Chi tiết</th>" +
           "                </tr>" +
           "                <tr>" +
           "                    <td>Tên đăng nhập</td>" +
           "                    <td>" + username + "</td>" +
           "                </tr>" +
           "                <tr>" +
           "                    <td>Mật khẩu</td>" +
           "                    <td>" + password + "</td>" +
           "                </tr>" +
           "                <tr>" +
           "                    <td>Ngày bắt đầu</td>" +
           "                    <td>" + startDateStr + "</td>" +
           "                </tr>" +
           "                <tr>" +
           "                    <td>Ngày kết thúc (nếu có)</td>" +
           "                    <td>" + endDateStr + "</td>" +
           "                </tr>" +
           "            </table>" +
           "            <p>Vui lòng đăng nhập vào hệ thống của chúng tôi bằng thông tin trên để bắt đầu nhận đơn hàng.</p>" +
           "            <p>Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi qua email hoặc số điện thoại hỗ trợ.</p>" +
           "            <p>Chúc bạn thành công và có những trải nghiệm tuyệt vời cùng chúng tôi!</p>" +
           "            <p>Trân trọng,<br>Ban quản lý</p>" +
           "        </div>" +
           "        <div class='footer'>" +
           "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
           "            <p>&copy; " + java.time.Year.now().getValue() + " - Hệ thống quản lý giao hàng</p>" +
           "        </div>" +
           "    </div>" +
           "</body>" +
           "</html>";
}

    
}
