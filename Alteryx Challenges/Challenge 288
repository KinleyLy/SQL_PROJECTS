// https://community.alteryx.com/t5/Weekly-Challenges/Challenge-288-Client-s-Rating-Analysis/td-p/830054

                                                //CHALLENGE 288
SELECT
    CT.STATUS AS EVALUATION,
    COUNT(PROFESSIONAL) AS NUMBER_OF_CUSTOMERS
FROM AYX288_CLIENTS CT
JOIN AYX288_REQUESTS_EVALUATIONS RE ON CT.CLIENT_ID = RE.REQUESTNUMBER 
WHERE RE.STATUS = 'Evaluated'
GROUP BY EVALUATION;
