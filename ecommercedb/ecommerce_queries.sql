-- ==========================================
-- SQL Practice Tasks: EcommerceDB
-- Author: RaShunda
-- Purpose: Practice SQL querying skills on eCommerce data
-- ==========================================

USE EcommerceDB
GO
-- Get all customers
SELECT * FROM Customers;

-- Get all orders
SELECT * FROM Orders;

-- Get all order details
SELECT * FROM OrderDetails;

-- Get all columns from Products.
SELECT * FROM Products;

-- Get only customer names who registered after '2024-01-01'.
SELECT name 
FROM Customers 
WHERE registration_date < '2024-01-01';

-- Get top 5 most expensive products.
SELECT TOP 5 name, price 
FROM Products
ORDER BY price DESC;

-- Find customers whose names start with "B".
SELECT *
FROM Customers
WHERE name LIKE 'b%';

-- Show orders placed after "2024-03-01".
SELECT *
FROM Orders
WHERE order_date > '2024-03-01';

-- List products that cost less than 100.
SELECT name, price
FROM Products
WHERE price < 100;

-- Show customers ordered by registration date (newest first).
SELECT *
FROM Customers
ORDER BY registration_date DESC;

-- List orders sorted by total_amount.
SELECT *
FROM Orders
ORDER BY total_amount;

-- Total number of orders per customer.
SELECT Customers.name, COUNT(Orders.order_id) AS 'Total Orders'
FROM Orders
JOIN Customers ON Customers.customer_id=Orders.customer_id
GROUP BY Customers.name;

-- Total revenue per product.
SELECT Products.name, SUM(OrderDetails.quantity * OrderDetails.price) AS 'total_revenue'
FROM OrderDetails
JOIN Products On OrderDetails.product_id=Products.product_id
GROUP BY Products.name;

-- Average order total per customer.
SELECT Customers.name, AVG(Orders.total_amount) AS average_order_total
FROM Orders
JOIN Customers On Orders.customer_id=Customers.customer_id
GROUP BY Customers.name;

-- Formatted Data from 199.990000 to 199.99
SELECT 
	Customers.name,
	CAST(AVG(Orders.total_amount) AS FLOAT) AS average_order_total
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
GROUP BY Customers.name;

-- Find customers with "son" in their name.
SELECT *
FROM Customers
WHERE name LIKE '%son%';

-- Find emails ending in "@example.com".
SELECT email
FROM Customers
WHERE email LIKE '%@example.com%';

-- Subquery: The names of all customers who have placed an order where the total amount is greater than 500.
SELECT name FROM Customers
WHERE customer_id IN (
  SELECT customer_id FROM Orders WHERE total_amount > 500
);

-- Count how many products are in each category
SELECT category, Count(product_id) AS 'total'
FROM Products
GROUP BY category;

-- Get the most expensive product
SELECT TOP 1 * 
FROM Products
ORDER BY price DESC;

-- If there"s a chance multiple products share the same highest price and you want all of them
SELECT * 
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

-- Find the average price of Electronics
SELECT AVG(price) AS 'Average Price'
FROM Products
WHERE category = 'Electronics';

-- Formatted Price
SELECT ROUND(CAST(AVG(price) AS FLOAT), 2) AS 'Average Price'
FROM Products
WHERE category = 'Electronics';

--  List products with a price between $30 and $200
SELECT name, price
FROM Products
WHERE price BETWEEN 30 AND 200;

-- Rename "Coffee Maker" to "Espresso Machine"
UPDATE Products
SET name = 'Espresso Machine'
WHERE name = 'Coffee Maker';

-- List all orders with customer names and their order dates.
SELECT Customers.name, Orders.order_date
FROM Orders
JOIN Customers ON Customers.customer_id=Orders.customer_id;

-- Show each order"s products with product names, quantities, and prices.
SELECT order_id, Products.name, quantity, OrderDetails.price
FROM OrderDetails
JOIN Products ON Products.product_id=OrderDetails.product_id;

-- Find the total amount spent by each customer by joining their orders and order details.
SELECT Customers.name, SUM(OrderDetails.quantity * OrderDetails.price) AS total_price
FROM Orders
JOIN OrderDetails ON OrderDetails.order_id=Orders.order_id
JOIN Customers ON Customers.customer_id=Orders.customer_id
GROUP BY Customers.name;

-- Retrieve customers who ordered a specific product (e.g., "Laptop").
SELECT Customers.name
FROM Customers
JOIN Orders ON Customers.customer_id=Orders.customer_id
JOIN OrderDetails ON Orders.order_id=OrderDetails.order_id
WHERE OrderDetails.product_id IN (
	SELECT product_id FROM Products WHERE name = 'Laptop'
);

-- Get a detailed report showing customer name, order date, product name, quantity, and price per product for all orders.
SELECT Customers.name, Orders.order_date, Products.name, OrderDetails.quantity, Products.price
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Products ON Products.product_id = OrderDetails.product_id;

-- List all products that have never been ordered by any customer.
SELECT name
FROM Products
LEFT JOIN OrderDetails ON Products.product_id = OrderDetails.product_id
WHERE OrderDetails.product_id IS NULL;

-- Show the top 3 customers who spent the most money in total.
SELECT TOP 3 Customers.name, SUM(Orders.total_amount) as total_spent
FROM Customers
JOIN Orders ON Orders.customer_id = Customers.customer_id
GROUP BY Customers.name
ORDER BY total_spent DESC;

-- Find the number of different products each customer has purchased.
SELECT Customers.customer_id, Customers.name, COUNT(DISTINCT Products.name) as number_of_products
FROM Customers
JOIN Orders ON Orders.customer_id = Customers.customer_id
JOIN OrderDetails ON OrderDetails.order_id = Orders.order_id
JOIN Products ON Products.product_id = OrderDetails.product_id
GROUP BY Customers.customer_id, Customers.name;

-- Display orders along with the total quantity of items purchased in each order.
SELECT Orders.order_id, SUM(OrderDetails.quantity) AS quantity_of_items
FROM Orders
JOIN OrderDetails ON OrderDetails.order_id = Orders.order_id
GROUP BY Orders.order_id;

-- Find orders where the total amount in the Orders table does NOT match the sum of prices in the OrderDetails table.
SELECT Orders.order_id, Orders.total_amount AS total, SUM(OrderDetails.price) AS calculated_total
FROM Orders
JOIN OrderDetails ON OrderDetails.order_id = Orders.order_id
GROUP BY Orders.order_id, Orders.total_amount
HAVING SUM(OrderDetails.price) <> Orders.total_amount;