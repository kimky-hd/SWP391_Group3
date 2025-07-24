package ManagerController;

import DAO.CardTemplateDAO;
import Model.Account;
import Model.CardTemplate;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CardTemplateManagementController", urlPatterns = {"/manager/cardtemplates"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CardTemplateManagementController extends HttpServlet {

    private CardTemplateDAO cardDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        cardDAO = new CardTemplateDAO();
        gson = new Gson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkManagerAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                handleListCards(request, response);
                break;
            case "edit":
                handleEditCard(request, response);
                break;
            case "create":
                request.getRequestDispatcher("/Manager_CreateCardTemplate.jsp").forward(request, response);
                break;
            default:
                handleListCards(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkManagerAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "create":
                handleCreateCard(request, response);
                break;
            case "update":
                handleUpdateCard(request, response);
                break;
            case "delete":
                handleDeleteCard(request, response);
                break;
            case "activate":
                handleActivateCard(request, response);
                break;
            case "deactivate":
                handleDeactivateCard(request, response);
                break;
            default:
                handleListCards(request, response);
                break;
        }
    }

    private boolean checkManagerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() != 1) { // Role 1 is Manager
            session.setAttribute("message", "Bạn không có quyền truy cập chức năng này.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    private void handleListCards(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CardTemplate> cardTemplates = cardDAO.getAllActiveCardTemplates();
        request.setAttribute("cardTemplates", cardTemplates);
        request.getRequestDispatcher("/Manager_ListCardTemplate.jsp").forward(request, response);
    }

    private void handleEditCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cardId = Integer.parseInt(request.getParameter("cardId"));
            CardTemplate card = cardDAO.getCardTemplateById(cardId);
            if (card != null) {
                request.setAttribute("card", card);
                request.getRequestDispatcher("/Manager_UpdateCardTemplate.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy thiệp.");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "ID thiệp không hợp lệ.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        }
    }

    private void handleCreateCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cardName = request.getParameter("cardName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        Part imagePart = request.getPart("image"); // Get the image file

        String imageFileName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imageFileName = getFileName(imagePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            imagePart.write(uploadPath + File.separator + imageFileName);
        }

        CardTemplate newCard = new CardTemplate();
        newCard.setCardName(cardName);
        newCard.setDescription(description);
        newCard.setPrice(price);
        newCard.setImage(imageFileName);
        newCard.setIsActive(true); // New cards are active by default

        boolean success = cardDAO.addCardTemplate(newCard);
        
        if (success) {
            request.getSession().setAttribute("message", "Tạo thiệp thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Tạo thiệp thất bại.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
    }

    private void handleUpdateCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cardId = Integer.parseInt(request.getParameter("cardId"));
            String cardName = request.getParameter("cardName");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            Part imagePart = request.getPart("image"); // Get the new image file
            String existingImage = request.getParameter("existingImage"); // Hidden field for existing image
            boolean isActive = request.getParameter("isActive") != null;

            String imageFileName = existingImage; // Default to existing image
            if (imagePart != null && imagePart.getSize() > 0) {
                imageFileName = getFileName(imagePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                imagePart.write(uploadPath + File.separator + imageFileName);
            }

            CardTemplate cardToUpdate = new CardTemplate();
            cardToUpdate.setCardId(cardId);
            cardToUpdate.setCardName(cardName);
            cardToUpdate.setDescription(description);
            cardToUpdate.setPrice(price);
            cardToUpdate.setImage(imageFileName);
            cardToUpdate.setIsActive(isActive);

            boolean success = cardDAO.updateCardTemplate(cardToUpdate);

            if (success) {
                request.getSession().setAttribute("message", "Cập nhật thiệp thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Cập nhật thiệp thất bại.");
                request.getSession().setAttribute("messageType", "error");
            }
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "ID thiệp hoặc giá không hợp lệ.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        }
    }

    private void handleDeleteCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cardId = Integer.parseInt(request.getParameter("cardId"));
            boolean success = cardDAO.deleteCardTemplate(cardId);

            if (success) {
                request.getSession().setAttribute("message", "Xóa thiệp thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Xóa thiệp thất bại.");
                request.getSession().setAttribute("messageType", "error");
            }
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "ID thiệp không hợp lệ.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        }
    }

    private void handleActivateCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cardId = Integer.parseInt(request.getParameter("cardId"));
            boolean success = cardDAO.updateCardTemplateStatus(cardId, true);

            if (success) {
                request.getSession().setAttribute("message", "Kích hoạt thiệp thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Kích hoạt thiệp thất bại.");
                request.getSession().setAttribute("messageType", "error");
            }
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "ID thiệp không hợp lệ.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        }
    }

    private void handleDeactivateCard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int cardId = Integer.parseInt(request.getParameter("cardId"));
            boolean success = cardDAO.updateCardTemplateStatus(cardId, false);

            if (success) {
                request.getSession().setAttribute("message", "Vô hiệu hóa thiệp thành công!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Vô hiệu hóa thiệp thất bại.");
                request.getSession().setAttribute("messageType", "error");
            }
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "ID thiệp không hợp lệ.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/manager/cardtemplates");
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
