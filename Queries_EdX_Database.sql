
-- check database for columns
SELECT 
    *
FROM
    course_users
LIMIT 1;
SELECT 
    *
FROM
    users
LIMIT 1;
SELECT 
    *
FROM
    course
LIMIT 1;
-- check database with class for # rows
SELECT 
    COUNT(*)
FROM
    course_users;
SELECT 
    COUNT(*)
FROM
    users;
SELECT 
    COUNT(*)
FROM
    course;


-- students in fall 2012 6.00x -- 6804
SELECT 
    COUNT(*)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2012_Fall'
        AND registered = 1;

-- students in spring 2013 6.00x -- 5775
SELECT 
    COUNT(*)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2013_Spring'
        AND registered = 1;

-- alternate
SELECT 
    Course_id, COUNT(*)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2012_Fall'
        OR course_id = 'MITx/6.00x/2013_Spring'
GROUP BY course_id;


-- average grade in fall 2012 6.00x - 0.0444, 4.4%
SELECT 
    AVG(grade)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2012_Fall';

-- average grade in spring 2013 6.00x - 0.02820, 2.8%
SELECT 
    AVG(grade)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2013_Spring';

-- average grade in fall 2012 6.00x without zeros - 0.2189, 21.9%
SELECT 
    AVG(grade)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2012_Fall'
        AND grade > 0;

-- average grade in spring 2013 6.00x - 0.1400, 14%
SELECT 
    AVG(grade)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2013_Spring'
        AND grade > 0;

-- What were the total number of enrollments for 6.00x over both terms? 12579
SELECT 
    COUNT(*)
FROM
    Course_users
WHERE
    course_id IN ('MITx/6.00x/2012_Fall' , 'MITx/6.00x/2013_Spring');
-- put another way
SELECT 
    COUNT(*)
FROM
    Course_users
WHERE
    course_id = 'MITx/6.00x/2012_Fall'
        OR course_id = 'MITx/6.00x/2013_Spring';

-- how many users have taken both courses, 32 rows returned
SELECT 
    userid_DI, COUNT(*)
FROM
    course_users
WHERE
    course_id IN ('MITx/6.00x/2012_Fall' , 'MITx/6.00x/2013_Spring')
GROUP BY userid_DI
HAVING COUNT(Course_id) > 1;


-- lets list the number of people in each course
SELECT 
    Course_id, COUNT(*)
FROM
    Course_users
GROUP BY course_id;
-- nicer header
SELECT 
    Course_id, COUNT(*) AS Enrollees
FROM
    Course_users
GROUP BY course_id;

-- enrollees in desc order
SELECT 
    Course_id, COUNT(*) AS Enrollees
FROM
    Course_users
GROUP BY course_id
ORDER BY Enrollees DESC;


--  Create the same list of enrollees in descending order, but include the course long title in the returned result. (Hint: JOIN)

SELECT 
    C.Course_Long_Title, COUNT(*) AS enrollees
FROM
    course_users CU
        INNER JOIN
    course C ON CU.course_id = C.course_id
GROUP BY c.course_long_title
ORDER BY enrollees DESC;

-- courses that have at least 4000 enrollees
SELECT 
    Course_id, COUNT(*) AS Enrollees
FROM
    Course_users
GROUP BY course_id
HAVING Enrollees > 4000
ORDER BY Enrollees DESC;

-- Now let's put together some statistics for the engagement for each course. How many people are registered, have viewed, have explored, and have become certified for each course?

SELECT 
    Course_id,
    SUM(registered) Registered,
    SUM(viewed) Viewed,
    SUM(explored) Explored,
    SUM(certified) Certified
FROM
    Course_users
GROUP BY course_id
ORDER BY SUM(registered) DESC;

-- using the course title with join -- combines different terms of same course
SELECT 
    C.Course_Long_Title,
    SUM(registered) Registered,
    SUM(viewed) Viewed,
    SUM(explored) Explored,
    SUM(certified) Certified
FROM
    course_users CU
        INNER JOIN
    course C ON CU.course_id = c.course_id
GROUP BY c.course_long_title
ORDER BY COUNT(*) DESC;


-- What fraction of users view, explore, or certify in the content in each course once they have registered?

