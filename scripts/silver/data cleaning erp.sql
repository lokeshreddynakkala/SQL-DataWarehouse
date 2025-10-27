-----------------------------------------------------------cleaning erp_px_cat_g1v2------------------------------------------------------------------------------

--checking for table relation --

select * from silver.crm_prd_info
select * from bronze.erp_px_cat_g1v2

--checking for whitespaces in id,cat,subcat,maintenance--

select * from bronze.erp_px_cat_g1v2 where id <> trim(id) or cat != trim(cat) or subcat <> trim(subcat) or maintenance <> trim(maintenance)
--no whitespaces--

-- checking for null values in id,cat,subcat,maintenance-

select * from bronze.erp_px_cat_g1v2 where id is null or cat is null or subcat is null or maintenance is null

--no null values 

-- final quary--
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2



------------------------------------------------------------cleaning erp_cust_az12-------------------------------------------------------------------

select * from bronze.erp_cust_az12

--checkin for relationships----
select * from silver.crm_cust_info

select * from bronze.erp_cust_az12

---checking for whitespaces and null values in cid,gen

select * from bronze.erp_cust_az12 where cid <> trim(cid) or cid is null or gen <> trim(gen) or gen is null

--only null values in gen---

-- select  cid form forth character--

select 
case 
when cid like 'nas%' then SUBSTRING(cid,4,len(cid)) 
else cid 
end as cid from bronze.erp_cust_az12 


--checking bdate grater then today and 100years --

select * from  bronze.erp_cust_az12 where bdate > GETDATE() or  bdate < '1925-10-18'


select case 
when bdate > GETDATE() or  bdate < '1925-10-18' then null
else bdate
end as bdate
from bronze.erp_cust_az12


select 
case 
when cid like 'nas%' then SUBSTRING(cid,4,len(cid)) 
else cid 
end as cid,
case 
when bdate > GETDATE() or  bdate < '1925-10-18' then null
else bdate
end as bdate
from bronze.erp_cust_az12


--checking for different types of values in gen ---

select distinct gen from bronze.erp_cust_az12

--there are null,f,male,female,m,balnkspace --

select case
when UPPER(trim(gen)) in ('F','FEMALE') then 'FEMALE'
when UPPER(trim(gen)) in ('M','MALE') then 'MALE'
ELSE 'n/a'
end as gen
from  bronze.erp_cust_az12


--fianl query----

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


----------------------------------------------------------cleaning bronze.erp_loc_a101------------------------------------------------------------------
select * from bronze.erp_loc_a101

-- checking relationships--
select * from silver.crm_cust_info

select * from bronze.erp_loc_a101

--checking for null and whitespaces in cid,cntry--

select * from bronze.erp_loc_a101 where cid is null or cid <> trim(cid) or cntry is null or cntry <> trim(cntry)

--null values in cntry --

--removing '-' in cid 

select REPLACE(cid,'-','') from bronze.erp_loc_a101

-- finging distinct values in cntry--

select distinct cntry from bronze.erp_loc_a101

-- handling inconstinces--

select 
case 
when trim(cntry) in ('DE','Germany') then 'Germany'
when trim(cntry) in ('USA','US','United States') then 'United States'
when trim(cntry) = '' or cntry IS NULL  then 'n/a'
 else trim(cntry)
 end as cntry
 from  bronze.erp_loc_a101


 -- final query---

 select REPLACE(cid,'-','') ,
 case 
when trim(cntry) in ('DE','Germany') then 'Germany'
when trim(cntry) in ('USA','US','United States') then 'United States'
when trim(cntry) = '' or cntry IS NULL  then 'n/a'
 else trim(cntry)
 end as cntry 
 from bronze.erp_loc_a101
