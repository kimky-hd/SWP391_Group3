 -- Tạo database và sử dụng

CREATE DATABASE IF NOT EXISTS FlowerShopDB;
USE FlowerShopDB;

-- Bảng Account
CREATE TABLE Account (
    accountID INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role TINYINT CHECK (role IN (0, 1, 2, 3)),
    email VARCHAR(100) UNIQUE
);
INSERT INTO Account (username, password, role, email)
VALUES ('admin', 'admin123', 1, 'minhduc31082003@gmail.com');

-- Bảng Tổng chi tiêu
CREATE TABLE TongChiTieu (
    accountID INT PRIMARY KEY,
    tongChiTieu DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (accountID) REFERENCES Account(accountID)
);

-- Bảng Phân loại
CREATE TABLE PhanLoaiTheoColor (
    colorID INT PRIMARY KEY AUTO_INCREMENT,
    colorName VARCHAR(100) NOT NULL
);

INSERT INTO PhanLoaiTheoColor (colorName)
VALUES
('Hồng'),
('Đỏ'),
('Vàng'),
('Tím'),
('Xanh'),
('Trắng'),
('Đen'),
('Cam');

CREATE TABLE PhanLoaiTheoSeason (
    seasonID INT PRIMARY KEY AUTO_INCREMENT,
    seasonName VARCHAR(100) NOT NULL
);

INSERT INTO PhanLoaiTheoSeason (seasonName)
VALUES
('Xuân'),
('Hạ'),
('Thu'),
('Đông');

-- Bảng Product
CREATE TABLE Product (
    productID INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    image VARCHAR(255),
    price DECIMAL(10,2),
    quantity INT,
    description TEXT,
    colorID int,
    seasonID int,
    unit VARCHAR(20),
    dateImport DATE,
    dateExpire DATE,
    FOREIGN KEY (colorID) REFERENCES PhanLoaiTheoColor(colorID),
    FOREIGN KEY (seasonID) REFERENCES PhanLoaiTheoSeason(seasonID)
);

INSERT INTO Product (
    title, image, price, quantity, description,
    colorID, seasonID, unit, dateImport, dateExpire
) VALUES (
    'Hoa Hồng Đỏ',
    'rose.jpg',
    150000,
    20,
    'Hoa hồng đỏ tượng trưng cho tình yêu nồng cháy, đam mê và lãng mạn, cũng như sự hoàn hảo và vẻ đẹp nữ tính.',
    2,
    1,
    'cành',
    '2025-05-22',
    '2025-05-30'
);

-- Bảng Số lượng bán
CREATE TABLE SoLuongBan (
    productID INT PRIMARY KEY,
    soLuongDaBan INT DEFAULT 0,
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Trạng thái hóa đơn
CREATE TABLE Status (
    statusID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

INSERT INTO Status (name)
VALUES
('Đang Chuẩn Bị'),
('Đã Giao');

-- Bảng Hóa đơn
CREATE TABLE HoaDon (
    maHD INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    tongGia DECIMAL(15,2),
    ngayXuat DATE,
    statusID INT,
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (statusID) REFERENCES Status(statusID)
);

-- Bảng Thông tin khách hàng trong hóa đơn
CREATE TABLE InforLine (
    maHD INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(255),
    phoneNumber VARCHAR(20),
    FOREIGN KEY (maHD) REFERENCES HoaDon(maHD)
);

-- Bảng OrderLine (chi tiết hóa đơn)
CREATE TABLE OrderDetail (
	orderdetailID INT PRIMARY KEY AUTO_INCREMENT,
    maHD INT,
    productID INT,
    price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (maHD) REFERENCES HoaDon(maHD),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Cart
CREATE TABLE Cart (
    cartID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    productID INT,
    amount INT,
    status TINYINT CHECK (status IN (0, 1, 2)),
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Customize
CREATE TABLE Customize (
    customizeID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    productID INT,
    amount INT,
    dateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Wishlist
CREATE TABLE Wishlist (
    wishlistID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    productID INT,
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Feedback
CREATE TABLE Feedback (
    feedbackID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    productID INT,
    comment TEXT,
    rate INT CHECK (rate BETWEEN 1 AND 5),
    dateReview DATE,
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng Blog
CREATE TABLE Blog (
    blogID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT,
    title VARCHAR(200),
    content TEXT,
    image VARCHAR(255),
    datePosted DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (accountID) REFERENCES Account(accountID)
);

-- Bảng Voucher
CREATE TABLE Voucher (
    voucherID INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    discountPercent DECIMAL(5,2) CHECK (discountPercent >= 0 AND discountPercent <= 100),
    startDate DATE,
    endDate DATE,
    quantity INT,
    isActive BOOLEAN DEFAULT TRUE
);
CREATE TABLE Blog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);