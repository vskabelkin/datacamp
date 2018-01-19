--- CHAPTER 1 - Introduction to joins

--- INNER JOIN

SELECT * 
FROM cities;

SELECT * 
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

SELECT cities.name AS city, countries.name AS country, region
FROM cities 
INNER JOIN countries 
ON cities.country_code = countries.code;

--- INNER JOIN (2)

SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
FROM countries AS c
INNER JOIN economies AS e
ON c.code = e.code;

-- wrong way
SELECT c.code, c.name, c.region, p.year, p.fertility_rate, e.year, e.unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code;

-- right way
SELECT c.code, c.name, c.region, p.fertility_rate, e.year, e.unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
AND p.year = e.year;

--- Inner join with using

SELECT c.name AS country, continent, l.name AS language, l.official
FROM countries AS c
INNER JOIN languages AS l
USING (code);

--- Self-join

SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code
AND p1.year = p2.year - 5;

SELECT p1.country_code, 
       p1.size AS size2010,
       p2.size AS size2015,
       ((p2.size - p1.size) / p1.size * 100.0) AS growth_perc
FROM populations AS p1
INNER JOIN populations AS p2
ON  p1.country_code = p2.country_code
AND p1.year = p2.year - 5;

--- Case when and then

-- get name, continent, code, and surface area
SELECT name, continent, code, surface_area,
    -- first case
    CASE WHEN surface_area > 2000000
    -- first then
            THEN 'large'
    -- second case
       WHEN surface_area > 350000
       -- second then
            THEN 'medium'
    -- else clause + end
       ELSE 'small' END 
    -- alias resulting field of CASE WHEN
       AS geosize_group
-- from the countries table
FROM countries;

--- Inner challenge

SELECT p.country_code, p.size,
  -- start CASE here with WHEN and THEN
    CASE WHEN size > 50000000
        THEN 'large'
  -- layout other CASE conditions here
    WHEN size > 1000000
        THEN 'medium'
  -- end CASE here with ELSE & END
    ELSE 'small' END
  -- provide the alias of popsize_group to SELECT the new field
    AS popsize_group
-- which table?
FROM populations AS p
-- any conditions to check?
WHERE p.year = 2015;

---

SELECT p.country_code, p.size,
  -- start CASE here with WHEN and THEN
    CASE WHEN size > 50000000
        THEN 'large'
  -- layout other CASE conditions here
    WHEN size > 1000000
        THEN 'medium'
  -- end CASE here with ELSE & END
    ELSE 'small' END
  -- provide the alias of popsize_group to SELECT the new field
    AS popsize_group
-- which table?
INTO pop_plus
FROM populations AS p
-- any conditions to check?
WHERE p.year = 2015;

SELECT *
FROM pop_plus;

---

SELECT p.country_code, p.size,
  -- start CASE here with WHEN and THEN
    CASE WHEN size > 50000000
        THEN 'large'
  -- layout other CASE conditions here
    WHEN size > 1000000
        THEN 'medium'
  -- end CASE here with ELSE & END
    ELSE 'small' END
  -- provide the alias of popsize_group to SELECT the new field
    AS popsize_group
-- which table?
INTO pop_plus
FROM populations AS p
-- any conditions to check?
WHERE p.year = 2015;

SELECT c.name, c.continent, c.geosize_group, p.popsize_group
FROM countries_plus AS c
INNER JOIN pop_plus AS p
ON c.code = p.country_code
ORDER BY geosize_group;

--- CHAPTER 2 - Outer joins and cross joins

--- Left Join

-- get the city name (and alias it), the country code,
-- the country name (and alias it), the region,
-- and the city proper population
SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
-- specify left table
FROM cities AS c1
-- specify right table and type of join
LEFT JOIN countries AS c2
-- how should the tables be matched?
ON c1.country_code = c2.code
-- sort based on descending country code
ORDER BY code DESC;

--- Left join (2)

