package Controller;

import DAO.AddressDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AddressController", urlPatterns = {"/address"})
public class AddressController extends HttpServlet {

    private final Gson gson = new Gson();
    private final AddressDAO addressDAO = new AddressDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "getCities":
                    List<Map<String, Object>> cities = addressDAO.getCities();
                    response.getWriter().write(gson.toJson(cities));
                    break;

                case "getDistricts":
                    String cityId = request.getParameter("cityId");
                    if (cityId != null) {
                        List<Map<String, Object>> districts = addressDAO.getDistricts(cityId);
                        response.getWriter().write(gson.toJson(districts));
                    }
                    break;

                case "getWards":
                    String districtId = request.getParameter("districtId");
                    if (districtId != null) {
                        List<Map<String, Object>> wards = addressDAO.getWards(districtId);
                        response.getWriter().write(gson.toJson(wards));
                    }
                    break;
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
