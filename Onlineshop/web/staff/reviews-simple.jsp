<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Đánh giá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>Quản Lý Đánh Giá</h1>
        
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title"><c:out value="${totalReviews}"/></h5>
                        <p class="card-text">Tổng đánh giá</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5>Danh sách Đánh giá</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty feedbackList}">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Đánh giá</th>
                                    <th>Nội dung</th>
                                    <th>Ngày tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="feedback" items="${feedbackList}">
                                    <tr>
                                        <td><c:out value="${feedback.feedbackId}"/></td>
                                        <td><c:out value="${feedback.username}"/></td>
                                        <td><c:out value="${feedback.productTitle}"/></td>
                                        <td>
                                            <c:forEach begin="1" end="${feedback.rating}">
                                                ⭐
                                            </c:forEach>
                                            (<c:out value="${feedback.rating}"/>)
                                        </td>
                                        <td><c:out value="${feedback.comment}"/></td>
                                        <td><c:out value="${feedback.createdAt}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center">
                            <h5>Chưa có đánh giá nào</h5>
                            <p>Đánh giá từ khách hàng sẽ hiển thị ở đây</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        console.log('Simple reviews page loaded');
        console.log('feedbackList exists: <c:out value="${not empty feedbackList}"/>');
        console.log('feedbackList size: <c:out value="${feedbackList != null ? feedbackList.size() : 0}"/>');
        console.log('totalReviews: <c:out value="${totalReviews}"/>');
    </script>
</body>
</html>
