 -- case study --- -Supply chain Management

 use WH --use this db

--1. Find the Shape of the FMCG Table. 
-- Question: How would you determine the total number of 
-- rows and columns in the FMCG dataset?

select count(*) AS NumofRows from fast ;

select count(*) AS NumofColumns FROM INFORMATION_SCHEMA.columns 
where TABLE_NAME = 'fast';

--2. Evaluate the Impact of Warehouse Age on Performance. 
--	 Question: How does the age of a warehouse impact its 
--   operational performance, specifically in terms of 
--   storage issues reported in the last 3 months?

select * from fast

select (YEAR(GETDATE()) -wh_est_year) AS WareHouseAge,
avg(storage_issue_reported_l3m) AS AvgStorageIssue from fast
WHERE wh_est_year is not NULL
GROUP BY (YEAR(GETDATE()) -wh_est_year)
ORDER BY WareHouseAge ASC;

                          --Insight --
--Studying the query response we can say that there is positive 
--coorelation or direct relation b/w WH age and avg storage issues
--------------------------- --------------------------------------

--3. Analyze the Relationship Between Flood-Proof 
--   Status and Transport Issues. 

--   Question: Is there a significant relationship between 
--   flood-proof status and the number of 
--   transport issues reported in the last year?


select flood_proof, sum(transport_issue_l1y) as totaltransportissue
from fast group by flood_proof;

                      -- Insight --
-- More transportation issue has found for non-flood proof warehouses.



-- 4. Evaluate the Impact of Government Certification on 
-- Warehouse Performance. 
-- Question: How does having a government certification impact 
-- the performance of warehouses, particularly in terms of 
-- breakdowns and storage issues?

select approved_wh_govt_certificate, 
avg(wh_breakdown_l3m),
avg(storage_issue_reported_l3m) as storagreissue from fast 
group by approved_wh_govt_certificate
order by approved_wh_govt_certificate;

                         --Insight--
--Comapring values of approved_wh_govt_certificate and sum of
--breakdowns and avg of storage issues, No Relation found amoung all



-- E) Determine the Optimal Distance from Hub for Warehouses:
-- Question: What is the optimal distance from the 
-- hub for warehouses to minimize transport issues, 
-- based on the data provided?

select avg(dist_from_hub) as min_dist,
transport_issue_l1y from fast
group by transport_issue_l1y
order by transport_issue_l1y;

            --Insight--
-- optimum distance from hub must be less than uqal to 162 
-- for no transport issues


-- F.Identify the Zones with the Most Operational Challenges.
-- Question: Which zones face the most operational challenges
-- considering factors like transport issues, storage problems, 
-- and breakdowns?



select zone, 
	sum(transport_issue_l1y) as transport_issue,
	sum(storage_issue_reported_l3m) as storage_issue,
	sum(wh_breakdown_l3m) as breakdown,
	(sum(transport_issue_l1y) + sum(storage_issue_reported_l3m)+
	sum(transport_issue_l1y)) as total_issue
from fast
group by zone
order by total_issue asc;


-- G) Examine the Effectiveness of Warehouse Distribution Strategy. 
-- Question: How effective is the current distribution
-- strategy in each zone, based on the number of distributors 
-- connected to warehouses and their respective product weights?


select 
	zone, 
	sum(distributor_num) as distributor,
	sum(product_wg_ton) as product_weight,
	sum(product_wg_ton) / sum(distributor_num) from fast
	group by zone;

	--Insight --
--current distribution plan is best in east 
--zone and worst in south and west

--G) Identify High-Risk Warehouses Based on Breakdown
--   Incidents and Age. 
--   Question: Which warehouses are at high risk of breakdowns, 
--   especially considering their age and the number of 
-- breakdown incidents reported in the last 3 months?

select Ware_house_ID,
(YEAR(GETDATE()) - wh_est_year) as warehouseage,
wh_breakdown_l3m,
CASE
	WHEN wh_breakdown_l3m > 5 THEN 'High_Risk'
	WHEN wh_breakdown_l3m >=3 THEN 'Medium_Risk'
	ELSE 'LOW_RISK'
END AS Risklevel
from fast WHERE (YEAR(GETDATE()) - wh_est_year) > 15
ORDER BY wh_breakdown_l3m DESC;
 
-- I) Correlation Between Worker Numbers and Warehouse Issues. 
-- Question: Is there a correlation between the number of workers in a 
-- warehouse and the number of storage or breakdown issues reported?

SELECT avg(workers_num)as avg_workers,
	avg(storage_issue_reported_l3m) as storage_issue,
	avg(wh_breakdown_l3m) as avg_breakdown
	from fast
	group by workers_num
	order by workers_num;

select * from fast;

-- J) Assess the Zone-wise Distribution of Flood Impacted Warehouses.
-- Question: Which zones are most affected by flood impacts, and 
-- how does this affect their overall operational stability?

select zone, COUNT(*) AS TOTAL_WAREHOUSE,
	SUM(CASE
		WHEN  flood_impacted = 1 THEN 1 
		ELSE 0 
		END) AS Floodimpacted_warehouse,
	SUM(CASE 
		WHEN  flood_impacted = 1 THEN 1 ELSE 0 END) *100 / count(*) AS flood_Impact_percentage
FROM fast GROUP BY ZONE order by flood_Impact_percentage desc;


--insight --
--analyzing all zones, flood impacted warehouse percentage can be conlcuded that north zone
--wearhouse hightly affected by flood


--K) Calculate the Cumulative Sum of Total Working Years for Each Zone. 
-- Question: How can you calculate the cumulative sum of total working years for each zone?

select zone, 
SUM(YEAR(GETDATE()) - wh_est_year) OVER(ORDER BY zone ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
AS Cummulative_age
from fast;

select zone, 
YEAR(GETDATE()) - wh_est_year FROM fast ORDER BY zone;

--K) Calculate the Cumulative Sum of Total Workers for Each warehouse govt. rating. 
-- Question: write a query to Calculate the cumulative sum of total workers for each 
-- warehouse govt. Rating?

select approved_wh_govt_certificate, workers_num,
sum(workers_num) over(Partition by approved_wh_govt_certificate order by approved_wh_govt_certificate
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT
ROW) AS CUMMULATIVE_SUM FROM fast;

-- L) Rank Warehouses Based on Distance from the Hub. 
-- Question: How would you rank warehouses based on their distance from the hub?

select Ware_house_ID,
	  dist_from_hub,
dense_rank() over(order by dist_from_hub) as rank
from fast

-- M) Calculate the Running avg of Product Weight in Tons for Each Zone:
-- Question: How can you calculate the running total of product weight in tons for each zone?


select product_wg_ton, zone,
avg(product_wg_ton) over(Partition by zone order by zone
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT
ROW) AS CUMMULATIVE_AVG FROM fast;

--N) Rank Warehouses Based on Total Number of Breakdown Incidents. 
-- Question: How can you rank warehouses based on the total number of breakdown incidents in the 
-- last 3 months?

select Ware_house_ID, wh_breakdown_l3m,
dense_rank() over(order by wh_breakdown_l3m) as rank
from fast

--O )Determine the Relation Between Transport Issues and Flood Impact.
-- Question: Is there any significant relationship between the number of transport issues 
-- and flood impact status of warehouses?

select flood_impacted, sum(transport_issue_l1y)as totaltransportissue
from fast group by flood_impacted

