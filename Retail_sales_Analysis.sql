-- Sql Retail sales Analysis

create database Sql_project_1;
use Sql_project_1;

-- creating Table

create table retail_sales(
transactions_id	int primary key,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(7),
age	int,
category varchar(30),
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float
);

drop table retail_sales;

select * from retail_sales
where transactions_id is null
 or
sale_date is null
 or
sale_time is null
 or
customer_id is null
 or
gender is null
 or
age is null
 or
category is null
 or
quantiy is null
 or
price_per_unit is null
 or
cogs is null
 or
total_sale is null;

-- Data Exploration

select * from retail_sales;

-- How Many sales we have ?

select count(*) as Total_Sales from retail_sales;

-- How Many Unique Customer we have ?

select  count(distinct customer_id) as Total_Customer from retail_sales;

-- How Many Unique Category we have ?

select distinct Category from retail_sales;

-- Data Analysis / Business Key Problems Ans

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q1) Write a SQL query retrieve all columns for sales made on 2022-11-05
  
  select * from retail_sales
  where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

   select *,row_number() over() as Num from retail_sales
  where category = 'Clothing'  and quantiy >= 4 and sale_date  between '2022-11-01' and '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, 
sum(total_sale) as Total_sale ,
count(*) as Total_Orders
from retail_sales
group by category;

 -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select category, 
round(avg(age),2) as Average_age 
from retail_sales
group by category
having category='Beauty' ;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail_sales
where total_sale > 1000 ;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender ,
count(*) as Total_transcation 
from retail_sales
group by category,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT sale_year, sale_month, avg_monthly_sale
FROM (
    SELECT
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_monthly_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
) AS ranked_sales
WHERE rnk = 1;

with sale as (
select Year(sale_date) as year,
monthname(sale_date) as month ,
avg(Total_sale) Avg,
rank() over(partition by Year(sale_date) order by avg(Total_sale) desc ) as rnk
from retail_sales
group by Year(sale_date),monthname(sale_date)
order by 1,2
)
select year, Month,avg from sale
where rnk=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id, 
sum(total_sale) as Total_sale 
from retail_sales
group by customer_id
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select  category,
count(distinct customer_id) as Unique_customer 
from retail_sales
group by  category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly as (
select *,
case
when hour(sale_time)<=12 then "Morning"
when hour(sale_time) Between 12 and 17 then "Afternoon"
else "Evening"
end as shift
from retail_sales
)
select shift,count(*) as no_of_Orders
from hourly
group by shift;

-- End of Project






