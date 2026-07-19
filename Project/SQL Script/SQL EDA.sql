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
	CASE
		WHEN TIMESTAMPDIFF(MONTH, hire_date, curdate()) < 12 THEN '1 yr'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, curdate()) < 36 THEN '1-3 yrs'
        WHEN TIMESTAMPDIFF(MONTH, hire_date,  curdate()) < 60 THEN '3-5 years'
        ELSE '5+ years'
	END AS tenure_bucket,
	SUM(CASE 
		WHEN status IN ('resigned', 'terminated') THEN 1 
        ELSE 0
	END) AS attrition,
    ROUND(AVG(CASE
				WHEN status IN ('resigned', 'terminated') THEN 1
                ELSE 0
			END)*100,2) as attrition_rate
    
FROM hr_data
GROUP BY tenure_bucket
ORDER BY tenure_bucket;
-- here we can observe that the higher the tenurity, the less likely an employee to leave weather it is voluntary or not
 

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
-- We can observe that the average salary is higher than the minimum salary
-- but compared to the maximum salary, it is nowhere near that 
-- std is also close to the average and minimum salary, it means that just in few walks, it covers almost all of those salaries 
-- insinuating that the distribution at the right side is packed
-- while in the left, few more step (adding the std) to the min or median would still not enough to get to the max salaries 
-- Indicating that the above average salary are skewed, almost outliers

-- Now we will try to observe which department has below or upper salaries 

WITH calculated_salaries as(
	SELECT
		department,
		salary,
		AVG(salary) OVER() AS global_avg_salary
	FROM hr_data
    ),

positioned_salaries AS (
	SELECT
		department,
		salary,
		CASE
			WHEN salary > global_avg_salary THEN 'above'
			Else 'below'
		END as position
	FROM calculated_salaries
)

SELECT 
	department,
    SUM(CASE WHEN position = 'above' Then 1 ELSE 0 END) AS above_avg,
    SUM(CASE WHEN position = 'below' THEN 1 ELSE 0 END) AS below_avg
FROM positioned_salaries
GROUP BY department;



SELECT
	performance_rating,
	SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) AS  active,
    SUM(CASE WHEN status = 'resigned' THEN 1 ELSE 0 END) AS resigned,
    SUM(CASE WHEN status = 'retired' THEN 1 ELSE 0 END) AS retired
FROM hr_data
GROUP BY performance_rating;


-- TENURE ANALYSIS

-- Building Finer tenure Bucket with attrition and attrition rate
-- Resigned and Terminated (Across All performance Rating) 
SELECT
	CASE
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 3 THEN '0-3 months'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 6 THEN '3-6 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 12 THEN '6-12 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 24 THEN '1-2 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 36 THEN '2-3 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 60 THEN '3-5 years'
		ELSE '5+ year'
	END AS fine_tenure_bucket,
	SUM(CASE WHEN status IN ('resigned', 'terminated') THEN 1 ELSE 0 END) AS attrition,
	ROUND(AVG(CASE WHEN status IN ('resigned', 'terminated') THEN 1 ELSE 0 END)*100,2) AS attrition_rate

FROM hr_data
GROUP BY fine_tenure_bucket
ORDER BY MIN(TIMESTAMPDIFF(MONTH, hire_date, CURDATE()));

-- Resigned (Across All performance Rating) 
SELECT
	CASE
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 3 THEN '0-3 months'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 6 THEN '3-6 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 12 THEN '6-12 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 24 THEN '1-2 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 36 THEN '2-3 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 60 THEN '3-5 years'
		ELSE '5+ year'
	END AS split_attrition_bucket,
	SUM(CASE WHEN status = 'resigned' THEN 1 ELSE 0 END) AS resigned_attrition,
	ROUND(AVG(CASE WHEN status = 'resigned' THEN 1 ELSE 0 END)*100,2) AS resigned_attrition_rate,
	SUM(CASE WHEN status = 'terminated' THEN 1 ELSE 0 END) AS terminated_attrition,
	ROUND(AVG(CASE WHEN status = 'terminated' THEN 1 ELSE 0 END)*100,2) AS terminated_attrition_rate

FROM hr_data
GROUP BY split_attrition_bucket
ORDER BY MIN(TIMESTAMPDIFF(MONTH, hire_date, CURDATE()));



-- Attrition rate splitted to resigned and terminated in 'Needs Improvement Group'

SELECT
	CASE
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 3 THEN '0-3 months'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 6 THEN '3-6 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 12 THEN '6-12 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 24 THEN '1-2 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 36 THEN '2-3 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 60 THEN '3-5 years'
		ELSE '5+ year'
	END AS fine_tenure_bucket,
	SUM(CASE WHEN status = 'resigned' THEN 1 ELSE 0 END) AS resigned_attrition,
	ROUND(AVG(CASE WHEN status = 'resigned' THEN 1 ELSE 0 END)*100,2) AS resigned_attrition_rate,
	SUM(CASE WHEN status = 'terminated' THEN 1 ELSE 0 END) AS terminated_attrition,
	ROUND(AVG(CASE WHEN status = 'terminated' THEN 1 ELSE 0 END)*100,2) AS terminated_attrition_rate
FROM hr_data
WHERE performance_rating = 'needs improvement'
GROUP BY fine_tenure_bucket
ORDER BY MIN(TIMESTAMPDIFF(MONTH, hire_date, CURDATE()));


-- Salary by Tenure

SELECT
	CASE
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 3 THEN '0-3 months'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 6 THEN '3-6 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 12 THEN '6-12 months'
        WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 24 THEN '1-2 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 36 THEN '2-3 years'
		WHEN TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) < 60 THEN '3-5 years'
		ELSE '5+ year'
	END AS fine_tenure_bucket,
    AVG(salary) as salary

FROM hr_data
GROUP BY fine_tenure_bucket
ORDER BY MIN(TIMESTAMPDIFF(MONTH, hire_date, CURDATE()));