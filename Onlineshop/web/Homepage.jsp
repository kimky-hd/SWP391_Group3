<%-- 
    Document   : Homepage
    Created on : May 24, 2025, 11:28:41 PM
    Author     : Duccon
--%>
<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Flower Commerce Website</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

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
    </head>

    <body>
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
                                    <button type="button" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</button>
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
                    <a href="" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search for products">
                            <div class="input-group-append">
                                <span class="input-group-text bg-transparent text-primary">
                                    <i class="fa fa-search"></i>
                                </span>
                            </div>
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
        <div class="container-fluid bg-pink mb-30">
            <div class="row px-xl-5">

                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0">
                        <a href="" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>
                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse justify-content-between" id="navbarCollapse">
                            <div class="navbar-nav mr-auto py-0">
                                <a href="Homepage" class="nav-item nav-link">Home</a>
                                <a href="ViewListProductController" class="nav-item nav-link active">Shop</a>
                                <a href="detail.html" class="nav-item nav-link">Shop Detail</a>
                                <a href="VoucherController" class="nav-item nav-link">Voucher</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Pages <i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">
                                        <a href="Cart.jsp" class="dropdown-item">Shopping Cart</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Checkout</a>
                                    </div>
                                </div>
                                <a href="contact.html" class="nav-item nav-link">Contact</a>
                            </div>
                            <div class="navbar-nav ml-auto py-0 d-none d-lg-block">
                                <a href="" class="btn px-0">
                                    <i class="fas fa-heart text-primary"></i>
                                    <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                                </a>
                                <a href="" class="btn px-0 ml-3">
                                    <i class="fas fa-shopping-cart text-primary"></i>
                                    <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                                </a>
                            </div>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar End -->

        <!-- Carousel Start -->
        <div class="container-fluid mb-3">
            <div class="row px-xl-5">
                <div class="col-lg-8">
                    <div id="header-carousel" class="carousel slide carousel-fade mb-30 mb-lg-0" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <li data-target="#header-carousel" data-slide-to="0" class="active"></li>
                            <li data-target="#header-carousel" data-slide-to="1"></li>
                            <li data-target="#header-carousel" data-slide-to="2"></li>
                        </ol>
                        <div class="carousel-inner">
                            <div class="carousel-item position-relative active" style="height: 430px;">
                                <img class="position-absolute w-100 h-100" src="img/banner1.jpg" style="object-fit: cover;">
                                <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                    <div class="p-3" style="max-width: 700px;">
                                        <h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Hoa Theo Mùa</h1>
                                        <p class="mx-md-5 px-5 animate__animated animate__bounceIn">Từng bông hoa rực rỡ theo mùa</p>
                                        <a href="ViewListProductController" class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" >Shop Now</a>
                                    </div>
                                </div>
                            </div>
                            <div class="carousel-item position-relative" style="height: 430px;">
                                <img class="position-absolute w-100 h-100" src="img/banner2.jpg" style="object-fit: cover;">
                                <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                    <div class="p-3" style="max-width: 700px;">
                                        <h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Hoa Ngày Lễ</h1>
                                        <p class="mx-md-5 px-5 animate__animated animate__bounceIn">Dành trọn tình cảm cho người mình yêu thương</p>
                                        <a href="ViewListProductController" class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" >Shop Now</a>
                                    </div>
                                </div>
                            </div>
                            <div class="carousel-item position-relative" style="height: 430px;">
                                <img class="position-absolute w-100 h-100" src="img/banner3.jpg" style="object-fit: cover;">
                                <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                    <div class="p-3" style="max-width: 700px;">
                                        <h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Sinh Nhật</h1>
                                        <p class="mx-md-5 px-5 animate__animated animate__bounceIn">Những đóa hoa sinh nhật theo chủ đề từng tháng</p>
                                        <a href="ViewListProductController" class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" >Shop Now</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="product-offer mb-30" style="height: 200px;">
                        <img class="img-fluid" src="img/offer-1.jpg" alt="">
                        <div class="offer-text">
                            <h6 class="text-white text-uppercase">Save 50%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Shop Now</a>
                        </div>
                    </div>
                    <div class="product-offer mb-30" style="height: 200px;">
                        <img class="img-fluid" src="img/offer-2.jpg" alt="">
                        <div class="offer-text">
                            <h6 class="text-white text-uppercase">Save 20%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Shop Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Carousel End -->


        <!-- Featured Start -->
        <div class="container-fluid pt-5">
            <div class="row px-xl-5 pb-3">
                <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
                    <div class="d-flex align-items-center bg-light mb-4" style="padding: 30px;">
                        <h1 class="fa fa-check text-primary m-0 mr-3"></h1>
                        <h5 class="font-weight-semi-bold m-0">Quality Flower</h5>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
                    <div class="d-flex align-items-center bg-light mb-4" style="padding: 30px;">
                        <h1 class="fa fa-shipping-fast text-primary m-0 mr-2"></h1>
                        <h5 class="font-weight-semi-bold m-0">Free Shipping</h5>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
                    <div class="d-flex align-items-center bg-light mb-4" style="padding: 30px;">
                        <h1 class="fas fa-exchange-alt text-primary m-0 mr-3"></h1>
                        <h5 class="font-weight-semi-bold m-0">1-Day Return</h5>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
                    <div class="d-flex align-items-center bg-light mb-4" style="padding: 30px;">
                        <h1 class="fa fa-phone-volume text-primary m-0 mr-3"></h1>
                        <h5 class="font-weight-semi-bold m-0">24/7 Support</h5>
                    </div>
                </div>
            </div>
        </div>
        <!-- Featured End -->


        <!-- Categories Start -->
        <div class="container-fluid pt-5">
            <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4"><span class="bg-secondary pr-3">Categories</span></h2>
            <div class="row px-xl-5 pb-3">
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <a class="text-decoration-none" href="">
                        <div class="cat-item d-flex align-items-center mb-4">
                            <div class="overflow-hidden" style="width: 100px; height: 100px;">
                                <img class="img-fluid" src="img/cat-1.jpg" alt="">
                            </div>
                            <div class="flex-fill pl-3">
                                <h6>Hoa Theo Mùa</h6>
                                <small class="text-body">100 Products</small>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <a class="text-decoration-none" href="">
                        <div class="cat-item img-zoom d-flex align-items-center mb-4">
                            <div class="overflow-hidden" style="width: 100px; height: 100px;">
                                <img class="img-fluid" src="img/cat-2.jpg" alt="">
                            </div>
                            <div class="flex-fill pl-3">
                                <h6>Hoa Theo Dịp Lễ</h6>
                                <small class="text-body">100 Products</small>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <a class="text-decoration-none" href="">
                        <div class="cat-item img-zoom d-flex align-items-center mb-4">
                            <div class="overflow-hidden" style="width: 100px; height: 100px;">
                                <img class="img-fluid" src="img/cat-3.jpg" alt="">
                            </div>
                            <div class="flex-fill pl-3">
                                <h6>Hoa Sinh Nhật</h6>
                                <small class="text-body">100 Products</small>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <a class="text-decoration-none" href="">
                        <div class="cat-item img-zoom d-flex align-items-center mb-4">
                            <div class="overflow-hidden" style="width: 100px; height: 100px;">
                                <img class="img-fluid" src="img/cat-4.jpg" alt="">
                            </div>
                            <div class="flex-fill pl-3">
                                <h6>Hoa Theo Màu</h6>
                                <small class="text-body">100 Products</small>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <!-- Categories End -->


        <!-- Products Start -->
        <div class="container-fluid pt-5 pb-3">
            <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4"><span class="bg-secondary pr-3">Featured Products</span></h2>
            <div class="row px-xl-5">
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-1.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-2.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star-half-alt text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-3.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star-half-alt text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-4.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-5.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-6.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star-half-alt text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-7.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star-half-alt text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                    <div class="product-item bg-light mb-4">
                        <div class="product-img position-relative overflow-hidden">
                            <img class="img-fluid w-100" src="img/product-8.jpg" alt="">
                            <div class="product-action">
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-shopping-cart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="far fa-heart"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-sync-alt"></i></a>
                                <a class="btn btn-outline-dark btn-square" href=""><i class="fa fa-search"></i></a>
                            </div>
                        </div>
                        <div class="text-center py-4">
                            <a class="h6 text-decoration-none text-truncate" href="">Product Name Goes Here</a>
                            <div class="d-flex align-items-center justify-content-center mt-2">
                                <h5>$123.00</h5><h6 class="text-muted ml-2"><del>$123.00</del></h6>
                            </div>
                            <div class="d-flex align-items-center justify-content-center mb-1">
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="fa fa-star text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small class="far fa-star text-primary mr-1"></small>
                                <small>(99)</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Products End -->





        <!-- Footer Start -->

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

            <!-- Footer End -->


            <!-- Back to Top -->
            <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

            <!-- Logout Modal-->
            <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header bg-pink text-white">
                            <h5 class="modal-title" id="exampleModalLabel">
                                <i class="fas fa-sign-out-alt mr-2"></i>Xác nhận đăng xuất
                            </h5>
                            <button class="close text-white" type="button" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                        <div class="modal-body py-4">
                            <div class="text-center mb-3">
                                <i class="fas fa-question-circle text-pink" style="font-size: 3rem;"></i>
                            </div>
                            <p class="text-center mb-0" style="font-size: 1.1rem; color: #000000; font-weight: 600;">
                                Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?
                            </p>
                        </div>
                        <div class="modal-footer justify-content-center border-0 pt-0">
                            <button class="btn btn-secondary px-4" type="button" data-dismiss="modal">
                                <i class="fas fa-times mr-2"></i>Hủy
                            </button>
                            <a class="btn btn-pink px-4" href="LogoutServlet">
                                <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thêm style cho modal -->
            <style>
                .modal-content {
                    border: none;
                    border-radius: 15px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                }
                
                .modal-header {
                    border-top-left-radius: 15px;
                    border-top-right-radius: 15px;
                    border-bottom: none;
                }
                
                .btn-pink {
                    background: linear-gradient(45deg, #FFB6C1, #FFA5B5);
                    border: none;
                    color: white;
                    transition: all 0.3s ease;
                }
                
                .btn-pink:hover {
                    background: linear-gradient(45deg, #FFA5B5, #FFB6C1);
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(255, 182, 193, 0.4);
                }
                
                .btn-secondary {
                    background: #f8f9fa;
                    color: #6c757d;
                    border: none;
                    transition: all 0.3s ease;
                }
                
                .btn-secondary:hover {
                    background: #e9ecef;
                    transform: translateY(-2px);
                }
                
                .modal-dialog-centered {
                    display: flex;
                    align-items: center;
                    min-height: calc(100% - 1rem);
                }
                
                .text-pink {
                    color: #FFB6C1 !important;
                }
                
                .bg-pink {
                    background: linear-gradient(45deg, #FFB6C1, #FFA5B5) !important;
                }
            </style>

            <!-- Custom Javascript -->
            <script>
                $(document).ready(function() {
                    // Xử lý sự kiện khi nhấn vào nút đăng xuất
                    $('.dropdown-item[data-toggle="modal"]').on('click', function(e) {
                        e.preventDefault();
                        $('#logoutModal').modal('show');
                    });
                });
            </script>

            <!-- JavaScript Libraries -->
            <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
            <script src="lib/easing/easing.min.js"></script>
            <script src="lib/owlcarousel/owl.carousel.min.js"></script>

            <!-- Contact Javascript File -->
            <script src="mail/jqBootstrapValidation.min.js"></script>
            <script src="mail/contact.js"></script>

            <!-- Template Javascript -->
            <script src="js/main.js"></script>
    </body>
</html>