/*
select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/
SELECT c.name AS country, local_name, l.name AS language, percent
-- countries on the left (alias as c)
FROM countries AS c
-- inner join with languages (as l) on the right
LEFT JOIN languages AS l
-- give fields to match on
ON c.code = l.code
-- sort by descending country name
ORDER BY country DESC;

--- Left join (3)

-- select name, region, and gdp_percapita
SELECT name, region, gdp_percapita
-- countries (alias c) on the left
FROM countries AS c
-- join with economies (alias e)
LEFT JOIN economies AS e
-- match on code fields
ON c.code = e.code
-- focus on 2010 entries
WHERE e.year = 2010;

---

-- select name, region, and gdp_percapita
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- countries (alias c) on the left
FROM countries AS c
-- join with economies (alias e)
LEFT JOIN economies AS e
-- match on code fields
ON c.code = e.code
-- focus on 2010 entries
WHERE e.year = 2010
GROUP BY region;

---

-- select name, region, and gdp_percapita
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- countries (alias c) on the left
FROM countries AS c
-- join with economies (alias e)
LEFT JOIN economies AS e
-- match on code fields
ON c.code = e.code
-- focus on 2010 entries
WHERE e.year = 2010
GROUP BY region
ORDER BY avg_gdp DESC;

--- Right join

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
ON languages.code = countries.code
RIGHT JOIN cities
ON countries.code = cities.country_code
ORDER BY city, language;

--- Full join

SELECT name AS country, code, region, basic_unit
FROM countries
FULL JOIN currencies
USING (code)
WHERE region = 'North America' OR region IS NULL
ORDER BY region;

---

SELECT countries.name, code, languages.name AS language
FROM languages
FULL JOIN countries
USING (CODE)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

---

SELECT country.name AS country, region, language.name AS language,
       cur.basic_unit, cur.frac_unit
FROM countries AS country
FULL JOIN languages AS language
USING (code)
FULL JOIN currencies AS cur
USING (code)
WHERE region LIKE 'M%esia';

--- Cross join

SELECT c.name AS city, l.name AS language
FROM cities AS c
CROSS JOIN languages AS l
WHERE c.name LIKE 'Hyder%';

--- 

SELECT c.name AS city, l.name AS language
FROM cities AS c
INNER JOIN languages AS l
ON c.country_code = l.code
WHERE c.name LIKE 'Hyder%';

---

SELECT co.name AS country, region, p.life_expectancy AS life_exp
FROM countries AS co
LEFT JOIN populations AS p
WHERE p.year = 2010
ORDER BY p.life_expectancy
LIMIT 5;

---

SELECT co.name AS country, region, p.life_expectancy AS life_exp
FROM countries AS co
LEFT JOIN populations AS p
ON co.code = p.country_code
WHERE p.year = 2010
ORDER BY p.life_expectancy
LIMIT 5;

--- CHAPTER 3 - Set theory clauses

--- Union

-- pick specified columns from 2010 table
SELECT *
-- 2010 table will be on top
FROM economies2010
-- which set theory clause?
UNION
-- pick specified columns from 2015 table
SELECT *
-- 2015 table on the bottom
FROM economies2015
-- order accordingly
ORDER BY code, year;

--- 

SELECT country_code
FROM cities
UNION
SELECT code
FROM currencies
ORDER BY country_code;

--- Union all

SELECT code, year
FROM economies
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;

--- Intersect

SELECT code, year
FROM economies
INTERSECT
SELECT country_code, year
FROM populations
ORDER BY code, year;

---

SELECT co.name
FROM countries AS co
INTERSECT
SELECT ci.name
FROM cities AS ci;


--- Except

SELECT city.name
FROM cities AS city
EXCEPT
SELECT country.capital
FROM countries AS country
ORDER BY name;

---

SELECT country.capital
FROM countries AS country
EXCEPT
SELECT city.name
FROM cities AS city
ORDER BY capital;


--- Semi-join

SELECT country.code
FROM countries AS country
WHERE country.region = 'Middle East';

---

SELECT DISTINCT lang.name
FROM languages AS lang
ORDER BY lang.name;

---

SELECT DISTINCT name
FROM languages
WHERE code IN
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
ORDER BY name;

--- Or similiar

SELECT languages.name AS language
FROM languages
INNER JOIN countries
ON languages.code = countries.code
WHERE region = 'Middle East'
ORDER BY language;

--- Anti-join 

SELECT COUNT(*)
FROM countries
WHERE continent = 'Oceania';

---

SELECT c1.code, c1.name, c2.basic_unit AS currency
FROM countries AS c1
INNER JOIN currencies AS c2
USING (code)
WHERE continent = 'Oceania';

---

SELECT c1.code, c1.name
FROM countries AS c1
WHERE c1.continent = 'Oceania'
    AND code NOT IN
    (SELECT code 
    FROM currencies);
	 
---

-- select the city name
SELECT name
-- alias the table where city name resides
FROM cities AS c1
-- choose only records matching the result of multiple set theory clauses
WHERE country_code IN
(
    -- select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- get all additional (unique) values of the field from currencies AS c2  
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);

--- CHAPTER 4 - Subqueries

--- Subquery inside where

SELECT AVG(life_expectancy)
FROM populations
WHERE year = 2015;

--- 

SELECT *
FROM populations
WHERE life_expectancy > 1.15 *
    (SELECT AVG(life_expectancy)
    FROM populations
    WHERE year = 2015)
    AND year = 2015;
	
---

-- select the appropriate fields
SELECT city.name, city.country_code, city.urbanarea_pop
-- from the cities table
FROM cities AS city
-- with city name in the field of capital cities
WHERE city.name IN
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;

--- Subquery inside select

SELECT countries.name AS country, COUNT(*) AS cities_num
FROM cities
INNER JOIN countries
ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;

--- Same as

SELECT countries.name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

--- Subquery inside from

SELECT code, COUNT(name) AS lang_num
FROM languages
GROUP BY code;

---

SELECT local_name, subquery.lang_num
FROM countries, 
    (SELECT code, COUNT(name) AS lang_num
    FROM languages
    GROUP BY code) as subquery
WHERE countries.code = subquery.code
ORDER BY lang_num DESC;

--- Advanced subquery

SELECT name, continent, inflation_rate
FROM countries 
INNER JOIN economies
USING (code)
WHERE year = 2015;

---

SELECT MAX(inflation_rate) AS max_inf
  FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING (code)
      WHERE year = 2015) AS subquery
GROUP BY continent;

---

SELECT name, continent, inflation_rate
FROM countries
INNER JOIN economies
ON countries.code = economies.code
WHERE year = 2015
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
        GROUP BY continent);
		
---

SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 AND code NOT IN
  (SELECT code
   FROM countries
   WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic'))
ORDER BY inflation_rate;

--- Final challenges

SELECT DISTINCT c.name, e.total_investment, e.imports
FROM countries AS c
LEFT JOIN economies AS e
ON (c.code = e.code AND c.code IN 
    (SELECT code 
    FROM languages
    WHERE official = 'true'))
WHERE year = 2015 AND region = 'Central America'
ORDER BY c.name;

---

-- choose fields
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
-- left table
FROM countries
-- right table
INNER JOIN populations
-- join conditions
ON countries.code = populations.country_code
-- specific records matching a condition
WHERE year = 2015
-- aggregated for each what?
GROUP BY region, continent
-- how should we sort?
ORDER BY avg_fert_rate;

---

SELECT name, country_code, city_proper_pop, metroarea_pop,  
      city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
WHERE name IN
  (SELECT capital
   FROM countries
   WHERE (continent = 'Europe'
      OR continent LIKE '%America'))
     AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;





 
