# 🗃️ Vehicle Rental System: Database Design, Entity-Relationship Diagram & SQL Queries

### ✒️ This project is done for the fulfillment of the requirement of Assignment 3

This assignment is designed to evaluate your understanding of `database table design`, `ERD relationships` and `SQL queries`. You will work with a simplified Vehicle Rental System database.

## 📜 What are the requiremnet for fulfilling the project?

- Design an ERD with **1 to 1**, **1 to Many** and **Many to 1** relationships
- Understand primary keys and foreign keys
- Write SQL queries using JOIN, EXISTS and WHERE

---

## 🛢️ Database Design & Business Logic

### The database will composed of below three entity. Those are following:

- **_Users_**
- **_Vehicles_**
- **_bookings_**

### 🧩 Business Logic - What Your Database Must Handle

---

Database design supports these real world scenarios:

#### Users Table Must Store:

- User role (Admin or Customer)
- Name, email, password, phone number
- Each email must be unique (no duplicate accounts)

#### Vehicles Table Must Store:

- Vehicle name, type (car/bike/truck), model
- Registration number (must be unique)
- Rental price per day
- Availability status (available/rented/maintenance)

#### Bookings Table Must Store:

- Which user made the booking (link to Users table)
- Which vehicle was booked (link to Vehicles table)
- Start date and end date of rental
- Booking status (pending/confirmed/completed/cancelled)
- Total cost of the booking

---

## 📋 SQL Queries

- ### CREATE tables

```sql
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

```

## 🪄 Questions

### Query 1: JOIN

Retrieve booking information along with:

- Customer name
- Vehicle name

```sql
SELECT
  b.booking_id,
  u.name as customer_name,
  v.name as vahicle_name,
  b.start_rent_date as start_date,
  b.end_rent_date as end_date,
  b.booking_status as status
FROM
  bookings AS b
  INNER JOIN users AS u ON b.user_id = u.user_id
  INNER JOIN vehicles as v ON b.vehicle_id = v.vehicle_id;
```

- Result

| booking_id | customer_name | vahicle_name   | start_date | end_date   | status    |
| ---------- | ------------- | -------------- | ---------- | ---------- | --------- |
| 1          | Alice Johnson | Honda Civic    | 2023-10-01 | 2023-10-05 | completed |
| 2          | Alice Johnson | Honda Civic    | 2023-11-01 | 2023-11-03 | completed |
| 3          | Charlie Brown | Honda Civic    | 2023-12-01 | 2023-12-02 | confirmed |
| 4          | Alice Johnson | Toyota Corolla | 2023-12-10 | 2023-12-12 | pending   |

### Query 2: EXISTS

Find all vehicles that have never been booked.

```sql
SELECT
  *
FROM
  vehicles AS v
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      bookings AS b
    WHERE
      v.vehicle_id = b.vehicle_id
  );
```

- Result

| vehicle_id | name       | type  | model | registration_number | rental_price | status      |
| ---------- | ---------- | ----- | ----- | ------------------- | ------------ | ----------- |
| 4          | Ford F-150 | truck | 2020  | DHAKA-GA-3409       | 40.00        | maintenance |
| 3          | Yamaha R15 | bike  | 2023  | KHUL-CC3RT          | 30.00        | available   |

### Query 3: WHERE

Retrieve all available vehicles of a specific type (e.g. cars).

```sql
SELECT
  *
FROM
  vehicles
WHERE
  type = 'car'
  AND status = 'available';
```

| vehicle_id | name           | type | model | registration_number | rental_price | status    |
| ---------- | -------------- | ---- | ----- | ------------------- | ------------ | --------- |
| 1          | Toyota Corolla | car  | 2022  | ABC-123             | 50.00        | available |

### Query 4: GROUP BY and HAVING

Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

```sql
SELECT
  v.name AS vehicle_name,
  COUNT(*) AS total_bookings
FROM
  vehicles AS v
  INNER JOIN bookings AS b ON v.vehicle_id = b.vehicle_id
GROUP BY
  v.name
HAVING
  COUNT(*) > 2;
```

- Result

| vehicle_name | total_bookings |
| ------------ | -------------- |
| Honda Civic  | 3              |

---

```

```
