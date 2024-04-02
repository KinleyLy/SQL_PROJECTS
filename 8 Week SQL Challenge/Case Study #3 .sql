--1. How many customers has Foodie-Fi ever had? (Trial and paying)

SELECT 
    COUNT(DISTINCT CUSTOMER_ID) AS NUMBER_OF_CUSTOMERS
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID;

--1. How many customers has Foodie-Fi ever had? (ONLY paying)

SELECT 
    COUNT(DISTINCT CUSTOMER_ID) AS NUMBER_OF_CUSTOMERS
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID LIKE ANY ('1','2','3');

--2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT DATE_TRUNC('month', START_DATE) AS MONTH,
COUNT(DISTINCT CUSTOMER_ID) AS NUBMER_OF_CUSTOMERS
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = '0'
GROUP BY MONTH
ORDER BY MONTH ASC;

--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT 
    PLAN_NAME,
    COUNT(CUSTOMER_ID) AS NUMBER_OF_EVENTS
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE DATE_TRUNC('year',start_date) >= '2021-01-01'
GROUP BY PLAN_NAME;

--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name (NO Duplicate Customer ID)
WITH RO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             row_number() over(partition by CUSTOMER_ID order by START_DATE desc) as rn
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE DATE_TRUNC('year',start_date) >= '2021-01-01'
)

select 
    PLAN_NAME,
    COUNT(*) AS NUMBER_OF_EVENTS
from RO
where rn = 1 
GROUP BY PLAN_NAME;

--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

WITH RO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             row_number() over(partition by CUSTOMER_ID order by START_DATE desc) as rn
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
)

select 
    PLAN_NAME,
    COUNT(DISTINCT CUSTOMER_ID) AS NUMBER_OF_CUSTOMERS,
    ROUND(100 * RATIO_TO_REPORT(NUMBER_OF_CUSTOMERS) OVER (), 1) AS PERCENT
from RO
where rn = 1 
GROUP BY PLAN_NAME;

--5 How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH customer_plans AS (
    SELECT
        customer_id,
        COUNT(DISTINCT PLN.plan_id) AS num_plans,
        MAX(CASE WHEN PLN.plan_id = 0 THEN 1 ELSE 0 END) AS has_plan_0,
        MAX(CASE WHEN PLN.plan_id = 4 THEN 1 ELSE 0 END) AS has_plan_4
    FROM PLANS AS PLN
    JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
    GROUP BY
        customer_id
)
SELECT
    CASE
        WHEN num_plans = 2 AND has_plan_0 = 1 AND has_plan_4 = 1 THEN 'Immediately Churned'
        ELSE 'Others'
    END AS customer_category,
    COUNT(*) AS customer_count,
   ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(),0) AS percent_of_total
FROM
    customer_plans
GROUP BY
    customer_category;
    
--6. What is the number and percentage of customer plans after their initial free trial?

WITH RO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             row_number() over(partition by CUSTOMER_ID order by START_DATE desc) as rn
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID != 0
)

select 
    PLAN_NAME,
    COUNT(*) AS NUMBER_OF_CUSTOMERS,
    ROUND(100 * RATIO_TO_REPORT(NUMBER_OF_CUSTOMERS) OVER (), 1) AS PERCENT
from RO
where rn = 1 
GROUP BY PLAN_NAME;

--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31? (Reworded to upto and including 2020-12-31)

WITH RO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             row_number() over(partition by CUSTOMER_ID order by START_DATE desc) as rn
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE START_DATE <= '2020-12-31'
)

select 
    PLAN_NAME,
    COUNT(*) AS NUMBER_OF_CUSTOMERS,
    ROUND(100 * RATIO_TO_REPORT(NUMBER_OF_CUSTOMERS) OVER (), 1) AS PERCENT
from RO
where rn = 1 
GROUP BY PLAN_NAME;

-- 8. How many customers have upgraded to an annual plan in 2020?

WITH RO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             row_number() over(partition by CUSTOMER_ID order by START_DATE desc) as rn
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 3 AND START_DATE <= '2020-12-31'
)

select 
    PLAN_NAME,
    COUNT(*) AS NUMBER_OF_CUSTOMERS
from RO
where rn = 1 
GROUP BY PLAN_NAME;

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH TRIAL AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 0 
),
    ANNUAL AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 3 
)

select
  ROUND(AVG(DATEDIFF('day',TRIAL.START_DATE,ANNUAL.START_DATE)),1) AS AVG_DAYS
from TRIAL
JOIN ANNUAL ON TRIAL.CUSTOMER_ID = ANNUAL.CUSTOMER_ID;

--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH TRIAL AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE AS TRIAL_START
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 0 
),
    ANNUAL AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE AS ANNUAL_START
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 3 
)

select
CASE
    WHEN DATEDIFF('days',trial_start,annual_start)<=30  THEN '0-30'
    WHEN DATEDIFF('days',trial_start,annual_start)<=60  THEN '31-60'
    WHEN DATEDIFF('days',trial_start,annual_start)<=90  THEN '61-90'
    WHEN DATEDIFF('days',trial_start,annual_start)<=120  THEN '91-120'
    WHEN DATEDIFF('days',trial_start,annual_start)<=150  THEN '121-150'
    WHEN DATEDIFF('days',trial_start,annual_start)<=180  THEN '151-180'
    WHEN DATEDIFF('days',trial_start,annual_start)<=210  THEN '181-210'
    WHEN DATEDIFF('days',trial_start,annual_start)<=240  THEN '211-240'
    WHEN DATEDIFF('days',trial_start,annual_start)<=270  THEN '241-270'
    WHEN DATEDIFF('days',trial_start,annual_start)<=300  THEN '271-300'
    WHEN DATEDIFF('days',trial_start,annual_start)<=330  THEN '301-330'
    WHEN DATEDIFF('days',trial_start,annual_start)<=360  THEN '331-360'
    END as PERIODS,
COUNT(TRIAL.customer_id) as customer_count
from TRIAL
JOIN ANNUAL ON TRIAL.CUSTOMER_ID = ANNUAL.CUSTOMER_ID
GROUP BY PERIODS;

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH BASIC AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 1 
),
    PRO AS(
select Plan_Name,
             PLN.PLAN_ID,
             CUSTOMER_ID,
             START_DATE
FROM PLANS AS PLN
JOIN SUBSCRIPTIONS AS SUB ON PLN.PLAN_ID = SUB.PLAN_ID
WHERE PLN.PLAN_ID = 2 
)

select
   PRO.CUSTOMER_ID,
   BASIC.START_DATE,
   PRO.START_DATE
from BASIC
JOIN PRO ON BASIC.CUSTOMER_ID = PRO.CUSTOMER_ID
WHERE BASIC.START_DATE > PRO.START_DATE
AND DATE_PART('year',PRO.START_DATE);
