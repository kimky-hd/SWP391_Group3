<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết bài viết</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px 30px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h2.page-heading {
            text-align: center;
            font-size: 26px;
            margin-bottom: 10px;
            color: #333;
        }
        p.sub-heading {
            text-align: center;
            color: #777;
            margin-bottom: 25px;
            font-size: 14px;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #333;
            background-color: #ececec;
            padding: 8px 14px;
            border-radius: 4px;
            border: 1px solid #ddd;
            font-size: 14px;
        }
        .back-btn:hover {
            background-color: #e2e2e2;
        }
        .blog-title {
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
            border-bottom: 2px solid #eee;
            padding-bottom: 8px;
        }
        .blog-meta {
            color: #777;
            font-size: 13px;
            margin-bottom: 20px;
        }
        /* CSS mới: hiển thị full ảnh, giữ nguyên tỉ lệ */
        .blog-image-detail {
            width: 100%;      /* chạy hết chiều ngang container */
            height: auto;     /* chiều cao tự điều chỉnh theo tỉ lệ gốc */
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #ddd;
        }
        .blog-content {
            font-size: 15px;
            line-height: 1.7;
            color: #444;
            margin-bottom: 30px;
        }
        .no-data {
            text-align: center;
            color: #d9534f;
            font-size: 16px;
            margin-top: 50px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="page-heading">Chi tiết bài viết</h2>
    <p class="sub-heading">Xem nội dung đầy đủ của bài viết</p>

    <a class="back-btn" href="${pageContext.request.contextPath}/blogs?action=list">
        &laquo; Quay về danh sách
    </a>

    <c:if test="${not empty blog}">
        <h3 class="blog-title">${blog.title}</h3>

        <p class="blog-meta">
            Đăng bởi tài khoản ID: <strong>${blog.accountID}</strong>
            &nbsp;|&nbsp;
            Ngày đăng: <strong>${blog.datePosted}</strong>
        </p>

        <c:choose>
            <c:when test="${not empty blog.image}">
                <img src="${pageContext.request.contextPath}/img/${blog.image}"
                     alt="Ảnh bài viết"
                     class="blog-image-detail"/>
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/img/default.png"
                     alt="Không có ảnh"
                     class="blog-image-detail"/>
            </c:otherwise>
        </c:choose>

        <div class="blog-content">
            ${blog.content}
        </div>
    </c:if>

    <c:if test="${empty blog}">
        <p class="no-data">Không tìm thấy bài viết.</p>
    </c:if>
</div>
</body>
</html>
