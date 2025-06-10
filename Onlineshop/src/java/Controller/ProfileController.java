package Controller;

import DAO.AccountDAO;
import DAO.ProfileDAO;
import Model.Account;
import Model.Profile;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5)
public class ProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            // Lấy profile từ database nếu có
            ProfileDAO profileDAO = new ProfileDAO();
            Profile profile = profileDAO.getProfileByAccountId(account.getAccountID());

            // Nếu chưa có profile, tạo đối tượng mới
            if (profile == null) {
                profile = new Profile();
                profile.setAccountId(account.getAccountID());
                profile.setEmail(account.getEmail());
                profile.setPhoneNumber(account.getPhone());
            }

            // Lưu profile vào session
            session.setAttribute("profile", profile);

            // Hiển thị trang profile
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "update":
                updateProfile(request, response, session, account);
                break;
            case "uploadImage":
                uploadProfileImage(request, response, session, account);
                break;
            case "updateProfile":
                updateProfileModal(request, response, session, account);
                break;
            default:
                request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, HttpSession session, Account account)
            throws ServletException, IOException {
        String field = request.getParameter("field");
        String value = request.getParameter("value");
        Map<String, Object> result = new HashMap<>();

        if (field == null || field.isEmpty()) {
            result.put("success", false);
            result.put("message", "Thông tin không hợp lệ");
            sendJsonResponse(response, result);
            return;
        }

        // Lấy profile từ session hoặc tạo mới
        Profile profile = (Profile) session.getAttribute("profile");
        if (profile == null) {
            profile = new Profile();
            profile.setAccountId(account.getAccountID());
            profile.setEmail(account.getEmail());
            profile.setPhoneNumber(account.getPhone());
        }

        ProfileDAO profileDAO = new ProfileDAO();

        // Kiểm tra giá trị hợp lệ dựa trên loại trường
        switch (field) {
            case "email":
                if (value == null || value.isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Email không được để trống");
                    sendJsonResponse(response, result);
                    return;
                }
                if (!isValidEmail(value)) {
                    result.put("success", false);
                    result.put("message", "Email không hợp lệ");
                    sendJsonResponse(response, result);
                    return;
                }
                // Kiểm tra trùng lặp email
                AccountDAO dao = new AccountDAO();
                Account existingAccount = dao.checkEmailExist(value);
                if (existingAccount != null && existingAccount.getAccountID() != account.getAccountID()) {
                    result.put("success", false);
                    result.put("message", "Email đã được sử dụng bởi tài khoản khác");
                    sendJsonResponse(response, result);
                    return;
                }
                account.setEmail(value);
                profile.setEmail(value);
                boolean updated = updateAccountField(account.getAccountID(), field, value, dao);
                if (updated) {
                    session.setAttribute("account", account);
                    session.setAttribute("profile", profile);
                    // Cập nhật profile
                    profileDAO.saveOrUpdateProfile(profile);
                    result.put("success", true);
                    result.put("message", "Cập nhật email thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật email thất bại");
                }
                break;

            case "phone":
                if (value == null || value.isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Số điện thoại không được để trống");
                    sendJsonResponse(response, result);
                    return;
                }
                if (!isValidPhone(value)) {
                    result.put("success", false);
                    result.put("message", "Số điện thoại không hợp lệ");
                    sendJsonResponse(response, result);
                    return;
                }
                // Kiểm tra trùng lặp số điện thoại
                AccountDAO phoneDao = new AccountDAO();
                account.setPhone(value);
                profile.setPhoneNumber(value);
                boolean phoneUpdated = updateAccountField(account.getAccountID(), field, value, phoneDao);
                if (phoneUpdated) {
                    session.setAttribute("account", account);
                    session.setAttribute("profile", profile);
                    // Cập nhật profile
                    profileDAO.saveOrUpdateProfile(profile);
                    result.put("success", true);
                    result.put("message", "Cập nhật số điện thoại thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật số điện thoại thất bại");
                }
                break;

            case "fullName":
                profile.setFullName(value);
                boolean nameUpdated = profileDAO.saveOrUpdateProfile(profile);
                if (nameUpdated) {
                    session.setAttribute("profile", profile);
                    result.put("success", true);
                    result.put("message", "Cập nhật họ tên thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật họ tên thất bại");
                }
                break;

            case "address":
                profile.setAddress(value);
                boolean addressUpdated = profileDAO.saveOrUpdateProfile(profile);
                if (addressUpdated) {
                    session.setAttribute("profile", profile);
                    result.put("success", true);
                    result.put("message", "Cập nhật địa chỉ thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật địa chỉ thất bại");
                }
                break;

            case "dob":
                try {
                if (value != null && !value.isEmpty()) {
                    Date dob = Date.valueOf(value);
                    profile.setDob(dob);
                    boolean dobUpdated = profileDAO.saveOrUpdateProfile(profile);
                    if (dobUpdated) {
                        session.setAttribute("profile", profile);
                        result.put("success", true);
                        result.put("message", "Cập nhật ngày sinh thành công");
                    } else {
                        result.put("success", false);
                        result.put("message", "Cập nhật ngày sinh thất bại");
                    }
                } else {
                    profile.setDob(null);
                    boolean dobUpdated = profileDAO.saveOrUpdateProfile(profile);
                    if (dobUpdated) {
                        session.setAttribute("profile", profile);
                        result.put("success", true);
                        result.put("message", "Đã xóa thông tin ngày sinh");
                    } else {
                        result.put("success", false);
                        result.put("message", "Xóa thông tin ngày sinh thất bại");
                    }
                }
            } catch (Exception e) {
                result.put("success", false);
                result.put("message", "Ngày sinh không hợp lệ");
            }
            break;

            case "gender":
                profile.setGender(value);
                boolean genderUpdated = profileDAO.saveOrUpdateProfile(profile);
                if (genderUpdated) {
                    session.setAttribute("profile", profile);
                    result.put("success", true);
                    result.put("message", "Cập nhật giới tính thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Cập nhật giới tính thất bại");
                }
                break;

            default:
                result.put("success", false);
                result.put("message", "Trường thông tin không hợp lệ");
        }

        sendJsonResponse(response, result);
    }

    private void uploadProfileImage(HttpServletRequest request, HttpServletResponse response, HttpSession session, Account account)
            throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();

        try {
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String newFileName = "profile_" + account.getAccountID() + fileExtension;

                // Đường dẫn lưu file
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "profiles";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + newFileName;
                filePart.write(filePath);

                // Cập nhật đường dẫn ảnh trong profile
                Profile profile = (Profile) session.getAttribute("profile");
                if (profile == null) {
                    profile = new Profile();
                    profile.setAccountId(account.getAccountID());
                    profile.setEmail(account.getEmail());
                    profile.setPhoneNumber(account.getPhone());
                }

                String imageUrl = "img/profiles/" + newFileName;
                profile.setImg(imageUrl);
                session.setAttribute("profile", profile);

                // Lưu vào database
                ProfileDAO profileDAO = new ProfileDAO();
                boolean updated = profileDAO.saveOrUpdateProfile(profile);

                if (updated) {
                    result.put("success", true);
                    result.put("message", "Tải ảnh lên thành công");
                } else {
                    result.put("success", false);
                    result.put("message", "Lỗi khi lưu thông tin ảnh vào database");
                }
            } else {
                result.put("success", false);
                result.put("message", "Không có file được chọn");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi tải ảnh lên: " + e.getMessage());
        }

        sendJsonResponse(response, result);
    }

    private void updateProfileModal(HttpServletRequest request, HttpServletResponse response, HttpSession session, Account account)
            throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();

        try {
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");

            // Kiểm tra email
            if (email != null && !email.isEmpty()) {
                if (!isValidEmail(email)) {
                    result.put("success", false);
                    result.put("message", "Email không hợp lệ");
                    sendJsonResponse(response, result);
                    return;
                }

                // Kiểm tra trùng lặp email
                AccountDAO dao = new AccountDAO();
                Account existingAccount = dao.checkEmailExist(email);
                if (existingAccount != null && existingAccount.getAccountID() != account.getAccountID()) {
                    result.put("success", false);
                    result.put("message", "Email đã được sử dụng bởi tài khoản khác");
                    sendJsonResponse(response, result);
                    return;
                }
            }

            // Kiểm tra số điện thoại
            if (phone != null && !phone.isEmpty()) {
                if (!isValidPhone(phone)) {
                    result.put("success", false);
                    result.put("message", "Số điện thoại không hợp lệ");
                    sendJsonResponse(response, result);
                    return;
                }
            }

            // Lấy profile từ session hoặc tạo mới
            Profile profile = (Profile) session.getAttribute("profile");
            if (profile == null) {
                profile = new Profile();
                profile.setAccountId(account.getAccountID());
            }

            // Cập nhật thông tin profile
            profile.setFullName(fullName);
            profile.setEmail(email);
            profile.setPhoneNumber(phone);
            profile.setAddress(address);
            profile.setGender(gender);

            // Xử lý ngày sinh
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    Date dob = Date.valueOf(dobStr);
                    profile.setDob(dob);
                } catch (Exception e) {
                    result.put("success", false);
                    result.put("message", "Ngày sinh không hợp lệ");
                    sendJsonResponse(response, result);
                    return;
                }
            } else {
                profile.setDob(null);
            }

            // Cập nhật thông tin account
            if (email != null && !email.isEmpty()) {
                account.setEmail(email);
                AccountDAO accountDAO = new AccountDAO();
                accountDAO.updateField(account.getAccountID(), "email", email);
            }

            if (phone != null && !phone.isEmpty()) {
                account.setPhone(phone);
                AccountDAO accountDAO = new AccountDAO();
                accountDAO.updateField(account.getAccountID(), "phone", phone);
            }

            // Lưu vào database
            ProfileDAO profileDAO = new ProfileDAO();
            boolean updated = profileDAO.saveOrUpdateProfile(profile);

            if (updated) {
                // Cập nhật session
                session.setAttribute("account", account);
                session.setAttribute("profile", profile);

                result.put("success", true);
                result.put("message", "Cập nhật thông tin cá nhân thành công");
            } else {
                result.put("success", false);
                result.put("message", "Cập nhật thông tin cá nhân thất bại");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        sendJsonResponse(response, result);
    }

    private boolean updateAccountField(int accountID, String field, String value, AccountDAO dao) {
        return dao.updateField(accountID, field, value);
    }

    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print("{");
        boolean first = true;
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            if (!first) {
                out.print(",");
            }
            first = false;
            out.print("\"" + entry.getKey() + "\":");
            if (entry.getValue() instanceof String) {
                out.print("\"" + entry.getValue() + "\"");
            } else {
                out.print(entry.getValue());
            }
        }
        out.print("}");
        out.flush();
    }

