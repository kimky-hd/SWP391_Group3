<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.HoaDonDAO" %>
<%@ page import="Model.HoaDon" %>
<%@ page import="Model.Account" %>

<%
    // Check authentication
    Account account = (Account) session.getAttribute("account");
    if (account == null || account.getRole() != 3) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        out.print("Unauthorized access");
        return;
    }
    
    // Handle POST request only
    if (!"POST".equals(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        out.print("Method not allowed");
        return;
    }

    try {
        String orderIdParam = request.getParameter("orderId");
        String statusIdParam = request.getParameter("statusId");
        String note = request.getParameter("note"); // For cancellation reason
        
        if (orderIdParam == null || statusIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Missing required parameters");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        int statusId = Integer.parseInt(statusIdParam);
        
        HoaDonDAO hoaDonDAO = new HoaDonDAO();
        
        // Validate status transitions for shipper
        // 2 -> 9 -> 3 -> 4 or 6 (with note for cancellation)
        HoaDon order = hoaDonDAO.getOrderById(orderId);
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("Order not found");
            return;
        }
        
        int currentStatus = order.getStatusID();
        boolean isValidTransition = false;
        
        // Shipper can make these transitions:
        // 2 (Approved) -> 9 (Ready to ship) or 3 (Shipping) or 6 (Cancelled)
        // 9 (Ready to ship) -> 3 (Shipping) or 6 (Cancelled)
        // 3 (Shipping) -> 4 (Delivered) or 6 (Cancelled)
        // Any status -> 6 (Cancelled) - with note
        
        switch (currentStatus) {
            case 2: // Approved and ready for packaging
                isValidTransition = (statusId == 9 || statusId == 3 || statusId == 6);
                break;
            case 9: // Ready to ship
                isValidTransition = (statusId == 3 || statusId == 6);
                break;
            case 3: // Shipping
                isValidTransition = (statusId == 4 || statusId == 6);
                break;
            case 4: // Delivered
            case 6: // Cancelled
                isValidTransition = false; // No further transitions allowed
                break;
            default:
                isValidTransition = false;
        }
        
        if (!isValidTransition) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Invalid status transition");
            return;
        }
        
        // If status is 6 (cancelled), note is required
        if (statusId == 6 && (note == null || note.trim().isEmpty())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Cancellation reason is required");
            return;
        }
        
        boolean success;
        if (statusId == 6) {
            // Update with note for cancellation
            success = hoaDonDAO.updateOrderStatusWithNote(orderId, statusId, note);
        } else {
            // Regular status update
            success = hoaDonDAO.updateOrderStatus(orderId, statusId);
        }
        
        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("Status updated successfully");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("Failed to update status");
        }
        
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("Invalid parameter format");
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("Server error: " + e.getMessage());
    }
%>
