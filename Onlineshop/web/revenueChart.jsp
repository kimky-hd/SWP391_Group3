<%@ page import="java.util.*, Model.RevenueByMonth, Model.RevenueByProduct, Model.RevenueByCustomer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo doanh thu</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 40px 20px;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 40px;
            font-size: 2.8em;
            letter-spacing: 1px;
            text-transform: uppercase;
            border-bottom: 3px solid #3498db;
            padding-bottom: 20px;
            display: inline-block;
            width: 100%;
            box-sizing: border-box;
        }

        h2 {
            color: #34495e;
            margin-top: 35px;
            margin-bottom: 20px;
            font-size: 1.8em;
            padding-left: 10px;
            border-left: 5px solid #2ecc71;
        }

        /* Total Revenue Section */
        .total-revenue-card {
            background-color: #e0f7fa; /* Light blue */
            color: #00796b; /* Darker teal for text */
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .total-revenue-card strong {
            font-size: 3em;
            font-weight: 700;
            display: block;
            margin-top: 10px;
            color: #004d40; /* Even darker teal */
        }

        /* Table styles */
        table {
            width: 100%;
            border-collapse: separate; /* For rounded corners */
            border-spacing: 0;
            margin-bottom: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden; /* Ensures rounded corners are visible */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #4a69bd; /* Dark blue header */
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.95em;
            letter-spacing: 0.5px;
        }

        /* Rounded corners for table headers */
        th:first-child {
            border-top-left-radius: 10px;
        }

        th:last-child {
            border-top-right-radius: 10px;
        }

        tr:nth-child(even) {
            background-color: #f8f8f8;
        }

        tr:hover {
            background-color: #f1f1f1;
            transition: background-color 0.2s ease;
        }

        /* Specific styling for financial data columns */
        td:nth-child(even), td:last-child {
            text-align: right; /* Align numbers to the right */
            font-weight: 500;
            color: #0056b3; /* A nice blue for numbers */
        }

        /* Media Queries for Responsiveness */
        @media (max-width: 768px) {
            body {
                padding: 20px 10px;
            }
            .container {
                padding: 20px;
            }
            h1 {
                font-size: 2em;
                margin-bottom: 30px;
            }
            h2 {
                font-size: 1.5em;
            }
            .total-revenue-card strong {
                font-size: 2.5em;
            }
            table, thead, tbody, th, td, tr {
                display: block;
            }
            thead tr {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }
            tr {
                border: 1px solid #ccc;
                border-radius: 8px;
                margin-bottom: 15px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }
            td {
                border: none;
                position: relative;
                padding-left: 50%;
                text-align: right;
            }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                width: calc(50% - 20px);
                padding-right: 10px;
                white-space: nowrap;
                text-align: left;
                font-weight: bold;
                color: #555;
            }
            td:first-of-type {
                border-top-left-radius: 8px;
                border-top-right-radius: 8px;
            }
            td:last-of-type {
                border-bottom-left-radius: 8px;
                border-bottom-right-radius: 8px;
                border-bottom: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>BÁO CÁO DOANH THU</h1>

        <h2>Tổng doanh thu</h2>
        <div class="total-revenue-card">
            <p>Tổng doanh thu từ tất cả các hoạt động:</p>
            <%
                Double totalRevenue = (Double) request.getAttribute("totalRevenue");
            %>
            <strong><%= String.format("%,.0f", totalRevenue) %> VNĐ</strong>
        </div>

        <h2>Doanh thu theo tháng</h2>
        <%
            List<RevenueByMonth> monthList = (List<RevenueByMonth>) request.getAttribute("revenueList");
        %>
        <table>
            <thead>
                <tr>
                    <th>Tháng</th>
                    <th>Doanh thu (VNĐ)</th>
                </tr>
            </thead>
            <tbody>
                <% if (monthList != null && !monthList.isEmpty()) { %>
                    <% for (RevenueByMonth r : monthList) { %>
                    <tr>
                        <td data-label="Tháng">Tháng <%= r.getMonth() %></td>
                        <td data-label="Doanh thu (VNĐ)"><%= String.format("%,.0f", r.getRevenue()) %></td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="2" style="text-align: center; color: #777;">Không có dữ liệu doanh thu theo tháng.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <h2>Doanh thu theo sản phẩm</h2>
        <%
            List<RevenueByProduct> productList = (List<RevenueByProduct>) request.getAttribute("productRevenueList");
        %>
        <table>
            <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng đã bán</th>
                    <th>Doanh thu (VNĐ)</th>
                </tr>
            </thead>
            <tbody>
                <% if (productList != null && !productList.isEmpty()) { %>
                    <% for (RevenueByProduct p : productList) { %>
                    <tr>
                        <td data-label="Tên sản phẩm"><%= p.getTitle() %></td>
                        <td data-label="Số lượng đã bán"><%= p.getTotalSold() %></td>
                        <td data-label="Doanh thu (VNĐ)"><%= String.format("%,.0f", p.getTotalRevenue()) %></td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="3" style="text-align: center; color: #777;">Không có dữ liệu doanh thu theo sản phẩm.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <h2>Doanh thu theo khách hàng</h2>
        <%
            List<RevenueByCustomer> customerList = (List<RevenueByCustomer>) request.getAttribute("customerRevenueList");
        %>
        <table>
            <thead>
                <tr>
                    <th>Tên đăng nhập</th>
                    <th>Họ tên</th>
                    <th>Tổng chi tiêu (VNĐ)</th>
                </tr>
            </thead>
            <tbody>
                <% if (customerList != null && !customerList.isEmpty()) { %>
                    <% for (RevenueByCustomer c : customerList) { %>
                    <tr>
                        <td data-label="Tên đăng nhập"><%= c.getUsername() %></td>
                        <td data-label="Họ tên"><%= c.getFullName() %></td>
                        <td data-label="Tổng chi tiêu (VNĐ)"><%= String.format("%,.0f", c.getTotalSpent()) %></td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="3" style="text-align: center; color: #777;">Không có dữ liệu doanh thu theo khách hàng.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <h2>Thống kê đơn hàng theo trạng thái</h2>
        <%
            Map<String, Integer> statusMap = (Map<String, Integer>) request.getAttribute("orderStatusSummary");
        %>
        <table>
            <thead>
                <tr>
                    <th>Trạng thái</th>
                    <th>Số đơn hàng</th>
                </tr>
            </thead>
            <tbody>
                <% if (statusMap != null && !statusMap.isEmpty()) { %>
                    <% for (Map.Entry<String, Integer> entry : statusMap.entrySet()) { %>
                    <tr>
                        <td data-label="Trạng thái"><%= entry.getKey() %></td>
                        <td data-label="Số đơn hàng"><%= entry.getValue() %></td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="2" style="text-align: center; color: #777;">Không có dữ liệu thống kê trạng thái đơn hàng.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>