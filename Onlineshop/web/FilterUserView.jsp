<%-- 
    Document   : FilterUserView
    Created on : Jul 5, 2025, 2:40:13 AM
    Author     : Duccon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
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
    </head>
    <body>
        <div class="container-fluid pt-5">
            <div class="row px-xl-5">
                <!-- SIDEBAR BÊN TRÁI -->
                <div class="col-lg-3 mb-5 sidebar-pink">
                    <h4 class="font-weight-semi-bold mb-4">Lọc sản phẩm</h4>

                    <!-- SẮP XẾP THEO GIÁ -->

                    <!<!-- Category -->
                    <h3>Danh mục</h3>
                    <div class="mb-3">
                        <c:forEach items="${listAllCategory}" var="category">
                            <a href="searchproductbycategory?cid=${category.categoryID}"
                               class="black-link font-weight-medium mb-2
                               <c:if test='${selectedCategoryId == category.categoryID}'> text-warning font-weight-bold</c:if>'">
                                ${category.categoryName} <br>
                            </a>
                        </c:forEach>


                    </div>

                    <!-- MÀU -->
                    <h3>Màu</h3>
                    <div class="mb-3">
                        <c:forEach items="${listAllColors}" var="color">
                            <a href="searchproductbycolor?colorId=${color.colorID}"
                               class="black-link font-weight-medium mb-2
                               <c:if test='${selectedColorId == color.colorID}'> text-warning font-weight-bold</c:if>'">
                                ${color.colorName} <br>
                            </a>
                        </c:forEach>


                    </div>
                    <!-- MÙA -->
                    <h3>Mùa</h3>
                    <div class="mb-4">

                        <c:forEach items="${listAllSeasons}" var="season">
                            <a href="searchproductbyseason?seasonId=${season.seasonID}"
                               class="black-link font-weight-medium mb-2
                               <c:if test='${selectedSeasonId == season.seasonID}'> text-warning font-weight-bold</c:if>'">
                                ${season.seasonName} <br>
                            </a>
                        </c:forEach>                 
                    </div>
                    <!-- GIÁ -->
                    <form action="SearchPriceMinToMax" onsubmit="return validatePriceRange()" class="mt-4">
                        <div class="form-row align-items-end">
                            <!-- Min Price -->
                            <div class="col">
                                <label for="priceMin" class="small font-weight-bold text-muted">Giá thấp nhất</label>
                                <input id="priceMin" name="priceMin" type="number" min="0" value="${priceMin}" class="form-control" placeholder="Tối thiểu">
                            </div>

                            <!-- Separator -->
                            <div class="col-auto d-flex align-items-center justify-content-center">
                                <span class="text-muted px-2">–</span>
                            </div>

                            <!-- Max Price -->
                            <div class="col">
                                <label for="priceMax" class="small font-weight-bold text-muted">Giá cao nhất</label>
                                <input id="priceMax" name="priceMax" type="number" min="0" value="${priceMax}" class="form-control" placeholder="Tối đa">
                            </div>

                            <!-- Search Button -->
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary mt-3">Lọc</button>
                            </div>
                        </div>

                        <!-- ✅ Đưa thông báo lỗi ra ngoài hàng input để không làm co giao diện -->
                        <div id="priceError" class="text-danger small mt-2" style="display: none;"></div>
                    </form>



                </div>
    </body>
</html>
