SELECT * 
FROM sales
LIMIT 10;

SELECT COUNT(*) 
FROM sales;

-- Data cleaning
SELECT * FROM first_portfolio_project.sales
WHERE transaction_id IS NULL;

SELECT * FROM first_portfolio_project.sales
WHERE sale_date IS NULL;

SELECT * FROM first_portfolio_project.sales
WHERE sale_time IS NULL;

SELECT 
	* 
FROM 
	sales
WHERE 
	transaction_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
DELETE FROM sales
WHERE 
	transaction_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

SELECT COUNT(*) FROM sales;


-- Data Exploration

-- How many sales/records do we have?
SELECT COUNT(*) AS number_of_records FROM sales;

-- How many customers do we have? Note that one customer can have multiple transactions.
SELECT COUNT(DISTINCT customer_id) AS number_of_customers FROM sales;

-- How many categories do we have? There could be more than one transaction for one category.
SELECT DISTINCT category AS categories FROM sales;


-- Data analysis and Business key problems & answers

-- Write a SQL query to retrieve all columns for sales made on 2022-11-05
SELECT * 
FROM sales 
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all the transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of November 2022
SELECT *
FROM sales
WHERE category = 'Clothing' 
	AND sale_date LIKE '2022-11-%' 
	AND quantity >= 4;

-- Write a SQL query to calculate the total sales for each category
SELECT 
	category, 
	SUM(total_sale) AS total_sales,
    COUNT(*) AS number_of_orders
FROM sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT
	ROUND(AVG(age), 2) AS average_age_beauty
FROM
	sales
WHERE
	category = 'Beauty';
    
-- Write a SQL query to find all transactions where the total sale is greater than 1000.
SELECT *
FROM sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions made by each gender in each category
SELECT
	gender,
    category,
    COUNT(transaction_id) AS number_of_transactions
FROM
	sales
GROUP BY
	gender, category
ORDER BY 
	category;
    
-- Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT
	year_of_sale,
    name_of_month,
    average_sales
FROM
	(
	SELECT
		MONTHNAME(sale_date) AS name_of_month,
		ROUND(AVG(total_sale), 2) AS average_sales,
		YEAR(sale_date) AS year_of_sale,
		RANK () OVER (PARTITION BY YEAR(sale_date) ORDER BY YEAR(sale_date), ROUND(AVG(total_sale), 2) DESC) AS ranking
	FROM
		sales
	GROUP BY
		MONTHNAME(sale_date), YEAR(sale_date)
	) AS sales_summary
WHERE sales_summary.ranking = 1;

-- Write a SQL query to find the top five customers based on highest total sale
SELECT
	customer_id,
    SUM(total_sale) AS total_sales
FROM
	sales
GROUP BY
	customer_id
ORDER BY
	SUM(total_sale) DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS number_of_customers
FROM
	sales
GROUP BY
	category;
    
-- Write a SQL query to create each shift and number of orders, for example, morning < 12, afternoon between 12 and 17, evening > 17
WITH shifts AS(
SELECT
	transaction_id,
	CASE
		WHEN HOUR(sale_time) < 12 THEN "Morning"
		WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
		ELSE "Evening"
	END AS time_of_day
FROM
	sales
)
SELECT
	time_of_day,
    COUNT(transaction_id) AS number_of_orders
FROM
	shifts
GROUP BY
	time_of_day;
    
-- How many youth i.e aged between 18 and 35 make purchases from this store?
SELECT
	COUNT(DISTINCT customer_id) AS number_of_youth
FROM
	sales
WHERE
	age BETWEEN 18 AND 35;
    
-- END OF PROJECT