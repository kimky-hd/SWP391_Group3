<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Account"%>
<%@page import="Model.Profile"%>
<%@page import="DAO.AccountDAO"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đổi mật khẩu - Flower Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta8FYhReZ3g4mQjX5BUhzjFhM2Q/OpF/g/FLs5tQz6S+D" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

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


        <style>
            /* CSS cho giao diện đổi mật khẩu phù hợp với shop hoa */
            :root {
                --primary-pink: #e91e63;
                --light-pink: #fce4ec;
                --medium-pink: #f8bbd0;
                --dark-pink: #d81b60;
                --rose-accent: #f48fb1;
                --green-accent: #a5d6a7;
                --light-green: #e8f5e9;
            }

            body {
                background-color: #fff;
                font-family: 'Montserrat', sans-serif;
                color: #555;
                background-image: url('img/Pink Watercolor Abstract Linktree Background.png');
                background-size: cover;
                background-attachment: fixed;
                background-position: center;
            }

            .profile-container {
                max-width: 1000px;
                margin: 40px auto;
                padding: 0 20px;
            }

            .profile-card {
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                background-color: rgba(255, 255, 255, 0.95);
                overflow: hidden;
                border: none;
                transition: transform 0.3s ease;
            }

            .profile-header {
                background: linear-gradient(135deg, var(--medium-pink) 0%, var(--primary-pink) 100%);
                padding: 25px 20px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .profile-header::before {
                content: "";
                position: absolute;
                top: -10px;
                right: -10px;
                bottom: -10px;
                left: -10px;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40"><path d="M20,0 C20,10 30,20 40,20 C30,20 20,30 20,40 C20,30 10,20 0,20 C10,20 20,10 20,0 Z" fill="%23ffffff" opacity="0.2"/></svg>');
                background-size: 40px 40px;
                background-repeat: repeat;
                opacity: 0.3;
                z-index: 0;
            }

            .profile-card h2 {
                color: #fff;
                font-weight: 600;
                margin-bottom: 0;
                font-size: 28px;
                text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
                position: relative;
                z-index: 1;
            }

            .profile-body {
                padding: 30px;
            }

            .form-floating {
                margin-bottom: 20px;
            }

            .form-floating > .form-control {
                padding: 1.5rem 1rem;
                height: calc(3.5rem + 2px);
                line-height: 1.25;
                border-radius: 15px;
                border: 1px solid #f0f0f0;
                background-color: #fff;
                transition: all 0.3s ease;
            }

            .form-floating > label {
                padding: 1rem 1rem;
                color: var(--primary-pink);
                opacity: 0.8;
            }

            .form-floating > .form-control:focus {
                box-shadow: 0 0 0 3px rgba(233, 30, 99, 0.1);
                border-color: var(--primary-pink);
            }

            .form-floating > .form-control:focus ~ label {
                color: var(--primary-pink);
                opacity: 1;
            }

            .btn-save {
                background: linear-gradient(135deg, var(--primary-pink) 0%, var(--dark-pink) 100%);
                color: white;
                border: none;
                border-radius: 30px;
                padding: 12px 25px;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(233, 30, 99, 0.3);
                width: 100%;
                font-size: 16px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .btn-save:hover {
                background: linear-gradient(135deg, var(--dark-pink) 0%, var(--primary-pink) 100%);
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(233, 30, 99, 0.4);
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: var(--primary-pink);
                text-decoration: none;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .back-link:hover {
                color: var(--dark-pink);
                transform: translateX(-5px);
            }

            .back-link i {
                margin-right: 5px;
            }

            .alert {
                border-radius: 15px;
                padding: 15px 20px;
                margin-bottom: 20px;
                border: none;
                display: flex;
                align-items: center;
            }

            .alert-danger {
                background-color: #ffebee;
                color: #c62828;
                border-left: 4px solid #f44336;
            }

            .alert-success {
                background-color: #e8f5e9;
                color: #2e7d32;
                border-left: 4px solid #4caf50;
            }

            .alert i {
                margin-right: 10px;
                font-size: 18px;
            }

            .form-text {
                color: #757575;
                font-size: 13px;
                margin-top: 5px;
                padding-left: 10px;
                border-left: 2px solid var(--medium-pink);
            }

            /* Floral decorations */
            .floral-decoration {
                position: absolute;
                width: 80px;
                height: 80px;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 80 80"><path d="M40,0 C40,20 60,40 80,40 C60,40 40,60 40,80 C40,60 20,40 0,40 C20,40 40,20 40,0 Z" fill="%23f8bbd0" opacity="0.5"/></svg>');
                background-size: contain;
                background-repeat: no-repeat;
                z-index: 0;
            }

            .floral-top-right {
                top: -20px;
                right: -20px;
                transform: rotate(45deg);
            }

            .floral-bottom-left {
                bottom: -20px;
                left: -20px;
                transform: rotate(225deg);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .profile-container {
                    margin: 20px auto;
                }

                .profile-header {
                    padding: 20px 15px;
                }

                .profile-body {
                    padding: 20px;
                }
            }
        </style>
    </head>

    <body>
        <!-- Topbar Start -->
        <div class="container-fluid">
            <div class="row bg-secondary py-1 px-xl-5">
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="d-inline-flex align-items-center h-100">
                        <a class="text-body mr-3" href="">About</a>
                        <a class="text-body mr-3" href="">Contact</a>
                        <a class="text-body mr-3" href="">Help</a>
                        <a class="text-body mr-3" href="">FAQs</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center text-lg-right">
                    <div class="d-inline-flex align-items-center">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown">
                                <%= acc.getUsername() %>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="VoucherController" class="dropdown-item">Voucher của tôi</a>
                                <button type="button" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</button>
                            </div>
                        </div>
                        <% } else { %>
                        <a href="login.jsp" class="btn btn-sm btn-light mr-2">Đăng nhập</a>
                        <a href="register.jsp" class="btn btn-sm btn-light">Đăng ký</a>
                        <% } %>
                    </div>
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
            </div>
            <div class="row align-items-center bg-light py-3 px-xl-5 d-none d-lg-flex">
                <div class="col-lg-4">
                    <a href="" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Bán</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm">
                            <div class="input-group-append">
                                <span class="input-group-text bg-transparent text-primary">
                                    <i class="fa fa-search"></i>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-lg-4 col-6 text-right">
                    <p class="m-0">Hỗ trợ khách hàng</p>
                    <h5 class="m-0">+012 345 6789</h5>
                </div>
            </div>
        </div>
        <!-- Topbar End -->


    <!-- Footer Start -->
    <!-- Footer End -->


        <!-- Navbar Start -->
        <div class="container-fluid bg-pink mb-30">
            <div class="row px-xl-5">
                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0 w-100">

                        <a href="#" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>

                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse justify-content-center" id="navbarCollapse">
                            <div class="navbar-nav py-0">
                                <a href="Homepage" class="nav-item nav-link active">Trang chủ</a>
                                <a href="ViewListProductController" class="nav-item nav-link ">Sản phẩm</a>
                                <a href="detail.html" class="nav-item nav-link">Chi tiết</a>
                                <a href="VoucherController" class="nav-item nav-link">Mã giảm giá</a>
                                <a href="blogs" class="nav-item nav-link">Bài viết</a>

                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Trang<i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">

                                        <a href="Cart.jsp" class="dropdown-item">Giỏ hàng</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Thanh toán</a>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-none d-lg-flex align-items-center ml-auto">
                            <a href="#" class="btn px-0">
                                <i class="fas fa-heart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                            </a>
                            <a href="Cart.jsp" class="btn px-0 ml-3">
                                <i class="fas fa-shopping-cart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                                </span>
                            </a>
                            <a href="order?action=view" class="btn px-0 ml-3">
                                <i class="fas fa-clipboard-list text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.orderCount != null ? sessionScope.orderCount : 0}
                                </span>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar End -->

        <%
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <!-- Toast container -->
        <div class="toast-container"></div>

        <div class="container profile-container">
            <div class="card profile-card">
                <div class="profile-header">
                    <h2>Đổi mật khẩu</h2>
                    <!-- Floral decorations -->
                    <div class="floral-decoration floral-top-right"></div>
                    <div class="floral-decoration floral-bottom-left"></div>
                </div>

                <div class="profile-body">
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <% if(request.getAttribute("success") != null) { %>
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <form action="account" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="changePassword">
                        
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Mật khẩu hiện tại" required>
                            <label for="currentPassword"><i class="fas fa-lock me-2"></i>Mật khẩu hiện tại</label>
                        </div>
                        
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Mật khẩu mới" required>
                            <label for="newPassword"><i class="fas fa-key me-2"></i>Mật khẩu mới</label>
                            <div class="form-text">
                                Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số, không được chứa khoảng trắng, và không được giống mật khẩu cũ
                            </div>
                        </div>
                        
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                            <label for="confirmPassword"><i class="fas fa-check-circle me-2"></i>Xác nhận mật khẩu mới</label>
                        </div>
                        
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save me-2"></i>Đổi mật khẩu
                        </button>
                        
                        <a href="profile.jsp" class="back-link">
                            <i class="fas fa-arrow-left"></i> Quay lại trang cá nhân
                        </a>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer Start -->
        <jsp:include page="footer.jsp" />
        <!-- Footer End -->

        <!-- Back to Top -->
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Contact Javascript File -->
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>

        <script>
            function validateForm() {
                var currentPassword = document.getElementById("currentPassword").value;
                var newPassword = document.getElementById("newPassword").value;
                var confirmPassword = document.getElementById("confirmPassword").value;
                
                // Kiểm tra mật khẩu mới có đủ mạnh không
                var hasUpperCase = /[A-Z]/.test(newPassword);
                var hasLowerCase = /[a-z]/.test(newPassword);
                var hasNumbers = /\d/.test(newPassword);
                var isLongEnough = newPassword.length >= 8;
                var hasNoWhitespace = !/\s/.test(newPassword);
                
                if (!hasUpperCase || !hasLowerCase || !hasNumbers || !isLongEnough || !hasNoWhitespace) {
                    showToast("Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số, và không được chứa khoảng trắng!", "error");
                    return false;
                }
                
                // Kiểm tra mật khẩu mới không được giống mật khẩu cũ
                if (newPassword === currentPassword) {
                    showToast("Mật khẩu mới không được giống mật khẩu cũ!", "error");
                    return false;
                }
                
                // Kiểm tra mật khẩu xác nhận
                if (newPassword !== confirmPassword) {
                    showToast("Mật khẩu xác nhận không khớp!", "error");
                    return false;
                }
                
                return true;
            }
            
            // Hàm hiển thị thông báo dạng toast
            function showToast(message, type = 'success') {
                const container = document.querySelector('.toast-container');
                const toast = document.createElement('div');
                toast.className = `toast ${type}`;
                toast.textContent = message;

                container.appendChild(toast);

                toast.offsetHeight; // Kích hoạt reflow để áp dụng hiệu ứng

                toast.classList.add('show'); // Thêm class để hiển thị

                // Xóa toast sau 3 giây
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => {
                        container.removeChild(toast);
                    }, 400); // Delay để khớp với transition
                }, 3000);
            }
        </script>
        
        <style>
            /* Toast styles */
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                font-family: 'Montserrat', sans-serif;
            }

            .toast {
                padding: 15px 25px;
                margin-bottom: 12px;
                border-radius: 12px;
                color: #5f375f;
                background-color: var(--light-pink);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.4s ease-in-out;
                border-left: 6px solid var(--rose-accent);
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.success {
                background-color: var(--light-green);
                border-left-color: var(--green-accent);
                color: #2e7d32;
            }

            .toast.error {
                background-color: var(--light-pink);
                border-left-color: var(--dark-pink);
                color: #c2185b;
            }
        </style>
    </body>
</html>