package Controller.Shipper;

import DAO.HoaDonDAO;
import DAO.ProductBatchDAO;
import DAO.OrderDetailDAO;
import Model.HoaDon;
import Model.Status;
import Model.Account;
import Model.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Shipper Controller for managing orders that need to be shipped
 */
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
            // Get summary data for dashboard
            int approvedOrders = hoaDonDAO.getTotalOrdersByStatus(2, null); // Approved and ready for packaging
            int readyToShip = hoaDonDAO.getTotalOrdersByStatus(9, null); // Ready to ship
            int shipping = hoaDonDAO.getTotalOrdersByStatus(3, null); // Shipping
            int delivered = hoaDonDAO.getTotalOrdersByStatus(4, null); // Delivered
            int cancelled = hoaDonDAO.getTotalOrdersByStatus(6, null); // Cancelled

            // Get recent orders (status 2, 9, 3, 4, 6)
            List<HoaDon> recentOrders = hoaDonDAO.getOrdersByMultipleStatusForShipper(new int[]{2, 9, 3, 4, 6});

            // Set attributes
            request.setAttribute("approvedOrders", approvedOrders);
            request.setAttribute("readyToShip", readyToShip);
            request.setAttribute("shipping", shipping);
            request.setAttribute("delivered", delivered);
            request.setAttribute("cancelled", cancelled);
            request.setAttribute("recentOrders", recentOrders);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/shipper/shipper_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/shipper/shipper_dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handle order status update
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Debug: Print all request parameters
            System.out.println("=== handleUpdateStatus Debug ===");
            System.out.println("Request method: " + request.getMethod());
            System.out.println("Content type: " + request.getContentType());
            System.out.println("All parameters:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println("  " + key + ": " + String.join(", ", values));
            });

            String orderIdParam = request.getParameter("orderId");
            String statusIdParam = request.getParameter("statusId");
            String note = request.getParameter("note"); // For cancellation reason

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
            // 2 -> 9 -> 3 -> 4 or 6 (with note for cancellation)
            if (!isValidStatusTransition(orderId, statusId)) {
                System.out.println("Invalid status transition - returning 400");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid status transition");
                return;
            }

            // If status is 6 (cancelled), note is required
            if (statusId == 6 && (note == null || note.trim().isEmpty())) {
                System.out.println("Cancellation reason required - returning 400");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Cancellation reason is required");
                return;
            }

            boolean success;
            if (statusId == 6) {
                System.out.println("Cancelling order " + orderId + " - will restore product quantities");
                // When cancelling order, restore product quantities FIRST
                restoreProductQuantities(orderId);
                // Then update order status with note
                success = hoaDonDAO.updateOrderStatusWithNote(orderId, statusId, note);
                System.out.println("Order status update result: " + success);
            } else {
                System.out.println("Regular status update for order " + orderId + " to status " + statusId);
                // Regular status update
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
     * Validate if the status transition is allowed for shipper New flow: 2 -> 9
     * -> 3 -> 4 or 6
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

            // Shipper can make these transitions:
            // 2 (Approved) -> 9 (Ready to ship)
            // 9 (Ready to ship) -> 3 (Shipping)
            // 3 (Shipping) -> 4 (Delivered) or 6 (Cancelled with note)
            // Only status 3 can be cancelled
            boolean isValid = false;
            switch (currentStatus) {
                case 2: // Approved and ready for packaging
                    isValid = newStatusId == 9; // Can only move to Ready to ship
                    // TEMPORARY: Allow direct transition from 2 to 3 for testing
                    if (newStatusId == 3) {
                        System.out.println("WARNING: Direct transition from status 2 to 3 detected - this should go through status 9");
                        isValid = true; // Allow for now, but log the issue
                    }
                    break;
                case 9: // Ready to ship
                    isValid = newStatusId == 3; // Can only move to Shipping
                    break;
                case 3: // Shipping
                    isValid = newStatusId == 4 || newStatusId == 6; // Can deliver or cancel
                    break;
                case 4: // Delivered
                case 6: // Cancelled
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

            // Get order items
            List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);
            System.out.println("Found " + orderDetails.size() + " order details");

            // Set attributes
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);

            // Check if this is an AJAX request (for modal)
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);

            if (isAjax) {
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
}
