/* 
Datacamp - SQL for Joining Data
Notes & Exercises
Uses several different datasets
12/9/22
Ashley Joyner
*/

--Using INNER JOIN
-- Select name fields (with alias) and region 
SELECT cities.name AS city, countries.name AS country, countries.region
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on the country codes
ON cities.country_code = countries.code;

-- Select fields with aliases
SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
FROM countries AS c
-- Join to economies (alias e)
INNER JOIN economies AS e
-- Match on code
ON c.code = e.code;

-- Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
-- From countries (alias as c)
FROM countries AS c
-- Join to populations (as p)
INNER JOIN populations AS p
-- Match on country code
ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e
-- Match on country code and year
ON c.code = e.code AND e.year = p.year;

-- Select fields
SELECT countries.name AS country, continent, languages.name AS language, official
-- From countries (alias as c)
FROM countries
-- Join to languages (as l)
INNER JOIN languages
-- Match using code
ON countries.code = languages.code;

--Self-ish JOIN
-- Select fields with aliases
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- Calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- From populations (alias as p1)
FROM populations AS p1
-- Join to itself (alias as p2)
INNER JOIN populations AS p2
-- Match on country code
ON p1.country_code = p2.country_code
    -- and year (with calculation)
    AND p1.year = p2.year - 5;

--WHEN/ELSE
SELECT name, continent, code, surface_area,
    -- First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- Else clause + end
        ELSE 'small' END
        -- Alias name
        AS geosize_group
-- From table
FROM countries;

--INTO table
SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;
--new query using pop_plus
-- Select fields
SELECT name, continent, geosize_group, popsize_group
-- From countries_plus (alias as c)
FROM countries_plus AS c
-- Join to pop_plus (alias as p)
JOIN pop_plus AS p
-- Match on country code
ON c.code = p.country_code
-- Order the table    
ORDER BY geosize_group;

--LEFT JOIN
SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
FROM cities AS c1
  -- Join right table (with alias)
  LEFT JOIN countries AS c2
    -- Match on country code
    ON c1.country_code = c2.code
-- Order by descending country code
ORDER BY code DESC;

/*
Select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/
SELECT c.name AS country, local_name, l.name AS language, percent
-- From left table (alias as c)
FROM countries AS c
  -- Join to right table (alias as l)
  LEFT JOIN languages AS l
    -- Match on fields
    ON c.code = l.code
-- Order by descending country
ORDER BY country DESC;

-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
-- Left join with economies (alias as e)
LEFT JOIN economies AS e
-- Match on code fields
ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC;

-- convert this code to use RIGHT JOINs instead of LEFT JOINs
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
  LEFT JOIN countries
    ON cities.country_code = countries.code
  LEFT JOIN languages
    ON countries.code = languages.code
ORDER BY city, language;
*/
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON countries.code = languages.code
  RIGHT JOIN cities
    ON cities.country_code = countries.code
ORDER BY city, language;

--USING
--FULL JOIN
/*
SELECT name AS country, code, region, basic_unit
-- From countries
FROM countries
-- Join to currencies
FULL JOIN currencies
-- Match on code
USING (code)
-- Where region is North America or null
WHERE region = 'North America' OR region IS NULL
-- Order by region
ORDER BY region;
*/

SELECT countries.name, code, languages.name AS language
-- From languages
FROM languages
  -- Join to countries
  INNER JOIN countries
    -- Match using code
    USING (code)
-- Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
-- Order by ascending countries.name
ORDER BY countries.name;

-- Select fields (with aliases)
SELECT c1.name AS country, region, l.name AS language,
       basic_unit, frac_unit
-- From countries (alias as c1)
FROM countries AS c1
  -- Join with languages (alias as l)
  FULL JOIN languages AS l
    -- Match on code
    USING (code)
  -- Join with currencies (alias as c2)
  FULL JOIN currencies AS c2
    -- Match on code
    USING (code)
-- Where region like Melanesia and Micronesia
WHERE c1.region LIKE 'M%nesia';

-- Select fields
SELECT c.name AS city, l.name AS language
-- From cities (alias as c)
FROM cities AS c  
  -- Join to languages (alias as l)
  INNER JOIN languages AS l
    -- Match on country code
    ON c.country_code = l.code
-- Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';

-- Select fields
SELECT c.name AS country, region, life_expectancy AS life_exp
-- From countries (alias as c)
FROM countries AS c
  -- Join to populations (alias as p)
  LEFT JOIN populations AS p
    -- Match on country code
    ON p.country_code = c.code
-- Focus on 2010
WHERE year = 2010
-- Order by life_exp
ORDER BY life_exp
-- Limit to 5 records
LIMIT 5;

--UNION
-- Select fields from 2010 table
SELECT *
-- From 2010 table
FROM economies2010
-- Set theory clause
UNION
-- Select fields from 2015 table
SELECT *
-- From 2015 table
FROM economies2015
-- Order by code and year
ORDER BY code, year;

