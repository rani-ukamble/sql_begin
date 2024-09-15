CREATE DATABASE sales;

use sales;
drop table if exists sales_retail ;

create table sales_retail
(
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
            
select * from sales_retail limit 5; 

select count(*) from sales_retail;

SELECT * FROM sales_retail
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
    
-- 
DELETE FROM sales_retail
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
 
--  *************************************************************************************************************
-- Data Exploration
--  *************************************************************************************************************

-- How many sales we have?
select count(*) as total_sales from  sales_retail;

-- How many uniuque customers we have ?
select count(distinct customer_id) as uniuque_customers from sales_retail;

SELECT DISTINCT category FROM sales_retail;

--  *************************************************************************************************************
-- Data Analysis & Business Key Problems & Answers
--  *************************************************************************************************************

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from sales_retail where sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where 
-- the category is 'Clothing' and the 
-- quantity sold is more than 3 in the month of Nov-2022;

SELECT * 
FROM sales_retail 
WHERE category = 'Clothing' 
AND sale_date >= '2022-11-01' 
AND sale_date < '2022-12-01'
AND quantity > 3;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM sales_retail
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.;
select * from sales_retail where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(transaction_id) as count from sales_retail 
group by category, gender order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year, month, avg_sale
from 
(
select 
year(sale_date) as year,
month(sale_date) as month,
avg(total_sale) as avg_sale, 
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rn
from sales_retail
group by 1, 2) as t1
where rn=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
customer_id, sum(total_sale)
from sales_retail
group by 1
order by 2
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.








--  *************************************************************************************************************
