use datawarehouse
------------------------------------------------- cleaning crm_cust_info-----------------------------------------------------------------------------

select * from bronze.crm_cust_info

-- checking duplicate and null values in cst_id 


select cst_id,count(*) from bronze.crm_cust_info group by cst_id having COUNT(cst_id) >1 or cst_id is null

--removing duplicate and null values in cst_id 

select distinct * from(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank from bronze.crm_cust_info) as t where cst_id is not null

select cst_id from(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank from bronze.crm_cust_info) as t where rank = 1 and cst_id is not null



select cst_id from(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank from bronze.crm_cust_info) as t where rank = 1 and cst_id is not null
 
 
 
 --checking for white spaces in cst_firstname

select cst_id from bronze.crm_cust_info where cst_firstname <> trim(cst_firstname)


-- removing white spaces in cst_firstname

select TRIM(cst_firstname) from bronze.crm_cust_info


select cst_id,TRIM(cst_firstname) as cst_firstname from(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank from bronze.crm_cust_info) as t where rank = 1 and cst_id is not null

--checking for white spaces in cst_lastname

select cst_id from bronze.crm_cust_info where cst_lastname <> trim(cst_lastname)


-- removing white spaces in cst_lastname

select TRIM(cst_lastname) from bronze.crm_cust_info



select cst_id,TRIM(cst_firstname) as cst_firstname,TRIM(cst_lastname) as cst_lastname
from
(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank 
from 
bronze.crm_cust_info) as t where rank = 1 and cst_id is not null   


--checking for white spaces in  cst_marital_status

select * from bronze.crm_cust_info where cst_marital_status <> trim(cst_marital_status)


--no white spaces in it

--checking constraints in  cst_marital_status

select distinct cst_marital_status from bronze.crm_cust_info

-- there is only M and S
--standardizing the cst_marital_status

select cst_id,case
when UPPER(trim(cst_marital_status)) = 'M' then 'Married'
when UPPER(trim(cst_marital_status)) = 'S' then 'Single'
end  as cst_marital_status from bronze.crm_cust_info



select cst_id,TRIM(cst_firstname) as cst_firstname,TRIM(cst_lastname) as cst_lastname,
case
when UPPER(trim(cst_marital_status)) = 'M' then 'Married'
when UPPER(trim(cst_marital_status)) = 'S' then 'Single'
end  as cst_marital_status 
from
(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank 
from 
bronze.crm_cust_info) as t where rank = 1 and cst_id is not null

--checking for white spaces in  cst_gndr

select * from bronze.crm_cust_info where cst_gndr <> trim(cst_gndr)


--no white spaces in it

--checking constraints in  cst_gndr

select distinct cst_gndr from bronze.crm_cust_info

-- there is only M and F
--standardizing the cst_gndr

select case when UPPER(trim(cst_gndr)) = 'M' then 'Male'
when upper(trim(cst_gndr)) = 'F' then 'Female'
else 'n/a'


--final quary--
select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
case
when UPPER(trim(cst_marital_status)) = 'M' then 'Married'
when UPPER(trim(cst_marital_status)) = 'S' then 'Single'
else 'n/a'
end  as cst_marital_status,
case
when UPPER(trim(cst_gndr)) = 'M' then 'Male'
when UPPER(trim(cst_gndr)) = 'F' then 'Female'
else 'n/a'
end  as cst_gndr,
cst_create_date
from
(select *,ROW_NUMBER() over(partition by cst_id order by  cst_create_date desc) as rank 
from bronze.crm_cust_info) 
as t
where rank = 1 and cst_id is not null




-------------------------------------------------------cleaning crm_prd_info---------------------------------------------------------------------


select * from bronze.crm_prd_info


--checking duplicates and null valuse in crm_prd_info

select prd_id,count(prd_id) as prd_count from bronze.crm_prd_info group by prd_id having(count(prd_id)) > 1 or prd_id is null

--checking white spaces in prd_key-

select * from bronze.crm_prd_info where prd_key <> trim( prd_key)
-- no white spaces--

-- spliting prd_key into cat_id and prd_key--

select replace(substring(prd_key,1,5),'-','_') as cat_id,substring(prd_key,7,len(prd_key)) as prd_key from bronze.crm_prd_info

select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,len(prd_key)) as prd_key 
from bronze.crm_prd_info


--checking negitive and zero values in prd_cost--

select * from bronze.crm_prd_info where prd_cost <= 0 

-- no negitive and zero values

-- converting null values as zero --

select 
ISNULL(prd_cost,0) as prd_cost from bronze.crm_prd_info 


select 
prd_id,
substring(prd_key,1,5) as cat_id,
replace(substring(prd_key,7,len(prd_key)),'-','_') as prd_key, 
ISNULL(prd_cost,0) as prd_cost
from bronze.crm_prd_info

-- checking constraints in prd_line

select distinct prd_line from bronze.crm_prd_info

--there are only M,R,S,T--

--standardizang the prd_line --

select case 
WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
when UPPER(trim(prd_line)) = 'R' then 'Road'
when UPPER(trim(prd_line)) = 'S' then 'Other Sales'
when UPPER(trim(prd_line)) = 'T' then 'Touring'
else 'n/a'
end as prd_line
from bronze.crm_prd_info


