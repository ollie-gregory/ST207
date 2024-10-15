---------------
-- LECTURE W3_1
---------------

-- Q0
SELECT Bdate, Address
FROM employee
WHERE Fname='John' AND Minit='B' AND Lname='Smith';

-- Q1
SELECT Fname, Lname, Address
FROM employee, department
WHERE Dname='Research' AND Dnumber = Dno;

-- Q2
SELECT Pnumber, Dnum, Lname, Address, Bdate
FROM project, department, employee
WHERE Dnumber=Dno AND Mgr_ssn=Ssn AND Plocation='Stafford';

-- Q5
SELECT	E.Fname, E.Lname, S.Fname, S.Lname
 	FROM	EMPLOYEE AS E, EMPLOYEE AS S
	WHERE	E.Super_ssn=S.Ssn;

-- Q10
SELECT	Ssn, Dname
FROM	EMPLOYEE, DEPARTMENT;

-- Q4A
SELECT	DISTINCT Pnumber
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Lname='Smith'
UNION
SELECT DISTINCT Pnumber
FROM PROJECT, WORKS_ON, EMPLOYEE
WHERE Pnumber=Pno AND Essn=Ssn AND Lname='Smith';

-- Q16A
SELECT	Fname, Lname
FROM	EMPLOYEE
WHERE	Address LIKE “%Houston%”;

-- Q17A
SELECT E.Fname, E.Lname, 1.1 * E.Salary AS Increased_sal
FROM   EMPLOYEE AS E, WORKS_ON AS W, PROJECT AS P
WHERE  E.Ssn=W.Essn AND W.Pno=P.Pnumber AND P.Pname="ProductX";

-- Q18
SELECT   D.Dname, E.Lname, E.Fname, P.Pname
FROM     DEPARTMENT AS D, EMPLOYEE AS E, WORKS_ON AS W, PROJECT AS P
WHERE    D.Dnumber = E.Dno AND E.Ssn = W.Essn AND W.Pno = P.Pnumber
ORDER BY D.Dname, E.Lname, E.Fname;

-----------------------
-- INSERT/UPDATE/DELETE
-----------------------

-- U1
INSERT INTO EMPLOYEE
VALUES ('Richard', 'K', 'Marini', 653298653, '30/12/1962', '98 Oak Forest, Katy, TX', 'M', 37000, 555555500, 4);

-- U2
INSERT INTO EMPLOYEE(Fname, Lname, Dno, Ssn)
VALUES ('Richard','Marini',4,'653298653');

-- I1
CREATE TABLE WORKS_ON_INFO
 (Emp_name VARCHAR(15),
 	Proj_name VARCHAR(15),
  Hours_per_week DECIMAL(3,1));

-- I2
INSERT INTO WORKS_ON_INFO(Emp_name, Proj_name, Hours_per_week)
SELECT E.Lname, P.Pname, W.Hours
FROM EMPLOYEE E, PROJECT P, WORKS_ON W
WHERE P.Pnumber=W.Pno AND W.Essn=E.Ssn;

-- I3
CREATE TABLE D5EMPS AS
 SELECT E.*
 FROM   EMPLOYEE AS E
 WHERE  E.Dno = 5;

-- U3
UPDATE PROJECT
SET	Plocation = 'Bellaire', Dnum = 5
WHERE	Pnumber = 10;

-- U4
UPDATE EMPLOYEE
SET	Salary = Salary *1.1
WHERE	Dno  IN
(SELECT	Dnumber
 FROM  	DEPARTMENT
 WHERE 	Dname = 'Research');

---------------
-- LECTURE W3_2
---------------

-- Q18
SELECT Fname, Lname
FROM employee
WHERE Super_ssn IS NULL;

-- Q4A
SELECT DISTINCT Pnumber
FROM PROJECT
WHERE Pnumber IN
(SELECT Pnumber
 FROM PROJECT, DEPARTMENT, EMPLOYEE
 WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Lname='Smith'
UNION
 SELECT Pno
 FROM WORKS_ON, EMPLOYEE
 WHERE Essn=Ssn AND Lname='Smith');

-- QUERY SLIDE 8
SELECT DISTINCT Essn
FROM WORKS_ON
WHERE (Pno, Hours) IN
(SELECT Pno, Hours
 FROM WORKS_ON
 WHERE Essn=123456789);

