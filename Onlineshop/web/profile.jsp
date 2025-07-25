<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Account"%>
<%@page import="Model.Profile"%>
<%@page import="DAO.AccountDAO"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ cá nhân - Flower Shop</title>
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
            /* CSS cho giao diện hồ sơ phù hợp với shop hoa */
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

            .profile-content {
                display: flex;
                flex-wrap: wrap;
            }

            .profile-image-section {
                flex: 0 0 300px;
                padding: 30px;
                background: linear-gradient(135deg, var(--light-pink) 0%, #fff 100%);
                border-right: 1px solid var(--medium-pink);
                display: flex;
                flex-direction: column;
                align-items: center;
                position: relative;
            }

            .profile-image-section::before {
                content: "";
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><path d="M30,50 C30,40 40,30 50,30 C60,30 70,40 70,50 C70,60 60,70 50,70 C40,70 30,60 30,50 Z" fill="none" stroke="%23f8bbd0" stroke-width="1"/></svg>');
                background-size: 100px 100px;
                opacity: 0.3;
                z-index: 0;
            }

            .profile-info-section {
                flex: 1;
                padding: 30px;
                position: relative;
            }

            .profile-info-section::before {
                content: "";
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><circle cx="10" cy="10" r="2" fill="%23f8bbd0"/></svg>');
                background-size: 20px 20px;
                opacity: 0.1;
                z-index: 0;
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
                padding: 0;
            }

            .profile-info .list-group-item {
                background-color: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 15px;
                margin-bottom: 15px;
                padding: 15px 20px;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                z-index: 1;
            }

            .profile-info .list-group-item:hover {
                background-color: var(--light-pink);
                transform: translateX(5px);
                box-shadow: 0 5px 15px rgba(233, 30, 99, 0.1);
            }

            .profile-info .list-group-item::after {
                content: "";
                position: absolute;
                bottom: -10px;
                right: -10px;
                width: 40px;
                height: 40px;
                background-color: var(--medium-pink);
                opacity: 0.1;
                border-radius: 50%;
                z-index: -1;
            }

            .profile-info .list-group-item strong {
                color: var(--primary-pink);
                font-weight: 600;
                display: block;
                margin-bottom: 5px;
                font-size: 14px;
            }

            .profile-info .list-group-item span {
                font-size: 16px;
                color: #555;
            }

            .edit-icon {
                color: var(--primary-pink);
                cursor: pointer;
                position: absolute;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                opacity: 0.7;
                transition: all 0.3s ease;
                background-color: #fff;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                border: 1px solid var(--medium-pink);
            }

            .edit-icon:hover {
                opacity: 1;
                background-color: var(--primary-pink);
                color: white;
                transform: translateY(-50%) scale(1.1);
            }

            .btn-save {
                background-color: var(--primary-pink);
                color: white;
                border: none;
                border-radius: 30px;
                padding: 10px 25px;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(233, 30, 99, 0.3);
            }

            .btn-save:hover {
                background-color: var(--dark-pink);
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(233, 30, 99, 0.4);
            }

            .btn-cancel {
                background-color: #f8f9fa;
                color: #6c757d;
                border: 1px solid #e9ecef;
                border-radius: 30px;
                padding: 10px 25px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-cancel:hover {
                background-color: #e9ecef;
                color: #495057;
            }

            .profile-image-container {
                position: relative;
                width: 180px;
                height: 180px;
                margin: 0 auto 20px;
                z-index: 1;
            }

            .profile-image {
                width: 180px;
                height: 180px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #fff;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }

            .profile-image:hover {
                transform: scale(1.05);
            }

            .image-upload {
                position: relative;
            }

            .image-upload .camera-icon {
                position: absolute;
                bottom: 5px;
                right: 5px;
                background-color: var(--primary-pink);
                color: white;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
                border: 3px solid white;
                font-size: 18px;
            }

            .image-upload .camera-icon:hover {
                transform: scale(1.1);
                background-color: var(--dark-pink);
            }

            .username-display {
                text-align: center;
                font-size: 24px;
                font-weight: 600;
                margin: 15px 0;
                color: var(--primary-pink);
                position: relative;
                z-index: 1;
            }

            .username-display::after {
                content: "";
                position: absolute;
                bottom: -5px;
                left: 50%;
                transform: translateX(-50%);
                width: 50px;
                height: 2px;
                background-color: var(--medium-pink);
            }

            .action-buttons {
                margin-top: 20px;
                width: 100%;
                z-index: 1;
                position: relative;
            }

            .btn-action {
                border-radius: 30px;
                padding: 12px 25px;
                font-weight: 500;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .btn-edit-all {
                background: linear-gradient(135deg, var(--primary-pink) 0%, var(--dark-pink) 100%);
                color: white;
                border: none;
                box-shadow: 0 4px 15px rgba(233, 30, 99, 0.3);
            }

            .btn-edit-all:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(233, 30, 99, 0.4);
                color: white;
            }

            .btn-edit-all i {
                margin-right: 10px;
            }

            .btn-password {
                background-color: white;
                color: #555;
                border: 1px solid var(--medium-pink);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            }

            .btn-password:hover {
                background-color: var(--light-pink);
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            }

            .btn-password i {
                margin-right: 10px;
                color: var(--primary-pink);
            }

            .btn-logout {
                background-color: #fff;
                color: #dc3545;
                border: 1px solid #f8f9fa;
            }

            .btn-logout:hover {
                background-color: #dc3545;
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(220, 53, 69, 0.2);
            }

            .btn-logout i {
                margin-right: 10px;
            }

            /* Modal styling */
            .modal-content {
                border-radius: 20px;
                border: none;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .modal-header {
                background: linear-gradient(135deg, var(--medium-pink) 0%, var(--primary-pink) 100%);
                border-bottom: none;
                padding: 20px 30px;
                position: relative;
                overflow: hidden;
            }

            .modal-header::before {
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

            .modal-title {
                color: white;
                font-weight: 600;
                font-size: 22px;
                text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
                position: relative;
                z-index: 1;
            }

            .modal-body {
                padding: 30px;
            }

            .modal-footer {
                border-top: none;
                padding: 20px 30px;
            }

            .form-label {
                color: var(--primary-pink);
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 8px;
            }

            .form-control {
                border-radius: 10px;
                padding: 12px 15px;
                border: 1px solid #e9ecef;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                box-shadow: 0 0 0 3px rgba(233, 30, 99, 0.1);
                border-color: var(--primary-pink);
            }

            .btn-close {
                background-color: white;
                opacity: 1;
                padding: 8px;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                z-index: 1;
            }

            .gender-options {
                display: flex;
                gap: 15px;
            }

            .gender-option {
                cursor: pointer;
                display: flex;
                align-items: center;
                padding: 8px 15px;
                background-color: #f8f9fa;
                border-radius: 30px;
                transition: all 0.3s ease;
                border: 1px solid transparent;
            }

            .gender-option:hover {
                background-color: var(--light-pink);
                border-color: var(--medium-pink);
            }

            .gender-option input {
                margin-right: 8px;
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

            /* Responsive adjustments */
            @media (max-width: 992px) {
                .profile-content {
                    flex-direction: column;
                }

                .profile-image-section {
                    flex: 0 0 100%;
                    border-right: none;
                    border-bottom: 1px solid var(--medium-pink);
                    max-width: 100%;
                }

                .profile-image-container {
                    width: 150px;
                    height: 150px;
                }

                .profile-image {
                    width: 150px;
                    height: 150px;
                }
            }

            @media (max-width: 768px) {
                .profile-container {
                    margin: 20px auto;
                }

                .profile-header {
                    padding: 20px 15px;
                }

                .profile-body {
                    padding: 0;
                }

                .profile-info .list-group-item {
                    padding: 12px 15px;
                }

                .edit-icon {
                    right: 15px;
                }

                .gender-options {
                    flex-direction: column;
                    gap: 10px;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <%
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Lấy thông tin profile từ session
            Profile profile = (Profile) session.getAttribute("profile");
            // Nếu chưa có profile, tạo đối tượng mới
            if (profile == null) {
                profile = new Profile();
                profile.setAccountId(account.getAccountID());
                profile.setEmail(account.getEmail());
                profile.setPhoneNumber(account.getPhone());
            }
        %>

        <!-- Toast container -->
        <div class="toast-container"></div>

        <div class="container profile-container">
            <div class="card profile-card">
                <div class="profile-header">
                    <h2>Hồ sơ cá nhân</h2>
                    <!-- Floral decorations -->
                    <div class="floral-decoration floral-top-right"></div>
                    <div class="floral-decoration floral-bottom-left"></div>
                </div>

                <div class="profile-body">
                    <div class="profile-content">
                        <!-- Phần ảnh bên trái -->
                        <div class="profile-image-section">
                            <div class="image-upload">
                                <div class="profile-image-container">
                                    <img src="<%= profile.getImg() != null ? profile.getImg() : "img/default-avatar.jpg" %>" alt="Ảnh đại diện" class="profile-image" id="profileImage">
                                    <label for="imageInput" class="camera-icon">
                                        <i class="fas fa-camera"></i>
                                    </label>
                                    <input type="file" id="imageInput" style="display: none;" accept="image/*">
                                </div>
                            </div>
                            <div class="username-display"><%= account.getUsername() %></div>

                            <div class="action-buttons">
                                <button type="button" class="btn btn-action btn-edit-all" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fas fa-user-edit"></i> Chỉnh sửa thông tin
                                </button>
                                <a href="changepassword.jsp" class="btn btn-action btn-password">
                                    <i class="fas fa-key"></i> Đổi mật khẩu
                                </a>
                                <a href="LogoutServlet" class="btn btn-action btn-logout">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
                        </div>

                        <!-- Phần thông tin bên phải -->
                        <div class="profile-info-section">
                            <ul class="list-group list-group-flush profile-info">
                                <li class="list-group-item">
                                    <strong>Họ và tên</strong>
                                    <span id="fullNameDisplay"><%= profile.getFullName() != null ? profile.getFullName() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="fullName"></i>
                                </li>

                                <li class="list-group-item">
                                    <strong>Email</strong>
                                    <span id="emailDisplay"><%= account.getEmail() != null ? account.getEmail() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="email"></i>
                                </li>

                                <li class="list-group-item">
                                    <strong>Số điện thoại</strong>
                                    <span id="phoneDisplay"><%= account.getPhone() != null ? account.getPhone() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="phone"></i>
                                </li>

                                <li class="list-group-item">
                                    <strong>Địa chỉ</strong>
                                    <span id="addressDisplay"><%= profile.getAddress() != null ? profile.getAddress() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="address"></i>
                                </li>

                                <li class="list-group-item">
                                    <strong>Ngày sinh</strong>
                                    <span id="dobDisplay"><%= profile.getDob() != null ? profile.getDob().toString() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="dob"></i>
                                </li>

                                <li class="list-group-item">
                                    <strong>Giới tính</strong>
                                    <span id="genderDisplay"><%= profile.getGender() != null ? profile.getGender() : "Chưa cập nhật" %></span>
                                    <i class="fas fa-edit edit-icon" data-field="gender"></i>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Chỉnh sửa thông tin cá nhân -->
        <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editProfileModalLabel">Chỉnh sửa thông tin cá nhân</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="editProfileForm" method="post" action="profile?action=updateProfile">
                            <div class="mb-3">
                                <label for="modalFullName" class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" id="modalFullName" name="fullName" value="<%= profile.getFullName() != null ? profile.getFullName() : "" %>">
                            </div>
                            <div class="mb-3">
                                <label for="modalEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="modalEmail" name="email" value="<%= account.getEmail() != null ? account.getEmail() : "" %>">
                            </div>
                            <div class="mb-3">
                                <label for="modalPhone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="modalPhone" name="phone" value="<%= account.getPhone() != null ? account.getPhone() : "" %>">
                            </div>
                            <div class="mb-3">
                                <label for="modalAddress" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="modalAddress" name="address" value="<%= profile.getAddress() != null ? profile.getAddress() : "" %>">
                            </div>
                            <div class="mb-3">
                                <label for="modalDob" class="form-label">Ngày sinh</label>
                                <input type="date" class="form-control" id="modalDob" name="dob" value="<%= profile.getDob() != null ? profile.getDob().toString() : "" %>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giới tính</label>
                                <div class="gender-options">
                                    <label class="gender-option">
                                        <input type="radio" name="gender" value="Nam" <%= profile.getGender() != null && profile.getGender().equals("Nam") ? "checked" : "" %>> Nam
                                    </label>
                                    <label class="gender-option">
                                        <input type="radio" name="gender" value="Nữ" <%= profile.getGender() != null && profile.getGender().equals("Nữ") ? "checked" : "" %>> Nữ
                                    </label>
                                    <label class="gender-option">
                                        <input type="radio" name="gender" value="Khác" <%= profile.getGender() != null && profile.getGender().equals("Khác") ? "checked" : "" %>> Khác
                                    </label>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-save" id="saveProfileBtn">Lưu thay đổi</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp" />

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

        <!-- Bootstrap 5 for modal -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Khai báo các phần tử DOM sẽ thao tác
                const editIcons = document.querySelectorAll('.edit-icon');
                const alertContainer = document.querySelector('.alert-container');
                const imageInput = document.getElementById('imageInput');
                const profileImage = document.getElementById('profileImage');
                const saveProfileBtn = document.getElementById('saveProfileBtn');
                const editProfileForm = document.getElementById('editProfileForm');
                const editProfileModal = document.getElementById('editProfileModal');
                const modalInstance = new bootstrap.Modal(editProfileModal); // Tạo instance modal từ Bootstrap

                // Xử lý sự kiện thay đổi ảnh đại diện
                imageInput.addEventListener('change', function () {
                    const file = this.files[0]; // Lấy file đầu tiên người dùng chọn
                    if (file) {
                        const reader = new FileReader(); // Dùng FileReader để đọc file ảnh
                        reader.onload = function (e) {
                            profileImage.src = e.target.result; // Hiển thị ảnh mới trong giao diện
                            uploadImage(file); // Gửi ảnh lên server
                        };
                        reader.readAsDataURL(file); // Đọc file dưới dạng base64
                    }
                });

                // Hàm upload ảnh lên server
                function uploadImage(file) {
                    const formData = new FormData();
                    formData.append('profileImage', file); // Gửi ảnh
                    formData.append('action', 'uploadImage'); // Gửi thêm action để phía server xử lý

                    fetch('profile', {
                        method: 'POST',
                        body: formData
                    })
                            .then(response => response.json())
                            .then(data => {
                                // Hiển thị kết quả thông qua toast
                                if (data.success) {
                                    showToast(data.message, 'success');
                                } else {
                                    showToast(data.message, 'error');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                showToast('Đã xảy ra lỗi khi tải ảnh lên.', 'error');
                            });
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

                // Khi người dùng bấm vào biểu tượng chỉnh sửa (bút)
                editIcons.forEach(icon => {
                    icon.addEventListener('click', function () {
                        const field = this.dataset.field; // Xác định trường sẽ chỉnh sửa
                        modalInstance.show(); // Hiển thị modal

                        // Tự động focus vào input tương ứng sau khi modal mở
                        setTimeout(() => {
                            const modalInput = document.getElementById(`modal${field.charAt(0).toUpperCase() + field.slice(1)}`);
                            if (modalInput) {
                                modalInput.focus();
                                modalInput.select();
                            }
                        }, 500);
                    });
                });

                // Khi bấm nút lưu thông tin trong modal
                saveProfileBtn.addEventListener('click', function () {
                    // Hiệu ứng đang lưu
                    this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang lưu...';
                    this.disabled = true;

                    const formData = new FormData(editProfileForm);
                    formData.append('action', 'updateProfile'); // Thêm action để server xử lý

                    fetch('profile', {
                        method: 'POST',
                        body: formData
                    })
                            .then(response => response.json())
                            .then(data => {
                                // Khôi phục nút lưu
                                saveProfileBtn.innerHTML = 'Lưu thay đổi';
                                saveProfileBtn.disabled = false;

                                if (data.success) {
                                    // Lấy các phần tử hiển thị thông tin cá nhân
                                    const fullNameDisplay = document.getElementById('fullNameDisplay');
                                    const emailDisplay = document.getElementById('emailDisplay');
                                    const phoneDisplay = document.getElementById('phoneDisplay');
                                    const addressDisplay = document.getElementById('addressDisplay');
                                    const dobDisplay = document.getElementById('dobDisplay');
                                    const genderDisplay = document.getElementById('genderDisplay');

                                    // Hiệu ứng highlight khi cập nhật thành công
                                    [fullNameDisplay, emailDisplay, phoneDisplay, addressDisplay, dobDisplay, genderDisplay].forEach(el => {
                                        if (el) {
                                            el.style.transition = 'all 0.3s ease';
                                            el.style.backgroundColor = 'var(--light-pink)';
                                            setTimeout(() => {
                                                el.style.backgroundColor = 'transparent';
                                            }, 1000);
                                        }
                                    });

                                    // Cập nhật thông tin hiển thị
                                    fullNameDisplay.textContent = formData.get('fullName') || 'Chưa cập nhật';
                                    emailDisplay.textContent = formData.get('email') || 'Chưa cập nhật';
                                    phoneDisplay.textContent = formData.get('phone') || 'Chưa cập nhật';
                                    addressDisplay.textContent = formData.get('address') || 'Chưa cập nhật';
                                    dobDisplay.textContent = formData.get('dob') || 'Chưa cập nhật';

                                    // Cập nhật giới tính
                                    const selectedGender = document.querySelector('input[name="gender"]:checked');
                                    genderDisplay.textContent = selectedGender ? selectedGender.value : 'Chưa cập nhật';

                                    showToast(data.message, 'success'); // Thông báo thành công
                                    modalInstance.hide(); // Đóng modal
                                } else {
                                    showToast(data.message, 'error'); // Thông báo thất bại
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                saveProfileBtn.innerHTML = 'Lưu thay đổi';
                                saveProfileBtn.disabled = false;
                                showToast('Đã xảy ra lỗi khi cập nhật thông tin.', 'error');
                            });
                });

                // Hiệu ứng hover cho từng dòng thông tin cá nhân
                const listItems = document.querySelectorAll('.list-group-item');
                listItems.forEach(item => {
                    item.addEventListener('mouseenter', function () {
                        const icon = this.querySelector('.edit-icon');
                        if (icon) {
                            icon.style.opacity = '1'; // Hiện rõ icon khi di chuột
                        }
                    });

                    item.addEventListener('mouseleave', function () {
                        const icon = this.querySelector('.edit-icon');
                        if (icon) {
                            icon.style.opacity = '0.7'; // Mờ icon khi rời chuột
                        }
                    });
                });
            });
        </script>
    </body>
</html>