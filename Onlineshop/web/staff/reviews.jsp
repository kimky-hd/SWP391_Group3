<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Đánh giá</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Staff Reviews CSS -->
        <link href="${pageContext.request.contextPath}/css/staff-reviews.css" rel="stylesheet">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Modal for showing full review content -->
        <div id="reviewModal" class="modal fade" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel">
                            <i class="fas fa-comment-dots text-primary me-2"></i>
                            Nội dung đánh giá đầy đủ
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="reviewModalContent">
                            <!-- Content will be loaded here -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>
                            Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inline JavaScript for immediate loading -->
        <script>
            // Date validation functions (global scope for inline onclick)
            function validateDateRange() {
                console.log('🔍 validateDateRange called');
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;

                console.log('🔍 fromDate:', fromDate, 'toDate:', toDate);

                // If both dates are empty, validation passes
                if (!fromDate && !toDate) {
                    console.log('✅ Both dates empty, validation passes');
                    return true;
                }

                // If only one date is filled, validation passes
                if (!fromDate || !toDate) {
                    console.log('✅ Only one date filled, validation passes');
                    return true;
                }

                // Compare dates
                const fromDateObj = new Date(fromDate);
                const toDateObj = new Date(toDate);

                console.log('🔍 Comparing dates:', fromDateObj, '>=', toDateObj, '?', fromDateObj >= toDateObj);

                if (fromDateObj >= toDateObj) {
                    console.log('❌ Date validation failed');
                    showDateValidationAlert('Ngày bắt đầu phải nhỏ hơn ngày kết thúc.');
                    return false;
                }

                // Hide alert if validation passes
                console.log('✅ Date validation passed');
                hideDateValidationAlert();
                return true;
            }

            function showDateValidationAlert(message) {
                console.log('🚨 showDateValidationAlert called with message:', message);
                const alert = document.getElementById('dateValidationAlert');
                const messageSpan = document.getElementById('dateValidationMessage');

                console.log('🚨 Alert element:', alert);
                console.log('🚨 Message span:', messageSpan);

                if (!alert || !messageSpan) {
                    console.log('❌ Alert elements not found!');
                    return;
                }

                messageSpan.textContent = message;
                alert.style.display = 'block';
                alert.classList.add('show');

                console.log('🚨 Alert should be visible now');

                // Auto hide after 5 seconds
                setTimeout(function() {
                    hideDateValidationAlert();
                }, 5000);

                console.log('⚠️ Date validation error:', message);
            }

            function hideDateValidationAlert() {
                console.log('🔇 hideDateValidationAlert called');
                const alert = document.getElementById('dateValidationAlert');
                if (alert) {
                    alert.classList.remove('show');
                    setTimeout(function() {
                        alert.style.display = 'none';
                        console.log('🔇 Alert hidden');
                    }, 150);
                }
            }

            // Search function with date validation
            function performSearchWithDateValidation() {
                console.log('Search button clicked');

                // Validate date range first
                if (!validateDateRange()) {
                    console.log('❌ Date validation failed, stopping search');
                    return;
                }

                const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
                const ratingFilter = document.getElementById('ratingFilter').value;
                const replyFilter = document.getElementById('replyFilter').value;
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;

                console.log('Search term:', searchTerm);
                console.log('Rating filter:', ratingFilter);
                console.log('Reply filter:', replyFilter);
                console.log('🗓️ From date:', fromDate);
                console.log('🗓️ To date:', toDate);
                console.log('🗓️ Has date filter?', !!(fromDate || toDate));

                const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                console.log('Found rows:', rows.length);

                let visibleCount = 0;
                rows.forEach((row, index) => {
                    let shouldShow = true;

                    // Text search filter
                    if (searchTerm && shouldShow) {
                        const customerName = row.cells[1].textContent.toLowerCase();
                        const productName = row.cells[2].textContent.toLowerCase();
                        const reviewContent = row.cells[4].textContent.toLowerCase();

                        const matches = customerName.includes(searchTerm) ||
                                      productName.includes(searchTerm) ||
                                      reviewContent.includes(searchTerm);

                        if (!matches) {
                            shouldShow = false;
                            console.log('Row ' + index + ': Text search failed');
                        }
                    }

                    // Rating filter
                    if (ratingFilter && shouldShow) {
                        const ratingCell = row.cells[3];
                        const ratingBadge = ratingCell.querySelector('.rating-badge');

                        if (ratingBadge) {
                            const badgeText = ratingBadge.textContent.trim();
                            const actualRating = parseInt(badgeText.split('/')[0]);
                            const filterRating = parseInt(ratingFilter);

                            if (actualRating !== filterRating) {
                                shouldShow = false;
                                console.log('Row ' + index + ': Rating filter failed - actual=' + actualRating + ', filter=' + filterRating);
                            }
                        } else {
                            shouldShow = false;
                            console.log('Row ' + index + ': No rating badge');
                        }
                    }

                    // Reply status filter
                    if (replyFilter && shouldShow) {
                        const replyCell = row.cells[6];
                        const hasReplyBadge = replyCell.querySelector('.badge.bg-success');
                        const noReplyBadge = replyCell.querySelector('.badge.bg-warning');

                        console.log('Row ' + index + ' reply cell HTML:', replyCell.innerHTML);
                        console.log('Row ' + index + ' has reply badge:', !!hasReplyBadge);
                        console.log('Row ' + index + ' has no-reply badge:', !!noReplyBadge);

                        if (replyFilter === 'replied' && !hasReplyBadge) {
                            shouldShow = false;
                            console.log('Row ' + index + ': Reply filter failed - expected replied but found no reply badge');
                        }
                        if (replyFilter === 'not-replied' && !noReplyBadge) {
                            shouldShow = false;
                            console.log('Row ' + index + ': Reply filter failed - expected not-replied but found reply badge');
                        }
                    }

                    // Date range filter
                    if ((fromDate || toDate) && shouldShow) {
                        const dateText = row.cells[5].textContent.trim();
                        console.log('Row ' + index + ' date text:', dateText);

                        const dateParts = dateText.split(' ')[0].split('-');
                        console.log('Row ' + index + ' date parts:', dateParts);

                        if (dateParts.length === 3) {
                            const reviewDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);
                            console.log('Row ' + index + ' parsed review date:', reviewDate);

                            if (fromDate) {
                                const fromDateObj = new Date(fromDate);
                                console.log('Row ' + index + ' comparing with fromDate:', fromDateObj, 'reviewDate < fromDate?', reviewDate < fromDateObj);
                                if (reviewDate < fromDateObj) {
                                    shouldShow = false;
                                    console.log('Row ' + index + ' hidden by fromDate filter');
                                }
                            }

                            if (toDate && shouldShow) {
                                const toDateObj = new Date(toDate);
                                toDateObj.setHours(23, 59, 59);
                                console.log('Row ' + index + ' comparing with toDate:', toDateObj, 'reviewDate > toDate?', reviewDate > toDateObj);
                                if (reviewDate > toDateObj) {
                                    shouldShow = false;
                                    console.log('Row ' + index + ' hidden by toDate filter');
                                }
                            }
                        } else {
                            console.log('Row ' + index + ' date parsing failed');
                        }
                    }

                    row.style.display = shouldShow ? '' : 'none';
                    if (shouldShow) visibleCount++;
                });

                console.log('Visible rows after all filters:', visibleCount);
                document.getElementById('table-count').textContent = visibleCount + ' đánh giá';

                // Update replied count from visible rows
                const visibleRows = Array.from(rows).filter(row => row.style.display !== 'none');
                const repliedCount = visibleRows.filter(row => {
                    const replyCell = row.cells[6];
                    return replyCell.querySelector('.badge.bg-success');
                }).length;
                document.getElementById('replied-reviews').textContent = repliedCount;
                console.log('Replied reviews count updated:', repliedCount);
            }

            // Function to show full review content
            function showFullReview(reviewId) {
                console.log('Showing full review for ID:', reviewId);

                // Find the table row with this review ID
                const tableRows = document.querySelectorAll('tbody tr');
                let targetRow = null;

                tableRows.forEach(row => {
                    const idCell = row.querySelector('td:first-child');
                    if (idCell && idCell.textContent.includes('#' + reviewId)) {
                        targetRow = row;
                    }
                });

                if (!targetRow) {
                    alert('Không tìm thấy đánh giá #' + reviewId);
                    return;
                }

                // Get data from table cells
                const cells = targetRow.querySelectorAll('td');
                console.log('Found', cells.length, 'cells in target row');

                // Debug: log each cell content
                cells.forEach((cell, index) => {
                    console.log('Cell', index, ':', cell.textContent.trim());
                });

                const reviewID = cells[0] ? cells[0].textContent.trim() : 'N/A';
                const customerInfo = cells[1] ? cells[1].textContent.trim() : 'N/A';
                const productInfo = cells[2] ? cells[2].textContent.trim() : 'N/A';
                const rating = cells[3] ? cells[3].textContent.trim() : 'N/A';
                // Get original comment from data attribute (for staff to see full content even if hidden)
                const reviewContentDiv = cells[4] ? cells[4].querySelector('.review-content') : null;
                const fullComment = reviewContentDiv ? reviewContentDiv.getAttribute('data-full-comment') || 'Không có nội dung' : 'Không có nội dung';

                // Get staff reply from reply column (column 5)
                const replyCell = cells[5];
                const hasReply = replyCell && replyCell.querySelector('.badge.bg-success');
                const staffReply = targetRow.getAttribute('data-staff-reply') || null;

                // Debug logging
                console.log('DEBUG - Review ID:', reviewID);
                console.log('DEBUG - Has reply badge:', hasReply);
                console.log('DEBUG - Staff reply data:', staffReply);
                console.log('DEBUG - Full comment:', fullComment);
                const reviewDate = cells[5] ? cells[5].textContent.trim() : 'N/A';

                console.log('Extracted data:', {
                    reviewID, customerInfo, productInfo, rating, fullComment, reviewDate
                });

                // Create modal HTML with uniform light background
                const modalHTML =
                    '<div style="position: fixed !important; top: 50% !important; left: 50% !important; ' +
                    'transform: translate(-50%, -50%) !important; background: #f8f9fa !important; ' +
                    'padding: 20px !important; border: 3px solid #007bff !important; ' +
                    'border-radius: 8px !important; box-shadow: 0 8px 16px rgba(0,0,0,0.3) !important; ' +
                    'z-index: 99999 !important; max-width: 600px !important; width: 90% !important;' +
                    'max-height: 80vh !important; overflow-y: auto !important; ' +
                    'font-family: Arial, sans-serif !important; font-size: 14px !important;' +
                    'color: #333 !important; line-height: 1.5 !important;" id="reviewModal">' +

                    '<div style="position: fixed !important; top: 0 !important; left: 0 !important; ' +
                    'width: 100% !important; height: 100% !important; ' +
                    'background: rgba(255,255,255,0.8) !important; z-index: -1 !important;" ' +
                    'onclick="closeModal()"></div>' +

                    '<h5 style="color: #007bff !important; margin-bottom: 15px !important; ' +
                    'font-size: 18px !important; font-weight: bold !important;">' +
                    'Chi tiết đánh giá ' + reviewID + '</h5>' +

                    '<div style="margin-bottom: 15px !important; background: #f8f9fa !important; padding: 10px !important; border-radius: 4px !important;">' +
                    '<strong style="color: #333 !important;">Khách hàng:</strong><br>' +
                    '<span style="color: #333 !important;">' + customerInfo + '</span>' +
                    '</div>' +

                    '<div style="margin-bottom: 15px !important; background: #f8f9fa !important; padding: 10px !important; border-radius: 4px !important;">' +
                    '<strong style="color: #333 !important;">Sản phẩm:</strong><br>' +
                    '<span style="color: #333 !important;">' + productInfo + '</span>' +
                    '</div>' +

                    '<div style="margin-bottom: 15px !important; background: #f8f9fa !important; padding: 10px !important; border-radius: 4px !important;">' +
                    '<strong style="color: #333 !important;">Đánh giá:</strong> ' +
                    '<span style="color: #333 !important;">' + rating + '</span>' +
                    '</div>' +

                    '<div style="margin-bottom: 15px !important; background: #f8f9fa !important; padding: 10px !important; border-radius: 4px !important;">' +
                    '<strong style="color: #333 !important;">Nội dung đánh giá đầy đủ:</strong>' +
                    '<div style="background: #ffffff !important; padding: 15px !important; ' +
                    'border-radius: 4px !important; margin: 10px 0 !important;' +
                    'line-height: 1.6 !important; white-space: pre-wrap !important;' +
                    'border: 1px solid #dee2e6 !important; color: #333 !important;">' +
                    fullComment +
                    '</div>' +
                    '</div>' +

                    '<div style="margin-bottom: 15px !important; background: #f8f9fa !important; padding: 10px !important; border-radius: 4px !important;">' +
                    '<strong style="color: #333 !important;">Ngày tạo:</strong> ' +
                    '<span style="color: #333 !important;">' + reviewDate + '</span>' +
                    '</div>' +

                    // Add staff reply section if exists
                    (staffReply && staffReply.trim() !== '' ?
                        '<div style="margin-bottom: 15px !important; background: #e8f5e8 !important; padding: 15px !important; border-radius: 4px !important; border-left: 4px solid #28a745 !important;">' +
                        '<strong style="color: #28a745 !important; font-size: 14px !important;"><i class="fas fa-store"></i> Phản hồi từ Shop:</strong>' +
                        '<div style="background: #ffffff !important; padding: 12px !important; ' +
                        'border-radius: 4px !important; margin: 8px 0 !important;' +
                        'line-height: 1.6 !important; color: #333 !important; font-size: 14px !important; ' +
                        'white-space: pre-wrap !important;">' +
                        staffReply.replace(/\\n/g, '\n') +
                        '</div>' +
                        '</div>' :
                        '<div style="margin-bottom: 15px !important; background: #fff3cd !important; padding: 10px !important; border-radius: 4px !important; border-left: 4px solid #ffc107 !important;">' +
                        '<span style="color: #856404 !important; font-style: italic !important;"><i class="fas fa-clock"></i> Chưa có phản hồi từ shop</span>' +
                        '</div>') +

                    '<button onclick="closeModal()" ' +
                    'style="background: #dc3545 !important; color: white !important; ' +
                    'border: none !important; padding: 8px 16px !important;' +
                    'border-radius: 4px !important; cursor: pointer !important; ' +
                    'float: right !important; font-size: 14px !important;">' +
                    'Đóng' +
                    '</button>' +
                    '<div style="clear: both !important;"></div>' +
                    '</div>';

                // Add modal to page
                document.body.insertAdjacentHTML('beforeend', modalHTML);
            }

            // Function to close modal
            function closeModal() {
                const modal = document.getElementById('reviewModal');
                if (modal) {
                    modal.remove();
                }
            }

            // Function to hide review
            function hideReview(reviewId) {
                if (confirm('Bạn có chắc chắn muốn ẩn đánh giá này?')) {
                    fetch('${pageContext.request.contextPath}/staff/reviews/hide', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'reviewId=' + reviewId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đánh giá đã được ẩn thành công!');
                            location.reload();
                        } else {
                            alert('Có lỗi xảy ra: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi ẩn đánh giá!');
                    });
                }
            }

            // Function to show review
            function showReview(reviewId) {
                if (confirm('Bạn có chắc chắn muốn hiện đánh giá này?')) {
                    fetch('${pageContext.request.contextPath}/staff/reviews/show', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'reviewId=' + reviewId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Đánh giá đã được hiện thành công!');
                            location.reload();
                        } else {
                            alert('Có lỗi xảy ra: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi hiện đánh giá!');
                    });
                }
            }

            // Global variable to store current review ID
            window.currentReviewId = null;

            // Function to reply to review
            function replyReview(reviewId) {
                // Store review ID globally
                window.currentReviewId = reviewId;
                // Create reply input modal
                const replyModal =
                    '<div style="position: fixed !important; top: 50% !important; left: 50% !important; ' +
                    'transform: translate(-50%, -50%) !important; background: #ffffff !important; ' +
                    'padding: 25px !important; border: 3px solid #28a745 !important; ' +
                    'border-radius: 12px !important; box-shadow: 0 10px 25px rgba(0,0,0,0.4) !important; ' +
                    'z-index: 999999 !important; max-width: 600px !important; width: 95% !important;' +
                    'font-family: Arial, sans-serif !important;" id="replyModal">' +

                    '<div style="position: absolute !important; top: 0 !important; left: 0 !important; ' +
                    'width: 100% !important; height: 100% !important; ' +
                    'background: rgba(255,255,255,0.8) !important; z-index: -1 !important; ' +
                    'border-radius: 12px !important;" ' +
                    'onclick="closeReplyModal()"></div>' +

                    '<h5 style="color: #28a745 !important; margin: 0 0 20px 0 !important; ' +
                    'font-size: 18px !important; font-weight: bold !important; text-align: center !important;">' +
                    '💬 Trả lời đánh giá #' + reviewId + '</h5>' +

                    '<div style="margin-bottom: 15px !important;">' +
                    '<label style="display: block !important; margin-bottom: 5px !important; font-weight: bold !important;">Nội dung trả lời:</label>' +
                    '<textarea id="replyTextArea" placeholder="Nhập nội dung trả lời cho khách hàng..." ' +
                    'style="width: 100% !important; height: 120px !important; padding: 10px !important; ' +
                    'border: 2px solid #dee2e6 !important; border-radius: 6px !important; ' +
                    'font-size: 14px !important; resize: vertical !important;"></textarea>' +
                    '</div>' +

                    '<div style="text-align: right !important;">' +
                    '<button onclick="closeReplyModal()" ' +
                    'style="background: #6c757d !important; color: white !important; ' +
                    'border: none !important; padding: 8px 16px !important; margin-right: 10px !important; ' +
                    'border-radius: 4px !important; cursor: pointer !important;">Hủy</button>' +

                    '<button onclick="generateReply(' + reviewId + ')" ' +
                    'style="background: #28a745 !important; color: white !important; ' +
                    'border: none !important; padding: 8px 16px !important; ' +
                    'border-radius: 4px !important; cursor: pointer !important;">Tạo nội dung</button>' +
                    '</div>' +
                    '</div>';

                document.body.insertAdjacentHTML('beforeend', replyModal);
                document.getElementById('replyTextArea').focus();
            }

            // Function to generate formatted reply
            function generateReply(reviewId) {
                const replyText = document.getElementById('replyTextArea').value.trim();

                if (!replyText) {
                    alert('Vui lòng nhập nội dung trả lời!');
                    return;
                }

                fetch('${pageContext.request.contextPath}/staff/reviews/reply', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'reviewId=' + reviewId + '&replyText=' + encodeURIComponent(replyText)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        closeReplyModal();
                        showFormattedReply(data.formattedReply);
                    } else {
                        alert('Có lỗi xảy ra: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi tạo nội dung trả lời!');
                });
            }

            // Function to show formatted reply for copying
            function showFormattedReply(formattedReply) {
                const resultModal =
                    '<div style="position: fixed !important; top: 50% !important; left: 50% !important; ' +
                    'transform: translate(-50%, -50%) !important; background: #ffffff !important; ' +
                    'padding: 25px !important; border: 3px solid #007bff !important; ' +
                    'border-radius: 12px !important; box-shadow: 0 10px 25px rgba(0,0,0,0.4) !important; ' +
                    'z-index: 999999 !important; max-width: 700px !important; width: 95% !important;' +
                    'font-family: Arial, sans-serif !important;" id="resultModal">' +

                    '<div style="position: absolute !important; top: 0 !important; left: 0 !important; ' +
                    'width: 100% !important; height: 100% !important; ' +
                    'background: rgba(255,255,255,0.8) !important; z-index: -1 !important; ' +
                    'border-radius: 12px !important;" ' +
                    'onclick="closeResultModal()"></div>' +

                    '<h5 style="color: #007bff !important; margin: 0 0 20px 0 !important; ' +
                    'font-size: 18px !important; font-weight: bold !important; text-align: center !important;">' +
                    '📋 Nội dung trả lời đã tạo</h5>' +

                    '<div style="margin-bottom: 15px !important;">' +
                    '<p style="margin-bottom: 10px !important; color: #666 !important;">Sao chép nội dung bên dưới để gửi cho khách hàng:</p>' +
                    '<textarea id="formattedReplyText" readonly ' +
                    'style="width: 100% !important; height: 200px !important; padding: 15px !important; ' +
                    'border: 2px solid #007bff !important; border-radius: 6px !important; ' +
                    'font-size: 14px !important; line-height: 1.6 !important; ' +
                    'background: #f8f9fa !important;">' + formattedReply + '</textarea>' +
                    '</div>' +

                    '<div style="text-align: right !important;">' +
                    '<button onclick="copyReplyText()" ' +
                    'style="background: #f8f9fa !important; color: #333 !important; ' +
                    'border: 1px solid #dee2e6 !important; padding: 8px 16px !important; margin-right: 10px !important; ' +
                    'border-radius: 4px !important; cursor: pointer !important; transition: all 0.2s ease !important;"' +
                    'onmouseover="this.style.background=\'#e9ecef\'" onmouseout="this.style.background=\'#f8f9fa\'">Sao chép</button>' +

                    '<button onclick="sendReplyToCustomer()" ' +
                    'style="background: #f8f9fa !important; color: #333 !important; ' +
                    'border: 1px solid #dee2e6 !important; padding: 8px 16px !important; margin-right: 10px !important; ' +
                    'border-radius: 4px !important; cursor: pointer !important; transition: all 0.2s ease !important;"' +
                    'onmouseover="this.style.background=\'#e9ecef\'" onmouseout="this.style.background=\'#f8f9fa\'">Gửi</button>' +

                    '<button onclick="closeResultModal()" ' +
                    'style="background: #f8f9fa !important; color: #333 !important; ' +
                    'border: 1px solid #dee2e6 !important; padding: 8px 16px !important; ' +
                    'border-radius: 4px !important; cursor: pointer !important; transition: all 0.2s ease !important;"' +
                    'onmouseover="this.style.background=\'#e9ecef\'" onmouseout="this.style.background=\'#f8f9fa\'">Đóng</button>' +
                    '</div>' +
                    '</div>';

                document.body.insertAdjacentHTML('beforeend', resultModal);
                document.getElementById('formattedReplyText').select();
            }

            // Function to copy reply text
            function copyReplyText() {
                const textArea = document.getElementById('formattedReplyText');
                textArea.select();
                document.execCommand('copy');
                alert('Đã sao chép nội dung trả lời!');
            }

            // Function to send reply to customer
            function sendReplyToCustomer() {
                const replyText = document.getElementById('formattedReplyText').value;

                if (confirm('Bạn có chắc chắn muốn gửi nội dung trả lời này cho khách hàng?')) {
                    // Get review ID from global variable or extract from modal
                    const reviewId = window.currentReviewId;

                    if (!reviewId) {
                        alert('Không tìm thấy ID đánh giá!');
                        return;
                    }

                    // Extract original reply text (remove formatting)
                    const lines = replyText.split('\n');
                    let originalReply = '';
                    let capturing = false;

                    for (let line of lines) {
                        if (line.trim() === 'Cảm ơn quý khách đã dành thời gian đánh giá sản phẩm của chúng tôi.') {
                            capturing = true;
                            continue;
                        }
                        if (capturing && line.trim() === 'Trân trọng,') {
                            break;
                        }
                        if (capturing && line.trim() !== '') {
                            originalReply += line + '\n';
                        }
                    }

                    // Send to backend
                    fetch('${pageContext.request.contextPath}/staff/reviews/reply', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'reviewId=' + reviewId + '&replyText=' + encodeURIComponent(originalReply.trim()) + '&action=send'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Nội dung trả lời đã được gửi và lưu thành công!\n\nKhách hàng sẽ thấy phần trả lời khi xem chi tiết sản phẩm.');
                            closeResultModal();
                            location.reload(); // Reload to see updated status
                        } else {
                            alert('Có lỗi xảy ra: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi gửi trả lời!');
                    });
                }
            }

            // Function to close reply modal
            function closeReplyModal() {
                const modal = document.getElementById('replyModal');
                if (modal) {
                    modal.remove();
                }
            }

            // Function to close result modal
            function closeResultModal() {
                const modal = document.getElementById('resultModal');
                if (modal) {
                    modal.remove();
                }
            }

            console.log('Review management functions loaded - v5.0 - Hide/Show/Reply');
        </script>
    </head>
    <body>
        <!-- Include Top Bar và Sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="container-fluid">
                <!-- Header Section -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="h3 mb-0">
                                    <i class="fas fa-star me-2"></i>Quản Lý Đánh Giá
                                </h1>
                                <p class="text-muted mb-0">Quản lý đánh giá sản phẩm từ khách hàng</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="bg-primary bg-gradient rounded-3 p-3">
                                            <i class="fas fa-star text-white fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold fs-4" id="total-reviews">${totalReviews != null ? totalReviews : 0}</div>
                                        <div class="text-muted small">Tổng đánh giá</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="bg-warning bg-gradient rounded-3 p-3">
                                            <i class="fas fa-star-half-alt text-white fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold fs-4" id="avg-rating">${avgRating != null ? avgRating : 0.0}</div>
                                        <div class="text-muted small">Điểm trung bình</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="bg-success bg-gradient rounded-3 p-3">
                                            <i class="fas fa-reply text-white fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold fs-4" id="replied-reviews">0</div>
                                        <div class="text-muted small">Đã phản hồi</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="card border-0 shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="bg-info bg-gradient rounded-3 p-3">
                                            <i class="fas fa-eye text-white fa-lg"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <div class="fw-bold fs-4" id="visible-reviews">${visibleReviews != null ? visibleReviews : 0}</div>
                                        <div class="text-muted small">Kết quả hiển thị</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Date Validation Alert -->
                <div id="dateValidationAlert" class="alert alert-danger alert-dismissible fade" role="alert" style="display: none;">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Lỗi ngày tháng!</strong> <span id="dateValidationMessage">Ngày bắt đầu phải nhỏ hơn ngày kết thúc.</span>
                    <button type="button" class="btn-close" onclick="hideDateValidationAlert()"></button>
                </div>

                <!-- Search and Filter Section -->
                <div class="card mb-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-search me-2"></i>Tìm kiếm & Lọc
                            </h5>
                            <button class="btn btn-outline-secondary btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#filterCollapse">
                                <i class="fas fa-filter me-1"></i>Hiển thị bộ lọc
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Search Bar -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <input type="text" class="form-control" id="searchInput"
                                           placeholder="Tìm kiếm theo tên khách hàng, sản phẩm, nội dung đánh giá..."
                                           onkeypress="if(event.key==='Enter') applyFilters()">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary w-100" onclick="performSearchWithDateValidation()">
                                    <i class="fas fa-search me-1"></i>Tìm kiếm
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-outline-secondary w-100" onclick="
                                    document.getElementById('searchInput').value = '';
                                    document.getElementById('ratingFilter').value = '';
                                    document.getElementById('replyFilter').value = '';
                                    document.getElementById('fromDate').value = '';
                                    document.getElementById('toDate').value = '';

                                    const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                                    rows.forEach(row => row.style.display = '');

                                    const totalRows = rows.length;
                                    document.getElementById('table-count').textContent = totalRows + ' đánh giá';

                                    // Update replied count from all rows
                                    const repliedCount = Array.from(rows).filter(row => {
                                        const replyCell = row.cells[6]; // Cột Phản hồi (index 6)
                                        return replyCell.querySelector('.badge.bg-success');
                                    }).length;
                                    document.getElementById('replied-reviews').textContent = repliedCount;

                                    console.log('Filters reset, showing all ' + totalRows + ' rows, replied: ' + repliedCount);
                                ">
                                    <i class="fas fa-undo me-1"></i>Reset tất cả
                                </button>
                            </div>
                        </div>

                        <!-- Advanced Filters -->
                        <div class="collapse" id="filterCollapse">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="form-label" for="ratingFilter">Số sao</label>
                                    <select class="form-select" id="ratingFilter">
                                        <option value="">Tất cả</option>
                                        <option value="5">5 sao</option>
                                        <option value="4">4 sao</option>
                                        <option value="3">3 sao</option>
                                        <option value="2">2 sao</option>
                                        <option value="1">1 sao</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="replyFilter">Trạng thái phản hồi</label>
                                    <select class="form-select" id="replyFilter">
                                        <option value="">Tất cả</option>
                                        <option value="replied">Đã phản hồi</option>
                                        <option value="not-replied">Chưa phản hồi</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="fromDate">Từ ngày</label>
                                    <input type="date" class="form-control" id="fromDate">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label" for="toDate">Đến ngày</label>
                                    <input type="date" class="form-control" id="toDate">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Reviews Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>
                            <i class="fas fa-table me-2"></i>Danh sách Đánh giá
                        </span>
                        <span class="badge bg-primary" id="table-count">${totalReviews != null ? totalReviews : 0} đánh giá</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="reviewsTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Khách hàng</th>
                                        <th>Sản phẩm</th>
                                        <th>Đánh giá</th>
                                        <th>Nội dung</th>
                                        <th>Ngày tạo</th>
                                        <th>Phản hồi</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="reviewsTableBody">
                                    <c:choose>
                                        <c:when test="${not empty feedbackList}">
                                            <c:forEach var="feedback" items="${feedbackList}">
                                                <tr class="review-row ${!feedback.active ? 'table-secondary' : ''}"
                                                    style="${!feedback.active ? 'opacity: 0.6; background-color: #f8f9fa;' : ''}"
                                                    data-staff-reply="<c:out value="${feedback.replyText}" escapeXml="true"/>">
                                                    <td>
                                                        <span class="fw-bold text-primary">#<c:out value="${feedback.feedbackId}"/></span>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-2">
                                                                <i class="fas fa-user text-white"></i>
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold"><c:out value="${feedback.username}"/></div>
                                                                <small class="text-muted"><c:out value="${feedback.email}"/></small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${pageContext.request.contextPath}/img/<c:out value="${feedback.productImage}"/>" alt="Product" class="product-thumb me-2" style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;" onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                                            <div>
                                                                <div class="fw-bold"><c:out value="${feedback.productTitle}"/></div>
                                                                <small class="text-muted"><fmt:formatNumber value="${feedback.productPrice}" type="number" groupingUsed="true"/> VNĐ</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="rating-column">
                                                        <div class="rating-container">
                                                            <div class="stars">
                                                                <c:forEach begin="1" end="${feedback.rating}">
                                                                    <i class="fas fa-star text-warning"></i>
                                                                </c:forEach>
                                                                <c:forEach begin="${feedback.rating + 1}" end="5">
                                                                    <i class="far fa-star text-muted"></i>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="badge bg-warning rating-badge"><c:out value="${feedback.rating}"/>/5</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-start justify-content-between">
                                                            <!-- Main content area -->
                                                            <div class="review-content flex-grow-1" data-full-comment="<c:out value="${feedback.comment}" escapeXml="true"/>">
                                                                <p class="review-text mb-0">
                                                                    <c:choose>
                                                                        <c:when test="${!feedback.active}">
                                                                            <span class="text-muted fst-italic">
                                                                                <i class="fas fa-eye-slash me-1"></i>
                                                                                Đánh giá này đã bị ẩn do vi phạm chính sách
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${fn:length(feedback.comment) > 30}">
                                                                            <span class="short-text"><c:out value="${fn:substring(feedback.comment, 0, 30)}"/>...</span>
                                                                            <span class="full-text" style="display: none;"><c:out value="${feedback.comment}"/></span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:out value="${feedback.comment}"/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </p>
                                                            </div>

                                                            <!-- Icons on the right -->
                                                            <div class="review-icons ms-3 d-flex flex-column align-items-center gap-1">
                                                                <!-- Image count icon -->
                                                                <div class="image-count-badge">
                                                                    <span class="text-muted small">
                                                                        <i class="fas fa-images me-1"></i>+0
                                                                    </span>
                                                                </div>

                                                                <!-- Eye icon for viewing details - Always show for staff -->
                                                                <div class="view-detail-badge">
                                                                    <span class="text-primary small" style="cursor: pointer; opacity: 1 !important;" onclick="showFullReview(${feedback.feedbackId})" title="Xem chi tiết đánh giá">
                                                                        <i class="fas fa-eye"></i>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <small class="text-muted"><c:out value="${feedback.createdAt}"/></small>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty feedback.replyText}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check me-1"></i>Đã phản hồi
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning">
                                                                    <i class="fas fa-clock me-1"></i>Chưa phản hồi
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group" style="opacity: 1 !important;">
                                                            <!-- Nút Ẩn -->
                                                            <button type="button" class="btn btn-sm btn-outline-warning" onclick="hideReview(<c:out value="${feedback.feedbackId}"/>)" title="Ẩn đánh giá"
                                                                    style="opacity: 1 !important;">
                                                                <i class="fas fa-eye-slash"></i> Ẩn
                                                            </button>

                                                            <!-- Nút Hiện - Sáng lên khi đánh giá bị ẩn -->
                                                            <button type="button" class="btn btn-sm ${!feedback.active ? 'btn-success' : 'btn-outline-success'}"
                                                                    onclick="showReview(<c:out value="${feedback.feedbackId}"/>)" title="Hiện đánh giá"
                                                                    style="opacity: 1 !important; ${!feedback.active ? 'box-shadow: 0 0 10px rgba(40, 167, 69, 0.5);' : ''}">
                                                                <i class="fas fa-eye"></i> Hiện
                                                            </button>

                                                            <!-- Nút Trả lời -->
                                                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="replyReview(<c:out value="${feedback.feedbackId}"/>)" title="Trả lời đánh giá"
                                                                    style="opacity: 1 !important;">
                                                                <i class="fas fa-reply"></i> Trả lời
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center py-4">
                                                    <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                                    <h5>Chưa có đánh giá nào</h5>
                                                    <p class="text-muted">Đánh giá từ khách hàng sẽ hiển thị ở đây</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center" id="pagination">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <li class="page-item active">
                                    <a class="page-link" href="#">1</a>
                                </li>
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xem Chi tiết Đánh giá -->
        <div class="modal fade" id="viewReviewModal" tabindex="-1" aria-labelledby="viewReviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="viewReviewModalLabel">
                            <i class="fas fa-star me-2"></i>Chi Tiết Đánh Giá
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Customer Info -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="fw-bold mb-2">Thông tin khách hàng</h6>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-circle me-3">
                                        <i class="fas fa-user fa-2x"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" id="modal-customer-name">Tên khách hàng</div>
                                        <div class="text-muted small" id="modal-customer-email">email@example.com</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold mb-2">Thông tin sản phẩm</h6>
                                <div class="d-flex align-items-center">
                                    <img id="modal-product-image" src="" alt="Product" class="rounded me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                    <div>
                                        <div class="fw-bold" id="modal-product-name">Tên sản phẩm</div>
                                        <div class="text-muted small" id="modal-product-price">Giá sản phẩm</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Rating -->
                        <div class="mb-4">
                            <h6 class="fw-bold mb-2">Đánh giá</h6>
                            <div class="d-flex align-items-center">
                                <div id="modal-rating-stars" class="me-3">
                                    <!-- Stars will be populated by JavaScript -->
                                </div>
                                <span class="badge bg-warning" id="modal-rating-text">5/5</span>
                                <span class="text-muted ms-2" id="modal-review-date">01/01/2024</span>
                            </div>
                        </div>

                        <!-- Review Content -->
                        <div class="mb-4">
                            <h6 class="fw-bold mb-2">Nội dung đánh giá</h6>
                            <div class="bg-light p-3 rounded" id="modal-review-content">
                                Nội dung đánh giá sẽ hiển thị ở đây...
                            </div>
                        </div>

                        <!-- Review Images -->
                        <div class="mb-4" id="modal-review-images-section" style="display: none;">
                            <h6 class="fw-bold mb-2">Hình ảnh đính kèm</h6>
                            <div class="row" id="modal-review-images">
                                <!-- Images will be populated by JavaScript -->
                            </div>
                        </div>

                        <!-- Current Reply -->
                        <div class="mb-4" id="modal-current-reply-section" style="display: none;">
                            <h6 class="fw-bold mb-2">Phản hồi hiện tại</h6>
                            <div class="bg-success bg-opacity-10 p-3 rounded border-start border-success border-4">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <strong class="text-success">Shop phản hồi:</strong>
                                    <small class="text-muted" id="modal-reply-date">02/01/2024</small>
                                </div>
                                <div id="modal-current-reply-content">
                                    Phản hồi hiện tại sẽ hiển thị ở đây...
                                </div>
                                <div class="mt-2">
                                    <button class="btn btn-sm btn-outline-primary" onclick="editReply()">
                                        <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteReply()">
                                        <i class="fas fa-trash me-1"></i>Xóa
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Reply Form -->
                        <div id="modal-reply-form-section">
                            <h6 class="fw-bold mb-2" id="reply-form-title">Phản hồi đánh giá</h6>
                            <form id="replyForm">
                                <div class="mb-3">
                                    <textarea class="form-control" id="replyContent" rows="4"
                                              placeholder="Nhập phản hồi của bạn..."></textarea>
                                </div>
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-secondary me-2" onclick="cancelReply()">Hủy</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-reply me-1"></i>Gửi phản hồi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xác nhận Xóa -->
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="deleteConfirmModalLabel">
                            <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa phản hồi này không?</p>
                        <p class="text-muted small">Hành động này không thể hoàn tác.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-danger" onclick="confirmDeleteReply()">
                            <i class="fas fa-trash me-1"></i>Xóa
                        </button>
                    </div>
                </div>
            </div>
        </div>



        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Global variables
            let allReviews = [];
            let filteredReviews = [];

            // Update statistics from DOM
            function updateStatistics() {
                const allRows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                const visibleRows = Array.from(allRows).filter(row => row.style.display !== 'none');

                // Count replied reviews from visible rows
                const repliedCount = visibleRows.filter(row => {
                    const replyCell = row.cells[6]; // Cột Phản hồi (index 6)
                    return replyCell.querySelector('.badge.bg-success'); // Đã phản hồi
                }).length;

                // Update display
                document.getElementById('replied-reviews').textContent = repliedCount;

                console.log('Statistics updated - Replied:', repliedCount, 'Total visible:', visibleRows.length);
            }

            // Function to count replied reviews (from working demo)
            function countRepliedReviews() {
                console.log('🚀 Starting countRepliedReviews...');

                const rows = document.querySelectorAll('#reviewsTableBody tr');
                let repliedCount = 0;
                let totalCount = rows.length;

                console.log('🔍 Found rows:', totalCount);

                rows.forEach((row, index) => {
                    if (row.cells && row.cells.length > 6) {
                        const replyCell = row.cells[6]; // Cột Phản hồi (index 6)
                        const hasReplyBadge = replyCell.querySelector('.badge.bg-success');

                        console.log('Row ' + index + ' reply cell:', replyCell.innerHTML.trim());
                        console.log('Row ' + index + ' has reply badge:', !!hasReplyBadge);

                        if (hasReplyBadge) {
                            repliedCount++;
                            console.log('✅ Row ' + index + ' counted as replied');
                        }
                    }
                });

                // Update display
                const repliedElement = document.getElementById('replied-reviews');
                if (repliedElement) {
                    repliedElement.textContent = repliedCount;
                    console.log('🎉 Final count - Replied:', repliedCount, 'Total:', totalCount);
                } else {
                    console.log('❌ replied-reviews element not found');
                }

                return repliedCount;
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                console.log('📄 Reviews page loaded - DOMContentLoaded');
                setupFilterEventListeners();
                updateResultCount();

                // Auto count after delay (from working demo)
                setTimeout(function() {
                    console.log('⏰ Auto-count after 500ms delay');
                    countRepliedReviews();
                }, 500);
            });

            // Backup - window load (from working demo)
            window.addEventListener('load', function() {
                console.log('🪟 Window load event');
                setTimeout(function() {
                    console.log('⏰ Backup auto-count after 1000ms delay');
                    countRepliedReviews();
                }, 1000);
            });

            // Setup event listeners for filters (removed auto-filter, now manual only)
            function setupFilterEventListeners() {
                console.log('Filter event listeners setup - manual search mode');
                // No auto-filtering, only manual search via button click
                // Enter key in search input will trigger search
            }

            // Simple search function
            function performSearch() {
                console.log('performSearch called');

                try {
                    const ratingFilter = document.getElementById('ratingFilter').value;
                    console.log('Rating filter value:', ratingFilter);

                    const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                    console.log('Found rows:', rows.length);

                    let visibleCount = 0;

                    rows.forEach((row, index) => {
                        let shouldShow = true;

                        if (ratingFilter) {
                            // Get rating from badge
                            const ratingBadge = row.cells[3].querySelector('.rating-badge');
                            if (ratingBadge) {
                                const badgeText = ratingBadge.textContent.trim();
                                const actualRating = parseInt(badgeText.split('/')[0]);
                                const filterRating = parseInt(ratingFilter);

                                console.log(`Row ${index}: actual=${actualRating}, filter=${filterRating}`);

                                if (actualRating !== filterRating) {
                                    shouldShow = false;
                                }
                            }
                        }

                        row.style.display = shouldShow ? '' : 'none';
                        if (shouldShow) visibleCount++;
                    });

                    console.log('Visible rows:', visibleCount);

                } catch (error) {
                    console.error('Error in performSearch:', error);
                    alert('Có lỗi xảy ra: ' + error.message);
                }
            }



            // Apply all filters to the table (backup function)
            function applyFilters() {
                console.log('applyFilters called');

                // Validate date range first
                if (!validateDateRange()) {
                    console.log('❌ Date validation failed, stopping filter');
                    return;
                }

                // Test if elements exist
                const searchInput = document.getElementById('searchInput');
                const ratingFilter = document.getElementById('ratingFilter');
                const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');

                console.log('Elements found:');
                console.log('- searchInput:', searchInput);
                console.log('- ratingFilter:', ratingFilter);
                console.log('- rows count:', rows.length);
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const ratingFilter = document.getElementById('ratingFilter').value;
                const replyFilter = document.getElementById('replyFilter').value;
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;

                const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                let visibleCount = 0;

                rows.forEach(row => {
                    let shouldShow = true;

                    // Search term filter
                    if (searchTerm && shouldShow) {
                        const customerName = row.cells[1].textContent.toLowerCase();
                        const productName = row.cells[2].textContent.toLowerCase();
                        const reviewContent = row.cells[4].textContent.toLowerCase();

                        const matches = customerName.includes(searchTerm) ||
                                      productName.includes(searchTerm) ||
                                      reviewContent.includes(searchTerm);

                        if (!matches) shouldShow = false;
                    }

                    // Rating filter
                    if (ratingFilter && shouldShow) {
                        // Get rating from the badge which shows "X/5"
                        const ratingBadge = row.cells[3].querySelector('.rating-badge');
                        let actualRating = 0;

                        if (ratingBadge) {
                            const badgeText = ratingBadge.textContent.trim();
                            actualRating = parseInt(badgeText.split('/')[0]);
                        } else {
                            // Fallback: count filled stars
                            actualRating = row.cells[3].querySelectorAll('.fas.fa-star.text-warning').length;
                        }

                        const filterRating = parseInt(ratingFilter);

                        console.log('Rating Filter Debug:');
                        console.log('- Row actual rating:', actualRating);
                        console.log('- Filter rating:', filterRating);
                        console.log('- Badge text:', ratingBadge ? ratingBadge.textContent : 'No badge');
                        console.log('- Should show:', actualRating === filterRating);

                        if (actualRating !== filterRating) {
                            shouldShow = false;
                        }
                    }

                    // Reply status filter
                    if (replyFilter && shouldShow) {
                        const hasReplyBadge = row.cells[5].querySelector('.badge.bg-success');

                        if (replyFilter === 'replied' && !hasReplyBadge) shouldShow = false;
                        if (replyFilter === 'not-replied' && hasReplyBadge) shouldShow = false;
                    }

                    // Date range filter
                    if ((fromDate || toDate) && shouldShow) {
                        const dateText = row.cells[5].textContent.trim(); // Cột "Ngày tạo" (index 5)
                        console.log('Row ' + index + ' date text:', dateText);

                        // Try to parse date (format: dd/MM/yyyy HH:mm or similar)
                        const dateParts = dateText.split(' ')[0].split('/');
                        console.log('Row ' + index + ' date parts:', dateParts);

                        if (dateParts.length === 3) {
                            const reviewDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                            console.log('Row ' + index + ' parsed review date:', reviewDate);

                            if (fromDate) {
                                const fromDateObj = new Date(fromDate);
                                console.log('Row ' + index + ' comparing with fromDate:', fromDateObj, 'reviewDate < fromDate?', reviewDate < fromDateObj);
                                if (reviewDate < fromDateObj) {
                                    shouldShow = false;
                                    console.log('Row ' + index + ' hidden by fromDate filter');
                                }
                            }

                            if (toDate && shouldShow) {
                                const toDateObj = new Date(toDate);
                                toDateObj.setHours(23, 59, 59);
                                console.log('Row ' + index + ' comparing with toDate:', toDateObj, 'reviewDate > toDate?', reviewDate > toDateObj);
                                if (reviewDate > toDateObj) {
                                    shouldShow = false;
                                    console.log('Row ' + index + ' hidden by toDate filter');
                                }
                            }
                        } else {
                            console.log('Row ' + index + ' date parsing failed');
                        }
                    }

                    row.style.display = shouldShow ? '' : 'none';
                    if (shouldShow) visibleCount++;
                });

                updateResultCount(visibleCount);
            }

            // Update result count display
            function updateResultCount(visibleCount = null) {
                if (visibleCount === null) {
                    const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                    visibleCount = Array.from(rows).filter(row => row.style.display !== 'none').length;
                }

                const totalRows = document.querySelectorAll('#reviewsTableBody tr.review-row').length;

                // Update table count
                const tableCount = document.getElementById('table-count');
                if (tableCount) {
                    tableCount.textContent = `${visibleCount} đánh giá`;
                }

                // Update visible reviews stat
                const visibleReviews = document.getElementById('visible-reviews');
                if (visibleReviews) {
                    visibleReviews.textContent = visibleCount;
                }
            }

            // Reset all filters
            function resetFilters() {
                document.getElementById('searchInput').value = '';
                document.getElementById('ratingFilter').value = '';
                document.getElementById('replyFilter').value = '';
                document.getElementById('fromDate').value = '';
                document.getElementById('toDate').value = '';

                // Show all rows
                const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                rows.forEach(row => row.style.display = '');

                updateResultCount();
            }

            // Simple action functions
            function viewReview(reviewId) {
                console.log('Viewing review:', reviewId);
                // For now, just show an alert
                alert('Xem chi tiết đánh giá #' + reviewId);
            }

            function replyReview(reviewId) {
                console.log('Replying to review:', reviewId);
                // For now, just show an alert
                alert('Phản hồi đánh giá #' + reviewId);
            }

            function hideReview(reviewId) {
                console.log('Hiding review:', reviewId);
                // For now, just show an alert
                if (confirm('Bạn có chắc muốn ẩn đánh giá #' + reviewId + '?')) {
                    alert('Đã ẩn đánh giá #' + reviewId);
                }
            }



            // Update statistics
            function updateStatistics() {
                document.getElementById('total-reviews').textContent = allReviews.length;
                document.getElementById('visible-reviews').textContent = filteredReviews.length;
                document.getElementById('table-count').textContent = filteredReviews.length + ' đánh giá';
                
                // Calculate average rating
                if (allReviews.length > 0) {
                    const avgRating = allReviews.reduce((sum, review) => sum + review.rating, 0) / allReviews.length;
                    document.getElementById('avg-rating').textContent = avgRating.toFixed(1);
                } else {
                    document.getElementById('avg-rating').textContent = '0.0';
                }
                
                // Count replied reviews
                const repliedCount = allReviews.filter(review => review.hasReply).length;
                document.getElementById('replied-reviews').textContent = repliedCount;
            }

            // Setup event listeners
            function setupEventListeners() {
                // Search input
                document.getElementById('searchInput').addEventListener('input', filterReviews);
                
                // Filter selects
                document.getElementById('ratingFilter').addEventListener('change', filterReviews);
                document.getElementById('replyFilter').addEventListener('change', filterReviews);
                document.getElementById('fromDate').addEventListener('change', function() {
                    if (validateDateRange()) {
                        filterReviews();
                    }
                });
                document.getElementById('toDate').addEventListener('change', function() {
                    if (validateDateRange()) {
                        filterReviews();
                    }
                });
            }

            // Filter reviews
            function filterReviews() {
                // Validate date range first
                if (!validateDateRange()) {
                    console.log('❌ Date validation failed in filterReviews');
                    return;
                }

                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const ratingFilter = document.getElementById('ratingFilter').value;
                const replyFilter = document.getElementById('replyFilter').value;
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;

                filteredReviews = allReviews.filter(review => {
                    // Search filter
                    const matchesSearch = !searchTerm ||
                        review.customerName.toLowerCase().includes(searchTerm) ||
                        review.productName.toLowerCase().includes(searchTerm) ||
                        review.content.toLowerCase().includes(searchTerm);

                    // Rating filter
                    const matchesRating = !ratingFilter || review.rating.toString() === ratingFilter;

                    // Reply filter
                    const matchesReply = !replyFilter ||
                        (replyFilter === 'replied' && review.hasReply) ||
                        (replyFilter === 'not-replied' && !review.hasReply);

                    // Date filter
                    const reviewDate = new Date(review.createdDate);
                    const matchesFromDate = !fromDate || reviewDate >= new Date(fromDate);
                    const matchesToDate = !toDate || reviewDate <= new Date(toDate);

                    return matchesSearch && matchesRating && matchesReply && matchesFromDate && matchesToDate;
                });

                renderReviewsTable();
                updateStatistics();
            }

            // Reset filters
            function resetFilters() {
                document.getElementById('searchInput').value = '';
                document.getElementById('ratingFilter').value = '';
                document.getElementById('replyFilter').value = '';
                document.getElementById('fromDate').value = '';
                document.getElementById('toDate').value = '';
                filterReviews();
            }

            // Render reviews table
            function renderReviewsTable() {
                const tbody = document.getElementById('reviewsTableBody');

                if (filteredReviews.length === 0) {
                    tbody.innerHTML = `
                        <tr>
                            <td colspan="8" class="text-center py-4">
                                <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                <h5>Chưa có đánh giá nào</h5>
                                <p class="text-muted">Đánh giá từ khách hàng sẽ hiển thị ở đây</p>
                            </td>
                        </tr>
                    `;
                    return;
                }

                tbody.innerHTML = filteredReviews.map(review => `
                    <tr class="review-row">
                        <td>
                            <span class="fw-bold text-primary">#${review.id}</span>
                        </td>
                        <td>
                            <div class="d-flex align-items-center justify-content-center">
                                <div class="avatar-sm me-2">
                                    <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center"
                                         style="width: 35px; height: 35px;">
                                        <i class="fas fa-user text-white"></i>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <div class="fw-bold small">${review.customerName}</div>
                                    <div class="text-muted" style="font-size: 0.7rem;">${review.customerEmail}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="d-flex align-items-center justify-content-center">
                                <img src="${review.productImage}" alt="Product" class="rounded me-2"
                                     style="width: 40px; height: 40px; object-fit: cover;">
                                <div class="text-center">
                                    <div class="fw-bold small">${review.productName}</div>
                                    <div class="text-success fw-bold" style="font-size: 0.75rem;">${review.productPrice}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="text-center">
                                <div class="mb-1">${generateStars(review.rating)}</div>
                                <span class="badge bg-warning">${review.rating}/5</span>
                            </div>
                        </td>
                        <td>
                            <div class="text-start" style="max-width: 250px;">
                                <div class="text-truncate" title="${review.content}">
                                    ${review.content}
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="text-center">
                                <small class="text-muted fw-bold">${formatDate(review.createdDate)}</small>
                            </div>
                        </td>
                        <td>
                            <div class="text-center">
                                ${review.hasReply ?
                                    '<span class="badge bg-success"><i class="fas fa-check me-1"></i>Đã phản hồi</span>' :
                                    '<span class="badge bg-warning"><i class="fas fa-clock me-1"></i>Chưa phản hồi</span>'
                                }
                            </div>
                        </td>
                        <td>
                            <div class="btn-group d-flex justify-content-center" role="group">
                                <button class="btn btn-sm btn-info" onclick="viewReview(${review.id})"
                                        data-bs-toggle="modal" data-bs-target="#viewReviewModal" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-primary" onclick="replyToReview(${review.id})"
                                        data-bs-toggle="modal" data-bs-target="#viewReviewModal" title="Phản hồi">
                                    <i class="fas fa-reply"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="hideReview(${review.id})" title="Ẩn đánh giá">
                                    <i class="fas fa-eye-slash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `).join('');
            }

            // Generate star rating HTML
            function generateStars(rating) {
                let stars = '';
                for (let i = 1; i <= 5; i++) {
                    if (i <= rating) {
                        stars += '<i class="fas fa-star text-warning"></i>';
                    } else {
                        stars += '<i class="far fa-star text-muted"></i>';
                    }
                }
                return stars;
            }

            // Format date
            function formatDate(dateString) {
                const date = new Date(dateString);
                return date.toLocaleDateString('vi-VN');
            }

            // View review details
            function viewReview(reviewId) {
                const review = allReviews.find(r => r.id === reviewId);
                if (!review) return;

                // Populate modal with review data
                document.getElementById('modal-customer-name').textContent = review.customerName;
                document.getElementById('modal-customer-email').textContent = review.customerEmail;
                document.getElementById('modal-product-name').textContent = review.productName;
                document.getElementById('modal-product-price').textContent = review.productPrice;
                document.getElementById('modal-product-image').src = review.productImage;
                document.getElementById('modal-rating-stars').innerHTML = generateStars(review.rating);
                document.getElementById('modal-rating-text').textContent = review.rating + '/5';
                document.getElementById('modal-review-date').textContent = formatDate(review.createdDate);
                document.getElementById('modal-review-content').textContent = review.content;

                // Handle reply section
                if (review.hasReply) {
                    document.getElementById('modal-current-reply-section').style.display = 'block';
                    document.getElementById('modal-current-reply-content').textContent = review.replyContent;
                    document.getElementById('modal-reply-date').textContent = formatDate(review.replyDate);
                    document.getElementById('modal-reply-form-section').style.display = 'none';
                } else {
                    document.getElementById('modal-current-reply-section').style.display = 'none';
                    document.getElementById('modal-reply-form-section').style.display = 'block';
                    document.getElementById('reply-form-title').textContent = 'Phản hồi đánh giá';
                }

                // Store current review ID for form submission
                document.getElementById('replyForm').setAttribute('data-review-id', reviewId);
            }

            // Reply to review
            function replyToReview(reviewId) {
                viewReview(reviewId);
                // Focus on reply form
                setTimeout(() => {
                    document.getElementById('replyContent').focus();
                }, 500);
            }

            // Edit reply
            function editReply() {
                document.getElementById('modal-current-reply-section').style.display = 'none';
                document.getElementById('modal-reply-form-section').style.display = 'block';
                document.getElementById('reply-form-title').textContent = 'Chỉnh sửa phản hồi';

                // Pre-fill form with current reply
                const currentReply = document.getElementById('modal-current-reply-content').textContent;
                document.getElementById('replyContent').value = currentReply;
            }

            // Cancel reply
            function cancelReply() {
                const reviewId = document.getElementById('replyForm').getAttribute('data-review-id');
                const review = allReviews.find(r => r.id == reviewId);

                if (review && review.hasReply) {
                    document.getElementById('modal-current-reply-section').style.display = 'block';
                    document.getElementById('modal-reply-form-section').style.display = 'none';
                } else {
                    document.getElementById('replyContent').value = '';
                }
            }

            // Delete reply
            function deleteReply() {
                // Show confirmation modal
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                deleteModal.show();
            }

            // Confirm delete reply
            function confirmDeleteReply() {
                const reviewId = document.getElementById('replyForm').getAttribute('data-review-id');
                // Implementation will be added when backend is ready
                console.log('Deleting reply for review:', reviewId);

                // Close modals
                bootstrap.Modal.getInstance(document.getElementById('deleteConfirmModal')).hide();
                bootstrap.Modal.getInstance(document.getElementById('viewReviewModal')).hide();
            }

            // Hide review
            function hideReview(reviewId) {
                if (confirm('Bạn có chắc chắn muốn ẩn đánh giá này không?')) {
                    // Implementation will be added when backend is ready
                    console.log('Hiding review:', reviewId);
                }
            }

            // Handle reply form submission
            document.getElementById('replyForm').addEventListener('submit', function(e) {
                e.preventDefault();
                const reviewId = this.getAttribute('data-review-id');
                const replyContent = document.getElementById('replyContent').value.trim();

                if (!replyContent) {
                    alert('Vui lòng nhập nội dung phản hồi');
                    return;
                }

                // Implementation will be added when backend is ready
                console.log('Submitting reply for review:', reviewId, 'Content:', replyContent);

                // Close modal
                bootstrap.Modal.getInstance(document.getElementById('viewReviewModal')).hide();
            });
        </script>

        <!-- Review Images Modal -->
        <div class="modal fade" id="reviewImagesModal" tabindex="-1" aria-labelledby="reviewImagesModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewImagesModalLabel">
                            <i class="fas fa-images me-2"></i>Ảnh đánh giá #<span id="modalReviewId"></span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Image Carousel -->
                        <div class="review-image-carousel">
                            <div class="image-container position-relative">
                                <img id="currentImage" src="" alt="Review Image" class="img-fluid rounded shadow-sm">

                                <!-- Navigation Arrows -->
                                <button class="carousel-nav prev-btn" onclick="previousImage()">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button class="carousel-nav next-btn" onclick="nextImage()">
                                    <i class="fas fa-chevron-right"></i>
                                </button>

                                <!-- Image Counter -->
                                <div class="image-counter">
                                    <span id="currentImageIndex">1</span> / <span id="totalImages">5</span>
                                </div>
                            </div>

                            <!-- Thumbnail Navigation -->
                            <div class="thumbnail-nav mt-3">
                                <div class="d-flex justify-content-center gap-2" id="thumbnailContainer">
                                    <!-- Thumbnails will be generated by JavaScript -->
                                </div>
                            </div>

                            <!-- Page Numbers -->
                            <div class="page-numbers mt-3">
                                <div class="d-flex justify-content-center gap-1" id="pageNumbers">
                                    <!-- Page numbers 1-5 will be generated by JavaScript -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary" onclick="downloadImage()">
                            <i class="fas fa-download me-1"></i>Tải xuống
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Separate script for search function to avoid conflicts -->
        <script>
            function performSearch() {
                console.log('performSearch called from separate script');

                try {
                    const ratingFilter = document.getElementById('ratingFilter').value;
                    console.log('Rating filter value:', ratingFilter);

                    if (!ratingFilter) {
                        console.log('No rating filter selected');
                        return;
                    }

                    const rows = document.querySelectorAll('#reviewsTableBody tr.review-row');
                    console.log('Found rows:', rows.length);

                    let visibleCount = 0;

                    rows.forEach((row, index) => {
                        let shouldShow = true;

                        // Get rating from badge
                        const ratingCell = row.cells[3]; // Đánh giá column
                        const ratingBadge = ratingCell.querySelector('.rating-badge');

                        if (ratingBadge) {
                            const badgeText = ratingBadge.textContent.trim();
                            const actualRating = parseInt(badgeText.split('/')[0]);
                            const filterRating = parseInt(ratingFilter);

                            console.log(`Row ${index}: actual=${actualRating}, filter=${filterRating}, badge="${badgeText}"`);

                            if (actualRating !== filterRating) {
                                shouldShow = false;
                            }
                        } else {
                            console.log(`Row ${index}: No rating badge found`);
                            shouldShow = false; // Hide rows without rating badge
                        }

                        row.style.display = shouldShow ? '' : 'none';
                        if (shouldShow) visibleCount++;
                    });

                    console.log('Visible rows after filter:', visibleCount);

                    // Update count display
                    const tableCount = document.getElementById('table-count');
                    if (tableCount) {
                        tableCount.textContent = `${visibleCount} đánh giá`;
                    }

                } catch (error) {
                    console.error('Error in performSearch:', error);
                    alert('Có lỗi xảy ra: ' + error.message);
                }
            }
        </script>
    </body>
</html>
