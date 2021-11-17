Lab 3 - Índices e Monitorização
Nome: Nuno Reis		Número: 202000753
Etapa 1
--1)
select object_name(object_id) as TableName, name As ColumnName, is_identity
from sys.columns
where object_name(object_id)='Customer'
and name='CustomerID'

--2)
EXEC sys.sp_helpindex @objname = N'SalesLT.Customer'

--3)------
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;
SELECT 1.00 / (CAST(COUNT(DISTINCT CustomerID) AS DECIMAL(10,4))/ COUNT(CustomerID))
FROM SalesLT.Customer;

SELECT count(DISTINCT (select name
						from sys.columns
						where object_name(object_id)='Customer'))
FROM SalesLT.Customer;

SELECT count(DISTINCT name)
FROM SalesLT.Customer, sys.columns
where object_name(object_id)='Customer'

select name
from sys.columns
where object_name(object_id)='Customer'

SELECT 1.00 / (CAST(COUNT(DISTINCT Title) AS DECIMAL(10,4))/ COUNT(Title))
FROM SalesLT.Customerselect *from SalesLT.Customer

--4)


Etapa 2
--1)
SET STATISTICS IO ON

SELECT c.LastName , c.FirstName
FROM SalesLT.Customer c
WHERE CustomerID=100

SELECT c.LastName , c.FirstName
FROM SalesLT.Customer c
WHERE c.phone ='979-555-0163'

--2)


--3)


--4)


Etapa 3
--1)


--2)


Etapa 4
--1)


--2)


--3)
