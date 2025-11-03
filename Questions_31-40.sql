-- Question 31
--Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their 
--primary department. Note that when an employee belongs to only one department, their primary column is 'N'.
--Write a solution to report all the employees with their primary department. For employees who belong to one department, report their 
--only department.
--Return the result table in any order.

(SELECT 
    employee_id,
    department_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(employee_id) = 1)
UNION (
SELECT
    employee_id,
    department_id
FROM Employee
WHERE primary_flag = 'Y')
ORDER BY employee_id;

-- Question 32
--Report for every three line segments whether they can form a triangle.
--Return the result table in any order.

SELECT 
    x,
    y,
    z,
CASE WHEN (x + y) > z 
    AND (x + z) > y 
    AND (y + z) > x 
    THEN 'Yes' 
    ELSE 'No' end AS triangle
FROM Triangle;

-- Question 33
--Find all numbers that appear at least three times consecutively.
--Return the result table in any order.

SELECT DISTINCT l1.num AS consecutiveNums
FROM Logs AS l1, Logs AS l2, Logs AS l3
WHERE 
    l1.id = l2.id+1 
    AND l2.id = l3.id+1
    AND l1.num = l2.num
    AND l2.num = l3.num;

-- Question 34
--Write a solution to find the prices of all products on the date 2019-08-16.
--Return the result table in any order.

WITH final_price AS (
    SELECT DISTINCT product_id, 
    FIRST_VALUE(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) AS final_price
    FROM products 
    WHERE change_date <= '2019-08-16')


SELECT DISTINCT product_id,
    IFNULL(b.final_price, 10) as price
FROM products a
    LEFT JOIN final_price b USING (product_id)

-- Question 35
--There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people 
--who cannot board.
--Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases 
--are generated such that the first person does not exceed the weight limit.
--Note that only one person can board the bus at any given turn.

SELECT person_name
FROM Queue AS q1
WHERE 1000 >= (
    SELECT SUM(weight)
    FROM Queue AS q2
    WHERE q1.turn >= q2.turn
)
ORDER BY turn DESC
LIMIT 1;

-- Question 36
--Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
--    "Low Salary": All the salaries strictly less than $20000.
--    "Average Salary": All the salaries in the inclusive range [$20000, $50000].
--    "High Salary": All the salaries strictly greater than $50000.
--The result table must contain all three categories. If there are no accounts in a category, return 0.
--Return the result table in any order.

SELECT
c.category,
COALESCE(a.accounts_count, 0) AS accounts_count
FROM (
SELECT 'Low Salary' AS category, 1 AS ord UNION ALL
SELECT 'Average Salary', 2 AS ord UNION ALL
SELECT 'High Salary' AS category, 3 AS ord
) AS c
LEFT JOIN (
SELECT
CASE
WHEN income < 20000 THEN 'Low Salary'
WHEN income <= 50000 THEN 'Average Salary'
ELSE 'High Salary'
END AS category,
COUNT(account_id) AS accounts_count
FROM Accounts
GROUP BY category
) AS a
ON a.category = c.category
ORDER BY c.ord;

-- Question 37
--Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the 
--company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
--Return the result table ordered by employee_id.

SELECT e1.employee_id
FROM Employees AS e1
LEFT JOIN Employees AS e2
ON e1.manager_id = e2.employee_id
WHERE e1.salary < 30000
    AND e2.manager_id IS NULL
GROUP BY e1.employee_id

-- Question 38
--Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is 
--not swapped.
--Return the result table ordered by id in ascending order.

SELECT 
    CASE WHEN id = (SELECT MAX(id) FROM seat) AND id % 2 = 1
            THEN id 
        WHEN id % 2 = 1
            THEN id + 1
        ELSE id - 1
    END AS id,
    student
FROM seat
ORDER BY id;

-- Question 39
--Write a solution to:
--    Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
--    Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

(   SELECT u.name AS results
    FROM MovieRating AS mr 
    LEFT JOIN Users AS u
    ON (mr.user_id = u.user_id)
    GROUP BY mr.user_id
    ORDER BY COUNT(mr.movie_id) DESC, u.name 
    LIMIT 1 )
UNION (
  SELECT m.title AS results
  FROM MovieRating AS mr 
  LEFT JOIN Movies AS m
  ON (mr.movie_id = m.movie_id)
  WHERE mr.created_at LIKE '2020-02%'
  GROUP BY mr.movie_id
  ORDER BY AVG(mr.rating) DESC, m.title 
  LIMIT 1
);

-- Question 40
--You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
--Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount 
--should be rounded to two decimal places.
--Return the result table ordered by visited_on in ascending order.

SELECT DISTINCT 
    visited_on, 
    amount, 
    ROUND(amount/7, 2) AS average_amount
FROM (SELECT visited_on, 
      SUM(amount) OVER (
        ORDER BY visited_on RANGE BETWEEN INTERVAL 6 day PRECEDING AND CURRENT ROW) AS amount,
      DENSE_RANK() OVER (ORDER BY visited_on) AS rk
      FROM Customer) AS t
WHERE rk >= 7