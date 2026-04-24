/*======================================================================
 *
 * NAME:    Fady Youssef
 * ASSIGN:  HW-4, Part 1
 * COURSE:  CPSC 321, Fall 2025
 * DESC:    Views and queries for CIA World Factbook tables.
 *
 *======================================================================*/

-- =============================================================
-- (i) Question: 1
-- (ii) Purpose: Create a single view that combines city and country information.
-- (iii) Assumptions/notes: The DROP VIEW statement lets the script run multiple times without errors.
-- =============================================================
DROP VIEW IF EXISTS country_city CASCADE;

CREATE VIEW country_city AS
SELECT
    c.country_code,
    c.country_name,
    ci.city_name,
    ci.population
FROM
    country c
    JOIN city ci ON c.country_code = ci.country_code;
-- For screenshot:
    SELECT * FROM country_city LIMIT 10;

-- =============================================================
-- (i) Question: 2
-- (ii) Purpose: Find countries that have at least two big cities (population over a certain number).
-- (iii) Assumptions/notes: This query uses the country_city view. The population number can be changed for testing.
-- =============================================================
SELECT
    c.country_code,
    c.country_name,
    c.gdp,
    c.inflation
FROM
    country c
JOIN
    country_city cc ON c.country_code = cc.country_code
WHERE
    cc.population > 500000
GROUP BY
    c.country_code, c.country_name, c.gdp, c.inflation
HAVING
    COUNT(cc.city_name) >= 2
ORDER BY
    c.gdp DESC,
    c.inflation ASC;

-- =============================================================
-- (i) Question: 3
-- (ii) Purpose: Create a view where each border is listed twice, once for each direction (e.g., US-CA and CA-US).
-- (iii) Assumptions/notes: This uses UNION to combine the original borders with the reversed ones.
-- =============================================================
DROP VIEW IF EXISTS border_full;

CREATE VIEW border_full AS
SELECT country_code_1 AS country_code_1, country_code_2 AS country_code_2, border_length
FROM border
UNION
SELECT country_code_2 AS country_code_1, country_code_1 AS country_code_2, border_length
FROM border
;

-- For screenshot:
    SELECT * FROM border_full;

-- =============================================================
-- (i) Question: 4
-- (ii) Purpose: Find rich countries (high GDP, low inflation) that border poor countries (low GDP, high inflation).
-- (iii) Assumptions/notes: This query uses the border_full view. The GDP and inflation numbers can be changed for testing.
-- =============================================================
SELECT DISTINCT
    c.country_code,
    c.country_name
FROM
    country c
WHERE
    c.gdp > 40000            -- <-- HIGH_GDP threshold; change for testing
    AND c.inflation < 4.0    -- <-- LOW_INFLATION threshold; change for testing
    AND EXISTS (
        SELECT 1
        FROM border_full bf
        JOIN country neigh ON bf.country_code_2 = neigh.country_code
        WHERE bf.country_code_1 = c.country_code
          AND neigh.gdp < 20000       -- <-- LOW_GDP threshold; change for testing
          AND neigh.inflation > 5.0   -- <-- HIGH_INFLATION threshold; change for testing
    );

-- =============================================================
-- (i) Question: 5
-- (ii) Purpose: Find the country or countries with the highest inflation.
-- (iii) Assumptions/notes: This method works even if multiple countries are tied for the highest inflation.
-- =============================================================
SELECT
    c.country_code,
    c.country_name,
    c.inflation
FROM
    country c
WHERE
    NOT EXISTS (
        SELECT 1
        FROM country c2
        WHERE c2.inflation > c.inflation
    );

