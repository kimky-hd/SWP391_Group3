package Utility;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class GoogleUtils {
    private static final Properties config = loadConfig();

    private static Properties loadConfig() {
        Properties props = new Properties();
        try (InputStream input = GoogleUtils.class.getClassLoader().getResourceAsStream("Utility/config.properties")) {
            props.load(input);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return props;
    }

    private static final String GOOGLE_CLIENT_ID = config.getProperty("google.client.id");
    private static final String GOOGLE_CLIENT_SECRET = config.getProperty("google.client.secret");
    private static final String GOOGLE_REDIRECT_URI = config.getProperty("google.redirect.uri");
    private static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    private static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    private static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static String getGoogleLoginUrl() {
        return "https://accounts.google.com/o/oauth2/auth?"
                + "client_id=" + GOOGLE_CLIENT_ID
                + "&redirect_uri=" + GOOGLE_REDIRECT_URI
                + "&response_type=code"
                + "&scope=email%20profile";
    }

    public static String getToken(String code) throws IOException, ParseException {
        String urlParameters = "code=" + code
                + "&client_id=" + GOOGLE_CLIENT_ID
                + "&client_secret=" + GOOGLE_CLIENT_SECRET
                + "&redirect_uri=" + GOOGLE_REDIRECT_URI
                + "&grant_type=" + GOOGLE_GRANT_TYPE;

        URL url = new URL(GOOGLE_LINK_GET_TOKEN);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        connection.setDoOutput(true);
        connection.getOutputStream().write(urlParameters.getBytes());

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            JSONParser parser = new JSONParser();
            JSONObject jsonObject = (JSONObject) parser.parse(response.toString());
            return (String) jsonObject.get("access_token");
        }
    }

    public static JSONObject getUserInfo(String accessToken) throws IOException, ParseException {
        URL url = new URL(GOOGLE_LINK_GET_USER_INFO + accessToken);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            JSONParser parser = new JSONParser();
            return (JSONObject) parser.parse(response.toString());
        }
    }
}
