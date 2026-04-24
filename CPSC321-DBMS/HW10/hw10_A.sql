/*
 Name: Fady Youssef
 Assignment: HW10 Part A
 Course: CPSC 321, Fall 2025
 Desc: Queries 1-4 using Outer Joins, CASE statements, and Window Functions.
 */

/* (1) Find actors who have NOT acted in a 'PG' rated film */
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM film f
         -- grabbing the pg roles first then right joining to actors
         -- this keeps everyone in the list, so if they never did a pg movie the film_id ends up null
         JOIN film_actor fa ON f.film_id = fa.film_id AND f.rating = 'PG'
         RIGHT OUTER JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.film_id IS NULL -- filters out the matches, leaving only non-pg actors
ORDER BY a.actor_id;

/* (2) Categorize films by length using CASE */
SELECT
    film_id,
    rating,
    title,
    length,
    CASE
        WHEN length >= 80 THEN 'feature'
        WHEN length <= 50 THEN 'short'
        WHEN length BETWEEN 51 AND 79 THEN 'featurette'
        END AS type
FROM film
ORDER BY film_id;

/* (3) Rank films by length within each rating category */
SELECT
    film_id,
    title,
    rating,
    length,
    -- used dense_rank instead of rank because I don't want gaps in the numbering if there's a tie
    DENSE_RANK() OVER (PARTITION BY rating ORDER BY length) as rank
FROM film
ORDER BY rating, length;

/* (4) CTE to find updates for Action films */
WITH film_update AS (
    -- need to combine updates from 3 different tables so i union them here first
    SELECT f.film_id, f.title, 'actor' as type, f.last_update
    FROM film f JOIN film_actor fa ON f.film_id = fa.film_id
    UNION
    SELECT f.film_id, f.title, 'category' as type, f.last_update
    FROM film f JOIN film_category fc ON f.film_id = fc.film_id
    UNION
    SELECT f.film_id, f.title, 'inventory' as type, f.last_update
    FROM film f JOIN inventory i ON f.film_id = i.film_id
)
SELECT DISTINCT fu.film_id, fu.title, fu.type, fu.last_update
FROM film_update fu
         JOIN film_category fc ON fu.film_id = fc.film_id
         JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action' -- filtering specifically for action movies
ORDER BY fu.title, fu.last_update;