<%-- 
    Document   : ProductList
    Created on : May 22, 2025, 4:26:19 AM
    Author     : Admin
--%>
<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Flower Shop - Product List</title>
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
            .product-img {
                height: 250px; /* Hoặc chiều cao mong muốn */
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .product-img img {
                height: 100%;
                width: auto;
                object-fit: contain;
            }
            .sidebar-pink {
                background-color: #fce4ec;
                border-radius: 8px;
                padding: 20px;
            }
            .black-link {
                color: black;
                text-decoration: none; /* nếu không muốn gạch chân */
            }
            .icon-search-button {
                background-color: transparent;
                border: none;
                cursor: pointer;
            }
            .icon-search-button .icon {
                font-size: 20px; /* Điều chỉnh kích thước icon */
                color: #333; /* Màu của icon */
            }
            .sticky-navbar {
                position: sticky;
                top: 0;
                z-index: 1020;
                background-color: var(--primary);
            }
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-button {
                background-color: #f8f9fa;
                border: 1px solid #ccc;
                padding: 8px 16px;
                cursor: pointer;
                font-weight: bold;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                right: 0;
                background-color: white;
                min-width: 180px;
                box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
                z-index: 1;
                border: 1px solid #ddd;
            }

            .dropdown-content a {
                color: black;
                padding: 10px 14px;
                text-decoration: none;
                display: block;
            }

            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }
            
        </style>
        <style>
            #message-popup {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background-color: #28a745; /* Màu xanh thông báo thành công */
                color: white;
                padding: 16px 32px;
                border-radius: 8px;
                font-size: 18px;
                z-index: 9999;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                animation: fadeOut 0.5s ease-in-out 2.5s forwards;
            }

            /* Ẩn sau 3s bằng animation */
            @keyframes fadeOut {
                to {
                    opacity: 0;
                    visibility: hidden;
                }
            }
        </style>

    </head>



    <body>
        <%
            String baseUrl = (String) request.getAttribute("baseUrl");
            String extraParams = (String) request.getAttribute("extraParams");
            if (baseUrl == null) baseUrl = "ViewListProductController";
            if (extraParams == null) extraParams = "";
        %>

        <c:if test="${not empty mess}">
            <div id="message-popup">${mess}</div>
        </c:if>

        <jsp:include page="header.jsp" />



        <!-- Products Start -->

        <jsp:include page="FilterProductForUser.jsp" />

                <!-- DANH SÁCH SẢN PHẨM BÊN PHẢI -->
                <c:set var="sortOrder" value="${sortOrder != null ? sortOrder : 'asc'}" />
                <c:choose>
                    <c:when test="${sortOrder == 'desc'}">
                        <c:set var="sortLabel" value="Giá: Cao đến thấp" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="sortLabel" value="Giá: Thấp đến cao" />
                    </c:otherwise>
                </c:choose>

                <div class="col-lg-9">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <h2 style="margin: 0;">Danh sách sản phẩm</h2>

                        <div class="dropdown">
                            <div class="dropdown-button">
                                <c:choose>
                                    <c:when test="${param.sortOrder == 'asc'}">Giá: Thấp đến cao ⏷</c:when>
                                    <c:when test="${param.sortOrder == 'desc'}">Giá: Cao đến thấp ⏷</c:when>
                                    <c:otherwise>Sắp xếp theo thứ tự ⏷</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="dropdown-content">
                                <a href="ViewListProductController">Sắp xếp theo thứ tự</a>
                                <a href="SearchSortProduct?sortOrder=asc">Giá: Thấp đến cao</a>
                                <a href="SearchSortProduct?sortOrder=desc">Giá: Cao đến thấp</a>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <c:forEach items="${productList}" var="product" varStatus="status">
                            <div class="col-lg-3 col-md-6 col-sm-6 col-12 pb-1">
                                <div class="card product-item border-0 mb-4">
                                    <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0" style="height: 250px; display: flex; align-items: center; justify-content: center;">
                                        <img class="img-fluid h-100" src="${pageContext.request.contextPath}/img/${product.getImage()}" alt="${product.getTitle()}" style="object-fit: contain;">
                                    </div>
                                    <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
                                        <h6 class="text-truncate mb-3">
                                            <a href="ViewProductDetail?productid=${product.getProductID()}" class="text-dark">
                                                ${product.getTitle()}
                                            </a>
                                        </h6>

                                        <div class="d-flex justify-content-center">
                                            <h6><fmt:formatNumber value="${product.getPrice()}" pattern="#,##0" /> VNĐ</h6>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-center">
                                        <c:choose>
                                            <c:when test="${product.getQuantity() == 0}">
                                                <small class="text-danger">Hết Hàng</small>
                                            </c:when>
                                            <c:otherwise>
                                                <small class="text-muted">Số Lượng : ${product.getQuantity()}</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-footer d-flex justify-content-between bg-light border">
                                        <c:choose>
                                            <c:when test="${product.getQuantity() == 0}">
                                                <button class="btn btn-sm text-dark p-0" onclick="showOutOfStockAlert()">
                                                    <i class="fas fa-shopping-cart text-primary mr-1"></i>Thêm vào giỏ hàng
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="cart?action=add&productId=${product.getProductID()}&quantity=1" class="btn btn-sm text-dark p-0">
                                                    <i class="fas fa-shopping-cart text-primary mr-1"></i>Thêm vào giỏ hàng
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:set var="wishlist" value="${requestScope.wishlistProductIDs}" />
                                        <c:set var="isLiked" value="false" />

                                        <c:forEach var="item" items="${wishlist}">
                                            <c:if test="${item.productID == product.productID}">
                                                <c:set var="isLiked" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${isLiked}">
                                                <a href="AddWishlistController?pid=${product.productID}&index=${tag}" class="btn btn-sm text-danger p-0 font-weight-bold">
                                                    <i class="fas fa-heart mr-1"></i>Đã yêu thích
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="AddWishlistController?pid=${product.productID}&index=${tag}" class="btn btn-sm text-dark p-0">
                                                    <i class="far fa-heart text-primary mr-1"></i>Yêu Thích
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${tag != null}">
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
        </div>



        <!-- Products End -->

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
        <!-- Sticky Button for Custom Order End -->

        <!-- Toast Message Container -->
        <style>
            .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .toast {
            padding: 15px 25px;
            margin-bottom: 12px;
            border-radius: 12px;
            color: #5f375f;
            background-color: #fce4ec;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.4s ease-in-out;
            border-left: 6px solid #f48fb1;
            }

            .toast.show {
            opacity: 1;
            transform: translateX(0);
            }

            .toast.success {
            background-color: #f8bbd0;
            border-left-color: #40ec46;
            }

            .toast.error {
            background-color: #fce4ec;
            border-left-color: #d81b60;
            }
        </style>

        <div class="toast-container"></div>

        <script>
                                                    function showToast(message, type) {
                                                        const container = document.querySelector('.toast-container');
                                                        const toast = document.createElement('div');
                                                        toast.className = `toast ${type}`;
                                                        toast.textContent = message;

                                                        container.appendChild(toast);

                                                        // Reflow để kích hoạt animation
                                                        toast.offsetHeight;

                                                        // Show toast
                                                        toast.classList.add('show');

                                                        // Tự động biến mất sau 3s
                                                        setTimeout(() => {
                                                            toast.classList.remove('show');
                                                            setTimeout(() => {
                                                                container.removeChild(toast);
                                                            }, 400);
                                                        }, 3000);
                                                    }

                                                    // Lấy message từ session JSP
                                                    const message = '<%= session.getAttribute("message") != null ? session.getAttribute("message") : "" %>';
                                                    const messageType = '<%= session.getAttribute("messageType") != null ? session.getAttribute("messageType") : "" %>';

                                                    if (message && messageType) {
                                                        showToast(message, messageType);
                                                    }
        </script>
        <script>
            setTimeout(function () {
                var msg = document.getElementById("message-popup");
                if (msg) {
                    msg.remove(); // hoặc msg.style.display = "none";
                }
            }, 3000);
        </script>

        <script>
            function showOutOfStockAlert() {
                Swal.fire({
                    icon: 'error',
                    title: 'Hết hàng!',
                    text: 'Sản phẩm này hiện đã hết hàng. Vui lòng chọn sản phẩm khác.',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'Đóng'
                });
            }
        </script>

        <!-- JavaScript validation -->
        <script>
            function validatePriceRange() {
                const minInput = document.getElementById('priceMin');
                const maxInput = document.getElementById('priceMax');
                const errorBox = document.getElementById('priceError');

                const min = parseFloat(minInput.value);
                const max = parseFloat(maxInput.value);

                // Xóa thông báo cũ
                errorBox.textContent = "";
                errorBox.style.display = "none";

                // Kiểm tra giá âm
                if (!isNaN(min) && min < 0) {
                    errorBox.textContent = "⚠️ Giá thấp nhất không thể là số âm.";
                    errorBox.style.display = "block";
                    minInput.focus();
                    return false;
                }

                if (!isNaN(max) && max < 0) {
                    errorBox.textContent = "⚠️ Giá cao nhất không thể là số âm.";
                    errorBox.style.display = "block";
                    maxInput.focus();
                    return false;
                }

                // Kiểm tra max < min
                if (!isNaN(min) && !isNaN(max) && max < min) {
                    errorBox.textContent = "⚠️ Giá cao nhất không thể nhỏ hơn giá thấp nhất.";
                    errorBox.style.display = "block";
                    maxInput.focus();
                    return false;
                }

                return true;
            }
        </script>



        <%
            // Xoá session sau khi hiển thị
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        %>
    </body>
</html>