CREATE TABLE Students (
    student_id   INT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    major        VARCHAR(100) NOT NULL,
    enrollment_year INT NOT NULL
);

CREATE TABLE Courses (
    course_id    INT PRIMARY KEY,
    course_name  VARCHAR(100) NOT NULL,
    credits      INT NOT NULL
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id    INT NOT NULL,
    course_id     INT NOT NULL,
    grade         CHAR(2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert sample data into Students table
INSERT INTO Students (student_id, name, major, enrollment_year) VALUES
(1, 'Alice Johnson', 'Computer Science', 2020),
(2, 'Bob Smith', 'Electrical Engineering', 2019),
(3, 'Carol White', 'Mechanical Engineering', 2021);

-- Insert sample data into Courses table
INSERT INTO Courses (course_id, course_name, credits) VALUES
(101, 'Calculus', 4),
(102, 'Introduction to Programming', 3),
(103, 'Physics', 4);

-- Insert sample data into Enrollments table
INSERT INTO Enrollments (enrollment_id, student_id, course_id, grade) VALUES
(1, 1, 101, 'A'),
(2, 1, 102, 'B'),
(3, 2, 103, 'A');

-- Check for Existing Users and Remove if Necessary --
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'AdminUser')
    DROP USER AdminUser;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ViewerUser')
    DROP USER ViewerUser;

-- Create Database Users for Existing Logins --
CREATE LOGIN AdminUser WITH PASSWORD = 'Admin@123';
CREATE LOGIN ViewerUser WITH PASSWORD = 'Viewer@123';
CREATE USER AdminUser FOR LOGIN AdminUser;
CREATE USER ViewerUser FOR LOGIN ViewerUser;

-- Create Roles for Access Control --
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'admin_role' AND type = 'R')
    CREATE ROLE admin_role;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'viewer_role' AND type = 'R')
    CREATE ROLE viewer_role;

-- Grant Privileges to admin_role --
-- Full permissions on Students
GRANT SELECT, INSERT, UPDATE, DELETE ON Students TO admin_role;
-- Select, Insert, Delete on Enrollments (no UPDATE)
GRANT SELECT, INSERT, DELETE ON Enrollments TO admin_role;
-- Read-only on Courses
GRANT SELECT ON Courses TO admin_role;

-- Grant Privileges to viewer_role --
GRANT SELECT ON Students TO viewer_role;
GRANT SELECT ON Courses TO viewer_role;

-- Add Users to Roles --
ALTER ROLE admin_role ADD MEMBER AdminUser;
ALTER ROLE viewer_role ADD MEMBER ViewerUser;
