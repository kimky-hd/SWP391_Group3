<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách tin tức</title>
        <!-- ====================== Bootstrap CSS ====================== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bootstrap/css/bootstrap.min.css" />

        <!-- Font Awesome (nếu header/footer dùng icon fa-*) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/fontawesome/css/all.min.css" />

        <!-- Custom CSS (ví dụ: css/style.css) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .container {
                width: 90%;
                max-width: 1200px;
                margin: 20px auto;
                background-color: #fff;
                padding: 20px 30px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                margin-bottom: 10px;
            }
            p.sub-heading {
                text-align: center;
                color: #777;
                margin-bottom: 20px;
                font-size: 14px;
            }
            /* Top-bar chứa nút Thêm và form tìm kiếm */
            .top-bar {
                display: flex;
                justify-content: space-between; /* Đẩy 2 phần ra hai đầu */
                align-items: center;
                margin-bottom: 15px;
                gap: 10px;  /* Khoảng cách giữa các thành phần */
            }
            /* Style cho NÚT Thêm Blog */
            .btn-add {
                display: inline-block;
                background-color: #28a745;       /* xanh lá */
                color: white;
                padding: 6px 12px;               /* padding dày vừa đủ */
                border-radius: 4px;              /* bo góc */
                text-decoration: none;
                font-size: 14px;
                font-weight: bold;
                transition: background-color 0.2s ease;
            }
            .btn-add:hover {
                background-color: #218838;       /* tối hơn khi hover */
            }
            /* Wrapper cho form tìm kiếm */
            .search-box {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .search-box input[type="text"] {
                width: 250px;
                padding: 6px 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
            }
            .search-box button {
                padding: 6px 12px;
                background-color: #ff6600;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }
            .search-box button:hover {
                background-color: #e65c00;
            }

            /* ==== Thêm style cho grid/card ==== */
            .grid-container {
                margin-top: 20px;
            }
            .card-blog {
                border: 1px solid #ddd;
                border-radius: 6px;
                overflow: hidden;
                transition: box-shadow 0.2s ease;
                height: 100%;
            }
            .card-blog:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            .card-blog img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }
            .card-body-center {
                padding: 10px;
            }
            .card-body-center h5 {
                font-size: 16px;
                font-weight: bold;
                color: #333;
                margin: 10px 0;
            }
            .card-body-center p {
                font-size: 14px;
                color: #777;
                margin-bottom: 15px;
                height: 60px;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 3; /* Show only 3 lines */
                -webkit-box-orient: vertical;
            }
            .btn-detail {
                display: inline-block;
                background-color: #3498db;
                color: white;
                padding: 6px 12px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 14px;
                transition: background-color 0.2s ease;
            }
            .btn-detail:hover {
                background-color: #2980b9;
            }
            .no-blogs {
                text-align: center;
                color: #777;
                padding: 40px 0;
                font-size: 16px;
            }
            /* ==== Giữ nguyên style pagination và info-count ==== */
            .pagination {
                margin: 20px 0;
                text-align: center;
            }
            .pagination a, .pagination span {
                display: inline-block;
                margin: 0 4px;
                padding: 6px 10px;
                color: #333;
                text-decoration: none;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .pagination a:hover {
                background-color: #eee;
            }
            .pagination .current {
                background-color: #ff6600;
                color: white;
                border-color: #ff6600;
            }
            .info-count {
                margin-top: 8px;
                font-size: 14px;
                color: #555;
                text-align: right;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Danh sách tin tức</h2>

            <!-- INCLUDE HEADER TẠI ĐÂY -->
            <jsp:include page="/header.jsp" />
            <p class="sub-heading">Quản lý danh sách tin tức thuộc campus</p>

            <!-- Top-bar: bên trái là NÚT Thêm, bên phải là Form tìm kiếm -->
            <div class="top-bar">
                <!-- Nút Thêm Blog mới (Chỉ admin mới thấy) -->
                <div>
                    <c:if test="${not empty sessionScope.account 
                                  and (sessionScope.account.role == 1 or sessionScope.account.role == 2)}">
                          <a href="${pageContext.request.contextPath}/blogs?action=add" class="btn-add">
                              + Thêm Blog
                          </a>
                    </c:if>
                </div>

                <!-- Form tìm kiếm -->
                <div class="search-box">
                    <form action="${pageContext.request.contextPath}/blogs" method="get">
                        <input type="hidden" name="action" value="search"/>
                        <input 
                            type="text" 
                            name="keyword"
                            value="${keyword}" 
                            placeholder="Tìm kiếm tiêu đề..." />
                        <button type="submit">Tìm</button>
                    </form>
                </div>
            </div>

            <!-- ==== Phần hiển thị danh sách blogs chuyển thành grid ==== -->
            <div class="grid-container">
                <div class="row">
                    <!-- Duyệt blogList -->
                    <c:forEach var="blog" items="${blogList}">
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card-blog h-100">
                                <!-- Ảnh bài viết (nếu có) -->
                                <c:choose>
                                    <c:when test="${not empty blog.image}">
                                        <img src="${pageContext.request.contextPath}/img/${blog.image}"
                                             alt="Ảnh bài viết" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/default.png"
                                             alt="No Image" />
                                    </c:otherwise>
                                </c:choose>
                                <!-- Tiêu đề và Mô tả nằm bên dưới ảnh -->
                                <div class="card-body-center">
                                    <!-- Tiêu đề -->
                                    <h5>${blog.title}</h5>
                                    <!-- Mô tả (dài hơn 100 ký tự thì cắt) -->
                                    <p>
                                        <c:choose>
                                            <c:when test="${fn:length(blog.content) > 100}">
                                                ${fn:substring(blog.content, 0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${blog.content}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <!-- Nút Xem chi tiết nằm bên dưới -->
                                    <a href="${pageContext.request.contextPath}/blogs?action=detail&bid=${blog.blogID}" 
                                       class="btn-detail">
                                        Xem chi tiết
                                    </a>
                                    <!-- Nút Sửa, Xóa: chỉ role = 1 hoặc 2 mới thấy -->
                                    <c:if test="${not empty sessionScope.account 
                                                  and (sessionScope.account.role == 1 or sessionScope.account.role == 2)}">
                                          <a href="${pageContext.request.contextPath}/blogs?action=edit&bid=${blog.blogID}"
                                             class="action-btn">Sửa</a>
                                          <a href="${pageContext.request.contextPath}/blogs?action=delete&bid=${blog.blogID}"
                                             class="action-btn delete-btn"
                                             onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?');">
                                              Xóa
                                          </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Nếu không có blog nào -->
                    <c:if test="${empty blogList}">
                        <div class="col-12">
                            <div class="no-blogs">Chưa có bài viết nào.</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Phân trang (giữ nguyên) -->
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/blogs?action=list&page=${currentPage - 1}">Prev</a>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/blogs?action=list&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/blogs?action=list&page=${currentPage + 1}">Next</a>
                    </c:if>
                </c:if>
            </div>

            <!-- Thông tin số lượng đang hiển thị (giữ nguyên) -->
            <div class="info-count">
                <c:if test="${totalCount > 0}">
                    Hiển thị 
                    <c:out value="${(currentPage - 1) * 10 + 1}"/> - 
                    <c:choose>
                        <c:when test="${(currentPage * 10) < totalCount}">
                            <c:out value="${currentPage * 10}"/>
                        </c:when>
                        <c:otherwise>
                            <c:out value="${totalCount}"/>
                        </c:otherwise>
                    </c:choose>
                    trên tổng số 
                    <c:out value="${totalCount}"/> bài viết
                </c:if>
            </div>
        </div>
        <!-- INCLUDE FOOTER TẠI ĐÂY -->
        <jsp:include page="/footer.jsp" />
    </body>
</html>
