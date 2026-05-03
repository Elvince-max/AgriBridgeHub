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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `user_type` enum('CUSTOMER','ADMIN','STAFF','DELIVERY_AGENT') DEFAULT 'CUSTOMER',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Elvince Fidel','elvincefidel@gmail.com','0791774849','esiu8CWvV4kmFZTuBcokdQ==:SyQQoFWgQD13kqiclknOd+l5pgQ4Uow7l5yyy0jUhmI=','ADMIN','2026-04-30 07:15:31'),(2,'Risper Mukiri','rispermukiri@gmail.com','0791774899','L0ue14nuEn8kV/QETQltTw==:uI9PUfAwz2wn7OPYxnS2T8RBM1aNfCpy+U7dWQbuFpI=','STAFF','2026-04-30 07:17:50'),(3,'Samwel Mogul','samwelmogul@gmail.com','0791774844','/X3uyvXiSRbuQvJXEQkEgw==:+kaOqQpfC75tFKQRZMrYevV3Vz4lNkWCiODrQ1ej+30=','DELIVERY_AGENT','2026-04-30 07:19:34'),(7,'Kimani Njoroge','kimaninjoroge@gmail.com','0723687245','ulHd1fyREdRyZ5wzoQrmpg==:pZA3gXjFTxFsYyw/INXyc1FNanH126wJkmKLRf4A2qg=','CUSTOMER','2026-04-30 07:23:34'),(8,'Vincent Okoth','okothvincent@gmail.com','0113050613','cXQArAEtgL0Of9GiMr6emA==:GZ+ok6W4FbcZ1HHWl7abS1ITqZJSHRwPY1ATgYjmpnc=','CUSTOMER','2026-04-30 08:46:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-03  5:24:46
