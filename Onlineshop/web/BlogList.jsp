<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Flower Shop - Product List</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

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
        html, body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: url('https://img.lovepik.com/photo/50091/3710.jpg_wh860.jpg') no-repeat top left,
                        url('https://images.pexels.com/photos/931162/pexels-photo-931162.jpeg') no-repeat top right,
                        #fdfdfd;
            background-size: auto 100vh, auto 100vh;
            background-attachment: fixed;
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

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            gap: 10px;
        }

        .btn-add {
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }

        .btn-add:hover {
            background-color: #218838;
        }

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
            -webkit-line-clamp: 3;
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

        .action-btn {
            display: inline-block;
            margin-left: 5px;
            background-color: #ffc107;
            color: black;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 14px;
            text-decoration: none;
        }

        .action-btn.delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .no-blogs {
            text-align: center;
            color: #777;
            padding: 40px 0;
            font-size: 16px;
        }

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
    <jsp:include page="header.jsp" />
    <div class="container">
        <h2>Danh sách tin tức</h2>
        <p class="sub-heading">Quản lý danh sách tin tức thuộc campus</p>

        <div class="top-bar">
            <div>
                <c:if test="${not empty sessionScope.account and (sessionScope.account.role == 1 or sessionScope.account.role == 3)}">
                    <a href="${pageContext.request.contextPath}/blogs?action=add" class="btn-add">+ Thêm Blog</a>
                </c:if>
            </div>
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/blogs" method="get">
                    <input type="hidden" name="action" value="search"/>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm kiếm tiêu đề..." />
                    <button type="submit">Tìm</button>
                </form>
            </div>
        </div>

        <div class="grid-container">
            <div class="row">
                <c:forEach var="blog" items="${blogList}">
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card-blog h-100">
                            <c:choose>
                                <c:when test="${not empty blog.image}">
                                    <img src="${pageContext.request.contextPath}/img/${blog.image}" alt="Ảnh bài viết" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/default.png" alt="No Image" />
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body-center">
                                <h5>${blog.title}</h5>
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
                                <a href="${pageContext.request.contextPath}/blogs?action=detail&bid=${blog.blogID}" class="btn-detail">Xem chi tiết</a>
                                <c:if test="${not empty sessionScope.account and (sessionScope.account.role == 1 or sessionScope.account.role == 3)}">
                                    <a href="${pageContext.request.contextPath}/blogs?action=edit&bid=${blog.blogID}" class="action-btn">Sửa</a>
                                    <a href="${pageContext.request.contextPath}/blogs?action=delete&bid=${blog.blogID}" class="action-btn delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?');">Xóa</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty blogList}">
                    <div class="col-12"><div class="no-blogs">Chưa có bài viết nào.</div></div>
                </c:if>
            </div>
        </div>

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

    <jsp:include page="footer.jsp" />
       <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
