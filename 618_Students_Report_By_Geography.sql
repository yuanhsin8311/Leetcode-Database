/*-----------------------------------------------------------------
(Hard)
Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.
 

A school has students from Asia, Europe, and America.

Write a solution to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The result format is in the following example.

 

Example 1:

Input: 
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output: 
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+
 

Follow up: If it is unknown which continent has the most students, 
could you write a solution to generate the student report?
----------------------------------------------------------------------------*/
-- SELF JOIN 
with tmp as (
select row_number() over(partition by continent order by name) as rank
, name
, continent 
from student
)
select america.name as America
, asia.name as Asia
, eu.name as Europe
from tmp america
    left outer join tmp asia on america.rank = asia.rank and asia.continent = 'Asia' and america.continent = 'America'
    left outer join tmp eu on america.rank = eu.rank and eu.continent = 'Europe' and america.continent = 'America'
where america.continent = 'America'

-- CASE WHEN 
with cte1 as 
(select 
row_number() over (partition by continent order by name) as rk,
name, 
continent
from Student)
select 
max(case when continent = 'America' then name end) as America,
max(case when continent = 'Asia' then name end) as Asia,
max(case when continent = 'Europe' then name end) as Europe
from cte1
group by rk
order by rk
