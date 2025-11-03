-- Question 11
--Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
--Return the result table in any order.

SELECT 
    e.name,
    b.bonus
FROM Employee AS e
LEFT JOIN Bonus AS b ON e.empId = b.empId
WHERE b.bonus < 1000 OR b.bonus IS NULL;

-- Question 12
--Write a solution to find the number of times each student attended each exam.
--Return the result table ordered by student_id and subject_name.

SELECT
    s.student_id,
    s.student_name,
    su.subject_name,
    COUNT(e.student_id) AS attended_exams
FROM Students AS s
CROSS JOIN Subjects AS su
LEFT JOIN Examinations AS e
    ON s.student_id = e.student_id
    AND su.subject_name = e.subject_name

GROUP BY s.student_id, s.student_name, su.subject_name
ORDER BY s.student_id, s.student_name, su.subject_name;

-- Question 13
--Write a solution to find managers with at least five direct reports.
--Return the result table in any order.

SELECT name
FROM Employee
WHERE Id IN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);

-- Question 14
--The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
--Write a solution to find the confirmation rate of each user.
--Return the result table in any order.

SELECT 
    s.user_id,
    CASE WHEN c.user_id IS NULL THEN 0
         ELSE ROUND(
            SUM(c.action = 'confirmed') / 
            COUNT(c.user_id), 2) 
    END AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY s.user_id;

-- Question 15
--Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
--Return the result table ordered by rating in descending order.

SELECT 
    id,
    movie,
    description,
    rating
FROM Cinema
WHERE description != 'boring'
    AND (id/2) != ROUND(id/2, 0)
ORDER BY rating DESC;

-- Question 16
--Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.
--Return the result table in any order.

SELECT 
    p.product_id,
    ROUND((
        CASE WHEN units = 0
                THEN 0
            ELSE SUM(p.price*u.units) / SUM(u.units)
        END) , 2) AS average_price
FROM Prices AS p
LEFT JOIN UnitsSold AS u
    ON p.product_id = u.product_id
    AND u.purchase_date >= p.start_date
    AND u.purchase_date <= p.end_date
GROUP BY p.product_id;

-- Question 17
--Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
--Return the result table in any order.

SELECT
    p.project_id,
    ROUND(
        SUM(e.experience_years) / COUNT(p.employee_id)
    , 2) AS average_years
FROM Employee AS e
LEFT JOIN Project AS p
ON p.employee_id = e.employee_id
GROUP BY p.project_id;

-- Question 18
--Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
--Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

SELECT 
    r.contest_id,
    ROUND((
        COUNT(DISTINCT r.user_id) * 100.0 / (
            SELECT COUNT(*) 
            FROM Users)
    ), 2) AS percentage
FROM Users AS u
LEFT JOIN Register AS r
ON u.user_id = r.user_id

GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC;

-- Question 19
--We define query quality as:
--    The average of the ratio between query rating and its position.
--We also define poor query percentage as:
--    The percentage of all queries with rating less than 3.
--Write a solution to find each query_name, the quality and poor_query_percentage.
--Both quality and poor_query_percentage should be rounded to 2 decimal places.
--Return the result table in any order.

SELECT
    query_name,
    ROUND(AVG((rating / position)), 2) AS quality,
    ROUND(AVG(if (rating<3, 1, 0))*100, 2) AS poor_query_percentage
FROM Queries

GROUP BY query_name

-- Question 20
--Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
--Return the result table in any order.

SELECT
    LEFT(trans_date, 7) AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE 
        WHEN state = 'approved' THEN amount 
        ELSE 0 
        END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

