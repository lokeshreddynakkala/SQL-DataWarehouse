- Change Over Time Analysis

--How have total sales, number of customers, and quantity sold changed over time (by year and month)?

select year(order_date) as order_year,
MONTH(order_date) as order_month,
sum(sales_amount) as Total_sales,
count(distinct customer_key) as total_customers
,sum(quantity) as total_quantity
from gold.fact_sales 
where order_date is not null
group by year(order_date),month(order_date) 
order by year(order_date),month(order_date) 

-- Performance Analysis

--How has each product performed over the years compared to its historical average and the previous year’s sales?



WITH yearly_product_sales AS (
SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
	)

  select 
   order_year,
    product_name,
    current_sales,
    avg(current_sales) over(partition by product_name) as avg_sales,
    current_sales-avg(current_sales) over(partition by product_name) as avg_sales,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
        end as avg_change,
        lag(current_sales) over (PARTITION BY product_name ORDER BY order_year) AS py_sales,
		current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
		    CASE 
             WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
	FROM yearly_product_sales

	
-----Part to Whole Analysis-----
with category_sales as(
select p.category
,sum(f.sales_amount) as total_sales 
from gold.fact_sales f  left join gold.dim_products p 
on p.product_key= f.product_key
group by p.category )

select category,
total_sales,
sum(total_sales)over() as overall_sales 
,Round((cast(total_sales as float)/sum(total_sales)over())*100,2) as percentage_of_total 
from category_sales 
order by total_sales desc

----Data Segmentation----

with product_segments as(
select 
product_key,
product_name,
cost,
case
when cost < 100 then 'Below 100'
when cost between 100 and 500 then '100-500'
when cost between 500 and 1000 then '500-1000'
else 'Above 1000'
end as cost_range
from gold.dim_products
)
select 
cost_range,
count(*) as total_products 
from Product_segments 
group by cost_range

--- Segmenting customers based on ther ---
with customer_spending as (
select 
c.customer_key,
sum(f.sales_amount) as total_spending,
min(f.order_date) as first_order,
max(f.order_date) as last_order,
DATEDIFF(month,min(f.order_date),max(f.order_date)) as lifespan
from gold.fact_sales f 
left join gold.dim_customers c 
on f.customer_key=c.customer_key
group by c.customer_key
)
select
customer_segment,
count(customer_key) as total_customers
from(
select 
customer_key,
case 
when lifespan >= 12 AND total_spending > 5000 then 'VIP'
when lifespan >= 12 AND total_spending <= 5000 then 'Regular'
else 'New'
end as customer_segment
from customer_spending 
)
as segmented_customers
group by customer_segment
order by total_customers desc
