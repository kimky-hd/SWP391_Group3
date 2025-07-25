package Controller.Shipper;

import DAO.HoaDonDAO;
import DAO.ProductBatchDAO;
import DAO.OrderDetailDAO;
import Model.HoaDon;
import Model.Status;
import Model.Account;
import Model.OrderDetail;
import Utils.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.List;

/**
 * Shipper Controller for managing orders that need to be shipped
 */
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class ShipperController extends HttpServlet {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();
    private final ProductBatchDAO productBatchDAO = new ProductBatchDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        // Check if user is logged in and has shipper role
        if (account == null || account.getRole() != 3) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/shipper/dashboard":
                handleDashboard(request, response);
                break;
            case "/shipper/order-detail":
                handleOrderDetail(request, response);
                break;
            case "/shipper/customer-email":
                handleCustomerEmail(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ShipperController doPost called with path: " + request.getServletPath());

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        System.out.println("Session account: " + (account != null ? account.getUsername() : "null"));
        System.out.println("Session account role: " + (account != null ? account.getRole() : "null"));

        // Check if user is logged in and has shipper role
        if (account == null || account.getRole() != 3) {
            System.out.println("Authentication failed - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/shipper/update-status".equals(path)) {
            handleUpdateStatus(request, response);
        } else {
            System.out.println("Path not found: " + path);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Handle orders list page with pagination and search
     */
    /**
     * Handle shipper dashboard
     */
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            int shipperID = account.getAccountID();

            System.out.println("=== SHIPPER DASHBOARD DEBUG ===");
            System.out.println("Shipper ID: " + shipperID);
            System.out.println("Account details: " + account.getUsername() + " (Role: " + account.getRole() + ")");

            // Get summary data for dashboard - only for this shipper
            int approvedOrders = hoaDonDAO.getTotalOrdersByStatusAndShipper(2, shipperID, null); // Approved and ready for shipping
            int shipping = hoaDonDAO.getTotalOrdersByStatusAndShipper(3, shipperID, null); // Shipping
            int delivered = hoaDonDAO.getTotalOrdersByStatusAndShipper(4, shipperID, null); // Delivered
            int cancelled = hoaDonDAO.getTotalOrdersByStatusAndShipper(10, shipperID, null); // Cancelled

            System.out.println("Orders count for shipper " + shipperID + ":");
            System.out.println("- Approved (status 2): " + approvedOrders);
            System.out.println("- Shipping (status 3): " + shipping);
            System.out.println("- Delivered (status 4): " + delivered);
            System.out.println("- Cancelled (status 10): " + cancelled);

            // Get recent orders (status 2, 3, 4, 10) - only for this shipper
            List<HoaDon> recentOrders = hoaDonDAO.getOrdersByMultipleStatusForSpecificShipper(new int[]{2, 3, 4, 10}, shipperID);

            System.out.println("Recent orders count: " + recentOrders.size());
            for (HoaDon order : recentOrders) {
                System.out.println("- Order #" + order.getMaHD() + " (Status: " + order.getStatusID() + ", ShipperID: " + order.getShippingID() + ")");
            }

            // Set attributes
            request.setAttribute("approvedOrders", approvedOrders);
            request.setAttribute("shipping", shipping);
            request.setAttribute("delivered", delivered);
            request.setAttribute("cancelled", cancelled);
            request.setAttribute("recentOrders", recentOrders);

            System.out.println("=== END SHIPPER DASHBOARD DEBUG ===");

            // Forward to dashboard JSP
            request.getRequestDispatcher("/shipper/shipper_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/shipper/shipper_dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handle order status update with image upload support
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Debug: Print all request parameters
            System.out.println("=== handleUpdateStatus Debug ===");
            System.out.println("Request method: " + request.getMethod());
            System.out.println("Content type: " + request.getContentType());

            String orderIdParam = request.getParameter("orderId");
            String statusIdParam = request.getParameter("statusId");
            String note = request.getParameter("note"); // For notes/cancellation reason

            // Debug logging
            System.out.println("Update status request received:");
            System.out.println("orderIdParam: " + orderIdParam);
            System.out.println("statusIdParam: " + statusIdParam);
            System.out.println("note: " + note);

            if (orderIdParam == null || statusIdParam == null) {
                System.out.println("Missing required parameters - returning 400");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameters");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);
            int statusId = Integer.parseInt(statusIdParam);

            System.out.println("Parsed parameters - orderId: " + orderId + ", statusId: " + statusId);

            // Validate status transitions for shipper
            if (!isValidStatusTransition(orderId, statusId)) {
                System.out.println("Invalid status transition - returning 400");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid status transition");
                return;
            }

            // Handle image upload for status 4 (delivered) and 10 (failed delivery)
            String imagePath = null;
            try {
                Part imagePart = request.getPart("image");
                if (imagePart != null && imagePart.getSize() > 0) {
                    imagePath = FileUploadUtil.saveFile(imagePart, getServletContext().getRealPath("/"));
                    System.out.println("Image uploaded: " + imagePath);
                }
            } catch (Exception e) {
                System.out.println("Error uploading image: " + e.getMessage());
                // Continue without image for status 4, but fail for status 10
                if (statusId == 10) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Image upload failed for delivery failure");
                    return;
                }
            }

            // Validation based on status
            if (statusId == 10) {
                // Status 10 (failed delivery) requires both note and image
                if ((note == null || note.trim().isEmpty())) {
                    System.out.println("Failure reason required - returning 400");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Failure reason is required");
                    return;
                }
                if (imagePath == null) {
                    System.out.println("Evidence image required for failed delivery - returning 400");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Evidence image is required for failed delivery");
                    return;
                }
            }

            boolean success = false;
            
            if (statusId == 10) {
                // Failed delivery with note and image
                System.out.println("Updating to failed delivery with note and image");
                restoreProductQuantities(orderId); // Restore quantities first
                success = hoaDonDAO.updateOrderStatusWithNoteAndImage(orderId, statusId, note, imagePath);
            } else if (statusId == 4 && imagePath != null) {
                // Successful delivery with optional image
                System.out.println("Updating to successful delivery with image");
                success = hoaDonDAO.updateOrderStatusWithImage(orderId, statusId, imagePath);
            } else if (statusId == 4) {
                // Successful delivery without image
                System.out.println("Updating to successful delivery without image");
                success = hoaDonDAO.updateOrderStatus(orderId, statusId);
            } else {
                // Regular status update
                System.out.println("Regular status update for order " + orderId + " to status " + statusId);
                success = hoaDonDAO.updateOrderStatus(orderId, statusId);
            }

            System.out.println("Update result: " + success);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Status updated successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to update status");
            }

        } catch (NumberFormatException e) {
            System.out.println("NumberFormatException: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid parameter format");
        } catch (Exception e) {
            System.out.println("Exception in handleUpdateStatus: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Server error: " + e.getMessage());
        }
    }

    /**
     * Validate if the status transition is allowed for shipper 
     * New flow: 2 -> 3 -> 4 or 9 (failed delivery)
     */
    private boolean isValidStatusTransition(int orderId, int newStatusId) {
        try {
            HoaDon order = hoaDonDAO.getOrderById(orderId);
            if (order == null) {
                System.out.println("Order not found: " + orderId);
                return false;
            }

            int currentStatus = order.getStatusID();

            System.out.println("Status transition check:");
            System.out.println("Order ID: " + orderId);
            System.out.println("Current Status: " + currentStatus);
            System.out.println("New Status: " + newStatusId);

           
            boolean isValid = false;
            switch (currentStatus) {
                case 2: // Approved and ready for shipping
                    isValid = newStatusId == 3 || newStatusId == 10; // Can start shipping or fail
                    break;
                case 3: // Shipping
                    isValid = newStatusId == 4 || newStatusId == 10; // Can deliver successfully or fail
                    break;
                case 4: // Delivered successfully
                case 9: // Failed delivery
                    isValid = false; // No further transitions allowed
                    break;
                default:
                    isValid = false;
                    break;
            }

            System.out.println("Transition valid: " + isValid);
            return isValid;

        } catch (Exception e) {
            System.out.println("Exception in isValidStatusTransition: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Handle order detail page
     */
    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderIdParam = request.getParameter("orderId");
            System.out.println("Order detail request - orderIdParam: " + orderIdParam);

            if (orderIdParam == null || orderIdParam.isEmpty()) {
                System.out.println("Order ID parameter is missing");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);
            System.out.println("Looking for order with ID: " + orderId);

            // Get order details
            HoaDon order = hoaDonDAO.getOrderById(orderId);
            if (order == null) {
                System.out.println("Order not found for ID: " + orderId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            System.out.println("Found order: " + order.getMaHD() + ", Customer: " + order.getCustomerName());

            // Get shipper information
            String shipperInfo = hoaDonDAO.getShipperInfo(order.getShippingID());
            
            // Get customer email from inforline
            String customerEmail = hoaDonDAO.getCustomerEmailFromInforline(order.getCustomerName(), order.getCustomerPhone());
            
            System.out.println("Shipper info: " + shipperInfo);
            System.out.println("Customer email: " + customerEmail);

            // Get order items
            List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
            System.out.println("Found " + orderDetails.size() + " order details");

            // Tính tổng giá đơn hàng tại đây:
            double tongGia = 0;
            System.out.println("=== PROCESSING ORDER DETAILS ===");
            for (OrderDetail detail : orderDetails) {
                double total = detail.getPrice() * detail.getQuantity();
                detail.setTotal(total); // <- DÒNG NÀY QUAN TRỌNG!
                tongGia += total;
                
                System.out.println("Product: " + (detail.getProductName() != null ? detail.getProductName().toString() : "null"));
                System.out.println("Price: " + detail.getPrice());
                System.out.println("Quantity: " + detail.getQuantity());
                System.out.println("Total: " + detail.getTotal());
                System.out.println("---");
            }
            System.out.println("Final tongGia: " + tongGia);
            System.out.println("=== END ORDER DETAILS PROCESSING ===");

            // Set attributes
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("shipperInfo", shipperInfo);
            request.setAttribute("customerEmail", customerEmail);

            // Check if this is an AJAX request (for modal)
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);
            
            // Check if this is a JSON request (from JavaScript fetch)
            String acceptHeader = request.getHeader("Accept");
            boolean isJsonRequest = acceptHeader != null && acceptHeader.contains("application/json");

            if (isJsonRequest) {
                // Return JSON response for JavaScript
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"maHD\":\"").append(order.getMaHD()).append("\",");
                json.append("\"customerName\":\"").append(order.getCustomerName() != null ? order.getCustomerName() : "").append("\",");
                json.append("\"customerPhone\":\"").append(order.getCustomerPhone() != null ? order.getCustomerPhone() : "").append("\",");
                json.append("\"customerEmail\":\"").append(customerEmail != null ? customerEmail : "Chưa có").append("\",");
                json.append("\"customerAddress\":\"").append(order.getCustomerAddress() != null ? order.getCustomerAddress() : "").append("\",");
                json.append("\"tongGia\":").append(tongGia).append(",");
                json.append("\"ngayXuat\":\"").append(order.getNgayXuat() != null ? order.getNgayXuat().toString() : "").append("\",");
                json.append("\"statusID\":").append(order.getStatusID()).append(",");
                json.append("\"note\":\"").append(order.getNote() != null ? order.getNote().replaceAll("\"", "\\\\\"") : "").append("\",");
                json.append("\"imageNote\":\"").append(order.getImageNote() != null ? order.getImageNote().replaceAll("\"", "\\\\\"") : "").append("\",");
                json.append("\"shipperName\":\"").append(shipperInfo != null ? shipperInfo : "Chưa phân công").append("\",");
                json.append("\"items\":[");
                
                for (int i = 0; i < orderDetails.size(); i++) {
                    OrderDetail detail = orderDetails.get(i);
                    if (i > 0) json.append(",");
                    json.append("{");
                    
                    // Get product name safely
                    String productName = "Sản phẩm";
                    if (detail.getProductName() != null) {
                        productName = detail.getProductName().toString();
                    }
                    
                    // Get product image safely
                    String imageName = "default-flower.jpg";
                    if (detail.getProduct() != null && detail.getProduct().getImage() != null && !detail.getProduct().getImage().isEmpty()) {
                        imageName = detail.getProduct().getImage();
                    }
                    
                    // Get product description safely
                    String description = "Sản phẩm hoa tươi";
                    if (detail.getProduct() != null && detail.getProduct().getDescription() != null && !detail.getProduct().getDescription().isEmpty()) {
                        description = detail.getProduct().getDescription();
                    }
                    
                    json.append("\"name\":\"").append(productName).append("\",");
                    json.append("\"quantity\":").append(detail.getQuantity()).append(",");
                    json.append("\"price\":").append(detail.getPrice()).append(",");
                    json.append("\"total\":").append(detail.getTotal()).append(",");
                    json.append("\"image\":\"").append(imageName).append("\",");
                    json.append("\"description\":\"").append(description).append("\"");
                    json.append("}");
                }
                
                json.append("]");
                json.append("}");
                
                response.getWriter().write(json.toString());
                return;
            } else if (isAjax) {
                // Forward to JSP fragment for modal content
                request.getRequestDispatcher("/shipper/order_detail_fragment.jsp").forward(request, response);
            } else {
                // Forward to full page
                request.getRequestDispatcher("/shipper/order_detail.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("Exception in handleOrderDetail: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết đơn hàng: " + e.getMessage());

            // Check if this is an AJAX request
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);

            if (isAjax) {
                request.getRequestDispatcher("/shipper/order_detail_fragment.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/shipper/order_detail.jsp").forward(request, response);
            }
        }
    }

    /**
     * Restore product quantities when order is cancelled
     *
     * @param orderId Order ID
     */
    private void restoreProductQuantities(int orderId) {
        try {
            System.out.println("=== STARTING QUANTITY RESTORATION ===");
            System.out.println("Order ID: " + orderId);

            // Get all order details for this order
            List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
            System.out.println("Found " + orderDetails.size() + " order details to restore");

            if (orderDetails.isEmpty()) {
                System.out.println("No order details found - nothing to restore");
                return;
            }

            int successCount = 0;
            int failCount = 0;

            // Test database operation with first product
            if (!orderDetails.isEmpty()) {
                OrderDetail firstDetail = orderDetails.get(0);
                System.out.println("Running database test with product " + firstDetail.getProductId());
                productBatchDAO.testDatabaseOperation(firstDetail.getProductId(), 1);
            }

            // For each order detail, add the quantity back to product batch
            for (OrderDetail detail : orderDetails) {
                System.out.println("=== Processing product " + detail.getProductId() + " ===");
                System.out.println("Quantity to restore: " + detail.getQuantity());

                // Check if product batch exists
                boolean batchExists = productBatchDAO.checkProductBatchExists(detail.getProductId());
                System.out.println("Product batch exists: " + batchExists);

                // Get current total quantity before restore
                int currentQuantity = productBatchDAO.getTotalQuantityForProduct(detail.getProductId());
                System.out.println("Current total quantity: " + currentQuantity);

                // Try to restore quantity
                System.out.println("Method 1: Using addQuantityToProduct()");
                boolean success = productBatchDAO.addQuantityToProduct(detail.getProductId(), detail.getQuantity());

                if (!success) {
                    System.out.println("Method 1 failed, trying Method 2: Using forceAddQuantity()");
                    success = productBatchDAO.forceAddQuantity(detail.getProductId(), detail.getQuantity());
                }

                if (success) {
                    // Check quantity after restore
                    int newQuantity = productBatchDAO.getTotalQuantityForProduct(detail.getProductId());
                    System.out.println("New total quantity: " + newQuantity);
                    System.out.println("Expected change: +" + detail.getQuantity() + ", Actual change: +" + (newQuantity - currentQuantity));
                    System.out.println("✓ Successfully restored " + detail.getQuantity() + " units of product " + detail.getProductId());
                    successCount++;
                } else {
                    System.out.println("✗ Failed to restore quantity for product " + detail.getProductId());
                    failCount++;
                }
                System.out.println("=== End processing product " + detail.getProductId() + " ===");
            }

            System.out.println("=== RESTORATION SUMMARY ===");
            System.out.println("Total products processed: " + orderDetails.size());
            System.out.println("Successful restorations: " + successCount);
            System.out.println("Failed restorations: " + failCount);
            System.out.println("=== END QUANTITY RESTORATION ===");

        } catch (Exception e) {
            System.out.println("Error restoring product quantities: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Handle customer email request from inforline table
     */
    private void handleCustomerEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String customerName = request.getParameter("name");
            String customerPhone = request.getParameter("phone");
            
            System.out.println("=== CUSTOMER EMAIL REQUEST ===");
            System.out.println("Looking for customer: " + customerName + " | Phone: " + customerPhone);
            
            if (customerName == null || customerPhone == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing name or phone parameter\"}");
                return;
            }
            
            // Get email from inforline table based on name and phone
            String email = hoaDonDAO.getCustomerEmailFromInforline(customerName, customerPhone);
            
            System.out.println("Found email: " + email);
            
            if (email != null && !email.isEmpty()) {
                response.getWriter().write("{\"email\":\"" + email + "\"}");
            } else {
                response.getWriter().write("{\"email\":\"Chưa có email\"}");
            }
            
        } catch (Exception e) {
            System.out.println("Error in handleCustomerEmail: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Server error: " + e.getMessage() + "\"}");
        }
    }
}
