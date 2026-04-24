/*======================================================================
 *
 *  NAME:    Fady Youssef
 *  ASSIGN:  HW-3, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Defines country/province/city/border tables
 *           and populates them for Part 2 query testing.
 *======================================================================*/

DROP TABLE IF EXISTS border;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS province;
DROP TABLE IF EXISTS country;


CREATE TABLE country(
    country_code CHAR(2) NOT NULL,
    country_name VARCHAR(50) NOT NULL,
    gdp NUMERIC(12,2) NOT NULL CHECK (gdp >= 0), --up to 12 total digits; 2 decimals, make sure not negative
    inflation NUMERIC(5,2) NOT NULL CHECK (inflation > -100 AND inflation < 100), -- inflation is between (-100,100)%
    PRIMARY KEY(country_code)
);


CREATE TABLE province(
    province_name VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    area INT NOT NULL CHECK (area > 0 ),
    PRIMARY KEY(province_name, country_code),
    FOREIGN KEY(country_code) REFERENCES country(country_code)
);


CREATE TABLE city(
    city_name VARCHAR(50) NOT NULL,
    province_name VARCHAR(50) NOT NULL,
    country_code CHAR(2) NOT NULL,
    population INT NOT NULL CHECK (population >= 0), -- not negative
    PRIMARY KEY(city_name, province_name,country_code),
    FOREIGN KEY (province_name,country_code) REFERENCES province(province_name, country_code)
);


CREATE TABLE border(
    country_code_1 CHAR(2) NOT NULL,
    country_code_2 CHAR(2) NOT NULL,
    border_length NUMERIC(10,2) NOT NULL CHECK (border_length > 0), --up to 99,999,999.99
    PRIMARY KEY(country_code_1, country_code_2),
    FOREIGN KEY(country_code_1) REFERENCES country(country_code),
    FOREIGN KEY(country_code_2) REFERENCES country(country_code),
    CHECK (country_code_1 <> country_code_2)
);

------------------------------ POPULATED DATA ------------------------------

-- countries
INSERT INTO country VALUES
('US','United States of America',65000,3.50),
('CA','Canada',52000,2.10),
('MX','Mexico',25000,6.30),
('UK','United Kingdom',46000,4.20);

-- provinces
INSERT INTO province VALUES
 ('Washington','US',184827),
 ('Oregon','US',254799),
 ('Maine','US',91633),
 ('Montana','US',380831),

 ('Ontario','CA',1076395),
 ('Quebec','CA',1542056),
 ('Alberta','CA',661848),
 ('British Columbia','CA',944735),

 ('Jalisco','MX',78599),
 ('Chihuahua','MX',247460),
 ('Puebla','MX',34251),
 ('Yucatan','MX',39524),

 ('England','UK',130279),
 ('Scotland','UK',77933),
 ('Wales','UK',20779),
 ('Northern Ireland','UK',14130);

-- cities
INSERT INTO city VALUES

-- US Cities
-- Washington
('Seattle','Washington','US',750000),
('Everett','Washington','US',110000),
('Spokane','Washington','US',230000),
('Bellevue','Washington','US',150000),

-- Oregon
('Portland','Oregon','US',640000),
('Eugene','Oregon','US',176000),
('Salem','Oregon','US',180000),
('Gresham','Oregon','US',114000),

-- Maine
('Portland','Maine','US',68000),
('Bangor','Maine','US',32000),
('Lewiston','Maine','US',37000),
('Augusta','Maine','US',19000),

-- Montana
('Billings','Montana','US',120000),
('Missoula','Montana','US',74000),
('Bozeman','Montana','US',57000),
('Great Falls','Montana','US',59000),


-- Canadian cities
-- Ontario
('Toronto','Ontario','CA',3000000),
('Ottawa','Ontario','CA',1010000),
('Hamilton','Ontario','CA',570000),
('London','Ontario','CA',420000),

-- Quebec
('Montreal','Quebec','CA',1780000),
('Quebec City','Quebec','CA',550000),
('Laval','Quebec','CA',440000),
('Gatineau','Quebec','CA',290000),

-- Alberta
('Calgary','Alberta','CA',1300000),
('Edmonton','Alberta','CA',980000),
('Red Deer','Alberta','CA',105000),
('Lethbridge','Alberta','CA',93000),

-- British Columbia
('Vancouver','British Columbia','CA',675000),
('Surrey','British Columbia','CA',570000),
('Victoria','British Columbia','CA',92000),
('Kelowna','British Columbia','CA',145000),


-- Mexican cities
-- Jalisco
('Guadalajara','Jalisco','MX',1500000),
('Zapopan','Jalisco','MX',1250000),
('Puerto Vallarta','Jalisco','MX',300000),
('Tequila','Jalisco','MX',40000),

-- Chihuahua
('Chihuahua','Chihuahua','MX',925000),
('Juarez','Chihuahua','MX',1500000),
('Delicias','Chihuahua','MX',150000),
('Parral','Chihuahua','MX',110000),

-- Puebla
('Puebla','Puebla','MX',1700000),
('Tehuacan','Puebla','MX',319000),
('Cholula','Puebla','MX',120000),
('Atlixco','Puebla','MX',140000),

-- Yucatan
('Merida','Yucatan','MX',960000),
('Progreso','Yucatan','MX',37000),
('Ticul','Yucatan','MX',40000),
('Izamal','Yucatan','MX',30000),


--UK cities
-- England
('London','England','UK',8900000),
('Manchester','England','UK',550000),
('Birmingham','England','UK',1100000),
('Leeds','England','UK',790000),

-- Scotland
('Edinburgh','Scotland','UK',550000),
('Glasgow','Scotland','UK',635000),
('Aberdeen','Scotland','UK',200000),
('Dundee','Scotland','UK',150000),

-- Wales
('Cardiff','Wales','UK',360000),
('Swansea','Wales','UK',245000),
('Newport','Wales','UK',150000),
('Wrexham','Wales','UK',60000),

-- Northern Ireland
('Belfast','Northern Ireland','UK',340000),
('Derry','Northern Ireland','UK',85000),
('Lisburn','Northern Ireland','UK',120000),
('Newry','Northern Ireland','UK',27000);

-- borders
INSERT INTO border VALUES
('US','CA',8891.00), -- US to Canada
('CA','US',8891.00), -- Canada to US
('US','MX',3145.00), -- US to Mexico
('MX','US',3145.00); -- Mexico to US
