<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Banner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .main-content { background-color: #f8f9fa; min-height: 100vh; padding: 30px; margin-left: 260px; margin-top: 70px; }
        .header-card, .banner-table { background: white; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 30px; margin-bottom: 20px; }
        .table th { background: #4f63d2; color: white; border: none; font-weight: 600; text-align: center; }
        .table td { text-align: center; vertical-align: middle; }
        .action-buttons { display: flex; justify-content: center; gap: 8px; }
        .btn-action { padding: 8px 12px; border-radius: 8px; font-size: 12px; min-width: 36px; height: 36px; }
        .banner-img-thumb { max-width: 120px; max-height: 60px; object-fit: cover; border-radius: 8px; }
        .status-badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 500; min-width: 70px; display: inline-block; }
        .status-active { background: #d4edda; color: #155724; }
        .status-inactive { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<jsp:include page="../manager_topbarsidebar.jsp" />
<div class="main-content">
    <div class="header-card d-flex justify-content-between align-items-center">
        <div>
            <h4 class="mb-1"><i class="fas fa-images me-2"></i>Quản Lý Banner</h4>
            <p class="text-muted mb-0">Quản lý slider/banner trang chủ</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBannerModal">
            <i class="fas fa-plus me-2"></i>Thêm Banner mới
        </button>
    </div>
    <!-- Bảng danh sách banner -->
    <div class="banner-table">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tiêu đề</th>
                    <th>Mô tả</th>
                    <th>Link</th>
                    <th>Thứ tự</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${banners}">
                    <tr>
                        <td>${b.bannerID}</td>
                        <td><img src="${pageContext.request.contextPath}/img/${b.image}" class="banner-img-thumb"></td>
                        <td>${b.title}</td>
                        <td>${b.description}</td>
                        <td>${b.link}</td>
                        <td>${b.displayOrder}</td>
                        <td>
                            <span class="status-badge ${b.active ? 'status-active' : 'status-inactive'}">
                                ${b.active ? 'Hiện' : 'Ẩn'}
                            </span>
                        </td>
                        <td class="action-buttons">
                            <a href="banner?action=edit&id=${b.bannerID}" class="btn btn-action btn-edit" title="Sửa"><i class="fas fa-edit"></i></a>
                            <a href="banner?action=delete&id=${b.bannerID}" class="btn btn-action btn-danger" title="Xóa" onclick="return confirm('Xóa banner này?')"><i class="fas fa-trash"></i></a>
                            <c:choose>
                                <c:when test="${b.active}">
                                    <a href="banner?action=deactivate&id=${b.bannerID}" class="btn btn-action btn-warning" title="Ẩn"><i class="fas fa-eye-slash"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="banner?action=activate&id=${b.bannerID}" class="btn btn-action btn-success" title="Hiện"><i class="fas fa-eye"></i></a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item"><a class="page-link" href="banner?action=list&page=${currentPage - 1}">Trước</a></li>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="banner?action=list&page=${i}">${i}</a></li>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item"><a class="page-link" href="banner?action=list&page=${currentPage + 1}">Sau</a></li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>
    <!-- Modal Thêm Banner -->
    <div class="modal fade" id="addBannerModal" tabindex="-1" aria-labelledby="addBannerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="banner" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addBannerModalLabel"><i class="fas fa-plus me-2"></i>Thêm Banner mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh</label>
                            <input type="file" class="form-control" name="image" accept="image/*" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="2"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Link</label>
                            <input type="text" class="form-control" name="link">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Thứ tự hiển thị</label>
                            <input type="number" class="form-control" name="displayOrder" value="1" min="1">
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="isActive" id="isActiveAdd" checked>
                            <label class="form-check-label" for="isActiveAdd">Hiển thị banner</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- Modal Sửa Banner (nếu có) -->
    <c:if test="${not empty editBanner}">
        <div class="modal fade show" id="editBannerModal" tabindex="-1" aria-labelledby="editBannerModalLabel" aria-modal="true" style="display:block; background:rgba(0,0,0,0.5);">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="banner" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="${editBanner.bannerID}">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="editBannerModalLabel"><i class="fas fa-edit me-2"></i>Sửa Banner</h5>
                            <a href="banner" class="btn-close btn-close-white"></a>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tiêu đề</label>
                                <input type="text" class="form-control" name="title" value="${editBanner.title}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Ảnh hiện tại</label><br>
                                <img src="${pageContext.request.contextPath}/img/${editBanner.image}" class="banner-img-thumb mb-2">
                                <input type="file" class="form-control" name="image" accept="image/*">
                                <small class="text-muted">Chỉ chọn ảnh mới nếu muốn thay đổi</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" rows="2">${editBanner.description}</textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Link</label>
                                <input type="text" class="form-control" name="link" value="${editBanner.link}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thứ tự hiển thị</label>
                                <input type="number" class="form-control" name="displayOrder" value="${editBanner.displayOrder}" min="1">
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="isActive" id="isActiveEdit" ${editBanner.active ? 'checked' : ''}>
                                <label class="form-check-label" for="isActiveEdit">Hiển thị banner</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <a href="banner" class="btn btn-secondary">Đóng</a>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>document.body.classList.add('modal-open');</script>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 