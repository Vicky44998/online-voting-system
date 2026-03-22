CREATE DATABASE  IF NOT EXISTS `voting_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `voting_system`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: voting_system
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES ('admin','40510175845988f13f6162ed8526f0b09f73384467fa855e1e79b44a56562a58');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidates`
--

DROP TABLE IF EXISTS `candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidates` (
  `letter` char(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `color` varchar(20) NOT NULL,
  `vote_count` int DEFAULT '0',
  PRIMARY KEY (`letter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidates`
--

LOCK TABLES `candidates` WRITE;
/*!40000 ALTER TABLE `candidates` DISABLE KEYS */;
INSERT INTO `candidates` VALUES ('A','VIGNESH L','red',1),('B','VIGNESHWARAN','blue',0),('C','VIGNESH M','yellow',0),('D','VINAYAGAMOORTHY','purple',0);
/*!40000 ALTER TABLE `candidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voters`
--

DROP TABLE IF EXISTS `voters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voters` (
  `id` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `has_voted` tinyint(1) DEFAULT '0',
  `voted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voters`
--

LOCK TABLES `voters` WRITE;
/*!40000 ALTER TABLE `voters` DISABLE KEYS */;
INSERT INTO `voters` VALUES ('23117602','a0cc561e091b8f277d87053dc445b77f1bc7ce951989c0d61514c91558f0ce3f',0,NULL),('23117702','3cf31cccc7d0bf914dbd2f7d925a101f47eee44739a2c3d497a92a345e90fd53',0,NULL),('23139202','7ba55b1e7faa5171817f0ba6078b3a01c4d79e83fa2d8236794210fa444015e5',0,NULL),('23140402','aa1f43b0e52e1f7f593b744f6ad5c6a928b0503733694c1d5123014508ddadf7',0,NULL),('23144102','ff2b27fabfde059e655b09f2d07b0bf0d43afd33b7c0ba09f6924468c7381c69',0,NULL),('23149202','552392ef4b3508fdde586159b31e743a169a47ce26ae14467a4ed3442a252034',0,NULL),('23155602','77a34c55256d8a07dee7796459594f1882dd5079c2199a121d7cdac85c50359e',0,NULL),('23158902','abf9da1a9812cb5ee9f667844861b19b22046734ec8155975f17d687774ebb47',0,NULL),('23159102','fc5268d7b339ffd78e553388bc386ee9c3a1f45d608df1381fb625d96c1a3b78',0,NULL),('23159402','9050ab7221b065c450a29abdc92bd2931437851dcbd99e8d090c9d36840315d9',0,NULL),('23161202','552392ef4b3508fdde586159b31e743a169a47ce26ae14467a4ed3442a252034',0,NULL),('23167502','4233d79c3ac147ee141d2a0fbaf671f5ce68d0163cf4139809f2e8e2f4ee9827',0,NULL),('23171902','e5cc3727c510665b3ce8c2c273533e1ef5fc8f9c607a24659e976c47d1df9afd',0,NULL),('23174002','fbc7813a4f4da5076383675ba7cbf0cd87054003eed67b6e79274c1a5e11934a',0,NULL),('23174202','4571a07079aa4f858db58969bfc933c09d3a11c869824e66e4b0850a11e93783',0,NULL),('23181702','bd5d5c46106a06976f0939b9aabe52a8aec7964e8f6d324f73e5262e0bfc00d8',0,NULL),('23186102','3b65deb80de414b793a9aa7b5db665f45d1a028f18ec57d37d34d93d96e3fec4',0,NULL),('23190602','6721950c5f376ffbe708d8e79fb96c45c2ea5c59016380442eaaa3fbd10f839c',0,NULL),('23194702','75c6ae4f545152068a8f306dc10de15ed230436676ccfb35c3001492605ee764',0,NULL),('23210302','7140105206b35f5b96a7e44eca2e43f82f98e1c114845030aa520e0cd012f0a3',0,NULL),('23213702','44c890109a8430c212a8de251c542c64d0250a0deac8389942a787dabab6f64c',0,NULL),('23214302','5f6738f3af4027c639110dba464378bcc23238e00f7700ce8620340426de6983',0,NULL),('23218902','24972b2ce7898738587e86af3a006bd71b1929bb021dd21194da341b5d738286',0,NULL),('23224002','cc5beefdd72ba8239565bc089760e522d651e8c66902324a35a034fa89586164',0,NULL),('23234202','8b1c8803ecabdf00aea5b9c2d2069155e138d76966f8b2bbcb3c259ded57b967',0,NULL),('23243802','ff2b27fabfde059e655b09f2d07b0bf0d43afd33b7c0ba09f6924468c7381c69',0,NULL),('23250102','5221a2e09d6ce139c40c66c1442790d6b94969b8361fc37124414a5ad2bc197e',1,'2026-03-21 16:43:04');
/*!40000 ALTER TABLE `voters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `voter_id` varchar(20) NOT NULL,
  `candidate` char(1) NOT NULL,
  `voted_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `voter_id` (`voter_id`),
  KEY `candidate` (`candidate`),
  CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voters` (`id`),
  CONSTRAINT `votes_ibfk_2` FOREIGN KEY (`candidate`) REFERENCES `candidates` (`letter`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
INSERT INTO `votes` VALUES (1,'23250102','A','2026-03-21 16:43:04');
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'voting_system'
--

--
-- Dumping routines for database 'voting_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-21 17:22:18
