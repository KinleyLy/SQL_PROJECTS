-- 1. Select ALL the records from Superstore_Orders

SELECT* FROM SUPERSTORE;

-- 2. Select ALL the records from Superstore_Orders That are in the East Region, That has a profit value greater than 200

SELECT * FROM SUPERSTORE
WHERE REGION = 'East' AND PROFIT > 200;

-- 3. Select Unique Products from Superstore_Orders That were sold in the South or Central Region That have a Sales value greater than 200 and less than 300

SELECT DISTINCT PRODUCT_NAME, REGION, SALES FROM SUPERSTORE
WHERE REGION in ('South','Central') AND SALES between 200 AND 300;

-- 4. Select Unique Products from Superstore_Orders that have the letter ‘b’ in. Give two answers, one that is case sensitive and one that is case insensitive.

SELECT DISTINCT product_name
FROM SUPERSTORE
WHERE product_name LIKE '%b%';

SELECT DISTINCT PRODUCT_NAME FROM SUPERSTORE
WHERE lower(product_name) LIKE '%b%';

-- 5.Select ALL records from Superstore_Orders that are unprofitable That are either in the Central Region or in New York State

SELECT * FROM SUPERSTORE
WHERE PROFIT < 0 
AND (REGION = 'CENTRAL' OR STATE = 'New York');

-- 6. Find the 10 largest sales values in Superstore_Orders. One answer using TOP and another using LIMIT. Remember to ORDER BY

SELECT * FROM SUPERSTORE
ORDER BY sales DESC
LIMIT 10; 

-- 7. Find the Total Sales & Profit for each Region

SELECT REGION, ROUND(SUM(SALES),2) AS TOTAL_SALES, ROUND(SUM(PROFIT),2) AS TOTAL_PROFIT
FROM SUPERSTORE
GROUP BY REGION;

-- 8. Find the Average Discount by Segment & Ship Mode. Alias the Avg Discount to something of your choice. Order from highest to lowest Avg Discount.

SELECT SEGMENT, SHIP_MODE, AVG(DISCOUNT) AS AVERAGE_DISCOUNT 
FROM SUPERSTORE
GROUP BY SEGMENT, SHIP_MODE
ORDER BY AVERAGE_DISCOUNT DESC;

-- 9. For the Central Region find the Minimum Profit value per Sub-Category. Alias the Minimum Profit field. Order from lowest profit value to highest

SELECT SUB_CATEGORY, MIN(PROFIT) AS MINIMUM_PROFIT 
FROM SUPERSTORE
WHERE REGION = 'Central' 
GROUP BY SUB_CATEGORY
ORDER BY MINIMUM_PROFIT ASC;

-- 10. Which Order Dates had a total profit greater than 2000? Alias your profit aggregation. Sort from highest to lowest profit

SELECT ORDER_DATE, SUM(PROFIT) AS TOTAL_PROFIT
FROM superstore
GROUP BY ORDER_DATE
HAVING SUM(PROFIT) > 2000
ORDER BY TOTAL_PROFIT DESC;

-- 11. For the Central Region, which Products had an average profit less than -400? Alias your profit aggregation. Sort from lowest to highest avg profit

SELECT PRODUCT_NAME, REGION, AVG(PROFIT) AS AVERAGE_PROFIT
FROM SUPERSTORE
WHERE REGION = 'Central'
GROUP BY REGION, PRODUCT_NAME
HAVING AVG(PROFIT) < -400
ORDER BY AVERAGE_PROFIT ASC;

-- 12. For Florida State in the Superstore_Joined table find the total Sales value of items returned and not returned Find the total number of items returned and not returned. Alias your fields

SELECT RETURNED, SUM(SALES) AS TOTAL_SALES, COUNT(PRODUCT_NAME) AS TOTAL_ITEMS  FROM SUPERSTORE
FULL JOIN RETURNED_ORDERS ON SUPERSTORE.ORDER_ID = RETURNED_ORDERS.ORDER_ID
WHERE STATE = 'Florida'
GROUP BY RETURNED;

-- 13. For the Furniture Category in the Superstore_Joined table. Find the top 10 order values for orders with a profit < 0. Ensure the orders have not been returned. Alias your fields

SELECT RETURNED, CATEGORY, SUPERSTORE.ORDER_ID, SUM(PROFIT) AS TOTAL_PROFIT
FROM SUPERSTORE
FULL JOIN  RETURNED_ORDERS ON SUPERSTORE.ORDER_ID = RETURNED_ORDERS.ORDER_ID
WHERE RETURNED IS NULL AND CATEGORY = 'Furniture'
GROUP BY RETURNED, CATEGORY, SUPERSTORE.ORDER_ID
HAVING SUM(PROFIT) < 0
ORDER BY TOTAL_PROFIT ASC
LIMIT 10; 

-- 14. Join Superstore_Orders to Superstore_Returns, selecting all columns. First do an Inner Join. Then do a Left Join. Then a Right Join. Does the output change? And how? Why is it changing?

SELECT * FROM ORDERS
INNER JOIN RETURNED_ORDERS ON ORDERS.ORDER_ID = returned_orders.order_id;

SELECT * FROM ORDERS
LEFT JOIN RETURNED_ORDERS ON ORDERS.ORDER_ID = returned_orders.order_id;

