<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Flower Shop</title>
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
        
        .forgot-container {
            padding: 30px 0;
            margin-bottom: 0; /* Giảm khoảng cách với footer */
        }
        
        /* Style cho các phần tử trong trang */
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
        
        /* Đảm bảo không ảnh hưởng đến style của header */
        .row.bg-secondary {
            background-color: #6c757d !important;
        }

        .row.bg-light {
            background-color: #f8f9fa !important;
        }

        /* Đảm bảo chiều cao phù hợp */
        @media (min-height: 800px) {
            .forgot-container {
                min-height: calc(100vh - 400px); /* Điều chỉnh chiều cao dựa trên kích thước header và footer */
                display: flex;
                align-items: center;
            }
        }

        @media (max-height: 800px) {
            .forgot-container {
                min-height: auto;
                padding: 30px 0;
            }
        }
    </style>
</head>
<body>
    <!-- Header giống như trong login.jsp -->
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
    <div class="row align-items-center bg-light py-3 px-xl-5 d-none d-lg-flex">
        <div class="col-lg-4">
            <a href="Homepage.jsp" class="text-decoration-none logo-container">
                <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
            </a>
        </div>
        <div class="col-lg-4 col-6 text-left">
            <form action="SearchProductByTitle" class="search-form">
                <div class="input-group">
                    <input type="text" name="txt" class="form-control search-input" placeholder="Tìm kiếm sản phẩm" value="${txt}">
                    <div class="input-group-append">
                        <button class="btn btn-pink">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-lg-4 col-6 text-end ms-auto">
            <p class="m-0">Hỗ trợ khách hàng</p>
            <h5 class="m-0 text-pink">+012 345 6789</h5>
        </div>
    </div>
    
    <!-- Forgot password container -->
    <div class="forgot-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5">
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
                                        <input type="text" class="form-control" id="emailOrPhone" name="email" placeholder="Email" required value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
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
    </div>
    
    <!-- Include footer -->
    <jsp:include page="footer.jsp" />

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    window.onload = function () {
        // Đảm bảo header hiển thị đúng
        document.querySelectorAll('.row.bg-secondary').forEach(function (el) {
            el.style.backgroundColor = '#6c757d !important';
        });

        document.querySelectorAll('.row.bg-light').forEach(function (el) {
            el.style.backgroundColor = '#f8f9fa !important';
        });
    }
</script>
</body>
</html>