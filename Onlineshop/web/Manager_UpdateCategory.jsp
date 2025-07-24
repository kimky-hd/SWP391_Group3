<%-- 
    Document   : Manager_UpdateCategory
    Created on : Jun 17, 2025, 4:35:42 AM
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
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
                <h2>Sửa danh mục sản phẩm</h2>

                <form action="updatecategory" method="post" >
                    <div class="form-group">
                        <label>Tên danh mục</label>
                        <input name="categoryName" required class="form-control"
                               value="${oldValue != null ? oldValue : ''}" />   
                        <input type="hidden" name="categoryID" value="${categoryID}" />
                    </div>
                    <button type="submit" class="btn btn-primary">Sửa danh mục</button>
                    <p class="text-danger" style="color:#140C40">${msg}</p>

                </form>
            </div>
        </main>

        
    </body>
</html>
