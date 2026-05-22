-- 1. Total Sales by Region
SELECT Region, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Region
ORDER BY TotalSales;

-- 2. Top 5 Products by Sales
SELECT TOP 5 [Product Name], SUM(Sales) AS TotalSales
FROM Orders
GROUP BY [Product Name]
ORDER BY TotalSales DESC;

-- 3. Total Profit by Product Category
SELECT Category, SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY Category
ORDER BY TotalProfit;

-- 4. Monthly Sales Trends
SELECT EOMONTH([Order Date]) AS SalesMonth, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY EOMONTH([Order Date])
ORDER BY SalesMonth

-- 5. Customer with Highest Total Sales
SELECT TOP 1 [Customer Name], SUM(Sales) AS TotalSales
FROM Orders
GROUP BY [Customer Name]
ORDER BY TotalSales DESC;


