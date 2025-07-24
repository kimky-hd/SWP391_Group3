<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Flower Shop</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="Free HTML Templates">
    <meta name="description" content="Free HTML Templates">

    <!-- Favicon -->
    <link rel="icon" href="img/favicon.ico">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="header.jsp"/>

    <!-- Login Form -->
    <div class="login-container" style="padding: 60px 0; background: url('img/carousel-1.jpg') center center/cover no-repeat fixed; min-height: 80vh;">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-md-6 col-lg-5">
            <div class="card" style="border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); overflow: hidden; background: rgba(255, 255, 255, 0.95);"> <!-- Cập nhật màu nền giống register -->
              <!-- Header -->
              <div class="card-header text-center" style="background: linear-gradient(135deg, #FFB6C1, #FFA5B5); color: white; padding: 2rem;">
                <h3 style="font-size: 1.8rem; font-weight: bold; letter-spacing: 0.5px; margin-bottom: 0;">Đăng Nhập</h3>
              </div>

              <!-- Body -->
              <div class="card-body" style="padding: 2.5rem;">
                <!-- Error Alert -->
                <c:if test="${error != null}">
                  <div class="alert alert-danger" style="
                    background: linear-gradient(135deg, #fef2f2, #fee2e2);
                    border: 1px solid #fca5a5;
                    color: #b91c1c;
                    border-radius: 12px;
                    padding: 1rem;
                    margin-bottom: 1.5rem;
                    display: flex;
                    align-items: center;
                    font-weight: 500;
                  ">
                    <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem; color: #dc2626;"></i>
                    ${error}
                  </div>
                </c:if>

                <!-- Success Alert (nếu có) -->
                <c:if test="${success != null}">
                  <div class="alert alert-success" style="
                    background: linear-gradient(135deg, #f0fdf4, #dcfce7);
                    border: 1px solid #86efac;
                    color: #166534;
                    border-radius: 12px;
                    padding: 1rem;
                    margin-bottom: 1.5rem;
                    display: flex;
                    align-items: center;
                    font-weight: 500;
                  ">
                    <i class="fas fa-check-circle" style="margin-right: 0.5rem; color: #16a34a;"></i>
                    ${success}
                  </div>
                </c:if>

                <!-- Đăng nhập Google -->
                <a href="LoginWithGoogle" class="btn w-100 mb-4" style="
                  background: linear-gradient(135deg, #f472b6, #ec4899);
                  color: white;
                  border: none;
                  border-radius: 12px;
                  padding: 0.9rem 1.25rem;
                  font-weight: 500;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  transition: 0.3s ease;
                  text-decoration: none;
                "
                  onmouseover="this.style.background='linear-gradient(135deg, #FFA5B5, #db2777)'; this.style.transform='translateY(-2px)'"
                  onmouseout="this.style.background='linear-gradient(135deg, #FFA5B5, #ec4899)'; this.style.transform='translateY(0)'">
                  <i class="fab fa-google me-2" style="font-size: 1.1rem;"></i> Đăng nhập bằng Google
                </a>

                <!-- Hoặc -->
                <div class="text-center my-4" style="position: relative; font-size: 0.95rem; color: #6b7280;">
                  <span style="background: #fff; padding: 0 1rem; position: relative; z-index: 1;">HOẶC</span>
                  <div style="position: absolute; top: 50%; left: 0; right: 0; height: 1px; background: #e5e7eb;"></div>
                </div>

                <!-- Form -->
                <form action="LoginServlet" method="post" onsubmit="return validateForm()">
                  <!-- User input -->
                  <div class="mb-4" style="position: relative;">
                    <i class="fas fa-user" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                    <input type="text" class="form-control" id="userInput" name="userInput" placeholder="Email, SĐT hoặc Tên đăng nhập" required value="${userInput}" style="
                      padding: 1.25rem 1rem 1.25rem 3rem;
                      border: 2px solid #e5e7eb;
                      border-radius: 12px;
                      font-size: 1rem;
                      transition: 0.3s ease;
                      height: 60px;
                    " 
                    onfocus="this.style.borderColor='#f472b6'; this.style.boxShadow='0 0 0 3px rgba(244,114,182,0.1)'"
                    onblur="this.style.borderColor='#e5e7eb'; this.style.boxShadow='none'">
                  </div>

                  <!-- Password input -->
                  <div class="mb-4" style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required style="
                      padding: 1.25rem 1rem 1.25rem 3rem;
                      border: 2px solid #e5e7eb;
                      border-radius: 12px;
                      font-size: 1rem;
                      transition: 0.3s ease;
                      height: 60px;
                    " 
                    onfocus="this.style.borderColor='#f472b6'; this.style.boxShadow='0 0 0 3px rgba(244,114,182,0.1)'"
                    onblur="this.style.borderColor='#e5e7eb'; this.style.boxShadow='none'">
                  </div>

                  <!-- Remember me -->
                  <div class="form-check mb-4" style="padding-left: 0;">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe" style="
                      width: 18px;
                      height: 18px;
                      margin-right: 0.75rem;
                      accent-color: #f472b6;
                    ">
                    <label for="rememberMe" class="form-check-label" style="color: #374151;">Nhớ mật khẩu</label>
                  </div>

                  <!-- Submit button -->
                  <button type="submit" class="btn w-100 py-3" style="
                    background: linear-gradient(135deg, #f472b6, #db2777);
                    color: white;
                    font-weight: 600;
                    font-size: 1.05rem;
                    border: none;
                    border-radius: 12px;
                    transition: 0.3s ease;
                  " 
                  onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 25px rgba(244,114,182,0.4)'"
                  onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                  </button>
                </form>

                <!-- Links -->
                <div class="text-center mt-4 pt-3" style="border-top: 1px solid #f3f4f6;">
                  <p style="color: #6b7280; font-size: 0.95rem;">
                    Chưa có tài khoản? 
                    <a href="register.jsp" style="color: #f472b6; font-weight: 600; text-decoration: none;"
                       onmouseover="this.style.color='#db2777'" onmouseout="this.style.color='#f472b6'">
                       Đăng ký ngay
                    </a>
                  </p>
                  <p style="color: #6b7280; font-size: 0.95rem;">
                    <a href="forgotpassword.jsp" style="color: #f472b6; font-weight: 600; text-decoration: none;"
                       onmouseover="this.style.color='#db2777'" onmouseout="this.style.color='#f472b6'">
                       Quên mật khẩu?
                    </a>
                  </p>
                  <a href="Homepage" style="color: #6b7280; font-size: 0.9rem; text-decoration: none;"
                     onmouseover="this.style.color='#374151'" onmouseout="this.style.color='#6b7280'">
                    <i class="fas fa-arrow-left me-1"></i> Quay về trang chủ
                  </a>
                </div>
              </div> <!-- End card-body -->
            </div> <!-- End card -->
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JS logic -->
    <script>
        window.onload = function () {
            function getCookie(name) {
                let cookieArr = document.cookie.split(";");
                for (let i = 0; i < cookieArr.length; i++) {
                    let cookiePair = cookieArr[i].split("=");
                    if (cookiePair[0].trim() === name) {
                        return decodeURIComponent(cookiePair[1]);
                    }
                }
                return null;
            }

            function decodeBase64(str) {
                try {
                    return atob(str);
                } catch (e) {
                    console.error('Lỗi giải mã Base64:', e);
                    return '';
                }
            }

            let savedUserInput = getCookie("savedUserInput");
            let savedPassword = getCookie("savedPassword");

            if (savedUserInput && savedPassword) {
                document.getElementById("userInput").value = decodeBase64(savedUserInput);
                document.getElementById("password").value = decodeBase64(savedPassword);
                document.getElementById("rememberMe").checked = true;
            }
        };

        function validateForm() {
            const userInput = document.getElementById("userInput").value;
            const password = document.getElementById("password").value;
            if (userInput.trim() === "" || password.trim() === "") {
                alert("Vui lòng điền đầy đủ thông tin đăng nhập!");
                return false;
            }
            return true;
        }

        <% 
            String successMsg = (String)request.getAttribute("success");
            if (successMsg != null && !successMsg.contains("Đăng ký thành công")) { 
        %>
        setTimeout(() => {
            window.location.href = "Homepage";
        }, 1500);

        if (${sessionScope.account != null}) {
            fetch('ordercount')
                .then(response => {
                    if (response.ok) {
                        window.location.href = 'Homepage';
                    }
                });
        }
        <% } %>

        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s ease';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>