// Phương thức kiểm tra định dạng email có hợp lệ hay không
    private boolean isValidEmail(String email) {
        // Biểu thức chính quy để kiểm tra định dạng email
        // Giải thích:
        // ^[a-zA-Z0-9_+&*-]+        : Bắt đầu bằng một hoặc nhiều ký tự chữ, số hoặc các ký tự đặc biệt _ + & * -
        // (?:\\.[a-zA-Z0-9_+&*-]+)* : Cho phép có thêm các phần mở rộng sau dấu chấm (ví dụ: firstname.lastname)
        // @                         : Phải có ký tự '@' ngăn cách giữa tên người dùng và tên miền
        // (?:[a-zA-Z0-9-]+\\.)+     : Tên miền có thể gồm nhiều phần cách nhau bởi dấu chấm (ví dụ: gmail.com, mail.co.uk)
        // [a-zA-Z]{2,7}$            : Phần mở rộng tên miền (TLD) phải từ 2 đến 7 ký tự (ví dụ: com, org, net)
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";

        // Trả về true nếu email khớp với biểu thức chính quy, ngược lại trả về false
        return email.matches(emailRegex);
    }

    /**
     * Kiểm tra một chuỗi số điện thoại có hợp lệ hay không theo tiêu chuẩn Việt
     * Nam.
     *
     * Tiêu chí hợp lệ: - Chỉ chứa các chữ số (0-9), không có ký tự đặc biệt
     * hoặc chữ cái. - Có độ dài 10 hoặc 11 số. - Có thể chứa dấu cách hoặc dấu
     * gạch ngang, nhưng sẽ bị loại bỏ trước khi kiểm tra. - Phải bắt đầu bằng
     * các đầu số hợp lệ của Việt Nam như 03, 05, 07, 08, 09,...
     *
     * @param phone Chuỗi số điện thoại cần kiểm tra.
     * @return true nếu số điện thoại hợp lệ, false nếu không hợp lệ.
     */
    private boolean isValidPhone(String phone) {
        // Loại bỏ tất cả dấu cách và dấu gạch ngang ra khỏi số điện thoại để chuẩn hóa chuỗi
        phone = phone.replaceAll("\\s|-", "");

        // Kiểm tra độ dài của chuỗi đã chuẩn hóa phải là 10 hoặc 11 ký tự
        if (phone.length() != 10 && phone.length() != 11) {
            return false;
        }

        // Kiểm tra chuỗi chỉ chứa ký tự số (0-9), không chứa chữ cái hoặc ký tự đặc biệt
        if (!phone.matches("\\d+")) {
            return false;
        }

        // Danh sách các đầu số hợp lệ theo nhà mạng và vùng ở Việt Nam
        String[] validPrefixes = {"03", "05", "07", "08", "09", "01", "02", "04", "06", "84"};

        // Biến cờ để xác định xem chuỗi bắt đầu bằng một trong các đầu số hợp lệ không
        boolean validPrefix = false;
        for (String prefix : validPrefixes) {
            if (phone.startsWith(prefix)) {
                validPrefix = true;
                break; // Nếu đúng đầu số hợp lệ thì dừng vòng lặp
            }
        }

        // Trả về true nếu có đầu số hợp lệ, ngược lại trả về false
        return validPrefix;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Profile Controller";
    }
}
