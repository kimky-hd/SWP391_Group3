package CommonController;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import javax.net.ssl.HttpsURLConnection;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class RecaptchaVerifier {
    private static final String RECAPTCHA_VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";
    private final String secretKey;
    
    public RecaptchaVerifier(String secretKey) {
        this.secretKey = secretKey;
    }
    
    public boolean verify(String recaptchaResponse, String remoteIp) {
        System.out.println("Verifying reCAPTCHA response: " + recaptchaResponse);
        if (recaptchaResponse == null || recaptchaResponse.isEmpty()) {
            return false;
        }
        
        try {
            URL url = new URL(RECAPTCHA_VERIFY_URL);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            
            String postParams = "secret=" + secretKey + "&response=" + recaptchaResponse;
            if (remoteIp != null && !remoteIp.isEmpty()) {
                postParams += "&remoteip=" + remoteIp;
            }
            
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();
            
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder responseSB = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                responseSB.append(inputLine);
            }
            in.close();

            String jsonResponse = responseSB.toString();
            System.out.println("Google response: " + jsonResponse);
            
            // Dùng Gson để parse JSON
            JsonObject jsonObject = JsonParser.parseString(jsonResponse).getAsJsonObject();
            return jsonObject.get("success").getAsBoolean();
            
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("Error connecting to Google reCAPTCHA: " + e.getMessage());
            return false;
        }
    }
}
