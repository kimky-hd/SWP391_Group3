/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.RevenueDAO;
import Model.RevenueByCustomer;
import Model.RevenueByMonth;
import Model.RevenueByProduct;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RevenueChartServlet", urlPatterns = {"/revenue-chart"})
public class RevenueChartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RevenueDAO dao = new RevenueDAO();

        // Lấy giá trị tìm kiếm từ request (nếu có)
        String productSearch = request.getParameter("productSearch");
        String userSearch = request.getParameter("userSearch");
        String statusSearch = request.getParameter("statusSearch");

        // 1. Doanh thu theo tháng
        String monthParam = request.getParameter("selectedMonth"); // Đúng với name trong form
        int selectedMonth = 0;

        try {
            selectedMonth = (monthParam != null && !monthParam.isEmpty()) ? Integer.parseInt(monthParam) : 0;
        } catch (NumberFormatException e) {
            selectedMonth = 0;
        }

        List<RevenueByMonth> revenueList;
        if (selectedMonth > 0) {
            revenueList = dao.getRevenuePerMonthBySelectedMonth(selectedMonth); // lọc theo tháng
        } else {
            revenueList = dao.getRevenuePerMonth(); // tất cả tháng
        }

        request.setAttribute("revenueList", revenueList);
        request.setAttribute("selectedMonth", monthParam); // để giữ lại lựa chọn trong dropdown

        // 2. Tổng doanh thu (toàn bộ hoặc theo tháng)
        double totalRevenue;
        double totalImportCost;
        double totalDamagedCost;
        
        if (selectedMonth > 0) {
            // Tính theo tháng được chọn
            totalRevenue = dao.getTotalRevenueByMonth(selectedMonth);
            totalImportCost = dao.getTotalImportCostByMonth(selectedMonth);
            totalDamagedCost = dao.getTotalDamagedCostByMonth(selectedMonth);
        } else {
            // Tính tổng toàn bộ
            totalRevenue = dao.getTotalRevenue();
            Map<String, Object> importRevData = dao.getImportRevenue();
            totalImportCost = importRevData != null && importRevData.get("totalImport") != null ? 
                              (Double) importRevData.get("totalImport") : 0;
            Map<String, Object> damagedRevData = dao.getDamagedFlowerRevenue();
            totalDamagedCost = damagedRevData != null && damagedRevData.get("totalLoss") != null ? 
                               (Double) damagedRevData.get("totalLoss") : 0;
        }
        
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalImportCost", totalImportCost);
        request.setAttribute("totalDamagedCost", totalDamagedCost);
        
        // Tính lợi nhuận
        double profit = totalRevenue - totalImportCost - totalDamagedCost;
        double profitMargin = totalRevenue > 0 ? (profit / totalRevenue) * 100 : 0;
        double damageRate = totalImportCost > 0 ? (totalDamagedCost / totalImportCost) * 100 : 0;
        
        request.setAttribute("profit", profit);
        request.setAttribute("profitMargin", profitMargin);
        request.setAttribute("damageRate", damageRate);

        // 3. Doanh thu theo sản phẩm (nếu có tìm kiếm)
        List<RevenueByProduct> productRevenueList;
        if (productSearch != null && !productSearch.isEmpty()) {
            productRevenueList = dao.getRevenueByProductSearch(productSearch);
        } else {
            productRevenueList = dao.getRevenueByProduct();
        }
        request.setAttribute("productRevenueList", productRevenueList);

        // 4. Doanh thu theo khách hàng (nếu có tìm kiếm theo tên người dùng)
        List<RevenueByCustomer> customerRevenueList;
        if (userSearch != null && !userSearch.isEmpty()) {
            customerRevenueList = dao.getRevenueByCustomerSearch(userSearch);
        } else {
            customerRevenueList = dao.getRevenueByCustomer();
        }
        request.setAttribute("customerRevenueList", customerRevenueList);

        // 5. Thống kê đơn hàng theo trạng thái (nếu có tìm kiếm theo trạng thái)
        Map<String, Integer> statusSummary;
        if (statusSearch != null && !statusSearch.isEmpty()) {
            statusSummary = dao.getOrderStatusSummaryByStatus(statusSearch);
        } else {
            statusSummary = dao.getOrderStatusSummary();
        }
        request.setAttribute("orderStatusSummary", statusSummary);

        // Lấy danh sách trạng thái để hiển thị trong dropdown
        Map<String, Integer> statusMap = dao.getOrderStatusSummary();
        request.setAttribute("statusMap", statusMap);

        // 6. Doanh thu hoa thiệt hại
        Map<String, Object> damagedFlowerRevenue = dao.getDamagedFlowerRevenue();
        request.setAttribute("damagedFlowerRevenue", damagedFlowerRevenue);

        // 7. Doanh thu nhập hàng
        Map<String, Object> importRevenue = dao.getImportRevenue();
        request.setAttribute("importRevenue", importRevenue);

        // 8. Doanh thu nhập hàng theo tháng
        List<Map<String, Object>> importRevenueByMonth = dao.getImportRevenueByMonth();
        request.setAttribute("importRevenueByMonth", importRevenueByMonth);

        // 9. Doanh thu thiệt hại theo tháng
        List<Map<String, Object>> damagedRevenueByMonth = dao.getDamagedRevenueByMonth();
        request.setAttribute("damagedRevenueByMonth", damagedRevenueByMonth);

        // 10. Forward sang JSP
        request.getRequestDispatcher("/revenueChart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
