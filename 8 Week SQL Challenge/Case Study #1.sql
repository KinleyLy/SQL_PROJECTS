-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
    CUSTOMER_ID,
    SUM(PRICE) AS TOTAL_SPENT,
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY CUSTOMER_ID;

-- 2. How many days has each customer visited the restaurant?

SELECT 
    CUSTOMER_ID,
    COUNT(DISTINCT ORDER_DATE) AS UNIQUE_DAYS_VISITED,
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY CUSTOMER_ID;

-- 3. What was the first item from the menu purchased by each customer?

WITH FD AS (
SELECT 
        SALES.CUSTOMER_ID,
        ORDER_DATE,
        ROW_NUMBER() OVER(PARTITION BY SALES.CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS rn,
        PRODUCT_NAME
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID, ORDER_DATE, PRODUCT_NAME
) 

SELECT 
        CUSTOMER_ID,
        PRODUCT_NAME AS FIRST_ORDER
FROM FD
WHERE RN = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH ITEMTOTALS AS (
SELECT
        PRODUCT_NAME,
        COUNT(SALES.PRODUCT_ID) AS TOTAL_PRODUCTS
FROM SALES
    JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY PRODUCT_NAME
),
MOSTPURCHASEDITEM AS (
SELECT
        PRODUCT_NAME,
        TOTAL_PRODUCTS,
        RANK() OVER (ORDER BY TOTAL_PRODUCTS DESC) AS PR
FROM ITEMTOTALS
)
SELECT
        PRODUCT_NAME,
        TOTAL_PRODUCTS
FROM MOSTPURCHASEDITEM
WHERE PR = 1
;

-- 5. Which item was the most popular for each customer?

WITH MOSTPURCHASEDITEM AS (
    SELECT
        SALES.CUSTOMER_ID,
        PRODUCT_NAME,
        COUNT(SALES.PRODUCT_ID) AS TOTAL_PRODUCTS,
        RANK() OVER (PARTITION BY SALES.CUSTOMER_ID ORDER BY TOTAL_PRODUCTS DESC) AS PR
   FROM SALES
    JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID, PRODUCT_NAME

)
    SELECT
        CUSTOMER_ID,
        PRODUCT_NAME,
        TOTAL_PRODUCTS,
    FROM MOSTPURCHASEDITEM
    WHERE PR = 1;


-- 6. Which item was purchased first by the customer after they became a member?

WITH JD AS (
SELECT 
        JOIN_DATE, 
        ORDER_DATE,
        SALES.CUSTOMER_ID, 
        PRODUCT_NAME,
        PRICE,
        RANK() OVER (PARTITION BY SALES.CUSTOMER_ID ORDER BY SALES.PRODUCT_ID ASC) AS RNK,
        ROW_NUMBER() OVER (PARTITION BY SALES.CUSTOMER_ID ORDER BY SALES.PRODUCT_ID ASC) AS RN
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
JOIN MEMBERS ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
WHERE JOIN_DATE >= ORDER_DATE
ORDER BY ORDER_DATE DESC
)
SELECT 
        CUSTOMER_ID,
        PRODUCT_NAME,
        ORDER_DATE
FROM JD
WHERE RNK = 1;

-- 7. Which item was purchased just before the customer became a member?

WITH JD AS (
SELECT 
        JOIN_DATE, 
        ORDER_DATE,
        SALES.CUSTOMER_ID, 
        PRODUCT_NAME,
        PRICE,
        RANK() OVER (PARTITION BY SALES.CUSTOMER_ID ORDER BY SALES.PRODUCT_ID ASC) AS RNK,
        ROW_NUMBER() OVER (PARTITION BY SALES.CUSTOMER_ID ORDER BY SALES.PRODUCT_ID ASC) AS RN
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
JOIN MEMBERS ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
WHERE JOIN_DATE >= ORDER_DATE
ORDER BY ORDER_DATE DESC
)
SELECT 
        CUSTOMER_ID,
        PRODUCT_NAME,
        ORDER_DATE
FROM JD
WHERE RNK = 1;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT
        SALES.CUSTOMER_ID,
        COUNT(SALES.PRODUCT_ID) AS TOTAL_ITEMS,
        SUM(PRICE) AS TOTAL_PRICE
FROM SALES
   JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
   JOIN MEMBERS ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
WHERE JOIN_DATE > ORDER_DATE
GROUP BY SALES.CUSTOMER_ID;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH PT AS (
SELECT
        SALES.CUSTOMER_ID,
           CASE
              WHEN PRODUCT_NAME = 'sushi' THEN SUM(PRICE) * 20
              ELSE SUM(PRICE) * 10 
              END AS POINTS
FROM SALES
JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID, Product_Name
)
SELECT
        CUSTOMER_ID,
        SUM(POINTS) AS POINTS
        FROM PT
        GROUP BY CUSTOMER_ID;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT 
        SALES.CUSTOMER_ID,
        SUM(CASE
            WHEN SALES.ORDER_DATE BETWEEN MEMBERS.JOIN_DATE AND DATEADD('day',6,MEMBERS.join_date) THEN PRICE * 20
            WHEN SALES.ORDER_DATE NOT BETWEEN MEMBERS.JOIN_DATE AND DATEADD('day',6,MEMBERS.join_date) AND PRODUCT_NAME = 'sushi' THEN PRICE * 20
            ELSE PRICE * 10
        END) AS POINTS
FROM SALES
    JOIN MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
    JOIN MEMBERS ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
WHERE DATE_TRUNC('month',ORDER_DATE) = '2021-01-01'
GROUP BY SALES.CUSTOMER_ID;
  
  
