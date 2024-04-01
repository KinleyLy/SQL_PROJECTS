// https://preppindata.blogspot.com/2023/01/2023-week-4-new-customers.html

WITH RANKED_DATA AS (
SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY ID ORDER BY JOINING_DATE ASC) AS rn
FROM(
WITH JANUARY AS (
SELECT 
   ID,
    TO_DATE('1'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_JANUARY
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS JANUARY
),

FEBUARY AS(
SELECT 
    ID,
    TO_DATE('2'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_FEBRUARY
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS FEBUARY
),

MARCH AS (
SELECT 
     ID,
    TO_DATE('3'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_MARCH
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS MARCH
),

APRIL AS (
SELECT 
      ID,
    TO_DATE('4'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_APRIL
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS APRIL
),

MAY AS (
SELECT 
   ID,
    TO_DATE('5'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_MAY
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS MAY
),

JUNE AS (
SELECT 
   ID,
    TO_DATE('6'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_JUNE
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS JUNE
),

JULY AS (
SELECT 
   ID,
    TO_DATE('7'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_JULY
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS JULY
),

AUGUST AS (
SELECT 
   ID,
    TO_DATE('8'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_AUGUST
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS AUGUST
),

SEPTEMBER AS (
SELECT 
    ID,
    TO_DATE('9'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_SEPTEMBER
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS SEPTEMBER
),

OCTOBER AS (
SELECT 
   ID,
    TO_DATE('10'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_OCTOBER
PIVOT (
    MAX(VALUE) FOR DEMAGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS OCTOBER
),

NOVEMBER AS (
SELECT 
   ID,
    TO_DATE('11'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_NOVEMBER
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS NOVEMBER
),

DECEMBER AS (
SELECT 
    ID,
    TO_DATE('12'||'-'||JOINING_DAY||'-'||'2023', 'MM-DD-YYYY') AS JOINING_DATE,
    "'Ethnicity'" AS ETHNICITY,
    "'Account Type'" AS ACCOUNT_TYPE,
    "'Date of Birth'" AS DATE_OF_BIRTH
FROM PD2023_WK04_DECEMBER
PIVOT (
    MAX(VALUE) FOR DEMOGRAPHIC IN ('Ethnicity', 'Account Type', 'Date of Birth')
) AS DECEMBER
)


SELECT * FROM JANUARY
UNION ALL
SELECT * FROM FEBUARY
UNION ALL
SELECT * FROM MARCH
UNION ALL
SELECT * FROM APRIL
UNION ALL
SELECT * FROM MAY
UNION ALL
SELECT * FROM JUNE
UNION ALL
SELECT * FROM JULY
UNION ALL
SELECT * FROM AUGUST
UNION ALL
SELECT * FROM SEPTEMBER
UNION ALL
SELECT * FROM OCTOBER
UNION ALL
SELECT * FROM NOVEMBER
UNION ALL
SELECT * FROM DECEMBER

    ) combined_data   
)
SELECT
  ID,
  JOINING_DATE, 
  ETHNICITY,
  ACCOUNT_TYPE,
  DATE_OF_BIRTH
FROM RANKED_DATA
WHERE rn = 1;
