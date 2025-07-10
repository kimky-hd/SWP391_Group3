# Shipper Management System

## Overview
This is a comprehensive shipper management system for the online flower shop application. The system allows shippers to view, manage, and update the status of orders that are ready for delivery.

## Features
- **Dashboard**: Overview of orders ready to ship, currently shipping, and delivered
- **Order Management**: Full list of orders with pagination, search, and filtering
- **Status Updates**: Real-time status updates for order progression
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Auto-refresh**: Automatic page refresh to keep data current

## Files Created/Modified

### Model Classes
1. **`src/java/Model/HoaDon.java`** - Main order model class with all order details
2. **`src/java/Model/Status.java`** - Order status model

### DAO Classes
1. **`src/java/DAO/HoaDonDAO.java`** - Database operations for orders
   - Get orders by status with pagination
   - Search and filter functionality
   - Order status updates
   - Customer information retrieval

### Controller Classes
1. **`src/java/Controller/ShipperController.java`** - Main controller for shipper operations
   - Handles GET requests for dashboard and order list
   - Handles POST requests for status updates
   - Role-based access control

### JSP Pages
1. **`web/shipper_dashboard.jsp`** - Shipper dashboard page
2. **`web/shipper_orders.jsp`** - Orders management page with full CRUD operations

### CSS Files
1. **`web/css/shipper-style.css`** - Enhanced with shipper-specific styles

### JavaScript Files
1. **`web/js/shipper-script.js`** - Enhanced with order management functions
2. **`web/js/mobile-navigation.js`** - Enhanced with utility functions  
3. **`web/js/shipper-dashboard.js`** - Dashboard-specific functionality
4. **`web/js/shipper-orders.js`** - Orders page functionality
5. **`web/js/topbar-navigation.js`** - Navigation highlighting and tooltips management

## Database Schema
The system uses the following database tables:
- `hoadon` - Main orders table
- `account` - User accounts
- `status` - Order status definitions
- `inforline` - Customer delivery information

## URL Patterns
- `/shipper/dashboard` - Shipper dashboard
- `/shipper/orders` - Orders list with pagination and search
- `/shipper/update-status` - AJAX endpoint for status updates

## Order Status Flow
1. **Status ID 1**: Chờ duyệt (Pending Approval)
2. **Status ID 2**: Đơn hàng đã được duyệt và tiến hành đóng gói (Approved & Packaging)
3. **Status ID 3**: Đơn hàng đang được vận chuyển (Shipping)
4. **Status ID 4**: Đã giao hàng thành công (Delivered)
5. **Status ID 9**: Sẵn sàng giao (Ready to Ship)

## Access Control
- Only users with `role = 3` (Shipper) can access shipper pages
- Automatic redirect to login page for unauthorized users
- Session-based authentication

## Features Implemented

### Dashboard Features
- Statistics cards showing order counts by status
- Quick action buttons for common operations
- Recent orders table with inline status updates
- Real-time status indicators

### Order Management Features
- **Pagination**: Configurable page size (10, 20, 50 items)
- **Search**: Search by order ID, customer name, phone, email
- **Filter**: Filter by order status
- **Sort**: Orders sorted by creation date (newest first)
- **Status Updates**: One-click status updates with confirmation
- **Responsive Table**: Mobile-friendly table design

### Technical Features
- **AJAX Operations**: Status updates without page refresh
- **Toast Notifications**: User-friendly success/error messages
- **Auto-refresh**: Automatic page refresh every 5 minutes
- **Keyboard Shortcuts**: Ctrl+F for search, Escape to close modals
- **Tooltips**: Helpful tooltips on action buttons
- **Loading States**: Visual feedback during operations
- **Separated JavaScript**: All JavaScript code extracted to external files
- **Modular Architecture**: Each page has its own dedicated JS file

### JavaScript Architecture
- **`topbar-navigation.js`**: Handles active navigation highlighting and tooltips
- **`shipper-dashboard.js`**: Dashboard-specific functionality and statistics
- **`shipper-orders.js`**: Orders page functionality including filters and pagination
- **`shipper-script.js`**: Common shipper utilities and shared functions
- **`mobile-navigation.js`**: Mobile responsive navigation features

All JavaScript is properly separated from JSP files for better maintainability and performance.

## Installation & Setup

1. **Database Setup**: Ensure your database has the required tables from `SQL.sql`

2. **Server Configuration**: Make sure your server supports:
   - Jakarta Servlet API
   - MySQL connectivity
   - JSP and JSTL

3. **Dependencies**: Add these JARs to your classpath:
   - `mysql-connector-j-9.3.0.jar`
   - `jakarta.servlet.jsp.jstl-2.0.0.jar`
   - `jakarta.servlet.jsp.jstl-api-2.0.0.jar`

4. **Database Connection**: Update `DAO/DBContext.java` with your database credentials

5. **Deploy**: Deploy the application to your servlet container

## Usage

### For Shippers
1. Login with shipper credentials (role = 3)
2. Access the dashboard at `/shipper/dashboard`
3. View orders at `/shipper/orders`
4. Update order status by clicking action buttons
5. Use search and filter to find specific orders

### For Administrators
1. Create shipper accounts with role = 3
2. Monitor shipper activities through the system
3. Manage order statuses and workflow

## API Endpoints

### GET `/shipper/dashboard`
Returns shipper dashboard with order statistics

### GET `/shipper/orders`
Returns paginated list of orders with search and filter options

Parameters:
- `page`: Page number (default: 1)
- `pageSize`: Items per page (default: 10)
- `search`: Search keyword
- `status`: Status ID filter

### POST `/shipper/update-status`
Updates order status

Parameters:
- `orderId`: Order ID to update
- `statusId`: New status ID

## Security Features
- Role-based access control
- Session validation
- CSRF protection via proper form handling
- SQL injection prevention via prepared statements

## Future Enhancements
- Real-time notifications
- GPS tracking integration
- Delivery route optimization
- Photo proof of delivery
- Customer rating system
- Bulk operations for multiple orders
- Export functionality for reports
- Integration with delivery services

## Troubleshooting

### Common Issues

1. **Import Errors**: If you see servlet import errors, ensure you have the Jakarta Servlet API in your classpath

2. **Database Connection**: If database connection fails, check your MySQL credentials in `DBContext.java`

3. **Role Access**: If access is denied, ensure the user has role = 3 in the database

4. **Page Not Loading**: Check that all JSP files are in the correct `web/` directory

### Database Issues
- Ensure `flowershopdb` database exists
- Check that all tables are created with correct schema
- Verify foreign key constraints are properly set

## Support
For issues or questions, please check:
1. Server logs for error messages
2. Browser console for JavaScript errors
3. Database connection status
4. User role assignments

This system provides a complete shipper management solution with modern UI/UX design and robust functionality for managing order deliveries in the flower shop application.
