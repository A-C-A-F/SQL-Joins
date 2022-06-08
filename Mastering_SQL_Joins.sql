##########################################################
##########################################################
-- Project: Mastering SQL Joins in PostgreSQL
##########################################################
##########################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the dept_manager_dup and
-- departments_dup tables in the database
#############################

-- 1.1: Retrieve all data from the dept_manager_dup table
select *
from dept_manager_dup
order by dept_no;

-- 1.2: Retrieve all data from the departments_dup table
SELECT *
FROM departments_dup
ORDER BY dept_no;

#############################
-- Task Two: INNER JOIN
-- In this task, you will retrieve data from the two 
-- tables using INNER JOIN
#############################

-- So, if we perform INNER JOIN, this operation, for example, between departments duplicate table and the department
-- management duplicate table, it returns all the records which have matching values in both of these tables 
-- that will be returned as the output.

##########
-- INNER JOIN

-- If we remember from set theory, when we talked about Venn
-- diagrams, particularly when we talk about intersection
-- of two sets, we say A intersect B and the output
-- of that A intersect B will be those element that exists both
-- in A and both in B. So, imagine INNER JOIN to be like the concept
-- of intersection between two tables. The output of the result set will contain elements in both
-- of the tables. Also INNER JOIN is the area that belongs to both circles, like
-- in a Venn diagram; that middle part of the Venn diagram
-- and it represent the record belonging to both the department
-- manager duplicate table and the departments table.

-- 2.1: Extract all managers' employees number, department number, 
-- and department name. Order by the manager's department number
SELECT m.emp_no, m.dept_no, d.dept_name
FROM dept_manager_dup m -- m is an alias for this table
INNER JOIN departments_dup d -- d is an alias for this table
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;


-- add m.from_date and m.to_date
SELECT m.emp_no, m.dept_no, d.dept_name, m.from_date, m.to_date
FROM dept_manager_dup m -- m is an alias for this table
INNER JOIN departments_dup d -- d is an alias for this table
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- 2.2 (Ex.): Extract a list containing information about all managers'
-- employee number, first and last name, dept_number and hire_date
-- Hint: Use the employees and dept_manager tables

-- Retrieve data from the employees and dept_manager

SELECT * FROM employees;
SELECT * FROM dept_manager;

-- Solution to 2.2
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM employees e -- e is an alias for this table
INNER JOIN dept_manager d -- d is an alias for this table
ON e.emp_no = d.emp_no
ORDER BY e.emp_no;

#############################
-- Task Three: Duplicate Records
-- In this task, you will retrieve data from the two 
-- tables with duplicate records using INNER JOIN
#############################

###########
-- Duplicate Records

-- 3.1: Let us add some duplicate records
-- Insert records into the dept_manager_dup and departments_dup tables respectively

INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

-- 3.2: Select all records from the dept_manager_dup table

SELECT *
FROM dept_manager_dup
ORDER BY dept_no ASC;

-- 3.3: Select all records from the departments_dup table

SELECT *
FROM departments_dup
ORDER BY dept_no ASC;

-- 3.4: Perform INNER JOIN as before
SELECT m.emp_no, m.dept_no, d.dept_name
FROM dept_manager_dup m -- m is an alias for this table
INNER JOIN departments_dup d -- d is an alias for this table
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- We will see the particular record employee number 110228.
-- It's a duplicate record and duplicate records are bad.
-- It gives inaccurate or stale data which can lead to bad
-- reporting, skewed metrics or even poor sender reputation.
-- As much as possible, we want to avoid this. So, how do we deal with duplicate records?
-- We simply add a GROUP BY clause.

-- What GROUP BY clause does is that it groups by like summarizes
-- by a particular field. Ordinarily, we would have grouped by the most
-- distinct column. In this case, which is the employee number but
-- in PostgreSQL, we have to GROUP BY all the fields.

-- 3.5: add a GROUP BY clause. Make sure to include all the fields in the GROUP BY clause
SELECT m.emp_no, m.dept_no, d.dept_name
FROM dept_manager_dup m -- m is an alias for this table
INNER JOIN departments_dup d -- d is an alias for this table
ON m.dept_no = d.dept_no
GROUP BY m.emp_no, m.dept_no, d.dept_name
ORDER BY m.dept_no;


#############################
-- Task Four: LEFT JOIN
-- In this task, you will retrieve data from the two tables using LEFT JOIN
#############################

###########
-- LEFT JOIN

-- A LEFT JOIN or LEFT OUTER JOIN returns
-- all the records on the left table and those records
-- which satisfies a condition from the right table.
-- So, there is a left table, which comes first and there is a right
-- table, which comes second.
-- Any record that does not have a matching value
-- with right table, the output will be null.

