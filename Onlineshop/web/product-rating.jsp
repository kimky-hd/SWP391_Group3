<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Connection", "close");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Đánh giá sản phẩm - Flower Shop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Free HTML Templates" name="keywords">
    <meta content="Free HTML Templates" name="description">

    <link href="img/favicon.ico" rel="icon">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    
    <style>
        :root {
            --pink-pastel: #F8BBD0;
            --light-pink: #FCE4EC;
            --dark-pink: #D81B60;
            --rose-accent: #F48FB1;
            --text-dark: #5f375f;
            --text-light: #888;
            --bg-light: #FFF;
            --bg-secondary: #F7F7F7;
            --success-color: #4CAF50;
            --warning-color: #FFC107;
            --danger-color: #DC3545;
            --info-color: #17A2B8;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background-color: var(--light-pink);
            color: var(--text-dark);
        }

        .rating-container {
            background: var(--bg-light);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin: 2rem auto;
            max-width: 600px;
        }

        .rating-title {
            color: var(--dark-pink);
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
        }

        .rating-form {
            background: var(--bg-secondary);
            border-radius: 15px;
            padding: 2rem;
            border: 2px solid var(--pink-pastel);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            color: var(--dark-pink);
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
        }

        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 5px;
            margin: 1rem 0;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #ffd700;
        }

        .comment-textarea {
            width: 100%;
            min-height: 120px;
            padding: 1rem;
            border: 2px solid var(--pink-pastel);
            border-radius: 10px;
            font-family: inherit;
            resize: vertical;
            transition: border-color 0.3s ease;
        }

        .comment-textarea:focus {
            outline: none;
            border-color: var(--dark-pink);
        }

        .image-upload {
            border: 2px dashed var(--pink-pastel);
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .image-upload:hover {
            border-color: var(--dark-pink);
            background-color: var(--light-pink);
        }

        .image-upload input {
            display: none;
        }

        .image-upload-icon {
            font-size: 3rem;
            color: var(--rose-accent);
            margin-bottom: 1rem;
        }

        .image-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 1rem;
        }

        .image-preview img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid var(--pink-pastel);
        }

        .btn-submit {
            background: linear-gradient(45deg, var(--dark-pink), var(--rose-accent));
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(216, 27, 96, 0.3);
        }

        /* Review Management Styles */
        .review-management {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            margin-top: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .success-message {
            margin-bottom: 30px;
        }

        .success-message i {
            font-size: 48px;
            color: #28a745;
            margin-bottom: 15px;
        }

        .success-message h3 {
            color: #28a745;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .success-message p {
            color: #6c757d;
            margin-bottom: 0;
        }

        .existing-message {
            margin-bottom: 30px;
        }

        .existing-message i {
            font-size: 48px;
            color: #ffc107;
            margin-bottom: 15px;
        }

        .existing-message h3 {
            color: #856404;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .existing-message p {
            color: #6c757d;
            margin-bottom: 0;
        }

        .management-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .management-buttons button {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 180px;
            justify-content: center;
        }

        .btn-view-current {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }

        .btn-view-current:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3);
        }

        .btn-view-all {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
        }

        .btn-view-all:hover {
            background: linear-gradient(135deg, #1e7e34, #155724);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-back-orders {
            background: linear-gradient(135deg, #6c757d, #545b62);
            color: white;
        }

        .btn-back-orders:hover {
            background: linear-gradient(135deg, #545b62, #3d4142);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-back {
            background: var(--text-light);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }

        .btn-back:hover {
            background: var(--text-dark);
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            padding: 15px 25px;
            margin-bottom: 12px;
            border-radius: 12px;
            color: var(--text-dark);
            background-color: var(--light-pink);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.4s ease-in-out;
            border-left: 6px solid var(--rose-accent);
        }

        .toast.show {
            opacity: 1;
            transform: translateX(0);
        }

        .toast.success {
            background-color: #e6ffe6;
            border-left-color: var(--success-color);
        }

        .toast.error {
            background-color: #ffe6e6;
            border-left-color: var(--danger-color);
        }

        /* Product Item Styles */
        .product-item {
            background: var(--bg-light);
            border: 2px solid var(--pink-pastel);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .product-item:hover {
            border-color: var(--dark-pink);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .product-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--light-pink);
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid var(--pink-pastel);
            margin-right: 1rem;
        }

        .product-info h4 {
            color: var(--dark-pink);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .product-info .price {
            color: var(--text-light);
            font-size: 1.1rem;
            font-weight: 500;
        }

        .product-info .quantity {
            color: var(--text-dark);
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        .rating-form-product {
            background: var(--bg-secondary);
            border-radius: 10px;
            padding: 1.5rem;
            border: 1px solid var(--pink-pastel);
        }

        .star-rating-product {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 5px;
            margin: 1rem 0;
        }

        .star-rating-product input {
            display: none;
        }

        .star-rating-product label {
            font-size: 1.8rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .star-rating-product label:hover,
        .star-rating-product label:hover ~ label,
        .star-rating-product input:checked ~ label {
            color: #ffd700;
        }

        .btn-submit-product {
            background: linear-gradient(45deg, var(--dark-pink), var(--rose-accent));
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }

        .btn-submit-product:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(216, 27, 96, 0.3);
        }

        .btn-submit-product:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .feedback-status {
            text-align: center;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .feedback-status.completed {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .feedback-status.pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        @media (max-width: 768px) {
            .rating-container {
                margin: 1rem;
                padding: 1rem;
            }

            .star-rating label,
            .star-rating-product label {
                font-size: 1.5rem;
            }

            .product-header {
                flex-direction: column;
                text-align: center;
            }

            .product-image {
                margin-right: 0;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Load jQuery before any includes that use it -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    
    <%
        Account account = (Account) session.getAttribute("account");
    %>

    <jsp:include page="header.jsp" />

    <!-- Rating Container -->
    <div class="container-fluid">
        <div class="rating-container">
            <button onclick="goBack()" class="btn-back">
                <i class="fas fa-arrow-left mr-2"></i>Quay lại
            </button>

            <h2 class="rating-title">Đánh giá sản phẩm trong đơn hàng #${param.orderId}</h2>

            <!-- Products container - show directly -->
            <div id="productsContainer">
                <!-- Products will be loaded here dynamically -->
            </div>

            <!-- Review Management Buttons (Hidden initially) -->
            <div id="reviewManagement" class="review-management" style="display: none;">
                <!-- Success Message -->
                <div id="successMessage" class="success-message" style="display: none;">
                    <i class="fas fa-check-circle"></i>
                    <h3>Đánh giá đã được gửi thành công!</h3>
                    <p>Cảm ơn bạn đã chia sẻ trải nghiệm về đơn hàng này.</p>
                </div>

                <!-- Existing Feedback Message -->
                <div id="existingMessage" class="existing-message" style="display: none;">
                    <i class="fas fa-info-circle"></i>
                    <h3>Bạn đã đánh giá đơn hàng này rồi!</h3>
                    <p>Bạn có thể xem lại, chỉnh sửa hoặc xóa đánh giá hiện tại.</p>
                </div>

                <div class="management-buttons">
                    <button class="btn-view-current" onclick="viewCurrentReview()">
                        <i class="fas fa-eye"></i>
                        <span id="btnViewText">Xem đánh giá vừa tạo</span>
                    </button>

                    <button class="btn-view-all" onclick="viewAllReviews()">
                        <i class="fas fa-list"></i>
                        Xem tất cả đánh giá của tôi
                    </button>

                    <button class="btn-back-orders" onclick="backToOrders()">
                        <i class="fas fa-list"></i>
                        Xem tất cả đơn hàng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="js/main.js"></script>

    <script>
        // Show toast message
        function showToast(message, type) {
            const container = document.querySelector('.toast-container') || createToastContainer();
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.textContent = message;
            container.appendChild(toast);
            toast.offsetHeight;
            toast.classList.add('show');
            
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 400);
            }, 3000);
        }
        
        // Function to update product rating in ViewListProductController
        function updateProductRatingInList() {
            // Get the product ID from the form
            const productId = $('#productId').val();
            
            if (productId) {
                // Call FeedbackController to get updated stats
                $.ajax({
                    url: 'FeedbackController',
                    type: 'GET',
                    data: {
                        action: 'getFeedbackStats',
                        productId: productId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Update local storage or session storage with new rating data
                            // This will be used by ViewListProductController when displaying products
                            const ratingData = {
                                productId: productId,
                                averageRating: response.stats.average_rating,
                                totalReviews: response.stats.total_reviews,
                                lastUpdated: new Date().getTime()
                            };
                            
                            // Store in session storage for ViewListProductController to use
                            sessionStorage.setItem('updatedRating_' + productId, JSON.stringify(ratingData));
                            
                            console.log('Rating data updated for product ' + productId);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.log('Error updating rating data: ' + error);
                    }
                });
            }
        }

        function createToastContainer() {
            const container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
            return container;
        }

        // Go back to orders page
        function goBack() {
            window.history.back();
        }

        // Handle image preview
        document.getElementById('imageInput').addEventListener('change', function(e) {
            const preview = document.getElementById('imagePreview');
            preview.innerHTML = '';
            
            for (let i = 0; i < e.target.files.length; i++) {
                const file = e.target.files[i];
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    preview.appendChild(img);
                };
                
                reader.readAsDataURL(file);
            }
        });

        // jQuery dependent functions
        $(document).ready(function() {
            // Override alert to prevent popup issues
            window.alert = function(message) {
                console.log('Alert blocked:', message);
            };

            // Load products immediately without loading indicator
            loadOrderProductsDirectly();
        });

        // Load products for the order
        function loadOrderProducts() {
            const orderId = getOrderIdFromUrl();
            console.log('Loading products for order ID:', orderId);

            if (!orderId) {
                console.error('No order ID found');
                showToast('Không tìm thấy mã đơn hàng', 'error');
                $('#loadingIndicator').hide();
                $('#productsContainer').show();
                return;
            }

            console.log('Making AJAX request to FeedbackController...');
            $.ajax({
                url: 'FeedbackController',
                type: 'GET',
                data: {
                    action: 'getOrderProducts',
                    orderId: orderId
                },
                dataType: 'json',
                success: function(response) {
                    console.log('AJAX Success response:', response);
                    if (response.success) {
                        displayProducts(response.products, orderId);
                    } else {
                        console.error('API returned error:', response.message);
                        showToast(response.message || 'Không thể tải danh sách sản phẩm', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', status, error);
                    console.error('Response text:', xhr.responseText);
                    showToast('Không thể kết nối máy chủ', 'error');
                },
                complete: function() {
                    console.log('AJAX request completed');
                    $('#loadingIndicator').hide();
                    $('#productsContainer').show();
                }
            });
        }

        // Display products with rating forms
        function displayProducts(products, orderId) {
            console.log('Displaying products:', products);
            const container = $('#productsContainer');
            container.empty();

            if (!products || products.length === 0) {
                console.log('No products found');
                container.html('<div class="text-center"><p>Không tìm thấy sản phẩm trong đơn hàng này.</p></div>');
                return;
            }

            console.log('Creating product forms for', products.length, 'products');
            products.forEach(function(product, index) {
                console.log('Creating form for product:', product);
                const productHtml = createProductRatingForm(product, orderId, index);
                container.append(productHtml);
            });

            // Check existing feedback for each product
            console.log('Checking existing feedback...');
            checkExistingFeedback(products, orderId);
        }

        // Create HTML for product rating form
        function createProductRatingForm(product, orderId, index) {
            const productId = product.productId || product.productID;
            const productTitle = product.product ? product.product.title : (product.title || 'Sản phẩm');
            const productImage = product.product ? product.product.image : (product.image || 'default.jpg');
            const productPrice = product.price || (product.product ? product.product.price : 0);
            const quantity = product.quantity || 1;

            return `
                <div class="product-item" id="product-${productId}">
                    <div class="product-header">
                        <img src="img/${productImage}" alt="${productTitle}" class="product-image">
                        <div class="product-info">
                            <h4>${productTitle}</h4>
                            <div class="price">Giá: ${formatCurrency(productPrice)}</div>
                            <div class="quantity">Số lượng: ${quantity}</div>
                        </div>
                    </div>

                    <div class="feedback-status pending" id="status-${productId}">
                        <i class="fas fa-clock"></i> Chưa đánh giá
                    </div>

                    <form class="rating-form-product" id="ratingForm-${productId}">
                        <input type="hidden" name="orderId" value="${orderId}">
                        <input type="hidden" name="productId" value="${productId}">

                        <!-- Đánh giá sao -->
                        <div class="form-group">
                            <label>Đánh giá của bạn:</label>
                            <div class="star-rating-product">
                                <input type="radio" id="star5-${productId}" name="rating-${productId}" value="5">
                                <label for="star5-${productId}">★</label>
                                <input type="radio" id="star4-${productId}" name="rating-${productId}" value="4">
                                <label for="star4-${productId}">★</label>
                                <input type="radio" id="star3-${productId}" name="rating-${productId}" value="3">
                                <label for="star3-${productId}">★</label>
                                <input type="radio" id="star2-${productId}" name="rating-${productId}" value="2">
                                <label for="star2-${productId}">★</label>
                                <input type="radio" id="star1-${productId}" name="rating-${productId}" value="1">
                                <label for="star1-${productId}">★</label>
                            </div>
                        </div>

                        <!-- Nội dung đánh giá -->
                        <div class="form-group">
                            <label for="comment-${productId}">Nội dung đánh giá:</label>
                            <textarea id="comment-${productId}" name="comment" class="comment-textarea"
                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." rows="4"></textarea>
                        </div>

                        <!-- Nút gửi -->
                        <button type="submit" class="btn-submit-product" id="submitBtn-${productId}">
                            <i class="fa fa-paper-plane mr-2"></i>Gửi đánh giá sản phẩm này
                        </button>
                    </form>
                </div>
            `;
        }

        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }

        // Check existing feedback for products
        function checkExistingFeedback(products, orderId) {
            products.forEach(function(product) {
                const productId = product.productId || product.productID;

                $.ajax({
                    url: 'FeedbackController',
                    type: 'POST',
                    data: {
                        action: 'checkProductFeedback',
                        productId: productId,
                        orderId: orderId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.hasFeedback) {
                            markProductAsRated(productId, response.feedback);
                        } else {
                            setupProductRatingForm(productId);
                        }
                    },
                    error: function() {
                        // If check fails, still allow rating
                        setupProductRatingForm(productId);
                    }
                });
            });
        }

        // Mark product as already rated
        function markProductAsRated(productId, feedback) {
            const statusDiv = $(`#status-${productId}`);
            const form = $(`#ratingForm-${productId}`);

            statusDiv.removeClass('pending').addClass('completed');
            statusDiv.html('<i class="fas fa-check-circle"></i> Đã đánh giá');

            // Disable form and show existing rating
            form.find('input, textarea, button').prop('disabled', true);
            form.find(`input[name="rating-${productId}"][value="${feedback.rating}"]`).prop('checked', true);
            form.find(`#comment-${productId}`).val(feedback.comment);
            form.find(`#submitBtn-${productId}`).html('<i class="fas fa-eye mr-2"></i>Xem chi tiết sản phẩm').prop('disabled', false);

            // Change button action to view product
            form.find(`#submitBtn-${productId}`).off('click').on('click', function(e) {
                e.preventDefault();
                window.open(`ViewProductDetail?productid=${productId}&highlight=review`, '_blank');
            });
        }

        // Setup rating form for product
        function setupProductRatingForm(productId) {
            const form = $(`#ratingForm-${productId}`);

            form.on('submit', function(e) {
                e.preventDefault();
                submitProductRating(productId);
            });
        }

        // Submit rating for individual product
        function submitProductRating(productId) {
            const form = $(`#ratingForm-${productId}`);
            const rating = form.find(`input[name="rating-${productId}"]:checked`).val();
            const comment = form.find(`#comment-${productId}`).val().trim();
            const orderId = form.find('input[name="orderId"]').val();

            // Validation
            if (!rating) {
                showToast('Vui lòng chọn số sao đánh giá cho sản phẩm này', 'warning');
                return;
            }

            if (!comment) {
                showToast('Vui lòng nhập nội dung đánh giá cho sản phẩm này', 'warning');
                return;
            }

            const submitBtn = $(`#submitBtn-${productId}`);

            // Submit rating
            $.ajax({
                url: 'FeedbackController',
                type: 'POST',
                data: {
                    action: 'submitProductRating',
                    orderId: orderId,
                    productId: productId,
                    rating: rating,
                    comment: comment
                },
                dataType: 'json',
                beforeSend: function() {
                    submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin mr-2"></i>Đang gửi...');
                },
                success: function(response) {
                    if (response.success) {
                        showToast('Đánh giá sản phẩm thành công!', 'success');

                        // Mark as completed
                        const statusDiv = $(`#status-${productId}`);
                        statusDiv.removeClass('pending').addClass('completed');
                        statusDiv.html('<i class="fas fa-check-circle"></i> Đã đánh giá');

                        // Disable form
                        form.find('input, textarea').prop('disabled', true);
                        submitBtn.html('<i class="fas fa-eye mr-2"></i>Xem chi tiết sản phẩm').prop('disabled', false);

                        // Change button to view product
                        submitBtn.off('click').on('click', function(e) {
                            e.preventDefault();
                            window.location.href = `ViewProductDetail?productid=${productId}&highlight=latest`;
                        });

                    } else {
                        showToast(response.message || 'Có lỗi xảy ra khi gửi đánh giá', 'error');
                        submitBtn.prop('disabled', false).html('<i class="fa fa-paper-plane mr-2"></i>Gửi đánh giá sản phẩm này');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', status, error);
                    showToast('Không thể kết nối máy chủ', 'error');
                    submitBtn.prop('disabled', false).html('<i class="fa fa-paper-plane mr-2"></i>Gửi đánh giá sản phẩm này');
                }
            });
        }
    </script>

    <!-- Subiz Chat -->
    <%
        if (account == null || account.getRole() == 0) {
    %>
    <script>
        window._sbzaccid = 'acsjohqbflsylnzfqogm'
        window.subiz = function () {
            window.subiz.q.push(arguments)
        }
        window.subiz.q = []
        window.subiz('setAccount', window._sbzaccid)

        // Show review management buttons after successful submission or existing feedback
        function showReviewManagementButtons(type) {
            // Show the management section
            document.getElementById('reviewManagement').style.display = 'block';

            if (type === 'success') {
                // Show success message
                document.getElementById('successMessage').style.display = 'block';
                document.getElementById('existingMessage').style.display = 'none';
                document.getElementById('btnViewText').textContent = 'Xem đánh giá vừa tạo';
            } else if (type === 'existing') {
                // Show existing feedback message
                document.getElementById('successMessage').style.display = 'none';
                document.getElementById('existingMessage').style.display = 'block';
                document.getElementById('btnViewText').textContent = 'Xem đánh giá hiện tại';
            }

            // Smooth scroll to the management section
            setTimeout(() => {
                document.getElementById('reviewManagement').scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }, 500);
        }

        // View current review (the one just submitted)
        function viewCurrentReview() {
            const orderId = getOrderIdFromUrl();
            if (orderId) {
                window.open('view-feedback.jsp?orderId=' + orderId + '&highlight=latest', '_blank');
            } else {
                window.open('view-feedback.jsp?highlight=latest', '_blank');
            }
        }

        // View all reviews
        function viewAllReviews() {
            window.open('view-feedback.jsp', '_blank');
        }

        // Back to orders page
        function backToOrders() {
            window.location.href = 'orders.jsp';
        }

        // Get order ID from URL parameters
        function getOrderIdFromUrl() {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get('orderId');
        }
    </script>
    <script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>
    <%
        }
    %>
</body>
</html>