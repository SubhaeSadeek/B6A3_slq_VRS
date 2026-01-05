-- CREATE users table
-- ----------
CREATE TYPE user_role AS ENUM('admin', 'customer');

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,  
  name VARCHAR(150) NOT NULL,
  email VARCHAR(100)  UNIQUE NOT NULL ,
  password TEXT NOT NULL,
  phone_number VARCHAR(25) NOT NULL,
  role user_role NOT NULL
);

-- CREATE vehicles table
-- ---------------------
  CREATE TYPE typeof_vehicle_model AS ENUM('car', 'bike', 'truck');
  CREATE TYPE typeof_vehicle_availability_status AS ENUM('available', 'rented', 'maintenance');
  
  CREATE TABLE vehicles(
    vehicle_id SERIAL PRIMARY KEY, 
    name VARCHAR(100) NOT NULL,
    type typeof_vehicle_model NOT NULL,
    model VARCHAR(50) NOT NULL,
    registration_number VARCHAR(50) UNIQUE NOT NULL,
    rental_price DECIMAL(8,2) NOT NULL,
    status typeof_vehicle_availability_status NOT NULL 
    );

-- CREATE bookings table
-- ---------------------

CREATE TYPE typeof_booking_status AS ENUM('pending', 'confirmed', 'completed', 'cancelled');

CREATE TABLE bookings(
  booking_id SERIAL PRIMARY KEY, 
  user_id INT NOT NULL REFERENCES users(user_id),
  vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
  start_rent_date DATE NOT NULL,
  end_rent_date DATE NOT NULL,
  booking_status typeof_booking_status NOT NULL,
  total_cost DECIMAL(8, 2) NOT NULL
);

-- ------------------------------------------------
-- Inserting data for testing
-- ------------------------------------------------
INSERT INTO users (name, email, password, phone_number, role) 
VALUES 
    ('Alice Johnson', 'alice@bandit.com', 'pass123', '1234567890', 'customer'),
    ('Bob Smith', 'bob@bindas.com', 'pass123', '2345678901', 'admin'),
    ('Charlie Brown', 'charlie@safnas.com', 'pass123', '3456789012', 'customer'),
    ('Diana Prince', 'diana@phero.com', 'pass123', '4567890123', 'customer');

INSERT INTO vehicles (name, type, model, registration_number, rental_price, status)
  VALUES 
  ('Toyota Corolla',	'car',	'2022',	'ABC-123',	50,	'available'),
  ('Honda Civic',	'car',	'2021',	'RAJ-GA-006',	100,	'rented'),
  ('Yamaha R15',	'bike',	'2023',	'KHUL-CC3RT',	30,	'available'),
  ('Ford F-150',	'truck',	'2020',	'DHAKA-GA-3409',	40,	'maintenance');
INSERT INTO bookings(user_id, vehicle_id, start_rent_date, end_rent_date, booking_status, total_cost)
  VALUES
  (1,	2,	'2023-10-01',	'2023-10-05',	'completed', 240),
(1,	2,	'2023-11-01',	'2023-11-03',	'completed',	120),
(3,	2,	'2023-12-01',	'2023-12-02',	'confirmed',	60),
(1,	1,	'2023-12-10',	'2023-12-12',	'pending',	100);

-- -----------------------------------------------------------------------------
-- Data query and manupulations
-- query 1
SELECT b.booking_id, u.name as customer_name, v.name as vahicle_name, b.start_rent_date as start_date, b.end_rent_date as end_date, b.booking_status as status FROM bookings  
 AS b  INNER JOIN users AS u ON b.user_id = u.user_id
  INNER JOIN vehicles as v ON b.vehicle_id = v.vehicle_id; 

-- query 2
SELECT * FROM vehicles AS v
 WHERE NOT EXISTS(
  SELECT *
  FROM bookings AS b
  WHERE v.vehicle_id = b.vehicle_id
 );

-- Query 3
SELECT * FROM vehicles 
WHERE type = 'car'
AND status = 'available';

-- Query 4
SELECT v.name AS vehicle_name, COUNT(*) AS total_bookings
FROM vehicles AS v 
  INNER JOIN bookings AS b 
  ON v.vehicle_id = b.vehicle_id
  GROUP BY v.name
    HAVING COUNT(*) > 2;