SELECT * FROM ORDERS
RIGHT JOIN RETURNED_ORDERS ON ORDERS.ORDER_ID = returned_orders.order_id;

-- 15 p1. Join CUSTOMERS to CUSTOMER_SALES_REP. Can you work out how many customers do not have a Sales representative? HINT: Use a LEFT JOIN.

SELECT COUNT( CUSTOMERS.CUSTOMER_ID) AS CUSTOMERS
FROM CUSTOMERS
LEFT JOIN 
CUSTOMER_SALES_REP ON CUSTOMERS.CUSTOMER_ID = CUSTOMER_SALES_REP.CUSTOMER_ID
WHERE SALES_PERSON_ID IS NULL;


--15 p2. Join CUSTOMERS to CUSTOMER_SALES_REP. Can you work out how many customers do not have a Sales representative? HINT: Use a LEFT JOIN.

SELECT 
CASE
WHEN SALES_PERSON_ID IS NULL THEN 'NO_SALES_REP'
ELSE 'SALES_REP'
END AS SALES_REPS,
COUNT( CUSTOMERS.CUSTOMER_ID) AS CUSTOMERS
FROM
CUSTOMERS
LEFT JOIN
CUSTOMER_SALES_REP ON CUSTOMERS.CUSTOMER_ID = CUSTOMER_SALES_REP.CUSTOMER_ID
GROUP BY 
CASE 
WHEN SALES_PERSON_ID IS NULL THEN 'NO_SALES_REP'
ELSE 'SALES_REP'
END;

--15 p3. Add to your query from Part 2: Perform a further (INNER) Join to include the ORDERS table in your query. Why have the numbers changed?

SELECT 
CASE
WHEN SALES_PERSON_ID IS NULL THEN 'NO_SALES_REP'
ELSE 'SALES_REP'
END AS SALES_REPS,
COUNT( CUSTOMERS.CUSTOMER_ID) AS CUSTOMERS
FROM
CUSTOMERS
LEFT JOIN
CUSTOMER_SALES_REP ON CUSTOMERS.CUSTOMER_ID = CUSTOMER_SALES_REP.CUSTOMER_ID
INNER JOIN 
ORDERS ON CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID 
GROUP BY 
CASE 
WHEN SALES_PERSON_ID IS NULL THEN 'NO_SALES_REP'
ELSE 'SALES_REP'
END;

-- 16. Join ORDERS to PRODUCTS. To find how many times each product was sold in each Year. Sort so we can see the best selling product for a given Year.

SELECT YEAR(ORDER_DATE) AS YEAR, COUNT(YEAR) AS NUMBER_OF_PRODUCTS 
FROM ORDERS
INNER JOIN PRODUCTS ON ORDERS.PRODUCT_ID = PRODUCTS.PRODUCT_ID
GROUP BY YEAR
ORDER BY NUMBER_OF_PRODUCTS DESC;

-- 17. How many Regions have at least 4 different States with a total Profit > 7000?

SELECT REGION, COUNT(STATE) AS STATE_COUNT
FROM
(
SELECT REGION, STATE, SUM(PROFIT) AS TOTAL_PROFIT
FROM SUPERSTORE
GROUP BY REGION, STATE)
WHERE TOTAL_PROFIT > 7000
GROUP BY REGION
HAVING STATE_COUNT >=4;

-- EX9 Which month in the year 2021 has the biggest drop in month over month sales?
SELECT 
    MONTH(ORDER_DATE) AS MONTH,
    SUM(SALES) AS TOTAL_SALES,
   TOTAL_SALES - LAG(TOTAL_SALES, 1, 0) OVER (ORDER BY MONTH) AS diff_to_prev,
FROM SUPERSTORE
WHERE YEAR(ORDER_DATE) = '2021' 
GROUP BY MONTH
ORDER BY DIFF_TO_PREV ASC;

-- EX9 p2. Find our which Sub-Category is the biggest contributor for this drop during this month.
SELECT 
    SUB_CATEGORY,
    MONTH(ORDER_DATE) AS MONTH,
    SUM(SALES) AS TOTAL_SALES,
   TOTAL_SALES - LAG(TOTAL_SALES, 1, 0) OVER (PARTITION BY SUB_CATEGORY ORDER BY MONTH) AS diff_to_prev,
FROM SUPERSTORE
WHERE YEAR(ORDER_DATE) = '2021' AND MONTH IN (11,12) 
GROUP BY MONTH, SUB_CATEGORY
ORDER BY DIFF_TO_PREV;

-- EX10. Find the 3 month rolling sum of sales for the year 2021.

SELECT 
    MONTH(ORDER_DATE) AS Month,
    SUM(SALES) AS TOTAL_SALES,
    (LEAD(TOTAL_SALES,1) OVER (ORDER BY Month) +
        LEAD(TOTAL_SALES,2) OVER (ORDER BY Month) +
            LEAD(TOTAL_SALES,3) OVER (ORDER BY Month))  AS ROllING_3_MONTH_SALES
FROM SUPERSTORE
WHERE YEAR(ORDER_DATE) = '2021' 
GROUP BY MONTH
ORDER BY MONTH ASC;
