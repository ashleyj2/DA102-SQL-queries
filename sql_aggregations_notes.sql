/* 
Udacity - SQL Aggregations
Notes & Exercises
Uses Parch and Posy ERD
11/29/22
Ashley Joyner
*/

--COUNT 
--examples
SELECT COUNT (*) AS account_count
FROM accounts;

SELECT COUNT (id) AS account_id_count
FROM accounts;

SELECT COUNT(primary_poc) AS account_primary_poc_count
FROM accounts;

SELECT *
FROM accounts
WHERE primary_poc IS NULL;

--SUM
--example
SELECT SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders;

--Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM (poster_qty) as poster_total
FROM orders;

--Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM (standard_qty) as standard_total
FROM orders;

--Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM (total_amt_usd) as total_amount
FROM orders;

--Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
--This should give a dollar amount for each order in the table.
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

--Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both aggregation and a 
--mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

--MIN and MAX
--example
SELECT MIN(standard_qty) AS standard_min,
       MIN(gloss_qty) AS gloss_min,
       MIN(poster_qty) AS poster_min,
       MAX(standard_qty) AS standard_max,
       MAX(gloss_qty) AS gloss_max,
       MAX(poster_qty) AS poster_max
FROM   orders;

--AVERAGE
--example
SELECT AVG(standard_qty) AS standard_avg,
       AVG(gloss_qty) AS gloss_avg,
       AVG(poster_qty) AS poster_avg
FROM orders;

--When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) AS earliest_order
FROM orders;

--Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at AS earliest_order
FROM orders
ORDER BY occurred_at
LIMIT 1;

--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) AS latest_event_time
FROM web_events;

--Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at AS latest_event_time
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of 
--each paper type purchased per order. Your final answer should have 6 values - one for each paper 
--type for the average number of sales, as well as the average amount.
SELECT AVG(standard_amt_usd) AS avg_std_usd,
		 AVG(gloss_amt_usd) AS avg_gloss_usd,
       AVG(poster_amt_usd) AS avg_poster_usd,
       AVG(standard_qty) AS avg_std_qty,
       AVG(gloss_qty) AS avg_gloss_qty,
       AVG(poster_qty) AS avg_poster_qty
FROM orders;

--What is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
   FROM orders
   ORDER BY total_amt_usd
   LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

--GROUP BY
--example
SELECT account_id,
       SUM(standard_qty) AS standard,
       SUM(gloss_qty) AS gloss,
       SUM(poster_qty) AS poster
FROM orders
GROUP BY account_id
ORDER BY account_id;

--Which account (by name) placed the earliest order? Your solution should have the account name and the date 
--of the order. 
SELECT a.name, 
		 o.occurred_at
FROM orders o
JOIN accounts a
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

--Find the total sales in usd for each account. You should include two columns - the total sales for each 
--company's orders in usd and the company name.
SELECT a.name, 
		 SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

--Via what channel did the most recent (latest) web_event occur, which account was associated with this 
--web_event? Your query should return only three values - the date, channel, and account name.
SELECT a.name, 
       w.occurred_at,
       w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

--Find the total number of times each type of channel from the web_events was used. Your final table should 
--have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel;

--Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--What was the smallest order placed by each account in terms of total usd. Provide only two columns - the 
--account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, 
		 MIN (o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

--Find the number of sales reps in each region. Your final table should have two columns - the region and 
--the number of sales_reps. Order from the fewest reps to most reps.
SELECT r.name, 
       COUNT(s.name) count_sales_reps
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
ORDER BY count_sales_reps;

--Using multpile columns in GROUP BY
SELECT account_id,
       channel,
       COUNT(id) as events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, channel

--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one for the average quantity purchased 
--for each of the paper types for each account.
SELECT a.name,
       AVG(o.standard_qty) avg_std,
       AVG(o.gloss_qty) avg_gloss,
       AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

--For each account, determine the average amount spent per order on each paper type. Your result should have 
--four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name,
       AVG(o.standard_amt_usd) avg_std,
       AVG(o.gloss_amt_usd) avg_gloss, 
       AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number of 
--occurrences. Order your table with the highest number of occurrences first.
SELECT s.name,
       w.channel, 
       COUNT(w.channel) amt_visits
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY amt_visits DESC;

--Determine the number of times a particular channel was used in the web_events table for each region. Your 
--final table should have three columns - the region name, the channel, and the number of occurrences. Order 
--your table with the highest number of occurrences first.
SELECT r.name,
       w.channel, 
       COUNT(w.channel) amt_visits
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY amt_visits DESC;

--DISTINCT
--example
SELECT DISTINCT account_id, channel
FROM web_events
ORDER BY account_id;

--Use DISTINCT to test if there are any accounts associated with more than one region.
--BOTH return the same number of rows so every account is only associated with one region
SELECT a.id AS "account id",
       r.id AS "region id", 
       a.name AS "account name", 
       r.name AS "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;

--Have any sales reps worked on more than one account?
SELECT s.id,
       s.name, 
       COUNT(*) num_acts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_acts;

SELECT DISTINCT id, name
FROM sales_reps;

--HAVING
--example
SELECT account_id,
       SUM(total_amt_usd) AS sum_total_amt_usd
FROM orders
GROUP BY account_id
HAVING SUM(total_amt_usd) >= 250000;

--How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id,
       s.name, 
       COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

--How many accounts have more than 20 orders?
SELECT a.id,
       a.name, 
       COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20;

--Which account has the most orders?
SELECT a.id,
       a.name, 
       COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

--Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id,
       a.name, 
       SUM(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000;

--Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id,
       a.name, 
       SUM(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000;

--Which account has spent the most with us?
SELECT a.id, 
       a.name, 
       SUM(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_usd DESC
LIMIT 1;

--Which account has spent the least with us?
SELECT a.id, 
       a.name, 
       SUM(o.total_amt_usd) total_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_usd
LIMIT 1;

--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id,
       a.name, 
       w.channel, 
       COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 
       AND w.channel = 'facebook';

--Which account used facebook most as a channel?
SELECT a.id,
       a.name, 
       w.channel, 
       COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY use_of_channel DESC
LIMIT 1;

--Which channel was most frequently used by most accounts?
SELECT a.id,
       a.name, 
       w.channel, 
       COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 5;

--DATES (DATE_TRUNC and DATE_PART)
--example
SELECT DATE_PART('dow',occurred_at) AS day_of_week,
       SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2

--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
--Do you notice any trends in the yearly sales totals?
--totals increase each year until 2017 where there is a significant decrease
SELECT DATE_PART('year', occurred_at) order_year,
       SUM(total_amt_usd) total_year
FROM orders
GROUP BY order_year;

--Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly 
--represented by the dataset?
--2013 and 2017 data has been removed as it was discovered in the previous query that those years did not
--report a full 12 months of data
SELECT DATE_PART('month', occurred_at) order_month,
       SUM(total_amt_usd) total_month
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY order_month
ORDER BY total_month;

--Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years 
--evenly represented by the dataset?
--Significantly less orders in 2013 and 2017 compared to other years. There is a steady increase between
--2014-2016
SELECT DATE_PART('year', occurred_at) order_year,
       COUNT(*) total_sales
FROM orders
GROUP BY order_year
ORDER BY order_year;

--Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all 
--months evenly represented by the dataset?
--again removed outlying years 2013 and 2017. Sales increase throughout the year
SELECT DATE_PART('month', occurred_at) order_month,
       COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY order_month
ORDER BY order_month;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at) order_date,
       SUM(o.gloss_amt_usd) total_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY order_date
ORDER BY total_spent DESC
LIMIT 1;

--CASE
--examples
SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at

SELECT account_id,
       occurred_at,
       total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <=300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

SELECT CASE WHEN total > 500 THEN 'OVer 500'
            ELSE '500 or under' END AS total_group,
            COUNT(*) AS order_count
FROM orders
GROUP BY 1

--Write a query to display for each order, the account ID, the total amount of the order, and the level of 
--the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT a.id, 
       SUM(o.total_amt_usd) total_amt, 
	CASE WHEN SUM(o.total_amt_usd) >= 3000 THEN 'Large' 
       ELSE 'Small' END AS size
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id;

--Write a query to display the number of orders in each of three categories, based on the total number of 
--items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000' 
       WHEN total <2000 AND total >=1000 THEN 'Between 1000 and 2000' 
       ELSE 'Less than 1000' END AS order_category,
       COUNT(*) order_count
FROM orders
GROUP BY order_category;

--We would like to understand 3 different levels of customers based on the amount associated with their 
--purchases. The top-level includes anyone with a Lifetime Value (total sales of all orders) greater than 
--200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 
--usd. Provide a table that includes the level associated with each account. You should provide the account 
--name, the total sales of all orders for the customer, and the level. Order with the top spending customers 
--listed first.
SELECT a.name, 
       SUM(total_amt_usd) total_spent, 
       CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
       WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
       ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY total_spent DESC;

--We would now like to perform a similar calculation to the first, but we want to obtain the total amount 
--spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the 
--top spending customers listed first.
SELECT a.name, 
       SUM(total_amt_usd) total_spent, 
       CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
       WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
       ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at > '2015-12-31' 
GROUP BY a.name
ORDER BY total_spent DESC;

