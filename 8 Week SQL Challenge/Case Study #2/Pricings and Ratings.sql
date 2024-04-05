-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
    SUM(CASE 
        WHEN CO.PIZZA_ID = '1' THEN '12'
        WHEN CO.PIZZA_ID = '2' THEN '10'
        END) AS TOTAL_SALES
FROM CUSTOMER_ORDERS AS CO
JOIN RUNNER_ORDERS AS RO ON CO.ORDER_ID = RO.order_id
WHERE PICKUP_TIME != 'null'
;

-- 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
WITH EX_COST AS(;
SELECT
    PIZZA_ID,
    ARRAY_SIZE(SPLIT(extras, ',')) AS num_toppings
FROM CUSTOMER_ORDERS;
)
SELECT
    SUM(CASE 
        WHEN PIZZA_ID = '1' THEN '12'
        WHEN PIZZA_ID = '2' THEN '10'
        END) AS TOTAL_SALES
FROM CUSTOMER_ORDERS;

-- INCOMPLETE
