<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách khiếu nại</title>
        <!-- Bootstrap CSS -->
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
            .complaint-list {
                max-width: 1000px;
                margin: 0 auto;
                padding: 20px;
            }
            .complaint-item {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                box-shadow: 0 0 5px rgba(0,0,0,0.1);
                transition: transform 0.2s;
            }
            .complaint-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            .status-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }
            .status-pending {
                background-color: #ffeeba;
                color: #856404;
            }
            .status-processing {
                background-color: #b8daff;
                color: #004085;
            }
            .status-resolved {
                background-color: #c3e6cb;
                color: #155724;
            }
            .status-rejected {
                background-color: #f5c6cb;
                color: #721c24;
            }
            .pagination {
                justify-content: center;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>

            <div class="container mt-5 mb-5">
                <div class="complaint-list">
                    <h2 class="text-center mb-4">Danh sách khiếu nại của bạn</h2>

                <c:if test="${empty complaintList}">
                    <div class="alert alert-info" role="alert">
                        Bạn chưa có khiếu nại nào. Nếu bạn gặp vấn đề với đơn hàng, vui lòng gửi khiếu nại từ trang chi tiết đơn hàng.
                    </div>
                    <div class="text-center mt-4">
                        <a href="order?action=list" class="btn btn-primary">Xem đơn hàng của tôi</a>
                    </div>
                </c:if>

                <c:if test="${not empty complaintList}">
                    <div class="row">
                        <c:forEach items="${complaintList}" var="complaint">
                            <div class="col-md-12">
                                <div class="complaint-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5><a href="complaint?action=detail&id=${complaint.id}" class="text-decoration-none">${complaint.title}</a></h5>
                                            <c:choose>
                                                <c:when test="${complaint.status eq 'Đang xử lý'}">
                                                <span class="status-badge status-processing">${complaint.status}</span>
                                            </c:when>
                                            <c:when test="${complaint.status eq 'Chờ xử lý'}">
                                                <span class="status-badge status-pending">${complaint.status}</span>
                                            </c:when>
                                            <c:when test="${complaint.status eq 'Đã giải quyết'}">
                                                <span class="status-badge status-resolved">${complaint.status}</span>
                                            </c:when>
                                            <c:when test="${complaint.status eq 'Từ chối'}">
                                                <span class="status-badge status-rejected">${complaint.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge">${complaint.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="mb-1">Mã đơn hàng: #${complaint.maHD}</p>
                                    <p class="mb-1 text-muted">
                                        <small>Ngày tạo: <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></small>
                                    </p>
                                    <div class="mt-2">
                                        <a href="complaint?action=detail&id=${complaint.id}" class="btn btn-sm btn-outline-primary">Xem chi tiết</a>
                                        <a href="order-detail?id=${complaint.maHD}" class="btn btn-sm btn-outline-secondary">Xem đơn hàng</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Phân trang -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="complaint?action=list&page=${currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="complaint?action=list&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="complaint?action=list&page=${currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:if>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
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
