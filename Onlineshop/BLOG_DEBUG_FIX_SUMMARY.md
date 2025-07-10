# BLOG SYSTEM DEBUG & FIX SUMMARY

## Vấn đề đã xác định và sửa:

### 1. **SQL INSERT Statement Issue**
- **Vấn đề**: Câu SQL INSERT có thể conflict với DEFAULT value của blogStatus
- **Sửa**: Loại bỏ `blogStatus` khỏi INSERT statement vì đã có DEFAULT 'Pending' trong database
- **File**: `BlogDAO.java` - method `addBlog()`

### 2. **Main Image Logic Issue**  
- **Vấn đề**: Ảnh upload không được đặt làm main image
- **Sửa**: Kiểm tra nếu blog chưa có ảnh nào thì ảnh đầu tiên sẽ tự động thành main image
- **File**: `StaffBlogManager.java` - method `addBlogImage()`

### 3. **Image Preview JavaScript Issue**
- **Vấn đề**: Template literals (`${}`) không hoạt động trong JSP
- **Sửa**: Thay thế bằng string concatenation
- **File**: `blog-create.jsp` - function `previewImages()`

### 4. **Missing Bootstrap JS**
- **Vấn đề**: Thiếu Bootstrap JavaScript cho modal và components
- **Sửa**: Thêm Bootstrap JS CDN
- **File**: `blog-create.jsp`

### 5. **Enhanced Debug Logging**
- **Thêm**: Debug logging vào tất cả methods quan trọng để tracking flow
- **Files**: `BlogDAO.java`, `StaffBlogManager.java`, `blog-create.jsp`

## Các file đã sửa đổi:

### 1. `BlogDAO.java`
```java
// Sửa addBlog method - loại bỏ blogStatus từ INSERT
String sql = "INSERT INTO blog (accountID, title, content, dateCreated) VALUES (?, ?, ?, NOW())";

// Thêm debug logging cho addBlog và addBlogImage
```

### 2. `StaffBlogManager.java` 
```java
// Sửa addBlogImage để tự động set main image cho ảnh đầu tiên
List<BlogImg> existingImages = blogDAO.getBlogImages(blogId);
if (existingImages.isEmpty()) {
    blogImg.setMain(true);
}
```

### 3. `blog-create.jsp`
```javascript
// Sửa template literals thành string concatenation
preview.innerHTML = 
    '<img src="' + e.target.result + '" alt="Preview">' +
    '<div class="preview-info">' +
        '<small>' + file.name + '</small>' +
    '</div>';

// Thêm Bootstrap JS
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
```

## Testing Tools Tạo:

### 1. `test-db.jsp`
- Test database connection
- Kiểm tra cấu trúc bảng blog
- Đếm số blog hiện có

## Cách test system:

1. **Truy cập `test-db.jsp`** để kiểm tra database connection
2. **Truy cập `blog-create.jsp`** để test tạo blog
3. **Kiểm tra console logs** để debug flow
4. **Check database** để xem data đã được insert chưa

## Next Steps nếu vẫn có issue:

1. Kiểm tra server logs để xem debug messages
2. Verify database schema bằng `test-db.jsp`
3. Test từng step: 
   - Form validation
   - Blog creation 
   - Image upload
   - Image preview

## Database Schema Expected:
```sql
CREATE TABLE `blog` (
  `blogID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `blogStatus` varchar(50) NOT NULL DEFAULT 'Pending',
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blogID`),
  KEY `accountID` (`accountID`),
  CONSTRAINT `blblogblogog_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`)
);

CREATE TABLE `blogImg` (
  `blogImgID` int NOT NULL AUTO_INCREMENT,
  `blogID` int NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `IsMain` tinyint(1) NOT NULL,
  `datePosted` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blogImgID`),
  KEY `blogID` (`blogID`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`blogID`) REFERENCES `blog` (`blogID`) ON DELETE CASCADE
);
```
