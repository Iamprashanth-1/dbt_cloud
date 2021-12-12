-- death rates
{{ config(materialized='table') }}

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