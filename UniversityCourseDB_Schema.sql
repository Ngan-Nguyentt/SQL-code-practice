/*
Lab2-CST2102
This university course management database is designed to track and manage student enrollments, courses, instructors, and academic performance. It contains four key entities: Students, Courses, Instructors, and Enrollments. The Student table stores basic student details like ID, name, date of birth, and email, while the Instructor table keeps track of instructors and their department affiliations. The Course table records information about each course, including its name, credit hours, and assigned instructor. The Enrollment table serves as an associative entity, capturing the many-to-many relationship between students and courses by logging which students are enrolled in which courses, along with the grades they have received. This structure allows for efficient querying of data, such as determining course enrollments, instructor assignments, and student performance.

*/


-- =====================================================================
-- PART 1: DDL - Schema creation (UniversityCourseManagement)
-- =====================================================================

-- Create the database
CREATE DATABASE UniversityCourseManagement;

-- Use the database
USE UniversityCourseManagement;

-- Create the Student table
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Birth DATE,
    Email VARCHAR(100)
);

-- Create the Course table
CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(100),
    Credit_Hours INT
);

-- Create the Instructor table
CREATE TABLE Instructor (
    Instructor_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Office_Location VARCHAR(100),
    Department VARCHAR(100)
);

-- Create the Enrollment table (Associative Entity)
CREATE TABLE Enrollment (
    Student_ID INT,
    Course_ID INT,
    Grade VARCHAR(2),
    PRIMARY KEY (Student_ID, Course_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

-- Add a relationship between Instructor and Course
ALTER TABLE Course
ADD Instructor_ID INT,
ADD FOREIGN KEY (Instructor_ID) REFERENCES Instructor(Instructor_ID);


-- =====================================================================
-- PART 2: DML - Sample data
-- =====================================================================

-- Insert sample students
INSERT INTO Student (Student_ID, Name, Date_of_Birth, Email) VALUES
(1, 'Alice Johnson', '2000-01-15', 'alice.johnson@example.com'),
(2, 'Bob Smith', '1999-05-21', 'bob.smith@example.com'),
(3, 'Charlie Brown', '2001-09-08', 'charlie.brown@example.com'),
(4, 'Diana Prince', '2000-03-30', 'diana.prince@example.com'),
(5, 'Eve Adams', '2000-11-12', 'eve.adams@example.com');

-- Insert sample instructors
INSERT INTO Instructor (Instructor_ID, Name, Office_Location, Department) VALUES
(1, 'Dr. Alan Turing', 'Room 101', 'Computer Science'),
(2, 'Dr. Ada Lovelace', 'Room 102', 'Computer Science'),
(3, 'Dr. John von Neumann', 'Room 103', 'Engineering'),
(4, 'Dr. Grace Hopper', 'Room 104', 'Mathematics'),
(5, 'Dr. Donald Knuth', 'Room 105', 'Computer Science');

-- Insert sample courses with associated Instructor_ID values
INSERT INTO Course (Course_ID, Course_Name, Credit_Hours, Instructor_ID) VALUES
(101, 'Database Design', 3, 1),
(102, 'Introduction to Programming', 4, 2),
(103, 'Data Structures', 3, 2),
(104, 'Operating Systems', 3, 3),
(105, 'Artificial Intelligence', 4, 4);

-- Insert sample enrollments (relationships between students and courses)
INSERT INTO Enrollment (Student_ID, Course_ID, Grade) VALUES
(1, 101, 'A'),
(1, 102, 'B'),
(2, 103, 'A'),
(2, 104, 'C'),
(3, 101, 'B'),
(3, 105, 'A'),
(4, 102, 'A'),
(4, 103, 'B'),
(5, 104, 'A'),
(5, 105, 'B');


-- =====================================================================
-- PART 3: Alternate MySQL Workbench forward-engineered schema (mydb)
-- =====================================================================
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Enrollments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Enrollments` (
  `StudentID` INT NOT NULL,
  `CourseID` INT NOT NULL,
  `Grade` VARCHAR(50) NULL,
  PRIMARY KEY (`StudentID`, `CourseID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Students` (
  `StudentID` INT NOT NULL,
  `FullName` VARCHAR(50) NOT NULL,
  `DateOfBirth` DATE NULL,
  `Email` VARCHAR(50) NULL,
  `Enrollments_StudentID` INT NOT NULL,
  `Enrollments_CourseID` INT NOT NULL,
  PRIMARY KEY (`StudentID`, `Enrollments_StudentID`, `Enrollments_CourseID`),
  INDEX `fk_Students_Enrollments1_idx` (`Enrollments_StudentID` ASC, `Enrollments_CourseID` ASC) VISIBLE,
  CONSTRAINT `fk_Students_Enrollments1`
    FOREIGN KEY (`Enrollments_StudentID` , `Enrollments_CourseID`)
    REFERENCES `mydb`.`Enrollments` (`StudentID` , `CourseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Courses` (
  `CourseID` INT NOT NULL,
  `CourseName` VARCHAR(50) NOT NULL,
  `CreditHours` INT NOT NULL,
  `InstructorID` INT NOT NULL,
  `Enrollments_StudentID` INT NOT NULL,
  `Enrollments_CourseID` INT NOT NULL,
  PRIMARY KEY (`CourseID`, `Enrollments_StudentID`, `Enrollments_CourseID`),
  INDEX `fk_Courses_Enrollments1_idx` (`Enrollments_StudentID` ASC, `Enrollments_CourseID` ASC) VISIBLE,
  CONSTRAINT `fk_Courses_Enrollments1`
    FOREIGN KEY (`Enrollments_StudentID` , `Enrollments_CourseID`)
    REFERENCES `mydb`.`Enrollments` (`StudentID` , `CourseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Instructors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Instructors` (
  `InstructorID` INT NOT NULL,
  `FullName` VARCHAR(50) NOT NULL,
  `Department` VARCHAR(50) NULL,
  `Courses_CourseID` INT NOT NULL,
  PRIMARY KEY (`InstructorID`, `Courses_CourseID`),
  INDEX `fk_Instructors_Courses_idx` (`Courses_CourseID` ASC) VISIBLE,
  CONSTRAINT `fk_Instructors_Courses`
    FOREIGN KEY (`Courses_CourseID`)
    REFERENCES `mydb`.`Courses` (`CourseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
