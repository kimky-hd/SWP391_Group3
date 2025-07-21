<%-- 
    Document   : WhishList
    Created on : June 5, 2025, 12:02:19 AM
    Author     : Admin
--%>
<%@ page import="Model.Account" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Flower Shop - WishList</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <style>
            .product-item {
                transition: transform 0.3s ease;
            }

            .product-item:hover {
                transform: translateY(-5px);
            }

            .product-img img {
                object-fit: contain;
            }
        </style>
        <style>
            /* Giao diện bảng */
            table {
                border-collapse: collapse;
                width: 100%;
                background-color: #fff;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            table thead {
                background-color: #f8f9fa;
            }

            table th, table td {
                border: 1px solid #dee2e6;
                padding: 12px;
                vertical-align: middle;
                text-align: center;
            }

            /* Tiêu đề bảng */
            h2.text-center {
                font-size: 28px;
                font-weight: bold;
                color: #343a40;
            }

            /* Ảnh sản phẩm */
            table img {
                width: 60px;
                height: auto;
                border-radius: 6px;
            }

            /* Nút Remove */
            .wishlist-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background-color 0.3s ease;
            }

            .wishlist-btn:hover {
                background-color: #c82333;
            }

            /* Link sản phẩm */
            table a {
                color: #007bff;
                text-decoration: none;
            }

            table a:hover {
                text-decoration: underline;
            }

            /* Responsive nhẹ */
            @media (max-width: 768px) {
                table th, table td {
                    font-size: 14px;
                    padding: 8px;
                }

                h2.text-center {
                    font-size: 22px;
                }

                .wishlist-btn {
                    padding: 5px 10px;
                    font-size: 13px;
                }
            }
        </style>
        <style>
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0,0,0,0.5);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }

            .modal-box {
                background-color: white;
                padding: 24px;
                border-radius: 8px;
                max-width: 400px;
                width: 90%;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                text-align: center;
            }

            .modal-buttons {
                margin-top: 20px;
                display: flex;
                justify-content: space-around;
            }

            .btn {
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn-danger {
                background-color: #dc3545;
                color: white;
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
        </style>



    </head>
    <body>
        <!-- Topbar Start -->
        <jsp:include page="header.jsp" />
        <!-- Topbar End -->

        <jsp:include page="FilterProductForUser.jsp" />

        <!-- Wishlist Section -->
        <div class="container mt-5 mb-5">
            <h2 class="text-center mb-4">Sản Phẩm Yêu Thích</h2>
            <div class="row">
                <table style="width: 100%; text-align: center;">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Còn</th>
                            <th>Giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty listWL}">
                                <tr>
                                    <td colspan="5" style="padding: 20px; text-align: center; font-style: italic; color: gray;">
                                        Chưa có sản phẩm yêu thích nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${listWL}" var="listWL">
                                    <tr>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/img/${listWL.getImage()}" 
                                                 style="width: 50px; height: auto;" />
                                        </td>
                                        <td>
                                            <a href="ViewProductDetail?productid=${listWL.getProductID()}">${listWL.getTitle()}</a>
                                        </td>
                                        <td>${listWL.getQuantity()}</td>
                                        <fmt:setLocale value="vi_VN" />
                                        <td><fmt:formatNumber value="${listWL.getPrice()}" /> VNĐ</td>
                                        <td>
                                            <c:set var="isInWishlist" value="false" />
                                            <c:forEach items="${listWLByAcc}" var="listWLByAcc">
                                                <c:if test="${listWL.getProductID() == listWLByAcc.getProductID()}">
                                                    <c:set var="isInWishlist" value="true" />
                                                    <form action="ManageWishListController" method="post">
                                                        <input type="hidden" name="wlid" value="${listWLByAcc.getWishListID()}">
                                                        <button type="button" class="wishlist-btn" onclick="openDeleteModal('${listWLByAcc.getWishListID()}')">Xóa</button>
                                                    </form>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>

                </table>
                <c:if test="${tag != null && not empty listWL}">
                    <ul class="pagination">
                        <c:if test="${tag != 1}">
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}?index=${tag - 1}${extraParams}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="${baseUrl}?index=${i}${extraParams}"
                                   style="${tag == i ? 'text-decoration: underline;' : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}?index=${tag + 1}${extraParams}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>
            </div>
        </div>

        <-<!-- Footer start -->

        <jsp:include page="footer.jsp" />

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
        <!-- Sticky Button for Custom Order -->
        <div class="flower-fixed-btn">
            <a href="CustomOrder.jsp" title="Đặt hoa theo yêu cầu">
                <i class="fas fa-seedling"></i> <!-- Bạn có thể thay bằng: fa-pencil-alt, fa-heart, fa-rose -->
            </a>
        </div>

        <script>
                                                            window.onload = function () {
                                                                var messageBox = document.getElementById("message-box");
                                                                if (messageBox.innerHTML.trim() !== "") { // Only show if there's a message
                                                                    messageBox.style.display = "block";
                                                                    setTimeout(function () {
                                                                        messageBox.style.display = "none"; // Hide after 3 seconds
                                                                    }, 3000);
                                                                }
                                                            };
        </script>
        <!-- Modal Xác Nhận Xóa -->
        <div id="deleteModal" class="modal-overlay">
            <div class="modal-box">
                <p>Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?</p>
                <form action="ManageWishListController" method="post">
                    <input type="hidden" name="wlid" id="deleteWlid" />
                    <div class="modal-buttons">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                        <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openDeleteModal(wlid) {
                document.getElementById("deleteWlid").value = wlid;
                document.getElementById("deleteModal").style.display = "flex";
            }

            function closeModal() {
                document.getElementById("deleteModal").style.display = "none";
            }
        </script>

    </body>


</html>
