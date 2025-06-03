<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<% pageContext.setAttribute("now", new Date()); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Vouchers</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        :root {
            --primary: #ff69b4;
            --secondary: #ffd6e7;
        }
        
        .bg-primary {
            background-color: var(--primary) !important;
        }
        
        .text-primary {
            color: var(--primary) !important;
        }
        
        .border-primary {
            border-color: var(--primary) !important;
        }
        
        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-primary:hover {
            background-color: #ff1493;
            border-color: #ff1493;
        }
        
        .card {
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        
        .card.expired {
            opacity: 0.7;
            background-color: #f8f9fa;
        }
        
        .card.expired .card-header {
            background-color: #6c757d !important;
        }
        
        .logo {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--primary);
            text-decoration: none;
        }
        
        .logo:hover {
            text-decoration: none;
            color: #ff1493;
        }
    </style>
</head>
<body>
    <!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="logo" href="Homepage.jsp">FLOWER SHOP</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="Homepage.jsp">HOME</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="#">VOUCHERS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact.jsp">CONTACT</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Vouchers Start -->
    <div class="container py-5">
        <div class="text-center mb-5">
            <h2 class="font-weight-bold">Vouchers của bạn</h2>
        </div>
        
        <!-- Phần lọc và tìm kiếm -->
        <div class="row justify-content-center mb-4">
            <div class="col-md-6">
                <select id="sortAndFilter" class="form-control" onchange="handleVoucherDisplay()">
                    <option value="all">Tất cả voucher</option>
                    <option value="amount_asc">Giá trị tăng dần</option>
                    <option value="amount_desc">Giá trị giảm dần</option>
                    <option value="date_asc">Ngày hết hạn gần nhất</option>
                    <option value="date_desc">Ngày hết hạn xa nhất</option>
                </select>
            </div>
        </div>
        
        <!-- Hiển thị voucher -->
        <div class="row" id="voucherContainer">
            <c:choose>
                <c:when test="${empty vouchers}">
                    <div class="col-12 text-center">
                        <div class="p-5 bg-light rounded">
                            <i class="fas fa-ticket-alt fa-4x text-primary mb-4"></i>
                            <h4>Bạn chưa có voucher</h4>
                            <p class="text-muted">Hãy tiếp tục mua sắm để nhận thêm voucher mới!</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${vouchers}" var="voucher">
                        <div class="col-lg-4 col-md-6 mb-4 voucher-item">
                            <div class="card ${voucher.expiryDate.time lt now.time ? 'expired' : ''}" 
                                 data-voucher-id="${voucher.voucherId}"
                                 data-expiry-date="${voucher.expiryDate}">
                                <div class="card-header ${voucher.expiryDate lt now ? 'bg-secondary' : 'bg-primary'} text-white text-center py-4">
                                    <h3 class="mb-0 font-weight-bold">${voucher.discountAmount}đ</h3>
                                </div>
                                <div class="card-body text-center">
                                    <h5 class="card-title">Mã: ${voucher.code}</h5>
                                    <p class="text-muted">Hết hạn: ${voucher.expiryDate}</p>
                                    <c:if test="${voucher.expiryDate lt now}">
                                        <p class="text-danger font-weight-bold mb-3">Voucher này đã hết hạn</p>
                                    </c:if>
                                    <div class="mt-4">
                                        <c:choose>
                                            <c:when test="${voucher.expiryDate.time lt now.time}">
                                                <button type="button" class="btn btn-secondary mr-2" disabled>
                                                    <i class="fas fa-clock mr-2"></i>Đã hết hạn
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" 
                                                        onclick="useVoucher('${voucher.code}', '${voucher.discountAmount}', ${voucher.voucherId}, '${voucher.expiryDate}')" 
                                                        class="btn btn-primary mr-2"
                                                        ${voucher.expiryDate.time lt now.time ? 'disabled' : ''}>
                                                    <i class="fas fa-check mr-2"></i>Sử dụng
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <button type="button" 
                                                onclick="deleteVoucher('${voucher.code}', '${voucher.discountAmount}', ${voucher.voucherId})" 
                                                class="btn btn-danger">
                                            <i class="fas fa-trash mr-2"></i>Xóa
                                        </button>
                                    </div>
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
                    <h5 class="modal-title">Xác nhận sử dụng voucher</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn sử dụng voucher này không?</p>
                    <p>Mã voucher: <strong><span id="voucherCode"></span></strong></p>
                    <p>Giá trị: <strong><span id="voucherAmount"></span>đ</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="confirmUseVoucher()">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xác nhận xóa voucher -->
    <!-- Remove this entire modal section -->
    <div class="modal fade" id="deleteVoucherModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Xác nhận xóa voucher</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa voucher này không?</p>
                    <p>Mã voucher: <strong><span id="deleteVoucherCode"></span></strong></p>
                    <p>Giá trị: <strong><span id="deleteVoucherAmount"></span>đ</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDeleteVoucher()">Xác nhận</button>
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
        
        // Khởi tạo các modal khi trang được tải
        $(document).ready(function() {
            $('#useVoucherModal').modal({
                show: false
            });
            $('#deleteVoucherModal').modal({
                show: false
            });
        });
    
        function useVoucher(code, amount, voucherId, expiryDate) {
            const now = new Date();
            const expiry = new Date(expiryDate);
            
            if (expiry < now) {
                alert('Voucher đã hết hạn!');
                return;
            }
            
            // Tạo form và submit trực tiếp
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'VoucherController';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'use';
            
            const voucherInput = document.createElement('input');
            voucherInput.type = 'hidden';
            voucherInput.name = 'voucherId';
            voucherInput.value = voucherId;
            
            form.appendChild(actionInput);
            form.appendChild(voucherInput);
            document.body.appendChild(form);
            form.submit();
        }
    
        function deleteVoucher(code, amount, voucherId) {
            const voucherElement = document.querySelector(`.voucher-item button[onclick*="${voucherId}"]`).closest('.voucher-item');
            
            fetch(`VoucherController?action=delete&voucherId=${voucherId}`, {
                method: 'POST'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                // Xóa phần tử voucher
                voucherElement.remove();
                
                // Kiểm tra và hiển thị thông báo nếu không còn voucher
                const remainingVouchers = document.querySelectorAll('.voucher-item');
                if (remainingVouchers.length === 0) {
                    document.getElementById('voucherContainer').innerHTML = `
                        <div class="col-12 text-center">
                            <div class="p-5 bg-light rounded">
                                <i class="fas fa-ticket-alt fa-4x text-primary mb-4"></i>
                                <h4>Bạn chưa có voucher</h4>
                                <p class="text-muted">Hãy tiếp tục mua sắm để nhận thêm voucher mới!</p>
                            </div>
                        </div>
                    `;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi xóa voucher');
            });
        }
    
        function handleVoucherDisplay() {
            const selectValue = document.getElementById('sortAndFilter').value;
            const voucherItems = Array.from(document.querySelectorAll('.voucher-item'));
            const container = document.getElementById('voucherContainer');
            
            // Lọc voucher
            voucherItems.forEach(item => {
                const card = item.querySelector('.card');
                if (selectValue === 'all') {
                    item.style.display = 'block';
                } else if (selectValue === 'expired') {
                    item.style.display = card.classList.contains('expired') ? 'block' : 'none';
                } else if (selectValue === 'valid') {
                    item.style.display = !card.classList.contains('expired') ? 'block' : 'none';
                }
            });
            
            // Sắp xếp voucher
            if (['amount_asc', 'amount_desc', 'date_asc', 'date_desc'].includes(selectValue)) {
                const visibleItems = voucherItems.filter(item => item.style.display !== 'none');
                visibleItems.sort((a, b) => {
                    const aAmount = parseFloat(a.querySelector('h3').textContent);
                    const bAmount = parseFloat(b.querySelector('h3').textContent);
                    const aDate = new Date(a.querySelector('.text-muted').textContent.split(': ')[1]);
                    const bDate = new Date(b.querySelector('.text-muted').textContent.split(': ')[1]);
                    
                    switch(selectValue) {
                        case 'amount_asc': return aAmount - bAmount;
                        case 'amount_desc': return bAmount - aAmount;
                        case 'date_asc': return aDate - bDate;
                        case 'date_desc': return bDate - aDate;
                        default: return 0;
                    }
                });
                
                visibleItems.forEach(item => container.appendChild(item));
            }
        }
    
        function confirmUseVoucher() {
            if (selectedVoucherId) {
                const voucherElement = document.querySelector(`[data-voucher-id="${selectedVoucherId}"]`);
                const expiryDate = new Date(voucherElement.dataset.expiryDate);
                const now = new Date();
                
                if (expiryDate < now) {
                    alert('Voucher đã hết hạn!');
                    $('#useVoucherModal').modal('hide');
                    return;
                }
                
                // Tạo form và submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'VoucherController';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'use';
                
                const voucherInput = document.createElement('input');
                voucherInput.type = 'hidden';
                voucherInput.name = 'voucherId';
                voucherInput.value = selectedVoucherId;
                
                form.appendChild(actionInput);
                form.appendChild(voucherInput);
                document.body.appendChild(form);
                
                $('#useVoucherModal').modal('hide');
                form.submit();
            }
        }
    
        function confirmDeleteVoucher() {
            if (selectedVoucherId) {
                const voucherElement = document.querySelector(`.voucher-item button[onclick*="${selectedVoucherId}"]`).closest('.voucher-item');
                
                fetch(`VoucherController?action=delete&voucherId=${selectedVoucherId}`, {
                    method: 'POST'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    $('#deleteVoucherModal').modal('hide');
                    
                    // Xóa phần tử voucher
                    voucherElement.remove();
                    
                    // Kiểm tra và hiển thị thông báo nếu không còn voucher
                    const remainingVouchers = document.querySelectorAll('.voucher-item');
                    if (remainingVouchers.length === 0) {
                        document.getElementById('voucherContainer').innerHTML = `
                            <div class="col-12 text-center">
                                <div class="p-5 bg-light rounded">
                                    <i class="fas fa-ticket-alt fa-4x text-primary mb-4"></i>
                                    <h4>Bạn chưa có voucher</h4>
                                    <p class="text-muted">Hãy tiếp tục mua sắm để nhận thêm voucher mới!</p>
                                </div>
                            </div>
                        `;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa voucher');
                    $('#deleteVoucherModal').modal('hide');
                });
            }
        }
    </script>
                </body>
                </html>
