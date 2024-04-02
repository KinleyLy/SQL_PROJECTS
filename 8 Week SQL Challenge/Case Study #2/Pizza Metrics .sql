-- 1. How many pizzas were ordered?
SELECT 
    COUNT(PIZZA_ID) AS NUMBER_OF_PIZZA
FROM CUSTOMER_ORDERS;

-- 2. How many unique customer orders were made?
SELECT
    COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMER_ORDERS
FROM CUSTOMER_ORDERS;

-- 3. How many successful orders were delivered by each runner?

SELECT
    RUNNER_ID,
    COUNT(DISTINCT CO.ORDER_ID) AS PIZZA_ORDERS
FROM CUSTOMER_ORDERS AS CO
JOIN RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.ORDER_ID
WHERE DURATION != 'null'
GROUP BY RUNNER_ID;

-- 4. How many of each type of pizza was delivered?

SELECT
    PIZZA_NAME,
    COUNT(CO.PIZZA_ID) AS NUMBER_OF_PIZZA
FROM CUSTOMER_ORDERS AS CO
JOIN PIZZA_NAMES AS PN ON CO.PIZZA_ID = PN.PIZZA_ID
GROUP BY PIZZA_NAME;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
    CUSTOMER_ID,
    PIZZA_NAME,
    COUNT(CO.PIZZA_ID) AS NUMBER_OF_PIZZA
FROM CUSTOMER_ORDERS AS CO
JOIN PIZZA_NAMES AS PN ON CO.PIZZA_ID = PN.PIZZA_ID
GROUP BY CUSTOMER_ID, PIZZA_NAME
ORDER BY CUSTOMER_ID ASC;

-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT
    ORDER_ID,
    COUNT(ORDER_ID) AS NUMBER_OF_PIZZAS
FROM CUSTOMER_ORDERS
GROUP BY ORDER_ID 
ORDER BY NUMBER_OF_PIZZAS DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

WITH EX AS(
SELECT
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
        CASE
            WHEN EXCLUSIONS = 'null' THEN NULL
            WHEN EXCLUSIONS = '' THEN NULL
            ELSE EXCLUSIONS
    END AS EXCLUSIONS,
        CASE
            WHEN EXTRAS = 'null' THEN NULL
            WHEN EXTRAS = '' THEN NULL
            ELSE EXTRAS
    END AS EXTRAS
FROM customer_orders
)
SELECT 
    CUSTOMER_ID,
    COUNT(
        CASE
        WHEN EXCLUSIONS IS NULL AND EXTRAS IS NULL then 1 END) AS NO_CHANGES,
    COUNT(
        CASE
        WHEN EXCLUSIONS IS NOT NULL OR EXTRAS IS NOT NULL THEN 1 END) AS AT_LEAST_ONE_CHANGE
FROM EX
GROUP BY CUSTOMER_ID;

-- 8. How many pizzas were delivered that had both exclusions and extras?

WITH EX AS(
SELECT
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
        CASE
            WHEN EXCLUSIONS = 'null' THEN NULL
            WHEN EXCLUSIONS = '' THEN NULL
            ELSE EXCLUSIONS
    END AS EXCLUSIONS,
        CASE
            WHEN EXTRAS = 'null' THEN NULL
            WHEN EXTRAS = '' THEN NULL
            ELSE EXTRAS
    END AS EXTRAS
FROM customer_orders
)
SELECT 
    COUNT(
        CASE
        WHEN EXCLUSIONS IS NOT NULL AND EXTRAS IS NOT NULL THEN 1 END) AS BOTH_EXCLUSIONS_AND_EXTRAS
FROM EX;

-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT
    COUNT(PIZZA_ID) AS NUMBER_OF_PIZZAS,
    TIME_SLICE(order_time,1,'hour') AS TIME_BY_HOUR
FROM CUSTOMER_ORDERS
GROUP BY TIME_BY_HOUR;

-- 10. What was the volume of orders for each day of the week?

SELECT 
    COUNT(PIZZA_ID) AS NUMBER_OF_PIZZAS,
    DATE_TRUNC('day', order_time) AS DAY
FROM CUSTOMER_ORDERS
GROUP BY DAY;
SELECT *
FROM CUSTOMER_ORDERS;
