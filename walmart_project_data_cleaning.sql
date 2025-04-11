-- Use the specified database
USE walmart_project;

-- ==============================
-- DATA CLEANING OF 'transactions' TABLE
-- ==============================

-- View the full 'transactions' table
SELECT * FROM transactions;

-- Get the total number of rows in the 'transactions' table
SELECT COUNT(*) AS total_rows FROM transactions;

-- Get column names and their respective count of NULL values in 'transactions'
SELECT
	'invoice_id' AS COLUMN_NAME ,COUNT(*)-COUNT(invoice_id) AS null_count FROM transactions
UNION ALL
SELECT 'date' , COUNT(*)-COUNT(date) FROM transactions
UNION ALL
SELECT 'time' , COUNT(*)-COUNT(time) FROM transactions
UNION ALL
SELECT 'Branch' , COUNT(*)-COUNT(Branch) FROM transactions
UNION ALL
SELECT 'City' , COUNT(*)-COUNT(City) FROM transactions
UNION ALL
SELECT 'payment_method', COUNT(*)-COUNT(payment_method) FROM transactions
UNION ALL
SELECT 'quantity' , COUNT(*)-COUNT(quantity) FROM transactions
UNION ALL
SELECT 'profit_margin' , COUNT(*)-COUNT(profit_margin) FROM transactions;

-- Count total number of duplicate rows in 'transactions' table
SELECT SUM(dup_counts) AS total_duplicates
FROM (
	SELECT COUNT(*) - 1 AS dup_counts
	FROM transactions
	GROUP BY invoice_id, date, time, Branch, City, payment_method, profit_margin
	HAVING COUNT(*) > 1
) AS sub;

-- Delete rows with NULL values in 'quantity' column (update if more columns need null cleaning)
DELETE FROM transactions WHERE quantity IS NULL;

-- View duplicate rows based on selected columns
SELECT invoice_id, date, time, Branch, City, payment_method, quantity, profit_margin 
FROM transactions 
GROUP BY invoice_id, date, time, Branch, City, payment_method, quantity, profit_margin 
HAVING COUNT(*) > 1;

-- Remove duplicate rows while keeping only one entry of each duplicate
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY invoice_id, date, time, Branch, City, payment_method, quantity, profit_margin
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM transactions
)
DELETE FROM CTE
WHERE rn > 1;

-- Retrieve column names and their data types from 'transactions' table
SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transactions';

-- Modify column data types in 'transactions' table
ALTER TABLE transactions ALTER COLUMN invoice_id INT NOT NULL;
ALTER TABLE transactions ALTER COLUMN date DATE;
ALTER TABLE transactions ALTER COLUMN time TIME;
ALTER TABLE transactions ALTER COLUMN quantity FLOAT;

-- ==============================
-- DATA CLEANING OF 'product' TABLE
-- ==============================

-- View the full 'product' table
SELECT * FROM product;

-- Get total row count in 'product' table
SELECT COUNT(*) AS total_rows FROM product;

-- Get NULL count for each column in 'product' table
SELECT 'invoice_id' AS COLUMN_NAME , COUNT(*)-COUNT(invoice_id) AS null_count FROM product
UNION ALL
SELECT 'category', COUNT(*)-COUNT(category) FROM product
UNION ALL
SELECT 'unit_price', COUNT(*)-COUNT(unit_price) FROM product
UNION ALL
SELECT 'rating', COUNT(*)-COUNT(rating) FROM product;

-- Count total duplicate rows in 'product' table
SELECT SUM(dup_counts) AS total_duplicates
FROM (
	SELECT COUNT(*) - 1 AS dup_counts
	FROM product
	GROUP BY invoice_id, category, unit_price, rating
	HAVING COUNT(*) > 1
) AS sub;

-- Delete rows with NULL in 'unit_price' column (extend if needed)
DELETE FROM product WHERE unit_price IS NULL;

-- Remove duplicate rows in 'product' table
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY invoice_id, category, unit_price, rating
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM product
)
DELETE FROM CTE
WHERE rn > 1;

-- Get column names and data types in 'product' table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'product';

-- Clean and update data types in 'product' table
ALTER TABLE product ALTER COLUMN invoice_id INT NOT NULL;

-- Remove '$' symbol from unit_price column before converting data type
UPDATE product
SET unit_price = REPLACE(unit_price, '$', '');

-- Change unit_price column to float
ALTER TABLE product ALTER COLUMN unit_price FLOAT;

-- Add primary key to 'invoice_id' in 'product' table
ALTER TABLE product ADD CONSTRAINT pk_invoice_id PRIMARY KEY (invoice_id);

-- Add primary key to 'invoice_id' in 'transactions' table
ALTER TABLE transactions ADD CONSTRAINT invoice_id PRIMARY KEY (invoice_id);

-- Create foreign key link between 'product' and 'transactions' using invoice_id
ALTER TABLE product ADD CONSTRAINT fk_invoice_id FOREIGN KEY (invoice_id) REFERENCES transactions(invoice_id);

-- ==============================
-- FEATURE ENGINEERING
-- ==============================

-- Add a new column 'total_spendings' in 'transactions' table
ALTER TABLE transactions ADD total_spendings FLOAT;

-- Update 'total_spendings' by multiplying quantity and unit_price from joined tables
UPDATE t
SET t.total_spendings = t.quantity * p.unit_price
FROM transactions AS t
JOIN product AS p ON t.invoice_id = p.invoice_id;
