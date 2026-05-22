CREATE DATABASE CollegeDB;
GO

USE CollegeDB;
GO

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Major VARCHAR(50),
    EnrollmentYear INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT CHECK (Credits > 0)
);
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
	StudentID INT, 
	CourseID INT,
    CONSTRAINT stid FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
    CONSTRAINT crsid FOREIGN KEY(CourseID) REFERENCES Courses(CourseID),
    Grade CHAR(1) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F', NULL))
);


INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
VALUES
    (1, 'John', 'Doe', 'Computer Science', 2022),
    (2, 'Jane', 'Smith', 'Mathematics', 2021),
    (3, 'Alice', 'Johnson', 'Physics', 2023);

INSERT INTO Courses (CourseID, CourseName, Credits)
VALUES
    (101, 'Data Structures', 3),
    (102, 'Calculus I', 4),
    (103, 'Physics I', 4);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade)
VALUES
    (1, 1, 101, 'A'),
    (2, 2, 102, 'B'),
    (3, 3, 103, NULL);
GO

--- Create View ---
CREATE VIEW v_StudentCourseDetails AS
SELECT 
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS FullName,
    c.CourseName,
    e.Grade
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;
GO

-- Query the view
SELECT * FROM v_StudentCourseDetails;

-- Insert the new Bob Williams record and re-query --
INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
VALUES (4, 'Bob', 'Williams', 'Chemistry', 2020);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade)
VALUES (4, 4, 103, 'D');

SELECT * FROM v_StudentCourseDetails;
GO

-- Materialized view -- 
-- Create the indexed view
CREATE VIEW v_RecentStudents
WITH SCHEMABINDING
AS
SELECT 
    StudentID,
    FirstName,
    LastName,
    Major,
    EnrollmentYear
FROM dbo.Students
WHERE EnrollmentYear > 2021;
GO

-- Materialize it with a unique clustered index
CREATE UNIQUE CLUSTERED INDEX IX_v_RecentStudents 
ON v_RecentStudents(StudentID);
GO

-- Query it
SELECT * FROM v_RecentStudents;

-- Insert a new record with EnrollmentYear > 2021 --
INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
VALUES (5, 'Carol', 'Nguyen', 'Biology', 2024);

SELECT * FROM v_RecentStudents;

-- Create the GradeChangeLog table --
CREATE TABLE GradeChangeLog (
    LogID INT IDENTITY PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    OldGrade CHAR(1),
    NewGrade CHAR(1),
    ChangedOn DATETIME DEFAULT GETDATE()
);
GO

-- Sample transaction from the lab --
BEGIN TRANSACTION;
BEGIN TRY
    -- Declare variables for the old grade
    DECLARE @OldGrade CHAR(1);

    -- Fetch the current grade
    SELECT @OldGrade = Grade
    FROM Enrollments
    WHERE StudentID = 1 AND CourseID = 101;

    -- If no record is found, throw an error
    IF @OldGrade IS NULL
        THROW 50001, 'No matching record found for StudentID and CourseID.', 1;

    -- Update the grade
    UPDATE Enrollments
    SET Grade = 'B'
    WHERE StudentID = 1 AND CourseID = 101;

    -- Log the grade change
    INSERT INTO GradeChangeLog (StudentID, CourseID, OldGrade, NewGrade, ChangedOn)
    VALUES (1, 101, @OldGrade, 'B', GETDATE());

    -- Commit the transaction
    COMMIT TRANSACTION;
    PRINT 'Grade updated successfully.';
END TRY
BEGIN CATCH
    -- Rollback the transaction in case of an error
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;
GO

SELECT * FROM GradeChangeLog;

-- New transaction: insert 3 Students with commit/rollback --
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (6, 'Ngan', 'Nguyen', 'Math', 2023);

    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (7, 'David', 'Lee', 'Biology', 2022);

    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (8, 'John', 'Smith', 'Engineering', 2024);

    COMMIT TRANSACTION;
    PRINT 'All three students inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;

-- Check the Rollback work --
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (9, 'Grace', 'Kim', 'Economics', 2023);

    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (10, 'Henry', 'Wong', 'Art', 2022);

    -- Intentional duplicate to trigger PK violation
    INSERT INTO Students (StudentID, FirstName, LastName, Major, EnrollmentYear)
    VALUES (1, 'Duplicate', 'Key', 'Fail', 2024);

    COMMIT TRANSACTION;
    PRINT 'All three students inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;

-- Verify: StudentID 9 and 10 should NOT exist because the whole transaction was rolled back.
SELECT * FROM Students WHERE StudentID IN (9, 10);