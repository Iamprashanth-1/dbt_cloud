{{ config(materialized='table') }}

select Location, count(location) ,avg(total_recovered) ,avg(new_deaths) , avg(total_cases) ,avg(total_active_cases) ,sum(total_deaths) from INTERVIEW_DB.PLAYGROUND_Prashanth_Reddy.DBT_COVID19
 group by location; 

 SELECT  Location,
		MAX(total_cases) AS TotalCases 
FROM INTERVIEW_DB.PLAYGROUND_Prashanth_Reddy.DBT_COVID19 
GROUP BY location 
ORDER BY TotalCases DESC;


WITH cte AS
(SELECT  Date,
		 location,
		 
		 MAX(new_Active_cases) OVER (PARTITION BY location) AS MaxActiveCasesInDay,
		 DENSE_RANK() OVER (PARTITION BY location ORDER BY new_Active_cases desc) AS HighestActive
FROM INTERVIEW_DB.PLAYGROUND_Prashanth_Reddy.DBT_COVID19 )
SELECT location, Date, MaxActiveCasesInDay 
FROM cte 
WHERE HighestActive = 1 
ORDER BY MaxActiveCasesInDay DESC;
