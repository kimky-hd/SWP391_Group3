<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập - Flower Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <style>
            .search-input {
    border-radius: 20px 0 0 20px;
    border: 2px solid var(--primary-pink);
    border-right: none;
    padding: 0.375rem 1rem;
    height: 36px; /* hoặc chiều cao bạn muốn */
    font-size: 1rem;
    background-color: #fffafc; /* ví dụ màu nhẹ khác biệt */
            }
            :root {
                --primary: #FFB6C1;
                --primary-hover: #FFA5B5;
            }

            body {
                background-color: #fff;
                margin: 0;
                padding: 0;
            }

            .login-container {
                padding: 30px 0;
                margin-bottom: 0; /* Giảm khoảng cách với footer */
            }

            /* Style cho các phần tử trong trang login */
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
            
            /* Style cho nút đăng nhập Google */
            .btn-google {
                background: linear-gradient(45deg, #ffffff, #f8f9fa);
                border: 2px solid #eaeaea;
                color: #444;
                font-weight: 600;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 10px;
                border-radius: 10px;
            }
            
            .btn-google:hover {
                background: linear-gradient(45deg, #f8f9fa, #ffffff);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                color: #222;
            }
            
            .btn-google .fab {
                color: #DB4437;
                font-size: 1.2rem;
            }
            
            .or-divider {
                display: flex;
                align-items: center;
                margin: 20px 0;
                color: #999;
                font-size: 0.9rem;
            }
            
            .or-divider:before,
            .or-divider:after {
                content: "";
                flex: 1;
                border-bottom: 1px solid #eee;
                margin: 0 10px;
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

            /* Đảm bảo không ảnh hưởng đến style của header */
            .row.bg-secondary {
                background-color: #6c757d !important;
            }

            .row.bg-light {
                background-color: #f8f9fa !important;
            }

            /* Đảm bảo chiều cao phù hợp */
            @media (min-height: 800px) {
                .login-container {
                    min-height: calc(100vh - 400px); /* Điều chỉnh chiều cao dựa trên kích thước header và footer */
                    display: flex;
                    align-items: center;
                }
            }

            @media (max-height: 800px) {
                .login-container {
                    min-height: auto;
                    padding: 30px 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include header -->
        
        <jsp:include page="header.jsp"/>
        <!-- Login container -->
        <div class="login-container">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-5">
                        <div class="card">
                            <div class="card-header text-center py-4">
                                <h3 class="mb-0 fw-bold">Đăng nhập</h3>
                            </div>
                            <div class="card-body p-4">
                                <% if(request.getAttribute("error") != null) { %>
                                <div class="alert alert-danger d-flex align-items-center" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                                <% } %>
                                <% if(request.getAttribute("success") != null) { %>
                                <div class="alert alert-success d-flex align-items-center" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <%= request.getAttribute("success") %>
                                </div>
                                <% } %>
                                
                                <!-- Nút đăng nhập Google với thiết kế mới -->
                                <a href="LoginWithGoogle" class="btn btn-google w-100 py-3 mb-3">
                                    <i class="fab fa-google me-2"></i> Đăng nhập bằng Google
                                </a>
                                
                                <div class="or-divider">
                                    <span>HOẶC</span>
                                </div>
                                
                                <form action="LoginServlet" method="post" onsubmit="return validateForm()">
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="userInput" name="userInput" placeholder="Email, SĐT hoặc Tên đăng nhập" required
                                            value="${userInput != null ? userInput : ''}">
                                            <label for="userInput"><i class="fas fa-user me-2"></i>Email, SĐT hoặc Tên đăng nhập</label>
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <div class="form-floating">
                                            <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                                            <label for="password"><i class="fas fa-lock me-2"></i>Mật khẩu</label>
                                        </div>
                                    </div>
                                    <div class="mb-3 form-check">
                                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                                        <label class="form-check-label" for="rememberMe">Nhớ mật khẩu</label>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-pink py-3">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </button>
                                    </div>
                                </form>
                                <div class="text-center mt-4">
                                    <p class="mb-2">Chưa có tài khoản? <a href="register.jsp" class="text-pink fw-bold">Đăng ký ngay</a></p>

                                    <p class="mb-2"><a href="forgotpassword.jsp" class="text-pink fw-bold">Quên mật khẩu?</a></p>
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
            window.onload = function () {
                // Đảm bảo header hiển thị đúng
                document.querySelectorAll('.row.bg-secondary').forEach(function (el) {
                    el.style.backgroundColor = '#6c757d !important';
                });

                document.querySelectorAll('.row.bg-light').forEach(function (el) {
                    el.style.backgroundColor = '#f8f9fa !important';
                });

                // Lấy cookie theo tên
                function getCookie(name) {
                    let cookieArr = document.cookie.split(";");

                    for (let i = 0; i < cookieArr.length; i++) {
                        let cookiePair = cookieArr[i].split("=");
                        let cookieName = cookiePair[0].trim();

                        if (cookieName === name) {
                            return decodeURIComponent(cookiePair[1]);
                        }
                    }
                    return null;
                }

                // Giải mã Base64
                function decodeBase64(str) {
                    try {
                        return atob(str);
                    } catch (e) {
                        console.error('Lỗi giải mã Base64:', e);
                        return '';
                    }
                }

                // Tự động điền form từ cookie
                let savedUserInput = getCookie("savedUserInput");
                let savedPassword = getCookie("savedPassword");

                if (savedUserInput && savedPassword) {
                    document.getElementById("userInput").value = decodeBase64(savedUserInput);
                    document.getElementById("password").value = decodeBase64(savedPassword);
                    document.getElementById("rememberMe").checked = true;
                }
            }

            function validateForm() {
                var userInput = document.getElementById("userInput").value;
                var password = document.getElementById("password").value;

                if (userInput.trim() === "" || password.trim() === "") {
                    alert("Vui lòng điền đầy đủ thông tin đăng nhập!");
                    return false;
                }
                return true;
            }

            <% 
            String successMsg = (String)request.getAttribute("success");
            if(successMsg != null && !successMsg.contains("Đăng ký thành công")) { 
            %>
            setTimeout(function () {
                window.location.href = "Homepage";
            }, 1500);

            if (${sessionScope.account != null}) {
                fetch('ordercount')
                    .then(response => {
                        if (response.ok) {
                            window.location.href = 'Homepage';
                        }
                    });
            }
            <% } %>
        </script>
    </body>
</html>
