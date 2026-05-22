-- =====================================================================
-- Lab 7 - Business DB (Subqueries & Joins)
-- =====================================================================

-- =====================================================================
-- PART 1: DDL - Schema creation
-- =====================================================================

CREATE TABLE Departments(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id INT
);

CREATE TABLE Employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    position VARCHAR(50),
    email VARCHAR(50),
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Employees
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id);

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50)
);

CREATE TABLE Products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    description VARCHAR(100),
    price DECIMAL(10,2),
    stock_qty INT
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details(
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- =====================================================================
-- PART 2: DML - Sample data
-- =====================================================================

-- Insert sample data into Departments table
INSERT INTO departments (department_id, department_name, manager_id) VALUES
(1, 'Sales', NULL),
(2, 'Marketing', NULL),
(3, 'HR', NULL),
(4, 'IT', NULL),
(5, 'Finance', NULL),
(6, 'Operations', NULL),
(7, 'Logistics', NULL),
(8, 'Product Development', NULL),
(9, 'Support', NULL),
(10, 'Legal', NULL);

-- Insert sample data into Employees table
INSERT INTO employees (employee_id, first_name, last_name, department_id, position, email) VALUES
(1, 'John', 'Doe', 1, 'Sales Manager', 'johndoe@example.com'),
(2, 'Jane', 'Smith', 2, 'Marketing Specialist', 'janesmith@example.com'),
(3, 'Robert', 'Brown', 3, 'HR Coordinator', 'robertbrown@example.com'),
(4, 'Emily', 'Davis', 4, 'IT Support', 'emilydavis@example.com'),
(5, 'Michael', 'Wilson', 5, 'Accountant', 'michaelwilson@example.com'),
(6, 'Sarah', 'Miller', 6, 'Operations Lead', 'sarahmiller@example.com'),
(7, 'David', 'Clark', 7, 'Logistics Coordinator', 'davidclark@example.com'),
(8, 'Jessica', 'Taylor', 8, 'Product Manager', 'jessicataylor@example.com'),
(9, 'Daniel', 'Martinez', 9, 'Support Specialist', 'danielmartinez@example.com'),
(10, 'Laura', 'White', 10, 'Legal Advisor', 'laurawhite@example.com');

-- Update departments table to set manager_id after employees are inserted
UPDATE departments SET manager_id = 1 WHERE department_id = 1;
UPDATE departments SET manager_id = 2 WHERE department_id = 2;
UPDATE departments SET manager_id = 3 WHERE department_id = 3;
UPDATE departments SET manager_id = 4 WHERE department_id = 4;
UPDATE departments SET manager_id = 5 WHERE department_id = 5;
UPDATE departments SET manager_id = 6 WHERE department_id = 6;
UPDATE departments SET manager_id = 7 WHERE department_id = 7;
UPDATE departments SET manager_id = 8 WHERE department_id = 8;
UPDATE departments SET manager_id = 9 WHERE department_id = 9;
UPDATE departments SET manager_id = 10 WHERE department_id = 10;

-- Insert sample data into Customers table
INSERT INTO customers (customer_id, first_name, last_name, email, phone) VALUES
(1, 'Alice', 'Johnson', 'alicejohnson@example.com', '555-0101'),
(2, 'Tom', 'Wright', 'tomwright@example.com', '555-0102'),
(3, 'Emma', 'King', 'emmaking@example.com', '555-0103'),
(4, 'Oliver', 'Lee', 'oliverlee@example.com', '555-0104'),
(5, 'Sophia', 'Baker', 'sophiabaker@example.com', '555-0105'),
(6, 'Liam', 'Adams', 'liamadams@example.com', '555-0106'),
(7, 'Mia', 'Carter', 'miacarter@example.com', '555-0107'),
(8, 'Noah', 'Evans', 'noahevans@example.com', '555-0108'),
(9, 'Ava', 'Hill', 'avahill@example.com', '555-0109'),
(10, 'Lucas', 'Scott', 'lucasscott@example.com', '555-0110');

-- Insert sample data into Products table
INSERT INTO products (product_id, product_name, description, price, stock_qty) VALUES
(1, 'Laptop', 'High-performance laptop', 1200.00, 50),
(2, 'Smartphone', 'Latest model smartphone', 800.00, 150),
(3, 'Tablet', 'Portable tablet', 400.00, 100),
(4, 'Monitor', '27-inch HD monitor', 300.00, 75),
(5, 'Keyboard', 'Mechanical keyboard', 100.00, 200),
(6, 'Mouse', 'Wireless mouse', 50.00, 250),
(7, 'Printer', 'All-in-one printer', 250.00, 40),
(8, 'Headphones', 'Noise-canceling headphones', 150.00, 120),
(9, 'Webcam', 'HD webcam', 80.00, 90),
(10, 'External Hard Drive', '1TB external hard drive', 150.00, 60);

-- Insert sample data into Orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-15', 1250.00),
(2, 2, '2024-01-16', 950.00),
(3, 3, '2024-01-17', 450.00),
(4, 4, '2024-01-18', 300.00),
(5, 5, '2024-01-19', 1300.00),
(6, 6, '2024-01-20', 750.00),
(7, 7, '2024-01-21', 400.00),
(8, 8, '2024-01-22', 200.00),
(9, 9, '2024-01-23', 1150.00),
(10, 10, '2024-01-24', 850.00);

-- Insert sample data into Order Details table
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),
(1, 5, 1, 50.00),
(2, 2, 1, 800.00),
(2, 6, 3, 150.00),
(3, 3, 1, 400.00),
(3, 8, 1, 50.00),
(4, 4, 1, 300.00),
(5, 1, 1, 1200.00),
(5, 7, 2, 100.00),
(6, 9, 5, 250.00),
(7, 3, 1, 400.00),
(8, 10, 2, 300.00),
(9, 2, 1, 800.00),
(9, 6, 2, 100.00),
(10, 4, 1, 300.00);


-- =====================================================================
-- PART 3: Queries
-- =====================================================================

---- LAB 7A ----
-- Q1. Customers whose order total is above the average order total
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(o.total_amount) AS total_order,
       (SELECT AVG(total_amount) FROM orders) AS average_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > (SELECT AVG(total_amount) FROM orders);

-- Q2. Products ordered by more than 1 distinct customer
SELECT p.product_id, p.product_name, COUNT(DISTINCT o.customer_id) AS customer_count
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(DISTINCT o.customer_id) > 1;

-- Q3. Customers who have never placed an order
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q4. Customers who ordered a specific product (e.g., product_id = 1)
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
WHERE od.product_id = 1;

-- Q5. Products that have never been ordered
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
WHERE od.order_id IS NULL;


---- lab 7B ----
-- Q1. List all employees along with their respective departments
SELECT *
FROM Employees e
LEFT JOIN Departments d
ON e.department_id = d.department_ID;

-- Q2. Retrieve a list of all department managers along with the names of the departments they manage
SELECT *
FROM Departments d
LEFT JOIN Employees e
ON d.manager_id = e.employee_id;

-- Q3. Identify employees who hold the same position in different departments
SELECT *
FROM Employees e
LEFT JOIN Departments d
ON e.department_id = d.department_id
WHERE e.position IN (
    SELECT position
    FROM Employees
    GROUP BY position
    HAVING COUNT(DISTINCT department_id) > 1
    )
ORDER BY e.position,d.department_name;

-- Q4. Find a list of employees and their respective departments
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM Employees e
LEFT JOIN Departments d
ON e.department_id = d.department_id;
