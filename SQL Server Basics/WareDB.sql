DECLARE @Databasename VARCHAR(128) = 'WH';
IF NOT EXISTs(select 1 FROM sys.databases where name = @Databasename)
BEGIN
	DECLARE @SQL NVARCHAR(MAX)='CREATE DATABASE ' + QUOTENAME(@Databasename);
	EXEC sp_executesql @sql; 
END

use WH;

CREATE TABLE [dbo].fast (
    Ware_house_ID VARCHAR(20),
    WH_Manager_ID VARCHAR(20),
    Location_type VARCHAR(10),
    WH_capacity_size VARCHAR(10),
    zone VARCHAR(10),
    WH_regional_zone VARCHAR(10),
    num_refill_req_l3m INT,
    transport_issue_l1y INT,
    Competitor_in_mkt INT,
    retail_shop_num INT,
    wh_owner_type VARCHAR(20),
    distributor_num INT,
    flood_impacted INT,
    flood_proof INT,
    electric_supply INT,
    dist_from_hub INT,
    workers_num INT,
    wh_est_year INT,
    storage_issue_reported_l3m INT,
    temp_reg_mach INT,
    approved_wh_govt_certificate VARCHAR(20),
    wh_breakdown_l3m INT,
    govt_check_l3m INT,
    product_wg_ton INT
);

BULK INSERT fast FROM 'D:/FMCG_data.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2			--skip the header from records
);

SELECT * FROM [dbo].fast;

select count(*) as Num_of_Records from fast;

--2. Write a query to find warehouse with minimum product weight(bottom 5)
select top(5) Ware_house_ID, product_wg_ton from fast order by product_wg_ton DESC;
select top(5) Ware_house_ID, product_wg_ton from fast order by product_wg_ton;

--4. find out the total number of WH regional zone count of each category
select WH_regional_zone, count(WH_regional_zone) from fast group by WH_regional_zone order by WH_regional_zone asc;

--5. Find avg, min, max, median warehouse with minimum capacity of 1000 and location type urban
with warehouse as(
	select dist_from_hub,PERCENTILE_CONT(0.5) within group (order by dist_from_hub)
	over() as MEDIAN 
	from fast
	where Location_type='Urban' and product_wg_ton> 10000
)
select avg(dist_from_hub)as average,
       min(dist_from_hub) as minimum,
       max(dist_from_hub) as maximum,
(select distinct median from warehouse) as median
from fast where Location_type='Urban' and product_wg_ton> 10000;

--6. Window Function -  In sql server window function performs calculations across set
--of table rows. unlike aggregatw function which return a single value, for group of rows.
--window function return a value for each row in result set.

select * from fast;

select Ware_house_ID, Location_type, zone, wh_owner_type,Competitor_in_mkt, product_wg_ton,
RANK() OVER(PARTITION BY Competitor_in_mkt ORDER BY product_wg_ton DESC)
AS WH_RANK FROM FAST;



--another example 
select Ware_house_ID, Location_type, zone,distributor_num, retail_shop_num,
RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC)
AS WH_RANK FROM FAST;

--DENSE_RANK gives us continous rank
select Ware_house_ID, Location_type, zone,distributor_num, retail_shop_num,
DENSE_RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC)
AS WH_RANK FROM FAST;

--with CTE to find top 5 ranks of each category 
-- using CTE WITH
with rankCTE as(
	select 
		Ware_house_ID,
		Location_type,
		zone,
		wh_owner_type,
		product_wg_ton,
		Competitor_in_mkt,
	rank() over(partition by Competitor_in_mkt order by product_wg_ton desc)
	as wh_rank from fast
	)
select * from rankCTE where wh_rank<=5;
  
-- using subquery
SELECT * FROM(
SELECT
Ware_house_ID, Location_type, zone,
distributor_num, retail_shop_num,
DENSE_RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC)
AS WH_RANK FROM FAST)
AS warehouses
where WH_RANK <=5;

--show first 5 rows
SELECT TOP(5) * FROM(
SELECT
Ware_house_ID, Location_type, zone,
distributor_num, retail_shop_num,
DENSE_RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC)
AS WH_RANK FROM FAST)
AS warehouses;

--Lag & Lead
--LAG shows the previous value to the current cell
SELECT Ware_house_ID, Location_type, zone,
distributor_num, retail_shop_num,workers_num,product_wg_ton,
LAG(product_wg_ton,1) OVER(PARTITION BY zone ORDER BY workers_num DESC)
AS prev_product_wg_ton FROM FAST

-- LEAD
--LAG shows the NEXT value to the current cell
SELECT 
	Ware_house_ID, Location_type, zone, distributor_num, retail_shop_num,workers_num,product_wg_ton,
	LEAD(product_wg_ton,1) OVER(PARTITION BY zone ORDER BY workers_num DESC)
	AS NEXT_product_wg_ton 
FROM FAST

--NTILE -- percentiles (will divide the whole data into equal interval as we metnioned)
SELECT 
	Ware_house_ID, Location_type, zone, distributor_num, retail_shop_num,workers_num,product_wg_ton,
	NTILE(4) OVER(ORDER BY product_wg_ton ASC)
	AS QUARTILES 
FROM FAST

--
SELECT 
	Ware_house_ID, Location_type, zone, distributor_num, retail_shop_num,workers_num,product_wg_ton,
	PERCENT_RANK() OVER(ORDER BY workers_num ASC)
	AS Percentiles
FROM FAST  where workers_num>=0;

--show all records where number of workers comes in range of first 40th percentile).
select * from(
SELECT 
	Ware_house_ID, Location_type, zone, distributor_num, retail_shop_num,workers_num,product_wg_ton,
	PERCENT_RANK() OVER(ORDER BY workers_num ASC)
	AS Percentiles
FROM FAST  where workers_num>=0)
as percentilerange where Percentiles<0.4;

-- find the Difference b/w current value of product_wt_ton and compare it with previous 2 values [lag(2)]
-- and rank the overall records as per Differences.
select * from fast;

with diffCTE as(
SELECT 
	Ware_house_ID, Location_type, zone, distributor_num,workers_num,product_wg_ton,
	lag(product_wg_ton, 2) OVER(PARTITION BY zone ORDER BY product_wg_ton ASC) as prev_value,
	product_wg_ton - LAG(product_wg_ton, 2) OVER (ORDER BY product_wg_ton ASC) AS diff
from fast
) SELECT *,
	rank() over(order by diff desc) as Rank
FROM diffCTE where diff>=0
ORDER BY Rank;

