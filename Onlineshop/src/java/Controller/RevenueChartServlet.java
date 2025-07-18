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

        // 2. Tổng doanh thu
        double totalRevenue = dao.getTotalRevenue();
        request.setAttribute("totalRevenue", totalRevenue);

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

        // 6. Forward sang JSP
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
