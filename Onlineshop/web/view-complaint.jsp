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

            .image-container {
                text-align: center;
                margin: 20px 0;
            }

            .complaint-image {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .complaint-image:hover {
                transform: scale(1.02);
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

            @media (max-width: 575.98px) {
                .cpl-detail-wrapper {
                    padding: 20px;
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
                            <p><strong>Mã đơn hàng:</strong> #${complaint.maHD}</p>
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

                <c:if test="${not empty complaint.image}">
                    <h5>Hình ảnh đính kèm:</h5>
                    <div class="image-container">
                        <img src="${complaint.image}" alt="Hình ảnh khiếu nại" class="complaint-image" onclick="showFullImage(this.src)">
                    </div>
                </c:if>

                <c:if test="${not empty complaint.responseContent}">
                    <h5>Phản hồi từ cửa hàng:</h5>
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
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            function showFullImage(src) {
                                document.getElementById('fullImage').src = src;
                                const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                                modal.show();
                            }
        </script>
    </body>
</html>
