<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Blog</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 700px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        textarea {
            width: calc(100% - 22px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }
        textarea {
            resize: vertical;
            min-height: 150px;
        }
        input[type="file"] {
            padding: 8px 0;
        }
        .error-message {
            color: #e74c3c;
            margin-top: 10px;
            text-align: center;
            font-weight: bold;
        }
        .success-message {
            color: #27ae60;
            margin-top: 10px;
            text-align: center;
            font-weight: bold;
        }
        .button-group {
            text-align: center;
            margin-top: 25px;
        }
        .action-btn {
            padding: 10px 20px;
            background-color: #ff6600;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin: 0 5px;
            transition: background-color 0.3s ease;
        }
        .action-btn:hover {
            background-color: #e65c00;
        }
        .back-btn {
            background-color: #7f8c8d;
        }
        .back-btn:hover {
            background-color: #616e70;
        }
        .current-image {
            margin-top: 10px;
            text-align: center;
        }
        .current-image img {
            max-width: 200px;
            height: auto;
            border: 1px solid #ddd;
            padding: 5px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container">
        <h2>Chỉnh Sửa Blog</h2>

        <c:if test="${not empty requestScope.error}">
            <p class="error-message">${requestScope.error}</p>
        </c:if>

        <c:if test="${not empty requestScope.success}">
            <p class="success-message">${requestScope.success}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/blogs" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="blogID" value="${blogToEdit.blogID}"/>
            <input type="hidden" name="oldImage" value="${blogToEdit.image}"/>

            <div class="form-group">
                <label for="title">Tiêu đề:</label>
                <input type="text" id="title" name="title" required value="${blogToEdit.title}">
            </div>

            <div class="form-group">
                <label for="content">Nội dung:</label>
                <textarea id="content" name="content" required>${blogToEdit.content}</textarea>
            </div>

            <div class="form-group">
                <label for="image">Ảnh minh họa:</label>
                <input type="file" id="image" name="image" accept="image/*">
                <c:if test="${not empty blogToEdit.image}">
                    <div class="current-image">
                        <p>Ảnh hiện tại:</p>
                        <img src="${pageContext.request.contextPath}/img/${blogToEdit.image}" alt="Current Blog Image">
                    </div>
                </c:if>
            </div>

            <div class="button-group">
                <button type="submit" class="action-btn">Cập Nhật Blog</button>
                <button type="button" class="action-btn back-btn" onclick="window.location.href='${pageContext.request.contextPath}/blogs?action=detail&bid=${blogToEdit.blogID}'">Hủy</button>
            </div>
        </form>
    </div>
            <jsp:include page="footer.jsp" />
</body>
</html>