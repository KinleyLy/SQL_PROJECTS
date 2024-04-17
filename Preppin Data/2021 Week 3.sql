WITH Combined_Data AS (
SELECT
    *
FROM(
WITH B AS(
SELECT 
    "Date",
     REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',1), '_','') AS CUSTOMER_TYPE,
    REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',2),'_','') AS PRODUCT,
    VALUE AS PRODUCTS_SOLD
FROM PD2021_WK03_BIRMINGHAM
UNPIVOT (
    VALUE FOR NEW_PRODUCTS IN ("New_-_Saddles", "New_-_Mudguards", "New_-_Wheels", "New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags","Existing_-_Saddles")
)
ORDER BY "Date" ASC
),
 MA AS (
SELECT 
    "Date",
     REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',1), '_','') AS CUSTOMER_TYPE,
    REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',2),'_','') AS PRODUCT,
    VALUE AS PRODUCTS_SOLD
FROM PD2021_WK03_MANCHESTER
UNPIVOT (
    VALUE FOR NEW_PRODUCTS IN ("New_-_Saddles", "New_-_Mudguards", "New_-_Wheels", "New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags","Existing_-_Saddles")
)
ORDER BY "Date" ASC
),
LE AS (
SELECT 
    "Date",
     REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',1), '_','') AS CUSTOMER_TYPE,
    REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',2),'_','') AS PRODUCT,
    VALUE AS PRODUCTS_SOLD
FROM PD2021_WK03_LEEDS
UNPIVOT (
    VALUE FOR NEW_PRODUCTS IN ("New_-_Saddles", "New_-_Mudguards", "New_-_Wheels", "New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags","Existing_-_Saddles")
)
ORDER BY "Date" ASC
),
 Y AS (
SELECT 
    "Date",
     REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',1), '_','') AS CUSTOMER_TYPE,
    REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',2),'_','') AS PRODUCT,
    VALUE AS PRODUCTS_SOLD
FROM PD2021_WK03_YORK
UNPIVOT (
    VALUE FOR NEW_PRODUCTS IN ("New_-_Saddles", "New_-_Mudguards", "New_-_Wheels", "New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags","Existing_-_Saddles")
)
ORDER BY "Date" ASC
),
 LO AS (
SELECT 
    "Date",
     REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',1), '_','') AS CUSTOMER_TYPE,
    REGEXP_REPLACE(SPLIT_PART(NEW_PRODUCTS,'-',2),'_','') AS PRODUCT,
    VALUE AS PRODUCTS_SOLD
FROM PD2021_WK03_BIRMINGHAM
UNPIVOT (
    VALUE FOR NEW_PRODUCTS IN ("New_-_Saddles", "New_-_Mudguards", "New_-_Wheels", "New_-_Bags","Existing_-_Saddles","Existing_-_Mudguards","Existing_-_Wheels","Existing_-_Bags","Existing_-_Saddles")
)
ORDER BY "Date" ASC
)

SELECT * FROM B
UNION ALL
SELECT * FROM MA
UNION ALL
SELECT * FROM LE
UNION ALL
SELECT * FROM Y
UNION ALL
SELECT * FROM LO
    ) combined_data   
)
SELECT
    PRODUCT,
    QUARTER("Date") AS Quarter,
    SUM(PRODUCTS_SOLD) AS PRODUCTS_SOLD
FROM COMBINED_DATA
GROUP BY QUARTER, PRODUCT;
