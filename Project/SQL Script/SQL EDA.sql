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
		department
	;

    
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
    SUM(CASE WHEN status IN ('Active', 'Resigned') THEN 0 ELSE 1 END) AS total_attrition,
    ROUND(AVG(CASE WHEN status = 'Resigned' THEN 1 ELSE 0 END)*100,2) AS overall_attrition_rate
FROM hr_data;

-- Attrition rate by dimension 
-- 		Department


SELECT 
	COUNT(department) as Total_dept_emp,
    SUM(CASE WHEN status IN ('Active','Resigned') THEN 0 ELSE 1 END) AS dept_attrition,
	ROUND(AVG(CASE WHEN status IN('Active', 'Resigned') THEN 0 ELSE 1 END)*100,2) AS overall_attrition_rate
FROM hr_data
GROUP BY(department);


-- 		Job Level
-- 		Work mode
-- 		country
-- 		Tenure

