-- Tạo database và sử dụng
drop database flowershopdb;
CREATE DATABASE IF NOT EXISTS FlowerShopDB;
USE FlowerShopDB;

-- Bảng Account
   CREATE TABLE Account (
    accountID INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role INT NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,  -- Thêm UNIQUE constraint cho số điện thoại
    CONSTRAINT unique_login UNIQUE (username, email, phone)  -- Đảm bảo tính duy nhất
);
INSERT INTO Account (username, password, role, email, phone)
VALUES ('admin', 'admin123', 1, 'ducvmhe170394@gmail.com','0123456789');

INSERT INTO Account (username, password, role, email, phone)
VALUES ('user1', 'duc31082003', 0, 'minhduc31082003@gmail.com', '0964482825');

INSERT INTO Account (username, password, role, email, phone)
VALUES ('user2', 'duc31082003', 0, 'duc31082003@gmail.com', '0987654321');

CREATE TABLE Profile (
    profileID INT PRIMARY KEY AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    phoneNumber VARCHAR(20),
    address VARCHAR(255),
    img VARCHAR(255),
    DOB DATE,
    gender VARCHAR(10),
    CreateAT DATETIME DEFAULT CURRENT_TIMESTAMP,
    accountID INT,
    FOREIGN KEY (accountID) REFERENCES Account(accountID)
);

INSERT INTO Profile (fullName, phoneNumber, address, img, DOB, gender, accountID)
VALUES 
('Nguyễn Văn A', '0901234567', '123 Lê Lợi, Hà Nội', 'avatar1.jpg', '1995-05-20', 'Nam', 1);

INSERT INTO Profile (fullName, phoneNumber, address, img, DOB, gender, accountID)
VALUES 
('Trần Thị B', '0987654321', '456 Nguyễn Trãi, Đà Nẵng', 'avatar2.jpg', '1998-08-15', 'Nữ', 2);

INSERT INTO Profile (fullName, phoneNumber, address, img, DOB, gender, accountID)
VALUES 
('Lê Văn C', '0911223344', '789 Lý Thường Kiệt, TP.HCM', 'avatar3.jpg', '1990-01-10', 'Nam', 3);


-- Bảng Tổng chi tiêu
CREATE TABLE TongChiTieu (
    accountID INT PRIMARY KEY,
    tongChiTieu DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (accountID) REFERENCES Account(accountID)
);

-- Bảng Phân loại
CREATE TABLE Category(
	categoryID INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(100) NOT NULL
);

INSERT INTO Category(categoryName)
VALUES 
    ('Hoa sinh nhật'),
    ('Hoa cưới'),
    ('Hoa chúc mừng'),
    ('Hoa chia buồn'),
    ('Hoa tình yêu'),
    ('Hoa khai trương'),
    ('Hoa tốt nghiệp'),
	('Hoa ngày của mẹ'),
    ('Hoa lễ tình nhân'),
    ('Hoa giáng sinh');


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
('Cam'),
('Kết hợp màu');

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
    categoryID int,
    colorID int,
    seasonID int,
    thanhphan VARCHAR(200),
    dateImport DATE,
    dateExpire DATE,
    FOREIGN KEY (categoryID) REFERENCES Category(categoryID),
    FOREIGN KEY (colorID) REFERENCES PhanLoaiTheoColor(colorID),
    FOREIGN KEY (seasonID) REFERENCES PhanLoaiTheoSeason(seasonID)
);

