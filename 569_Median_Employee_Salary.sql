/*---------------------------------------------------------------------------------
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| company      | varchar |
| salary       | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the company and the salary of one employee.
 

Write a solution to find the rows that contain the median salary of each company. 
While calculating the median, when you sort the salaries of the company, break the ties by id.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 1  | A       | 2341   |
| 2  | A       | 341    |
| 3  | A       | 15     |
| 4  | A       | 15314  |
| 5  | A       | 451    |
| 6  | A       | 513    |
| 7  | B       | 15     |
| 8  | B       | 13     |
| 9  | B       | 1154   |
| 10 | B       | 1345   |
| 11 | B       | 1221   |
| 12 | B       | 234    |
| 13 | C       | 2345   |
| 14 | C       | 2645   |
| 15 | C       | 2645   |
| 16 | C       | 2652   |
| 17 | C       | 65     |
+----+---------+--------+
Output: 
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 5  | A       | 451    |
| 6  | A       | 513    |
| 12 | B       | 234    |
| 9  | B       | 1154   |
| 14 | C       | 2645   |
+----+---------+--------+
Explanation: 
For company A, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 3  | A       | 15     |
| 2  | A       | 341    |
| 5  | A       | 451    | <-- median
| 6  | A       | 513    | <-- median
| 1  | A       | 2341   |
| 4  | A       | 15314  |
+----+---------+--------+
For company B, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 8  | B       | 13     |
| 7  | B       | 15     |
| 12 | B       | 234    | <-- median
| 11 | B       | 1221   | <-- median
| 9  | B       | 1154   |
| 10 | B       | 1345   |
+----+---------+--------+
For company C, the rows sorted are as follows:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 17 | C       | 65     |
| 13 | C       | 2345   |
| 14 | C       | 2645   | <-- median
| 15 | C       | 2645   | 
| 16 | C       | 2652   |
+----+---------+--------+
 
Follow up: Could you solve it without using any built-in or window functions?
--------------------------------------------------------------------------------*/
-- Solution1: Window Function
with cte1 as(select 
id,
company,
salary,
count(id) over(partition by company) as cnt, 
row_number() over (partition by company order by salary) as num
from Employee569)
select 
id,
company,
salary
from cte1
where 
num between cnt::numeric/2 and cnt::numeric/2 +1 

-- without window function
WITH totalEmployee AS(
	SELECT
		company,
        -- Get the total row of the company
		count(1) totalEmployee,
        -- Divide the total row of the company
		FLOOR(count(1) / 2.0) rowDivi
	FROM
		employee569
	GROUP BY company
)
SELECT
	sub.id ,
	sub.company ,
	sub.salary
FROM
	totalEmployee T
LEFT JOIN LATERAL(
	SELECT * FROM (
        -- sort by company and salary
		SELECT * FROM Employee569 ORDER BY company, salary
	)s
        -- match company
	WHERE s.company = T.company
        -- totalEmploye is an even number => just skip rowDivi - 1 and get only 2 row
        -- totalEmploye is an odd number => just skip rowDivi and get only 1 row
    LIMIT (SELECT CASE WHEN T.totalEmployee % 2 = 0 THEN 2 ELSE 1 END)
	OFFSET (SELECT CASE WHEN T.totalEmployee % 2 = 0 THEN T.rowDivi - 1 ELSE T.rowDivi END)
)sub ON TRUE
ORDER BY company


