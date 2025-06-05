<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Flower Shop</title>
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
                        <h3 class="mb-0 fw-bold">Quên mật khẩu</h3>
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
                        <form action="forgot-password" method="post">
                            <input type="hidden" name="action" value="request">
                            <div class="mb-4">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="emailOrPhone" name="email" placeholder="Email" required>
                                    <label for="emailOrPhone"><i class="fas fa-envelope me-2"></i>Email</label>
                                </div>
                                <small class="form-text text-muted">Nhập email đã đăng ký để nhận mã xác nhận</small>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-pink py-3">
                                    <i class="fas fa-paper-plane me-2"></i>Gửi mã xác nhận
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-4">
                            <a href="login.jsp" class="text-decoration-none back-to-home">
                                <i class="fas fa-arrow-left me-1"></i> Quay lại đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>