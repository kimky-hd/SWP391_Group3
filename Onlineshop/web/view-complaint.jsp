<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết khiếu nại</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

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
            :root {
                --primary-pink: #FFB6C1;
                --dark-pink: #FF69B4;
                --light-bg: #f8f9fa;
                --white: #ffffff;
            }

            body {
                background-color: #fff;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .cpl-detail-wrapper {
                max-width: 800px;
                margin: 30px auto;
                padding: 30px;
                background-color: var(--light-bg);
                border-radius: 12px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }

            h2, h5 {
                color: #333;
                font-weight: 600;
            }

            .cpl-header-section p {
                margin-bottom: 5px;
                font-size: 0.95rem;
                color: #555;
            }

            .cpl-status-badge {
                display: inline-block;
                padding: 6px 15px;
                border-radius: 30px;
                font-size: 0.9rem;
                font-weight: 600;
            }

            .cpl-status-waiting {
                background-color: #ffeeba;
                color: #856404;
            }

            .cpl-status-inprogress {
                background-color: #b8daff;
                color: #004085;
            }

            .cpl-status-completed {
                background-color: #d4edda;
                color: #155724;
            }

            .cpl-status-declined {
                background-color: #f8d7da;
                color: #721c24;
            }

            .cpl-content-box {
                background-color: var(--white);
                padding: 20px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                font-size: 1rem;
                color: #444;
            }

            /* Styles cho gallery ảnh */
            .images-gallery {
                margin: 20px 0;
            }

            .images-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }

            .image-item {
                position: relative;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .image-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }

            .complaint-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .complaint-image:hover {
                transform: scale(1.05);
            }

            .image-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(transparent, rgba(0,0,0,0.7));
                color: white;
                padding: 10px;
                font-size: 0.8rem;
                text-align: center;
            }

            .single-image-container {
                text-align: center;
                margin: 20px 0;
            }

            .single-image {
                max-width: 100%;
                height: auto;
                max-height: 400px;
                border-radius: 8px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .single-image:hover {
                transform: scale(1.02);
            }

            .images-count {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 10px;
            }

            .cpl-response-container {
                background-color: #f1f3f5;
                padding: 20px;
                border-radius: 8px;
                font-size: 0.95rem;
                color: #333;
                margin-top: 25px;
                border-left: 4px solid var(--primary-pink);
            }

            .btn-outline-primary {
                border-radius: 25px;
                padding: 8px 25px;
                font-weight: 500;
            }

            .alert {
                font-size: 0.95rem;
                border-radius: 8px;
            }

            /* Modal styles */
            .modal-lg {
                max-width: 90%;
            }

            .modal-body img {
                max-width: 100%;
                height: auto;
                max-height: 80vh;
                object-fit: contain;
            }

            @media (max-width: 575.98px) {
                .cpl-detail-wrapper {
                    padding: 20px;
                }
                
                .images-grid {
                    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                    gap: 10px;
                }
                
                .complaint-image {
                    height: 150px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container">
            <div class="cpl-detail-wrapper">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success" role="alert">${successMessage}</div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-info" role="alert">${message}</div>
                </c:if>

                <div class="cpl-header-section mb-4">
                    <h2>${complaint.title}</h2>
                    <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap">
                        <div>
                            <p><strong>Mã đơn hàng :</strong> #${complaint.maHD}</p>
                            <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></p>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${complaint.status eq 'Đang xử lý'}">
                                    <span class="cpl-status-badge cpl-status-inprogress">${complaint.status}</span>
                                </c:when>
                                <c:when test="${complaint.status eq 'Chờ xử lý'}">
                                    <span class="cpl-status-badge cpl-status-waiting">${complaint.status}</span>
                                </c:when>
                                <c:when test="${complaint.status eq 'Đã giải quyết'}">
                                    <span class="cpl-status-badge cpl-status-completed">${complaint.status}</span>
                                </c:when>
                                <c:when test="${complaint.status eq 'Từ chối'}">
                                    <span class="cpl-status-badge cpl-status-declined">${complaint.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="cpl-status-badge">${complaint.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <h5 class="mt-4">Nội dung khiếu nại:</h5>
                <div class="cpl-content-box">
                    ${complaint.content}
                </div>

                <!-- Hiển thị ảnh đính kèm -->
                <c:choose>
                    <c:when test="${not empty complaint.images and complaint.images.size() > 0}">
                        <h5 class="mt-4">Hình ảnh đính kèm:</h5>
                        <div class="images-gallery">
                            <div class="images-count">
                                <i class="fas fa-images"></i> ${complaint.images.size()} ảnh
                            </div>
                            
                            <c:choose>
                                <c:when test="${complaint.images.size() == 1}">
                                    <!-- Hiển thị 1 ảnh duy nhất -->
                                    <div class="single-image-container">
                                        <img src="${complaint.images[0].imagePath}" 
                                             alt="Hình ảnh khiếu nại" 
                                             class="single-image" 
                                             onclick="showFullImage('${complaint.images[0].imagePath}', 1, 1)">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Hiển thị nhiều ảnh dạng grid -->
                                    <div class="images-grid">
                                        <c:forEach var="image" items="${complaint.images}" varStatus="status">
                                            <div class="image-item">
                                                <img src="${image.imagePath}" 
                                                     alt="Hình ảnh khiếu nại ${status.index + 1}" 
                                                     class="complaint-image" 
                                                     onclick="showFullImage('${image.imagePath}', ${status.index + 1}, ${complaint.images.size()})">
                                                <div class="image-overlay">
                                                    Ảnh ${status.index + 1}/${complaint.images.size()}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:when test="${not empty complaint.image}">
                        <!-- Fallback cho trường hợp chỉ có ảnh chính -->
                        <h5 class="mt-4">Hình ảnh đính kèm:</h5>
                        <div class="single-image-container">
                            <img src="${complaint.image}" 
                                 alt="Hình ảnh khiếu nại" 
                                 class="single-image" 
                                 onclick="showFullImage('${complaint.image}', 1, 1)">
                        </div>
                    </c:when>
                </c:choose>

                <c:if test="${not empty complaint.responseContent}">
                    <h5 class="mt-4">Phản hồi từ cửa hàng:</h5>
                    <div class="cpl-response-container">
                        <p>${complaint.responseContent}</p>
                        <c:if test="${not empty complaint.dateResolved}">
                            <p class="text-muted mb-0"><small>Phản hồi lúc: <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" /></small></p>
                        </c:if>
                    </div>
                </c:if>

                <div class="cpl-actions mt-4 text-center">
                    <a href="order?action=view" class="btn btn-outline-primary">Quay lại</a>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <!-- Modal xem hình ảnh -->
        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Hình ảnh khiếu nại</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img id="fullImage" src="" alt="Hình ảnh đầy đủ" style="max-width: 100%;">
                        <div id="imageInfo" class="mt-2 text-muted"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function showFullImage(src, currentIndex, totalImages) {
                document.getElementById('fullImage').src = src;
                document.getElementById('imageInfo').textContent = `Ảnh ${currentIndex} / ${totalImages}`;
                const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                modal.show();
            }
        </script>
        <script>
            $(document).ready(function () {
                // Xử lý sự kiện khi nhấn vào nút đăng xuất
                $('.dropdown-item[data-toggle="modal"]').on('click', function (e) {
                    e.preventDefault();
                    $('#logoutModal').modal('show');
                });
            });
        </script>

        <script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Contact Javascript File -->
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>

    </body>
</html>
