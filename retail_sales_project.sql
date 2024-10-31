-- Creating a table and then importing data into it--
CREATE TABLE retail_sales (
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR (15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);


--Data Exploration--
SELECT * FROM retail_sales;

--examining the data--
SELECT*FROM retail_sales
LIMIT 10;

--getting the count on the records in the data--
SELECT COUNT(*) FROM retail_sales;

--Null values in the primary key--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

--checking for all null values--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR 
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

-- Delete these rows--
DELETE FROM retail_sales
WHERE transactions_id IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR 
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;


--Data Analysis and Business Problems--
-- Q1. Write a query to retrieve all columns for sales made on '2022-11-05'--
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2. Write a query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than--
-- 10 in the month of nov-2022--
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
		AND
		sale_date BETWEEN '2022-11-01' AND '2022-11-30'
		AND
		quantity > 3;

--Q3. Write a query to calculate total sales for each category--
SELECT 
	SUM(total_sale),
	category,
	COUNT(*) AS order_count
	FROM retail_sales
		GROUP BY category;

--Q4. Write a query to find the average age of customers who purchased items from 'Beauty Category'--
SELECT 
	ROUND(AVG(age),1),gender
	FROM retail_sales
		WHERE category = 'Beauty'
		GROUP BY gender;

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000--
SELECT *
	FROM retail_sales
		WHERE total_sale>1000;

--Q6. Write a query to find the total number of transactions made by each gender in each category
SELECT 
	COUNT(transactions_id) AS total_transactions,
	gender,
	category
	FROM retail_sales
		GROUP BY gender,category
		ORDER BY total_transactions;

--Q7. Write a query to calculate the average sale for each month. Find out the month with the highest sales--
SELECT * FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale),
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
		FROM retail_sales
		GROUP BY 1,2
	) as t1
	WHERE rank =1;

--Q8. Write a query to find the top 5 customers with the highest total sales--
SELECT 
customer_id,
	SUM(total_sale) as total_sales
	FROM retail_sales
	GROUP BY 1
	ORDER BY total_sales DESC
	LIMIT 5;
		
--Q9.Write a query to find the number of unique customers who purchased items from each category--
SELECT 
	COUNT(DISTINCT customer_id),
	category
	FROM retail_sales
	GROUP BY category

--Q10. Write a query to create each shitft and number of orders (Example moring <=12, Afternoon between 12-17, and Evening >17)
WITH hourly_sale as
(
SELECT *,
	CASE
		 WHEN EXTRACT( HOUR FROM sale_time) < 12  THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
		 ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift




