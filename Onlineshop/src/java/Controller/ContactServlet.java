///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package Controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.*;
//import java.util.*;
//import java.util.regex.*;
//import java.text.SimpleDateFormat;
//import javax.mail.*;
//import javax.mail.internet.*;
///**
// *
// * @author PC
// */
//@WebServlet(name="ContactServlet", urlPatterns={"/ContactServlet"})
//public class ContactServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//    private static final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
//    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);
//    
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//        
//        // Lấy dữ liệu từ form
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//        String subject = request.getParameter("subject");
//        String message = request.getParameter("message");
//        
//        // Kiểm tra dữ liệu
//        if (name == null || name.trim().isEmpty() ||
//            email == null || email.trim().isEmpty() ||
//            subject == null || subject.trim().isEmpty() ||
//            message == null || message.trim().isEmpty() ||
//            !validateEmail(email)) {
//            
//            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//            out.print("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ thông tin và kiểm tra định dạng email.\"}");
//            return;
//        }
//        
//        try {
//            // Ghi log
//            logContactRequest(name, email, subject, message);
//            
//            // Gửi email (sử dụng JavaMail API)
//            boolean emailSent = sendEmail(name, email, subject, message);
//            
//            if (emailSent) {
//                out.print("{\"success\": true, \"message\": \"Tin nhắn của bạn đã được gửi thành công!\"}");
//            } else {
//                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//                out.print("{\"success\": false, \"message\": \"Không thể gửi tin nhắn. Vui lòng thử lại sau.\"}");
//            }
//        } catch (Exception e) {
//            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
//            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
//            e.printStackTrace();
//        }
//    }
//    
//    private boolean validateEmail(String email) {
//        Matcher matcher = pattern.matcher(email);
//        return matcher.matches();
//    }
//    
//    private void logContactRequest(String name, String email, String subject, String message) {
//        try {
//            String logDir = getServletContext().getRealPath("/") + "logs";
//            File dir = new File(logDir);
//            if (!dir.exists()) {
//                dir.mkdir();
//            }
//            
//            String logFile = logDir + "/contact_log.txt";
//            FileWriter fw = new FileWriter(logFile, true);
//            BufferedWriter bw = new BufferedWriter(fw);
//            
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            String timestamp = sdf.format(new Date());
//            
//            bw.write(timestamp + " - Contact from: " + name + " (" + email + "), Subject: " + subject);
//            bw.newLine();
//            bw.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//    
//    private boolean sendEmail(String name, String email, String subject, String message) {
//        // Đây là phương thức giả định để gửi email
//        // Trong môi trường thực tế, bạn sẽ sử dụng JavaMail API
//        
//        // Ví dụ đơn giản về cách sử dụng JavaMail:
//        try {
//            // Cấu hình thông tin email
//            String host = "smtp.gmail.com";
//            String port = "587";
//            final String username = "anhhoang30012004@gmail.com"; 
//            final String password = "mjsp obnk obye jorx"; 
//            
//            // Thiết lập thuộc tính
//            Properties props = new Properties();
//            props.put("mail.smtp.auth", "true");
//            props.put("mail.smtp.starttls.enable", "true");
//            props.put("mail.smtp.host", host);
//            props.put("mail.smtp.port", port);
//            
//            // Tạo session với xác thực
//            Session session = Session.getInstance(props, new Authenticator() {
//                protected PasswordAuthentication getPasswordAuthentication() {
//                    return new PasswordAuthentication(username, password);
//                }
//            });
//            
//            // Tạo message
//              MimeMessage msg = new MimeMessage(session);
//            msg.setFrom(new InternetAddress(username, "Flower Shop", "UTF-8"));
//            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse("anhhoang30012004@gmail.com")); // Thay bằng email nhận
//            msg.setSubject(subject + ": " + name, "UTF-8");            
//            // Tạo nội dung
//            String emailContent = "Bạn đã nhận được tin nhắn mới từ website.\n\n" +
//                                "Chi tiết:\n\n" +
//                                "Tên: " + name + "\n\n" +
//                                "Email: " + email + "\n\n" +
//                                "Tiêu đề: " + subject + "\n\n" +
//                                "Tin nhắn: " + message;
//            
//          msg.setContent(emailContent, "text/html; charset=UTF-8");
//            
//           // Gửi email
//            Transport.send(msg);
//            
//            return true;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//}
