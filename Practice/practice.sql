SQLTools: New Connection
-- =====================
-- SUBQUERIES PRACTICE
-- =====================

-- Challenge 1: Employees above average salary
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- Challenge 2: Employees in NYC offices
SELECT first_name, last_name
FROM employees
WHERE office_id IN (
    SELECT office_id FROM offices
    WHERE city = 'New York City'
);

-- Challenge 3: Offices above company average
WITH office_averages AS (
    SELECT office_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY office_id
)
SELECT office_id, ROUND(avg_salary, 2)
FROM office_averages
WHERE avg_salary > (SELECT AVG(salary) FROM employees);

-- =====================
-- WINDOW FUNCTIONS
-- =====================

-- "Show each employee's first name, salary, and the overall company average salary as a new column called company_avg"

SELECT first_name, last_name, ROUND(AVG(salary) OVER(), 2) as company_avg
FROM employees;


-- 2. "Show each employee's first name, last name, salary, and the average salary of their specific office as office_avg"


SELECT first_name, last_name, ROUND(AVG(salary) OVER(PARTITION BY office_id),2) as office_avg
FROM employees;

-- 3. Combining the first two
WITH
base AS (SELECT first_name,
	last_name,
	salary,
	ROUND(AVG(salary) OVER(),2) AS company_avg,
	ROUND(AVG(salary) OVER(PARTITION BY office_id),2) AS office_avg
FROM employees)


SELECT first_name,
	last_name,
	salary,
	company_avg,
	office_avg,
	salary - company_avg AS diff_from_company
FROM base;


-- Challenge 4 — RANK()

SELECT
	first_name,
	salary,
	office_id,
	RANK() OVER(PARTITION BY office_id ORDER BY salary DESC)
FROM employees;

-- ROW_NUMBER() Example
SELECT
	first_name,
	salary,
	office_id,
	ROW_NUMBER() OVER(PARTITION BY office_id ORDER BY salary DESC)
FROM employees;

-- Challenge 4
-- Write a query that shows only the 2nd highest earner in each office. Use ROW_NUMBER, not RANK 

WITH
row_query AS (
SELECT
	first_name,
	salary,
	office_id,
	ROW_NUMBER() OVER(PARTITION BY office_id ORDER BY salary DESC) AS row_quer 
FROM employees
)

SELECT 
	first_name,
	salary,
	office_id,
	row_quer
FROM 
	row_query
WHERE
	row_quer =2; 
	
-- Challenge 5
-- Write a query that shows each employee's salary and the salary of the person ranked just below them in the company (ordered by salary descending). Call it next_lower_salary.

SELECT
	first_name,
	salary,
	LAG(salary, 1) OVER(ORDER BY salary DESC) AS next_lower_salary,
	office_id
FROM 
	employees;

SELECT 
	first_name,
	salary,
	LEAD(salary,1) OVER(ORDER BY salary DESC) AS next_higher_salary,
	office_id
FROM 
	employees

-- Challege 6
-- Write a query showing each employee's first name, salary, and a running total of salary ordered by salary ascending. Call it running_total.

SELECT
	first_name,
	salary,
	SUM(salary) OVER(ORDER BY salary DESC) AS running_total
FROM employees;

WITH
	windowed_office as(
		SELECT 
			first_name,
			salary,
			office_id,
			ROW_NUMBER() OVER(PARTITION BY office_id ORDER BY salary DESC) AS row_numbering,
			ROUND(AVG(salary) OVER(PARTITION BY office_id),2) AS office_avg
		FROM employees
	)

SELECT
	office_id,
	first_name AS top_earner,
	salary,
	office_avg as avg_salary,
	salary - office_avg as salary_gap,
	SUM(office_avg) OVER(ORDER BY office_avg DESC) AS running_total
FROM windowed_office
WHERE 
	row_numbering = 1

