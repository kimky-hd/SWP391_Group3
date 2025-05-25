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
            --primary: #D19C97;
            --primary-hover: #B98E89;
        }
        .bg-pink {
            background-color: var(--primary) !important;
        }
        .text-pink {
            color: var(--primary) !important;
        }
        .btn-pink {
            background-color: var(--primary);
            border-color: var(--primary);
            color: white;
        }
        .btn-pink:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
            color: white;
        }
        .card {
            border: none;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: var(--primary);
            color: white;
            border: none;
        }
        a.text-pink:hover {
            color: var(--primary-hover) !important;
            text-decoration: underline;
        }
        .ml-n1 {
            margin-left: -0.25rem !important;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="text-center mb-4">
                    <a href="home.jsp" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
                    </a>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center mb-0">Đăng nhập</h3>
                    </div>
                    <div class="card-body">
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        <% if(request.getAttribute("success") != null) { %>
                            <div class="alert alert-success" role="alert">
                                <%= request.getAttribute("success") %>
                            </div>
                        <% } %>
                        <form action="login" method="post" onsubmit="return validateForm()">
                            <div class="mb-3">
                                <label for="userInput" class="form-label">Email hoặc Tên đăng nhập</label>
                                <input type="text" class="form-control" id="userInput" name="userInput" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-pink w-100">Đăng nhập</button>
                            </div>
                        </form>
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
                            
                            // Kiểm tra thông báo thành công và chuyển hướng
                            <% if(request.getAttribute("success") != null) { %>
                                setTimeout(function() {
                                    window.location.href = "index.html";
                                }, 1500);
                            <% } %>
                        </script>
                        <div class="text-center mt-3">
                            <p>Chưa có tài khoản? <a href="register.jsp" class="text-pink">Đăng ký ngay</a></p>
                            <a href="Homepage" class="text-decoration-none text-muted">
                                <i class="fas fa-arrow-left"></i> Quay về trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>