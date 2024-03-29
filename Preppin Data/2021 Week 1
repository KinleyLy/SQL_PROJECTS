// https://preppindata.blogspot.com/2021/01/2021-week-1.html
SELECT  
QUARTER(DATE) AS QUARTER,
TRIM(SPLIT_PART(store_bike,'-',1)) AS STORE, 
CASE 
        WHEN TRIM(SPLIT_PART(store_bike,'-',2)) LIKE 'R%' THEN 'Road'
        WHEN TRIM(SPLIT_PART(store_bike,'-',2)) LIKE 'Mo%' THEN 'Mountain'
        WHEN TRIM(SPLIT_PART(store_bike,'-',2)) LIKE 'Gr%' THEN 'Gravel'
        END AS BIKE,    
ORDER_ID, CUSTOMER_AGE, BIKE_VALUE, EXISTING_CUSTOMER,  
DAY(DATE) AS DAY_OF_MONTH,
FROM pd2021_wk01
WHERE ORDER_ID > 10;

