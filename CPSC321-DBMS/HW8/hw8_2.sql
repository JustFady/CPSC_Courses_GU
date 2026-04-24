/*
 Name: Fady Youssef
 Assignment: HW8 Part 2
 Course: CPSC 321, Fall 2025
 Desc: Queries for Part 2 using the cpsc321 film rental database.
 */

/*
 query 1: Determine film stats like total count and length attributes.
 I am counting distinct special features here to see how many unique combinations there are.
*/
SELECT
    COUNT(*) AS num_films,
    MIN(length) AS min_length,
    MAX(length) AS max_length,
    ROUND(AVG(length), 2) AS avg_length,
    COUNT(DISTINCT special_features) AS special_features
FROM film;

/*
 query 2: Group films by rating to find the count and average length.
 Ordered from the longest average length to the shortest.
*/
SELECT
    rating,
    COUNT(*) AS num_films,
    ROUND(AVG(length), 2) AS avg_length
FROM film
GROUP BY rating -- grouping by rating so the averages are calculated per rating instead of for everything
ORDER BY avg_length DESC;

/*
 query 3: Get stats for each category including rental rates and replacement costs.
 I had to join the category table through film_category to get the actual category names.
*/
SELECT
    c.name,
    COUNT(f.film_id) AS num_films,
    MIN(f.rental_rate) AS min_rate,
    MAX(f.rental_rate) AS max_rate,
    ROUND(AVG(f.rental_rate), 2) AS avg_rate,
    MIN(f.replacement_cost) AS min_cost,
    MAX(f.replacement_cost) AS max_cost,
    ROUND(AVG(f.replacement_cost), 2) AS avg_cost
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id -- linking category to film
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY c.name; -- sorting these alphabetically by name

/*
 query 4: Count rentals of classic films at store 1.
 This required joining several tables to get from the rental record all the way back to the category name.
*/
SELECT
    f.rating,
    COUNT(r.rental_id) AS num_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE i.store_id = 1 -- filtering for just store 1
  AND c.name = 'Classics' -- specifically looking for the Classics category
GROUP BY f.rating
ORDER BY num_rentals DESC; -- ordering by most rentals to least

/*
 query 5: Find popular PG Horror films.
 I used a HAVING clause to filter for titles that have at least 10 rentals.
*/
SELECT
    f.title,
    COUNT(r.rental_id) AS num_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.rating = 'PG' -- checking for PG rating
  AND c.name = 'Horror' -- checking for Horror category
GROUP BY f.title
HAVING COUNT(r.rental_id) >= 10 -- using HAVING here since I need to filter based on the count of rentals
ORDER BY num_rentals DESC;

/*
 query 6: Identify actors who appear in many sports movies.
 Listing them by how many sports movies they have done, sorted by count then name.
*/
SELECT
    a.first_name,
    a.last_name,
    COUNT(f.film_id) AS num_sports_films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id -- linking actor to film
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sports'
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f.film_id) >= 5 -- making sure they have appeared in at least 5 films
ORDER BY num_sports_films DESC, a.last_name, a.first_name;