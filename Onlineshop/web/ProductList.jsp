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

        <c:if test="${not empty mess}">
            <div id="message-popup">${mess}</div>
        </c:if>

        <!-- Topbar Start -->
        <div class="container-fluid">
            <div class="row bg-secondary py-1 px-xl-5">
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="d-inline-flex align-items-center h-100">
                        <a class="text-body mr-3" href="">About</a>
                        <a class="text-body mr-3" href="">Contact</a>
                        <a class="text-body mr-3" href="">Help</a>
                        <a class="text-body mr-3" href="">FAQs</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center text-lg-right">
                    <div class="d-inline-flex align-items-center">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown">
                                <%= acc.getUsername() %>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="VoucherController" class="dropdown-item">Voucher của tôi</a>
                                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</a>
                            </div>
                        </div>
                        <% } else { %>
                        <a href="login.jsp" class="btn btn-sm btn-light mr-2">Đăng nhập</a>
                        <a href="register.jsp" class="btn btn-sm btn-light">Đăng ký</a>
                        <% } %>
                    </div>
                    <div class="d-inline-flex align-items-center d-block d-lg-none">
                        <a href="" class="btn px-0 ml-2">
                            <i class="fas fa-heart text-dark"></i>
                            <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                        </a>
                        <a href="" class="btn px-0 ml-2">
                            <i class="fas fa-shopping-cart text-dark"></i>
                            <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                        </a>
                    </div>
                </div>
            </div>
            <div class="row align-items-center bg-light py-3 px-xl-5 d-none d-lg-flex">
                <div class="col-lg-4">
                    <a href="Homepage" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">BÁN</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">HOA</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="SearchProductByTitle">
                        <div class="input-group">
                            <input type="text" name="txt" class="form-control" placeholder="Tìm kiếm sản phẩm" value="${txt}">
                            <button type="submit" class="icon-search-button">
                                <i class="icon icon-search"></i> 
                            </button>
                        </div>
                    </form>
                </div>
                <div class="col-lg-4 col-6 text-right">
                    <p class="m-0">Customer Service</p>
                    <h5 class="m-0">+012 345 6789</h5>
                </div>
            </div>
        </div>
        <!-- Topbar End -->


        <!-- Navbar Start -->
        <div class="container-fluid bg-pink mb-0 p-0 sticky-navbar">
            <div class="row px-xl-5">
                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0 w-100">

                        <a href="#" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>

                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse justify-content-center" id="navbarCollapse">
                            <div class="navbar-nav py-0">
                                <a href="Homepage" class="nav-item nav-link">Trang chủ</a>
                                <a href="ViewListProductController" class="nav-item nav-link active">Sản phẩm</a>
                                <a href="detail.html" class="nav-item nav-link">Shop Detail</a>
                                <a href="VoucherController" class="nav-item nav-link">Mã giảm giá</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Pages <i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">
                                        <a href="Cart.jsp" class="dropdown-item">Giỏ hàng</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Thanh toán</a>
                                    </div>
                                </div>
                                <a href="contact.html" class="nav-item nav-link">Liên hệ</a>
                            </div>
                        </div>

                        <div class="d-none d-lg-flex align-items-center ml-auto">
                            <a href="ManageWishListController" class="btn px-0">
                                <i class="fas fa-heart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">${countWL}</span>
                            </a>
                            <a href="Cart.jsp" class="btn px-0 ml-3">
                                <i class="fas fa-shopping-cart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                                </span>
                            </a>
                            <a href="order?action=view" class="btn px-0 ml-3">
                                <i class="fas fa-clipboard-list text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.orderCount != null ? sessionScope.orderCount : 0}
                                </span>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar End -->
        <!-- Products Start -->

        <div class="container-fluid pt-5">
            <div class="row px-xl-5">
                <!-- SIDEBAR BÊN TRÁI -->
                <div class="col-lg-3 mb-5 sidebar-pink">
                    <h4 class="font-weight-semi-bold mb-4">Lọc sản phẩm</h4>

                    <!-- MÀU -->
                    <h3>Màu</h3>
                    <div class="mb-3">
                        <c:forEach items="${listAllColors}" var="color">
                            <a href="searchproductbycolor?colorId=${color.getColorID()}" class="black-link font-weight-medium mb-2">${color.getColorName()} <br></a>

                        </c:forEach>

                    </div>
                    <!-- MÙA -->
                    <h3>Mùa</h3>
                    <div class="mb-4">

                        <c:forEach items="${listAllSeasons}" var="season">
                            <a href="searchproductbyseason?seasonId=${season.getSeasonID()}" class="black-link font-weight-medium mb-2">${season.getSeasonName()} <br></a>

                        </c:forEach>                 
                    </div>
                    <!-- GIÁ -->
                    <div class="mb-3">
                        <h3 class="font-weight-medium mb-2">Giá</h3>
                        <div class="d-flex mb-2">

                            <a href="SearchPrice0to50" class="black-link font-weight-medium mb-2" >0 Đến 50.000</a>
                        </div>
                        <div class="d-flex mb-2">

                            <a href="SearchPriceAbove50" class="black-link font-weight-medium mb-2" >Trên 50.000</a>  
                        </div>
                        <form action="SearchPriceMinToMax" onsubmit="return validatePriceRang()" class="mt-4">
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
                        </form>


                    </div>



                </div>

                <!-- DANH SÁCH SẢN PHẨM BÊN PHẢI -->
                <div class="col-lg-9">
                    <div class="text-center mb-4">
                        <h2 class="section-title px-5"><span class="px-2">Danh sách sản phẩm</span></h2>
                    </div>

                    <div class="row">
                        <c:forEach items="${productList}" var="product" varStatus="status">
                            <div class="col-lg-3 col-md-6 col-sm-6 col-12 pb-1">
                                <div class="card product-item border-0 mb-4">
                                    <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0" style="height: 250px; display: flex; align-items: center; justify-content: center;">
                                        <img class="img-fluid h-100" src="${product.getImage()}" alt="${product.getTitle()}" style="object-fit: contain;">
                                    </div>
                                    <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
                                        <h6 class="text-truncate mb-3">
                                            <a href="ViewProductDetail?productid=${product.getProductID()}" class="text-dark">
                                                ${product.getTitle()}
                                            </a>
                                        </h6>

                                        <div class="d-flex justify-content-center">
                                            <h6>${product.getPrice()} VNĐ</h6>
                                        </div>
                                        <div class="d-flex justify-content-center">
                                            <h8>Ngày nhập : ${product.getDateImport()} </h8>
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
                                        <a href="AddWishlistController?pid=${product.getProductID()}" class="btn btn-sm text-dark p-0">
                                            <i class="far fa-heart text-primary mr-1"></i>Yêu Thích
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>


                    </div>


                    <c:if test="${tag != null}">
                        <ul class="pagination">
                            <c:if test="${tag != 1}">
                                <li class="page-item">
                                    <a class="page-link" href="ViewListProductController?index=${tag - 1}">Previous</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${endPage}" var="i">
                                <li class="page-item ${tag == i ? 'active' : ''}">
                                    <a class="page-link" href="ViewListProductController?index=${i}" 
                                       style="${tag == i ? 'text-decoration: underline;' : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${tag != endPage}">
                                <li class="page-item">
                                    <a class="page-link" href="ViewListProductController?index=${tag + 1}">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </c:if>


                </div>
            </div>
        </div>


        <!-- Products End -->

        <div class="container-fluid bg-pink text-secondary mt-5 pt-5">
            <div class="row px-xl-5 pt-5">
                <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
                    <h5 class="text-secondary text-uppercase mb-4">Get In Touch</h5>
                    <p class="mb-4">No dolore ipsum accusam no lorem. Invidunt sed clita kasd clita et et dolor sed dolor. Rebum tempor no vero est magna amet no</p>
                    <p class="mb-2"><i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street, New York, USA</p>
                    <p class="mb-2"><i class="fa fa-envelope text-primary mr-3"></i>info@example.com</p>
                    <p class="mb-0"><i class="fa fa-phone-alt text-primary mr-3"></i>+012 345 67890</p>
                </div>
                <div class="col-lg-8 col-md-12">
                    <div class="row">
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">Quick Shop</h5>
                            <div class="d-flex flex-column justify-content-start">
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                                <a class="text-secondary" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                            </div>
                        </div>
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">My Account</h5>
                            <div class="d-flex flex-column justify-content-start">
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                                <a class="text-secondary" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                            </div>
                        </div>
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">Newsletter</h5>
                            <p>Duo stet tempor ipsum sit amet magna ipsum tempor est</p>
                            <form action="">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Your Email Address">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary">Sign Up</button>
                                    </div>
                                </div>
                            </form>
                            <h6 class="text-secondary text-uppercase mt-4 mb-3">Follow Us</h6>
                            <div class="d-flex">
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-twitter"></i></a>
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-facebook-f"></i></a>
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-linkedin-in"></i></a>
                                <a class="btn btn-primary btn-square" href="#"><i class="fab fa-instagram"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>

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

        <%
            // Xoá session sau khi hiển thị
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        %>
    </body>
</html>