<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - Flower Shop</title>
        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <!-- Thêm script reCAPTCHA API -->
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        <style>
            :root {
                --primary: #FFB6C1;
                --primary-hover: #FFA5B5;
            }

            body {
                background-color: #fff;
                margin: 0;
                padding: 0;
            }

            .register-container {
                padding: 30px 0;
                margin-bottom: 0; /* Giảm khoảng cách với footer */
                
            }

            /* Style cho các phần tử trong trang register */
            .bg-pink {
                background-color: var(--primary) !important;
            }
            .text-pink {
                color: var(--primary) !important;
            }
            .btn-pink {
                background: linear-gradient(45deg, #FFB6C1, #FFA5B5);
                border: none;
                color: white;
                transition: all 0.3s ease;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .btn-pink:hover {
                background: linear-gradient(45deg, #FFA5B5, #FFB6C1);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 182, 193, 0.4);
            }
            
            .card {
                border: none;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                border-radius: 20px;
                overflow: hidden;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                margin-bottom: 0; /* Giảm khoảng cách dưới card */
            }
            .card-header {
                background: linear-gradient(45deg, #FFB6C1, #FFA5B5);
                color: white;
                border: none;
                padding: 1.5rem;
                text-transform: uppercase;
                letter-spacing: 2px;
            }
            .form-control {
                border-radius: 10px;
                padding: 0.8rem 1rem;
                border: 2px solid #d0f0e9;
                transition: all 0.3s ease;
                background-color: #FFFFFF;
            }
            .form-control:focus {
                border-color: #FFB6C1;
                box-shadow: 0 0 0 0.2rem rgba(255, 182, 193, 0.25);
                background-color: #FFFFFF;
            }
            .form-floating label {
                padding-left: 1rem;
                color: #FFA5B5;
            }
            .form-floating > .form-control:focus ~ label {
                color: #FFB6C1;
            }
            .alert-danger {
                background-color: #FFF0F0;
                color: #FF8B96;
                border-left: 4px solid #FFB6C1;
            }
            .alert-success {
                background-color: #e0f7f1;
                color: #4CAF50;
                border-left: 4px solid #4CAF50;
            }
            .back-to-home {
                color: #FFB6C1 !important;
                opacity: 0.9;
            }
            .back-to-home:hover {
                opacity: 1;
                color: #FFA5B5 !important;
            }



            /* Đảm bảo chiều cao phù hợp */
            @media (min-height: 800px) {
                .register-container {
                    min-height: calc(100vh - 400px); /* Điều chỉnh chiều cao dựa trên kích thước header và footer */
                    display: flex;
                    align-items: center;
                }
            }

            @media (max-height: 800px) {
                .register-container {
                    min-height: auto;
                    padding: 30px 0;
                }
            }
            
            .text-danger {
                color: #dc3545;
                font-size: 0.875em;
                margin-top: 0.25rem;
            }
            
            input:invalid {
                border-color: #dc3545;
            }
            
            .search-input {
                border-radius: 20px 0 0 20px;
                border: 2px solid var(--primary);
                border-right: none;
                padding: 0.375rem 1rem;
                height: 36px;
                font-size: 1rem;
                background-color: #fffafc;
            }
            
            /* Style cho form xác thực email */
            .verification-form {
                display: none;
            }
            
            .verification-code-container {
                display: flex;
                justify-content: center;
                margin-bottom: 20px;
            }
            
            .verification-code-input {
                width: 50px;
                height: 50px;
                text-align: center;
                font-size: 24px;
                margin: 0 5px;
                border: 2px solid #d0f0e9;
                border-radius: 10px;
            }
            
            .verification-code-input:focus {
                border-color: #FFB6C1;
                box-shadow: 0 0 0 0.2rem rgba(255, 182, 193, 0.25);
            }
            
            .timer-container {
                text-align: center;
                margin-bottom: 20px;
                color: #6c757d;
            }
            
            .resend-button {
                background: none;
                border: none;
                color: #FFB6C1;
                text-decoration: underline;
                cursor: pointer;
            }
            
            .resend-button:disabled {
                color: #6c757d;
                cursor: not-allowed;
                text-decoration: none;
            }
            
            .flower-decoration {
                position: absolute;
                width: 100px;
                height: 100px;
                opacity: 0.2;
                z-index: 0;
            }
            
            .flower-top-right {
                top: -20px;
                right: -20px;
                transform: rotate(45deg);
            }
            
            .flower-bottom-left {
                bottom: -20px;
                left: -20px;
                transform: rotate(-135deg);
            }
        </style>
    </head>
    <body>
        <!-- Include header -->
        <jsp:include page="header.jsp"/>
        <div class="container-fluid">
            <div class="d-inline-flex align-items-center d-block d-lg-none">
                <a href="" class="btn px-0 ml-2">
                    <i class="fas fa-heart text-dark"></i>
                    <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                </a>
                <a href="" class="btn px-0 ml-2">
                    <i class="fas fa-shopping-cart text-dark"></i>
                    <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                </a>
            </div>
        </div>
   
        <!-- Register container -->
        <div class="register-container">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-5">
                        <div class="card position-relative">
                            <!-- Trang trí hoa -->
                            <div class="flower-decoration flower-top-right">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                    <path fill="#FFB6C1" d="M50,0 C60,20 80,30 100,30 C80,40 70,60 70,80 C60,70 40,70 20,80 C30,60 20,40 0,30 C20,20 40,20 50,0 Z"></path>
                                </svg>
                            </div>
                            <div class="flower-decoration flower-bottom-left">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                                    <path fill="#FFB6C1" d="M50,0 C60,20 80,30 100,30 C80,40 70,60 70,80 C60,70 40,70 20,80 C30,60 20,40 0,30 C20,20 40,20 50,0 Z"></path>
                                </svg>
                            </div>
                            
                            <div class="card-header text-center py-4">
                                <h3 class="mb-0 fw-bold">Đăng ký</h3>
                            </div>
                            <div class="card-body p-4">
                                <% if(request.getAttribute("error") != null) { %>
                                <div class="alert alert-danger d-flex align-items-center" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                                <% } %>
                                
                                <!-- Form đăng ký -->
                                <form action="account" method="post" id="register-form" onsubmit="return validateForm()" class="registration-form">
                                    <input type="hidden" name="action" value="register">
                                    
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập" required value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                                            <label for="username"></label>
                                        </div>
                                        <small class="form-text text-muted">Tên đăng nhập không được chứa khoảng trắng</small>
                                        <span id="username-error" class="text-danger" style="display: none;"></span>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="email" class="form-control" id="email" name="email" placeholder="Email" required value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                                            <label for="email"></label>
                                        </div>
                                        <small class="form-text text-muted">Email phải có định dạng @gmail.com và không chứa khoảng trắng</small>
                                        <span id="email-error" class="text-danger" style="display: none;"></span>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="phone" name="phone" placeholder="Số điện thoại" required value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                                            <label for="phone"></label>
                                        </div>
                                        <small class="form-text text-muted">Số điện thoại chỉ được chứa chữ số, không khoảng trắng</small>
                                        <span id="phone-error" class="text-danger" style="display: none;"></span>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                                            <label for="password"></label>
                                        </div>
                                        <small class="form-text text-muted">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số, không được chứa khoảng trắng</small>
                                        <span id="password-error" class="text-danger" style="display: none;"></span>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="password" class="form-control" id="confirm-password" name="confirm-password" placeholder="Xác nhận mật khẩu" required>
                                            <label for="confirm-password"></label>
                                        </div>
                                        <span id="confirm-password-error" class="text-danger" style="display: none;"></span>
                                    </div>
                                    
                                    <!-- Thêm reCAPTCHA widget -->
                                    <div class="mb-4">
                                        <div class="g-recaptcha" data-sitekey="6LdWek4rAAAAAPy1lqXYjQHUiVHyjS5KOj3eEwRs"></div>
                                    </div>
                                    
                                    <div class="d-grid gap-2 text-center">
                                        <button type="submit" id="register-btn" class="btn btn-pink py-3 px-5 mx-auto rounded-pill">
                                            Đăng ký
                                        </button>
                                    </div>
                                </form>
                                
                                <!-- Form xác thực email -->
                                <form action="account-verification" method="post" id="verification-form" class="verification-form">
                                    <input type="hidden" name="action" value="verify">
                                    <input type="hidden" id="verification-email" name="email" value="">
                                    
                                    <div class="alert alert-success d-flex align-items-center" role="alert">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Mã xác nhận đã được gửi đến email của bạn. Vui lòng kiểm tra và nhập mã xác nhận.
                                    </div>
                                    
                                    <div class="verification-code-container">
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                        <input type="text" class="verification-code-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                                    </div>
                                    <input type="hidden" id="verification-code" name="verificationCode" value="">
                                    
                                    <div class="timer-container">
                                        <span>Mã xác nhận sẽ hết hạn sau: </span>
                                        <span id="timer">10:00</span>
                                        <div class="mt-2">
                                            <button type="button" id="resend-button" class="resend-button" disabled>
                                                Gửi lại mã xác nhận
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2 text-center">
                                        <button type="submit" class="btn btn-pink py-3 px-5 rounded-pill mx-auto">
                                            <i class="fas fa-check-circle me-2"></i>Xác nhận
                                        </button>
                                    </div>
                                </form>
                                
                                <div class="text-center mt-4">
                                    <p class="mb-2">Đã có tài khoản? <a href="login.jsp" class="text-pink fw-bold">Đăng nhập ngay</a></p>
                                    <a href="Homepage" class="text-decoration-none back-to-home">
                                        <i class="fas fa-arrow-left me-1"></i> Quay về trang chủ
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="footer.jsp" />

        <script>
            // Đợi cho trang tải xong
            document.addEventListener('DOMContentLoaded', function() {
                // Lấy tham chiếu đến các trường nhập liệu
                var phoneInput = document.getElementById('phone');
                var usernameInput = document.getElementById('username');
                var emailInput = document.getElementById('email');
                var passwordInput = document.getElementById('password');
                var confirmPasswordInput = document.getElementById('confirm-password');
                var registerForm = document.getElementById('register-form');
                var verificationForm = document.getElementById('verification-form');
                
                // Kiểm tra số điện thoại
                if (phoneInput) {
                    phoneInput.addEventListener('input', function(e) {
                        var phone = e.target.value;
                        var errorSpan = document.getElementById('phone-error');
                        
                        if (phone.indexOf(" ") !== -1) {
                            errorSpan.textContent = "Số điện thoại không được chứa khoảng trắng";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Số điện thoại không được chứa khoảng trắng");
                        } else if (!/^\d*$/.test(phone)) {
                            errorSpan.textContent = "Số điện thoại chỉ được chứa chữ số";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Số điện thoại chỉ được chứa chữ số");
                        } else {
                            errorSpan.style.display = 'none';
                            e.target.setCustomValidity("");
                            validateVietnamesePhone(e);
                        }
                    });
                    phoneInput.addEventListener('blur', validateVietnamesePhone);
                }
                
                // Kiểm tra tên đăng nhập
                if (usernameInput) {
                    usernameInput.addEventListener('input', function(e) {
                        var username = e.target.value;
                        var errorSpan = document.getElementById('username-error');
                        
                        if (username.indexOf(" ") !== -1) {
                            errorSpan.textContent = "Tên đăng nhập không được chứa khoảng trắng";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Tên đăng nhập không được chứa khoảng trắng");
                        } else {
                            errorSpan.style.display = 'none';
                            e.target.setCustomValidity("");
                        }
                    });
                }
                
                // Kiểm tra email
                if (emailInput) {
                    emailInput.addEventListener('input', function(e) {
                        var email = e.target.value;
                        var errorSpan = document.getElementById('email-error');
                        
                        if (email.indexOf(" ") !== -1) {
                            errorSpan.textContent = "Email không được chứa khoảng trắng";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Email không được chứa khoảng trắng");
                        } else if (!email.toLowerCase().endsWith("@gmail.com") && email.length > 0) {
                            errorSpan.textContent = "Email phải có định dạng @gmail.com";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Email phải có định dạng @gmail.com");
                        } else {
                            errorSpan.style.display = 'none';
                            e.target.setCustomValidity("");
                        }
                    });
                }
                
                // Kiểm tra mật khẩu
                if (passwordInput) {
                    passwordInput.addEventListener('input', function(e) {
                        var password = e.target.value;
                        var hasSpecialChar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/.test(password);
                        var errorSpan = document.getElementById('password-error');
                        
                        if (password.indexOf(" ") !== -1) {
                            errorSpan.textContent = "Mật khẩu không được chứa khoảng trắng";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Mật khẩu không được chứa khoảng trắng");
                        } else if (!hasSpecialChar && password.length > 0) {
                            errorSpan.textContent = "Mật khẩu phải chứa ít nhất một ký tự đặc biệt";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Mật khẩu phải chứa ít nhất một ký tự đặc biệt");
                        } else {
                            errorSpan.style.display = 'none';
                            e.target.setCustomValidity("");
                        }
                        
                        // Kiểm tra lại mật khẩu xác nhận nếu đã nhập
                        if (confirmPasswordInput.value !== "") {
                            var confirmErrorSpan = document.getElementById('confirm-password-error');
                            if (password !== confirmPasswordInput.value) {
                                confirmErrorSpan.textContent = "Mật khẩu xác nhận không khớp";
                                confirmErrorSpan.style.display = 'block';
                                confirmPasswordInput.setCustomValidity("Mật khẩu xác nhận không khớp");
                            } else {
                                confirmErrorSpan.style.display = 'none';
                                confirmPasswordInput.setCustomValidity("");
                            }
                        }
                    });
                }
                
                // Kiểm tra mật khẩu xác nhận
                if (confirmPasswordInput && passwordInput) {
                    confirmPasswordInput.addEventListener('input', function(e) {
                        var errorSpan = document.getElementById('confirm-password-error');
                        if (passwordInput.value !== e.target.value) {
                            errorSpan.textContent = "Mật khẩu xác nhận không khớp";
                            errorSpan.style.display = 'block';
                            e.target.setCustomValidity("Mật khẩu xác nhận không khớp");
                        } else {
                            errorSpan.style.display = 'none';
                            e.target.setCustomValidity("");
                        }
                    });
                }
                
                // Thêm sự kiện submit cho form đăng ký
                if (registerForm) {
                    registerForm.addEventListener('submit', function(e) {
                        if (!validateForm()) {
                            e.preventDefault();
                            return;
                        }
                        
                        // Ngăn form submit mặc định
                        e.preventDefault();
                        
                        // Gửi yêu cầu AJAX để kiểm tra email và gửi mã xác nhận
                        var email = document.getElementById('email').value;
                        var username = document.getElementById('username').value;
                        var password = document.getElementById('password').value;
                        var phone = document.getElementById('phone').value;
                        
                        // Gửi yêu cầu AJAX
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', 'account-verification', true);
                        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === 4) {
                                var response = JSON.parse(xhr.responseText);
                                if (xhr.status === 200 && response.success) {
                                    // Hiển thị form xác thực
                                    document.querySelector('.registration-form').style.display = 'none';
                                    document.querySelector('.verification-form').style.display = 'block';
                                    document.getElementById('verification-email').value = email;
                                    
                                    // Bắt đầu đếm ngược
                                    startCountdown();
                                    
                                    // Thiết lập sự kiện cho các ô nhập mã xác nhận
                                    setupVerificationInputs();
                                } else {
                                    // Hiển thị lỗi
                                    var errorMessage = response.message || 'Có lỗi xảy ra. Vui lòng thử lại.';
                                    alert(errorMessage);
                                }
                            }
                        };
                        xhr.send('action=send&email=' + encodeURIComponent(email) + 
                                '&username=' + encodeURIComponent(username) + 
                                '&password=' + encodeURIComponent(password) + 
                                '&phone=' + encodeURIComponent(phone));
                    });
                }
                
                // Thiết lập sự kiện cho nút gửi lại mã
                document.getElementById('resend-button').addEventListener('click', function() {
                    var email = document.getElementById('verification-email').value;
                    
                    // Gửi yêu cầu AJAX để gửi lại mã
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', 'account-verification', true);
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4) {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                // Bắt đầu đếm ngược lại
                                startCountdown();
                                alert('Mã xác nhận mới đã được gửi đến email của bạn.');
                            } else {
                                // Hiển thị lỗi
                                var errorMessage = response.message || 'Có lỗi xảy ra. Vui lòng thử lại.';
                                alert(errorMessage);
                            }
                        }
                    };
                    xhr.send('action=resend&email=' + encodeURIComponent(email));
                });
                
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

            function validateForm() {
                var password = document.getElementById("password").value;
                var confirmPassword = document.getElementById("confirm-password").value;
                var username = document.getElementById("username").value;
                var email = document.getElementById("email").value;
                var phone = document.getElementById("phone").value;
                
                // Kiểm tra khoảng trắng trong tên đăng nhập
                if (username.indexOf(" ") !== -1) {
                    alert("Tên đăng nhập không được chứa khoảng trắng!");
                    return false;
                }
                
                // Kiểm tra khoảng trắng trong email
                if (email.indexOf(" ") !== -1) {
                    alert("Email không được chứa khoảng trắng!");
                    return false;
                }
                
                // Kiểm tra định dạng email phải là @gmail.com
                if (!email.toLowerCase().endsWith("@gmail.com")) {
                    alert("Email phải có định dạng @gmail.com!");
                    return false;
                }
                
                // Kiểm tra khoảng trắng trong số điện thoại
                if (phone.indexOf(" ") !== -1) {
                    alert("Số điện thoại không được chứa khoảng trắng!");
                    return false;
                }
                
                // Kiểm tra số điện thoại chỉ chứa số
                if (!/^\d+$/.test(phone)) {
                    alert("Số điện thoại chỉ được chứa chữ số!");
                    return false;
                }
                
                // Kiểm tra khoảng trắng trong mật khẩu
                if (password.indexOf(" ") !== -1) {
                    alert("Mật khẩu không được chứa khoảng trắng!");
                    return false;
                }
                
                // Kiểm tra mật khẩu phải chứa ký tự đặc biệt
                var hasSpecialChar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/.test(password);
                if (!hasSpecialChar) {
                    alert("Mật khẩu phải chứa ít nhất một ký tự đặc biệt!");
                    return false;
                }
                
                 // Kiểm tra mật khẩu phải chứa chữ hoa
                if (!/[A-Z]/.test(password)) {
                    alert("Mật khẩu phải chứa ít nhất một chữ cái viết hoa!");
                    return false;
                }
                
                 // Kiểm tra mật khẩu phải chứa chữ thường
                if (!/[a-z]/.test(password)) {
                    alert("Mật khẩu phải chứa ít nhất một chữ cái viết thường!");
                    return false;
                }
                
                // Kiểm tra mật khẩu xác nhận phải khớp với mật khẩu
                if (password !== confirmPassword) {
                    alert("Mật khẩu xác nhận không khớp!");
                    return false;
                }
                
                  // Kiểm tra mật khẩu phải chứa số
                if (!/[0-9]/.test(password)) {
                    alert("Mật khẩu phải chứa ít nhất một chữ số!");
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
            
            // Hàm thiết lập các ô nhập mã xác nhận
            function setupVerificationInputs() {
                const inputs = document.querySelectorAll('.verification-code-input');
                const hiddenInput = document.getElementById('verification-code');
                
                inputs.forEach((input, index) => {
                    // Tự động focus vào ô tiếp theo khi nhập
                    input.addEventListener('input', function() {
                        if (this.value.length === this.maxLength) {
                            if (index < inputs.length - 1) {
                                inputs[index + 1].focus();
                            }
                        }
                        
                        // Cập nhật giá trị vào hidden input
                        updateVerificationCode();
                    });
                    
                    // Xử lý phím Backspace
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Backspace' && !this.value && index > 0) {
                            inputs[index - 1].focus();
                        }
                    });
                    
                    // Chỉ cho phép nhập số
                    input.addEventListener('keypress', function(e) {
                        if (!/[0-9]/.test(e.key)) {
                            e.preventDefault();
                        }
                    });
                    
                    // Xử lý paste
                    input.addEventListener('paste', function(e) {
                        e.preventDefault();
                        const pasteData = e.clipboardData.getData('text').slice(0, inputs.length);
                        if (/^\d+$/.test(pasteData)) {
                            for (let i = 0; i < pasteData.length; i++) {
                                if (index + i < inputs.length) {
                                    inputs[index + i].value = pasteData[i];
                                }
                            }
                            // Focus vào ô cuối cùng hoặc ô tiếp theo
                            const nextIndex = Math.min(index + pasteData.length, inputs.length - 1);
                            inputs[nextIndex].focus();
                            updateVerificationCode();
                        }
                    });
                });
                
                // Focus vào ô đầu tiên
                inputs[0].focus();
                
                function updateVerificationCode() {
                    hiddenInput.value = Array.from(inputs).map(input => input.value).join('');
                }
            }
            
            // Hàm bắt đầu đếm ngược
            function startCountdown() {
                const timerDisplay = document.getElementById('timer');
                const resendButton = document.getElementById('resend-button');
                let timeLeft = 10 * 60; // 10 phút
                
                resendButton.disabled = true;
                
                const countdownInterval = setInterval(function() {
                    timeLeft--;
                    
                    const minutes = Math.floor(timeLeft / 60);
                    const seconds = timeLeft % 60;
                    
                    timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
                    
                    if (timeLeft <= 0) {
                        clearInterval(countdownInterval);
                        timerDisplay.textContent = '00:00';
                        resendButton.disabled = false;
                    }
                }, 1000);
            }
        </script>
    </body>
</html>