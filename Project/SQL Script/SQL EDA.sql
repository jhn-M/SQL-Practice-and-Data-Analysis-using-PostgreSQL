USE hr_project;
SELECT COUNT(*) as total_rows
FROM hr_data;


-- Workforce Overview
	-- Headcount Per Department
SELECT 
	department,
	COUNT(*) as count_per_dep
FROM 
	hr_data
GROUP BY 
	department;

    
-- Headcount per Job_Level
SELECT 
	job_level,
	COUNT(*) as count_per_job_level
FROM
	hr_data
GROUP BY 
	job_level;


-- Overall Attrition Rate	
USE hr_project;
SELECT 
	COUNT(*) AS total_employees,
    SUM(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END) AS total_attrition,
    ROUND(AVG(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END)*100,2) AS overall_attrition_rate
FROM hr_data;


-- Attrition rate by dimension 
-- 		Department
SELECT 
	department,
	COUNT(department) as Total_dept_emp,
    SUM(CASE WHEN status IN ('Resigned','Terminated') THEN 1 ELSE 0 END) AS dept_attrition,
	ROUND(AVG(CASE WHEN status IN('Resigned', 'Terminated')THEN 1 ELSE 0 END)*100,2) AS overall_attrition_rate
FROM hr_data
GROUP BY(department);

-- 		Job Level
SELECT
	job_level,
    COUNT(Job_Level) as job_lvl_pop,
    SUM(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END) AS job_lvl_attrition,
    ROUND(AVG(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END)*100,2) AS job_lvl_attrition_rate
FROM 
	hr_data
GROUP BY (job_level);


-- 		Work mode
SELECT
	Work_Mode,
    COUNT(Work_Mode) as population_per_cat,
    SUM(CASE WHEN status in ('Resigned', 'Terminated') THEN 1 ELSE 0 END) AS attrition_per_cat,
    ROUND(AVG(CASE WHEN status in ('Resigned', 'Terminated') THEN 1 ELSE 0 END)*100,2)  AS attrition_rate
FROM hr_data
GROUP BY work_mode;


-- 		country
SELECT
	country,
    COUNT(country) as emp_per_country,
    SUM(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END) AS attrition_per_country,
    ROUND(AVG(CASE WHEN status in ('Resigned', 'Terminated') THEN 1 ELSE 0 END)*100,2) AS attrition_rate
FROM hr_data
GROUP BY country;


-- 	Tenure
SELECT
	job_level,
    COUNT(job_level) as job_level_pop,
    SUM(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END) as job_lvl_attrition,
    ROUND(AVG(CASE WHEN status IN ('Resigned', 'Terminated') THEN 1 ELSE 0 END)*100,2) AS attrition_rate
FROM hr_data
GROUP BY job_level;
	

SELECT distinct status from hr_data;
 

-- SALARY ANALYSIS
-- 	distribution
WITH RankedData AS (
	SELECT
		salary,
		ROW_NUMBER() OVER (ORDER BY salary) as row_num,
		COUNT(*) OVER () AS total_count
	FROM hr_data
	WHERE salary IS NOT NULL 
	),
    
MedianCalculation AS(
	SELECT AVG(salary) AS median
	FROM RankedData
	WHERE row_num IN (FLOOR((total_count + 1)/2), CEIL((total_count+1)/2))
    ),

SummaryStats AS(
SELECT 
	COUNT(salary) AS total_count,
    MIN(salary) AS minimum,
    MAX(salary) AS maximum,
    AVG(salary) AS average,
	stddev(salary) AS std
FROM hr_data
)

SELECT
	s.*,
    m.median
FROM SummaryStats s
CROSS JOIN MedianCalculation m;
-- We can observe that the average salary is significantly higher than the minimum salary
-- while the std 





