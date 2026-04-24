/*
 Name: Fady Youssef
 Assignment: HW8 Part 1
 Course: CPSC 321, Fall 2025
 Desc: Queries for Part 1 using the country/province/city database from HW3.
 */

 /*
 query 1: Find the average and total population for cities
 I decided to define "large area" as anything over 100,000 and "low inflation" as less than 5%.
 */
SELECT
    AVG(ci.population) AS avg_population,
    SUM(ci.population) AS total_population
FROM city ci
    -- joining to check the province area
JOIN province pr ON ci.province_name = pr.province_name AND ci.country_code = pr.country_code
JOIN country co ON pr.country_code = co.country_code
WHERE pr.area > 100000 AND co.inflation < 5;

 /*
 query 2: Calculate the total area for each country.
 This just sums up the area of all provinces associated with that country code.
 */
SELECT country_code, SUM(area ) as total_area
FROM province
GROUP BY country_code; -- grouping by country so the SUM calculates per country, not the whole table

 /*
 query 3: Get the GDP, inflation, and total population for each country.
 I'm using the sum of all city populations to represent the country's total population here.
 */
SELECT co.country_code,
       co.country_name,
       co.gdp,
       co.inflation,
       SUM(ci.population) AS country_population
FROM country co
JOIN city ci ON co.country_code = ci.country_code
GROUP BY co.country_code, co.country_name, co.gdp, co.inflation;

 /*
 query 4: Rank countries by how many cities they have.
 Ordering this from the most cities to the fewest.
 */
SELECT
    co.country_code,
    co.country_name,
    COUNT(ci.city_name) AS num_cities
FROM country co
JOIN city ci on co.country_code = ci.country_code
GROUP BY co.country_code, co.country_name
ORDER BY num_cities DESC;

 /*
 query 5: Complex sort based on city count and GDP.
 I used filters for GDP > 20,000 and total area < 2,000,000.
 I had to use SUM(DISTINCT pr.area) because joining the city table was causing province areas to be counted multiple times.
 */
SELECT
    co.country_code,
    co.gdp,
    SUM(DISTINCT pr.area) AS total_area, -- using DISTINCT so I don't double count province area for every city
    COUNT(ci.city_name) AS num_cities
FROM country co
JOIN province pr ON co.country_code = pr.country_code -- joining province to get the area
JOIN city ci ON pr.province_name = ci.province_name AND pr.country_code = ci.country_code
WHERE co.gdp > 20000 -- filtering countries by GDP before grouping
GROUP BY co.country_code, co.gdp
HAVING SUM(DISTINCT pr.area) < 2000000 -- filtering the calculated total area after grouping
ORDER BY num_cities, co.gdp DESC;