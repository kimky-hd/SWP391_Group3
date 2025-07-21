<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản hồi khiếu nại</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .status-processing { background-color: #b8daff; color: #004085; }
        .status-resolved { background-color: #c3e6cb; color: #155724; }
        .status-rejected { background-color: #f5c6cb; color: #721c24; }
        .badge { font-size: 0.9rem; padding: 0.5rem; }
        .complaint-image { max-width: 100%; height: auto; max-height: 300px; border-radius: 5px; }
        .complaint-content { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .user-info { padding: 15px; border-left: 3px solid #6c757d; background-color: #f8f9fa; margin-bottom: 20px; }
        .main-content { margin-left: 250px; padding: 20px; } /* Đảm bảo không bị sidebar che */
    </style>
</head>
<body>

<jsp:include page="../manager_topbarsidebar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Phản hồi khiếu nại #${complaint.complaintID}</h1>
            <div class="btn-toolbar">
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/complaints?action=view&id=${complaint.complaintID}" class="btn btn-sm btn-info">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <!-- Thông báo -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- PHẦN TRÁI -->
            <div class="col-lg-8">
                <!-- Thông tin khiếu nại -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">${complaint.title}</h5>
                        <span class="badge ${complaint.status eq 'Đang xử lý' ? 'status-processing' : 
                                             complaint.status eq 'Đã xử lý' ? 'status-resolved' : 'status-rejected'}">
                            ${complaint.status}
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="user-info mb-4">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
                                <h6 class="fw-bold mb-0">Người gửi khiếu nại</h6>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Họ tên:</strong> ${userProfile.fullName}</p>
                                    <p><strong>Email:</strong> ${userProfile.email}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>SĐT:</strong> ${userProfile.phoneNumber}</p>
                                    <p><strong>Địa chỉ:</strong> ${userProfile.address}</p>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <h6 class="fw-bold">Nội dung khiếu nại:</h6>
                            <div class="complaint-content">${complaint.content}</div>
                        </div>

                        <c:if test="${not empty complaint.image}">
                            <div class="mb-3">
                                <h6 class="fw-bold">Hình ảnh đính kèm:</h6>
                                <img src="${pageContext.request.contextPath}/${complaint.image}" class="complaint-image" alt="Hình ảnh khiếu nại">
                            </div>
                        </c:if>

                        <small class="text-muted">Ngày tạo: <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></small>
                    </div>
                </div>

                <!-- Form phản hồi -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Phản hồi khiếu nại</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/staff/complaints" method="post">
                            <input type="hidden" name="action" value="respond">
                            <input type="hidden" name="id" value="${complaint.complaintID}">

                            <div class="mb-3">
                                <label for="responseContent" class="form-label">Nội dung phản hồi</label>
                                <textarea name="responseContent" id="responseContent" rows="6" class="form-control" required>${complaint.responseContent}</textarea>
                            </div>

                            <div class="mb-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select name="status" id="status" class="form-select">
                                    <option value="Đang xử lý" ${complaint.status eq 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                    <option value="Đã xử lý" ${complaint.status eq 'Đã xử lý' ? 'selected' : ''}>Đã xử lý</option>
                                    <option value="Từ chối" ${complaint.status eq 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                                </select>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/staff/complaints?action=view&id=${complaint.complaintID}" class="btn btn-secondary me-md-2">Hủy</a>
                                <button type="submit" class="btn btn-primary">Gửi phản hồi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- PHẦN PHẢI -->
            <div class="col-lg-4">
                <!-- Liên hệ -->
                <div class="card mb-3">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-phone-alt me-2"></i>Liên hệ nhanh</h5>
                    </div>
                    <div class="card-body">
                        <a href="tel:${userProfile.phoneNumber}" class="btn btn-outline-primary mb-2">
                            <i class="fas fa-phone-alt me-2"></i>Gọi: ${userProfile.phoneNumber}
                        </a>
                        <a href="mailto:${userProfile.email}" class="btn btn-outline-secondary">
                            <i class="fas fa-envelope me-2"></i>Email: ${userProfile.email}
                        </a>
                    </div>
                </div>

            
            </div>
        </div> <!-- End row -->
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function insertTemplate(text) {
        document.getElementById('responseContent').value = text;
    }
</script>

</body>
</html>
