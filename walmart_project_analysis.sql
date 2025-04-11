-- Use the Walmart project database
USE walmart_project;

-- Q1: Find different payment methods, number of transactions, and total quantities sold.
SELECT 
    payment_method,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS quantities_sold
FROM 
    transactions 
GROUP BY 
    payment_method
ORDER BY 
	quantities_sold DESC;

-- Q2: Identify the highest rated category in each branch with average ratings.
WITH RatingSummary AS (
    SELECT 
        t.Branch,
        p.category,
        MAX(p.rating) AS max_rating,
        ROUND((AVG(p.rating)),2) AS avg_rating
    FROM 
        transactions AS t 
    JOIN 
        product AS p ON t.invoice_id = p.invoice_id 
    GROUP BY 
        t.Branch, p.category
),
ranked_categories AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY Branch ORDER BY max_rating DESC) AS rnk
    FROM 
        RatingSummary
)
SELECT 
    *
FROM 
    ranked_categories
WHERE 
    rnk = 1
ORDER BY 
    Branch ASC, max_rating DESC;

-- Q3: Identify the busiest day for each branch based on the number of transactions
WITH trans_summary AS (
    SELECT
        Branch,
        DATENAME(WEEKDAY, date) AS day_name,
        COUNT(*) AS no_of_trans
    FROM 
        transactions
    GROUP BY
        Branch, DATENAME(WEEKDAY, date)
),
ranked_summary AS (
    SELECT 
        *,
        RANK() OVER(PARTITION BY Branch ORDER BY no_of_trans DESC) AS rnk
    FROM 
        trans_summary
)
SELECT 
    * 
FROM 
    ranked_summary 
WHERE 
    rnk = 1 
ORDER BY 
    Branch, no_of_trans;

-- Q4: Calculate the total number of items sold per payment method.
SELECT 
    payment_method,
    SUM(quantity) AS total_items_sold_per_payment_method 
FROM 
    transactions 
GROUP BY 
    payment_method
ORDER BY
	total_items_sold_per_payment_method DESC;

-- Q5: Determine the average, minimum, and maximum ratings of each category per city.
SELECT 
    t.City,
    p.category,
    ROUND((AVG(p.rating)),2) AS avg_rating,
    MIN(p.rating) AS min_rating,
    MAX(p.rating) AS max_rating 
FROM 
    transactions AS t 
JOIN 
    product AS p ON t.invoice_id = p.invoice_id 
GROUP BY 
    t.City, p.category
ORDER BY 
    t.City ASC,avg_rating DESC;

-- Q6: Calculate total profit for each category.
-- Formula: profit = unit_price * quantity * profit_margin
SELECT 
    p.category,
    SUM(p.unit_price * t.quantity * t.profit_margin) AS total_profit
FROM 
    transactions AS t 
JOIN 
    product AS p ON t.invoice_id = p.invoice_id 
GROUP BY 
    p.category
ORDER BY 
    total_profit DESC;

-- Q7: Determine the most common payment method for each branch.
WITH pref_pay AS (
    SELECT 
        Branch,
        payment_method,
        COUNT(*) AS preferred_payment_method
    FROM 
        transactions
    GROUP BY 
        payment_method, Branch
),
ranked_summary AS (
    SELECT 
        *,
        RANK() OVER(PARTITION BY Branch ORDER BY preferred_payment_method DESC) AS rnk
    FROM 
        pref_pay
)
SELECT 
    * 
FROM 
    ranked_summary 
WHERE 
    rnk = 1;

-- Q8: Categorize sales into morning, afternoon, and evening shifts
-- Then find the number of invoices for each shift
SELECT 
    COUNT(*) AS no_of_transactions,
    CASE
        WHEN time >= '00:00:00' AND time < '12:00:00' THEN 'Morning'
        WHEN time >= '12:00:00' AND time < '17:00:00' THEN 'Afternoon'
        WHEN time >= '17:00:00' AND time <= '23:59:59' THEN 'Evening'
    END AS shift
FROM 
    transactions
GROUP BY
    CASE
        WHEN time >= '00:00:00' AND time < '12:00:00' THEN 'Morning'
        WHEN time >= '12:00:00' AND time < '17:00:00' THEN 'Afternoon'
        WHEN time >= '17:00:00' AND time <= '23:59:59' THEN 'Evening'
    END
ORDER BY 
    no_of_transactions DESC;

-- Q9: Identify the top 5 branches with the highest decrease in revenue from 2022 to 2023.
WITH rev_2022 AS (
    SELECT 
        Branch,
        SUM(total_spendings) AS revn_2022 
    FROM 
        transactions
    WHERE 
        YEAR(date) = 2022
    GROUP BY 
        Branch
),
rev_2023 AS (
    SELECT 
        Branch,
        SUM(total_spendings) AS revn_2023
    FROM 
        transactions
    WHERE 
        YEAR(date) = 2023
    GROUP BY 
        Branch
)
SELECT TOP 5
    ls.Branch,
    ls.revn_2022,
    cs.revn_2023,
    ROUND((((ls.revn_2022 - cs.revn_2023) / ls.revn_2022) * 100),2) AS dec_ratio
FROM 
    rev_2022 AS ls
JOIN 
    rev_2023 AS cs ON ls.Branch = cs.Branch
WHERE 
    ls.revn_2022 > cs.revn_2023
ORDER BY 
    dec_ratio DESC;
