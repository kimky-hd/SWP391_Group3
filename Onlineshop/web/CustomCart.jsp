<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ hàng tùy chỉnh</title>
        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Playfair+Display:wght@400;500&display=swap" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">

        <style>
            .custom-order-image {
                max-width: 100px;
                max-height: 100px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #f8bbd0;
            }

            .custom-order-card {
                border-radius: 15px;
                border: 1px solid #f8bbd0;
                overflow: hidden;
                transition: all 0.3s ease;
                margin-bottom: 20px;
                background-color: #fff;
            }

            .custom-order-card:hover {
                box-shadow: 0 5px 15px rgba(242, 92, 156, 0.2);
                transform: translateY(-5px);
            }

            .custom-order-header {
                background-color: #fce4ec;
                padding: 15px;
                border-bottom: 1px solid #f8bbd0;
            }

            .custom-order-body {
                padding: 20px;
            }

            .custom-order-footer {
                background-color: #fef5f9;
                padding: 15px;
                border-top: 1px solid #f8bbd0;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .status-pending {
                background-color: #fff3e0;
                color: #e65100;
                border: 1px solid #ffcc80;
            }

            .status-processing {
                background-color: #e3f2fd;
                color: #0d47a1;
                border: 1px solid #90caf9;
            }

            .status-completed {
                background-color: #e8f5e9;
                color: #1b5e20;
                border: 1px solid #a5d6a7;
            }

            .status-cancelled {
                background-color: #ffebee;
                color: #b71c1c;
                border: 1px solid #ef9a9a;
            }

            .btn-custom-pink {
                background-color: #f8bbd0;
                color: #880e4f;
                border: none;
                transition: all 0.3s ease;
            }

            .btn-custom-pink:hover {
                background-color: #f48fb1;
                color: #fff;
            }

            .description-text {
                max-height: 100px;
                overflow-y: auto;
            }

            .modal-content {
                border-radius: 15px;
                border: none;
            }

            .modal-header {
                background-color: #fce4ec;
                border-bottom: 1px solid #f8bbd0;
                border-radius: 15px 15px 0 0;
            }

            .modal-footer {
                background-color: #fef5f9;
                border-top: 1px solid #f8bbd0;
                border-radius: 0 0 15px 15px;
            }

            .form-control:focus {
                border-color: #f48fb1;
                box-shadow: 0 0 0 0.2rem rgba(244, 143, 177, 0.25);
            }

            .empty-cart-message {
                text-align: center;
                padding: 50px 0;
            }

            .empty-cart-icon {
                font-size: 60px;
                color: #f8bbd0;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="font-weight-semi-bold">Giỏ hàng tự thiết kế</h2>
                            <a href="CustomOrder.jsp" class="btn btn-custom-pink">
                                <i class="fas fa-plus mr-2"></i>Thêm mới sản phẩm tự thiết kế
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty customOrderCarts}">
                                <div class="empty-cart-message">
                                    <div class="empty-cart-icon">
                                        <i class="fas fa-shopping-basket"></i>
                                    </div>
                                    <h4>Giỏ hàng tự thiết kế của bạn hiện đang trống</h4>
                                    <p class="text-muted">Hãy thêm mới sản phẩm tự thiết kế của bạn</p>
                                    <a href="CustomOrder.jsp" class="btn btn-custom-pink mt-3">
                                        <i class="fas fa-plus mr-2"></i>Tạo mới sản phẩm tự thiết kế
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <c:forEach var="customOrder" items="${customOrderCarts}">
                                        <div class="col-lg-6 mb-4">
                                            <div class="custom-order-card">
                                                <div class="custom-order-header d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0">Đơn hàng tự thiết kế: ${customOrder.customCartID}</h5>
                                                    <span class="status-badge status-${customOrder.status.toLowerCase()}">${customOrder.status}</span>
                                                </div>
                                                <div class="custom-order-body">
                                                    <div class="row">
                                                        <div class="col-md-4 text-center">
                                                            <!-- Hình ảnh chính -->
                                                            <img src="${pageContext.request.contextPath}/${customOrder.referenceImage}" alt="Hình ảnh tham khảo" class="custom-order-image mb-3" onerror="this.src='${pageContext.request.contextPath}/img/user.jpg'">
                                                            
                                                            <!-- Hình ảnh bổ sung -->
                                                            <div class="row mt-2">
                                                                <c:if test="${not empty customOrder.referenceImage2}">
                                                                    <div class="col-6 mb-2">
                                                                        <img src="${pageContext.request.contextPath}/${customOrder.referenceImage2}" alt="Hình ảnh tham khảo 2" class="custom-order-image" onerror="this.style.display='none'">
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty customOrder.referenceImage3}">
                                                                    <div class="col-6 mb-2">
                                                                        <img src="${pageContext.request.contextPath}/${customOrder.referenceImage3}" alt="Hình ảnh tham khảo 3" class="custom-order-image" onerror="this.style.display='none'">
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty customOrder.referenceImage4}">
                                                                    <div class="col-6 mb-2">
                                                                        <img src="${pageContext.request.contextPath}/${customOrder.referenceImage4}" alt="Hình ảnh tham khảo 4" class="custom-order-image" onerror="this.style.display='none'">
                                                                    </div>
                                                                </c:if>
                                                                <c:if test="${not empty customOrder.referenceImage5}">
                                                                    <div class="col-6 mb-2">
                                                                        <img src="${pageContext.request.contextPath}/${customOrder.referenceImage5}" alt="Hình ảnh tham khảo 5" class="custom-order-image" onerror="this.style.display='none'">
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <!-- Nội dung mô tả và thông tin khác giữ nguyên -->
                                                            <div class="mb-3">
                                                                <h6>Mô tả:</h6>
                                                                <div class="description-text">${customOrder.description}</div>
                                                            </div>
                                                            <div class="d-flex justify-content-between">
                                                                <div>
                                                                    <h6>Số lượng:</h6>
                                                                    <p>${customOrder.quantity}</p>
                                                                </div>
                                                                <div>
                                                                    <h6>Ngày tạo:</h6>
                                                                    <p><fmt:formatDate value="${customOrder.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="custom-order-footer d-flex justify-content-end">
                                                    <c:if test="${customOrder.statusID == 7}">
                                                        <form action="custom-vnpay" method="post" class="mr-2">
                                                            <input type="hidden" name="customCartId" value="${customOrder.customCartID}">
                                                            <button type="submit" class="btn btn-sm btn-success">
                                                                <i class="fas fa-credit-card mr-1"></i>Thanh toán
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <button class="btn btn-sm btn-outline-secondary mr-2" onclick="openEditModal(${customOrder.customCartID})">
                                                        <i class="fas fa-edit mr-1"></i>Sửa
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${customOrder.customCartID})">
                                                        <i class="fas fa-trash-alt mr-1"></i>Xóa
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Chỉnh sửa đơn hàng tự thiết kế</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="editForm" action="custom-cart" method="post" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" id="editCustomCartId" name="customCartId">
                            <input type="hidden" name="action" value="update">

                            <div class="form-group">
                                <label for="editDescription">Mô tả chi tiết</label>
                                <textarea class="form-control" id="editDescription" name="description" rows="5" required></textarea>
                                <small class="text-muted"><i class="fas fa-lightbulb"></i>Càng chi tiết càng giúp chúng tôi hiểu rõ nhu cầu của bạn.</small>
                            </div>

                            <div class="form-group">
                                <label for="editQuantity">Số lượng</label>
                                <input type="number" class="form-control" id="editQuantity" name="quantity" min="1" max="100" required>
                                <small class="text-muted"><i class="fas fa-box"></i>Nhập số lượng sản phẩm bạn muốn đặt</small>
                            </div>

                            <div class="form-group">
                                <label>Hình ảnh hiện tại</label>
                                <div class="row">
                                    <div class="col-md-4 mb-2">
                                        <img id="currentImage" src="" alt="Hình ảnh tham khảo" class="img-fluid" style="max-height: 150px;" onerror="this.src='${pageContext.request.contextPath}/img/user.jpg'">
                                        <label for="editImageUpload">Hình ảnh chính</label>
                                        <input type="file" class="form-control" id="editImageUpload" name="imageUpload" accept="image/*">
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <img id="currentImage2" src="" alt="Hình ảnh tham khảo 2" class="img-fluid" style="max-height: 150px;" onerror="this.style.display='none'">
                                        <label for="editImageUpload2">Hình ảnh 2</label>
                                        <input type="file" class="form-control" id="editImageUpload2" name="imageUpload2" accept="image/*">
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <img id="currentImage3" src="" alt="Hình ảnh tham khảo 3" class="img-fluid" style="max-height: 150px;" onerror="this.style.display='none'">
                                        <label for="editImageUpload3">Hình ảnh 3</label>
                                        <input type="file" class="form-control" id="editImageUpload3" name="imageUpload3" accept="image/*">
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <img id="currentImage4" src="" alt="Hình ảnh tham khảo 4" class="img-fluid" style="max-height: 150px;" onerror="this.style.display='none'">
                                        <label for="editImageUpload4">Hình ảnh 4</label>
                                        <input type="file" class="form-control" id="editImageUpload4" name="imageUpload4" accept="image/*">
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <img id="currentImage5" src="" alt="Hình ảnh tham khảo 5" class="img-fluid" style="max-height: 150px;" onerror="this.style.display='none'">
                                        <label for="editImageUpload5">Hình ảnh 5</label>
                                        <input type="file" class="form-control" id="editImageUpload5" name="imageUpload5" accept="image/*">
                                    </div>
                                </div>
                                <small class="text-muted"><i class="fas fa-info-circle"></i>Thêm hình ảnh mẫu giúp chúng tôi hiểu rõ yêu cầu của bạn về sản phẩm</small>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-custom-pink">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Custom JavaScript -->
        <script>
                                                        function openEditModal(customCartId) {
                                                            $.ajax({
                                                                url: 'custom-cart',
                                                                type: 'GET',
                                                                data: {
                                                                    action: 'get',
                                                                    customCartId: customCartId
                                                                },
                                                                dataType: 'json',
                                                                success: function (response) {
                                                                    if (response.success) {
                                                                        var customOrder = response.customOrder;
                                                                        $('#editCustomCartId').val(customOrder.customCartID);
                                                                        $('#editDescription').val(customOrder.description);
                                                                        $('#editQuantity').val(customOrder.quantity);
                                                                        $('#currentImage').attr('src', '${pageContext.request.contextPath}/' + customOrder.referenceImage);
                                                                        
                                                                        // Hiển thị các hình ảnh bổ sung nếu có
                                                                        if (customOrder.referenceImage2) {
                                                                            $('#currentImage2').attr('src', '${pageContext.request.contextPath}/' + customOrder.referenceImage2);
                                                                            $('#currentImage2').show();
                                                                        } else {
                                                                            $('#currentImage2').hide();
                                                                        }
                                                                        
                                                                        if (customOrder.referenceImage3) {
                                                                            $('#currentImage3').attr('src', '${pageContext.request.contextPath}/' + customOrder.referenceImage3);
                                                                            $('#currentImage3').show();
                                                                        } else {
                                                                            $('#currentImage3').hide();
                                                                        }
                                                                        
                                                                        if (customOrder.referenceImage4) {
                                                                            $('#currentImage4').attr('src', '${pageContext.request.contextPath}/' + customOrder.referenceImage4);
                                                                            $('#currentImage4').show();
                                                                        } else {
                                                                            $('#currentImage4').hide();
                                                                        }
                                                                        
                                                                        if (customOrder.referenceImage5) {
                                                                            $('#currentImage5').attr('src', '${pageContext.request.contextPath}/' + customOrder.referenceImage5);
                                                                            $('#currentImage5').show();
                                                                        } else {
                                                                            $('#currentImage5').hide();
                                                                        }
                                                                        
                                                                        $('#editModal').modal('show');
                                                                    } else {
                                                                        alert('Không thể lấy thông tin đơn hàng. Vui lòng thử lại sau.');
                                                                    }
                                                                },
                                                                error: function () {
                                                                    alert('Đã xảy ra lỗi khi kết nối đến máy chủ. Vui lòng thử lại sau.');
                                                                }
                                                            });
                                                        }


                                                        function confirmDelete(customCartId) {
                                                            if (confirm('Bạn có chắc chắn muốn xóa đơn hàng tùy chỉnh này?')) {
                                                                // Gửi AJAX request để xóa đơn hàng
                                                                $.ajax({
                                                                    url: 'custom-cart',
                                                                    type: 'POST',
                                                                    data: {
                                                                        action: 'delete',
                                                                        customCartId: customCartId
                                                                    },
                                                                    dataType: 'json',
                                                                    success: function (response) {
                                                                        if (response.success) {
                                                                            // Reload trang sau khi xóa thành công
                                                                            location.reload();
                                                                        } else {
                                                                            alert('Không thể xóa đơn hàng. Vui lòng thử lại sau.');
                                                                        }
                                                                    },
                                                                    error: function () {
                                                                        alert('Đã xảy ra lỗi khi kết nối đến máy chủ. Vui lòng thử lại sau.');
                                                                    }
                                                                });
                                                            }
                                                        }

