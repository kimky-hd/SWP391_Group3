-- Create Cities table
CREATE TABLE Cities (
    city_id VARCHAR(10) PRIMARY KEY,
    city_name NVARCHAR(100) NOT NULL
);

-- Create Districts table
CREATE TABLE Districts (
    district_id VARCHAR(10) PRIMARY KEY,
    district_name NVARCHAR(100) NOT NULL,
    city_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);

-- Create Wards table
CREATE TABLE Wards (
    ward_id VARCHAR(10) PRIMARY KEY,
    ward_name NVARCHAR(100) NOT NULL,
    district_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (district_id) REFERENCES Districts(district_id)
);

-- Insert sample data for Cities
INSERT INTO Cities (city_id, city_name) VALUES
('1', N'Hà Nội'),
('2', N'Hồ Chí Minh'),
('3', N'Đà Nẵng'),
('4', N'Hải Phòng'),
('5', N'Cần Thơ');

-- Insert sample data for Districts
INSERT INTO Districts (district_id, district_name, city_id) VALUES
-- Hà Nội
('101', N'Hoàn Kiếm', '1'),
('102', N'Ba Đình', '1'),
('103', N'Đống Đa', '1'),
-- Hồ Chí Minh
('201', N'Quận 1', '2'),
('202', N'Quận 2', '2'),
('203', N'Quận 3', '2'),
-- Đà Nẵng
('301', N'Hải Châu', '3'),
('302', N'Thanh Khê', '3'),
('303', N'Sơn Trà', '3');

-- Insert sample data for Wards
INSERT INTO Wards (ward_id, ward_name, district_id) VALUES
-- Hoàn Kiếm
('1011', N'Phường Hàng Trống', '101'),
('1012', N'Phường Hàng Bông', '101'),
('1013', N'Phường Hàng Gai', '101'),
-- Quận 1
('2011', N'Phường Bến Nghé', '201'),
('2012', N'Phường Bến Thành', '201'),
('2013', N'Phường Đa Kao', '201'),
-- Hải Châu
('3011', N'Phường Hải Châu 1', '301'),
('3012', N'Phường Hải Châu 2', '301'),
('3013', N'Phường Nam Dương', '301');