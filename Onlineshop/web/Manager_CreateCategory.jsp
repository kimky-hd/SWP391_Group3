<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Manager</title>
        <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

    </head>

    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <h2>Thêm danh mục sản phẩm</h2>

                <form action="addcategory" method="post" onsubmit="return validateForm();" >
                    <div class="form-group">
                        <label>Tên thể loại</label>
                        <input name="categoryName" required class="form-control"
                               value="${oldValue != null ? oldValue : ''}" />                       
                    </div>
                    <button type="submit" class="btn btn-primary">Thêm thể loại</button>
                    <p class="text-danger" style="color:#140C40">${msg}</p>
                    <p style="color:green">${Success}</p>
                </form>
            </div>
            <!-- /.container-fluid -->
        </main> 

        <!-- Footer -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
        </footer>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>


    </body>
</html>