INSERT INTO Product (title, image, price, quantity, description, categoryID, colorID, seasonID, thanhphan, dateImport, dateExpire)
VALUES
-- 1. Hoa sinh nhật
('Bó hoa hồng sinh nhật', 'bohoahongsinhnhat.jpg', 450000, 10, 'Bó hoa hồng tươi rực rỡ dành tặng sinh nhật.', 1, 2, 2, 'Hồng đỏ pháp : 30  cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY)),

-- 2. Hoa cưới
('Lẵng hoa cưới trắng tinh khôi', 'langhoacuoitrangtinhkhoi.jpg', 2700000, 5, 'Lẵng hoa cưới sang trọng với sắc trắng tinh khôi.', 2, 6, 3, 'Hoa tulip trắng : 30 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY)),

-- 3. Hoa chúc mừng
('Giỏ hoa chúc mừng khai giảng', 'giohoachucmungkhaigiang.jpg', 700000, 7, 'Giỏ hoa rực rỡ chúc mừng ngày khai giảng.', 3, 3, 1, 'Hoa hướng dương : 10 cành. Hoa hồng vàng : 15 cành. Cúc calimero : 5 cành. ', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 DAY)),

-- 4. Hoa chia buồn
('Lẵng hoa chia buồn thanh lịch', 'langhoachiabuonthanhlich.jpg', 700000, 3, 'Lẵng hoa chia buồn màu trắng, thể hiện sự trang nghiêm.', 4, 6, 4, 'Hoa ly trắng : 5 cành. Cúc pingpong : 10 cành. Hoa hồng trắng : 15 cành. Cúc mai trắng : 5 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 DAY)),

-- 5. Hoa tình yêu
('Bó hoa đỏ tình yêu nồng cháy', 'bohoadotinhyeunongchay.jpg', 350000, 12, 'Bó hoa đỏ thể hiện tình cảm sâu sắc và đắm say.', 5, 2, 2, 'Hồng đỏ Ecuador DL : 10 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY)),

-- 6. Hoa khai trương
('Bó hoa khai trương phát tài', 'giohoakhaitruongphattai.jpg', 1000000, 4, 'Bó hoa rực rỡ mang lại may mắn ngày khai trương.', 6, 8, 1, 'Hoa cúc lưới xanh : 20 cành. Môn đỏ : 10 cành. Đồng tiền cam : 30 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY)),

-- 7. Hoa tốt nghiệp
('Bó hoa hướng dương tốt nghiệp', 'bohoahuongduongtotnghiep.jpg', 349000, 6, 'Bó hoa hướng dương chúc mừng tốt nghiệp đầy tươi sáng.', 7, 3, 2, 'Hoa hương dương : 9 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 DAY)),

-- 8. Hoa ngày của mẹ
('Giỏ hoa hồng tặng mẹ', 'giohoahongtangme.jpg', 1000000, 8, 'Giỏ hoa tươi thắm dành tặng người mẹ yêu quý.', 8, 1, 1, 'Hoa hồng sen : 50 cành. Hoa cúc calimero : 50 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 DAY)),

-- 9. Hoa lễ tình nhân
('Bó hoa Valentine lãng mạn', 'bohoavalentinelangman.jpg', 750000, 10, 'Bó hoa tình yêu dịp lễ Valentine thật ngọt ngào.', 9, 4, 4, 'Hoa thạch thảo tím : 1 cành. Hồng tím cà : 5 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 5 DAY)),

-- 10. Hoa giáng sinh
('Lẵng hoa Giáng Sinh đỏ trắng', 'langhoagiangsinhdotrang.jpg', 980000, 5, 'Lẵng hoa chủ đề Giáng Sinh phối đỏ và trắng.', 10, 9, 4, 'Hoa hồng trắng và đỏ : 20 cành. Hoa cẩm chướng trắng và đỏ : 20 cành.', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));




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
('Đã Giao'),
('Hủy');

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
    phoneNumber VARCHAR(20),FOREIGN KEY (maHD) REFERENCES HoaDon(maHD)
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

INSERT INTO Feedback (accountID, productID, comment, rate, dateReview)
VALUES 
(2, 1, 'Sản phẩm rất đẹp và chất lượng, giao hàng nhanh.', 5, '2025-05-30'),
(3, 1, 'Giá hợp lý, nhưng đóng gói chưa kỹ lắm.', 4, '2025-05-29');

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
-- Bảng Voucher
CREATE TABLE Voucher (
    voucherId INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    discountAmount DECIMAL(10,2) NOT NULL,
    minOrderValue DECIMAL(10,2) NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL,
    isActive BOOLEAN DEFAULT true,
    usageLimit INT NOT NULL,
    usedCount INT DEFAULT 0,
    description VARCHAR(255)
);

-- Tạo bảng AccountVoucher để liên kết Voucher với Account
CREATE TABLE AccountVoucher (
    accountId INT,
    voucherId INT,
    isUsed BOOLEAN DEFAULT false,
    assignedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    usedDate DATETIME,
    PRIMARY KEY (accountId, voucherId),
    FOREIGN KEY (accountId) REFERENCES Account(accountId),
    FOREIGN KEY (voucherId) REFERENCES Voucher(voucherId)
);
CREATE TABLE VoucherOrder (
    maHD INT,
    voucherId INT,
    accountId INT,
    discountAmount DECIMAL(10,2) NOT NULL,
    appliedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (maHD, voucherId),
    FOREIGN KEY (maHD) REFERENCES HoaDon(maHD),
    FOREIGN KEY (voucherId) REFERENCES Voucher(voucherId),
    FOREIGN KEY (accountId) REFERENCES Account(accountID)
);

-- Tạo các chỉ mục để tối ưu hiệu suất truy vấn
CREATE INDEX idx_voucher_code ON Voucher(code);
CREATE INDEX idx_voucher_dates ON Voucher(startDate, endDate);
CREATE INDEX idx_account_voucher_account ON AccountVoucher(accountId);
CREATE INDEX idx_account_voucher_used ON AccountVoucher(isUsed);

INSERT INTO Voucher (
    code, 
    discountAmount, 
    minOrderValue, 
    startDate, 
    endDate, 
    isActive, 
    usageLimit, 
    usedCount, 
    description
) VALUES (
    'SALE2025',
    50000.00,
    200000.00,
    '2025-06-01 00:00:00',
    '2025-06-30 23:59:59',
    true,
    100,
    0,
    'Giảm 50K cho đơn hàng từ 200K trong tháng 6'
);




