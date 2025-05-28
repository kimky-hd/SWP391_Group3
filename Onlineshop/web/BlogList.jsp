<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Blog List - Flower Shop</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <link href="img/favicon.ico" rel="icon">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4 text-center text-pink">Danh sách Blog</h2>
            <a href="index.html" class="btn btn-secondary mb-4">Home</a>
            <div class="list-group">
                <c:forEach var="blog" items="${blogs}">
                    <div class="list-group-item mb-4">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1 text-pink">${blog.title}</h5>
                            <c:if test="${isStaff}">
                                <div>
                                    <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal" data-blogid="${blog.blogID}" data-title="${blog.title}" data-content="${blog.content}">Edit</button>
                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteModal" data-blogid="${blog.blogID}">Delete</button>
                                </div>
                            </c:if>
                        </div>
                        <p class="mb-1">${blog.content}</p>
                        <small class="text-muted"><i class="fa fa-user mr-1"></i>${blog.accountID} | <i class="fa fa-calendar-alt mr-1"></i>${blog.datePosted}</small>
                    </div>
                </c:forEach>
            </div>
            <!-- Nút thêm blog mới (chỉ hiển thị cho staff) -->
            <c:if test="${isStaff}">
                <button type="button" class="btn btn-primary mt-4" data-bs-toggle="modal" data-bs-target="#addBlogModal">Add Blog</button>
            </c:if>
            <!-- Modal thêm blog mới -->
            <div class="modal fade" id="addBlogModal" tabindex="-1" aria-labelledby="addBlogModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addBlogModalLabel">Viết blog mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="blog" method="post">
                                <div class="form-group">
                                    <label for="title">Tiêu đề</label>
                                    <input type="text" class="form-control" id="title" name="title" required>
                                </div>
                                <div class="form-group">
                                    <label for="content">Nội dung</label>
                                    <textarea class="form-control" id="content" name="content" rows="4" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-pink mt-3">Đăng blog</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal chỉnh sửa blog -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Chỉnh sửa blog</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="blog" method="post">
                                <input type="hidden" id="editBlogID" name="blogID">
                                <div class="form-group">
                                    <label for="editTitle">Tiêu đề</label>
                                    <input type="text" class="form-control" id="editTitle" name="title" required>
                                </div>
                                <div class="form-group">
                                    <label for="editContent">Nội dung</label>
                                    <textarea class="form-control" id="editContent" name="content" rows="4" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-success mt-3">Lưu thay đổi</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal xác nhận xóa blog -->
            <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Bạn có chắc chắn muốn xóa blog này không?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Hủy bỏ</button>
                            <button type="button" class="btn btn-success" id="confirmDelete">Xác nhận</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            let blogIDToDelete;
            $('#deleteModal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                blogIDToDelete = button.data('blogid');
            });

            $('#confirmDelete').click(function () {
                window.location.href = 'blog?action=delete&id=' + blogIDToDelete;
            });

            $('#editModal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                const blogID = button.data('blogid');
                const title = button.data('title');
                const content = button.data('content');
                const modal = $(this);
                modal.find('#editBlogID').val(blogID);
                modal.find('#editTitle').val(title);
                modal.find('#editContent').val(content);
            });
        </script>
    </body>
</html>