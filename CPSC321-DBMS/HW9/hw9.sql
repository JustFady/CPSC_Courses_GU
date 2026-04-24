/*
 Name: Fady Youssef
 Assignment: HW9
 Course: CPSC 321, Fall 2025
 Desc: Advanced queries using subqueries and complex joins on the film database
 */

/*
 (1) Find films with max length and above average replacement cost.
 Using subqueries for max length and avg cost since ORDER BY/LIMIT are not allowed
 */
SELECT film_id, title, length, replacement_cost
FROM film
WHERE length = (SELECT MAX(length) FROM film) -- Matches global max length
  AND replacement_cost > (SELECT AVG(replacement_cost) FROM film); -- Checks against global average

/*
 (2) Find the longest PG-13 films
 Subquery calculates the max length specifically for PG-13 to filter the main query
 */
SELECT film_id, title, length
FROM film
WHERE rating = 'PG-13'
  AND length = (SELECT MAX(length) FROM film WHERE rating = 'PG-13');

/*
 (3) Find G rated Action films rented at least 15 times
 Joins film to rental history to aggregate counts, then filters groups using HAVING
 */
SELECT f.film_id, f.title, COUNT(r.rental_id) AS num_rentals
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE f.rating = 'G' AND c.name = 'Action'
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 15
ORDER BY num_rentals DESC, f.title;

/*
 (4) Find actors who appeared in at least 4 Horror films
 Groups by actor and filters for the Horror category before counting
 */
SELECT a.actor_id, a.last_name, a.first_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'
GROUP BY a.actor_id, a.last_name, a.first_name
HAVING COUNT(f.film_id) >= 4
ORDER BY COUNT(f.film_id) DESC, a.last_name, a.first_name;

/*
 (5) Find the category with the MOST PG films
 Nested subquery first finds the maximum film count across all categories, then the outer query matches the category to that max value
 */
SELECT c.name, COUNT(f.film_id)
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.rating = 'PG'
GROUP BY c.name
HAVING COUNT(f.film_id) = (
    -- Calculate the single highest PG film count to use as a filter
    SELECT MAX(pg_count)
    FROM (
        SELECT COUNT(f2.film_id) as pg_count
        FROM category c2
        JOIN film_category fc2 ON c2.category_id = fc2.category_id
        JOIN film f2 ON fc2.film_id = f2.film_id
        WHERE f2.rating = 'PG'
        GROUP BY c2.name
    ) AS distinct_counts
);

/*
 (6) Find PG films rented more than the average rental count for PG films
 Subquery calculates the average rental count for the PG group to compare against each film
 */
SELECT f.title, COUNT(r.rental_id) AS num_rentals
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE f.rating = 'PG'
GROUP BY f.title
HAVING COUNT(r.rental_id) > (
    -- Calculate average rentals per movie for the PG rating
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(r2.rental_id) AS rental_count
        FROM film f2
        JOIN inventory i2 ON f2.film_id = i2.film_id
        JOIN rental r2 ON i2.inventory_id = r2.inventory_id
        WHERE f2.rating = 'PG'
        GROUP BY f2.film_id
    ) AS avg_calculation
)
ORDER BY num_rentals DESC;

/*
 (7) Find actors who have NEVER acted in a PG film
 Uses a subquery to find all actors associated with PG films, then excludes them through NOT IN
 */
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.rating = 'PG'
);

/*
 (8) Find movies available in ALL stores
 Dynamically compares the count of distinct stores for each film against the total store count
 */
SELECT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(DISTINCT i.store_id) = (SELECT COUNT(*) FROM store);