-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
    DATE_TRUNC('week',registration_date) + 4 AS REGISTER_DATE,
    COUNT(DISTINCT RU.RUNNER_ID) AS NUMBER_OF_RUNNERS
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
GROUP BY REGISTER_DATE;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT
    RO.RUNNER_ID,
    AVG(TIMEDIFF(minute,order_time,pickup_time)) AS AVG_TIME
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
WHERE PICKUP_TIME != 'null'
GROUP BY RO.RUNNER_ID;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH NUM AS(
SELECT
    CO.ORDER_ID,
    COUNT(PIZZA_ID) AS NUMBER_OF_PIZZAS,
    MAX(TIMEDIFF(minute,order_time,pickup_time)) AS TIME_TO_COOK
FROM RUNNER_ORDERS AS RO 
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
WHERE PICKUP_TIME != 'null'
GROUP BY CO.ORDER_ID
)
SELECT
    NUMBER_OF_PIZZAS,
    AVG(TIME_TO_COOK) AS AVG_COOK_TIME
FROM NUM
GROUP BY NUMBER_OF_PIZZAS;

-- 4. What was the average distance travelled for each customer?

SELECT
    CO.CUSTOMER_ID,
    AVG(REPLACE(DISTANCE,'km','')) AS AVG_DISTANCE_KM
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
WHERE DISTANCE != 'null'
GROUP BY CO.CUSTOMER_ID;

-- 5. What was the difference between the longest and shortest delivery times for all orders?

SELECT
    MAX(REGEXP_REPLACE(DURATION,'[^0-9]', '')) - MIN(REGEXP_REPLACE(DURATION,'[^0-9]', '')) AS DURATION_DIFFERENCE
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
WHERE DURATION != 'null';

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT
    RO.RUNNER_ID,
    RO.ORDER_ID,
    AVG(REPLACE(DISTANCE,'km','')) / AVG(REGEXP_REPLACE(DURATION,'[^0-9]', '')) AS KM_PER_MINUTE
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
WHERE DURATION != 'null'
GROUP BY RO.RUNNER_ID, RO.ORDER_ID
ORDER BY RO.RUNNER_ID, RO.ORDER_ID ASC;

-- 7. What is the successful delivery percentage for each runner?

SELECT 
    RO.RUNNER_ID,
    SUM(CASE WHEN PICKUP_TIME = 'null' THEN 0 ELSE 1 END)/ COUNT(RO.ORDER_ID) AS PERCENTAGE  
FROM
    RUNNERS AS RU
JOIN RUNNER_ORDERS AS RO ON RU.RUNNER_ID = RO.runner_id
JOIN CUSTOMER_ORDERS AS CO ON CO.ORDER_ID = RO.order_id
GROUP BY RO.RUNNER_ID;

