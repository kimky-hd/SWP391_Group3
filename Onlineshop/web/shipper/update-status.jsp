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
        // 2 -> 3 -> 4 or 10 (with note for cancellation)
        HoaDon order = hoaDonDAO.getOrderById(orderId);
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("Order not found");
            return;
        }
        
        int currentStatus = order.getStatusID();
        boolean isValidTransition = false;
        
        // Shipper can make these transitions:
        // 2 (Approved) ->  3 (Shipping) 
        // 3 (Shipping) -> 4 (Delivered) or 10 (Cancelled)
        // Any status -> 10 (Cancelled) - with note
        
        switch (currentStatus) {
            case 2: // Approved and ready for shipping
                isValidTransition = (statusId == 3 || statusId == 10);
                break;
            case 3: // Shipping
                isValidTransition = (statusId == 4 || statusId == 10);
                break;
            case 4: // Delivered
            case 10: // Failed
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
        
        // If status is 10 (cancelled), note is required
        if (statusId == 10 && (note == null || note.trim().isEmpty())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("Cancellation reason is required");
            return;
        }
        
        boolean success;
        if (statusId == 10) {
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