select 
prd_id,
substring(prd_key,1,5) as cat_id,
replace(substring(prd_key,7,len(prd_key)),'-','_') as prd_key, 
ISNULL(prd_cost,0) as prd_cost,
case 
WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
when UPPER(trim(prd_line)) = 'R' then 'Road'
when UPPER(trim(prd_line)) = 'S' then 'Other Sales'
when UPPER(trim(prd_line)) = 'T' then 'Touring'
else 'n/a'
end as prd_line
from bronze.crm_prd_info

--checking for prd_end_dt id lesser the prd_start_date--

select prd_id,prd_start_dt,prd_end_dt from  bronze.crm_prd_info where prd_start_dt > prd_end_dt


--Correcting prd_end_dt--

select prd_key,cast(prd_start_dt as date) as prd_start_date,cast(lead(prd_start_dt) over( partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt from  bronze.crm_prd_info


--final quary--
select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
case 
WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
when UPPER(trim(prd_line)) = 'R' then 'Road'
when UPPER(trim(prd_line)) = 'S' then 'Other Sales'
when UPPER(trim(prd_line)) = 'T' then 'Touring'
else 'n/a'
end as prd_line,
cast(prd_start_dt as date) as prd_start_date,
cast(lead(prd_start_dt) over( partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
from bronze.crm_prd_info




----------------------------------------------cleaning bronze.crm_sales_details -------------------------------------------------------------------------------

select * from bronze.crm_sales_details 

	-- checking the connections of how bronze.crm_sales_details is related with silver.crm_prd_info
	select * from bronze.crm_sales_details 
	select * from silver.crm_prd_info


	--checking for is there anys values sls_prd_key not in prd_key
select * from bronze.crm_sales_details where sls_prd_key not in
(select prd_key from silver.crm_prd_info)

-- checking for white spaces in sls_ord_num,sls_prd_key

select * from bronze.crm_sales_details where sls_ord_num != trim(sls_ord_num)


select * from bronze.crm_sales_details where sls_prd_key != trim(sls_prd_key)

select * from bronze.crm_sales_details where sls_ord_num != trim(sls_ord_num)
--no whitespaces--

select sls_ord_num,sls_prd_key,sls_cust_id from bronze.crm_sales_details

-- checking  values length less then 8 and converting  to null and  date type of sls_order_dt,sls_due_dt,sls_ship_dt

select * from bronze.crm_sales_details where len(sls_order_dt) != 8 

select * from bronze.crm_sales_details where len(sls_due_dt) != 8 

select * from bronze.crm_sales_details where len(sls_ship_dt) != 8 


select 
case
when len(sls_order_dt) != 8 then null
else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case
when len(sls_ship_dt) != 8 then null 
else cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_date,
case
when len(sls_due_dt) != 8 then null 
else cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt
from bronze.crm_sales_details


select sls_ord_num,sls_prd_key,sls_cust_id,case
when len(sls_order_dt) != 8 then null
else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case
when len(sls_ship_dt) != 8 then null 
else cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_date,
case
when len(sls_due_dt) != 8 then null 
else cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt
from bronze.crm_sales_details

-- checking for null,zero,negitive values in sls_sales,sls_quantity,sls_price

select * from bronze.crm_sales_details where sls_sales <= 0 or sls_sales is null

select * from bronze.crm_sales_details where sls_quantity <= 0 or sls_quantity is null

select * from bronze.crm_sales_details where sls_price <= 0 or sls_price is null

--quality check of  sls_sales,sls_quantity,sls_price

select * from bronze.crm_sales_details where sls_sales !=  sls_quantity*sls_price

select * from bronze.crm_sales_details where sls_quantity <> sls_sales/sls_price

select * from bronze.crm_sales_details where sls_price <> sls_sales/sls_quantity

-- handling the inconsistent values 

select 
case 
when  sls_sales !=  sls_quantity*sls_price then sls_quantity*sls_price
else sls_sales 
end as sls_sales,
case 
when  sls_quantity <> sls_sales/sls_price then sls_sales/sls_price
else sls_quantity
end as sls_quantity,
case 
when sls_price <> sls_sales/sls_quantity then sls_sales/sls_quantity
else sls_price
end as sls_price
from bronze.crm_sales_details


--final quary--
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
case
when len(sls_order_dt) != 8 then null
else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case
when len(sls_ship_dt) != 8 then null 
else cast(cast(sls_ship_dt as varchar) as date)
end as sls_ship_date,
case
when len(sls_due_dt) != 8 then null 
else cast(cast(sls_due_dt as varchar) as date)
end as sls_due_dt,
case 
when  sls_sales !=  sls_quantity*sls_price then sls_quantity*sls_price
else sls_sales 
end as sls_sales,
case 
when  sls_quantity <> sls_sales/sls_price then sls_sales/sls_price
else sls_quantity
end as sls_quantity,
case 
when sls_price <> sls_sales/sls_quantity then sls_sales/sls_quantity
else sls_price
end as sls_price
from bronze.crm_sales_details