-- VARIATION OF SLIDE 8
SELECT P.Pname, D.Dname
FROM PROJECT AS P, DEPARTMENT AS D
WHERE (Pnumber, Dnum) IN
(SELECT Pnumber, Dnum
 FROM PROJECT
 WHERE Plocation='Jacksonville');

 -- QUERY SLIDE 8
SELECT Lname, Fname
FROM employee
WHERE Salary >
(SELECT Salary
 FROM employee
 WHERE Dno=5);

-- Q16
 SELECT E.Fname, E.Lname
 FROM EMPLOYEE AS E
 WHERE E.Ssn IN
 (SELECT Essn
  FROM DEPENDENT AS D
  WHERE E.Fname = D.Dependent_name AND E.Sex=D.Sex);

-- Q16A
SELECT E.Fname, E.Lname
FROM   EMPLOYEE AS E, DEPENDENT AS D
WHERE  E.Ssn=D.Essn AND E.Sex=D.Sex AND E.Fname=D.Dependent_name;

-- Q6
SELECT Fname, Lname
FROM   Employee
WHERE  NOT EXISTS (SELECT *
                   FROM   DEPENDENT
                   WHERE  Ssn = Essn)

-- Q7
SELECT Fname, Lname
FROM   Employee
WHERE  EXISTS (SELECT *
               FROM   DEPENDENT
               WHERE  Ssn = Essn)
       AND EXISTS (SELECT *
                   FROM   Department
                   WHERE  Ssn = Mgr_Ssn)

-- Q17
SELECT DISTINCT Essn
FROM   WORKS_ON
WHERE  Pno IN (1,2,3);

-----------------
-- JOINED TABLES
-----------------

-- QUERY SLIDE 15
SELECT Fname, Lname, Address
FROM employee JOIN department ON Dno=Dnumber
WHERE Dname='Research';

-- Q8A
SELECT S.Lname AS Supervisor_Name, E.Lname AS Employee_Name
  FROM Employee AS S RIGHT OUTER JOIN EMPLOYEE AS E
    ON S.Ssn=E.Super_ssn

-- QUERY SLIDE 18
SELECT E.Lname AS Employee_Name,
       S.Lname AS Supervisor_Name
  FROM Employee AS E LEFT OUTER JOIN EMPLOYEE AS S
    ON E.Super_ssn = S.Ssn

-- QUERY SLIDE 19 (CROSS-JOIN)
SELECT *
  FROM Dependent
 CROSS JOIN Project

-- QUERY SLIDE 20 (MULTIWAY JOIN)
SELECT Pnumber, Dnum, Lname, Address, Bdate
  FROM PROJECT
  JOIN DEPARTMENT ON Dnum=Dnumber
  JOIN EMPLOYEE ON Mgr_ssn=Ssn
 WHERE Plocation='Stafford';

----------------
-- AGGREGATION
----------------

-- Q19
SELECT SUM (Salary), MAX (Salary),
       MIN (Salary), AVG (Salary)
FROM   EMPLOYEE;

-- Q20
SELECT SUM (Salary), MAX (Salary),  MIN (Salary), AVG (Salary)
FROM    employee JOIN department ON Dno=Dnumber
WHERE Dname='Research';

-- Q24
SELECT   Dno, COUNT (*), AVG (Salary)
FROM     EMPLOYEE
GROUP BY Dno;

-- Q25
SELECT   Pnumber, Pname, COUNT (*) as Number_employees
FROM     PROJECT, WORKS_ON
WHERE	 Pnumber=Pno
GROUP BY Pnumber, Pname;

-- Q26
SELECT   Pnumber, Pname, COUNT (*)
FROM     PROJECT, WORKS_ON
WHERE    Pnumber=Pno
GROUP BY	Pnumber, Pname
HAVING COUNT (*) > 2;

-- QUERY SLIDE 24 (WITH)
WITH BIGDEPTS (Dno) AS
     (SELECT   Dno
      FROM     EMPLOYEE
      GROUP BY Dno
      HAVING COUNT (*) > 5)
SELECT	Dno, COUNT (*)
FROM	EMPLOYEE
WHERE	Salary>40000 AND Dno IN BIGDEPTS
GROUP BY Dno;

-- QUERY SLIDE 25 (CASE)
SELECT Fname, Lname, Salary,
CASE
WHEN Salary >= 70000 THEN 'A'
WHEN Salary >= 40000 THEN 'B'
WHEN Salary >= 30000 THEN 'C'
ELSE 'D'
END as 'Salary_band'
FROM EMPLOYEE;
