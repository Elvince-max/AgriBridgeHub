-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: agribridgef1
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (16,8,2,1,250.00),(17,8,3,1,850.00),(18,9,1,1,120.00),(19,10,2,2,250.00),(20,11,6,1,60.00),(21,12,2,1,250.00),(22,13,4,1,420.00),(23,13,6,1,60.00),(24,14,2,3,250.00),(25,14,3,4,850.00),(26,15,2,2,250.00),(27,15,4,2,420.00),(28,16,3,3,850.00),(29,16,4,1,420.00),(30,17,5,2,200.00),(31,18,6,1,60.00),(32,19,4,1,420.00),(33,20,5,1,200.00),(34,21,1,1,120.00),(35,21,6,2,60.00),(36,22,6,1,60.00),(37,23,5,1,200.00),(38,24,6,1,60.00),(39,25,6,1,1.00),(40,26,6,1,1.00),(41,27,6,1,1.00),(42,28,6,1,1.00),(43,29,6,1,1.00),(44,30,6,1,1.00),(45,31,1,1,120.00),(46,31,2,2,250.00),(47,31,4,1,420.00),(48,31,5,1,200.00),(49,32,6,1,1.00),(50,33,6,1,1.00),(51,34,6,1,1.00),(52,35,1,1,120.00),(53,36,6,1,1.00),(54,37,6,1,1.00),(55,38,6,1,1.00),(56,39,6,1,1.00),(57,40,6,1,1.00),(58,41,1,1,120.00),(59,41,2,1,250.00),(60,41,3,1,850.00),(61,41,4,1,420.00),(62,41,5,1,200.00),(63,41,6,1,1.00),(64,42,6,1,1.00),(65,43,6,1,1.00),(66,44,6,1,1.00),(67,45,4,1,420.00),(68,45,5,1,200.00),(69,45,6,1,1.00),(70,46,3,1,850.00),(71,46,4,1,420.00),(72,46,5,1,200.00),(73,46,6,1,1.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-03  5:24:47
