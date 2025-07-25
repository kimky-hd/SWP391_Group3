package Controller;

import DAO.ShipperDAO;
import Model.Shipper;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet để xử lý các yêu cầu liên quan đến phân công shipper
 */
@WebServlet(name = "ShipperAssignmentController", urlPatterns = {"/shipper-assignment"})
public class ShipperAssignmentController extends HttpServlet {

    private ShipperDAO shipperDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        shipperDAO = new ShipperDAO();
    }

    /**
     * Xử lý GET request để lấy danh sách shipper
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("getActiveShippers".equals(action)) {
                getActiveShippers(request, response);
            } else {
                // Action không hợp lệ
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Invalid action\"}");
                out.flush();
            }
        } catch (Exception e) {
            // Log lỗi
            System.err.println("Error in ShipperAssignmentController.doGet: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về lỗi 500
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Internal server error: " + e.getMessage() + "\"}");
            out.flush();
        }
    }

    /**
     * Lấy danh sách shipper đang hoạt động
     */
    private void getActiveShippers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            System.out.println("ShipperAssignmentController: Getting active shippers...");
            
            // Lấy danh sách shipper từ database
            List<Shipper> shippers = shipperDAO.getActiveShippers();
            
            System.out.println("ShipperAssignmentController: Found " + shippers.size() + " active shippers");
            
            // Convert sang JSON
            Gson gson = new Gson();
            String json = gson.toJson(shippers);
            
            System.out.println("ShipperAssignmentController: JSON response: " + json);
            
            // Trả về response
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
            
        } catch (Exception e) {
            System.err.println("Error getting active shippers: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Xử lý POST request (nếu cần thiết trong tương lai)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Hiện tại chưa có POST action nào
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        PrintWriter out = response.getWriter();
        out.print("{\"error\":\"POST method not supported yet\"}");
        out.flush();
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling shipper assignment operations";
    }
}