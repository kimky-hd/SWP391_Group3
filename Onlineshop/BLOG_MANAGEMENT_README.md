# Hệ thống Quản lý Blog cho Staff

## Tổng quan
Hệ thống quản lý blog được thiết kế cho nhân viên (Staff) có thể tạo, chỉnh sửa, và quản lý các bài viết blog với nhiều ảnh.

## Cấu trúc Database

### Bảng `blog`
- `blogID` (INT, AUTO_INCREMENT, PRIMARY KEY): ID duy nhất của blog
- `accountID` (INT, FOREIGN KEY): ID của tài khoản tạo blog
- `title` (VARCHAR(200)): Tiêu đề blog
- `content` (TEXT): Nội dung blog (dự phòng cho tương lai)
- `dateCreated` (DATETIME): Ngày tạo blog

### Bảng `blogImg`
- `blogImgID` (INT, AUTO_INCREMENT, PRIMARY KEY): ID duy nhất của ảnh
- `blogID` (INT, FOREIGN KEY): ID của blog chứa ảnh
- `image` (VARCHAR(255)): Đường dẫn đến file ảnh
- `IsMain` (TINYINT(1)): Đánh dấu ảnh chính (1 = chính, 0 = phụ)
- `datePosted` (DATETIME): Ngày thêm ảnh

## Cấu trúc Code

### Models
- `Model/Blog.java`: Model cho blog
- `Model/BlogImg.java`: Model cho ảnh blog

### DAO
- `DAO/BlogDAO.java`: Data Access Object cho blog và ảnh blog

### Controllers
- `Controller/staff/StaffBlogController.java`: Controller chính xử lý các thao tác blog
- `Controller/staff/BlogImageUploadServlet.java`: Servlet xử lý upload ảnh

### Views (JSP)
- `web/staff/blog-list.jsp`: Trang danh sách blog
- `web/staff/blog-create.jsp`: Trang tạo blog mới
- `web/staff/blog-edit.jsp`: Trang chỉnh sửa blog
- `web/staff/blog-detail.jsp`: Trang xem chi tiết blog

### CSS & JavaScript
- `web/css/staff-blog.css`: CSS riêng cho quản lý blog
- `web/js/staff-blog.js`: JavaScript riêng cho quản lý blog

## Chức năng

### Cho Staff (Role = 2)
1. **Xem danh sách blog**: Hiển thị tất cả blog với ảnh đại diện
2. **Tìm kiếm blog**: Tìm kiếm theo tiêu đề
3. **Tạo blog mới**: Tạo blog với tiêu đề
4. **Chỉnh sửa blog**: 
   - Cập nhật tiêu đề
   - Thêm/xóa ảnh
   - Đặt ảnh chính
5. **Xóa blog**: Xóa blog và tất cả ảnh liên quan
6. **Quản lý ảnh**:
   - Upload nhiều ảnh
   - Đặt ảnh chính
   - Xóa ảnh riêng lẻ

## URL Patterns

### Blog Management
- `GET /staff/blogs` - Danh sách blog
- `GET /staff/blogs?action=search&keyword=xyz` - Tìm kiếm blog
- `GET /staff/blog/new` - Form tạo blog mới
- `POST /staff/blogs` (action=create) - Tạo blog
- `GET /staff/blog/edit/{blogId}` - Form chỉnh sửa blog
- `POST /staff/blogs` (action=update) - Cập nhật blog
- `GET /staff/blog/view/{blogId}` - Xem chi tiết blog
- `GET /staff/blog/delete/{blogId}` - Xóa blog

### Image Management
- `POST /staff/upload-blog-image` - Upload ảnh
- `POST /staff/blogs` (action=addImage) - Thêm ảnh vào blog
- `POST /staff/blogs` (action=deleteImage) - Xóa ảnh
- `POST /staff/blogs` (action=setMainImage) - Đặt ảnh chính

## Cài đặt

### 1. Database Setup
```sql
-- Chạy file blog_management_setup.sql để tạo bảng và dữ liệu mẫu
source blog_management_setup.sql;
```

### 2. Thư mục Upload
Tạo thư mục `web/img/blog/` để lưu ảnh blog:
```bash
mkdir -p web/img/blog
chmod 755 web/img/blog
```

### 3. Dependencies
Đảm bảo có các thư viện:
- GSON (đã có trong lib/)
- Jakarta Servlet API
- MySQL Connector

### 4. Web.xml
Servlet đã được cấu hình với annotation, không cần thêm vào web.xml.

## Sử dụng

### Truy cập hệ thống
1. Đăng nhập với tài khoản Staff (role = 2)
2. Vào menu "Quản lý Blog" ở sidebar
3. Sử dụng các chức năng như tạo, sửa, xóa blog

### Upload ảnh
1. Vào trang chỉnh sửa blog
2. Kéo thả ảnh vào vùng upload hoặc click để chọn file
3. Ảnh sẽ được upload tự động
4. Click "Đặt làm ảnh chính" để chọn ảnh đại diện

### Tìm kiếm
1. Sử dụng ô tìm kiếm trên trang danh sách
2. Nhập từ khóa và click "Tìm kiếm"
3. Kết quả sẽ hiển thị các blog có tiêu đề chứa từ khóa

## Tính năng kỹ thuật

### Upload ảnh
- Hỗ trợ: JPG, JPEG, PNG, GIF
- Kích thước tối đa: 10MB/file
- Tên file tự động được đổi để tránh trùng lặp
- Lưu trong thư mục `web/img/blog/`

### Validation
- Tiêu đề blog: 5-200 ký tự
- Chỉ Staff mới có quyền truy cập
- Kiểm tra định dạng file ảnh

### Ajax & JavaScript
- Upload ảnh không reload trang
- Toast notifications
- Auto-save (dự phòng)
- Keyboard shortcuts (Ctrl+S, Ctrl+N)

### Responsive Design
- Tương thích mobile
- Grid layout cho ảnh
- Sidebar collapse trên mobile

## Troubleshooting

### Lỗi thường gặp
1. **"Không có quyền truy cập"**: Kiểm tra role = 2 trong session
2. **Upload ảnh thất bại**: Kiểm tra quyền thư mục `web/img/blog/`
3. **Lỗi database**: Kiểm tra kết nối và bảng đã tạo chưa

### Debug
- Kiểm tra console browser cho JavaScript errors
- Kiểm tra server logs cho Java exceptions
- Kiểm tra network tab cho AJAX requests

## Mở rộng tương lai

### Có thể thêm
1. **Rich text editor** cho nội dung blog
2. **Categories/Tags** cho blog
3. **Comments** từ khách hàng
4. **SEO optimization** (meta description, keywords)
5. **Social sharing** buttons
6. **Blog analytics** (views, likes)
7. **Schedule publishing** (đăng blog theo lịch)

### API endpoints
Có thể mở rộng thành REST API cho mobile app:
- `GET /api/blogs` - Lấy danh sách blog
- `POST /api/blogs` - Tạo blog mới
- `PUT /api/blogs/{id}` - Cập nhật blog
- `DELETE /api/blogs/{id}` - Xóa blog

## Liên hệ
Nếu có vấn đề hoặc cần hỗ trợ, vui lòng liên hệ team phát triển.
