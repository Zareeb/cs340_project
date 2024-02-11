/*
Group 181: Marina Hampton & Zareeb Lorenzana
Description: Database of Simple Social app forward engineered from MySQL Workbench and db dump from MariaDB
*/


-- MariaDB dump 10.19  Distrib 10.5.22-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_lorenzaz
-- ------------------------------------------------------
-- Server version	10.6.16-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

--
-- Table structure for table `Followers`
--


DROP TABLE IF EXISTS `Followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Followers` (
  `followeeID` int(11) NOT NULL,
  `followerID` int(11) NOT NULL,
  `followedSince` date NOT NULL,
  PRIMARY KEY (`followeeID`,`followerID`),
  KEY `followerID_idx` (`followerID`),
  KEY `followeeID_idx` (`followeeID`),
  CONSTRAINT `FK_Followers_Users_followeeID` FOREIGN KEY (`followeeID`) REFERENCES `Users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Followers_Users_followerID` FOREIGN KEY (`followerID`) REFERENCES `Users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Followers`
--

LOCK TABLES `Followers` WRITE;
/*!40000 ALTER TABLE `Followers` DISABLE KEYS */;
INSERT INTO `Followers` VALUES (1,2,'2023-07-15'),(1,3,'2023-05-09'),(2,1,'2023-07-15'),(2,3,'2023-07-16'),(4,1,'2021-05-01');
/*!40000 ALTER TABLE `Followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Posts`
--

DROP TABLE IF EXISTS `Posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Posts` (
  `postID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `postsBody` varchar(255) NOT NULL,
  PRIMARY KEY (`postID`,`userID`),
  KEY `postedByID_idx` (`userID`),
  CONSTRAINT `userID` FOREIGN KEY (`userID`) REFERENCES `Users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Posts`
--

LOCK TABLES `Posts` WRITE;
/*!40000 ALTER TABLE `Posts` DISABLE KEYS */;
INSERT INTO `Posts` VALUES (11,4,'2023-07-20 09:00:00','Graduated from Sherborne!'),(12,4,'2023-08-20 19:00:00','My proof. Called Turing Proof.'),(13,1,'2023-05-10 03:00:00','Gonna wear the one ring!'),(14,2,'2024-01-10 05:40:00','I have a bad feeling about this'),(15,3,'2023-09-10 03:00:00','To define is to limit');
/*!40000 ALTER TABLE `Posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostsHasLikes`
--

DROP TABLE IF EXISTS `PostsHasLikes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostsHasLikes` (
  `likeID` int(11) NOT NULL AUTO_INCREMENT,
  `postID` int(11) NOT NULL,
  `likedByUserID` int(11) NOT NULL,
  `dateLiked` datetime NOT NULL,
  PRIMARY KEY (`likeID`,`postID`,`likedByUserID`),
  UNIQUE KEY `likeID_UNIQUE` (`likeID`),
  KEY `userID_idx` (`likedByUserID`),
  KEY `postID_idx` (`postID`),
  CONSTRAINT `FK_PostsHasLikes_Posts_postID` FOREIGN KEY (`postID`) REFERENCES `Posts` (`postID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PostsHasLikes_Users_likedByUserID` FOREIGN KEY (`likedByUserID`) REFERENCES `Users` (`userID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostsHasLikes`
--

LOCK TABLES `PostsHasLikes` WRITE;
/*!40000 ALTER TABLE `PostsHasLikes` DISABLE KEYS */;
INSERT INTO `PostsHasLikes` VALUES (11,2,1,'2023-08-20 19:01:00'),(12,2,2,'2023-08-20 19:10:00'),(13,2,3,'2023-08-20 19:20:00'),(14,2,5,'2023-08-20 19:45:00'),(15,4,1,'2023-09-10 03:00:00');
/*!40000 ALTER TABLE `PostsHasLikes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostsHasTags`
--

DROP TABLE IF EXISTS `PostsHasTags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostsHasTags` (
  `tagID` int(11) NOT NULL,
  `postID` int(11) NOT NULL,
  `dateTagged` date NOT NULL,
  PRIMARY KEY (`tagID`,`postID`),
  KEY `tagID_idx` (`tagID`),
  KEY `FK_PostsHasTags_Posts_postID` (`postID`),
  CONSTRAINT `FK_PostsHasTags_Posts_postID` FOREIGN KEY (`postID`) REFERENCES `Posts` (`postID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PostsHasTags_Tags_tagID` FOREIGN KEY (`tagID`) REFERENCES `Tags` (`tagID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostsHasTags`
--

LOCK TABLES `PostsHasTags` WRITE;
/*!40000 ALTER TABLE `PostsHasTags` DISABLE KEYS */;
INSERT INTO `PostsHasTags` VALUES (1,2,'2023-08-20'),(2,2,'2023-08-20'),(3,2,'2023-08-20'),(4,4,'2023-01-10'),(5,5,'2023-09-10');
/*!40000 ALTER TABLE `PostsHasTags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tags`
--

DROP TABLE IF EXISTS `Tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tags` (
  `tagID` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`tagID`),
  UNIQUE KEY `tagID_UNIQUE` (`tagID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tags`
--

LOCK TABLES `Tags` WRITE;
/*!40000 ALTER TABLE `Tags` DISABLE KEYS */;
INSERT INTO `Tags` VALUES (1,'computerscience'),(2,'rings'),(3,'cats'),(4,'iSeeYou'),(5,'movie');
/*!40000 ALTER TABLE `Tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phoneNumber` varchar(15) NOT NULL,
  `signupDate` datetime NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phoneNumber_UNIQUE` (`phoneNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (11,'RingBearer','Frodo','Baggins','frodo@bagend.com','5551234567','2021-03-11 20:00:00'),(12,'Snips','Ahsoka','Tano','snips@gmail.com','8888675309','2023-07-15 09:00:30'),(13,'ForeverYoung','Dorian','Gray','portrait@gmail.com','5551234561','2023-05-09 19:00:40'),(14,'CodeBreakerGenius','Alan','Turing','ATuring@gmail.com','3932912848','2021-01-01 10:03:04'),(15,'AliceOfWonderland','Alice','Wonderland','alice_curious@rabbit.com','9465294827','2022-04-01 10:00:00');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

/*Displays contents of tables*/
SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Tags;
SELECT * FROM Followers;
SELECT * FROM PostsHasLikes;
SELECT * FROM PostsHasTags;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-11  1:29:44
