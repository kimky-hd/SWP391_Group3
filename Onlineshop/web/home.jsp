<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="#">
                <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Giỏ hàng</a>
                    </li>
                    <% if(session.getAttribute("account") != null) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="logout">Đăng xuất</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">Đăng nhập</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-header">
        <div class="container text-center text-white py-5">
            <h1 class="display-4 mb-4">Chào mừng đến với Flower Shop</h1>
            <p class="lead mb-4">Khám phá bộ sưu tập hoa tươi độc đáo và đẹp mắt của chúng tôi</p>
            <a href="#" class="btn btn-outline-light btn-lg">Xem sản phẩm</a>
        </div>
    </div>

    <!-- Featured Products -->
    <div class="container py-5">
        <h2 class="text-center mb-5">Sản phẩm nổi bật</h2>
        <div class="row g-4">
            <!-- Product 1 -->
            <div class="col-lg-3 col-md-6">
                <div class="card product-card">
                    <img src="assets/img/product-1.jpg" class="card-img-top" alt="Hoa hồng">
                    <div class="card-body text-center">
                        <h5 class="card-title">Bó Hoa Hồng</h5>
                        <p class="card-text text-pink">500.000đ</p>
                        <a href="#" class="btn btn-pink">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
            <!-- Product 2 -->
            <div class="col-lg-3 col-md-6">
                <div class="card product-card">
                    <img src="assets/img/product-2.jpg" class="card-img-top" alt="Hoa tulip">
                    <div class="card-body text-center">
                        <h5 class="card-title">Bó Hoa Tulip</h5>
                        <p class="card-text text-pink">600.000đ</p>
                        <a href="#" class="btn btn-pink">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
            <!-- Product 3 -->
            <div class="col-lg-3 col-md-6">
                <div class="card product-card">
                    <img src="assets/img/product-3.jpg" class="card-img-top" alt="Hoa cúc">
                    <div class="card-body text-center">
                        <h5 class="card-title">Bó Hoa Cúc</h5>
                        <p class="card-text text-pink">400.000đ</p>
                        <a href="#" class="btn btn-pink">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
            <!-- Product 4 -->
            <div class="col-lg-3 col-md-6">
                <div class="card product-card">
                    <img src="assets/img/product-4.jpg" class="card-img-top" alt="Hoa lan">
                    <div class="card-body text-center">
                        <h5 class="card-title">Bó Hoa Lan</h5>
                        <p class="card-text text-pink">700.000đ</p>
                        <a href="#" class="btn btn-pink">Thêm vào giỏ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>Về chúng tôi</h5>
                    <p>Flower Shop - Nơi mang đến những bông hoa tươi đẹp nhất cho khách hàng.</p>
                </div>
                <div class="col-md-4">
                    <h5>Liên hệ</h5>
                    <p>
                        <i class="fas fa-phone"></i> +84 123 456 789<br>
                        <i class="fas fa-envelope"></i> info@flowershop.com<br>
                        <i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận XYZ, TP.HCM
                    </p>
                </div>
                <div class="col-md-4">
                    <h5>Theo dõi chúng tôi</h5>
                    <div class="social-links">
                        <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-light"><i class="fab fa-twitter"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
</body>
</html>