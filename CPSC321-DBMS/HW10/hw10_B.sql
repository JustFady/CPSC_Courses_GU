/*
 Name: Fady Youssef
 Assignment: HW10 Part B
 Course: CPSC 321, Fall 2025
 Desc: Queries 5-6 involving Recursive CTEs and table creation.
 */

-- setup for question 5. creating the parent_child table
DROP TABLE IF EXISTS parent_child;
CREATE TABLE parent_child(parent_name VARCHAR, child_name VARCHAR);

INSERT INTO parent_child (parent_name, child_name) VALUES
                                                       ('Abraham Simpson', 'Homer Simpson'),
                                                       ('Monica Simpson', 'Homer Simpson'),
                                                       ('Homer Simpson', 'Bart Simpson'),
                                                       ('Homer Simpson', 'Lisa Simpson'),
                                                       ('Homer Simpson', 'Maggie Simpson'),
                                                       ('Marge Simpson', 'Bart Simpson'),
                                                       ('Marge Simpson', 'Lisa Simpson'),
                                                       ('Marge Simpson', 'Maggie Simpson'),
                                                       ('Bart Simpson', 'Bart Simpson Jr.'),
                                                       ('Lisa Simpson', 'Zia Simpson');

/* (5) Find ancestors of Zia Simpson and Bart Simpson Jr. */
-- using a recursive cte to climb up the family tree. keeping track of distance and the path string
WITH RECURSIVE family_tree AS (
    -- base case: the specific kids we are looking for
    SELECT parent_name, child_name, 1 as dist,
           parent_name || ' < ' || child_name as path
    FROM parent_child
    WHERE child_name IN ('Zia Simpson', 'Bart Simpson Jr.')

    UNION ALL

    -- recursive step: finding parents of whoever is currently in the list
    SELECT pc.parent_name, ft.child_name, ft.dist + 1,
           pc.parent_name || ' < ' || ft.path
    FROM parent_child pc
             JOIN family_tree ft ON pc.child_name = ft.parent_name
)
SELECT parent_name as ancestor, child_name as descendent, dist, path
FROM family_tree
ORDER BY child_name, dist;


-- setup for question 6. creating flight table
DROP TABLE IF EXISTS flight;
CREATE TABLE flight(origin VARCHAR(3), destination VARCHAR(3), distance INT);

-- populating with pnw airports. I added a direct sea->den flight that's far
-- and a multi-hop one that's shorter distance-wise so I can test if the query finds the real shortest path
INSERT INTO flight VALUES
-- Out of Seattle
('SEA', 'GEG', 224),
('SEA', 'PDX', 129),
('SEA', 'DEN', 1300),

-- Out of Spokane
('GEG', 'BOI', 290),
('GEG', 'SEA', 224),

-- Out of Portland
('PDX', 'BOI', 340),
('PDX', 'SLC', 630),

-- Connecting Flights
('BOI', 'SLC', 290),
('SLC', 'DEN', 370),
('SLC', 'BOI', 290);

/* (6) Find the shortest distance flight routes */
-- recursive cte to map out all possible paths.
-- I added a 'num_flights' counter to stop infinite loops. if a path takes more than 8 flights, it's definitely not the shortest
WITH RECURSIVE flight_path AS (
    -- base case: just the direct flights
    SELECT origin, destination, distance,
           origin || ' -> ' || destination as path,
           1 as num_flights
    FROM flight

    UNION ALL

    -- recursive step: connecting flights to the next destination
    SELECT fp.origin, f.destination, fp.distance + f.distance,
           fp.path || ' -> ' || f.destination,
           fp.num_flights + 1
    FROM flight_path fp
             JOIN flight f ON fp.destination = f.origin
    -- cycle check: stop if the path gets too long (more than 8 flights)
    WHERE fp.num_flights < 8
),
-- finding the minimum distance for every start->end pair
               shortest_dist AS (
                   SELECT origin, destination, MIN(distance) as min_dist
                   FROM flight_path
                   GROUP BY origin, destination
               )
-- joining the min distance back to the full list to retrieve the text path
SELECT fp.origin, fp.destination, fp.distance, fp.path
FROM flight_path fp
         JOIN shortest_dist sd ON fp.origin = sd.origin
    AND fp.destination = sd.destination
    AND fp.distance = sd.min_dist
ORDER BY fp.origin, fp.destination;