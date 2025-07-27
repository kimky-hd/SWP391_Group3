package Utils;

import jakarta.servlet.http.Part;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {
    
    private static final String UPLOAD_DIR = "img/uploads/delivery_evidence/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};
    
    /**
     * Save uploaded file and return the file path
     * @param filePart The uploaded file part
     * @param contextPath The application context path
     * @return The relative path of the saved file
     * @throws IOException If file saving fails
     */
    public static String saveFile(Part filePart, String contextPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        // Check file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 5MB");
        }
        
        // Get original filename and validate extension
        String originalFileName = getFileName(filePart);
        if (originalFileName == null || !isValidFileExtension(originalFileName)) {
            throw new IOException("Invalid file type. Only JPG, JPEG, PNG, and GIF files are allowed");
        }
        
        // Generate unique filename
        String fileExtension = getFileExtension(originalFileName);
        String uniqueFileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + fileExtension;
        
        // Create upload directory if it doesn't exist
        String realContextPath = contextPath.replace("\\build\\web", "\\web");
        String uploadPath = realContextPath + File.separator + UPLOAD_DIR;
        Path uploadDir = Paths.get(uploadPath);
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }
        
        // Save file
        String filePath = uploadPath + uniqueFileName;
        try (InputStream input = filePart.getInputStream();
             FileOutputStream output = new FileOutputStream(filePath)) {
            
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
        
        // Return relative path for database storage
        return UPLOAD_DIR + uniqueFileName;
    }
    
    /**
     * Get filename from Part header
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                    return fileName.isEmpty() ? null : fileName;
                }
            }
        }
        return null;
    }
    
    /**
     * Get file extension from filename
     */
    private static String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(lastDotIndex) : "";
    }
    
    /**
     * Check if file extension is allowed
     */
    private static boolean isValidFileExtension(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (allowedExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Delete file if it exists
     */
    public static boolean deleteFile(String filePath, String contextPath) {
        if (filePath == null || filePath.isEmpty()) {
            return true;
        }
        
        try {
            String realContextPath = contextPath.replace("\\build\\web", "\\web");
            String fullPath = realContextPath + File.separator + filePath;
            Path path = Paths.get(fullPath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            System.err.println("Error deleting file: " + e.getMessage());
            return false;
        }
    }
}
