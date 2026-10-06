CREATE TABLE Amazon_customer(
Customer_ID VARCHAR(20) PRIMARY KEY,
Customer_Name VARCHAR(100));

CREATE TABLE product(
Product_ID VARCHAR (20) PRIMARY KEY,
Product_Name VARCHAR(150),
Category VARCHAR (100),
Brand  VARCHAR(100),
Quantity INT,
Unit_Price DECIMAL(10,2));

CREATE TABLE sales(
Order_ID VARCHAR(20) ,
Order_Date DATE ,
Customer_ID VARCHAR(20),
Customer_Name VARCHAR(100),
Product_ID VARCHAR (20),
Product_Name VARCHAR (150),
Quantity INT,
FOREIGN KEY (Customer_ID) REFERENCES Amazon_customer(Customer_ID),
FOREIGN KEY (Product_ID) REFERENCES product(Product_ID));

__data importing done

__first checking tables

SELECT * FROM Amazon_customer;
SELECT * FROM product;
SELECT * FROM Sales;

SELECT COUNT(*) FROM Amazon_customer;
SELECT COUNT(*) FROM product;
SELECT Count(*) FROM Sales;

__ Check Duplicate IDs
-- Customer_id

SELECT Customer_ID ,
COUNT(*) AS Duplicate_ID
FROM Amazon_customer
GROUP BY Customer_ID
HAVING COUNT(*) < 1;

-- Production_id

SELECT Product_ID,
COUNT(*) AS Duplicate_ID
FROM product
GROUP BY Product_ID
HAVING COUNT(*) < 1;

-- Check whether Sales ID'S match 
-- Customer id

SELECT DISTINCT s.customer_ID
FROM sales s
LEFT JOIN Amazon_customer c
ON s.customer_ID = c.customer_ID
WHERE c.customer_ID  IS NULL;

-- Production id

SELECT DISTINCT s.Product_ID
FROM sales s
LEFT JOIN product p
ON s.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL

-- Q1 How many orders are there

SELECT 
COUNT(*) AS Total_orders
FROM sales;

--	Q2 How many customers?

SELECT 
COUNT(DISTINCT Customer_ID) AS Total_customers
FROM sales;

-- Q3 How many different products were sold ?

SELECT 
COUNT(DISTINCT Product_ID) AS different_products
FROM sales;

--Q4 Total quantity sold

SELECT 
SUM(quantity)AS Total_quanity_sold
FROM sales;

-- Customer Analysis
--Q5 Number of orders by each customer

SELECT
Customer_ID,
Customer_Name,
COUNT(Order_ID) AS Total_orders
FROM sales 
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_orders DESC

-- Q6 Top 5 customers by numbers of orders

SELECT 
Customer_ID,
Customer_Name,
COUNT(Order_ID) AS Total_orders
FROM Sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_orders DESC
LIMIT 5;

-- Q7 Customer who purchaed more than 10 items

SELECT 
Customer_ID,
Customer_Name,
SUM(quantity) AS Total_quantity
FROM sales
GROUP BY Customer_ID, Customer_Name
HAVING SUM (quantity) > 10 
ORDER BY Total_quantity DESC;

-- Product Analysis
--Q8 Display product name and total quantity sold

SELECT 
p.product_ID,
p.Product_Name,
SUM(s.quantity) AS Total_quantity_sold
FROM sales s
JOIN product p
ON s. product_ID = p.product_ID
GROUP BY p.product_ID , p.product_Name
ORDER BY Total_quantity_sold
DESC;

-- Q9 TOP 5 best-slling products

SELECT 
p.product_name,
SUM(s.quantity) AS Total_quantity_sold
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.product_Name
ORDER BY Total_quantity_sold
LIMIT 5;

-- Q 10 Product with price 

SELECT 
p.product_ID,
p.product_Name,
p.Category,
p.Brand,
p.Unit_price
FROM product p
ORDER BY p.unit_price DESC;

