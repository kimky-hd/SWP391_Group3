<%@ page import="Model.Account" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Date" %>
<% pageContext.setAttribute("now", new Date()); %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mã Giảm Giá - Flower Shop</title>

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">

        <style>
            :root {
                --primary: #ff69b4;
                --secondary: #ffd6e7;
                --dark: #2d3436;
                --light: #f5f6fa;
                --success: #00b894;
                --warning: #fdcb6e;
            }

            .page-navigation {
                text-align: center;
                margin-bottom: 2rem;
            }

            .nav-btn {
                background: linear-gradient(45deg, var(--primary), #ff1493);
                border: none;
                border-radius: 25px;
                padding: 0.75rem 2rem;
                margin: 0 0.5rem;
                color: white;
                font-weight: 500;
                text-decoration: none;
                display: inline-block;
                transition: transform 0.2s;
            }

            .nav-btn:hover {
                transform: translateY(-2px);
                color: white;
                text-decoration: none;
            }

            .nav-btn.active {
                background: linear-gradient(45deg, var(--success), #00a085);
            }

            .card {
                height: 100%;
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0,0,0,.1);
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 25px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 15px rgba(0,0,0,.2);
            }

            .card-header {
                background: linear-gradient(45deg, var(--primary), #ff1493);
                padding: 1.5rem;
                text-align: center;
                border: none;
                flex: 0 0 auto;
                position: relative;
            }

            .card-header.added {
                background: linear-gradient(45deg, var(--success), #00a085);
            }

            .card-header.used {
                background: linear-gradient(45deg, #636e72, #2d3436);
            }

            .status-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: rgba(255,255,255,0.9);
                color: var(--dark);
                padding: 0.25rem 0.75rem;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
            }

            .card-body {
                padding: 1.5rem;
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .discount-amount {
                font-size: 2rem;
                font-weight: 700;
                color: white;
                margin: 0;
                text-shadow: 1px 1px 2px rgba(0,0,0,.2);
            }

            .voucher-code {
                background-color: var(--light);
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-weight: 500;
                color: var(--dark);
                display: inline-block;
                margin-bottom: 1rem;
                font-family: 'Courier New', monospace;
                letter-spacing: 1px;
            }

            .voucher-info {
                color: #636e72;
                margin-bottom: 0.75rem;
                font-size: 0.9rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .voucher-info i {
                width: 20px;
                text-align: center;
                color: var(--primary);
            }

            .btn-action {
                width: 100%;
                border: none;
                border-radius: 25px;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                color: white;
                transition: transform 0.2s;
                margin-top: 1rem;
            }

            .btn-add {
                background: linear-gradient(45deg, var(--primary), #ff1493);
            }

            .btn-added {
                background: linear-gradient(45deg, var(--success), #00a085);
            }

            .btn-use {
                background: linear-gradient(45deg, var(--warning), #e17055);
            }

            .btn-used {
                background: linear-gradient(45deg, #636e72, #2d3436);
            }

            .btn-action:hover:not(:disabled) {
                transform: translateY(-2px);
            }

            .btn-action:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .filter-select {
                border-radius: 20px;
                padding: 0.75rem 1.5rem;
                border: 2px solid var(--primary);
                color: var(--dark);
                font-weight: 500;
                width: 100%;
                max-width: 300px;
                margin: 0 auto;
                display: block;
                margin-bottom: 2rem;
            }

            .voucher-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 1.5rem;
                padding: 1.5rem;
            }

            @media (max-width: 768px) {
                .voucher-container {
                    grid-template-columns: 1fr;
                }
            }

            .expired {
                opacity: 0.6;
            }

            .alert {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 300px;
                border-radius: 10px;
                display: none;
            }
        </style>
    </head>

    <body>
        <!-- Include Header Start -->
        <jsp:include page="header.jsp"/>
        <!-- Include Header End -->

        <!-- Alert Messages -->
        <div id="alertSuccess" class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span id="successMessage"></span>
        </div>
        <div id="alertError" class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span id="errorMessage"></span>
        </div>

        <!-- Vouchers Start -->
        <div class="container-fluid pt-5">
            <div class="text-center mb-4">
                <h2 class="section-title px-5">
                    <span class="px-2">
                        <c:choose>
                            <c:when test="${pageType == 'my'}">Voucher Của Tôi</c:when>
                            <c:otherwise>Tất Cả Mã Giảm Giá</c:otherwise>
                        </c:choose>
                    </span>
                </h2>
            </div>

            <div class="container">
                <!-- Navigation -->
                <div class="page-navigation">
                    <a href="VoucherController" class="nav-btn ${pageType != 'my' ? 'active' : ''}">
                        <i class="fas fa-gift"></i> Tất Cả Voucher
                    </a>
                    <a href="VoucherController?action=myVouchers" class="nav-btn ${pageType == 'my' ? 'active' : ''}">
                        <i class="fas fa-wallet"></i> Voucher Của Tôi
                    </a>
                </div>

                <!-- Filter -->
                <select id="sortAndFilter" class="filter-select" onchange="handleVoucherDisplay()">
                    <option value="all">Tất Cả Mã Giảm Giá</option>
                    <option value="valid">Còn Hiệu Lực</option>
                    <option value="amount_desc">Giá Trị Cao Nhất</option>
                    <option value="amount_asc">Giá Trị Thấp Nhất</option>
                    <option value="date_asc">Sắp Hết Hạn</option>
                </select>

                <div class="voucher-container" id="voucherContainer">
                    <c:choose>
                        <c:when test="${empty vouchers}">
                            <div class="text-center w-100">
                                <div class="p-5 bg-white rounded">
                                    <i class="fas fa-ticket-alt fa-4x text-primary mb-4"></i>
                                    <h4>
                                        <c:choose>
                                            <c:when test="${pageType == 'my'}">Chưa Có Voucher Nào</c:when>
                                            <c:otherwise>Không Có Voucher Khả Dụng</c:otherwise>
                                        </c:choose>
                                    </h4>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${pageType == 'my'}">Hãy thêm voucher từ trang "Tất Cả Voucher"!</c:when>
                                            <c:otherwise>Hãy quay lại sau để kiểm tra voucher mới!</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${vouchers}" var="voucher">
                                <div class="voucher-item">
                                    <div class="card ${voucher.endDate lt now ? 'expired' : ''}">
                                        <div class="card-header
                                             <c:choose>
                                                 <c:when test="${voucher.used}">used</c:when>
                                                 <c:when test="${voucher.added}">added</c:when>
                                             </c:choose>">
                                            <h3 class="discount-amount">
                                                <fmt:formatNumber value="${voucher.discountAmount}" type="currency" currencySymbol="₫"/>
                                            </h3>
                                            <c:if test="${pageType != 'my'}">
                                                <div class="status-badge">
                                                    <c:choose>
                                                        <c:when test="${voucher.used}">Đã Dùng</c:when>
                                                        <c:when test="${voucher.added}">Đã Thêm</c:when>
                                                        <c:otherwise>Có Sẵn</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="card-body">
                                            <div class="voucher-code">${voucher.code}</div>

                                            <div class="voucher-info">
                                                <i class="fas fa-shopping-cart"></i>
                                                <span>Đơn tối thiểu: <fmt:formatNumber value="${voucher.minOrderValue}" type="currency" currencySymbol="₫"/></span>
                                            </div>

                                            <div class="voucher-info">
                                                <i class="fas fa-calendar-alt"></i>
                                                <span>Hết hạn: <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy"/></span>
                                            </div>

                                            <div class="voucher-info">
                                                <i class="fas fa-users"></i>
                                                <span>Còn lại: ${voucher.usageLimit - voucher.usedCount}/${voucher.usageLimit}</span>
                                            </div>

                                            <c:if test="${not empty voucher.description}">
                                                <div class="voucher-info">
                                                    <i class="fas fa-info-circle"></i>
                                                    <span>${voucher.description}</span>
                                                </div>
                                            </c:if>

                                            <!-- Action Buttons -->
                                            <c:choose>
                                                <c:when test="${pageType == 'my'}">
                                                    <c:choose>
                                                        <c:when test="${voucher.used}">
                                                            <button class="btn-action btn-used" disabled>
                                                                <i class="fas fa-check"></i> Đã Sử Dụng
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${voucher.endDate lt now}">
                                                            <button class="btn-action btn-used" disabled>
                                                                <i class="fas fa-clock"></i> Đã Hết Hạn
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action btn-use" onclick="useVoucher(${voucher.voucherId})">
                                                                <i class="fas fa-hand-holding-usd"></i> Sử Dụng Ngay
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${voucher.used}">
                                                            <button class="btn-action btn-used" disabled>
                                                                <i class="fas fa-check"></i> Đã Sử Dụng
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${voucher.added}">
                                                            <button class="btn-action btn-added" disabled>
                                                                <i class="fas fa-check"></i> Đã Thêm Vào Ví
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${voucher.endDate lt now}">
                                                            <button class="btn-action btn-used" disabled>
                                                                <i class="fas fa-clock"></i> Đã Hết Hạn
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${voucher.usedCount >= voucher.usageLimit}">
                                                            <button class="btn-action btn-used" disabled>
                                                                <i class="fas fa-times"></i> Đã Hết Lượt
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action btn-add" onclick="addVoucher(${voucher.voucherId})">
                                                                <i class="fas fa-plus"></i> Thêm Vào Ví
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <!-- Vouchers End -->

        <!-- Include Footer Start -->
        <jsp:include page="footer.jsp"/>
        <!-- Include Footer End -->

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Custom JavaScript -->
        <script>
                                                                // Thêm voucher vào tài khoản
                                                                function addVoucher(voucherId) {
                                                                    $.ajax({
                                                                        url: 'VoucherController',
                                                                        type: 'POST',
                                                                        data: {
                                                                            action: 'add',
                                                                            voucherId: voucherId
                                                                        },
                                                                        dataType: 'json',
                                                                        success: function (response) {
                                                                            if (response.success) {
                                                                                showAlert('success', response.message);
                                                                                // Cập nhật button
                                                                                updateButtonAfterAdd(voucherId);
                                                                            } else {
                                                                                showAlert('error', response.message);
                                                                            }
                                                                        },
                                                                        error: function () {
                                                                            showAlert('error', 'Có lỗi xảy ra khi thêm voucher');
                                                                        }
                                                                    });
                                                                }

                                                                // Sử dụng voucher (chuyển đến trang giỏ hàng)
                                                                function useVoucher(voucherId) {
                                                                    $.ajax({
                                                                        url: 'VoucherController',
                                                                        type: 'POST',
                                                                        data: {
                                                                            action: 'apply',
                                                                            voucherId: voucherId
                                                                        },
                                                                        dataType: 'json',
                                                                        success: function (response) {
                                                                            if (response.success) {
                                                                                showAlert('success', response.message);
                                                                                // Chuyển đến trang giỏ hàng sau 1 giây
                                                                                setTimeout(function () {
                                                                                    window.location.href = 'Cart.jsp';
                                                                                }, 1000);
                                                                            } else {
                                                                                showAlert('error', response.message);
                                                                            }
                                                                        },
                                                                        error: function () {
                                                                            showAlert('error', 'Có lỗi xảy ra khi áp dụng voucher');
                                                                        }
                                                                    });
                                                                }

                                                                // Cập nhật button sau khi thêm voucher
                                                                function updateButtonAfterAdd(voucherId) {
                                                                    const button = $(`button[onclick="addVoucher(${voucherId})"]`);
                                                                    button.removeClass('btn-add')
                                                                            .addClass('btn-added')
                                                                            .prop('disabled', true)
                                                                            .html('<i class="fas fa-check"></i> Đã Thêm Vào Ví')
                                                                            .attr('onclick', '');

                                                                    // Cập nhật header của card
                                                                    button.closest('.card').find('.card-header').addClass('added');

                                                                    // Thêm status badge nếu chưa có
                                                                    const statusBadge = button.closest('.card').find('.status-badge');
                                                                    if (statusBadge.length === 0) {
                                                                        button.closest('.card').find('.card-header').append('<div class="status-badge">Đã Thêm</div>');
                                                                    } else {
                                                                        statusBadge.text('Đã Thêm');
                                                                    }
                                                                }

                                                                // Hiển thị thông báo
                                                                function showAlert(type, message) {
                                                                    const alertId = type === 'success' ? '#alertSuccess' : '#alertError';
                                                                    const messageId = type === 'success' ? '#successMessage' : '#errorMessage';

                                                                    $(messageId).text(message);
                                                                    $(alertId).fadeIn().delay(3000).fadeOut();
                                                                }

                                                                // Xử lý filter và sort
                                                                function handleVoucherDisplay() {
                                                                    const filterValue = $('#sortAndFilter').val();
                                                                    const voucherItems = $('.voucher-item');

                                                                    // Reset display
                                                                    voucherItems.show();

                                                                    switch (filterValue) {
                                                                        case 'valid':
                                                                            voucherItems.each(function () {
                                                                                const card = $(this).find('.card');
                                                                                if (card.hasClass('expired')) {
                                                                                    $(this).hide();
                                                                                }
                                                                            });
                                                                            break;

                                                                        case 'amount_desc':
                                                                            sortVouchers('amount', 'desc');
                                                                            break;

                                                                        case 'amount_asc':
                                                                            sortVouchers('amount', 'asc');
                                                                            break;

                                                                        case 'date_asc':
                                                                            sortVouchers('date', 'asc');
                                                                            break;
                                                                    }
                                                                }

                                                                // Sắp xếp vouchers
                                                                function sortVouchers(type, order) {
                                                                    const container = $('#voucherContainer');
                                                                    const items = container.find('.voucher-item').get();

                                                                    items.sort(function (a, b) {
                                                                        let valueA, valueB;

                                                                        if (type === 'amount') {
                                                                            valueA = parseFloat($(a).find('.discount-amount').text().replace(/[₫,]/g, ''));
                                                                            valueB = parseFloat($(b).find('.discount-amount').text().replace(/[₫,]/g, ''));
                                                                        } else if (type === 'date') {
                                                                            valueA = new Date($(a).find('.voucher-info:contains("Hết hạn")').text().split(': ')[1]);
                                                                            valueB = new Date($(b).find('.voucher-info:contains("Hết hạn")').text().split(': ')[1]);
                                                                        }

                                                                        if (order === 'asc') {
                                                                            return valueA - valueB;
                                                                        } else {
                                                                            return valueB - valueA;
                                                                        }
                                                                    });

                                                                    container.empty().append(items);
                                                                }

                                                                // Khởi tạo khi trang load
                                                                $(document).ready(function () {
                                                                    // Ẩn các thông báo ban đầu
                                                                    $('.alert').hide();

                                                                    // Kiểm tra URL parameters để hiển thị thông báo
                                                                    const urlParams = new URLSearchParams(window.location.search);
                                                                    const message = urlParams.get('message');
                                                                    const type = urlParams.get('type');

                                                                    if (message && type) {
                                                                        showAlert(type, decodeURIComponent(message));
                                                                    }
                                                                });
        </script>
    </body>
</html>

