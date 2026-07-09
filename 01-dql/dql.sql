
-- show the definitions for the columns in a table
DESCRIBE employees;

-- Get all the rows and all the columns from a given table
SELECT * FROM customers;

-- Show only the firstName, lastName, email and employeeNumber columns from the employees table
SELECT employeeNumber, firstName, lastName, email FROM employees;

-- in general,
-- SELECT <col_1, col_2,....col_n> FORM <table_name>

-- Select column and rename them
SELECT lastName AS "Last Name", firstName AS "First Name", email AS "Email" FROM employees;

-- select the customerName, contactLastName, contactFirstName and phone
-- but rename them to proper English, eg: "Customer Name"
SELECT customerName AS "Customer Name", 
       contactLastName AS "Contact Last Name",
	   contactFirstName as "Contact First Name",
	   phone AS "Phone"
FROM customers;

-- CONCAT function can combine two columns into  one
SELECT employeeNumber, CONCAT(firstName, " ", lastName) AS "Full Name" FROM employees

-- UCASE can convert the column to uppercase
SELECT employeeNumber, CONCAT(firstName, " ", lastName) AS "Full Name", UCASE(email) FROM employees

-- only show employees from officeCode 1
SELECT * FROM employees WHERE officeCode=1

-- only show employees from officeCode 1
SELECT lastName AS "Last Name", firstName AS "First Name",
      email AS "Email", officeCode AS "Office Code" FROM employees WHERE officeCode=1

-- string comparison in SQL is case in-sensitive
select * from employees WHERE jobTitle="sales rep";
SELECT * FROM employees WHERE jobTitle LIKE "sales rep";

-- we can use LIKE with string patterns
-- the % is a placeholder (i.e a wildcard). It can match anything
-- Get all the sales manager
SELECT * FROM employees WHERE jobTitle LIKE "Sale% Manager%"

-- get all the employees with the word "sales" in their job title
SELECT * FROM employees WHERE jobTitle LIKE "%Sale%"

-- comparison operators work as in a programming language
select * from customers WHERE creditLimit > 0;

-- combining inequality with logical
-- find all customers which creditLimit is between 10K to 50K
SELECT * FROM customers
WHERE creditLimit >= 10000 AND creditLimit < 50000;

-- alternatively...
SELECT * FROM customers
WHERE creditLimit BETWEEN 10000 AND 50000;

-- Logical operators
-- AND / OR

-- select all the sales rep from office code 1
SELECT * FROM employees WHERE officeCode=1 AND jobTitle="sales rep";

-- Get only the unique values
SELECT DISTINCT(status) FROM orders;

-- Get all the orders that have been shipped or cancelled
SELECT * FROM orders WHERE status="Shipped" OR status="Cancelled";

-- when mixing AND / OR together, the order of precedence is important
-- the following actually select ALL employees from office code 1 and ONLY sales rep from office code 2.
select * from employees WHERE officeCode = 1 OR officeCode = 2 AND jobTitle = "Sales Rep";

-- when mixing AND / OR together, the order of precedence is important
-- the following actually select ALL employees from office code 1 and ONLY sales rep from office code 2.
select * from employees WHERE (officeCode = 1 OR officeCode = 2) AND jobTitle = "Sales Rep";

-- Sort tables

-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit;

-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit DESC;

-- Limit the number of rows returned
-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 10;

-- JOINING TABLES

-- get first name, last name and office address for each employee
-- we have JOIN both tables together first
SELECT firstName, lastName, city, addressLine1, addressLine2, state, country FROM employees JOIN offices
         ON employees.officeCode = offices.officeCode;

-- all other clauses happen on the JOINed table
SELECT firstName, lastName, city, addressLine1, addressLine2, state, country 
         FROM employees JOIN offices
         ON employees.officeCode = offices.officeCode
WHERE country="USA";

-- for columns that are repeated, we need to state which table to take from (eg: offices.officeCode)
SELECT firstName, lastName, email, offices.officeCode, city, addressLine1, addressLine2, state, country 
         FROM employees JOIN offices
         ON employees.officeCode = offices.officeCode
WHERE country="USA";

