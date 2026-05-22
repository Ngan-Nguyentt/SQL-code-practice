-- =====================================================================
-- Lab 9 - College DB (Joins)
-- =====================================================================

-- =====================================================================
-- PART 1: Database schema
-- =====================================================================
-----Database Schema-----
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    OfficeLocation VARCHAR(100)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    MajorDepartmentID INT,
    EnrollmentYear INT,
    Email VARCHAR(100),
    FOREIGN KEY (MajorDepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseCode VARCHAR(20) NOT NULL,
    CourseTitle VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    Credits INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Sections (
    SectionID INT PRIMARY KEY,
    CourseID INT NOT NULL,
    InstructorID INT,
    Semester VARCHAR(20) NOT NULL,
    YearOffered INT NOT NULL,
    Room VARCHAR(20),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

-- =====================================================================
-- PART 2: Sample data
-- =====================================================================
-----Sample Data-----
INSERT INTO Departments VALUES
(1, 'Computer Science', 'B201'),
(2, 'Business', 'C110'),
(3, 'Mathematics', 'A315'),
(4, 'English', 'D220');

INSERT INTO Students VALUES
(101, 'Ali', 'Hassan', 1, 2023, 'ali.hassan@college.edu'),
(102, 'Sara', 'Khan', 2, 2022, 'sara.khan@college.edu'),
(103, 'Michael', 'Smith', 1, 2021, 'michael.smith@college.edu'),
(104, 'Lina', 'Chen', 3, 2023, 'lina.chen@college.edu'),
(105, 'Omar', 'Farah', 4, 2024, 'omar.farah@college.edu'),
(106, 'Nora', 'Ahmed', NULL, 2024, 'nora.ahmed@college.edu');

INSERT INTO Instructors VALUES
(201, 'John', 'Miller', 1, '2018-08-15'),
(202, 'Emily', 'Clark', 2, '2019-01-10'),
(203, 'David', 'Lee', 3, '2016-09-01'),
(204, 'Sophia', 'Brown', 4, '2020-02-20'),
(205, 'James', 'Wilson', 1, '2021-06-01');

INSERT INTO Courses VALUES
(301, 'CST101', 'Introduction to Databases', 1, 3),
(302, 'CST220', 'Advanced SQL', 1, 4),
(303, 'BUS150', 'Principles of Management', 2, 3),
(304, 'MAT200', 'Statistics I', 3, 3),
(305, 'ENG110', 'Academic Writing', 4, 3),
(306, 'CST330', 'Data Warehousing', 1, 4);

INSERT INTO Sections VALUES
(401, 301, 201, 'Fall', 2025, 'R101'),
(402, 302, 205, 'Fall', 2025, 'R102'),
(403, 303, 202, 'Fall', 2025, 'B210'),
(404, 304, 203, 'Fall', 2025, 'M120'),
(405, 305, 204, 'Fall', 2025, 'E115'),
(406, 306, NULL, 'Fall', 2025, 'R103'),
(407, 301, 201, 'Winter', 2026, 'R101');

INSERT INTO Enrollments VALUES
(501, 101, 401, '2025-08-20', 'A'),
(502, 101, 402, '2025-08-20', 'B+'),
(503, 102, 403, '2025-08-21', 'A-'),
(504, 103, 401, '2025-08-22', 'B'),
(505, 103, 404, '2025-08-22', 'A'),
(506, 104, 404, '2025-08-23', 'A-'),
(507, 105, 405, '2025-08-24', 'B+'),
(508, 102, 401, '2025-08-25', 'B'),
(509, 106, 406, '2025-08-26', NULL);


-- =====================================================================
-- PART 3: Lab solutions
-- =====================================================================
----- Lab Solutions -----

--Task 1: Basic Inner Join - All enrollments showing student full name, section ID, and grade
SELECT s.StudentID, CONCAT(s.FirstName,' ', s.LastName) AS StudentName, e.SectionID, e.Grade
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID;

--Task 2: Join Across Multiple Tables - Students are enrolled in which course titles
SELECT s.StudentID, CONCAT(s.FirstName,' ', s.LastName) AS StudentName, c.CourseCode, c.CourseTitle, sec.Semester, sec.YearOffered
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Sections sec ON e.SectionID = sec.SectionID
INNER JOIN Courses c ON sec.CourseID = c.CourseID;

--Task 3: Join with Department Lookup - All students and their major department name
SELECT s.StudentID, CONCAT(s.FirstName,' ', s.LastName) AS StudentName, d.DepartmentName
FROM Students s
LEFT JOIN Departments d ON s.MajorDepartmentID = d.DepartmentID;

--Task 4: Left Join to Find Missing Relationships - All course sections that do not yet have an instructor assigned
SELECT sec.SectionID, c.CourseTitle, sec.Semester, sec.YearOffered
FROM Sections sec
LEFT JOIN Courses c ON sec.CourseID = c.CourseID
WHERE sec.InstructorID IS NULL;

--Task 5: Multi-Join Reporting Query
-- A report showing course title, section ID, instructor name, and number of enrolled students
-- Include sections with zero students
SELECT c.CourseTitle, sec.SectionID, CONCAT(i.FirstName,' ',i.LastName) AS InstructorName, COUNT(e.EnrollmentID) AS StudentCount
FROM Sections sec
INNER JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Instructors i ON sec.InstructorID = i.InstructorID
LEFT JOIN Enrollments e ON sec.SectionID = e.SectionID
GROUP BY c.CourseTitle, sec.SectionID, i.FirstName, i.LastName;

--Task 6: Self-Join - Find pairs of students in the same major department (no self-pair and duplicate reserved pairs)
SELECT CONCAT(s1.FirstName, ' ', s1.LastName) AS Student1,
	   CONCAT(s2.FirstName, ' ', s2.LastName) AS Student2, s1.MajorDepartmentID
FROM Students s1
INNER JOIN Students s2
	ON s1.MajorDepartmentID = s2.MajorDepartmentID
	AND s1.StudentID < s2.StudentID;

--Task 7: Many-to-Many Join Analysis - All instructors and the courses they teach
SELECT CONCAT(i.FirstName,' ',i.LastName) AS InstructorName, c.CourseCode, c.CourseTitle, sec.Semester, sec.YearOffered
FROM Instructors i
INNER JOIN Sections sec ON i.InstructorID = sec.InstructorID
INNER JOIN Courses c ON sec.CourseID = c.CourseID

--Task 8: Advanced Join with Aggregation - #students enrolled in each department’s courses
SELECT d.DepartmentName, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Departments d
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Sections sec ON c.CourseID = sec.CourseID
LEFT JOIN Enrollments e ON sec.SectionID = e.SectionID
GROUP BY d.DepartmentName;

--Task 9: Students Without Enrollments
SELECT s.StudentID, CONCAT(s.FirstName, ' ', s.LastName) AS StudentName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.StudentID IS NULL;

-- Task 10: Advanced Challenge - Compare MajorDepartment vs CourseDepartment
-- Answers two different questions:
-- 1. "what department is this student in?" (d1)
-- 2. "what department offers this course?" (d2)
-- ==> Same lookup table, two different questions

SELECT
	CONCAT(s.FirstName,' ', s.LastName) AS StudentName,
	d1.DepartmentName AS MajorDepartment,
	c.CourseCode,
	c.CourseTitle,
	d2.DepartmentName AS CourseDepartment
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Sections sec ON e.SectionID = sec.SectionID
INNER JOIN Courses c ON sec.CourseID = c.CourseID
INNER JOIN Departments d1 ON s.MajorDepartmentID = d1.DepartmentID
INNER JOIN Departments d2 ON c.DepartmentID = d2.DepartmentID
WHERE s.MajorDepartmentID IS NOT NULL
AND s.MajorDepartmentID <> c.DepartmentID -- students taking outside their major department;


-- Extension Challenge A: all pairs of instructors and students that belong to the same department
SELECT CONCAT(i.FirstName,' ',i.LastName) AS InstructorName,
	   CONCAT(s.FirstName,' ', s.LastName) AS StudentName,
	   d.DepartmentName
FROM Instructors i
INNER JOIN Departments d ON i.DepartmentID = d.DepartmentID
INNER JOIN Students s ON d.DepartmentID = s.MajorDepartmentID

-- Extension Challenge B: the course with the highest number of enrollments
SELECT TOP 1
	c.CourseTitle, COUNT(e.EnrollmentID) AS EnrollmentCount
FROM Courses c
INNER JOIN Sections sec ON c.CourseID = sec.CourseID
INNER JOIN Enrollments e ON sec.SectionID = e.SectionID
GROUP BY c.CourseTitle
ORDER BY EnrollmentCount DESC;

-- Extension Challenge C: all students, and for each student display total courses taken and average numeric grade
SELECT s.StudentID, CONCAT(s.FirstName,' ', s.LastName) AS StudentName,
	COUNT(e.EnrollmentID) AS TotalCourses,
	AVG (CASE e.Grade
			WHEN 'A' THEN 4.0
			WHEN 'A-' THEN 3.7
			WHEN 'B+' THEN 3.3
			WHEN 'B' THEN 3.0
		END
	) AS AvgGrade
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName

-- Extension Challenge D: Find departments that currently have courses offered but no students majoring in them
SELECT d.DepartmentName
FROM Departments d
INNER JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Students s ON d.DepartmentID = s.MajorDepartmentID
WHERE s.StudentID IS NULL
GROUP BY d.DepartmentName
