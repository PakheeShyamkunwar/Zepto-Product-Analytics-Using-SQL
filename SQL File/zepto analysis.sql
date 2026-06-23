create database zepto_analysis;
use zepto_analysis;

-- Data Exploration

-- Count of Rows
SELECT COUNT(*) FROM zepto_new;

-- Sample Data
SELECT * FROM zepto_new
LIMIT 10;

-- Null Values
SELECT * FROM zepto_new
WHERE name is NULL
OR 
category is NULL
OR 
mrp is NULL
OR 
discountPercent is NULL
OR 
discountedSellingPrice is NULL
OR 
availableQuantity is NULL
OR 
outOfStock is NULL
OR 
quantity is NULL;

-- Different Product Categories
SELECT DISTINCT category
FROM zepto_new
ORDER By category;

-- Product in Stock vs Out of Stock
SELECT outOfStock, count(*)
FROM zepto_new
GROUP BY outOfStock;

-- Product names present multiple times
SELECT name, COUNT(*) as "Number of Counts"
from zepto_new
GROUP BY name
HAVING count(*) > 1
ORDER BY count(*) DESC;  

-- Data cleaning

-- Products with Price = 0
SELECT * FROM zepto_new
WHERE mrp = 0 OR discountedSellingPrice = 0; 

DELETE FROM zepto_new
WHERE mrp = 0;

-- Convert Paise to rupees
UPDATE zepto_new
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto_new; 

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_new
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto_new
WHERE outOfStock = 'TRUE'
  AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Calculate Estimated Revenue for each category
SELECT category, 
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_new 
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than Rs. 500 and discoun is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_new
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC; 

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto_new
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5; 

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice, 
ROUND(discountedSellingPrice/weightInGms, 2) AS price_per_gram
FROM zepto_new
WHERE weightInGms >= 100
ORDER BY price_per_gram; 

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
     ELSE 'Bulk'
     END AS weight_category
FROM zepto_new;

-- Q8. What is the Total Inventory Weight for Category
SELECT category, 
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_new
GROUP BY category
ORDER BY total_weight;