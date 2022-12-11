/* 
Udacity - SQL Subqueries & Temporary Tables
Notes & Exercises
Uses Parch & Posy ERD
12/5/22
Ashley Joyner
*/

--example
SELECT product_id,
       name,
       price
FROM db.product
Where price > (SELECT AVG(price)
              FROM db.product)

--Subqueries:
--Output: Either a scalar (a single value) or rows that have met a condition. Use Case: Calculate a scalar 
--value to use in a later part of the query (e.g., average price as a filter). Dependencies: Stand 
--independently and be run as complete queries themselves.

--Joins:
--Output: A joint view of multiple tables stitched together using a common “key”. Use Case: Fully stitch 
--tables together and have full flexibility on what to “select” and “filter from”. Dependencies: Cannot 
--stand independently.

--example of a subquery
SELECT channel,
       AVG(event_count) AS avg_event_count
FROM
  (SELECT DATE_TRUNC('day',occurred_at) AS day,
          channel,
          count(*) as event_count
  FROM web_events
  GROUP BY 1,2
  ) sub
GROUP BY 1
ORDER BY 2 DESC

--inline subquery example
SELECT channel,
       AVG(event_count) AS avg_event_count
FROM
  (SELECT DATE_TRUNC('day',occurred_at) AS day,
          channel,
          count(*) as event_count
  FROM web_events
  GROUP BY 1,2
  ) sub
GROUP BY 1
ORDER BY 2 DESC

--Average number of events per day for each channel
SELECT channel, AVG(num_events) AS avg_num_events
FROM(
  SELECT COUNT(*) AS num_events, DATE_TRUNC('day',occurred_at) AS day, channel
FROM web_events
GROUP BY day, channel) sub
GROUP BY channel
ORDER BY avg_num_events DESC;

--Nested subquery example
SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
 (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS min_month
  FROM orders)
ORDER BY occurred_at

--Find average quantity sold for each paper type and the total amount of money from the first month a
--purchase was made
SELECT  AVG(standard_qty) AS avg_std, 
        AVG(gloss_qty) AS avg_gloss, 
        AVG(poster_qty) AS avg_poster, 
        SUM(total_amt_usd) AS total_usd
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = 
  (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS month 
  FROM orders);

--creating views
--example
create view v1
as
select S.id, S.name as Rep_Name, R.name as Region_Name
from sales_reps S
join region R
on S.region_id = R.id
and R.name = 'Northeast';

--example
SELECT t3.id, t3.name, t3.channel, t3.ct
FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
     FROM accounts a
     JOIN web_events we
     On a.id = we.account_id
     GROUP BY a.id, a.name, we.channel) T3
JOIN (SELECT t1.id, t1.name, MAX(ct) max_chan
      FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
            FROM accounts a
            JOIN web_events we
            ON a.id = we.account_id
            GROUP BY a.id, a.name, we.channel) t1
      GROUP BY t1.id, t1.name) t2
ON t2.id = t3.id AND t2.max_chan = t3.ct
ORDER BY t3.id;

--#17
SELECT s.name AS sales_rep, r.name AS region
FROM region r
JOIN sales_reps s
ON s.region_id = r.id;

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
    FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN orders o
        ON o.account_id = a.id
        JOIN region r
        ON r.id = s.region_id
        GROUP BY 1, 2) t1
    GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1,2
    ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

--How many accounts had more total purchases than the account name which has bought the most standard_qty 
--paper throughout their lifetime as a customer?
SELECT COUNT(*)
FROM (SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total 
            FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                  FROM accounts a
                  JOIN orders o
                  ON o.account_id = a.id
                  GROUP BY 1
                  ORDER BY 2 DESC
                  LIMIT 1) inner_tab)
      ) counter_tab;

--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many 
--web_events did they have for each channel?
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
      FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY a.id, a.name
            ORDER BY 3 DESC
            LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;

--What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10) temp;

--What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that 
--spent more per order, on average, than the average of all orders?
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
        FROM orders o)) temp_table;

--WITH example
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC), 
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

--For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH t1 AS (
   SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY r.name), 
t2 AS (
   SELECT MAX(total_amt)
   FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

--How many accounts had more total purchases than the account name which has bought the most standard_qty 
--paper throughout their lifetime as a customer?
WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1), 
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;

--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many 
--web_events did they have for each channel?
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;

--What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;

--What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that 
--spent more per order, on average, than the average of all orders.
WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;

--nested example
SELECT *
FROM students
WHERE student_id
IN (SELECT DISTINCT student_id
    FROM gpa_table
    WHERE gpa>3.5
    );

--inline example
SELECT dept_name,
       max_gpa
FROM department_db x
     (SELECT dept_id
             MAX(gpa) as max_gpa
      FROM students
      GROUP BY dept_id
      )y
WHERE x.dept_id = y.dept_id
ORDER BY dept_name;

--scalar example
SELECT 
   (SELECT MAX(salary) FROM employees_db) AS top_salary,
   employee_name
FROM employees_db;