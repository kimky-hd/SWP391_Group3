<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 20px;
            text-align: center;
        }
        .error-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"></jsp:include>
    
    <div class="container mt-5 mb-5">
        <div class="error-container">
            <div class="error-icon">
                <i class="bi bi-exclamation-triangle-fill"></i>
                &#9888;
            </div>
            <h2 class="mb-4">Đã xảy ra lỗi</h2>
            
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
            
            <div class="mt-4">
                <a href="javascript:history.back()" class="btn btn-outline-primary me-2">Quay lại</a>
                <a href="home" class="btn btn-primary">Về trang chủ</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp"></jsp:include>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
