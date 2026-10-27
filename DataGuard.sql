USE dataguard;

SELECT * FROM customers;

SELECT * FROM transactions;

USE dataguard;

SELECT *
FROM customers
WHERE customer_name IS NULL
   OR email IS NULL
   OR TRIM(email) = ''
   OR age IS NULL
   OR city IS NULL;

   SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY email
HAVING COUNT(*) > 1;

SELECT *
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
  AND email NOT REGEXP
  '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$';

SELECT *
FROM customers
WHERE age IS NOT NULL
  AND (age < 0 OR age > 100);

  SELECT COUNT(*) AS total_customers
FROM customers;


SELECT COUNT(*) AS total_transactions
FROM transactions;

SELECT *
FROM customers;

USE dataguard;

INSERT IGNORE INTO customers
(customer_id, customer_name, email, age, city)
VALUES
(1, 'Aarav Sharma', 'aarav@gmail.com', 24, 'Lucknow'),
(2, 'Priya Verma', 'priya@gmail.com', 22, 'Delhi'),
(3, 'Rahul Singh', 'rahul@gmail.com', 28, 'Kanpur'),
(4, 'Neha Gupta', NULL, 25, 'Lucknow'),
(5, 'Aarav Sharma', 'aarav@gmail.com', 24, 'Lucknow'),
(6, 'Riya Khan', 'riya.gmail.com', -5, 'Jaipur'),
(7, 'Karan Mehta', '   ', 30, 'Delhi'),
(8, NULL, 'simran@gmail.com', 19, 'Agra'),
(9, 'Simran Das', 'simran@gmail.com', 19, 'Agra'),
(10, 'Vikram Rao', 'vikram@gmail.com', NULL, 'Mumbai');

INSERT IGNORE INTO transactions
(transaction_id, customer_id, amount, transaction_date, status)
VALUES
(101, 1, 1500, '2026-01-05', 'Completed'),
(102, 2, 2500, '2026-01-06', 'Completed'),
(103, 3, -500, '2026-01-07', 'Failed'),
(104, 4, 1200, '2026-01-08', NULL),
(105, 5, 800, '2026-01-09', 'Completed'),
(106, 6, 0, '2026-01-10', 'Pending'),
(107, 7, 3200, '2026-01-11', 'Completed'),
(108, 8, 450, '2026-01-12', 'Unknown'),
(109, 9, 750, '2026-01-13', 'Completed'),
(110, 10, 1100, '2026-01-14', 'Pending');

SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_transactions FROM transactions;

USE dataguard;


SELECT *
FROM customers
WHERE customer_name IS NULL
   OR TRIM(customer_name) = ''
   OR email IS NULL
   OR TRIM(email) = ''
   OR age IS NULL
   OR city IS NULL
   OR TRIM(city) = '';


SELECT email, COUNT(*) AS duplicate_count
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY email
HAVING COUNT(*) > 1;


SELECT customer_id, customer_name, email
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
  AND email NOT REGEXP
  '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$';


SELECT *
FROM customers
WHERE age < 0 OR age > 100;

SELECT *
FROM transactions
WHERE amount < 0;


SELECT *
FROM transactions
WHERE amount = 0;


SELECT *
FROM transactions
WHERE status IS NULL
   OR TRIM(status) = ''
   OR status NOT IN ('Completed', 'Failed', 'Pending');


SELECT status, COUNT(*) AS total_transactions
FROM transactions
GROUP BY status;


SELECT
    c.customer_id,
    c.customer_name,
    COUNT(t.transaction_id) AS total_transactions,
    COALESCE(SUM(t.amount), 0) AS total_amount
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;


SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM transactions) AS total_transactions;

USE dataguard;

SELECT
    'Missing Customer Details' AS issue_type,
    COUNT(*) AS issue_count
FROM customers
WHERE customer_name IS NULL
   OR TRIM(customer_name) = ''
   OR email IS NULL
   OR TRIM(email) = ''
   OR age IS NULL
   OR city IS NULL

UNION ALL

SELECT
    'Invalid Age',
    COUNT(*)
FROM customers
WHERE age < 0 OR age > 100

UNION ALL

SELECT
    'Invalid Email',
    COUNT(*)
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
  AND email NOT REGEXP
  '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$'

UNION ALL

SELECT
    'Negative Transactions',
    COUNT(*)
FROM transactions
WHERE amount < 0

UNION ALL

SELECT
    'Invalid Transaction Status',
    COUNT(*)
FROM transactions
WHERE status IS NULL
   OR status NOT IN ('Completed', 'Failed', 'Pending');

USE dataguard;

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(CASE
        WHEN t.status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_transactions,
    SUM(CASE
        WHEN t.status = 'Failed' THEN 1
        ELSE 0
    END) AS failed_transactions,
    COALESCE(SUM(
        CASE
            WHEN t.status = 'Completed' THEN t.amount
            ELSE 0
        END
    ), 0) AS successful_amount
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city
ORDER BY successful_amount DESC;