-- Superstore Sales Analysis Queries
-- Author: [Your Name]
-- Purpose: To analyze Superstore sales performance, profit, returns, and segment performance.

-- 1. Total Sales and Profit by Year
SELECT YEAR(OrderDate) AS Year, 
       SUM(Sales) AS TotalSales, 
       SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY Year;

-- 2. Sales Performance Change vs Previous Year
WITH SalesByYear AS (
    SELECT YEAR(OrderDate) AS Year, 
           SUM(Sales) AS TotalSales
    FROM Orders
    GROUP BY YEAR(OrderDate)
)
SELECT Year,
       TotalSales,
       LAG(TotalSales) OVER (ORDER BY Year) AS PreviousYearSales,
       ((TotalSales - LAG(TotalSales) OVER (ORDER BY Year)) / LAG(TotalSales) OVER (ORDER BY Year)) * 100 AS PercentChange
FROM SalesByYear;

-- 3. Percentage of Returned Orders
SELECT COUNT(Returns.OrderID) * 100.0 / COUNT(Orders.OrderID) AS ReturnPercentage
FROM Orders
LEFT JOIN Returns ON Orders.OrderID = Returns.OrderID;

-- 4. Most Profitable Products
SELECT ProductName, 
       SUM(Profit) AS TotalProfit
FROM Products
JOIN Orders ON Products.ProductID = Orders.ProductID
GROUP BY ProductName
ORDER BY TotalProfit DESC
LIMIT 5;

-- 5. Most Loss-Making Products
SELECT ProductName, 
       SUM(Profit) AS TotalLoss
FROM Products
JOIN Orders ON Products.ProductID = Orders.ProductID
GROUP BY ProductName
HAVING SUM(Profit) < 0
ORDER BY TotalLoss ASC;

-- 6. Profit by Region
SELECT Region, 
       SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY Region
ORDER BY TotalProfit DESC;

-- 7. Sales by Segment
SELECT Segment, 
       SUM(Sales) AS TotalSales,
       SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY Segment
ORDER BY TotalSales DESC;

-- 8. Profit by City
SELECT City, 
       SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY City
ORDER BY TotalProfit DESC
LIMIT 10;

-- 9. Customer Segmentation
-- This query groups customers based on their purchase frequency.
SELECT CustomerID, 
       COUNT(OrderID) AS OrderCount, 
       SUM(Sales) AS TotalSales,
       SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY CustomerID
ORDER BY OrderCount DESC;

-- 10. Order Frequency Analysis
-- This query analyzes the frequency of orders placed by customers.
SELECT CustomerID, 
       COUNT(OrderID) AS TotalOrders,
       DATEDIFF(MAX(OrderDate), MIN(OrderDate)) AS DaysBetweenFirstAndLastOrder
FROM Orders
GROUP BY CustomerID
ORDER BY TotalOrders DESC;

-- 11. Product Category Trends
-- This query analyzes sales trends by product category.
SELECT Category, 
       YEAR(OrderDate) AS Year,
       SUM(Sales) AS TotalSales
FROM Orders
JOIN Products ON Orders.ProductID = Products.ProductID
GROUP BY Category, YEAR(OrderDate)
ORDER BY Year, TotalSales DESC;

-- 12. Geographical Insights (Sales by Region/City)
-- This query provides sales insights by region and city.
SELECT Region, City, 
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Region, City
ORDER BY Region, TotalSales DESC;

-- 13. Discount Impact on Profit
-- This query analyzes how discounts impact profit margins.
SELECT SUM(Discount) AS TotalDiscount, 
       SUM(Sales) AS TotalSales,
       SUM(Profit) AS TotalProfit,
       SUM(Sales) - SUM(Discount) AS NetSales
FROM Orders;

-- 14. Return Rate by Product
-- This query calculates the return rate for each product.
SELECT ProductName, 
       COUNT(Returns.OrderID) * 100.0 / COUNT(Orders.OrderID) AS ReturnRate
FROM Products
LEFT JOIN Orders ON Products.ProductID = Orders.ProductID
LEFT JOIN Returns ON Orders.OrderID = Returns.OrderID
GROUP BY ProductName;