SELECT 
    Course_id,
    SUM(viewed) / SUM(registered) AS FractionViewed,
    SUM(explored) / SUM(registered) AS FractionExplored,
    SUM(certified) / SUM(registered) AS FractionCertified
FROM
    Course_users
GROUP BY course_id;

-- using the course title with join -- combines different terms of same course
SELECT 
    C.Course_Long_Title,
    SUM(viewed) / SUM(registered) AS FractionViewed,
    SUM(explored) / SUM(registered) AS FractionExplored,
    SUM(certified) / SUM(registered) AS FractionCertified
FROM
    course_users CU
        INNER JOIN
    course C ON CU.course_id = c.course_id
GROUP BY C.Course_Long_Title;


-- list the classes taught at Harvard with more than 4000 enrollees:

SELECT 
    C.Course_id, COUNT(*) AS Enrollees
FROM
    Course C
        JOIN
    Course_Users CU ON C.course_id = CU.course_id
WHERE
    institution = 'HarvardX'
GROUP BY course_id
HAVING Enrollees > 4000
ORDER BY Enrollees DESC;


-- Option 2: use LIKE to find the HarvardX name inside the course_id

SELECT 
    cu.Course_id, COUNT(*) AS enrollees
FROM
    course_users CU
WHERE
    Course_id LIKE '%Harvard%'
GROUP BY Course_id
HAVING COUNT(*) > 4000
ORDER BY COUNT(*) DESC;

-- how many users have registered for more than three courses? 11

SELECT 
    u.userid_DI,
    u.Age,
    u.Country,
    u.LoE_DI,
    COUNT(cu.registered) AS registered
FROM
    Users u
        JOIN
    Course_Users cu ON (u.userid_DI = cu.userid_DI)
GROUP BY userid_DI
HAVING registered > 3;

-- How many users are there by country, ordered alphabetically
SELECT 
    Country, COUNT(*) AS enrollees
FROM
    edx.Users
GROUP BY Country
ORDER BY Country ASC;



SELECT 
    Country, AVG(Grade) AS AvgGrade
FROM
    Course_Users
        JOIN
    Users ON (Course_Users.Userid_DI = Users.Userid_DI)
WHERE
    certified = 1
GROUP BY Country
ORDER BY AvgGrade DESC;



-- Even in our moderately sized dataset, you'll notice that this query is taking a while!

SELECT 
    Country, AVG(Grade) AS AvgGrade
FROM
    Course
        JOIN
    Course_Users ON (Course.Course_ID = Course_Users.Course_ID)
        JOIN
    Users ON (Course_Users.Userid_DI = Users.Userid_DI)
WHERE
    institution = 'HarvardX'
        AND certified = 1
GROUP BY Country
ORDER BY AvgGrade DESC;

-- Left join
SELECT 
    Country, AVG(Grade) AS AvgGrade
FROM
    Course
        LEFT JOIN
    Course_Users ON (Course.Course_ID = Course_Users.Course_ID)
        LEFT JOIN
    Users ON (Course_Users.Userid_DI = Users.Userid_DI)
WHERE
    institution = 'HarvardX'
        AND certified = 1
GROUP BY Country
ORDER BY AvgGrade DESC;

-- MIT
-- TRIPLE JOIN!!
-- Even in our moderately sized dataset, you'll notice that this query is taking a while!

SELECT 
    Country, AVG(Grade) AS AvgGrade
FROM
    Course
        JOIN
    Course_Users ON (Course.Course_ID = Course_Users.Course_ID)
        JOIN
    Users ON (Course_Users.Userid_DI = Users.Userid_DI)
WHERE
    institution = 'MITx' AND certified = 1
GROUP BY Country
ORDER BY AvgGrade DESC;

-- Left join
SELECT 
    Country, AVG(Grade) AS AvgGrade
FROM
    Course
        LEFT JOIN
    Course_Users ON (Course.Course_ID = Course_Users.Course_ID)
        LEFT JOIN
    Users ON (Course_Users.Userid_DI = Users.Userid_DI)
WHERE
    institution = 'MITx' AND certified = 1
GROUP BY Country
ORDER BY AvgGrade DESC;


