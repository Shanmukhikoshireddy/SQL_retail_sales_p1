/*DROP TABLE if exists retail_sales;
create table retail_sales(
transactions_id	INT,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),	
quantiy INT,
price_per_unit FLOAT,
cogs FLOaT,
total_sale FLOAT

);*/
select * from retail_sales;
select count(*) from retail_sales;

--data cleaning 
select * from retail_sales 
where 
    sale_date is null
    or transactions_id is null 
	or sale_time is null 
	or gender is null
	or category is null
	or quantiy is null
	or cogs is null
	or total_sale is null;
--
delete from retail_sales where 
    sale_date is null
    or transactions_id is null 
	or sale_time is null 
	or gender is null
	or category is null
	or quantiy is null
	or cogs is null
	or total_sale is null;

--data explorations
--how many sales we have
select count(*) as total_sale from retail_sales;

--how many unique customers
select count(customer_id) as total_sale from retail_sales;

--category
select distinct category as categories from retail_sales;

--data analysis and key problems

--q1 retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';

--q2 retrive all transactions where the category is 'clothing and the quantity sold is more than 10 in the month of nov-2022'
select * from retail_sales where category='Clothing' and quantiy>=4 and TO_CHAR(sale_date,'YYYY-MM') ='2022-11';

--q3 calculate the toal sales (total_sale) for each category
select category,sum(total_sale) as net_sale,count(*) as total_orders from retail_sales group by category;

--q4 find the avg age of customers who purchases item from the 'beauty' category
select avg(age) as avg_age from retail_sales where category='Beauty'

--q5 find all transactions where the total_sale is greater then 1000
select * from retail_sales where total_sale >1000;

--q6 total number of transactions (transactions_id) made by each gender im each category
select category,gender,count(*) as total_trans from retail_sales group by category,gender order by 1

--q7 calculate the avg sale for each month find out best selling month in each year
select year,month,avg_sale from(
select
   extract(year from sale_date) as year,
   extract(month from sale_date) as month,
   avg(total_sale) as avg_sale,
   rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales 
group by year,month --order by 1,3 desc
) as t1
where rank<3

select * from retail_sales
--q8 find the top 5 customers based on the highest total_sales
select * from (select customer_id,sum(total_sale) as total_sale from retail_sales group by customer_id) order by total_sale desc limit 5

--q9 find the number of unique customers who purchased items from each category
select category,count(distinct customer_id) from retail_sales group by category

--q10 create each shift and number of orders (example morning <=12,afternoon between 12 and17,evening >17)
--select count(extract(hour from sale_time)<=12 )as mrng,count(extract(hour from sale_time) between 12 and 17 )as afternoon,count(extract(hour from sale_time)>=17 ) as eveng from retail_sales


with hourly_sale
as
(
select *,
   case 
       when extract(hour from sale_time) <12 then 'morning'
	   when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	   else 'evening'
   end as shift
from retail_sales
)
select shift,count(*) as total_orders
from hourly_sale group by shift