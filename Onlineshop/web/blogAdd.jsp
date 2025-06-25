<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Blog Mới</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- External Styles -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        body, html {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: url('https://img.lovepik.com/photo/50091/3710.jpg_wh860.jpg') no-repeat top left,
                        url('https://images.pexels.com/photos/931162/pexels-photo-931162.jpeg') no-repeat top right,
                        #f4f4f4;
            background-size: auto 100vh, auto 100vh;
            background-attachment: fixed;
        }

        main {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
        }

        .blog-form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 700px;
        }

        .blog-form-container h2 {
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
            white-space: pre-wrap;
            word-break: break-word;
            overflow-wrap: break-word;
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
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="header.jsp" />

    <!-- Main Content -->
    <main>
        <div class="blog-form-container">
            <h2>Thêm Blog Mới</h2>

            <c:if test="${not empty requestScope.error}">
                <p class="error-message">${requestScope.error}</p>
            </c:if>

            <c:if test="${not empty requestScope.success}">
                <p class="success-message">${requestScope.success}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/blogs" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create"/>

                <div class="form-group">
                    <label for="title">Tiêu đề:</label>
                    <input type="text" id="title" name="title" required value="${param.title}">
                </div>

                <div class="form-group">
                    <label for="content">Nội dung:</label>
                    <textarea id="content"
                              name="content"
                              required
                              wrap="soft">${fn:escapeXml(param.content)}</textarea>
                </div>

                <div class="form-group">
                    <label for="image">Ảnh minh họa:</label>
                    <input type="file" id="image" name="image" accept="image/*">
                </div>

                <div class="button-group">
                    <button type="submit" class="action-btn">Thêm Blog</button>
                    <button type="button" class="action-btn back-btn"
                            onclick="window.location.href = '${pageContext.request.contextPath}/blogs?action=list'">Quay lại</button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
