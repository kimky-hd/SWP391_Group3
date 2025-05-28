<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Blog List - Flower Shop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4 text-center text-pink">Danh sách Blog</h2>
        <div class="row">
            <c:forEach var="blog" items="${blogList}">
                <div class="col-md-6 mb-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title text-pink">${blog.title}</h5>
                            <p class="card-text">${blog.content}</p>
                        </div>
                        <div class="card-footer bg-white border-0 d-flex justify-content-between align-items-center">
                            <span class="text-muted"><i class="fa fa-user mr-1"></i>${blog.author}</span>
                            <span class="text-muted"><i class="fa fa-calendar-alt mr-1"></i>${blog.createdAt}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <!-- Form tạo blog mới (chỉ hiển thị cho staff) -->
        <c:if test="${sessionScope.user.role eq 'staff'}">
            <div class="card mt-5">
                <div class="card-header bg-pink text-white">Viết blog mới</div>
                <div class="card-body">
                    <form action="blog" method="post">
                        <div class="form-group">
                            <label for="title">Tiêu đề</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="form-group">
                            <label for="content">Nội dung</label>
                            <textarea class="form-control" id="content" name="content" rows="4" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-pink">Đăng blog</button>
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>