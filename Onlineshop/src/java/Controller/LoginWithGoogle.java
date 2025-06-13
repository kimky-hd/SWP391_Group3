package Controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/LoginWithGoogle")
public class LoginWithGoogle extends HttpServlet {
    private static final String CLIENT_ID = "YOUR_CLIENT_ID";
    private static final String REDIRECT_URI = "http://localhost:8080/Onlineshop/LoginGoogleHandler";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String googleUrl = "https://accounts.google.com/o/oauth2/auth?" +
                "scope=email%20profile&" +
                "access_type=online&" +
                "include_granted_scopes=true&" +
                "response_type=code&" +
                "redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8") + "&" +
                "client_id=" + CLIENT_ID;

        response.sendRedirect(googleUrl);
    }
}
