-- Question 21
--If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is 
--called scheduled.
--The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer 
--has precisely one first order.
--Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

SELECT
    ROUND ((
       SUM(IF 
            (order_date = customer_pref_delivery_date, 1, 0))*100 
            / COUNT(*)
    ), 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id);

-- Question 22
--Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 
--decimal places. In other words, you need to determine the number of players who logged in on the day immediately following their 
--initial login, and divide it by the number of total players.

SELECT
    ROUND(
        COUNT(*) / (SELECT COUNT(DISTINCT player_id) FROM Activity)
    , 2) AS fraction
FROM (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
) AS a
JOIN Activity AS b
ON a.player_id = b.player_id AND DATEDIFF(b.event_date, a.first_date) = 1

-- Question 23
--Write a solution to calculate the number of unique subjects each teacher teaches in the university.
--Return the result table in any order.

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id

-- Question 24
--Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on 
--someday if they made at least one activity on that day.
--Return the result table in any order.

SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date > DATE_SUB('2019-07-27', INTERVAL 30 day) AND activity_date <= '2019-07-27'
GROUP BY activity_date;

-- Question 25
--Write a solution to find all sales that occurred in the first year each product was sold.
--    For each product_id, identify the earliest year it appears in the Sales table.
--    Return all sales entries for that product in that year.
--Return a table with the following columns: product_id, first_year, quantity, and price.
--Return the result in any order.

SELECT
    product_id,
    MIN(year) AS first_year,
    quantity,
    price
FROM Sales
GROUP BY product_id;

-- Question 26
--Write a solution to find all the classes that have at least five students.
--Return the result table in any order.

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;

-- Question 27
--Write a solution that will, for each user, return the number of followers.
--Return the result table ordered by user_id in ascending order.

SELECT 
    user_id,
    COUNT(DISTINCT follower_id) AS followers_count
FROM Followers
GROUP BY user_id;

-- Question 28
--A single number is a number that appeared only once in the MyNumbers table.
--Find the largest single number. If there is no single number, report null.

SELECT (
    SELECT num FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
    ORDER BY num DESC
    LIMIT 1) AS num;

-- Question 29
--Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
--Return the result table in any order.

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING count(DISTINCT product_key) = (SELECT count(product_key) FROM Product);

-- Question 30
--For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
--Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average 
--age of the reports rounded to the nearest integer.
--Return the result table ordered by employee_id.

SELECT 
    e1.employee_id,
    e1.name,
    COUNT(e2.employee_id) AS reports_count,
    ROUND(AVG(e2.age)) AS average_age
FROM Employees e1
INNER JOIN Employees e2 ON e1.employee_id = e2.reports_to
GROUP BY e1.employee_id
ORDER BY e1.employee_id;