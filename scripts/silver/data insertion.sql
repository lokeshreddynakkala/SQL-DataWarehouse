---------------------------------------------------------fix silver.crm_cust_info----------------------------------------------------------------------------


insert into silver.crm_cust_info (
            cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname, 
			cst_marital_status, 
			cst_gndr,
			cst_create_date)
			(select 
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
where rank = 1 and cst_id is not null);



---------------------------------------------------------- fix silver.crm_prd_info---------------------------------------------------------------------------------------


-- The IF and Go is use to check the table silver.crm_prd_info is creared or not  if it present the drop it Else Create new table because while cleaning the product key is splited in is and product key 


IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
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


------------------------------------------------------------ fix silver.crm sales_details -------------------------------------------------------------------------



-- We need to change the data type of date as they are int type so before inserting the data we are going to change the data types in the table 


IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

	

-- insert into crm_sales_details ---


INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)select 
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

-------------------------------------------------------fix silver.erp_px_cat_g1v2--------------------------------------------------------------------------
INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2


--------------------------------------------------- insert into silver  erp_cust_az12-------------------------------------------------------------------



INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
select 
case 
when cid like 'nas%' then SUBSTRING(cid,4,len(cid)) 
else cid 
end as cid,
case 
when bdate > GETDATE() or  bdate < '1925-10-18' then null
else bdate
end as bdate,
case
when UPPER(trim(gen)) in ('F','FEMALE') then 'FEMALE'
when UPPER(trim(gen)) in ('M','MALE') then 'MALE'
ELSE 'n/a'
end as gen
from bronze.erp_cust_az12

--------------------------------------------------------  silver.erp_loc_a101 --------------------------------------------------------------------------------------

 INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)
 select REPLACE(cid,'-','') ,
 case 
when trim(cntry) in ('DE','Germany') then 'Germany'
when trim(cntry) in ('USA','US','United States') then 'United States'
when trim(cntry) = '' or cntry IS NULL  then 'n/a'
 else trim(cntry)
 end as cntry 
 from bronze.erp_loc_a101