-- Imagine in a Venn diagram where you have two circles
-- intersecting at the middle. LEFT JOIN returns
-- that part in the middle and in addition, it returns everything
-- on the left circle or on the left table and wherever there is
-- no matching record with right table, it returns a null value.


-- 4.1: Remove the duplicates from the two tables
-- first, let's remove all duplicate records that we added in the
-- the previous task.

DELETE FROM dept_manager_dup 
WHERE emp_no = '110228';
        
DELETE FROM departments_dup 
WHERE dept_no = 'd009';

-- 4.2: Add back the initial records
INSERT INTO dept_manager_dup 
VALUES 	('110228', 'd003', '1992-03-21', '9999-01-01');
        
INSERT INTO departments_dup 
VALUES	('d009', 'Customer Service');

-- 4.3: Select all records from dept_manager_dup
SELECT *
FROM dept_manager_dup
ORDER BY dept_no;

-- 4.4: Select all records from departments_dup
SELECT *
FROM departments_dup
ORDER BY dept_no;

-- Recall, when we had INNER JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- 4.5: Join the dept_manager_dup and departments_dup tables
-- Extract a subset of all managers' employee number, department number, 
-- and department name. Order by the managers' department number

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d
ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- so it returns all the records on the left table
-- on the department managers duplicate table and where they match 
-- with the right table. Now, we can see there are nulls;
-- these nulls comes as a result of where it doesn't see
-- any record. For example, if you take a clue and go back
-- to the department managers duplicate table, you see that
-- some department numbers does not have the department name, and
-- that is why they have null in this table that we pulled out.

-- Now what if I have a case where I interchange
-- the tables like for INNER JOIN.

-- 4.6: What will happen when we d LEFT JOIN m?
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup d
LEFT JOIN dept_manager_dup m
ON d.dept_no = m.dept_no
ORDER BY m.dept_no;

-- in this case, department duplicates is now the left table and department
-- manager is now the right table. So, by understanding of left
-- table, LEFT JOIN, this takes every record of this left
-- table and matches it with only those parts that matches with the right table.
-- Unlike when we have INNER JOIN. In the INNER JOIN,
-- the order of the table does not matter but in LEFT and RIGHT
-- JOINs, the order of the table really matters. In this case,
-- departments duplicate becomes the left table.
-- So, the result set returns all records of department duplicate
-- table, plus where it match with department managers table.


-- 4.7: Let's select d.dept_no
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup d
LEFT JOIN dept_manager_dup m
ON d.dept_no = m.dept_no
ORDER BY d.dept_no;

-- This also returns 24 rows. This means that it gives the same record.
-- Just that it orders it in a different manner.

-- LEFT OUTER JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup d
LEFT outer JOIN dept_manager_dup m
ON d.dept_no = m.dept_no
ORDER BY d.dept_no;

#############################
-- Task Five: RIGHT JOIN
-- In this task, you will retrieve data from the two tables using RIGHT JOIN
#############################

###########
-- RIGHT JOIN

-- The RIGHT JOIN keyword returns all records of the right
-- table. That is the table two and the matching record
-- from the table one, from the left table.
-- The result is null from the left side when there is no match-
-- like we've seen in what- LEFT JOIN.
-- You see this is just like the opposite of LEFT JOIN.
-- Their functionality is identical to LEFT JOINs, with the
-- only difference being that the opposite of the operation
-- is inverted.
-- This shows that the order of the tables is important.
-- So, whether we run the LEFT JOIN, or the RIGHT JOIN,
-- with an inverted table order, we will obtain the same result.

-- We have seen LEFT JOIN in the previous task

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY dept_no;

-- 5.1: Let's use RIGHT JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m -- in this case, department managers duplicate is my left table,
RIGHT OUTER JOIN departments_dup d -- In this case now, departments duplicate is my right table.
ON m.dept_no = d.dept_no
ORDER BY dept_no;

-- 5.2: SELECT d.dept_no
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m 
RIGHT OUTER JOIN departments_dup d 
ON m.dept_no = d.dept_no
ORDER BY d.dept_no;
--It doesn't change the output, the only thing that changes is just the ordering.

-- 5.3: d LEFT JOIN m
SELECT m.dept_no, m.emp_no, d.dept_name
FROM departments_dup d
LEFT JOIN dept_manager_dup m 
ON m.dept_no = d.dept_no
ORDER BY dept_no;

#############################
-- Task Six: JOIN and WHERE Used Together
-- In this task, you will retrieve data from tables
-- using JOIN and WHERE together
#############################

###########
-- JOIN and WHERE Used Together

