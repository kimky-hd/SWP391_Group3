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
            background: linear-gradient(135deg, #e0f7f1 0%, #c5f1e6 100%);
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

<style>
    .modal-confirm {
        max-width: 450px;
        margin: 2rem auto;
        transform: scale(0.8);
        transition: transform 0.3s ease;
    }
    .modal.show .modal-confirm {
        transform: scale(1);
    }
    .modal-confirm .modal-content {
        border-radius: 20px;
        border: none;
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(15px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    }
    .modal-confirm .modal-header {
        background: linear-gradient(135deg, #FFB6C1, #FF69B4);
        border-radius: 20px 20px 0 0;
        border: none;
        text-align: center;
        padding: 25px 20px;
        position: relative;
        overflow: hidden;
    }
    .modal-confirm .modal-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(45deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 100%);
        pointer-events: none;
    }
    .modal-confirm .modal-title {
        color: white;
        font-size: 1.8rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 3px;
        text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
        margin: 0;
    }
    .modal-confirm .modal-body {
        padding: 35px 25px;
        text-align: center;
        font-size: 1.2rem;
        font-weight: 500;
        color: #444;
        background: linear-gradient(135deg, rgba(255,255,255,0.5) 0%, rgba(255,255,255,0) 100%);
    }
    .modal-confirm .icon-box {
        width: 100px;
        height: 100px;
        margin: 0 auto 25px;
        border-radius: 50%;
        background: linear-gradient(135deg, #FFF0F5, #FFB6C1);
        padding: 20px;
        text-align: center;
        box-shadow: 0 10px 20px rgba(255, 182, 193, 0.3);
        animation: pulse 2s infinite;
    }
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
    }
    .modal-confirm .icon-box i {
        font-size: 50px;
        color: #FF69B4;
        text-shadow: 2px 2px 8px rgba(255, 105, 180, 0.3);
        line-height: 60px;
    }
    .modal-confirm .modal-footer {
        border: none;
        border-radius: 0 0 20px 20px;
        padding: 20px 25px;
        text-align: center;
        background: rgba(255, 255, 255, 0.9);
    }
    .modal-confirm .btn {
        padding: 12px 35px;
        font-size: 1.1rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 2px;
        border-radius: 50px;
        transition: all 0.4s ease;
        margin: 0 10px;
        position: relative;
        overflow: hidden;
    }
    .modal-confirm .btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(45deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 100%);
        transition: all 0.4s ease;
    }
    .modal-confirm .btn:hover::before {
        transform: translateX(100%);
    }
    .modal-confirm .btn-secondary {
        background: linear-gradient(135deg, #F5F5F5, #E0E0E0);
        border: none;
        color: #666;
    }
    .modal-confirm .btn-secondary:hover {
        background: linear-gradient(135deg, #E0E0E0, #D5D5D5);
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
    }
    .modal-confirm .btn-danger {
        background: linear-gradient(135deg, #FFB6C1, #FF69B4);
        border: none;
        color: white;
        text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.2);
    }
    .modal-confirm .btn-danger:hover {
        background: linear-gradient(135deg, #FF69B4, #FF1493);
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(255, 105, 180, 0.4);
    }
    .modal-backdrop.show {
        opacity: 0.7;
    }
</style>

<!-- Modal Xác nhận đăng xuất -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-confirm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="logoutModalLabel">Xác nhận đăng xuất</h5>
            </div>
            <div class="modal-body">
                <div class="icon-box">
                    <i class="fas fa-sign-out-alt"></i>
                </div>
                <p>Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                <a href="logout" class="btn btn-danger">Đăng xuất</a>
            </div>
        </div>
    </div>
</div>