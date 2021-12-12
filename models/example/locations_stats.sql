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

-- death rates
WITH cte_death AS
(SELECT  location,
		max(total_Deaths) as Deaths,
		max(total_cases) as CovidCases
FROM INTERVIEW_DB.PLAYGROUND_Prashanth_Reddy.DBT_COVID19
GROUP BY location)
SELECT  location, 
		CAST(Round((Deaths/CovidCases)*100, 2) as nvarchar(10))  AS DeathRate
FROM cte_death
ORDER BY DeathRate DESC;

-- Recovery  rates
WITH cte_recovery AS
(SELECT  location,
		max(total_recovered) as Recovered,
		max(total_cases) as CovidCases
FROM INTERVIEW_DB.PLAYGROUND_Prashanth_Reddy.DBT_COVID19
GROUP BY location)
SELECT  location, 
		CAST(Round((Recovered/CovidCases)*100, 2) as nvarchar(10))  AS RecovereyRate 
FROM cte_recovery
ORDER BY RecovereyRate DESC;