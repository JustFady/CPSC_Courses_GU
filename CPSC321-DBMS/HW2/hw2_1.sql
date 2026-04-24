/*===============================================================
 * NAME:   Fady Youssef
 * ASSIGN: HW-2, Question 1
 * COURSE: CPSC 321, Fall 2025
 * DESC:   Implement airport/airline/flight/segment with keys
 *         constraints, and valid/invalid inserts.
 *==============================================================*/

-- drop tables for clean rebuild (drop in reverse order of creation) 
DROP TABLE IF EXISTS segment;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS airline;
DROP TABLE IF EXISTS airport;

-- airport(id, name, city, state, elevation)
CREATE TABLE airport (
  id        VARCHAR(5) PRIMARY KEY, -- set number for id
  name      VARCHAR(80) NOT NULL,   -- different airport names
  city      VARCHAR(60) NOT NULL,
  state     CHAR(2)     NOT NULL, 
  elevation INTEGER     NOT NULL    -- varied elevation (DOUBLE?) 
);

-- airline(code, name, main_hub, yr_founded)
CREATE TABLE airline (
  code        CHAR(2)     PRIMARY KEY, -- airline code (e.g., AS, UA)
  name        VARCHAR(80) NOT NULL,    -- name of airline 
  main_hub    VARCHAR(5)  NOT NULL REFERENCES airport(id), -- specifies hub airport for airline
  yr_founded  INTEGER     NOT NULL,    -- founding year of airline
  CHECK (yr_founded BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)) 
);

-- flight(airline, flight_number, departure, arrival, flights_per_wk)
CREATE TABLE flight (
  airline        CHAR(2)    NOT NULL REFERENCES airline(code), -- airline that operates the flight
  flight_number  INTEGER    NOT NULL,                          -- unique within airline
  departure      VARCHAR(5) NOT NULL REFERENCES airport(id),   -- departure airport
  arrival        VARCHAR(5) NOT NULL REFERENCES airport(id),   -- arrival airport
  flights_per_wk INTEGER    NOT NULL,
  PRIMARY KEY (airline, flight_number),
  CHECK (flight_number > 0),                                   -- positive flight number
  CHECK (flights_per_wk >= 0),                                 -- non-negative weekly flights
  CHECK (departure <> arrival)                                 -- departure and arrival must be different
);

-- segment(airline, flight_number, segment_offset, start_airport, end_airport)
CREATE TABLE segment (
  airline        CHAR(2)    NOT NULL,                          -- airline code
  flight_number  INTEGER    NOT NULL,                          -- flight number within airline
  segment_offset INTEGER    NOT NULL,                          -- order of this leg within the full flight
  start_airport  VARCHAR(5) NOT NULL REFERENCES airport(id),   -- start airport of this leg
  end_airport    VARCHAR(5) NOT NULL REFERENCES airport(id),   -- end airport of this leg
  PRIMARY KEY (airline, flight_number, segment_offset), 
  FOREIGN KEY (airline, flight_number) REFERENCES flight(airline, flight_number), -- must map to an existing flight
  CHECK (segment_offset >= 1),                                 -- segment offset must be positive
  CHECK (start_airport <> end_airport)                         -- start and end airports must differ
);


-- airport(id, name, city, state, elevation)
INSERT INTO airport VALUES
  ('SEA','Seattle-Tacoma International','Seattle','WA',433),
  ('GEG','Spokane International','Spokane','WA',2377),
  ('LAX','Los Angeles International','Los Angeles','CA',125),
  ('DEN','Denver International','Denver','CO',5434),
  ('JFK','John F. Kennedy International','New York','NY',13),
  ('SFO','San Francisco International','San Francisco','CA',13);

-- INSERT INTO airport VALUES ('SEA','Duplicate','Nowhere','WA',100);      -- duplicate PK
-- INSERT INTO airport VALUES ('PDX', NULL, 'Portland', 'OR', 30);      -- invalid id--


-- airline(code, name, main_hub, yr_founded)
INSERT INTO airline VALUES
  ('AS','Alaska Airlines','SEA',1932),
  ('UA','United Airlines','DEN',1926),
  ('WN','Southwest Airlines','LAX',1967),
  ('AA','American Airlines','JFK',1930),
  ('DL','Delta Air Lines','SFO',1925);

-- INSERT INTO airline VALUES ('ZZ','Fake Air','XXX',2000);                -- hub FK fails
-- INSERT INTO airline VALUES ('FX','Future Air','SEA',1800);              -- year check fails


-- flight(airline, flight_number, departure, arrival, flights_per_wk)
INSERT INTO flight VALUES
  ('AS', 212,'GEG','SEA',21),
  ('AS', 450,'SEA','LAX',14),
  ('UA',1760,'DEN','JFK',10),
  ('UA', 567,'SFO','DEN',18),
  ('WN', 150,'SEA','LAX', 7),
  ('AA', 320,'JFK','SEA', 6);

-- INSERT INTO flight VALUES ('AS',999,'SEA','SEA',5);                     -- dep==arr check fails
-- INSERT INTO flight VALUES ('ZZ',1,'SEA','LAX',3);                        -- airline FK fails


-- segment(airline, flight_number, segment_offset, start_airport, end_airport)
INSERT INTO segment VALUES
  ('AS',212,1,'GEG','SEA'),
  ('AS',450,1,'SEA','LAX'),
  ('UA',1760,1,'DEN','SFO'),
  ('UA',1760,2,'SFO','JFK'),
  ('UA',567,1,'SFO','DEN'),
  ('WN',150,1,'SEA','GEG'),
  ('WN',150,2,'GEG','LAX'),
  ('AA',320,1,'JFK','SEA');

-- INSERT INTO segment VALUES ('AS',450,0,'SEA','LAX');                    -- offset check fails
-- INSERT INTO segment VALUES ('AS',999,1,'SEA','LAX');                    -- (airline,flight) FK fails

