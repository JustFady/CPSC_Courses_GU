-- schema.sql
DROP TABLE IF EXISTS Reviews CASCADE;
DROP TABLE IF EXISTS Reservation_Insurance CASCADE;
DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS Maintenance_Records CASCADE;
DROP TABLE IF EXISTS Reservations CASCADE;
DROP TABLE IF EXISTS Vehicles CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Insurance_Options CASCADE;
DROP TABLE IF EXISTS Vehicle_Categories CASCADE;
DROP TABLE IF EXISTS Locations CASCADE;
DROP TABLE IF EXISTS Discounts CASCADE;

CREATE TABLE Locations (
    location_id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    operating_hours VARCHAR(100)
);

CREATE TABLE Vehicle_Categories (
    category_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Insurance_Options (
    insurance_id SERIAL PRIMARY KEY,
    coverage_type VARCHAR(100) NOT NULL,
    daily_cost DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    license_num VARCHAR(50),
    address VARCHAR(255)
);

CREATE TABLE Vehicles (
    vin VARCHAR(17) PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    current_mileage INT DEFAULT 0,
    availability_status VARCHAR(20) DEFAULT 'Available',
    location_id INT REFERENCES Locations(location_id),
    category_id INT REFERENCES Vehicle_Categories(category_id)
);

CREATE TABLE Reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    vin VARCHAR(17) REFERENCES Vehicles(vin),
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    total_cost DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Reservation_Insurance (
    reservation_id INT REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
    insurance_id INT REFERENCES Insurance_Options(insurance_id) ON DELETE CASCADE,
    PRIMARY KEY (reservation_id, insurance_id)
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    reservation_id INT REFERENCES Reservations(reservation_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    method VARCHAR(50),
    transaction_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Maintenance_Records (
    maintenance_id SERIAL PRIMARY KEY,
    vin VARCHAR(17) REFERENCES Vehicles(vin) ON DELETE CASCADE,
    service_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2)
);

CREATE TABLE Discounts (
    code VARCHAR(20) PRIMARY KEY,
    percent_off INT NOT NULL
);

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    vin VARCHAR(17) REFERENCES Vehicles(vin),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);