<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FLOWER SHOP - Đăng ký</title>
     <!-- Thêm script reCAPTCHA API -->
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .register-container {
            width: 400px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .register-header {
            background-color: #A06060; 
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }
        
        .register-form {
            padding: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
            font-size: 16px;
        }
        
        .register-btn {
            background-color: #A06060; 
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 3px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
        }
        
        .register-btn:hover {
            background-color: #8a5252;
        }
        
        .error-message {
            color: #e74c3c;
            margin-bottom: 15px;
        }
        
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .login-link a {
            color: #A06060; 
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .home-link {
            text-align: center;
            margin-top: 10px;
        }
        
        .home-link a {
            color: #666;
            text-decoration: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .home-link a:hover {
            color: #A06060;
        }
         .text-danger {
        color: #dc3545;
        font-size: 0.875em;
        margin-top: 0.25rem;
    }
    
    input:invalid {
        border-color: #dc3545;
    }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            FLOWER SHOP
        </div>
        <div class="register-form">
            <h2 style="text-align: center; margin-top: 0;">Đăng ký</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="account" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" required value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                    <small class="form-text text-muted">Tên đăng nhập không được chứa khoảng trắng</small>
                </div>
                
               
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                    <small class="form-text text-muted">Email phải có định dạng @gmail.com</small>
                </div>
               <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" class="form-control" id="phone" name="phone" required value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                    <small class="form-text text-muted">Ví dụ: 0912345678, 0328888999</small>
                    <span id="phone-error" class="text-danger" style="display: none;"></span>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="confirm-password">Xác nhận mật khẩu</label>
                    <input type="password" id="confirm-password" name="confirm-password" required>
                </div>
                <!-- Thêm reCAPTCHA widget -->
                <div class="form-group">
                    <div class="g-recaptcha" data-sitekey="6LdWek4rAAAAAPy1lqXYjQHUiVHyjS5KOj3eEwRs"></div>
                    </div>
                <button type="submit" class="register-btn">Đăng ký</button>
            </form>
            
            <div class="login-link">
                Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
            </div>
            
            <div class="home-link">
                <a href="Homepage">
                    ← Quay về trang chủ
                </a>
            </div>
        </div>
    </div>
    
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirm-password").value;
            var username = document.getElementById("username").value;
            var email = document.getElementById("email").value;
            
            // Kiểm tra khoảng trắng trong tên đăng nhập
            if (username.indexOf(" ") !== -1) {
                alert("Tên đăng nhập không được chứa khoảng trắng!");
                return false;
            }
            
            // Kiểm tra định dạng email phải là @gmail.com
            if (!email.toLowerCase().endsWith("@gmail.com")) {
                alert("Email phải có định dạng @gmail.com!");
                return false;
            }
            
            // Kiểm tra mật khẩu xác nhận phải khớp với mật khẩu
            if (password !== confirmPassword) {
                alert("Mật khẩu xác nhận không khớp!");
                return false;
            }
            
            // Kiểm tra xem người dùng đã hoàn thành reCAPTCHA chưa
            var recaptchaResponse = grecaptcha.getResponse();
            if(recaptchaResponse.length === 0) {
                alert("Vui lòng xác nhận bạn không phải là robot!");
                return false;
            }
            
            return true;
        }
        
    // Đợi cho trang tải xong
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy tham chiếu đến các trường nhập liệu
        var phoneInput = document.getElementById('phone');
        var usernameInput = document.getElementById('username');
        var emailInput = document.getElementById('email');
        var passwordInput = document.getElementById('password');
        var confirmPasswordInput = document.getElementById('confirm-password');
        
        // Nếu trường tồn tại, thêm sự kiện kiểm tra
        if (phoneInput) {
            phoneInput.addEventListener('input', validateVietnamesePhone);
            phoneInput.addEventListener('blur', validateVietnamesePhone);
        }
        
        // Thêm kiểm tra khoảng trắng cho tên đăng nhập
        if (usernameInput) {
            usernameInput.addEventListener('input', function(e) {
                var username = e.target.value;
                if (username.indexOf(" ") !== -1) {
                    e.target.setCustomValidity("Tên đăng nhập không được chứa khoảng trắng");
                } else {
                    e.target.setCustomValidity("");
                }
            });
        }
        
        // Thêm kiểm tra định dạng email
        if (emailInput) {
            emailInput.addEventListener('input', function(e) {
                var email = e.target.value;
                if (!email.toLowerCase().endsWith("@gmail.com") && email.length > 0) {
                    e.target.setCustomValidity("Email phải có định dạng @gmail.com");
                } else {
                    e.target.setCustomValidity("");
                }
            });
        }
        
        // Thêm kiểm tra mật khẩu xác nhận
        if (confirmPasswordInput && passwordInput) {
            confirmPasswordInput.addEventListener('input', function(e) {
                if (passwordInput.value !== e.target.value) {
                    e.target.setCustomValidity("Mật khẩu xác nhận không khớp");
                } else {
                    e.target.setCustomValidity("");
                }
            });
            
            passwordInput.addEventListener('input', function() {
                if (confirmPasswordInput.value !== "") {
                    if (passwordInput.value !== confirmPasswordInput.value) {
                        confirmPasswordInput.setCustomValidity("Mật khẩu xác nhận không khớp");
                    } else {
                        confirmPasswordInput.setCustomValidity("");
                    }
                }
            });
        }
        

        
        function validateVietnamesePhone(e) {
            // Lấy giá trị và loại bỏ khoảng trắng, dấu gạch ngang
            const phone = e.target.value.replace(/\s|-/g, '');
            
            // Danh sách đầu số hợp lệ của Việt Nam
            const validPrefixes = [
              // Viettel
    "032", "033", "034", "035", "036", "037", "038", "039", "086", "096", "097", "098",
    // Vinaphone
    "081", "082", "083", "084", "085", "088", "091", "094",
    // Mobifone
    "070", "076", "077", "078", "079", "089", "090", "093",
    // Vietnamobile
    "052", "056", "058", "092",
    // Gmobile
    "059", "099",
    // Cố định (có thể bổ sung thêm mã vùng)
    "024", "028"
            ];
            
            // Kiểm tra tính hợp lệ
            let isValid = false;
            let errorMessage = '';
            
            // Kiểm tra độ dài và bắt đầu bằng số 0
            if (!phone.startsWith('0')) {
                errorMessage = 'Số điện thoại phải bắt đầu bằng số 0';
            } else if (phone.length !== 10 && phone.length !== 11) {
                errorMessage = 'Số điện thoại phải có 10 hoặc 11 chữ số';
            } else {
                // Kiểm tra đầu số
                for (const prefix of validPrefixes) {
                    if (phone.startsWith(prefix)) {
                        isValid = true;
                        break;
                    }
                }
                
                if (!isValid) {
                    errorMessage = 'Đầu số không hợp lệ. Vui lòng nhập đúng đầu số nhà mạng Việt Nam';
                }
            }
            
            // Hiển thị thông báo lỗi hoặc xóa thông báo lỗi
            if (isValid) {
                e.target.setCustomValidity('');
                // Xóa thông báo lỗi nếu có
                var errorSpan = document.getElementById('phone-error');
                if (errorSpan) {
                    errorSpan.textContent = '';
                    errorSpan.style.display = 'none';
                }
            } else {
                e.target.setCustomValidity(errorMessage);
                
                // Hiển thị thông báo lỗi
                var errorSpan = document.getElementById('phone-error');
                if (!errorSpan) {
                    // Tạo phần tử hiển thị lỗi nếu chưa có
                    errorSpan = document.createElement('span');
                    errorSpan.id = 'phone-error';
                    errorSpan.className = 'text-danger';
                    e.target.parentNode.appendChild(errorSpan);
                }
                errorSpan.textContent = errorMessage;
                errorSpan.style.display = 'block';
            }
        }
    });

    </script>
    
</body>
</html>