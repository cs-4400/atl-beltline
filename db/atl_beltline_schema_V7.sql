CREATE DATABASE  IF NOT EXISTS `atl_beltline` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `atl_beltline`;
-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: atl_beltline
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assign_to`
--

DROP TABLE IF EXISTS `assign_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `assign_to` (
  `staff_username` varchar(55) NOT NULL,
  `event_name` varchar(50) NOT NULL,
  `event_start` date NOT NULL,
  `site_name` varchar(50) NOT NULL,
  PRIMARY KEY (`staff_username`,`event_name`,`event_start`,`site_name`),
  KEY `event_name` (`event_name`,`event_start`,`site_name`),
  CONSTRAINT `assign_to_ibfk_1` FOREIGN KEY (`staff_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assign_to_ibfk_2` FOREIGN KEY (`event_name`, `event_start`, `site_name`) REFERENCES `event` (`event_name`, `event_start`, `site_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assign_to`
--

LOCK TABLES `assign_to` WRITE;
/*!40000 ALTER TABLE `assign_to` DISABLE KEYS */;
INSERT INTO `assign_to` VALUES ('staff3','Arboretum Walking Tour','2019-02-08','Inman Park'),('michael.smith','Bus Tour','2019-02-01','Inman Park'),('staff2','Bus Tour','2019-02-01','Inman Park'),('michael.smith','Bus Tour','2019-02-08','Inman Park'),('robert.smith','Bus Tour','2019-02-08','Inman Park'),('robert.smith','Eastside Trail','2019-02-04','Inman Park'),('staff2','Eastside Trail','2019-02-04','Inman Park'),('michael.smith','Eastside Trail','2019-02-04','Piedmont Park'),('staff1','Eastside Trail','2019-02-04','Piedmont Park'),('michael.smith','Eastside Trail','2019-02-13','Historic Fourth Ward Park'),('staff1','Eastside Trail','2019-03-01','Inman Park'),('staff1','Official Atlanta BeltLine Bike Tour','2019-02-09','Atlanta BeltLine Center'),('robert.smith','Private Bus Tour','2019-02-01','Inman Park'),('staff1','Westside Trail','2019-02-18','Westview Cemetery'),('staff3','Westside Trail','2019-02-18','Westview Cemetery');
/*!40000 ALTER TABLE `assign_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `connects`
--

DROP TABLE IF EXISTS `connects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `connects` (
  `site_name` varchar(50) NOT NULL,
  `transit_type` varchar(25) NOT NULL,
  `transit_route` varchar(25) NOT NULL,
  PRIMARY KEY (`site_name`,`transit_type`,`transit_route`),
  KEY `transit_type` (`transit_type`,`transit_route`),
  CONSTRAINT `connects_ibfk_1` FOREIGN KEY (`site_name`) REFERENCES `site` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `connects_ibfk_2` FOREIGN KEY (`transit_type`, `transit_route`) REFERENCES `transit` (`type`, `route`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `connects`
--

LOCK TABLES `connects` WRITE;
/*!40000 ALTER TABLE `connects` DISABLE KEYS */;
INSERT INTO `connects` VALUES ('Historic Fourth Ward Park','Bike','Relay'),('Piedmont Park','Bike','Relay'),('Historic Fourth Ward Park','Bus','152'),('Inman Park','Bus','152'),('Piedmont Park','Bus','152'),('Historic Fourth Ward Park','MARTA','Blue'),('Inman Park','MARTA','Blue'),('Piedmont Park','MARTA','Blue'),('Westview Cemetery','MARTA','Blue');
/*!40000 ALTER TABLE `connects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `employee` (
  `username` varchar(50) NOT NULL,
  `emp_ID` int(11) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `address` varchar(95) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(3) DEFAULT NULL,
  `zip` int(11) DEFAULT NULL,
  `emp_type` enum('Admin','Manager','Staff') DEFAULT NULL,
  PRIMARY KEY (`emp_ID`),
  KEY `username` (`username`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('james.smith',1,'4043721234','123 East Main Street','Rochester','NY',14604,'Admin'),('michael.smith',2,'4043726789','350 Ferst Drive','Atlanta','GA',30332,'Staff'),('robert.smith',3,'1234567890','123 East Main Street','Columbus','OH',43215,'Staff'),('maria.garcia',4,'7890123456','123 East Main Street','Richland','PA',17987,'Manager'),('david.smith',5,'5124776435','350 Ferst Drive','Atlanta','GA',30332,'Manager'),('manager1',6,'8045126767','123 East Main Street','Rochester','NY',14604,'Manager'),('manager2',7,'9876543210','123 East Main Street','Rochester','NY',14604,'Manager'),('manager3',8,'5432167890','350 Ferst Drive','Atlanta','GA',30332,'Manager'),('manager4',9,'8053467565','123 East Main Street','Columbus','OH',43215,'Manager'),('manager5',10,'8031446782','801 Atlantic Drive','Atlanta','GA',30332,'Manager'),('staff1',11,'8024456765','266 Ferst Drive Northwest','Atlanta','GA',30332,'Staff'),('staff2',12,'8888888888','266 Ferst Drive Northwest','Atlanta','GA',30332,'Staff'),('staff3',13,'3333333333','801 Atlantic Drive','Atlanta','GA',30332,'Staff');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `event` (
  `event_name` varchar(50) NOT NULL,
  `event_start` date NOT NULL,
  `site_name` varchar(50) NOT NULL,
  `end_date` date DEFAULT NULL,
  `event_price` double DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `min_staff` int(11) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`event_name`,`event_start`,`site_name`),
  KEY `site_name` (`site_name`),
  CONSTRAINT `event_ibfk_1` FOREIGN KEY (`site_name`) REFERENCES `site` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event`
--

LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
INSERT INTO `event` VALUES ('Arboretum Walking Tour','2019-02-08','Inman Park','2019-02-11',5,5,1,'Official Atlanta BeltLine Arboretum Walking Tours provide an up-close view of the Westside Trail and the Atlanta BeltLine Arboretum led by Trees Atlanta Docents. The one and a half hour tours step off at at 10am (Oct thru May), and 9am (June thru September). Departure for all tours is from Rose Circle Park near Brown Middle School. More details at: https://beltline.org/visit/atlanta-beltline-tours/#arboretum-walking'),('Bus Tour','2019-02-01','Inman Park','2019-02-02',25,6,2,'The Atlanta BeltLine Partnership’s tour program operates with a natural gas-powered, ADA accessible tour bus funded through contributions from 10th & Monroe, LLC, SunTrust Bank Trusteed Foundations – Florence C. and Harry L. English Memorial Fund and Thomas Guy Woolford Charitable Trust, and AGL Resources'),('Bus Tour','2019-02-08','Inman Park','2019-02-10',25,6,2,'The Atlanta BeltLine Partnership’s tour program operates with a natural gas-powered, ADA accessible tour bus funded through contributions from 10th & Monroe, LLC, SunTrust Bank Trusteed Foundations – Florence C. and Harry L. English Memorial Fund and Thomas Guy Woolford Charitable Trust, and AGL Resources'),('Eastside Trail','2019-02-04','Inman Park','2019-02-05',0,99999,1,'A combination of multi-use trail and linear greenspace, the Eastside Trail was the first finished section of the Atlanta BeltLine trail in the old rail corridor. The Eastside Trail, which was funded by a combination of public and private philanthropic sources, runs from the tip of Piedmont Park to Reynoldstown. More details at https://beltline.org/explore-atlanta-beltline-trails/eastside-trail/'),('Eastside Trail','2019-02-04','Piedmont Park','2019-02-05',0,99999,1,'A combination of multi-use trail and linear greenspace, the Eastside Trail was the first finished section of the Atlanta BeltLine trail in the old rail corridor. The Eastside Trail, which was funded by a combination of public and private philanthropic sources, runs from the tip of Piedmont Park to Reynoldstown. More details at https://beltline.org/explore-atlanta-beltline-trails/eastside-trail/'),('Eastside Trail','2019-02-13','Historic Fourth Ward Park','2019-02-14',0,99999,1,'A combination of multi-use trail and linear greenspace, the Eastside Trail was the first finished section of the Atlanta BeltLine trail in the old rail corridor. The Eastside Trail, which was funded by a combination of public and private philanthropic sources, runs from the tip of Piedmont Park to Reynoldstown. More details at https://beltline.org/explore-atlanta-beltline-trails/eastside-trail/'),('Eastside Trail','2019-03-01','Inman Park','2019-03-02',0,99999,1,'A combination of multi-use trail and linear greenspace, the Eastside Trail was the first finished section of the Atlanta BeltLine trail in the old rail corridor. The Eastside Trail, which was funded by a combination of public and private philanthropic sources, runs from the tip of Piedmont Park to Reynoldstown. More details at https://beltline.org/explore-atlanta-beltline-trails/eastside-trail/'),('Official Atlanta BeltLine Bike Tour','2019-02-09','Atlanta BeltLine Center','2019-02-14',5,5,1,'These tours will include rest stops highlighting assets and points of interest along the Atlanta BeltLine. Staff will lead the rides, and each group will have a ride sweep to help with any unexpected mechanical difficulties.'),('Private Bus Tour','2019-02-01','Inman Park','2019-02-02',40,4,1,'Private tours are available most days, pending bus and tour guide availability. Private tours can accommodate up to 4 guests per tour, and are subject to a tour fee (nonprofit rates are available). As a nonprofit organization with limited resources, we are unable to offer free private tours. We thank you for your support and your understanding as we try to provide as many private group tours as possible. The Atlanta BeltLine Partnership’s tour program operates with a natural gas-powered, ADA accessible tour bus funded through contributions from 10th & Monroe, LLC, SunTrust Bank Trusteed Foundations – Florence C. and Harry L. English Memorial Fund and Thomas Guy Woolford Charitable Trust, and AGL Resources'),('Westside Trail','2019-02-18','Westview Cemetery','2019-02-21',0,99999,1,'The Westside Trail is a free amenity that offers a bicycle and pedestrian-safe corridor with a 14-foot-wide multi-use trail surrounded by mature trees and grasses thanks to Trees Atlanta’s Arboretum. With 16 points of entry, 14 of which will be ADA-accessible with ramp and stair systems, the trail provides numerous access points for people of all abilities. More details at: https://beltline.org/explore-atlanta-beltline-trails/westside-trail/');
/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site`
--

DROP TABLE IF EXISTS `site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `site` (
  `name` varchar(50) NOT NULL,
  `address` varchar(95) DEFAULT NULL,
  `zipcode` int(11) DEFAULT NULL,
  `open_everyday` varchar(50) DEFAULT NULL,
  `manager_username` varchar(55) NOT NULL,
  PRIMARY KEY (`name`),
  KEY `manager_username` (`manager_username`),
  CONSTRAINT `site_ibfk_1` FOREIGN KEY (`manager_username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site`
--

LOCK TABLES `site` WRITE;
/*!40000 ALTER TABLE `site` DISABLE KEYS */;
INSERT INTO `site` VALUES ('Atlanta Beltline Center','112 Krog Street Northeast',30307,'No','manager3'),('Historic Fourth Ward Park','680 Dallas Street Northeast',30308,'Yes','manager4'),('Inman Park',NULL,30307,'Yes','david.smith'),('Piedmont Park','400 Park Drive Northeast',30306,'Yes','manager2'),('Westview Cemetery','1680 Westview Drive Southwest',30310,'No','manager5');
/*!40000 ALTER TABLE `site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `take_transit`
--

DROP TABLE IF EXISTS `take_transit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `take_transit` (
  `username` varchar(50) NOT NULL,
  `type` varchar(25) NOT NULL,
  `route` varchar(25) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`username`,`date`,`type`,`route`),
  KEY `type` (`type`,`route`),
  CONSTRAINT `take_transit_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `take_transit_ibfk_2` FOREIGN KEY (`type`, `route`) REFERENCES `transit` (`type`, `route`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `take_transit`
--

LOCK TABLES `take_transit` WRITE;
/*!40000 ALTER TABLE `take_transit` DISABLE KEYS */;
INSERT INTO `take_transit` VALUES ('manager3','Bike','Relay','2019-03-20'),('maria.hernandez','Bike','Relay','2019-03-20'),('mary.smith','Bike','Relay','2019-03-23'),('manager2','Bus','152','2019-03-20'),('maria.hernandez','Bus','152','2019-03-20'),('maria.hernandez','Bus','152','2019-03-22'),('manager2','MARTA','Blue','2019-03-20'),('manager2','MARTA','Blue','2019-03-21'),('manager2','MARTA','Blue','2019-03-22'),('visitor1','MARTA','Blue','2019-03-21');
/*!40000 ALTER TABLE `take_transit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transit`
--

DROP TABLE IF EXISTS `transit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `transit` (
  `type` varchar(25) NOT NULL,
  `route` varchar(25) NOT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`type`,`route`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transit`
--

LOCK TABLES `transit` WRITE;
/*!40000 ALTER TABLE `transit` DISABLE KEYS */;
INSERT INTO `transit` VALUES ('Bike','Relay',1),('Bus','152',2),('MARTA','Blue',2);
/*!40000 ALTER TABLE `transit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `status` enum('Pending','Approved','Declined') DEFAULT 'Pending',
  `user_type` enum('Employee','Visitor','Employee, Visitor','User') DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('david.smith','dsmith456','David','Smith','Approved','Employee'),('james.smith','jsmith123','James','Smith','Approved','Employee'),('manager1','manager1','Manager','One','Pending','Employee'),('manager2','manager2','Manager','Two','Approved','Employee, Visitor'),('manager3','manager3','Manager','Three','Approved','Employee'),('manager4','manager4','Manager','Four','Approved','Employee, Visitor'),('manager5','manager5','Manager','Five','Approved','Employee, Visitor'),('maria.garcia','mgarcia123','Maria','Garcia','Approved','Employee, Visitor'),('maria.hernandez','mhernandez','Maria','Hernandez','Approved','User'),('maria.rodriguez','mrodriguez','Maria','Rodriguez','Declined','Visitor'),('mary.smith','msmith789','Mary','Smith','Approved','Visitor'),('michael.smith','msmith456','Michael','Smith','Approved','Employee, Visitor'),('robert.smith','rsmith789','Robert','Smith','Approved','Employee'),('staff1','staff1234','Staff','One','Approved','Employee'),('staff2','staff4567','Staff','Two','Approved','Employee, Visitor'),('staff3','staff7890','Staff','Three','Approved','Employee, Visitor'),('user1','user123456','User','One','Pending','User'),('visitor1','visitor123','Visitor','One','Approved','Visitor');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_email`
--

DROP TABLE IF EXISTS `user_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user_email` (
  `username` varchar(50) NOT NULL,
  `email` varchar(75) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `user_email_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_email`
--

LOCK TABLES `user_email` WRITE;
/*!40000 ALTER TABLE `user_email` DISABLE KEYS */;
INSERT INTO `user_email` VALUES ('david.smith','dsmith@outlook.com'),('james.smith','jsmith@gatech.edu'),('james.smith','jsmith@gmail.com'),('james.smith','jsmith@hotmail.com'),('james.smith','jsmith@outlook.com'),('manager1','m1@beltline.com'),('manager2','m2@beltline.com'),('manager3','m3@beltline.com'),('manager4','m4@beltline.com'),('manager5','m5@beltline.com'),('maria.garcia','mgarcia@gatech.edu'),('maria.garcia','mgarcia@yahoo.com'),('maria.hernandez','mh@gatech.edu'),('maria.hernandez','mh123@gmail.com'),('maria.rodriguez','mrodriguez@gmail.com'),('mary.smith','mary@outlook.com'),('michael.smith','msmith@gmail.com'),('robert.smith','rsmith@hotmail.com'),('staff1','s1@beltline.com'),('staff2','s2@beltline.com'),('staff3','s3@beltline.com'),('user1','u1@beltline.com'),('visitor1','v1@beltline.com');
/*!40000 ALTER TABLE `user_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_event`
--

DROP TABLE IF EXISTS `visit_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `visit_event` (
  `username` varchar(50) NOT NULL,
  `event_name` varchar(50) NOT NULL,
  `event_start` date NOT NULL,
  `site_name` varchar(50) NOT NULL,
  `visit_date` date NOT NULL,
  PRIMARY KEY (`username`,`visit_date`,`event_name`,`event_start`,`site_name`),
  KEY `event_name` (`event_name`,`event_start`,`site_name`),
  CONSTRAINT `visit_event_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visit_event_ibfk_2` FOREIGN KEY (`event_name`, `event_start`, `site_name`) REFERENCES `event` (`event_name`, `event_start`, `site_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_event`
--

LOCK TABLES `visit_event` WRITE;
/*!40000 ALTER TABLE `visit_event` DISABLE KEYS */;
INSERT INTO `visit_event` VALUES ('mary.smith','Arboretum Walking Tour','2019-02-08','Inman Park','2019-02-10'),('manager2','Bus Tour','2019-02-01','Inman Park','2019-02-02'),('manager4','Bus Tour','2019-02-01','Inman Park','2019-02-01'),('manager5','Bus Tour','2019-02-01','Inman Park','2019-02-02'),('maria.garcia','Bus Tour','2019-02-01','Inman Park','2019-02-02'),('mary.smith','Bus Tour','2019-02-01','Inman Park','2019-02-01'),('staff2','Bus Tour','2019-02-01','Inman Park','2019-02-02'),('mary.smith','Eastside Trail','2019-02-04','Piedmont Park','2019-02-04'),('mary.smith','Eastside Trail','2019-02-13','Historic Fourth Ward Park','2019-02-13'),('mary.smith','Eastside Trail','2019-02-13','Historic Fourth Ward Park','2019-02-14'),('visitor1','Eastside Trail','2019-02-13','Historic Fourth Ward Park','2019-02-14'),('mary.smith','Official Atlanta BeltLine Bike Tour','2019-02-09','Atlanta BeltLine Center','2019-02-10'),('visitor1','Official Atlanta BeltLine Bike Tour','2019-02-09','Atlanta BeltLine Center','2019-02-10'),('mary.smith','Private Bus Tour','2019-02-01','Inman Park','2019-02-01'),('mary.smith','Private Bus Tour','2019-02-01','Inman Park','2019-02-02'),('mary.smith','Westside Trail','2019-02-18','Westview Cemetery','2019-02-19'),('visitor1','Westside Trail','2019-02-18','Westview Cemetery','2019-02-19');
/*!40000 ALTER TABLE `visit_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_site`
--

DROP TABLE IF EXISTS `visit_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `visit_site` (
  `username` varchar(50) NOT NULL,
  `site_name` varchar(50) NOT NULL,
  `visit_date` date NOT NULL,
  PRIMARY KEY (`username`,`visit_date`,`site_name`),
  KEY `site_name` (`site_name`),
  CONSTRAINT `visit_site_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visit_site_ibfk_2` FOREIGN KEY (`site_name`) REFERENCES `site` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_site`
--

LOCK TABLES `visit_site` WRITE;
/*!40000 ALTER TABLE `visit_site` DISABLE KEYS */;
INSERT INTO `visit_site` VALUES ('mary.smith','Atlanta Beltline Center','2019-02-01'),('mary.smith','Atlanta Beltline Center','2019-02-10'),('visitor1','Atlanta Beltline Center','2019-02-09'),('visitor1','Atlanta Beltline Center','2019-02-13'),('mary.smith','Historic Fourth Ward Park','2019-02-02'),('visitor1','Historic Fourth Ward Park','2019-02-11'),('mary.smith','Inman Park','2019-02-01'),('mary.smith','Inman Park','2019-02-02'),('mary.smith','Inman Park','2019-02-03'),('visitor1','Inman Park','2019-02-01'),('mary.smith','Piedmont Park','2019-02-02'),('visitor1','Piedmont Park','2019-02-01'),('visitor1','Piedmont Park','2019-02-11'),('visitor1','Westview Cemetery','2019-02-06');
/*!40000 ALTER TABLE `visit_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'atl_beltline'
--

--
-- Dumping routines for database 'atl_beltline'
--
/*!50003 DROP PROCEDURE IF EXISTS `create_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `create_event`(

    IN p_event_name varchar(50),

    IN p_event_start date,

    IN p_end_date date,

    IN p_min_staff INT,

    IN p_site_name varchar(50),

    IN p_price float,

    IN p_capacity INT,

    IN p_description varchar(255),

    IN staff_assigned varchar(255))
BEGIN

    Declare big_len INT;

    Declare small_len INT;



    INSERT INTO EVENT VALUES (p_event_name, p_event_start, p_site_name, p_end_date, p_price, p_capacity, p_min_staff, p_description);



    IF staff_assigned IS NULL THEN

    SET staff_assigned = "";

    END IF;



    WHILE staff_assigned != '' DO

    SET big_len = LENGTH(staff_assigned);



    INSERT IGNORE INTO assign_to (staff_username, event_name, event_start, site_name) VALUES (SUBSTRING_INDEX(staff_assigned, ',', 1), e_name, s_date, v_site_name);

    SET small_len = LENGTH(SUBSTRING_INDEX(staff_assigned, ',', 1));

    SET staff_assigned = MID(staff_assigned, small_len + 2, big_len);



    END WHILE;



    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `create_site`(IN p_name VARCHAR(50), IN p_address VARCHAR(95), IN p_zip INT, IN p_manager VARCHAR(55), IN p_open VARCHAR(50))
BEGIN

    INSERT INTO site VALUES (p_name, p_address, p_zip, p_open, p_manager);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_transit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `create_transit`(

    IN p_type varchar(25),

    IN p_route varchar(25),

    IN p_price float,

    IN p_connected_sites varchar(255))
BEGIN

    Declare big_len INT;

    Declare small_len INT;



    INSERT INTO transit VALUES (p_type, p_route, p_price);



    IF p_connected_sites IS NULL THEN

    SET p_connected_sites = "";

    END IF;



    WHILE p_connected_sites != '' DO

    SET big_len = LENGTH(p_connected_sites);



    INSERT IGNORE INTO connects (site_name, transit_type, transit_route) VALUES (SUBSTRING_INDEX(p_connected_sites, ',', 1), p_type, p_route);

    SET small_len = LENGTH(SUBSTRING_INDEX(p_connected_sites, ',', 1));

    SET p_connected_sites = MID(p_connected_sites, small_len + 2, big_len);



    END WHILE;



    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `display_transit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `display_transit`(IN p_type VARCHAR(25), IN p_route VARCHAR(25))
BEGIN

    Select type, route, price, connected_sites from

    (SELECT transit_type, transit_route, group_concat(site_name SEPARATOR ', ') as connected_sites from connects where transit_type = p_type and transit_route =p_route) connects_t

    join

    (select price, type, route from transit where type = p_type and route =p_route)

    transit_t

    on (connects_t.transit_type = transit_t.type and connects_t.transit_route = transit_t.route);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `enter_emails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `enter_emails`(

    IN p_username VARCHAR(50),

    IN p_emails VARCHAR(255))
BEGIN

    DECLARE big_len INT;

    DECLARE small_len INT;



    IF p_emails IS NULL THEN

    SET p_emails = "";

    END IF;



    WHILE p_emails != '' DO

    SET big_len = LENGTH(p_emails);



    INSERT IGNORE INTO user_email (username, email) VALUES (p_username, SUBSTRING_INDEX(p_emails, ',', 1));

    SET small_len = LENGTH(SUBSTRING_INDEX(p_emails, ',', 1));

    SET p_emails = MID(p_emails, small_len + 2, big_len);



    END WHILE;



    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `event_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `event_report`(IN e_name VARCHAR(50), IN s_date DATE, IN price DECIMAL(10, 2))
BEGIN

    SELECT visit_date, count(*) visits, count(*) * price

    from visit_event where event_name = e_name and event_start = s_date

    GROUP BY visit_date order by visit_date;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `event_staffs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `event_staffs`(IN e_name VARCHAR(50), IN s_date DATE)
BEGIN

    select CONCAT(first_name, ' ', last_name) as staff, username

    from user where username in (SELECT staff_username from assign_to

    where event_name = e_name and event_start = s_date);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `explore_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `explore_event`(IN p_username varchar(50))
BEGIN

    SELECT event.event_name AS event_name, event.site_name as site_name, event.event_price as ticket_price, event.capacity - COALESCE(a.tickets_bought, 0) AS tickets_remaining, COALESCE(b.total_visits, 0) AS total_visits, COALESCE(c.my_visits, 0) AS my_visits FROM event

    LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS tickets_bought FROM visit_event GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)

    LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS total_visits FROM visit_event GROUP BY event_name, site_name, event_start) b USING (event_name, site_name, event_start)

    LEFT JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS my_visits FROM visit_event WHERE username = p_username GROUP BY event_name, site_name, event_start) c USING (event_name, site_name, event_start);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `explore_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `explore_site`(IN p_username varchar(50))
BEGIN

    SELECT site.name AS site_name, COALESCE(a.event_count, 0) AS event_count, COALESCE(b.total_event_visits, 0) + COALESCE(c.total_site_visits, 0) AS total_visits, COALESCE(d.my_event_visits, 0) + COALESCE(e.my_site_visits, 0) AS my_visits FROM site

    LEFT JOIN (SELECT site_name AS name, COUNT(*) AS event_count FROM event GROUP BY name) a USING (name)

    LEFT JOIN (SELECT site_name as name, COUNT(*) AS total_event_visits FROM visit_event GROUP BY name) b USING (name)

    LEFT JOIN (SELECT site_name as name, COUNT(*) AS total_site_visits FROM visit_site GROUP BY name) c USING (name)

    LEFT JOIN (SELECT site_name as name, COUNT(*) AS my_event_visits FROM visit_event WHERE username = p_username GROUP BY name) d USING (name)

    LEFT JOIN (SELECT site_name as name, COUNT(*) AS my_site_visits FROM visit_site WHERE username = p_username GROUP BY name) e USING (name);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `filter_staff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `filter_staff`(

    IN p_site_name varchar(50))
BEGIN

    SELECT b.staff_name, a.event_shifts FROM

    (SELECT staff_username as username, COUNT(*) AS event_shifts FROM assign_to WHERE site_name = p_site_name GROUP BY username) a join (SELECT username, CONCAT(first_name, " ", last_name) AS staff_name FROM user) b USING (username);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `filter_visitor_visits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `filter_visitor_visits`(IN p_username varchar(50))
BEGIN

    SELECT visit_event.visit_date as date, visit_event.event_name as event, visit_event.site_name as site, event.event_price as price FROM visit_event, event WHERE visit_event.username = p_username

    UNION ALL

    SELECT visit_site.visit_date as date, NULL as event, visit_site.site_name as site, 0 as price FROM visit_site WHERE visit_site.username = p_username;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_available_staff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_available_staff`(

    IN p_start_date DATE,

    IN p_end_date DATE)
BEGIN

    SELECT CONCAT(first_name, " ", last_name) AS staff_name FROM (user JOIN (SELECT username FROM employee WHERE emp_type = “Staff”) a USING (username)) WHERE NOT EXISTS (SELECT * FROM (event JOIN assign_to USING (event_name, event_start, site_name)) WHERE user.username = assign_to.staff_username AND assign_to.event_start <= p_end_date AND event.end_date >= p_start_date);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_daily_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_daily_detail`(

    IN p_manager_username varchar(50),

    IN p_site varchar(50),

    IN p_date DATE)
BEGIN

    SELECT event.event_name, a.staff_names, b.visits, b.visits * event.event_price AS revenue FROM

    event JOIN (SELECT event_name, site_name, event_start, GROUP_CONCAT(staff_name ORDER BY staff_name ASC SEPARATOR ", ") AS staff_names FROM (SELECT assign_to.event_name, assign_to.site_name, assign_to.event_start, CONCAT(user.first_name, " ", user.last_name) as staff_name FROM assign_to, user WHERE assign_to.staff_username = user.username) d GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)

    JOIN (SELECT event_name, site_name, event_start, COUNT(*) AS visits FROM visit_event WHERE visit_date = p_date GROUP BY event_name, site_name, event_start) b USING (event_name, site_name, event_start)

    WHERE event.site_name = p_site AND p_date BETWEEN event.event_start AND event.end_date;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_event_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_event_detail`(

    IN p_name varchar(50),

    IN p_site_name varchar(50),

    IN p_start_date DATE)
BEGIN

    SELECT event.event_name AS event, event.site_name AS site, event.event_start AS start_date, event.end_date AS end_date, event.event_price AS ticket_price, event.capacity - (SELECT COUNT(*) FROM visit_event WHERE event_name = p_name AND event_start = p_start_date AND site_name = p_site_name) AS tickets_remaining FROM event, visit_event WHERE event.event_name = p_name GROUP BY event.event_name;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_event_staff_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_event_staff_detail`(

    IN p_event_name varchar(50),

    IN p_site_name varchar(50),

    IN p_start_date DATE)
BEGIN

    SELECT event.event_name AS event,

    event.site_name AS site,

    event.event_start AS start_date,

    event.end_date,

    DATEDIFF(event.end_date, event.event_start) + 1AS duration,

    (SELECT GROUP_CONCAT(CONCAT(user.first_name, " ", user.last_name) ORDER BY user.first_name ASC SEPARATOR ", ") FROM user, (SELECT staff_username FROM assign_to WHERE event_name = p_event_name AND site_name = p_site_name AND event_start = p_start_date) a WHERE a.staff_username = user.username) AS staff_assigned,

    event.capacity,

    event.event_price AS ticket_price,

    event.description

    FROM event, visit_event WHERE event.event_name = p_event_name AND event.site_name = p_site_name AND event.event_start = p_start_date GROUP BY event.event_name, event.site_name, event.event_start;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_schedule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_schedule`(IN p_staff_username varchar(50))
BEGIN

    SELECT event.event_name, event.site_name, event.event_start AS start_date, event.end_date, a.staff_count

    FROM event JOIN (SELECT event_name, site_name, event_start, COUNT(event_name) AS staff_count FROM assign_to GROUP BY event_name, site_name, event_start) a USING (event_name, site_name, event_start)

    JOIN (SELECT event_name, site_name, event_start FROM assign_to WHERE staff_username = p_staff_username) b USING (event_name, site_name, event_start);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_site_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_site_detail`(IN p_name varchar(50))
BEGIN

    SELECT name, CONCAT(address, ", Atlanta, GA ", zipcode) AS address, open_everyday FROM site WHERE name = p_name;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_site_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_site_report`(

    IN p_site_name varchar(50),

    IN p_start_date date,

    IN p_end_date date)
BEGIN

    DROP TABLE IF EXISTS dates;

    CREATE TABLE dates AS select * from

    (select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) date from

     (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,

     (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,

     (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,

     (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,

     (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v

    where date between p_start_date and p_end_date;



    SELECT dates.date, COALESCE(c.event_count, 0) AS event_count, COALESCE(d.staff_count, 0) AS staff_count, COALESCE(a.event_visits, 0) + COALESCE(b.site_visits, 0) AS total_visits, COALESCE(a.total_revenue, 0) AS total_revenue FROM

    dates

    LEFT JOIN (SELECT visit_date AS date, COUNT(*) AS event_visits, SUM(event_price) AS total_revenue FROM (visit_event JOIN event USING (event_name, event_start, site_name)) WHERE site_name = p_site_name GROUP BY visit_date) a USING (date)

    LEFT JOIN (SELECT visit_date AS date, COUNT(*) AS site_visits FROM visit_site WHERE site_name = p_site_name GROUP BY visit_date) b USING (date)

    LEFT JOIN (SELECT dates.date, COUNT(event.event_name) AS event_count FROM dates, event WHERE site_name = p_site_name AND dates.date BETWEEN event.event_start AND event.end_date GROUP BY date) c USING (date)

    LEFT JOIN (SELECT dates.date, COUNT(assign_to.staff_username) AS staff_count FROM dates, (event JOIN assign_to USING (event_name, event_start, site_name)) WHERE site_name = p_site_name AND dates.date BETWEEN event.event_start AND event.end_date GROUP BY date) d USING (date)

    ORDER BY date ASC;



    DROP TABLE dates;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_transits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_transits`()
BEGIN

    SELECT transit.route, transit.type, transit.price, COUNT(*) AS connected_sites FROM (transit JOIN connects ON transit.type = connects.transit_type AND transit.route = connects.transit_route) GROUP BY route, type;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_transit_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_transit_detail`(IN p_type varchar(25), IN p_route varchar(25))
BEGIN

    SELECT transit.route AS route, transit.type AS type, transit.price AS price, COUNT(connects.site_name) AS connected_sites FROM transit, connects WHERE transit.route = connects.transit_route AND transit.type = connects.transit_type;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_unassigned_managers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `get_unassigned_managers`()
BEGIN

    SELECT CONCAT(first_name, " ", last_name) AS manager_name FROM (user JOIN (SELECT username FROM employee WHERE emp_type = “Manager”) a USING (username)) WHERE NOT EXISTS (SELECT * FROM site WHERE manager_username = a.username);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `login_user`(IN p_email VARCHAR(75))
BEGIN

    SELECT

        email, password, uname1, user_type

    FROM

        (SELECT

            username AS uname1, email

        FROM

            user_email) email_t

            JOIN

        (SELECT

            username AS uname2, user_type, password

        FROM

            user) user_t ON (email_t.uname1 = user_t.uname2)

    WHERE

        email = p_email;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log_event_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `log_event_visit`(

    IN p_username varchar(50),

    IN p_event_name varchar(50),

    IN p_event_start varchar(50),

    IN p_site_name varchar(50),

    IN p_visit_date date)
BEGIN

    DECLARE v_end_date DATE;



    SELECT end_date INTO v_end_date FROM event WHERE event_name = p_event_name AND event_start = p_event_start AND site_name = p_site_name;



    IF NOT EXISTS (SELECT * FROM visit_event WHERE username = p_username AND event_name = p_event_name AND event_start = p_event_start AND site_name = p_site_name AND visit_date = p_visit_date)

    AND p_visit_date BETWEEN p_event_start AND v_end_date THEN

    INSERT INTO visit_event (username, event_name, event_start, site_name, visit_date) VALUES (p_username, p_event_name, p_event_start, p_site_name, p_visit_date);

    END IF;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log_site_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `log_site_visit`(

    IN p_username varchar(50),

    IN p_site_name varchar(50),

    IN p_visit_date date)
BEGIN

    IF NOT EXISTS (SELECT * FROM visit_site WHERE username = p_username AND site_name = p_site_name AND visit_date = p_visit_date) THEN

    INSERT INTO visit_site (username, site_name, visit_date) VALUES (p_username, p_site_name, p_visit_date);

    END IF;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log_transit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `log_transit`(

    IN p_username varchar(50),

    IN p_type varchar(25),

    IN p_route varchar(25),

    IN p_transit_date date)
BEGIN

    INSERT INTO take_transit (username, type, route, date) VALUES (p_username, p_type, p_route, p_transit_date);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `log_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `log_visit`(

    IN p_username varchar(50),

    IN p_site_name varchar(50),

    IN p_visit_date date)
BEGIN

    IF NOT EXISTS (SELECT * FROM visit_site WHERE username = p_username AND site_name = p_site_name AND visit_date = p_visit_date) THEN

    INSERT INTO visit_site (username, site_name, visit_date) VALUES (p_username, p_site_name, p_visit_date);

    END IF;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manage_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `manage_event`()
BEGIN

    SELECT event.event_name, c.staff_count, b.duration, COALESCE(a.total_visits, 0) AS total_visits, COALESCE(a.total_revenue, 0) AS total_revenue FROM

    event LEFT JOIN (SELECT event_name, event_start, site_name, COUNT(*) AS total_visits, SUM(event_price) AS total_revenue FROM (visit_event JOIN event USING (event_name, event_start, site_name)) GROUP BY event_name, event_start, site_name) a USING (event_name, event_start, site_name)

    LEFT JOIN (SELECT event_name, event_start, site_name, DATEDIFF(end_date, event_start) + 1 AS duration FROM event) b USING (event_name, event_start, site_name)

    LEFT JOIN (SELECT event_name, event_start, site_name, COUNT(*) AS staff_count FROM assign_to GROUP BY event_name, event_start, site_name) c USING (event_name, event_start, site_name);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manage_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `manage_profile`(IN p_username varchar(50))
begin





    SELECT first_name, last_name, uname1 AS username, email, emp_ID, phone, address, city, state, zip, site_name

    FROM

        (SELECT

            first_name, last_name, uname1, email

        FROM

            (SELECT

            first_name, last_name, username AS uname1

        FROM

            user

        WHERE

            username = p_username) user_t

        JOIN (SELECT

            email, username AS uname2

        FROM

            user_email

        WHERE

            username = p_username) email_t ON (user_t.uname1 = email_t.uname2)) t_1

            JOIN

        (SELECT

            uname2, phone, address, city, state, zip, site_name, emp_ID

        FROM

            (SELECT

            username AS uname1, phone, address, city, state, zip, emp_ID

        FROM

            employee

        WHERE

            username = p_username) emp_t

        JOIN (SELECT

            manager_username AS uname2, name AS site_name

        FROM

            site

        WHERE

            manager_username = p_username) site_t ON (emp_t.uname1 = site_t.uname2)) t_2 ON (t_1.uname1 = t_2.uname2);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manage_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `manage_site`()
BEGIN

    SELECT

        site_name, name, open_everyday

    FROM

        (SELECT

            name AS site_name, manager_username AS uname1, open_everyday

        FROM

            site) site_t

            JOIN

        (SELECT

            CONCAT(first_name, ' ', last_name) AS name,

                username AS uname2

        FROM

            user) user_t ON (site_t.uname1 = user_t.uname2);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manage_transit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `manage_transit`()
BEGIN

    Select type, route, price, num_sites, num_log from

    (Select type, route, price, num_sites from

    (Select * from transit) transit_t

    join

    (select transit_type, transit_route, count(*) as num_sites from connects group by transit_type, transit_route) connect_t

    on (transit_t.type = connect_t.transit_type and transit_t.route = connect_t.transit_route)) t_1





    join

    (select type as t_type, route as t_route, count(*) as num_log from take_transit group by type, route) t_2

    on (t_1.type = t_2.t_type and t_1.route = t_2.t_route);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manage_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `manage_user`(IN p_username varchar(50))
begin

    SELECT

        uname1 AS username, email_count, user_type, status

    FROM

        (SELECT

            username AS uname1, COUNT(*) AS email_count

        FROM

            user_email

        WHERE

            username = p_username

        GROUP BY username) email_t

            JOIN

        (SELECT

            user_type, status, username AS uname2

        FROM

            user

        WHERE

            username = p_username) user_t ON (email_t.uname1 = user_t.uname2);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `m_edit_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `m_edit_event`(IN e_name VARCHAR(50), IN s_date DATE)
BEGIN

    SELECT event_name, event_price, event_start, end_date, min_staff, capacity, description

    from event where event_name = e_name and event_start = s_start;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `new_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `new_site`(IN p_name VARCHAR(50), IN p_address VARCHAR(95), IN p_zip INT, IN p_manager VARCHAR(55), IN p_open VARCHAR(50))
BEGIN

    INSERT INTO site VALUES (p_name, p_address, p_zip, p_open, p_manager);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_employee`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_phone VARCHAR(10),

    IN p_address VARCHAR(95),

    IN p_city VARCHAR(50),

    IN p_state VARCHAR(3),

    IN p_zip INT,

    IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),

    IN p_empID INT,

    IN p_emails VARCHAR(255))
BEGIN

    CALL register_helper_2(p_username, p_fname, p_lname, p_pw, p_phone, p_address, p_city, p_state, p_zip, p_emp_type, "Employee", p_empID, p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_employee_visitor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_employee_visitor`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_phone VARCHAR(10),

    IN p_address VARCHAR(95),

    IN p_city VARCHAR(50),

    IN p_state VARCHAR(3),

    IN p_zip INT,

    IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),

    IN p_empID INT,

    IN p_emails VARCHAR(255))
BEGIN

    CALL register_helper_2(p_username, p_fname, p_lname, p_pw, p_phone, p_address, p_city, p_state, p_zip, p_emp_type, "Employee, Visitor", p_empID, p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_helper_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_helper_1`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_user_type ENUM('Visitor', 'User'),

    IN p_emails VARCHAR(255))
BEGIN

    INSERT INTO user VALUES (p_username, p_pw, p_fname, p_lname, "Pending", p_user_type);



    CALL enter_emails(p_username, p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_helper_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_helper_2`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_phone VARCHAR(10),

    IN p_address VARCHAR(95),

    IN p_city VARCHAR(50),

    IN p_state VARCHAR(3),

    IN p_zip INT,

    IN p_emp_type ENUM('Admin', 'Manager', 'Staff'),

    IN p_user_type ENUM('Employee', 'Employee, Visitor'),

    IN p_empID INT,

    IN p_emails VARCHAR(255))
BEGIN

    INSERT INTO user VALUES (p_username, p_pw, p_fname, p_lname, 'Pending', p_user_type);

    INSERT INTO employee VALUES (p_username, p_empID, p_phone, p_address, p_city, p_state, p_zip, p_emp_type);



    CALL enter_emails(p_username, p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_user`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_emails VARCHAR(255))
BEGIN

    CALL register_helper_1(p_username, p_fname, p_lname, p_pw, 'User', p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_visitor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `register_visitor`(

    IN p_username VARCHAR(50),

    IN p_fname VARCHAR(50),

    IN p_lname VARCHAR(50),

    IN p_pw VARCHAR(50),

    IN p_emails VARCHAR(255))
BEGIN

    CALL register_helper_1(p_username, p_fname, p_lname, p_pw, 'Visitor', p_emails);

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `transit_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `transit_history`(IN p_username varchar(50))
BEGIN

    SELECT take_transit.date as date, take_transit.route as route, take_transit.type as transport_type, transit.price as price FROM take_transit, transit WHERE username = p_username and transit.type = take_transit.type and transit.route = take_transit.route;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `update_event`(

    IN e_name VARCHAR(50),

    IN s_date DATE,

    IN new_description VARCHAR(255),

    IN staff_assigned VARCHAR(255))
BEGIN

    Declare big_len INT;

    Declare small_len INT;

    Declare v_site_name varchar(50);



    UPDATE event

    SET description = new_description

    where event_name = e_name and event_start = s_date;



    SELECT site_name INTO v_site_name FROM event WHERE event_name = e_name AND event_start = s_date;



    IF staff_assigned IS NULL THEN

    SET staff_assigned = "";

    END IF;



    WHILE staff_assigned != '' DO

    SET big_len = LENGTH(staff_assigned);



    INSERT IGNORE INTO assign_to (staff_username, event_name, event_start, site_name) VALUES (SUBSTRING_INDEX(staff_assigned, ',', 1), e_name, s_date, v_site_name);

    SET small_len = LENGTH(SUBSTRING_INDEX(staff_assigned, ',', 1));

    SET staff_assigned = MID(staff_assigned, small_len + 2, big_len);



    END WHILE;





    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `update_site`(IN new_name varchar(50),

    IN new_zipcode INT, IN new_address varchar(95), IN new_manager varchar(55),

    IN new_open VARCHAR(55), IN old_name varchar(50))
BEGIN

    UPDATE site set name=new_name, zipcode=new_zipcode, address=new_address, manager_username=new_manager, open_everyday=new_open where name=old_name;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_transit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`cs4400user`@`%` PROCEDURE `update_transit`(

    IN p_old_type varchar(25),

    IN p_old_route varchar(25),

    IN p_type varchar(25),

    IN p_route varchar(25),

    IN p_price float,

    IN p_connected_sites varchar(255))
BEGIN

    Declare big_len INT;

    Declare small_len INT;



    UPDATE transit SET type = p_type, route = p_route, price = p_price WHERE type = p_old_type AND route = p_old_route;



    IF p_connected_sites IS NULL THEN

    SET p_connected_sites = "";

    END IF;



    WHILE p_connected_sites != '' DO

    SET big_len = LENGTH(p_connected_sites);



    INSERT IGNORE INTO connects (site_name, transit_type, transit_route) VALUES (SUBSTRING_INDEX(p_connected_sites, ',', 1), p_type, p_route);

    SET small_len = LENGTH(SUBSTRING_INDEX(p_connected_sites, ',', 1));

    SET p_connected_sites = MID(p_connected_sites, small_len + 2, big_len);



    END WHILE;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-20 23:32:50
