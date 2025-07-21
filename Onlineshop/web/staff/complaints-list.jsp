<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khiếu nại</title>
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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../manager_topbarsidebar.jsp" />
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Quản lý khiếu nại</h1>
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
                
                <!-- Tìm kiếm và lọc -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/staff/complaints" method="get" class="d-flex">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm kiếm khiếu nại..." value="${keyword}">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                        </form>
                    </div>
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/staff/complaints" method="get" class="d-flex justify-content-end">
                            <select name="status" class="form-select me-2" style="max-width: 200px;" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Đang xử lý" ${selectedStatus eq 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="Đã xử lý" ${selectedStatus eq 'Đã xử lý' ? 'selected' : ''}>Đã xử lý</option>
                                <option value="Từ chối" ${selectedStatus eq 'Từ chối' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </form>
                    </div>
                </div>
                
                <!-- Bảng danh sách khiếu nại -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Mã đơn hàng</th>
                                <th>Tiêu đề</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                                <th>Ngày phản hồi</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="complaint" items="${complaints}">
                                <tr>
                                    <td>${complaint.complaintID}</td>
                                    <td>${complaint.maHD}</td>
                                    <td>${complaint.title}</td>
                                    <td><fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>
                                        <span class="badge ${complaint.status eq 'Đang xử lý' ? 'status-processing' : 
                                                              complaint.status eq 'Đã xử lý' ? 'status-resolved' : 'status-rejected'}">
                                            ${complaint.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty complaint.dateResolved}">
                                            <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:if>
                                        <c:if test="${empty complaint.dateResolved}">
                                            <span class="text-muted">Chưa phản hồi</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/staff/complaints?action=view&id=${complaint.complaintID}" 
                                           class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                        <c:if test="${complaint.status eq 'Đang xử lý'}">
                                            <a href="${pageContext.request.contextPath}/staff/complaints?action=respond&id=${complaint.complaintID}" 
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-reply"></i> Phản hồi
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty complaints}">
                                <tr>
                                    <td colspan="7" class="text-center">Không có khiếu nại nào</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <!-- Phân trang -->
                <c:if test="${totalPages > 0}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/staff/complaints?page=${currentPage - 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&action=search&keyword='.concat(keyword) : ''}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/staff/complaints?page=${i}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&action=search&keyword='.concat(keyword) : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/staff/complaints?page=${currentPage + 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&action=search&keyword='.concat(keyword) : ''}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