// Hiển thị hình ảnh đã chọn trước khi tải lên
                                                        $(document).ready(function () {
                                                            $('#editImageUpload').change(function () {
                                                                if (this.files && this.files[0]) {
                                                                    var reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        $('#currentImage').attr('src', e.target.result);
                                                                        $('#currentImage').show();
                                                                    }
                                                                    reader.readAsDataURL(this.files[0]);
                                                                }
                                                            });
                                                            
                                                            // Thêm xử lý cho các ảnh bổ sung
                                                            $('#editImageUpload2').change(function () {
                                                                if (this.files && this.files[0]) {
                                                                    var reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        $('#currentImage2').attr('src', e.target.result);
                                                                        $('#currentImage2').show();
                                                                    }
                                                                    reader.readAsDataURL(this.files[0]);
                                                                }
                                                            });
                                                            
                                                            $('#editImageUpload3').change(function () {
                                                                if (this.files && this.files[0]) {
                                                                    var reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        $('#currentImage3').attr('src', e.target.result);
                                                                        $('#currentImage3').show();
                                                                    }
                                                                    reader.readAsDataURL(this.files[0]);
                                                                }
                                                            });
                                                            
                                                            $('#editImageUpload4').change(function () {
                                                                if (this.files && this.files[0]) {
                                                                    var reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        $('#currentImage4').attr('src', e.target.result);
                                                                        $('#currentImage4').show();
                                                                    }
                                                                    reader.readAsDataURL(this.files[0]);
                                                                }
                                                            });
                                                            
                                                            $('#editImageUpload5').change(function () {
                                                                if (this.files && this.files[0]) {
                                                                    var reader = new FileReader();
                                                                    reader.onload = function (e) {
                                                                        $('#currentImage5').attr('src', e.target.result);
                                                                        $('#currentImage5').show();
                                                                    }
                                                                    reader.readAsDataURL(this.files[0]);
                                                                }
                                                            });
                                                        });

        </script>
    </body>
</html>