/* 
Different ways of finding the median in SQL databases
12/1/22
Ashley Joyner
*/

--What is the MEDIAN total_usd spent on all orders?
--example
SELECT *
FROM (SELECT total_amt_usd
   FROM orders
   ORDER BY total_amt_usd
   LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;