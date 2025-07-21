<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết khiếu nại</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
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
            .badge {
                font-size: 0.9rem;
                padding: 0.5rem;
            }
            .complaint-image {
                max-width: 100%;
                height: auto;
                max-height: 400px;
                border-radius: 5px;
                display: block; /* Đảm bảo hiển thị dạng block */
                margin: 10px 0; /* Thêm margin để tách biệt */
                border: 1px solid #ddd; /* Thêm viền để dễ nhìn */
            }
            .complaint-content, .response-content {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .user-info {
                padding: 15px;
                border-left: 3px solid #6c757d;
                background-color: #f8f9fa;
                margin-bottom: 20px;
            }
            /* Đảm bảo nội dung chính hiển thị đúng */
            .main-content {
                margin-left: 250px !important; /* Điều chỉnh theo chiều rộng của sidebar */
                padding: 20px !important;
                transition: margin-left 0.3s !important;
            }
            
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0 !important;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="container-fluid">
                <div class="row">
                    <!-- Main Content -->
                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Chi tiết khiếu nại #${complaint.complaintID}</h1>
                            <div class="btn-toolbar mb-2 mb-md-0">
                                <div class="btn-group me-2">
                                    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-sm btn-outline-secondary">
                                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                    </a>
                                    <c:if test="${complaint.status eq 'Đang xử lý'}">
                                        <a href="${pageContext.request.contextPath}/staff/complaints?action=respond&id=${complaint.complaintID}" class="btn btn-sm btn-primary">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Thông báo lỗi hoặc thành công -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Thông tin khiếu nại -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">${complaint.title}</h5>
                                        <span class="badge ${complaint.status eq 'Đang xử lý' ? 'status-processing' : 
                                                             complaint.status eq 'Đã xử lý' ? 'status-resolved' : 'status-rejected'}">
                                                  ${complaint.status}
                                              </span>
                                        </div>
                                        <div class="card-body">
                                            <!-- Thông tin người gửi khiếu nại -->
                                            <div class="user-info mb-4">
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
                                                    <h6 class="fw-bold mb-0">Người gửi khiếu nại</h6>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Họ tên:</strong> ${userProfile.fullName}</p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p><strong>Số điện thoại:</strong> ${userProfile.phoneNumber}</p>
                                                        <p><strong>Địa chỉ:</strong> ${userProfile.address}</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <h6 class="fw-bold">Nội dung khiếu nại:</h6>
                                                <div class="complaint-content">
                                                    ${complaint.content}
                                                </div>
                                            </div>

                                            <c:if test="${not empty complaint.image}">
                                                <div class="mb-3">
                                                    <h6 class="fw-bold">Hình ảnh đính kèm:</h6>
                                                    <img src="${pageContext.request.contextPath}/${complaint.image}" 
                                                         alt="Hình ảnh khiếu nại" 
                                                         class="complaint-image"
                                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/no-image.png';">
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty complaint.responseContent}">
                                                <div class="mb-3">
                                                    <h6 class="fw-bold">Phản hồi:</h6>
                                                    <div class="response-content">
                                                        ${complaint.responseContent}
                                                    </div>
                                                    <small class="text-muted">
                                                        Phản hồi lúc: <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" />
                                                    </small>
                                                </div>
                                            </c:if>

                                            <div class="d-flex justify-content-between">
                                                <small class="text-muted">Ngày tạo: <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></small>
                                                <c:if test="${not empty complaint.dateResolved}">
                                                    <small class="text-muted">Ngày giải quyết: <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" /></small>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Đã xóa phần form cập nhật trạng thái -->
                                </div>

                                <div class="col-md-4">
                                    <!-- Thông tin liên hệ -->
                                    <div class="card mb-3">
                                        <div class="card-header bg-info text-white">
                                            <h5 class="mb-0"><i class="fas fa-phone-alt me-2"></i>Liên hệ nhanh</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-grid gap-2">
                                                <a href="tel:${userProfile.phoneNumber}" class="btn btn-outline-primary">
                                                    <i class="fas fa-phone-alt me-2"></i>Gọi điện: ${userProfile.phoneNumber}
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Lịch sử khiếu nại -->
                                    <div class="card mt-3">
                                        <div class="card-header">
                                            <h5 class="mb-0">Thông tin bổ sung</h5>
                                        </div>
                                        <div class="card-body">
                                            <p><strong>ID Khiếu nại:</strong> #${complaint.complaintID}</p>
                                            <p><strong>ID Tài khoản:</strong> #${complaint.accountID}</p>
                                            <p><strong>Thời gian tạo:</strong> <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></p>
                                            <c:if test="${not empty complaint.dateResolved}">
                                                <p><strong>Thời gian giải quyết:</strong> <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" /></p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Kiểm tra xem hình ảnh có tồn tại không
                document.addEventListener('DOMContentLoaded', function() {
                    const images = document.querySelectorAll('.complaint-image');
                    images.forEach(img => {
                        console.log("Đang tải hình ảnh:", img.src);
                    });
                });
            </script>
        </body>
    </html>