-- Select field
SELECT cities.country_code AS country_code
-- From cities
FROM cities
-- Set theory clause
UNION
-- Select field
SELECT currencies.code
-- From currencies
FROM currencies
-- Order by country_code
ORDER BY country_code;

-- Select fields
SELECT economies.code, economies.year
-- From economies
FROM economies
-- Set theory clause
UNION ALL
-- Select fields
SELECT populations.country_code, populations.year
-- From populations
FROM populations
-- Order by code, year
ORDER BY code, year;


--INTERSECT
-- Select fields
SELECT economies.code, economies.year
-- From economies
FROM economies
-- Set theory clause
INTERSECT
-- Select fields
SELECT populations.country_code, populations.year
-- From populations
FROM populations
-- Order by code and year
ORDER BY code, year;

--which countries also have a city with the same name as their country name?
-- Select fields
SELECT countries.name
-- From countries
FROM countries
-- Set theory clause
INTERSECT
-- Select fields
SELECT cities.name
-- From cities
FROM cities;

--EXCEPT
-- Select field
SELECT cities.name
-- From cities
FROM cities
-- Set theory clause
EXCEPT
-- Select field
SELECT countries.capital
-- From countries
FROM countries
-- Order by result
ORDER BY name;

-- Select field
SELECT countries.capital
-- From countries
FROM countries
-- Set theory clause
EXCEPT
-- Select field
SELECT cities.name
-- From cities
FROM cities
-- Order by ascending capital
ORDER BY capital;

--Semi-joins
-- Query from step 2
SELECT DISTINCT name
FROM languages
-- Where in statement
WHERE code IN
  -- Query from step 1
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;

-- Select fields
SELECT *
-- From Countries
FROM countries
-- Where continent is Oceania
WHERE continent = 'Oceania'
	-- And code not in
	AND code NOT IN
	-- Subquery
	(SELECT code
	 FROM currencies);

-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2  
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);

--subqueries
-- Select fields
SELECT *
-- From populations
FROM populations
-- Where life_expectancy is greater than
WHERE life_expectancy > 1.15 *
  -- 1.15 * subquery
  -- Select average life_expectancy
  (SELECT AVG(life_expectancy)
  -- From populations
  FROM populations
  -- Where year is 2015
  WHERE year = 2015)
AND year = 2015;

-- Select fields
SELECT cities.name, country_code, urbanarea_pop
-- From cities
FROM cities 
-- Where city name in the field of capital cities
WHERE cities.name IN
  -- Subquery
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;

SELECT countries.name AS country,
  -- Subquery
  (SELECT  COUNT(*) AS cities_num
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

-- Select fields
SELECT local_name, t.lang_num
-- From countries
FROM countries,
	-- Subquery (alias as subquery)
	(SELECT code, COUNT(*) AS lang_num
	 FROM languages
	 GROUP BY code) AS t
-- Where codes match
WHERE countries.code = t.code
-- Order by descending number of languages
ORDER BY lang_num DESC;

-- Select fields
SELECT name, continent, inflation_rate
-- From countries
FROM countries
-- Join to economies
INNER JOIN economies
-- Match on code
USING(code)
-- Where year is 2015
WHERE year = 2015
  -- And inflation rate in subquery (alias as subquery)
  AND inflation_rate IN (
    SELECT MAX(inflation_rate) AS max_inf
    FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING(code)
      WHERE year = 2015) AS subquery
  -- Group by continent
  GROUP BY continent);

-- Select fields
SELECT code, inflation_rate, unemployment_rate
-- From economies
FROM economies
-- Where year is 2015 and code is not in
WHERE year = 2015 AND code NOT IN
	-- Subquery
	(SELECT code
	 FROM countries
	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;

-- Select fields
SELECT DISTINCT name, total_investment, imports
  -- From table (with alias)
  FROM countries AS c
    -- Join with table (with alias)
    LEFT JOIN economies AS e
      -- Match on code
      ON (c.code = e.code
      -- and code in Subquery
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ) )
  -- Where region and year are correct
  WHERE region = 'Central America' AND year = 2015
-- Order by field
ORDER BY name;

-- Select fields
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
  -- From left table
  FROM populations AS p
    -- Join to right table
    INNER JOIN countries AS c
      -- Match on join condition
      ON p.country_code = c.code
  -- Where specific records matching some condition
  WHERE year = 2015
-- Group appropriately
GROUP BY region, continent
-- Order appropriately
ORDER BY avg_fert_rate;

-- Select fields
SELECT name, country_code, city_proper_pop, metroarea_pop,  
      -- Calculate city_perc
      city_proper_pop / metroarea_pop * 100 AS city_perc
  -- From appropriate table
  FROM cities
  -- Where 
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America%'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;