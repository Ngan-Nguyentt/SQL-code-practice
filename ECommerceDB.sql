-- Step 1: Create the database
CREATE DATABASE ComplexDB;

-- Step 2: Use the database
USE ComplexDB;

-- Step 3: Create tables

-- Table 1: Users
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table 3: Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL
);

-- Table 4: OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Step 4: Insert sample data into tables

-- Insert data into Users
INSERT INTO Users (FirstName, LastName, Email) 
VALUES 
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Brown', 'bob.brown@example.com');

-- Insert data into Products
INSERT INTO Products (ProductName, Price, Stock) 
VALUES 
('Laptop', 1200.00, 10),
('Smartphone', 800.00, 25),
('Headphones', 150.00, 50),
('Monitor', 300.00, 15);

-- Insert data into Orders
INSERT INTO Orders (UserID, OrderDate, TotalAmount) 
VALUES 
(1, '2025-01-01', 1350.00),
(2, '2025-01-02', 800.00);

-- Insert data into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) 
VALUES 
(1, 1, 1), -- 1 Laptop
(1, 3, 1), -- 1 Headphones
(2, 2, 1); -- 1 Smartphone

-- Step 5: Query the tables to verify data insertion
SELECT * FROM Users;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
