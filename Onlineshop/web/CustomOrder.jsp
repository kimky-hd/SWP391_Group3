<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt hàng tùy chỉnh</title>
        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Playfair+Display:wght@400;500&display=swap" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">

        <!-- Custom Pastel Pink Flower Shop Styles -->
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container-fluid py-5">
            <div class="custom-order-container">
                <div class="card border-0 shadow-lg">
                    <div class="card-header text-center">
                        <h2>Đặt hàng tùy chỉnh</h2>
                        <p class="mb-0">Hãy cho chúng tôi biết ý tưởng của bạn</p>
                    </div>
                    <div class="card-body">
                        <!-- Decorative elements -->
                        <div class="flower-decoration flower-1"></div>
                        <div class="flower-decoration flower-2"></div>

                        <form action="submit-customize-request" method="post" enctype="multipart/form-data">
                            <!-- Thông tin yêu cầu -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-clipboard-list"></i>
                                    <h5>Chi tiết yêu cầu</h5>
                                </div>

                                <div class="form-group">
                                    <label for="imageUpload" class="form-label">Hình ảnh mẫu</label>
                                    <input type="file" class="form-control" id="imageUpload" name="imageUpload" accept="image/*">
                                    <small class="text-muted"><i class="fas fa-info-circle"></i> Tải lên hình ảnh mẫu để chúng tôi hiểu rõ hơn về yêu cầu của bạn</small>
                                </div>

                                <div class="form-group">
                                    <label for="description" class="form-label">Mô tả chi tiết</label>
                                    <textarea class="form-control" id="description" name="description" rows="5"placeholder="Mô tả chi tiết về sản phẩm bạn muốn đặt hàng (loại hoa, màu sắc, kích thước, dịp sử dụng, ngân sách dự kiến...)"></textarea>
                                    <small class="text-muted"><i class="fas fa-lightbulb"></i> Càng chi tiết càng giúp chúng tôi hiểu rõ nhu cầu của bạn</small>
                                </div>

                                <div class="form-group">
                                    <label for="quantity" class="form-label">Số lượng</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" value="1">
                                    <div class="form-group mt-2">
                                        <img id="previewImage" src="#" alt="Ảnh demo" style="max-width: 100%; display: none; border: 1px dashed #ccc; padding: 10px; margin-top: 10px;" />
                                    </div>
                                    <small class="text-muted"><i class="fas fa-box"></i> Nhập số lượng sản phẩm bạn muốn đặt</small>
                                </div>
                            </div>

                            <!-- Nút gửi -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane mr-2"></i> Gửi yêu cầu
                                </button>
                            </div>

                            <div class="footer-note">
                                <small><i class="fas fa-clock"></i> Chúng tôi sẽ liên hệ với bạn trong vòng 24 giờ sau khi nhận được yêu cầu</small>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

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

        <!-- Sticky Button for Custom Order -->
        <div class="flower-fixed-btn">
            <a href="CustomOrder.jsp" title="Đặt hoa theo yêu cầu">
                <i class="fas fa-seedling"></i> <!-- Bạn có thể thay bằng: fa-pencil-alt, fa-heart, fa-rose -->
            </a>
        </div>
        <!-- Sticky Button for Custom Order End -->

        <!-- Toast Container -->
        <div class="toast-container"></div>
        <style>
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .toast {
                padding: 15px 25px;
                margin-bottom: 12px;
                border-radius: 12px;
                color: #5f375f;
                background-color: #fce4ec;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.4s ease-in-out;
                border-left: 6px solid #f48fb1;
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.success {
                background-color: #f8bbd0;
                border-left-color: #40ec46;
            }

            .toast.error {
                background-color: #fce4ec;
                border-left-color: #d81b60;
            }
        </style>
        <script>
            function showToast(message, type) {
                const container = document.querySelector('.toast-container');
                const toast = document.createElement('div');
                toast.className = `toast ${type}`;
                toast.textContent = message;

                container.appendChild(toast);

                // Reflow để kích hoạt animation
                toast.offsetHeight;

                // Show toast
                toast.classList.add('show');

                // Tự động biến mất sau 3s
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => {
                        container.removeChild(toast);
                    }, 400);
                }, 3000);
            }

            // Lấy message từ session JSP
            const message = '<%= session.getAttribute("message") != null ? session.getAttribute("message") : "" %>';
            const messageType = '<%= session.getAttribute("messageType") != null ? session.getAttribute("messageType") : "" %>';

            if (message && messageType) {
                showToast(message, messageType);
            <% session.removeAttribute("message"); %>
            <% session.removeAttribute("messageType"); %>
            }
        </script>
        <script>
            document.getElementById("imageUpload").addEventListener("change", function (event) {
                const file = event.target.files[0];
                const preview = document.getElementById("previewImage");

                if (file) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = "block";
                    };

                    reader.readAsDataURL(file);
                } else {
                    preview.src = "#";
                    preview.style.display = "none";
                }
            });
        </script>

    </body>
</html>