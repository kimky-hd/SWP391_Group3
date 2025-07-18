<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khiếu nại</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .cpl-detail-wrapper {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
       
        .cpl-content-box {
            background-color: #fff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }
        .cpl-status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
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
            background-color: #c3e6cb;
            color: #155724;
        }
        .cpl-status-declined {
            background-color: #f5c6cb;
            color: #721c24;
        }
        .cpl-response-container {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .complaint-image {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            margin-top: 15px;
            margin-bottom: 15px;
            box-shadow: 0 0 5px rgba(0,0,0,0.2);
            cursor: pointer;
        }
        .image-container {
            text-align: center;
            margin: 15px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-5 mb-5">
        <div class="cpl-detail-wrapper">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-info" role="alert">
                    ${message}
                </div>
            </c:if>
            
            <div class="cpl-header-section">
                <h2>${complaint.title}</h2>
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div>
                        <p class="mb-0"><strong>Mã đơn hàng:</strong> #${complaint.maHD}</p>
                        <p class="mb-0"><strong>Ngày tạo:</strong> <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></p>
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
            
            <!-- Hiển thị hình ảnh khiếu nại nếu có -->
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
            
            <div class="cpl-actions mt-4">
                <a href="order?action=view" class="btn btn-outline-primary">Quay lại</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
    
    <!-- Modal xem hình ảnh đầy đủ -->
    <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="imageModalLabel">Hình ảnh khiếu nại</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
            var myModal = new bootstrap.Modal(document.getElementById('imageModal'));
            myModal.show();
        }
    </script>
</body>
</html>
