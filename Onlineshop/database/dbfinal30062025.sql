-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: flowershopdb
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `accountID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`accountID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `unique_login` (`username`,`email`,`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES (1,'admin','admin123',1,'ducvmhe170394@fpt.edu.vn','0123456789',1),(2,'manager','manager123',2,'ducvmhe170394@gmail.com','0855555555',1),(3,'user1','duc31082003',0,'minhduc31082003@gmail.com','0964482825',1),(4,'user2','duc31082003',0,'duc31082003@gmail.com','0987654321',1);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accountvoucher`
--

DROP TABLE IF EXISTS `accountvoucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accountvoucher` (
  `accountId` int NOT NULL,
  `voucherId` int NOT NULL,
  `isUsed` tinyint(1) DEFAULT '0',
  `assignedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `usedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`accountId`,`voucherId`),
  KEY `voucherId` (`voucherId`),
  KEY `idx_account_voucher_account` (`accountId`),
  KEY `idx_account_voucher_used` (`isUsed`),
  CONSTRAINT `accountvoucher_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `account` (`accountID`),
  CONSTRAINT `accountvoucher_ibfk_2` FOREIGN KEY (`voucherId`) REFERENCES `voucher` (`voucherId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountvoucher`
--

LOCK TABLES `accountvoucher` WRITE;
/*!40000 ALTER TABLE `accountvoucher` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountvoucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog` (
  `blogID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` text,
  `image` varchar(255) DEFAULT NULL,
  `datePosted` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blogID`),
  KEY `accountID` (`accountID`),
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cartID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `productID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  PRIMARY KEY (`cartID`),
  KEY `accountID` (`accountID`),
  KEY `productID` (`productID`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`),
  CONSTRAINT `cart_chk_1` CHECK ((`status` in (0,1,2)))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `categoryID` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(100) NOT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Hoa sinh nhật'),(2,'Hoa cưới'),(3,'Hoa chúc mừng'),(4,'Hoa chia buồn'),(5,'Hoa tình yêu'),(6,'Hoa khai trương'),(7,'Hoa tốt nghiệp'),(8,'Hoa ngày của mẹ'),(9,'Hoa lễ tình nhân'),(10,'Hoa giáng sinh');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoryproduct`
--

DROP TABLE IF EXISTS `categoryproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoryproduct` (
  `productID` int NOT NULL,
  `categoryID` int NOT NULL,
  PRIMARY KEY (`productID`,`categoryID`),
  KEY `categoryID` (`categoryID`),
  CONSTRAINT `categoryproduct_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`),
  CONSTRAINT `categoryproduct_ibfk_2` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoryproduct`
--

LOCK TABLES `categoryproduct` WRITE;
/*!40000 ALTER TABLE `categoryproduct` DISABLE KEYS */;
INSERT INTO `categoryproduct` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
/*!40000 ALTER TABLE `categoryproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customize`
--

DROP TABLE IF EXISTS `customize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customize` (
  `customizeID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `productID` int DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customizeID`),
  KEY `accountID` (`accountID`),
  KEY `productID` (`productID`),
  CONSTRAINT `customize_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`),
  CONSTRAINT `customize_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customize`
--

LOCK TABLES `customize` WRITE;
/*!40000 ALTER TABLE `customize` DISABLE KEYS */;
/*!40000 ALTER TABLE `customize` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customordercart`
--

DROP TABLE IF EXISTS `customordercart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customordercart` (
  `customCartID` int NOT NULL AUTO_INCREMENT,
  `cartID` int NOT NULL,
  `referenceImage` varchar(255) DEFAULT NULL,
  `description` text,
  `quantity` int DEFAULT '1',
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customCartID`),
  KEY `cartID` (`cartID`),
  CONSTRAINT `customordercart_ibfk_1` FOREIGN KEY (`cartID`) REFERENCES `cart` (`cartID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customordercart`
--

LOCK TABLES `customordercart` WRITE;
/*!40000 ALTER TABLE `customordercart` DISABLE KEYS */;
/*!40000 ALTER TABLE `customordercart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedbackID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `productID` int DEFAULT NULL,
  `comment` text,
  `rate` int DEFAULT NULL,
  `dateReview` date DEFAULT NULL,
  PRIMARY KEY (`feedbackID`),
  KEY `accountID` (`accountID`),
  KEY `productID` (`productID`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`),
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`),
  CONSTRAINT `feedback_chk_1` CHECK ((`rate` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,3,1,'Sản phẩm rất đẹp và chất lượng, giao hàng nhanh.',5,'2025-05-30'),(2,4,1,'Giá hợp lý, nhưng đóng gói chưa kỹ lắm.',4,'2025-05-29');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoadon`
--

DROP TABLE IF EXISTS `hoadon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hoadon` (
  `maHD` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `tongGia` decimal(15,2) DEFAULT NULL,
  `ngayXuat` date DEFAULT NULL,
  `statusID` int DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`maHD`),
  KEY `accountID` (`accountID`),
  KEY `statusID` (`statusID`),
  CONSTRAINT `hoadon_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`),
  CONSTRAINT `hoadon_ibfk_2` FOREIGN KEY (`statusID`) REFERENCES `status` (`statusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoadon`
--

LOCK TABLES `hoadon` WRITE;
/*!40000 ALTER TABLE `hoadon` DISABLE KEYS */;
/*!40000 ALTER TABLE `hoadon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inforline`
--

DROP TABLE IF EXISTS `inforline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inforline` (
  `maHD` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`maHD`),
  CONSTRAINT `inforline_ibfk_1` FOREIGN KEY (`maHD`) REFERENCES `hoadon` (`maHD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inforline`
--

LOCK TABLES `inforline` WRITE;
/*!40000 ALTER TABLE `inforline` DISABLE KEYS */;
/*!40000 ALTER TABLE `inforline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `materialID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `pricePerUnit` decimal(10,2) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`materialID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (1,'Hồng đỏ pháp','cành',8000.00,1),(2,'Tulip trắng','cành',12000.00,1),(3,'Hoa hướng dương','cành',10000.00,1),(4,'Hoa hồng vàng','cành',9000.00,1),(5,'Cúc calimero','cành',5000.00,1),(6,'Hoa ly trắng','cành',10000.00,1),(7,'Cúc pingpong','cành',6000.00,1),(8,'Hoa hồng trắng','cành',8500.00,1),(9,'Cúc mai trắng','cành',4000.00,1),(10,'Hồng đỏ Ecuador DL','cành',15000.00,1),(11,'Cúc lưới xanh','cành',7000.00,1),(12,'Môn đỏ','cành',8000.00,1),(13,'Đồng tiền cam','cành',7500.00,1),(14,'Hoa hồng sen','cành',9500.00,1),(15,'Thạch thảo tím','cành',3000.00,1),(16,'Hồng tím cà','cành',10000.00,1),(17,'Cẩm chướng đỏ trắng','cành',11000.00,1);
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materialbatch`
--

DROP TABLE IF EXISTS `materialbatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materialbatch` (
  `materialBatchID` int NOT NULL AUTO_INCREMENT,
  `materialID` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `importPrice` decimal(10,2) DEFAULT NULL,
  `dateImport` date DEFAULT NULL,
  `dateExpire` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Tươi mới',
  PRIMARY KEY (`materialBatchID`),
  KEY `materialID` (`materialID`),
  CONSTRAINT `materialbatch_ibfk_1` FOREIGN KEY (`materialID`) REFERENCES `material` (`materialID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materialbatch`
--

LOCK TABLES `materialbatch` WRITE;
/*!40000 ALTER TABLE `materialbatch` DISABLE KEYS */;
INSERT INTO `materialbatch` VALUES (1,1,100,6800.00,'2025-06-30','2025-07-10','Tươi mới'),(2,2,100,10200.00,'2025-06-30','2025-07-10','Tươi mới'),(3,3,100,8500.00,'2025-06-30','2025-07-10','Tươi mới'),(4,4,100,7650.00,'2025-06-30','2025-07-10','Tươi mới'),(5,5,100,4250.00,'2025-06-30','2025-07-10','Tươi mới'),(6,6,100,8500.00,'2025-06-30','2025-07-10','Tươi mới'),(7,7,100,5100.00,'2025-06-30','2025-07-10','Tươi mới'),(8,8,100,7225.00,'2025-06-30','2025-07-10','Tươi mới'),(9,9,100,3400.00,'2025-06-30','2025-07-10','Tươi mới'),(10,10,100,12750.00,'2025-06-30','2025-07-10','Tươi mới'),(11,11,100,5950.00,'2025-06-30','2025-07-10','Tươi mới'),(12,12,100,6800.00,'2025-06-30','2025-07-10','Tươi mới'),(13,13,100,6375.00,'2025-06-30','2025-07-10','Tươi mới'),(14,14,100,8075.00,'2025-06-30','2025-07-10','Tươi mới'),(15,15,100,2550.00,'2025-06-30','2025-07-10','Tươi mới'),(16,16,100,8500.00,'2025-06-30','2025-07-10','Tươi mới'),(17,17,100,9350.00,'2025-06-30','2025-07-10','Tươi mới');
/*!40000 ALTER TABLE `materialbatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderdetail` (
  `orderdetailID` int NOT NULL AUTO_INCREMENT,
  `maHD` int DEFAULT NULL,
  `productID` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`orderdetailID`),
  KEY `maHD` (`maHD`),
  KEY `productID` (`productID`),
  CONSTRAINT `orderdetail_ibfk_1` FOREIGN KEY (`maHD`) REFERENCES `hoadon` (`maHD`),
  CONSTRAINT `orderdetail_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetail`
--

LOCK TABLES `orderdetail` WRITE;
/*!40000 ALTER TABLE `orderdetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phanloaitheocolor`
--

DROP TABLE IF EXISTS `phanloaitheocolor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phanloaitheocolor` (
  `colorID` int NOT NULL AUTO_INCREMENT,
  `colorName` varchar(100) NOT NULL,
  PRIMARY KEY (`colorID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phanloaitheocolor`
--

LOCK TABLES `phanloaitheocolor` WRITE;
/*!40000 ALTER TABLE `phanloaitheocolor` DISABLE KEYS */;
INSERT INTO `phanloaitheocolor` VALUES (1,'Hồng'),(2,'Đỏ'),(3,'Vàng'),(4,'Tím'),(5,'Xanh'),(6,'Trắng'),(7,'Đen'),(8,'Cam'),(9,'Kết hợp màu');
/*!40000 ALTER TABLE `phanloaitheocolor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phanloaitheoseason`
--

DROP TABLE IF EXISTS `phanloaitheoseason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phanloaitheoseason` (
  `seasonID` int NOT NULL AUTO_INCREMENT,
  `seasonName` varchar(100) NOT NULL,
  PRIMARY KEY (`seasonID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phanloaitheoseason`
--

LOCK TABLES `phanloaitheoseason` WRITE;
/*!40000 ALTER TABLE `phanloaitheoseason` DISABLE KEYS */;
INSERT INTO `phanloaitheoseason` VALUES (1,'Xuân'),(2,'Hạ'),(3,'Thu'),(4,'Đông');
/*!40000 ALTER TABLE `phanloaitheoseason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `productID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `description` text,
  `colorID` int DEFAULT NULL,
  `seasonID` int DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`productID`),
  KEY `colorID` (`colorID`),
  KEY `seasonID` (`seasonID`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`colorID`) REFERENCES `phanloaitheocolor` (`colorID`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`seasonID`) REFERENCES `phanloaitheoseason` (`seasonID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Bó hoa hồng sinh nhật','bohoahongsinhnhat.jpg',450000.00,'Bó hoa hồng tươi rực rỡ dành tặng sinh nhật.',2,2,1),(2,'Lẵng hoa cưới trắng tinh khôi','langhoacuoitrangtinhkhoi.jpg',2700000.00,'Lẵng hoa cưới sang trọng với sắc trắng tinh khôi.',6,3,1),(3,'Giỏ hoa chúc mừng khai giảng','giohoachucmungkhaigiang.jpg',700000.00,'Giỏ hoa rực rỡ chúc mừng ngày khai giảng.',3,1,1),(4,'Lẵng hoa chia buồn thanh lịch','langhoachiabuonthanhlich.jpg',700000.00,'Lẵng hoa chia buồn màu trắng, thể hiện sự trang nghiêm.',6,4,1),(5,'Bó hoa đỏ tình yêu nồng cháy','bohoadotinhyeunongchay.jpg',350000.00,'Bó hoa đỏ thể hiện tình cảm sâu sắc và đắm say.',2,2,1),(6,'Bó hoa khai trương phát tài','giohoakhaitruongphattai.jpg',1000000.00,'Bó hoa rực rỡ mang lại may mắn ngày khai trương.',8,1,1),(7,'Bó hoa hướng dương tốt nghiệp','bohoahuongduongtotnghiep.jpg',349000.00,'Bó hoa hướng dương chúc mừng tốt nghiệp đầy tươi sáng.',3,2,1),(8,'Giỏ hoa hồng tặng mẹ','giohoahongtangme.jpg',1000000.00,'Giỏ hoa tươi thắm dành tặng người mẹ yêu quý.',1,1,1),(9,'Bó hoa Valentine lãng mạn','bohoavalentinelangman.jpg',750000.00,'Bó hoa tình yêu dịp lễ Valentine thật ngọt ngào.',4,4,1),(10,'Lẵng hoa Giáng Sinh đỏ trắng','langhoagiangsinhdotrang.jpg',980000.00,'Lẵng hoa chủ đề Giáng Sinh phối đỏ và trắng.',9,4,1);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productbatch`
--

DROP TABLE IF EXISTS `productbatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productbatch` (
  `productBatchID` int NOT NULL AUTO_INCREMENT,
  `productID` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `importPrice` decimal(10,2) DEFAULT NULL,
  `dateImport` date DEFAULT NULL,
  `dateExpire` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Tươi mới',
  PRIMARY KEY (`productBatchID`),
  KEY `productID` (`productID`),
  CONSTRAINT `productbatch_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productbatch`
--

LOCK TABLES `productbatch` WRITE;
/*!40000 ALTER TABLE `productbatch` DISABLE KEYS */;
INSERT INTO `productbatch` VALUES (1,1,10,320000.00,'2025-06-30','2025-07-07','Tươi mới'),(2,2,5,2000000.00,'2025-06-30','2025-07-05','Tươi mới'),(3,3,7,500000.00,'2025-06-30','2025-07-06','Tươi mới'),(4,4,3,480000.00,'2025-06-30','2025-07-04','Tươi mới'),(5,5,12,250000.00,'2025-06-30','2025-07-07','Tươi mới'),(6,6,4,720000.00,'2025-06-30','2025-07-05','Tươi mới'),(7,7,6,270000.00,'2025-06-30','2025-07-06','Tươi mới'),(8,8,8,750000.00,'2025-06-30','2025-07-06','Tươi mới'),(9,9,10,540000.00,'2025-06-30','2025-07-05','Tươi mới'),(10,10,5,700000.00,'2025-06-30','2025-07-07','Tươi mới');
/*!40000 ALTER TABLE `productbatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productcomponent`
--

DROP TABLE IF EXISTS `productcomponent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productcomponent` (
  `productComponentID` int NOT NULL AUTO_INCREMENT,
  `productID` int DEFAULT NULL,
  `materialID` int DEFAULT NULL,
  `materialQuantity` int DEFAULT NULL,
  PRIMARY KEY (`productComponentID`),
  KEY `productID` (`productID`),
  KEY `materialID` (`materialID`),
  CONSTRAINT `productcomponent_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`),
  CONSTRAINT `productcomponent_ibfk_2` FOREIGN KEY (`materialID`) REFERENCES `material` (`materialID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productcomponent`
--

LOCK TABLES `productcomponent` WRITE;
/*!40000 ALTER TABLE `productcomponent` DISABLE KEYS */;
INSERT INTO `productcomponent` VALUES (1,1,1,30),(2,2,2,30),(3,3,3,10),(4,3,4,15),(5,3,5,5),(6,4,6,5),(7,4,7,10),(8,4,8,15),(9,4,9,5),(10,5,10,10),(11,6,11,20),(12,6,12,10),(13,6,13,30),(14,7,3,9),(15,8,14,50),(16,8,5,50),(17,9,15,1),(18,9,16,5),(19,10,8,20),(20,10,17,20);
/*!40000 ALTER TABLE `productcomponent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile` (
  `profileID` int NOT NULL AUTO_INCREMENT,
  `fullName` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `CreateAT` datetime DEFAULT CURRENT_TIMESTAMP,
  `accountID` int DEFAULT NULL,
  PRIMARY KEY (`profileID`),
  KEY `accountID` (`accountID`),
  CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (1,'Nguyễn Văn A','0901234567','123 Lê Lợi, Hà Nội','avatar1.jpg','1995-05-20','Nam','2025-06-30 13:08:45',1),(2,'Trần Thị B','0987654321','456 Nguyễn Trãi, Đà Nẵng','avatar2.jpg','1998-08-15','Nữ','2025-06-30 13:08:45',3),(3,'Lê Văn C','0911223344','789 Lý Thường Kiệt, TP.HCM','avatar3.jpg','1990-01-10','Nam','2025-06-30 13:08:45',4);
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soluongban`
--

DROP TABLE IF EXISTS `soluongban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soluongban` (
  `productID` int NOT NULL,
  `soLuongDaBan` int DEFAULT '0',
  PRIMARY KEY (`productID`),
  CONSTRAINT `soluongban_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soluongban`
--

LOCK TABLES `soluongban` WRITE;
/*!40000 ALTER TABLE `soluongban` DISABLE KEYS */;
/*!40000 ALTER TABLE `soluongban` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `statusID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`statusID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'Chờ duyệt'),(2,'Đơn hàng đã được duyệt và tiến hành đóng gói'),(3,'Đơn hàng đang được vận chuyển'),(4,'Đã giao hàng thành công'),(5,'Đã thanh toán thành công'),(6,'Đã hủy');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tongchitieu`
--

DROP TABLE IF EXISTS `tongchitieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tongchitieu` (
  `accountID` int NOT NULL,
  `tongChiTieu` decimal(15,2) DEFAULT '0.00',
  PRIMARY KEY (`accountID`),
  CONSTRAINT `tongchitieu_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tongchitieu`
--

LOCK TABLES `tongchitieu` WRITE;
/*!40000 ALTER TABLE `tongchitieu` DISABLE KEYS */;
/*!40000 ALTER TABLE `tongchitieu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voucher`
--

DROP TABLE IF EXISTS `voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voucher` (
  `voucherId` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `discountAmount` decimal(10,2) NOT NULL,
  `minOrderValue` decimal(10,2) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `isActive` tinyint(1) DEFAULT '1',
  `usageLimit` int NOT NULL,
  `usedCount` int DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`voucherId`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_voucher_code` (`code`),
  KEY `idx_voucher_dates` (`startDate`,`endDate`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucher`
--

LOCK TABLES `voucher` WRITE;
/*!40000 ALTER TABLE `voucher` DISABLE KEYS */;
INSERT INTO `voucher` VALUES (1,'SALE2025',50000.00,200000.00,'2025-06-01 00:00:00','2025-06-30 23:59:59',1,100,0,'Giảm 50K cho đơn hàng từ 200K trong tháng 6');
/*!40000 ALTER TABLE `voucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voucherorder`
--

DROP TABLE IF EXISTS `voucherorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voucherorder` (
  `maHD` int NOT NULL,
  `voucherId` int NOT NULL,
  `accountId` int DEFAULT NULL,
  `discountAmount` decimal(10,2) NOT NULL,
  `appliedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`maHD`,`voucherId`),
  KEY `voucherId` (`voucherId`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `voucherorder_ibfk_1` FOREIGN KEY (`maHD`) REFERENCES `hoadon` (`maHD`),
  CONSTRAINT `voucherorder_ibfk_2` FOREIGN KEY (`voucherId`) REFERENCES `voucher` (`voucherId`),
  CONSTRAINT `voucherorder_ibfk_3` FOREIGN KEY (`accountId`) REFERENCES `account` (`accountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voucherorder`
--

LOCK TABLES `voucherorder` WRITE;
/*!40000 ALTER TABLE `voucherorder` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucherorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `wishlistID` int NOT NULL AUTO_INCREMENT,
  `accountID` int DEFAULT NULL,
  `productID` int DEFAULT NULL,
  PRIMARY KEY (`wishlistID`),
  KEY `accountID` (`accountID`),
  KEY `productID` (`productID`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `account` (`accountID`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `product` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-30 13:17:45
