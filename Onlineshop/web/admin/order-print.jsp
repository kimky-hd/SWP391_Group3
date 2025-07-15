<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In đơn hàng #${order.orderId} - Admin</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --dark-color: #5a5c69;
        }
        
        .main-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .print-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }
        
        .print-header h1 {
            font-size: 24px;
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 5px;
        }
        
        .print-header p {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 0;
        }
        
        .order-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        
        .order-info-section {
            flex: 1;
            padding: 0 15px;
        }
        
        .order-info-section h2 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #4e73df;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        
        .order-info-section p {
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .order-info-section strong {
            font-weight: 600;
            color: #495057;
        }
        
        .order-items {
            margin-bottom: 30px;
        }
        
        .order-items h2 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #4e73df;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        
        .order-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .order-table th {
            background-color: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        
        .order-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .order-table .text-right {
            text-align: right;
        }
        
        .order-table .text-center {
            text-align: center;
        }
        
        .order-total {
            margin-top: 20px;
            text-align: right;
        }
        
        .order-total p {
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .order-total .total {
            font-size: 18px;
            font-weight: 700;
            color: #4e73df;
        }
        
        .print-footer {
            margin-top: 40px;
            text-align: center;
            color: #6c757d;
            font-size: 14px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }
        
        .print-actions {
            text-align: center;
            margin-top: 30px;
        }
        
        @media print {
            body {
                background-color: white;
            }
            
            .main-content {
                background: white;
                padding: 0;
            }
            
            .dashboard-card {
                box-shadow: none;
                padding: 0;
            }
            
            .print-actions, 
            .topbar, 
            .sidebar,
            .no-print {
                display: none !important;
            }
            
            .main-content {
                margin-left: 0;
                margin-top: 0;
            }
        }
        
        /* Topbar và Sidebar styles */
        .topbar {
            background-color: var(--dark);
            padding: 10px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
        }
        
        .topbar-brand {
            color: #3B82F6;
            font-size: 28px;
            font-weight: 700;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .topbar-actions .nav-link {
            color: #ffffff;
        }
        
        .sidebar {
            width: 250px;
            background-color: #f8f9fa;
            border-right: 1px solid #e0e0e0;
            height: 100vh;
            position: fixed;
            top: 60px;
            left: 0;
            padding: 20px 0;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);
        }
        
        .sidebar-menu .nav-link {
            color: var(--dark);
        }
        
        .sidebar-menu .nav-link:hover,
        .sidebar-menu .nav-link.active {
            background-color: var(--light);
            color: #3B82F6;
        }
        
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 20px;
            background-color: #f9fafb;
            min-height: calc(100vh - 60px);
        }
    </style>
</head>
<body>
    <!-- Topbar -->
    <jsp:include page="../manager_topbarsidebar.jsp" />
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-file-invoice me-2"></i>In đơn hàng #${order.orderId}
                </h1>
                <div class="print-actions no-print">
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="fas fa-print me-2"></i>In đơn hàng
                    </button>
                    <button class="btn btn-secondary ms-2" onclick="closeWindow()">
    <i class="fas fa-arrow-left me-2"></i>Quay lại
</button>
                </div>
            </div>
            
            <div class="dashboard-card">
                <div class="print-header">
                    <h1>PHIẾU ĐƠN HÀNG</h1>
                    <p>Mã đơn hàng: #${order.orderId}</p>
                    <p>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="order-info-section">
                            <h2><i class="fas fa-user me-2"></i>Thông tin khách hàng</h2>
                            <p><strong>Họ tên:</strong> ${order.fullName}</p>
                            <p><strong>Email:</strong> ${order.email}</p>
                            <p><strong>Số điện thoại:</strong> ${order.phone}</p>
                            <p><strong>Địa chỉ:</strong> ${order.address}</p>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="order-info-section">
                            <h2><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h2>
                            <p>
                                <strong>Trạng thái:</strong>
                                <c:choose>
                                    <c:when test="${order.status eq 'Pending'}">
                                        <span class="badge bg-warning text-dark">Đang xử lý</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Completed'}">
                                        <span class="badge bg-success">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Cancelled'}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>
                                </c:choose>
                            </p>
                            <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                            <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                        </div>
                    </div>
                </div>
                
                <div class="order-items mt-4">
                    <h2><i class="fas fa-shopping-cart me-2"></i>Chi tiết đơn hàng</h2>
                    <div class="table-responsive">
                        <table class="order-table table table-hover">
                            <thead>
                                <tr>
                                    <th width="50%">Sản phẩm</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-right">Đơn giá</th>
                                    <th class="text-right">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderDetails}" var="detail">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:if test="${detail.product != null && detail.product.image != null}">
                                                    <img src="${detail.product.image}" alt="${detail.product.title}" 
                                                         class="img-thumbnail me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:if>
                                                <div>
                                                    <strong>${detail.product.title}</strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">${detail.quantity}</td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${detail.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end"><strong>Tổng cộng:</strong></td>
                                    <td class="text-right">
                                        <strong class="text-primary fs-5">
                                            <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </strong>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                
                <div class="print-footer">
                    <p>Cảm ơn quý khách đã mua hàng tại cửa hàng của chúng tôi!</p>
                    <p>Mọi thắc mắc xin vui lòng liên hệ với chúng tôi qua email hoặc số điện thoại.</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script>
    // Tự động mở hộp thoại in khi nhấn nút in
    function printOrder() {
        window.print();
    }
    
    // Đóng cửa sổ hiện tại
    function closeWindow() {
        window.close();
    }
</script>
</body>
</html>