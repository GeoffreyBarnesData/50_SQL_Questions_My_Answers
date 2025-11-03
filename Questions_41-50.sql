-- Question 41
--Write a solution to find the people who have the most friends and the most friends number.
--The test cases are generated so that only one person has the most friends.

WITH new_table AS (
    SELECT requester_id AS id 
    FROM RequestAccepted
UNION ALL
SELECT accepter_id AS id 
FROM RequestAccepted)

SELECT id, count(*) num  
FROM new_table 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Question 42
--Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
--    have the same tiv_2015 value as one or more other policyholders, and
--    are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
--Round tiv_2016 to two decimal places.

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
);

-- Question 43
--A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a 
--department is an employee who has a salary in the top three unique salaries for that department.
--Write a solution to find the employees who are high earners in each of the departments.
--Return the result table in any order.

SELECT Department, employee, salary 
FROM (
    SELECT 
        d.name AS Department, 
        e.name AS employee, 
        e.salary, 
        DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS dr
    FROM Employee e 
    JOIN Department d 
    ON e.DepartmentId= d.Id
) AS t 
WHERE t.dr <= 3;

-- Question 44
--Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
--Return the result table ordered by user_id.

SELECT 
    user_id, 
    CONCAT(
        UPPER(LEFT(name, 1)), LOWER(RIGHT(name, LENGTH(name)-1))
        ) AS name
FROM Users
ORDER BY user_id ASC;

-- Question 45
--Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always 
--starts with DIAB1 prefix.
--Return the result table in any order.

SELECT
    patient_id,
    patient_name,
    conditions
FROM Patients
WHERE conditions LIKE '%DIAB1%'

-- Question 46
--Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
--For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
--After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show 
--the Person table. The final order of the Person table does not matter.

DELETE 
FROM Person
WHERE id NOT IN (
    SELECT min_id FROM (
        SELECT MIN(id) as min_id
        FROM Person
        GROUP BY email
    ) AS temp
);

-- Question 47
--Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null 

SELECT 
    CASE 
        WHEN COUNT(DISTINCT salary) < 2 THEN NULL
        ELSE (
            SELECT MAX(salary)
            FROM Employee
            WHERE salary < (SELECT MAX(salary) FROM Employee)
        )
    END AS SecondHighestSalary
FROM Employee;

-- Question 48
--Write a solution to find for each date the number of different products sold and their names.
--The sold products names for each date should be sorted lexicographically.
--Return the result table ordered by sell_date.

SELECT 
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(
        DISTINCT product 
        ORDER BY product ASC 
        SEPARATOR ','
    ) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

-- Question 49
--Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
--Return the result table in any order.

SELECT 
    p.product_name,
    SUM(o.unit) as unit
FROM Products p
LEFT JOIN Orders o 
    ON p.product_id = o.product_id
    AND MONTH(o.order_date) = 2
GROUP BY p.product_id
HAVING SUM(o.unit) >= 100;

-- Question 50
--Write a solution to find the users who have valid emails.
--A valid e-mail has a prefix name and a domain where:
--    The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. 
--The prefix name must start with a letter.
--    The domain is '@leetcode.com'.
--Return the result table in any order.

SELECT *
FROM Users
WHERE REGEXP_LIKE(mail, 
    '^[A-Za-z][A-Za-z0-9_.-]*@leetcode.com$', 'c'
);