package ManagerController;

import DAO.BannerDAO;
import Model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.List;

@WebServlet("/manager/banner")
@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
public class BannerManagementController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("list".equals(action)) {
            handleList(req, resp);
            return;
        } else if ("edit".equals(action)) {
            handleEdit(req, resp);
            return;
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        } else if ("activate".equals(action)) {
            handleActivate(req, resp);
            return;
        } else if ("deactivate".equals(action)) {
            handleDeactivate(req, resp);
            return;
        }
        // Default: show all
        handleListAll(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            handleAdd(req, resp);
        } else if ("edit".equals(action)) {
            handleUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/manager/banner");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BannerDAO dao = new BannerDAO();
        int page = 1;
        int pageSize = 5;
        if (req.getParameter("page") != null) {
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception e) { page = 1; }
        }
        int totalBanners = dao.countAllBanners();
        int totalPages = (int) Math.ceil((double) totalBanners / pageSize);
        List<Banner> banners = dao.getBannersByPage(page, pageSize);
        req.setAttribute("banners", banners);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.getRequestDispatcher("/manager/banner.jsp").forward(req, resp);
    }

    private void handleListAll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BannerDAO dao = new BannerDAO();
        List<Banner> banners = dao.getAllBanners();
        req.setAttribute("banners", banners);
        req.getRequestDispatcher("/manager/banner.jsp").forward(req, resp);
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BannerDAO dao = new BannerDAO();
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Banner banner = null;
            for (Banner b : dao.getAllBanners()) {
                if (b.getBannerID() == id) {
                    banner = b;
                    break;
                }
            }
            req.setAttribute("editBanner", banner);
        }
        handleListAll(req, resp);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BannerDAO dao = new BannerDAO();
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            dao.deleteBanner(id);
        }
        resp.sendRedirect(req.getContextPath() + "/manager/banner?action=list");
    }

    private void handleActivate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BannerDAO dao = new BannerDAO();
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            dao.setActive(id, true);
        }
        resp.sendRedirect(req.getContextPath() + "/manager/banner?action=list");
    }

    private void handleDeactivate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BannerDAO dao = new BannerDAO();
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            dao.setActive(id, false);
        }
        resp.sendRedirect(req.getContextPath() + "/manager/banner?action=list");
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        BannerDAO dao = new BannerDAO();
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String link = req.getParameter("link");
        String displayOrderStr = req.getParameter("displayOrder");
        int displayOrder = 1;
        try { displayOrder = Integer.parseInt(displayOrderStr); } catch (Exception e) {}
        boolean isActive = req.getParameter("isActive") != null;
        String imageFileName = null;
        Part imagePart = req.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String submittedFileName = imagePart.getSubmittedFileName();
            imageFileName = System.currentTimeMillis() + "_" + submittedFileName;
            String uploadPath = req.getServletContext().getRealPath("/img/") + imageFileName;
            imagePart.write(uploadPath);
        }
        Banner b = new Banner(0, title, imageFileName, description, link, isActive, displayOrder);
        dao.addBanner(b);
        resp.sendRedirect(req.getContextPath() + "/manager/banner?action=list");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        BannerDAO dao = new BannerDAO();
        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String link = req.getParameter("link");
        String displayOrderStr = req.getParameter("displayOrder");
        int displayOrder = 1;
        try { displayOrder = Integer.parseInt(displayOrderStr); } catch (Exception e) {}
        boolean isActive = req.getParameter("isActive") != null;
        String imageFileName = null;
        Part imagePart = req.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String submittedFileName = imagePart.getSubmittedFileName();
            imageFileName = System.currentTimeMillis() + "_" + submittedFileName;
            String uploadPath = req.getServletContext().getRealPath("/img/") + imageFileName;
            imagePart.write(uploadPath);
        }
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Banner old = null;
            for (Banner b : dao.getAllBanners()) {
                if (b.getBannerID() == id) { old = b; break; }
            }
            if (old != null) {
                String img = (imageFileName != null) ? imageFileName : old.getImage();
                Banner b = new Banner(id, title, img, description, link, isActive, displayOrder);
                dao.updateBanner(b);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/manager/banner?action=list");
    }
} 