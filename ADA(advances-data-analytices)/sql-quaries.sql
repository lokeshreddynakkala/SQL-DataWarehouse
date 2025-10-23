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