-- Revenue analysis
-- Q 11 Total revenue

SELECT 
SUM(s.quantity  * p.unit_price) AS Total_revenue
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID;

-- Q12  Revenue by product

SELECT 
p.product_Name,
SUM(s.quantity * p.unit_price) AS revenue
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.product_Name
ORDER BY revenue DESC;

-- Q 13 Top 5 product by revenue

SELECT 
p.product_Name,
SUM(s.quantity * p.Unit_Price) AS revenue
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.product_Name
ORDER BY revenue DESC
LIMIT 5;

-- Category Analysis
--Q 14 Revenue by category

SELECT 
p.category,
SUM(s.quantity * p.unit_price) AS revenue
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.category
ORDER BY revenue DESC;

-- Q15 Quantity sold by catetgory

SELECT
p.category ,
SUM(s.quantity) AS Total_quantity
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.category
ORDER BY Total_quantity DESC;

-- Brand Analysis
-- Q16 Revenue by brand

SELECT 
p.brand,
SUM(s.quantity * p.unit_price) AS Revenue_by_brand
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.brand
ORDER BY Revenue_by_brand DESC;

-- Q17 Best-selling brand

SELECT 
p.brand,
SUM(s.quantity) AS Total_quantity
FROM sales s
JOIN Product p
ON s.product_ID = p.product_ID
GROUP BY p.brand
ORDER BY Total_quantity DESC
LIMIT 1;

-- Data Analysis
-- Q 18 Sales by year

SELECT
EXTRACT(YEAR FROM order_date) AS year,
count(order_ID) AS Total_orders
FROM sales
GROUP BY Extract(YEAR FROM order_date)
ORDER BY year;

--Q 19 sales by month 

SELECT
EXTRACT(YEAR FROM order_date) AS Year,
EXTRACT(MONTH FROM order_date) AS month,
COUNT(order_ID) AS Total_orders
FROM sales 
GROUP BY EXTRACT(YEAR FROM Order_date),
EXTRACT(MONTH FROM order_date)
ORDER BY YEAR, MONTH;

-- Q20 Monthly Revenue 

SELECT 
EXTRACT(YEAR FROM s.order_date) AS year ,
EXTRACT(MONTH FROM s.order_date) AS month,
SUM(s.quantity * p.unit_price) AS revenue
FROM sales s
JOIN product p
ON s.product_ID =p.product_ID
GROUP BY EXTRACT(YEAR FROM s.order_date),
EXTRACT(MONTH FROM s.order_date)
ORDER BY year, month;

-- Q21 Rank products by revenue 

SELECT 
p.product_Name,
SUM(s.quantity * p.unit_price) AS revenue,
RANK() OVER( ORDER BY SUM(s.quantity * p.unit_price) DESC) AS revenue_rank
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.product_Name;

-- Q22 Rank customers by spending

SELECT 
s.customer_ID,
s.Customer_Name,
SUM (s.quantity * p.unit_price) AS Total_spending,
RANK() OVER ( ORDER BY SUM(s.quantity * p.unit_price) DESC) AS Customer_rank
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY s.customer_ID, s.customer_Name;

-- Q23 highest-revenue category

SELECT 
p.category,
SUM(s.quantity * p.unit_price) AS revenue
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID
GROUP BY p.category 
ORDER BY revenue DESC
LIMIT 1;

-- Q24 Average order value

SELECT
AVG(s.quantity * p.unit_price) AS average_order_value
FROM sales s
JOIN product p
ON s.product_ID = p.product_ID;

-- Q 25 Customer with highest spending 

SELECT 
s.Customer_ID,
s.Customer_Name,
SUM(s.quantity * p.unit_price) AS Total_spending
FROM sales s
JOIN product p
ON  s.product_ID =p.product_ID
GROUP BY s.customer_ID, s.customer_Name
ORDER BY Total_spending DESC
LIMIT 1;