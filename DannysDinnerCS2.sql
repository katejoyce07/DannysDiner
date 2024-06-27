
//PART A Q1
SELECT COUNT(order_id)
FROM CUSTOMER_ORDERS;

//Q2
SELECT COUNT(DISTINCT order_id) AS NUMBER_OF_ORDERS
FROM CUSTOMER_ORDERS;

//Q3
SELECT COUNT (order_id)
FROM RUNNER_ORDERS
WHERE PICKUP_TIME IS NOT NULL;

//Q4
SELECT COUNT(*) as pizzas_delivered,
        pizza_name 
FROM CUSTOMER_ORDERS AS C
INNER JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
INNER JOIN PIZZA_NAMES AS P ON P.PIZZA_ID=C.PIZZA_ID
WHERE PICKUP_TIME <> 'null'
group BY PIZZA_NAME;

//Q5
SElECT CUSTOMER_ID,
        COUNT(*) as pizzas_delivered,
        pizza_name 
FROM CUSTOMER_ORDERS AS C
INNER JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
INNER JOIN PIZZA_NAMES AS P ON P.PIZZA_ID=C.PIZZA_ID
WHERE PICKUP_TIME <> 'null'
group BY PIZZA_NAME, CUSTOMER_ID;

//Q6
SElECT MAX(pizza_id) AS PIZZA_ORDERED
FROM CUSTOMER_ORDERS AS C
INNER JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
WHERE PICKUP_TIME <> 'null';

//Q7
SELECT CUSTOMER_ID,
       CASE WHEN (RLIKE(exclusions, '[0-9].*') = TRUE OR RLIKE(EXTRAS, '[0-9].*') = TRUE) THEN 1 
           ELSE 0 
           END AS changes,
        COUNT(PIZZA_ID) AS NO_CHANGES
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY customer_id, changes
ORDER BY CUSTOMER_ID, changes;

//Q8
SELECT 
       CASE WHEN (RLIKE(exclusions, '[0-9].*') = TRUE and RLIKE(EXTRAS, '[0-9].*') = TRUE) THEN 1 
           ELSE 0 
           END AS changes,
        COUNT(PIZZA_ID) AS NO_CHANGES
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY changes
ORDER BY CHANGES DESC
LIMIT 1;


//Q9
SELECT HOUR(ORDER_TIME) AS HOUR_OF_DAY,
        COUNT(ORDER_ID)
FROM CUSTOMER_ORDERS
GROUP BY HOUR_OF_DAY
ORDER BY HOUR_OF_DAY;

//Q10
SELECT day(ORDER_TIME) AS DAY_OF_WEEK,
        COUNT(ORDER_ID)
FROM CUSTOMER_ORDERS
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

//Recursive CTEs

WITH NUMBERS AS (
SELECT 1 as n
UNION ALL 
SELECT n + 1
FROM NUMBERS
WHERE N <24
)


//PART B Q1
SELECT date_trunc('week', registration_date)
FROM RUNNERS;

//Q2
SELECT RUNNER_ID,
  AVG(TIMEDIFF('MINUTE',ORDER_TIME,PICKUP_TIME::DATETIME)) AS AVG_TIME
FROM RUNNER_ORDERS AS R
JOIN CUSTOMER_ORDERS AS C ON C.ORDER_ID = R.ORDER_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY RUNNER_ID;

//Q3
WITH CTE AS(
SELECT C.ORDER_ID,
COUNT(PIZZA_ID) AS NUMBER_OF_PIZZA,
AVG(TIMEDIFF(minute,ORDER_TIME,PICKUP_TIME::DATETIME)) AS PREP_TIME
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R ON R.ORDER_ID=C.ORDER_ID
WHERE PICKUP_TIME <> 'null'
GROUP BY C.ORDER_ID) 

SELECT NUMBER_OF_PIZZA,
AVG(PREP_TIME) AS AVG_TIME
FROM CTE
GROUP BY NUMBER_OF_PIZZA;

