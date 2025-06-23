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

    // 1. Doanh thu theo tháng
    List<RevenueByMonth> revenueList = dao.getRevenuePerMonth();
    request.setAttribute("revenueList", revenueList);

    // 2. Tổng doanh thu
    double totalRevenue = dao.getTotalRevenue();
    request.setAttribute("totalRevenue", totalRevenue);

    // 3. Doanh thu theo sản phẩm
    List<RevenueByProduct> productRevenueList = dao.getRevenueByProduct();
    request.setAttribute("productRevenueList", productRevenueList);

    // 4. Doanh thu theo khách hàng
    List<RevenueByCustomer> customerRevenueList = dao.getRevenueByCustomer();
    request.setAttribute("customerRevenueList", customerRevenueList);

    // 5. Thống kê đơn hàng theo trạng thái
    Map<String, Integer> statusSummary = dao.getOrderStatusSummary();
    request.setAttribute("orderStatusSummary", statusSummary);

    // 6. Forward sang JSP
    request.getRequestDispatcher("revenueChart.jsp").forward(request, response);
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
