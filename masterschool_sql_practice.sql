/* 
Masterschool - SQL practice
Notes & Exercises
Uses Parch and Posy ERD
12/1/22
Ashley Joyner
*/

--1. Get all records (rows) and all attributes (columns) from ‘accounts’ table
SELECT *
FROM accounts;

--2. Gel all records and all attributes from ‘orders’ table
SELECT *
FROM orders;

--3. Get all account_id, occurred_at, and total from ‘orders’ table. Order in ascending order by 
--occurred_at. Order in descending order by total.
SELECT account_id, 
       occurred_at, 
       total
FROM orders
ORDER BY occurred_at, 
       total DESC;

--4. (Advanced) Get all records and all attributes from the ‘orders’ table where ‘occurred_at’ date 
--is after Jan. 01, 2016
SELECT *
FROM orders
WHERE occurred_at > '2016-01-01'; 

--5. (Advanced) Get account_id, occurred_at, total from ‘orders’ table where ‘occurred_at’ date is 
--after Jan.01, 2016, but prior to June 01, 2016, and the ‘total’ is over 200. Order in descending 
--order by ‘occurred_at’.
SELECT  account_id, 
        occurred_at, 
        total
FROM orders
WHERE   occurred_at BETWEEN '2016-01-01' AND '2016-06-01'
        AND total > 200
ORDER BY occurred_at DESC;

--6. From ‘orders’ table display order id, occurred_at and total_amt_usd for the two orders with the 
--highest ‘total_amt_usd’
SELECT  id, 
        occurred_at, 
        total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 2;

--7. Based on ‘orders’ table, show only 10 records in 2016. Do not use ‘>’ or ‘<’ functions.
SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
LIMIT 10;

--8. Based on ‘orders’ table, show the 10 records in 2016 with highest ‘total’ amount.
SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY total DESC
LIMIT 10;

--9. Based on ‘orders’ table, please show top 100 records from May 2016 with Lowest ‘total’ amount.
SELECT *
FROM orders
WHERE occurred_at BETWEEN '2016-05-01' AND '2016-06-01'
ORDER BY total
LIMIT 100;