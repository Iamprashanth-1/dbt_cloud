-- Recovery  rates
{{ config(materialized='table') }}

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
