/* 
Udacity - Basic SQL
Notes & Exercises
Uses Parch and Posy ERD
11/28/22
Ashley Joyner
*/

/*
Terms & Key-words
CREATE TABLE	is a statement that creates a new table in a database.
DROP TABLE	    is a statement that removes a table in a database.
ERD             Entity-relationship diagram - A common way to view data in a database.
FROM	        specifies from which table(s) you want to select the columns. Notice the columns 
                need to exist in this table.
SELECT    	    allows you to read data and display it. This is called a query and it specifies 
                from which table(s) you want to select the columns.
*/

-- LIMITS
--example
SELECT  occurred_at, 
        account_id, 
        channel
FROM web_events
LIMIT 15;

--ORDER BY

--Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, 
--and total_amt_usd.
SELECT  id, 
        occurred_at, 
        otal_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

--Write a query to return the top 5 orders in terms of the largest total_amt_usd. Include the id, 
--account_id, and total_amt_usd.
SELECT  id, 
        account_id, 
        total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

--Write a query to return the lowest 20 orders in terms of the smallest total_amt_usd. Include the 
--id, account_id, and total_amt_usd.
SELECT  id, 
        account_id, 
        total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

--This query selected account_id and total_amt_usd from the orders table, and orders the results 
--first by total_amt_usd in descending order and then account_id.
SELECT  account_id,
        total_amt_usd
FROM orders
ORDER By    total_amt_usd DESC,
            account_id;

--Write a query that displays the order ID, account ID, and total dollar amount for all the orders, 
--sorted first by the account ID (in ascending order), and then by the total dollar amount (in 
--descending order).
SELECT  id, 
        account_id, 
        total_amt_usd
FROM orders
ORDER BY    account_id, 
            total_amt_usd DESC;

--Now write a query that again displays order ID, account ID, and total dollar amount for each 
--order, but this time sorted first by total dollar amount (in descending order), and then by 
--account ID (in ascending order).
SELECT  id, 
        account_id, 
        total_amt_usd
FROM orders
ORDER BY    total_amt_usd DESC,
            account_id;

--WHERE

--Pulls the first 5 rows and all columns from the orders table that have a dollar amount of 
--gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

--Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less 
--than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

--Filter the accounts table to include the company name, website, and the primary point of contact 
--(primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT  name, 
        website, 
        primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

--CREATE NEW COLOMNS AND NAME THEM
--Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for 
--standard paper for each order. Limit the results to the first 10 orders, and include the id and 
--account_id fields.
SELECT  standard_amt_usd/standard_qty AS unit_price, 
        id, 
        account_id
FROM orders
LIMIT 10;

--Write a query that finds the percentage of revenue that comes from poster paper for each order. 
--You will need to use only the columns that end with _usd. (Try to do this without using the total 
--column.) Display the id and account_id fields also. limit to 10
SELECT  poster_amt_usd/(poster_amt_usd + gloss_amt_usd + standard_amt_usd) 
            AS poster_percent_revenue,
        id, 
        account_id
FROM orders
LIMIT 10;

--LIKE

--All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%'; 

--All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%'; 

--All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s'; 

--IN

--Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, 
--Target, and Nordstrom.
SELECT  name, 
        primary_poc, 
        sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

--Use the web_events table to find all information regarding individuals who were contacted via 
--the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

--NOT

--Use the accounts table to find the account name, primary poc, and sales rep id for all stores 
--except Walmart, Target, and Nordstrom.
SELECT  name, 
        primary_poc, 
        sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

--Use the web_events table to find all information regarding individuals who were contacted via 
--any method except using organic or adwords methods.
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

--Use the accounts table to find:
--All the companies whose names do not start with 'C'.
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

--All companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

--All companies whose names do not end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

--AND & BETWEEN

--Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty 
--is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE   standard_qty > 1000 
        AND poster_qty = 0 
        AND gloss_qty = 0;

--Using the accounts table, find all the companies whose names do not start with 'C' 
--and end with 's'.
SELECT name
FROM accounts
WHERE   name NOT LIKE 'C%' 
        AND name LIKE '%s';

--When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, 
--or not? Figure out the answer to this important question by writing a query that displays the 
--order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look 
--at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT *
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

--Use the web_events table to find all information regarding individuals who were contacted via 
--the organic or adwords channels, and started their account at any point in 2016, sorted from 
--newest to oldest.
SELECT *
FROM web_events
WHERE   channel IN ('organic', 'adwords') 
        AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

--OR

--Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include 
--the id field in the resulting table.
SELECT id
FROM orders
WHERE   gloss_qty>4000 
        OR poster_qty>4000;

--Write a query that returns a list of orders where the standard_qty is zero and either the 
--gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE   standard_qty=0 
        AND (gloss_qty>1000 OR poster_qty>1000);

--Find all the company names that start with a 'C' or 'W', and the primary contact contains 
--'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT  name, 
        primary_poc
FROM accounts
WHERE   (name LIKE 'C%' OR name LIKE 'W%') 
        AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
        AND primary_poc NOT LIKE '%eana%');