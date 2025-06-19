<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Lịch sử mua hàng</title>
</head>
<body>
<h2>Lịch sử mua hàng của tất cả người dùng</h2>
<table border="1">
    <tr>
        <th>Mã hóa đơn</th>
        <th>Username</th>
        <th>Ngày xuất</th>
        <th>Trạng thái</th>
        <th>Sản phẩm</th>
        <th>Đơn giá</th>
        <th>Số lượng</th>
        <th>Tổng đơn</th>
    </tr>
    <c:forEach var="o" items="${orderHistory}">
        <tr>
            <td>${o.maHD}</td>
            <td>${o.username}</td>
            <td>${o.ngayXuat}</td>
            <td>${o.status}</td>
            <td>${o.productTitle}</td>
            <td>${o.productPrice}</td>
            <td>${o.quantity}</td>
            <td>${o.tongGia}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