-- it is possible to give alias to tables when you join them
SELECT firstName, lastName, email, o.officeCode, city, addressLine1, addressLine2, state, country 
         FROM employees AS e JOIN offices AS o
         ON e.officeCode = o.officeCode
WHERE country="USA";


-- When we do a join, for a row on the LHS to appear, it must be joined to a corresponding
-- row on the RHS
SELECT * FROM customers JOIN employees
         ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- the default join is a INNER JOIN
-- there is also the LEFT JOIN and RIGHT JOIN

-- When we do LEFT join, the LHS all ROWS WILL BE IN THE FINAL RESULT
-- even if no counterpart is found in the other table (the below should show 122 because
-- that's the total number of customers)
SELECT COUNT(*) FROM customers LEFT JOIN employees
         ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- 1. identify the tables
-- orders, customers
-- 2. identify the FK and the primary KEY
-- the FK is in the MANY side of the relationship
-- customers and orders are in a 1:M relationship
-- the FK is orders.customerNumber and the PK is customers.customerNumber
SELECT * FROM customers JOIN orders
         ON customers.customerNumber = orders.customerNumber
		 WHERE country = "USA" AND status="Shipped";

-- 1. identify the tables
-- orders, customers
-- 2. identify the FK and the primary KEY
-- the FK is in the MANY side of the relationship
-- customers and orders are in a 1:M relationship
-- the FK is orders.customerNumber and the PK is customers.customerNumber
SELECT customerName, status, orderDate, shippedDate, lastName, firstName FROM customers JOIN orders
        	 ON customers.customerNumber = orders.customerNumber
		 JOIN employees
		     ON customers.salesRepEmployeeNumber = employees.employeeNumber
		 WHERE country = "USA" AND status="Shipped" 
		 ORDER BY orderDate;

-- dates processing in MySQL
-- find all the orders that shipped in the year 2003
SELECT * FROM orders WHERE shippedDate BETWEEN "2003-01-01" AND "2003-12-31";

-- the YEAR, MONTH and DAY functions can extract out the components of a date
SELECT orderDate, YEAR(orderDate), MONTH(orderDate), DAY(orderDate) FROM orders;

-- show all orders that take place in the four first weeks of 2003
SELECT * FROM orders WHERE YEAR(orderDate) = 2003 AND WEEK(orderDate) <=4;

-- AGGREGATE FUNCTIONS
-- 1. COUNT
-- 2. SUM
-- 3. AVG
-- 4. MIN
-- 5. MAX

-- find the highest credit limit among all the customers
SELECT MAX(creditLimit) FROM customers;

-- find the customer with the highest credit limit
-- (using a sub query)
SELECT * FROM customers WHERE creditLimit = (SELECT MAX(creditLimit) FROM customers);

-- find the average price of payments made by customer 103
select avg(amount) from payments where customerNumber = 103;

-- how many employees are there for each office code?
-- we use GROUP BY
select officeCode, count(*) FROM employees
GROUP BY officeCode

-- how many customers are there in each country?
select country, count(*) FROM customers
GROUP BY country;

-- 1. Determine what is the grouping criteria
-- 2. Do the aggregate function in the SELECT
-- 3. Whatever you group by, you must select
SELECT officeCode, count(*) FROM employees GROUP BY officeCode;

-- for each customer, I want to see their TOTAL payment made over the entire lifetime
-- of the database
SELECT customerNumber, SUM(amount) FROM payments
GROUP BY customerNumber

-- for each customer, I want to see their TOTAL payment made over the entire lifetime
-- of the database
SELECT customers.customerNumber, customerName, SUM(amount) FROM payments
  JOIN customers ON 
  	   customers.customerNumber = payments.customerNumber
GROUP BY customers.customerNumber, customerName

-- for each customer, I want to see their TOTAL payment made over the entire lifetime
-- of the database
SELECT customers.customerNumber, customerName, SUM(amount) FROM payments
  JOIN customers ON 
  	   customers.customerNumber = payments.customerNumber
WHERE country = "USA"
GROUP BY customers.customerNumber, customerName
HAVING SUM(amount) >= 40000
ORDER BY SUM(amount) ASC
LIMIT 10;