-- 6.1: Extract the employee number, first name, last name and salary
-- of all employees who earn above 145000 dollars per year

-- Let us retrieve all data in the salaries table
SELECT * FROM salaries;

-- Solution to 6.1
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
WHERE salary > 145000;


-- 6.2: What do you think will be the output of this query?

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE s.salary > 145000;

-- 6.3 (Ex.): Select the first and last name, the hire date and the salary
-- of all employees whose first name is 'Mario' and last_name is 'Straney'

SELECT e.first_name, e.last_name, e.hire_date, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
WHERE e.first_name = 'Mario' AND e.last_name = 'Straney'
ORDER BY e.emp_no;

-- 6.4: Join the 'employees' and the 'dept_manager' tables to return a subset
-- of all the employees whose last name is 'Markovitch'. 
-- See if the output contains a manager with that name
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
FROM employees e
LEFT JOIN dept_manager dm
ON e.emp_no = dm.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY dm.dept_no, e.emp_no;
-- this returns all employees who have their last name
-- as Markovitch and clearly we can see the different
-- employees. The first employee we see here is a manager. We can now see
-- department, the employee number.

-- 6.5: Join the 'employees' and the 'dept_manager' tables to return a subset
-- of all the employees who were hired before 31st of January, 1985
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
FROM employees e
LEFT JOIN dept_manager dm
ON e.emp_no = dm.emp_no
WHERE e.hire_date < '1985-01-31'
ORDER BY dm.dept_no, e.emp_no;


#############################
-- Task Seven: Using Aggregate Functions with Joins
-- In this task, you will retrieve data from tables in the employees database,
-- using Aggregate Functions with Joins
#############################

###########
-- Using Aggregate Functions with Joins

-- Aggregate functions are applied on multiple rows of a single
-- column of a table and returns an output of a single value.
-- This means that they gather values or data from many rows of
-- a table, then aggregates it into a single value.
-- There are basically five aggregate functions in SQL; COUNT,
-- SUM, MIN, MAX, and average represented by AVG.

-- 7.1: What is the average salary for the different gender?
SELECT e.gender, ROUND(AVG(salary),2) AS average_salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
GROUP BY e.gender;

-- 7.2: What do you think will be the output if we SELECT e.emp_no?
SELECT e.emp_no, e.gender, ROUND(AVG(salary),2) AS average_salary
FROM employees e
JOIN salaries s 
ON e.emp_no = s.emp_no
GROUP BY e.emp_no, e.gender; 

-- 7.3: How many males and how many females managers do we have in
-- employees database?
SELECT e.gender, COUNT(dm.emp_no)
FROM employees e
JOIN dept_manager dm
ON e.emp_no = dm.emp_no
GROUP BY e.gender;


#############################
-- Task Eight: Join more than Two Tables in SQL
-- In this task, you will retrieve data from tables in the employees database,
-- by joining more than two Tables in SQL
#############################

###########
-- Join more than Two Tables in SQL

-- 8.1: Extract a list of all managers' first and last name, dept_no, hire date, to_date,
-- and department name
SELECT e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date, m.to_date, d.dept_name
FROM employees e
JOIN dept_manager m
ON e.emp_no = m.emp_no
JOIN departments d
ON m.dept_no = d.dept_no;


-- 8.2: What do you think will be the output of this?
SELECT e.first_name, e.last_name, m.dept_no, e.hire_date, m.to_date, d.dept_name
FROM departments d
JOIN dept_manager m 
ON d.dept_no = m.dept_no
JOIN employees e 
ON m.emp_no = e.emp_no;
-- only the employee number will not be included.

-- 8.3: Retrieve the average salary for the different departments

-- Retrieve all data from departments table
SELECT * FROM departments

-- Retrieve all data from dept_emp table
SELECT * FROM dept_emp

-- Retrieve all data from salaries table
SELECT * FROM salaries

-- Now the question says we want to retrieve the average salary for
-- the different departments.
-- Now, there is nothing that links salaries and departments. We would
-- have joined department to salaries directly.
-- But if you look at salaries, employee number is one
-- field here.

-- Solution to 8.3
SELECT d.dept_name, AVG(salary) AS average_salary
FROM departments d
JOIN dept_emp de
ON d.dept_no = de.dept_no
JOIN salaries s
ON de.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY AVG(salary) DESC;

-- 8.4 (Ex.): Retrieve the average salary for the different departments where the
-- average_salary is more than 60000
SELECT d.dept_name, AVG(salary) AS average_salary
FROM departments d
JOIN dept_emp de
ON d.dept_no = de.dept_no
JOIN salaries s
ON de.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING AVG(salary) > 60000
ORDER BY AVG(salary) DESC;
