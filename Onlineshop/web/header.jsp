<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- PHẦN HEADER: only the DIVs, no <html> or <body> tags -->
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
                <% 
                    Account acc = (Account) session.getAttribute("account");
                    if (acc != null) {
                %>
                <div class="btn-group">
                    <button type="button" 
                            class="btn btn-sm btn-light dropdown-toggle" 
                            data-toggle="dropdown">
                        <%= acc.getUsername() %>
                    </button>
                    <div class="dropdown-menu dropdown-menu-right">
                        <a href="#" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</a>
                    </div>
                </div>
                <% } else { %>
                <a href="login.jsp" class="btn btn-sm btn-light mr-2">Đăng nhập</a>
                <a href="register.jsp" class="btn btn-sm btn-light">Đăng ký</a>
                <% } %>
            </div>
            <div class="d-inline-flex align-items-center d-block d-lg-none">
                <a href="" class="btn px-0">
                    <i class="fas fa-heart text-dark"></i>
                    <span class="badge text-dark border border-dark rounded-circle" 
                          style="padding-bottom: 2px;">0</span>
                </a>
                <a href="" class="btn px-0 ml-2">
                    <i class="fas fa-shopping-cart text-dark"></i>
                    <span class="badge text-dark border border-dark rounded-circle" 
                          style="padding-bottom: 2px;">0</span>
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
<div class="container-fluid bg-pink mb-30">
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
                        <a href="Homepage" class="nav-item nav-link active">Home</a>
                        <a href="ViewListProductController" class="nav-item nav-link">Shop</a>
                        <a href="detail.html" class="nav-item nav-link">Shop Detail</a>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Pages <i class="fa fa-angle-down mt-1"></i></a>
                            <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">
                                <a href="Cart.jsp" class="dropdown-item">Shopping Cart</a>
                                <a href="CheckOut.jsp" class="dropdown-item">Checkout</a>
                            </div>
                        </div>
                        <a href="contact.html" class="nav-item nav-link">Contact</a>
                    </div>
                </div>
                <div class="d-none d-lg-flex align-items-center ml-auto">
                    <a href="#" class="btn px-0">
                        <i class="fas fa-heart text-primary"></i>
                        <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                    </a>
                    <a href="Cart.jsp" class="btn px-0 ml-3">
                        <i class="fas fa-shopping-cart text-primary"></i>
                        <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                            ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                        </span>
                    </a>
                </div>
            </nav>
        </div>
    </div>
</div>
<!-- KẾT THÚC PHẦN HEADER -->
