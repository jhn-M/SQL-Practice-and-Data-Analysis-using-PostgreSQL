SELECT current_database();

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

SELECT table_name, table_schema
FROM information_schema.tables
WHERE table_name IN ('employees', 'offices');

SELECT inet_server_port();

SELECT oid, datname FROM pg_database;

SELECT schemaname, tablename 
FROM pg_catalog.pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema');

SELECT oid, datname FROM pg_database WHERE datname = 'sql_hr';

CREATE TABLE offices (
    office_id INT PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    salary INT NOT NULL,
    reports_to INT REFERENCES employees(employee_id),
    office_id INT REFERENCES offices(office_id)
);

INSERT INTO offices VALUES (1,'03 Reinke Trail','Cincinnati','OH');
INSERT INTO offices VALUES (2,'5507 Becker Terrace','New York City','NY');
INSERT INTO offices VALUES (3,'54 Northland Court','Richmond','VA');
INSERT INTO offices VALUES (4,'08 South Crossing','Cincinnati','OH');
INSERT INTO offices VALUES (5,'553 Maple Drive','Minneapolis','MN');
INSERT INTO offices VALUES (6,'23 North Plaza','Aurora','CO');
INSERT INTO offices VALUES (7,'9658 Wayridge Court','Boise','ID');
INSERT INTO offices VALUES (8,'9 Grayhawk Trail','New York City','NY');
INSERT INTO offices VALUES (9,'16862 Westend Hill','Knoxville','TN');
INSERT INTO offices VALUES (10,'4 Bluestem Parkway','Savannah','GA');
INSERT INTO employees VALUES (37270,'Yovonnda','Magrannell','Executive Secretary',63996,NULL,10);
INSERT INTO employees VALUES (33391,'D''arcy','Nortunen','Account Executive',62871,37270,1);
INSERT INTO employees VALUES (37851,'Sayer','Matterson','Statistician III',98926,37270,1);
INSERT INTO employees VALUES (40448,'Mindy','Crissil','Staff Scientist',94860,37270,1);
INSERT INTO employees VALUES (56274,'Keriann','Alloisi','VP Marketing',110150,37270,1);
INSERT INTO employees VALUES (63196,'Alaster','Scutchin','Assistant Professor',32179,37270,2);
INSERT INTO employees VALUES (67009,'North','de Clerc','VP Product Management',114257,37270,2);
INSERT INTO employees VALUES (67370,'Elladine','Rising','Social Worker',96767,37270,2);
INSERT INTO employees VALUES (68249,'Nisse','Voysey','Financial Advisor',52832,37270,2);
INSERT INTO employees VALUES (72540,'Guthrey','Iacopetti','Office Assistant I',117690,37270,3);
INSERT INTO employees VALUES (72913,'Kass','Hefferan','Computer Systems Analyst IV',96401,37270,3);
INSERT INTO employees VALUES (75900,'Virge','Goodrum','Information Systems Manager',54578,37270,3);
INSERT INTO employees VALUES (76196,'Mirilla','Janowski','Cost Accountant',119241,37270,3);
INSERT INTO employees VALUES (80529,'Lynde','Aronson','Junior Executive',77182,37270,4);
INSERT INTO employees VALUES (80679,'Mildrid','Sokale','Geologist II',67987,37270,4);
INSERT INTO employees VALUES (84791,'Hazel','Tarbert','General Manager',93760,37270,4);
INSERT INTO employees VALUES (95213,'Cole','Kesterton','Pharmacist',86119,37270,4);
INSERT INTO employees VALUES (96513,'Theresa','Binney','Food Chemist',47354,37270,5);
INSERT INTO employees VALUES (98374,'Estrellita','Daleman','Staff Accountant IV',70187,37270,5);
INSERT INTO employees VALUES (115357,'Ivy','Fearey','Structural Engineer',92710,37270,5);

SELECT * FROM employees;
SELECT * FROM offices;

