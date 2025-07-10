A<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Flower Shop - Blog List</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="${pageContext.request.contextPath}/lib/animate/animate.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

    <style>
        .blog-list-page {
            /* Reset for this page only */
        }
        .blog-list-page html, .blog-list-page body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: linear-gradient(120deg, #fdf6e3 0%, #f5e6ff 100%);
            font-family: 'Roboto', Arial, sans-serif;
        }
        .blog-list-page .container {
            width: 95%;
            max-width: 1280px;
            margin: 24px auto;
            background: rgba(255,255,255,0.98);
            padding: 32px 18px 24px 18px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.10);
        }
        .blog-list-page h2 {
            text-align: center;
            margin-bottom: 8px;
            font-size: 2.1rem;
            color: #7c3aed;
            letter-spacing: 1px;
        }
        .blog-list-page p.sub-heading {
            text-align: center;
            color: #a0aec0;
            margin-bottom: 28px;
            font-size: 1rem;
        }
        .blog-list-page .top-bar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 18px;
        }
        .blog-list-page .search-box {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .blog-list-page .search-box input[type="text"] {
            width: 220px;
            padding: 8px 12px;
            border: 1.5px solid #c7b8f5;
            border-radius: 6px;
            font-size: 15px;
            transition: border 0.2s;
        }
        .blog-list-page .search-box input[type="text"]:focus {
            border: 1.5px solid #7c3aed;
            outline: none;
        }
        .blog-list-page .search-box button {
            padding: 8px 18px;
            background: linear-gradient(90deg, #7c3aed 60%, #f472b6 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(124,58,237,0.08);
            transition: background 0.2s;
        }
        .blog-list-page .search-box button:hover {
            background: linear-gradient(90deg, #5b21b6 60%, #ec4899 100%);
        }
        .blog-list-page .grid-container {
            margin-top: 18px;
        }
        .blog-list-page .row {
            display: flex;
            flex-wrap: wrap;
            gap: 24px 18px;
            justify-content: flex-start;
        }
        .blog-list-page .col-lg-3, .blog-list-page .col-md-4, .blog-list-page .col-sm-6, .blog-list-page .col-12 {
            flex: 1 1 220px;
            max-width: 23%;
            min-width: 220px;
            box-sizing: border-box;
        }
        @media (max-width: 1024px) {
            .blog-list-page .col-lg-3, .blog-list-page .col-md-4, .blog-list-page .col-sm-6 {
                max-width: 48%;
            }
        }
        @media (max-width: 700px) {
            .blog-list-page .row {
                gap: 18px 0;
            }
            .blog-list-page .col-lg-3, .blog-list-page .col-md-4, .blog-list-page .col-sm-6 {
                max-width: 100%;
                min-width: 100%;
            }
        }
        .blog-list-page .card-blog {
            border: none;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 2px 12px rgba(124,58,237,0.07);
            transition: box-shadow 0.22s, transform 0.18s;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .blog-list-page .card-blog:hover {
            box-shadow: 0 8px 32px rgba(124,58,237,0.18);
            transform: translateY(-4px) scale(1.025);
        }
        .blog-list-page .card-blog img {
            width: 100%;
            height: 170px;
            object-fit: cover;
            background: #f3f3f3;
        }
        .blog-list-page .card-body-center {
            padding: 14px 12px 10px 12px;
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
        }
        .blog-list-page .card-body-center h5 {
            font-size: 1.08rem;
            font-weight: 600;
            color: #4b2995;
            margin: 8px 0 6px 0;
            min-height: 40px;
        }
        .blog-list-page .card-body-center p {
            font-size: 0.98rem;
            color: #6b7280;
            margin-bottom: 14px;
            height: 54px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .blog-list-page .btn-detail {
            display: inline-block;
            background: linear-gradient(90deg, #7c3aed 60%, #f472b6 100%);
            color: white;
            padding: 7px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 0.98rem;
            font-weight: 500;
            transition: background 0.18s;
            box-shadow: 0 1px 4px rgba(124,58,237,0.08);
            margin-top: auto;
        }
        .blog-list-page .btn-detail:hover {
            background: linear-gradient(90deg, #5b21b6 60%, #ec4899 100%);
        }
        .blog-list-page .no-blogs {
            text-align: center;
            color: #bdbdbd;
            padding: 48px 0 32px 0;
            font-size: 1.1rem;
        }
        .blog-list-page .pagination {
            margin: 28px 0 10px 0;
            text-align: center;
        }
        .blog-list-page .pagination a, .blog-list-page .pagination span {
            display: inline-block;
            margin: 0 4px;
            padding: 7px 13px;
            color: #7c3aed;
            text-decoration: none;
            border: 1.5px solid #e0d7fa;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            background: #f8f5ff;
            transition: background 0.18s, color 0.18s;
        }
        .blog-list-page .pagination a:hover {
            background: #e9d5ff;
            color: #4b2995;
        }
        .blog-list-page .pagination .current {
            background: linear-gradient(90deg, #7c3aed 60%, #f472b6 100%);
            color: white;
            border-color: #c7b8f5;
        }
        .blog-list-page .info-count {
            margin-top: 10px;
            font-size: 1rem;
            color: #6b7280;
            text-align: right;
        }
        @media (max-width: 700px) {
            .blog-list-page .container {
                padding: 10px 2px 10px 2px;
            }
            .blog-list-page .info-count {
                text-align: center;
                font-size: 0.98rem;
            }
            .blog-list-page .pagination a, .blog-list-page .pagination span {
                padding: 7px 8px;
                font-size: 0.98rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="blog-list-page">
        <div class="container">
            <h2>Danh sách tin tức</h2>
            <p class="sub-heading">Tin tức mới nhất từ Flower Shop</p>

            <div class="top-bar">
                <div class="search-box">
                    <form action="${pageContext.request.contextPath}/blogs" method="get">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm tiêu đề..." />
                        <button type="submit">Tìm</button>
                    </form>
                </div>
            </div>

            <div class="grid-container">
                <div class="row">
                    <c:forEach var="blog" items="${blogs}">
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card-blog h-100">
                                <c:choose>
                                    <c:when test="${not empty blog.mainImage}">
                                        <img src="${pageContext.request.contextPath}/img/blog/${blog.mainImage}" alt="Main Image"
                                             style="background:#eee;" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.png';" />
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
                                    <a href="${pageContext.request.contextPath}/blog-detail?bid=${blog.blogID}" class="btn-detail">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty blogs}">
                        <div class="col-12"><div class="no-blogs">Chưa có bài viết nào.</div></div>
                    </c:if>
                </div>
            </div>

            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/blogs?page=${currentPage - 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">Prev</a>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/blogs?page=${i}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/blogs?page=${currentPage + 1}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}">Next</a>
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
    </div>
    <jsp:include page="footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>