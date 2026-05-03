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
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_address` text,
  `delivery_time` varchar(50) DEFAULT NULL,
  `order_status` enum('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
  `total_amount` decimal(10,2) NOT NULL,
  `delivery_zone` varchar(100) DEFAULT NULL,
  `delivery_fee` decimal(10,2) DEFAULT '0.00',
  `phone` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (8,7,'2026-04-30 07:25:43','Nakuru','Morning','DELIVERED',1100.00,NULL,0.00,NULL,NULL),(9,7,'2026-04-30 07:26:24','Nakuru','Morning','DELIVERED',120.00,NULL,0.00,NULL,NULL),(10,1,'2026-04-30 08:13:15','Njokerio Nevada Estate','Morning','DELIVERED',500.00,NULL,0.00,NULL,NULL),(11,8,'2026-04-30 08:46:57','Njokerio','Morning','DELIVERED',60.00,NULL,0.00,NULL,NULL),(12,7,'2026-04-30 10:30:42','Nairobi','Morning','DELIVERED',250.00,NULL,0.00,NULL,NULL),(13,7,'2026-04-30 10:36:44','KIsumu','Morning','DELIVERED',480.00,NULL,0.00,NULL,NULL),(14,7,'2026-04-30 10:43:20','Nakuru','Morning','DELIVERED',4150.00,NULL,0.00,NULL,NULL),(15,7,'2026-04-30 10:49:29','Mombasa','Morning','DELIVERED',1340.00,NULL,0.00,NULL,NULL),(16,7,'2026-04-30 12:47:26','Njokerio','Morning','PENDING',2970.00,NULL,0.00,NULL,NULL),(17,7,'2026-04-30 13:06:13','Nakuru - Kenya, Nakuru Town','Morning','PENDING',400.00,NULL,0.00,NULL,NULL),(18,8,'2026-04-30 13:09:36','Siaya','Afternoon','PENDING',60.00,NULL,0.00,NULL,NULL),(19,7,'2026-04-30 21:21:36','Elburgon','Morning','PENDING',420.00,NULL,0.00,NULL,NULL),(20,7,'2026-04-30 21:23:12','Nah','Afternoon','PENDING',200.00,NULL,0.00,NULL,NULL),(21,7,'2026-04-30 21:29:25','N/A','Morning','PENDING',240.00,NULL,0.00,NULL,NULL),(22,7,'2026-05-01 07:54:56','nakuru','Morning','DELIVERED',60.00,NULL,0.00,NULL,NULL),(23,1,'2026-05-01 08:44:27','nah','Morning','PENDING',200.00,NULL,0.00,NULL,NULL),(24,1,'2026-05-01 09:28:24','Nah','Morning','DELIVERED',60.00,NULL,0.00,NULL,NULL),(25,1,'2026-05-01 09:45:08','Njokerio','Morning','CONFIRMED',1.00,NULL,0.00,NULL,NULL),(26,1,'2026-05-01 09:51:52','Nakuru','Afternoon','PENDING',1.00,NULL,0.00,NULL,NULL),(27,1,'2026-05-01 10:11:22','Nah','Morning','DELIVERED',1.00,NULL,0.00,NULL,NULL),(28,1,'2026-05-01 15:43:48','N/A','Morning','CONFIRMED',1.00,NULL,0.00,NULL,NULL),(29,1,'2026-05-01 15:54:24','N/A','Afternoon','CONFIRMED',1.00,NULL,0.00,NULL,NULL),(30,1,'2026-05-01 16:01:16','Home away from home','Morning','DELIVERED',1.00,NULL,0.00,NULL,NULL),(31,1,'2026-05-01 22:13:34','Nah','Morning','PENDING',1240.00,NULL,0.00,NULL,NULL),(32,1,'2026-05-02 09:13:49','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(33,1,'2026-05-02 09:51:12','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849','Maringo 49/4 Time: anytime from 4:00 pm'),(34,1,'2026-05-02 09:56:09','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(35,1,'2026-05-02 10:05:21','Campus pickup',NULL,'PENDING',120.00,'Campus pickup',0.00,'0791774849',''),(36,1,'2026-05-02 10:08:40','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(37,1,'2026-05-02 21:20:06','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(38,1,'2026-05-02 21:30:37','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(39,1,'2026-05-02 21:53:26','Campus pickup',NULL,'CONFIRMED',1.00,'Campus pickup',0.00,'0791774849',''),(40,8,'2026-05-02 21:55:32','Campus pickup',NULL,'CONFIRMED',1.00,'Campus pickup',0.00,'0791774849',''),(41,1,'2026-05-02 22:09:04','Campus pickup',NULL,'PENDING',1841.00,'Campus pickup',0.00,'0791774849',''),(42,1,'2026-05-02 23:43:27','Campus pickup',NULL,'CONFIRMED',1.00,'Campus pickup',0.00,'0791774849',''),(43,7,'2026-05-02 23:50:09','Campus pickup',NULL,'CONFIRMED',1.00,'Campus pickup',0.00,'0791774849',''),(44,7,'2026-05-02 23:53:01','Campus pickup',NULL,'PENDING',1.00,'Campus pickup',0.00,'0791774849',''),(45,1,'2026-05-03 00:48:10','Siaya',NULL,'PENDING',871.00,'Outside Nakuru',250.00,'0791774849',''),(46,7,'2026-05-03 00:50:22','Siaya',NULL,'PENDING',1721.00,'Outside Nakuru',250.00,'0791774849','');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
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
