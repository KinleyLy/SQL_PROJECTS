// https://preppindata.blogspot.com/2023/06/2023-week-23-is-it-teacher-or-student.html

WITH 
SR AS (
    SELECT
        STUDENT_ID,
        SUBJECT,
        GRADE
FROM PD2023_WK23_RESULTS
UNPIVOT(
        GRADE FOR SUBJECT IN (
            ENGLISH,
            ECONOMICS,
            PSYCHOLOGY
        )
    ) AS SR
),
RANKGRADES AS (
    SELECT 
        SUBJECT,
        AVG(GRADE) AS GRADE,
        CLASS,
        ROW_NUMBER() OVER (PARTITION BY SUBJECT ORDER BY AVG(GRADE)) AS RANK
    FROM PD2023_WK23_STUDENT_INFO SI
    JOIN SR ON SI.X_STUDENT_ID = SR.STUDENT_ID
    GROUP BY SUBJECT, CLASS
)
SELECT
    SUBJECT,
    GRADE,
    CLASS
FROM RANKGRADES
WHERE RANK = 1;
