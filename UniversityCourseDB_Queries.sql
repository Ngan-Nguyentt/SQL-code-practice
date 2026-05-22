-- =====================================================================
-- Lab 3 - UniversityCourseManagement
-- (Run after the Lab 2 schema/data has been created.)
-- =====================================================================

-- =====================================================================
-- PART 1: Additional data + SELECT queries
-- =====================================================================

-- Insert Data
INSERT INTO Student (Student_ID, Name, Date_of_Birth, Email) VALUES
(6, 'Frank Miller', '2001-12-22','frank.miller@example.com');
INSERT INTO Course (Course_ID, Course_Name, Credit_Hours, Instructor_ID) VALUES
(106,'Computer Networks', 3, 5);
INSERT INTO Enrollment (Student_ID, Course_ID, Grade) VALUES
(4, 101, 'A');

-- Select queries
SELECT Name
FROM Student;

SELECT  Course_Name, Credit_Hours
FROM Course;

SELECT Department, Office_Location
FROM Instructor
WHERE Name = 'Dr. Alan Turing';

-- Filtering Results
SELECT Name, Email
FROM Student
WHERE Date_of_Birth > '2000-01-01';

SELECT Course_Name, Credit_Hours
FROM Course
WHERE Credit_Hours = 4;

SELECT Name
FROM Instructor
WHERE Department ='Computer Science';


-- =====================================================================
-- PART 2: Full database dump (mysqldump)
-- =====================================================================
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: universitycoursemanagement
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `Course_ID` int NOT NULL,
  `Course_Name` varchar(100) DEFAULT NULL,
  `Credit_Hours` int DEFAULT NULL,
  `Instructor_ID` int DEFAULT NULL,
  PRIMARY KEY (`Course_ID`),
  KEY `Instructor_ID` (`Instructor_ID`),
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`Instructor_ID`) REFERENCES `instructor` (`Instructor_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (101,'Database Design',3,1),(102,'Introduction to Programming',4,2),(103,'Data Structures',3,2),(104,'Operating Systems',3,3),(105,'Artificial Intelligence',4,4),(106,'Computer Networks',3,5);
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollment`
--

DROP TABLE IF EXISTS `enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollment` (
  `Student_ID` int NOT NULL,
  `Course_ID` int NOT NULL,
  `Grade` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`Student_ID`,`Course_ID`),
  KEY `Course_ID` (`Course_ID`),
  CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student` (`Student_ID`),
  CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`Course_ID`) REFERENCES `course` (`Course_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollment`
--

LOCK TABLES `enrollment` WRITE;
/*!40000 ALTER TABLE `enrollment` DISABLE KEYS */;
INSERT INTO `enrollment` VALUES (1,101,'A'),(1,102,'B'),(2,103,'A'),(2,104,'C'),(3,101,'B'),(3,105,'A'),(4,101,'A'),(4,102,'A'),(4,103,'B'),(5,104,'A'),(5,105,'B');
/*!40000 ALTER TABLE `enrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructor`
--

DROP TABLE IF EXISTS `instructor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instructor` (
  `Instructor_ID` int NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Office_Location` varchar(100) DEFAULT NULL,
  `Department` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Instructor_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor`
--

LOCK TABLES `instructor` WRITE;
/*!40000 ALTER TABLE `instructor` DISABLE KEYS */;
INSERT INTO `instructor` VALUES (1,'Dr. Alan Turing','Room 101','Computer Science'),(2,'Dr. Ada Lovelace','Room 102','Computer Science'),(3,'Dr. John von Neumann','Room 103','Engineering'),(4,'Dr. Grace Hopper','Room 104','Mathematics'),(5,'Dr. Donald Knuth','Room 105','Computer Science');
/*!40000 ALTER TABLE `instructor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `Student_ID` int NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Date_of_Birth` date DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Student_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'Alice Johnson','2000-01-15','alice.johnson@example.com'),(2,'Bob Smith','1999-05-21','bob.smith@example.com'),(3,'Charlie Brown','2001-09-08','charlie.brown@example.com'),(4,'Diana Prince','2000-03-30','diana.prince@example.com'),(5,'Eve Adams','2000-11-12','eve.adams@example.com'),(6,'Frank Miller','2001-12-22','frank.miller@example.com');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-30 12:36:16
