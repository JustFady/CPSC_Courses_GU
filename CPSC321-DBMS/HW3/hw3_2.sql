/*======================================================================
 *
 *  NAME:    Fady Youssef
 *  ASSIGN:  HW-3, Part 2
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Ten queries using basic SELECT, WHERE, and JOIN.
 *
 *======================================================================*/

------------------------------ QUERIES ------------------------------

-- Q1: provinces under 40k area in countries with inflation over 5
SELECT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM province p, country c
WHERE p.country_code = c.country_code  -- link provinces to their country
  AND p.area < 40000                   -- small provinces only
  AND c.inflation > 5.0                -- higher inflation countries
ORDER BY c.inflation DESC, c.country_code ASC, p.area ASC;

-- Q2: same as Q1 but using JOIN
SELECT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM province p
         JOIN country c ON p.country_code = c.country_code  -- explicit join instead of comma
WHERE p.area < 40000
  AND c.inflation > 5.0
ORDER BY c.inflation DESC, c.country_code ASC, p.area ASC;

-- Q3: provinces that have at least one city over 500k
SELECT DISTINCT co.country_code, co.country_name, p.province_name, p.area
FROM country co
         JOIN province p ON co.country_code = p.country_code
         JOIN city ci ON ci.country_code = p.country_code AND ci.province_name = p.province_name
WHERE ci.population > 500000;  -- check if any city crosses the cutoff

-- Q4: same as Q3 but also show how many big cities are in each province
SELECT co.country_code, co.country_name, p.province_name, COUNT(ci.city_name) AS big_cities
FROM country co
         JOIN province p ON co.country_code = p.country_code
         JOIN city ci ON ci.country_code = p.country_code AND ci.province_name = p.province_name
WHERE ci.population > 500000
GROUP BY co.country_code, co.country_name, p.province_name; -- group so COUNT works

-- Q5: provinces that have at least two cities over 500k
SELECT co.country_code, co.country_name, p.province_name
FROM country co
         JOIN province p ON co.country_code = p.country_code
         JOIN city ci ON ci.country_code = p.country_code AND ci.province_name = p.province_name
WHERE ci.population > 500000
GROUP BY co.country_code, co.country_name, p.province_name
HAVING COUNT(ci.city_name) >= 2;  -- only provinces with 2+ big cities

-- Q6: largest city in each province
SELECT p.province_name, p.country_code, MAX(ci.population) AS largest_city_pop
FROM province p
         JOIN city ci ON p.province_name = ci.province_name AND p.country_code = ci.country_code
GROUP BY p.province_name, p.country_code;  -- one row per province

-- Q7: pairs of cities from different places that have the same population
SELECT a.city_name AS city1, a.country_code AS c1,
       b.city_name AS city2, b.country_code AS c2,
       a.population
FROM city a
         JOIN city b ON a.population = b.population
WHERE a.city_name < b.city_name;  -- avoids duplicates like (Seattle,Seattle)

-- Q8: countries with high GDP + low inflation that border a low GDP + high inflation neighbor
SELECT DISTINCT c1.country_code, c1.country_name
FROM border b
         JOIN country c1 ON b.country_code_1 = c1.country_code
         JOIN country c2 ON b.country_code_2 = c2.country_code
WHERE c1.gdp > 40000
  AND c1.inflation < 4.0
  AND c2.gdp < 20000
  AND c2.inflation > 5.0;

-- Q9: countries with how many cities they have
SELECT co.country_code, co.country_name, COUNT(ci.city_name) AS num_cities
FROM country co
         JOIN city ci ON co.country_code = ci.country_code
GROUP BY co.country_code, co.country_name;

-- Q10: average population of cities in provinces under 40k area
SELECT p.province_name, p.country_code, AVG(ci.population) AS avg_pop
FROM province p
         JOIN city ci ON p.province_name = ci.province_name AND p.country_code = ci.country_code
WHERE p.area < 40000
GROUP BY p.province_name, p.country_code;  -- one row per province
