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

