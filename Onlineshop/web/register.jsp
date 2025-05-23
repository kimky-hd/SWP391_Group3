<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FLOWER SHOP - Đăng ký</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .register-container {
            width: 400px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .register-header {
            background-color: #A06060; 
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }
        
        .register-form {
            padding: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
            font-size: 16px;
        }
        
        .register-btn {
            background-color: #A06060; 
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 3px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
        }
        
        .register-btn:hover {
            background-color: #8a5252;
        }
        
        .error-message {
            color: #e74c3c;
            margin-bottom: 15px;
        }
        
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .login-link a {
            color: #A06060; 
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .home-link {
            text-align: center;
            margin-top: 10px;
        }
        
        .home-link a {
            color: #666;
            text-decoration: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .home-link a:hover {
            color: #A06060;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            FLOWER SHOP
        </div>
        <div class="register-form">
            <h2 style="text-align: center; margin-top: 0;">Đăng ký</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="account" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="confirm-password">Xác nhận mật khẩu</label>
                    <input type="password" id="confirm-password" name="confirm-password" required>
                </div>
                
                <button type="submit" class="register-btn">Đăng ký</button>
            </form>
            
            <div class="login-link">
                Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
            </div>
            
            <div class="home-link">
                <a href="home">
                    ← Quay về trang chủ
                </a>
            </div>
        </div>
    </div>
    
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirm-password").value;
            
            if (password !== confirmPassword) {
                alert("Mật khẩu xác nhận không khớp!");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>