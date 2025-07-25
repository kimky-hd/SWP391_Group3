<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<%@ page import="DAO.OrderDAO" %>
<%@ page import="DAO.OrderDetailDAO" %>
<%@ page import="DAO.FeedbackDAO" %>
<%@ page import="Model.Order" %>
<%@ page import="Model.OrderDetail" %>
<%@ page import="java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Đánh giá sản phẩm - Flower Shop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="img/favicon.ico" rel="icon">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
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
            max-width: 800px;
        }

        .rating-title {
            color: var(--dark-pink);
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
        }

        .product-item {
            background: var(--bg-light);
            border: 2px solid var(--pink-pastel);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
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
            font-size: 1.8rem;
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
        }

        .btn-submit-product {
            background: linear-gradient(45deg, var(--dark-pink), var(--rose-accent));
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: 1rem;
        }

        .btn-back {
            background: var(--text-light);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 20px;
            font-weight: 500;
            cursor: pointer;
            margin-bottom: 1rem;
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

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            color: var(--dark-pink);
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: block;
        }

        .comment-info {
            margin-top: 0.5rem;
            font-size: 0.85rem;
        }

        .text-muted {
            color: var(--text-light);
        }
    </style>
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <%
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect("orders.jsp");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdStr);
        
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        
        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getAccountId() != account.getAccountID()) {
            response.sendRedirect("orders.jsp");
            return;
        }
        
        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
    %>

    <jsp:include page="header.jsp" />

    <div class="container-fluid">
        <div class="rating-container">
            <button onclick="goBack()" class="btn-back">
                <i class="fas fa-arrow-left mr-2"></i>Quay lại
            </button>
            
            <h2 class="rating-title">Đánh giá sản phẩm trong đơn hàng #<%= orderId %></h2>
            
            <%
                if (orderDetails == null || orderDetails.isEmpty()) {
            %>
                <div class="text-center">
                    <p>Không tìm thấy sản phẩm trong đơn hàng này.</p>
                </div>
            <%
                } else {
                    for (OrderDetail detail : orderDetails) {
                        boolean hasFeedback = feedbackDAO.hasFeedback(account.getAccountID(), detail.getProductId());
            %>
                <div class="product-item">
                    <div class="product-header">
                        <img src="img/<%= detail.getProduct().getImage() %>" alt="<%= detail.getProduct().getTitle() %>" class="product-image">
                        <div class="product-info">
                            <h4><%= detail.getProduct().getTitle() %></h4>
                            <div class="price">Giá: <%= String.format("%,.0f", detail.getPrice()) %> VNĐ</div>
                            <div class="quantity">Số lượng: <%= detail.getQuantity() %></div>
                        </div>
                    </div>
                    
                    <% if (hasFeedback) { %>
                        <div class="feedback-status completed">
                            <i class="fas fa-check-circle"></i> Đã đánh giá sản phẩm này
                        </div>
                        <div class="text-center">
                            <a href="ViewProductDetail?productid=<%= detail.getProductId() %>" class="btn-submit-product" style="text-decoration: none; display: inline-block;">
                                <i class="fas fa-eye mr-2"></i>Xem chi tiết sản phẩm
                            </a>
                        </div>
                    <% } else { %>
                        <div class="feedback-status pending">
                            <i class="fas fa-clock"></i> Chưa đánh giá
                        </div>
                        
                        <form class="rating-form-product" action="FeedbackController" method="post" onsubmit="return submitWithSuccess(this)">
                            <input type="hidden" name="action" value="submitProductRating">
                            <input type="hidden" name="orderId" value="<%= orderId %>">
                            <input type="hidden" name="productId" value="<%= detail.getProductId() %>">

                            <div class="form-group">
                                <label>Đánh giá của bạn:</label>
                                <div class="star-rating">
                                    <input type="radio" id="star5-<%= detail.getProductId() %>" name="rating" value="5" required>
                                    <label for="star5-<%= detail.getProductId() %>">★</label>
                                    <input type="radio" id="star4-<%= detail.getProductId() %>" name="rating" value="4">
                                    <label for="star4-<%= detail.getProductId() %>">★</label>
                                    <input type="radio" id="star3-<%= detail.getProductId() %>" name="rating" value="3">
                                    <label for="star3-<%= detail.getProductId() %>">★</label>
                                    <input type="radio" id="star2-<%= detail.getProductId() %>" name="rating" value="2">
                                    <label for="star2-<%= detail.getProductId() %>">★</label>
                                    <input type="radio" id="star1-<%= detail.getProductId() %>" name="rating" value="1">
                                    <label for="star1-<%= detail.getProductId() %>">★</label>
                                </div>
                                <div class="error-message" id="rating-error-<%= detail.getProductId() %>" style="color: red; display: none;">
                                    Vui lòng chọn số sao đánh giá
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="comment-<%= detail.getProductId() %>">Nội dung đánh giá:</label>
                                <textarea id="comment-<%= detail.getProductId() %>" name="comment" class="comment-textarea"
                                          placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." rows="4" required
                                          minlength="10" maxlength="500"></textarea>
                                <div class="comment-info">
                                    <small class="text-muted">Tối thiểu 10 ký tự, tối đa 500 ký tự</small>
                                </div>
                                <div class="error-message" id="comment-error-<%= detail.getProductId() %>" style="color: red; display: none;">
                                    Vui lòng nhập nội dung đánh giá (tối thiểu 10 ký tự)
                                </div>
                            </div>

                            <button type="submit" class="btn-submit-product" id="submit-btn-<%= detail.getProductId() %>">
                                <i class="fa fa-paper-plane mr-2"></i>Gửi đánh giá sản phẩm này
                            </button>
                        </form>
                    <% } %>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        // Simple functions without jQuery conflicts
        function goBack() {
            window.history.back();
        }

        function submitWithSuccess(form) {
            const productId = form.querySelector('input[name="productId"]').value;
            const rating = form.querySelector('input[name="rating"]:checked');
            const comment = form.querySelector('textarea[name="comment"]').value.trim();

            // Clear previous errors
            const ratingError = document.getElementById('rating-error-' + productId);
            const commentError = document.getElementById('comment-error-' + productId);

            if (ratingError) ratingError.style.display = 'none';
            if (commentError) commentError.style.display = 'none';

            let isValid = true;

            // Validate rating
            if (!rating) {
                if (ratingError) ratingError.style.display = 'block';
                isValid = false;
            }

            // Validate comment
            if (!comment || comment.length < 10) {
                if (commentError) {
                    commentError.textContent = comment.length === 0 ?
                        'Vui lòng nhập nội dung đánh giá (tối thiểu 10 ký tự)' :
                        `Nội dung đánh giá quá ngắn (${comment.length}/10 ký tự)`;
                    commentError.style.display = 'block';
                }
                isValid = false;
            } else if (comment.length > 500) {
                if (commentError) {
                    commentError.textContent = `Nội dung đánh giá quá dài (${comment.length}/500 ký tự)`;
                    commentError.style.display = 'block';
                }
                isValid = false;
            }

            if (isValid) {
                // Prevent default form submission
                event.preventDefault();

                // Show loading state
                const submitBtn = document.getElementById('submit-btn-' + productId);
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i>Đang gửi...';
                }

                // Submit via AJAX to avoid redirect
                const formData = new FormData(form);

                fetch('FeedbackController', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text())
                .then(data => {
                    // Reload page immediately to show updated state
                    window.location.reload();
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại.');

                    // Reset button
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fa fa-paper-plane mr-2"></i>Gửi đánh giá sản phẩm này';
                    }
                });

                return false; // Prevent form submission
            }

            return false;
        }



        // Check for error parameter in URL
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('error') === '1') {
                alert('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại.');
            }
        });
    </script>
</body>
</html>
