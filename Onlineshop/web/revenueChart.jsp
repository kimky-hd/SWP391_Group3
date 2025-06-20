<%@ page import="java.util.*, Model.RevenueByMonth" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo doanh thu</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Thêm Chart.js -->
</head>
<body>
    <h2>Báo cáo doanh thu theo tháng</h2>

    <!-- Bảng doanh thu -->
    <table border="1" cellpadding="10" cellspacing="0">
        <thead>
            <tr>
                <th>Tháng</th>
                <th>Doanh thu (VNĐ)</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<RevenueByMonth> list = (List<RevenueByMonth>) request.getAttribute("revenueList");
                for (RevenueByMonth r : list) {
            %>
            <tr>
                <td>Tháng <%= r.getMonth() %></td>
                <td><%= String.format("%,.0f", r.getRevenue()) %> VNĐ</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <!-- Biểu đồ doanh thu -->
    <h3>Biểu đồ doanh thu theo tháng</h3>
    <canvas id="revenueChart" width="800" height="400"></canvas> <!-- Chỗ hiển thị biểu đồ -->

    <script>
        var ctx = document.getElementById('revenueChart').getContext('2d');
        var revenueChart = new Chart(ctx, {
            type: 'bar', // Loại biểu đồ (cột)
            data: {
                labels: [<%
                    for (RevenueByMonth r : list) {
                        out.print("'Tháng " + r.getMonth() + "',");
                    }
                %>], // Nhãn của các cột
                datasets: [{
                    label: 'Doanh thu',
                    data: [<%
                        for (RevenueByMonth r : list) {
                            out.print(r.getRevenue() + ",");
                        }
                    %>], // Dữ liệu doanh thu của từng tháng
                    backgroundColor: 'rgba(54, 162, 235, 0.2)', // Màu nền của các cột
                    borderColor: 'rgba(54, 162, 235, 1)', // Màu viền của các cột
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
