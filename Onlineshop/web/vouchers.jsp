<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<% pageContext.setAttribute("now", new Date()); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Mã Giảm Giá</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #ff69b4;
            --secondary: #ffd6e7;
            --dark: #2d3436;
            --light: #f5f6fa;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--light);
        }
        
        .navbar {
            background-color: white !important;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
        }
        
        .logo:hover {
            color: var(--primary);
            text-decoration: none;
        }
        
 
            :root {
                --primary: #ff69b4;
                --secondary: #ffd6e7;
                --dark: #2d3436;
                --light: #f5f6fa;
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
            
            .card-header {
                background: linear-gradient(45deg, var(--primary), #ff1493);
                padding: 1.5rem;
                text-align: center;
                border: none;
                flex: 0 0 auto;
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
            
            .btn-use {
                width: 100%;
                background: linear-gradient(45deg, var(--primary), #ff1493);
                border: none;
                border-radius: 25px;
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                color: white;
                transition: transform 0.2s;
                margin-top: 1rem;
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
        </style>
    </style>
</head>
<body>
    <!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="logo" href="Homepage.jsp">FLOWER SHOP</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="Homepage.jsp">Trang Chủ</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="#">Mã Giảm Giá</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact.jsp">Liên Hệ</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Vouchers Start -->
    <div class="container py-5">
        <div class="text-center mb-5">
            <h2 class="font-weight-bold">Mã Giảm Giá Của Bạn</h2>
            <p class="text-muted">Sử dụng mã giảm giá để tiết kiệm chi phí mua hàng</p>
        </div>
        
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
                            <h4>Chưa Có Mã Giảm Giá</h4>
                            <p class="text-muted">Hãy tiếp tục mua sắm để nhận thêm ưu đãi!</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${vouchers}" var="voucher">
                        <div class="voucher-item">
                            <div class="card ${voucher.endDate lt now ? 'expired' : ''}">
                                <div class="card-header">
                                    <h3 class="discount-amount">
                                        <fmt:formatNumber value="${voucher.discountAmount}" type="currency" currencySymbol="₫"/>
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <div>
                                        <div class="voucher-code">${voucher.code}</div>
                                        <p class="voucher-info">
                                            <i class="far fa-clock"></i>
                                            <span>Hết hạn: ${voucher.endDate}</span>
                                        </p>
                                        <p class="voucher-info">
                                            <i class="fas fa-shopping-cart"></i>
                                            <span>Đơn tối thiểu: 
                                                <fmt:formatNumber value="${voucher.minOrderValue}" type="currency" currencySymbol="₫"/>
                                            </span>
                                        </p>
                                        <p class="voucher-info">
                                            <i class="fas fa-redo-alt"></i>
                                            <span>Còn lại: ${voucher.usageLimit - voucher.usedCount} lượt</span>
                                        </p>
                                        <c:if test="${not empty voucher.description}">
                                            <p class="voucher-info">
                                                <i class="fas fa-info-circle"></i>
                                                <span>${voucher.description}</span>
                                            </p>
                                        </c:if>
                                    </div>
                                    <button type="button" 
                                            onclick="useVoucher('${voucher.code}', '${voucher.discountAmount}', ${voucher.voucherId})" 
                                            class="btn btn-use" 
                                            ${voucher.endDate lt now ? 'disabled' : ''}>
                                        ${voucher.endDate lt now ? 'Đã Hết Hạn' : 'Sử Dụng Ngay'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <!-- Vouchers End -->

    <!-- Modal Xác nhận sử dụng voucher -->
    <div class="modal fade" id="useVoucherModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Xác Nhận Sử Dụng</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Bạn có muốn sử dụng mã giảm giá này không?</p>
                    <p>Mã: <strong><span id="voucherCode"></span></strong></p>
                    <p>Giá trị: <strong><span id="voucherAmount"></span>₫</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy Bỏ</button>
                    <button type="button" class="btn btn-primary" onclick="confirmUseVoucher()">Xác Nhận</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        let selectedVoucherId = null;

        function useVoucher(code, amount, voucherId) {
            selectedVoucherId = voucherId;
            $('#voucherCode').text(code);
            $('#voucherAmount').text(amount);
            $('#useVoucherModal').modal('show');
        }

        function handleVoucherDisplay() {
            const selectValue = document.getElementById('sortAndFilter').value;
            const voucherItems = Array.from(document.querySelectorAll('.voucher-item'));
            const container = document.getElementById('voucherContainer');

            voucherItems.forEach(item => {
                const card = item.querySelector('.card');
                if (selectValue === 'all') {
                    item.style.display = 'block';
                } else if (selectValue === 'valid') {
                    item.style.display = !card.classList.contains('expired') ? 'block' : 'none';
                }
            });

            if (['amount_asc', 'amount_desc', 'date_asc'].includes(selectValue)) {
                const visibleItems = voucherItems.filter(item => item.style.display !== 'none');
                visibleItems.sort((a, b) => {
                    const aAmount = parseFloat(a.querySelector('.discount-amount').textContent.replace(/[^0-9]/g, ''));
                    const bAmount = parseFloat(b.querySelector('.discount-amount').textContent.replace(/[^0-9]/g, ''));
                    const aDate = new Date(a.querySelector('.voucher-info').textContent.split(': ')[1]);
                    const bDate = new Date(b.querySelector('.voucher-info').textContent.split(': ')[1]);
                    
                    switch(selectValue) {
                        case 'amount_asc': return aAmount - bAmount;
                        case 'amount_desc': return bAmount - aAmount;
                        case 'date_asc': return aDate - bDate;
                        default: return 0;
                    }
                });
                
                visibleItems.forEach(item => container.appendChild(item));
            }
        }

        function confirmUseVoucher() {
            if (selectedVoucherId) {
                fetch(`VoucherController?action=apply&voucherId=${selectedVoucherId}`, {
                    method: 'POST'
                });
                $('#useVoucherModal').modal('hide');
                window.location.href = 'Cart.jsp';
            }
        }
    </script>
</body>
</html>
