/*
Case Statements
*/

SELECT *
FROM [SQL Tutorial].dbo.EmployeeDemographics;

-- cleaning up the data so that we are removing any null values and selecting the columns that we are only using.
SELECT FirstName, LastName, Age
FROM [SQL Tutorial].dbo.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

-- Here we created a column that shows us anyone who is older than 30 as 'old' and less then 30 as 'young'
SELECT FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'Old'
	ELSE 'Young'
END
FROM [SQL Tutorial].dbo.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

-- You can add as many 'when' statements as you want. Only thge first condition on thw when statement is always met first. 
SELECT FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM [SQL Tutorial].dbo.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

-- Here joined and used a case statement. You can also do simple mathematical computations in each WHEN statement. The whole case statement can even be named after the END.
SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * 0.10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * 0.05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * 0.000001)
	ELSE Salary + (Salary * 0.03)
END AS SalaryAfterRaise
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;


/*
	Having Clause
*/

-- Here we count how many people have are in different jobtitles.
SELECT JobTitle, COUNT(JobTitle)
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle;

-- We can't use 'WHERE' on here so we must use 'HAVING' to filter the count number. Must be used after the GROUP BY statement.
SELECT JobTitle, COUNT(JobTitle)
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1;

-- Here we look at the average salary that's greater than 45000. The 'HAVING' statement must be used after the GROUP BY and before ORDER BY statements.
SELECT JobTitle, AVG(Salary)
FROM [SQL Tutorial].dbo.EmployeeDemographics
JOIN [SQL Tutorial].dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary);

-- Here Holly Flax has 3 null values. So let's update it
SELECT *
FROM [SQL Tutorial].dbo.EmployeeDemographics;

-- This is how to update Holly's information. Use Update, then set the value according to the column, then specify 'WHERE' to that value.
UPDATE [SQL Tutorial].dbo.EmployeeDemographics
SET EmployeeID = 1012
WHERE FirstName = 'Holly' AND LastName = 'Flax';

-- Here we updated her Age and changed here 'male' gender to 'female'
UPDATE [SQL Tutorial].dbo.EmployeeDemographics
SET Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax';

-- Here we deleted a whole row with the data that contains employeeID 1005. BEFORE CAREFUL!!! YOU CAN'T GET DATA BACK THAT'S DELETED!!!
DELETE FROM [SQL Tutorial].dbo.EmployeeDemographics
WHERE EmployeeID = 1005;

/*
	Aliasing
*/

-- Here we used AS to change the column name to Fname, this is called an alias.
SELECT FirstName AS Fname
FROM [SQL Tutorial].dbo.EmployeeDemographics;

-- Here we can concatenate two fields from seperate columns by using '+'. We can add a space with ' ' between the words as well. Finally because we created a new column, we can alias it as Fullname.
SELECT FirstName + ' ' + LastName AS Fullname
FROM [SQL Tutorial].dbo.EmployeeDemographics;

-- Here we calculated the avg age of everyone and renamed the column. It's common to use aliasing when using aggregate functions.
SELECT AVG(Age) AS AvgAge
FROM [SQL Tutorial].dbo.EmployeeDemographics;

-- You can alias your table's name to make it easier for joining. If you do, you must prefix what you are selecting in the Select statement.
SELECT Demo.EmployeeID
FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo;

-- As you can see, it's much easier to read what you are joining together. It can get much messier with complex joinings.
SELECT Demo.EmployeeID, Sal.Salary
FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo
JOIN [SQL Tutorial].dbo.EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID;

-- Here we joined 3 tables, as you can see it's easier to read with aliasing
SELECT Demo.EmployeeID, Demo.Firstname, Demo.Lastname, Sal.JobTitle, Ware.Age
FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo
LEFT JOIN [SQL Tutorial].dbo.EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID
LEFT JOIN [SQL Tutorial].dbo.WareHouseEmployeeDemographics AS Ware
	ON Demo.EmployeeID = Ware.EmployeeID;


/*
	Partition By
*/

-- Here we use PARTITION BY, it's a must simpler aggregate function that allows use to essentailly create a column and with the number of counts for Gender. 
SELECT FirstName, LastName, Gender, Salary, COUNT(Gender) OVER(PARTITION BY Gender) AS TotalGender
FROM [SQL Tutorial].dbo.EmployeeDemographics Dem
JOIN [SQL Tutorial].dbo.EmployeeSalary Sal
	ON Dem.EmployeeID = Sal.EmployeeID;

-- The following two queries basically gives two tables with the same result as the above query. You would then have to join them together somehow to make it look exactly the same. Hence it's much easier to use PARTITION BY.
SELECT FirstName, LastName, Gender, Salary, COUNT(Gender)
FROM [SQL Tutorial].dbo.EmployeeDemographics Dem
JOIN [SQL Tutorial].dbo.EmployeeSalary Sal
	ON Dem.EmployeeID = Sal.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary;

SELECT COUNT(Gender)
FROM [SQL Tutorial].dbo.EmployeeDemographics Dem
JOIN [SQL Tutorial].dbo.EmployeeSalary Sal
	ON Dem.EmployeeID = Sal.EmployeeID
GROUP BY Gender;