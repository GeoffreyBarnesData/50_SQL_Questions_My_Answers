-- Question 1 
--Write a solution to find the ids of products that are both low fat and recyclable.
--Return the result table in any order.

SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- Question 2
--Find the names of the customer that are either:
--    referred by any customer with id != 2.
--    not referred by any customer.
--Return the result table in any order.

SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

-- Question 3
--A country is big if:
--    it has an area of at least three million (i.e., 3000000 km2), or
--    it has a population of at least twenty-five million (i.e., 25000000).
--Write a solution to find the name, population, and area of the big countries.
--Return the result table in any order.

SELECT
  name,
  population,
  area
FROM World
WHERE area > 3000000 OR population > 25000000;

-- Question 4
--Write a solution to find all the authors that viewed at least one of their own articles.
--Return the result table sorted by id in ascending order.

SELECT DISTINCT author_id as id
FROM Views
WHERE author_id = viewer_id
ORDER BY id ASC;

-- Question 5
--Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the 
--tweet is strictly greater than 15.
--Return the result table in any order.

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;

-- Question 6
--Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
--Return the result table in any order.

SELECT 
    name,
    unique_id
FROM Employees 
LEFT JOIN EmployeeUNI ON Employees.id = EmployeeUNI.id;

-- Question 7
--Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
--Return the resulting table in any order.

SELECT 
  product_name,
  year,
  price
FROM Sales
LEFT JOIN Product ON Sales.product_id = Product.product_id;

-- Question 8
--Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types 
--of visits.
--Return the result table sorted in any order.

SELECT 
  customer_id, 
  COUNT(*) AS count_no_transactions
FROM 
  Visits AS v 
  LEFT JOIN Transactions AS t ON v.visit_id = t.visit_id 
WHERE 
  t.visit_id IS NULL 
GROUP BY 
  customer_id;

-- Question 9
--Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
--Return the result table in any order.

SELECT today.id
FROM Weather AS yesterday 
CROSS JOIN Weather AS today

WHERE DATEDIFF(today.recordDate,yesterday.recordDate) = 1
    AND today.temperature > yesterday.temperature;

-- Question 10
--There is a factory website that has several machines each running the same number of processes. Write a solution to find the average 
--time each machine takes to complete a process.
--The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to 
--complete every process on the machine divided by the number of processes that were run.
--The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.
--Return the result table in any order.

SELECT 
    Act_1.machine_id, 
    ROUND(AVG(Act_2.timestamp-Act_1.timestamp), 3) as processing_time 
FROM Activity Act_1
JOIN Activity Act_2 ON Act_1.activity_type='start' 
    AND Act_2.activity_type = 'end' 
    AND Act_1.machine_id = Act_2.machine_id 
    AND Act_1.process_id = Act_2.process_id
GROUP BY Act_1.machine_id;