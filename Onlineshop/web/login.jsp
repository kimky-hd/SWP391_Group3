<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #FFB6C1;
            --primary-hover: #FFA5B5;
        }
        body {
            background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
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
            border: 2px solid #FFE4E8;
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
            background-color: #F0FFF0;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="text-center mb-4 logo-animation">
                    <a href="Homepage" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-3 py-2">Flower</span>
                        <span class="h1 text-uppercase text-pink bg-light px-3 py-2">Shop</span>
                    </a>
                </div>
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
                        <form action="LoginServlet" method="post" onsubmit="return validateForm()">
                            <div class="mb-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="userInput" name="userInput" placeholder="Email hoặc Tên đăng nhập" required>
                                    <label for="userInput"><i class="fas fa-user me-2"></i>Email hoặc Tên đăng nhập</label>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                                    <label for="password"><i class="fas fa-lock me-2"></i>Mật khẩu</label>
                                </div>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-pink py-3">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                </button>
                            </div>
                        </form>
                        <div class="text-center mt-4">
                            <p class="mb-2">Chưa có tài khoản? <a href="register.jsp" class="text-pink fw-bold">Đăng ký ngay</a></p>
                            <a href="Homepage" class="text-decoration-none back-to-home">
                                <i class="fas fa-arrow-left me-1"></i> Quay về trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function validateForm() {
            var userInput = document.getElementById("userInput").value;
            var password = document.getElementById("password").value;
            
            if (userInput.trim() === "" || password.trim() === "") {
                alert("Vui lòng điền đầy đủ thông tin đăng nhập!");
                return false;
            }
            return true;
        }
        
        <% if(request.getAttribute("success") != null) { %>
            setTimeout(function() {
                window.location.href = "index.html";
            }, 1500);
        <% } %>
    </script>
</body>
</html>