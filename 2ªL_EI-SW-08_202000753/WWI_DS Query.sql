/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto - Queries das tabelas da base de dados antiga
*		Nuno Reis (202000753)
*		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
USE WWI_DS
 
--City
select distinct Country
from dbo.City
order by Country;

select distinct Continent
from dbo.City
order by Continent;

select distinct City
from dbo.City
order by City;

select distinct [State Province]
from dbo.City
order by [State Province];

--States
select *
from dbo.States
order by name;

--lookup
select *
from dbo.lookup
order by name;


--Customer
select distinct Category
from dbo.Customer
order by Category;

select distinct [Buying Group]
from dbo.Customer
order by [Buying Group];

select distinct Customer
from dbo.Customer
order by Customer;

select *
from dbo.Customer;

--Employee
select distinct [Preferred Name]
from dbo.Employee
order by [Preferred Name];

select distinct Employee
from dbo.Employee
order by Employee;

select *
from dbo.Employee;

--Sale
select distinct Package
from dbo.Sale
order by Package;

select distinct [WWI Invoice ID]
from dbo.Sale
order by [WWI Invoice ID];

select *
from dbo.Sale
order by [WWI Invoice ID];

--Stock Item
select distinct [Selling Package]
from dbo.[Stock Item]
order by [Selling Package];

select distinct [Buying Package]
from dbo.[Stock Item]
order by [Buying Package];

select distinct Brand
from dbo.[Stock Item]
order by Brand;

select distinct [Is Chiller Stock]
from dbo.[Stock Item]
order by [Is Chiller Stock];

select distinct [Tax Rate]
from dbo.[Stock Item]
order by [Tax Rate];

select *
from dbo.[Stock Item]
order by [Stock Item];

/********************************************
*	Queries de verificação de conformidade
********************************************/
-- Nº de “Customers”
select count(*) as 'Nº de Customers'
from dbo.Customer;

-- Nº de “Customers” por “Category”
select Category as 'Categoria', count(*) as 'Nº de Customers'
from dbo.Customer
group by Category;

-- Total de vendas por “Employee”
-- Apenas deve ser contabilizada uma venda, mesmo que esta contenha vários produtos associados
select employee as 'Funcionario', SUM(n) as 'Nº de Vendas'
from (
	select e.Employee as employee, COUNT(distinct[WWI Invoice ID]) as n
	from dbo.Sale s
	join dbo.Employee e
	on s.[Salesperson Key] = e.[Employee Key]
	group by s.[Salesperson Key], e.Employee) as employees
group by employee;

-- Total monetário de vendas por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
select so.[Stock Item] as 'Produto', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from dbo.Sale sa
join dbo.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item]
order by so.[Stock Item];

-- Total monetário de vendas por ano por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
select so.[Stock Item] as 'Produto', year(sa.[Delivery Date Key]) as 'Ano', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from dbo.Sale sa
join dbo.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item], year(sa.[Delivery Date Key])
order by so.[Stock Item], year(sa.[Delivery Date Key]);

-- Total monetário de vendas por ano por “City”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
select ci.City as 'Cidade', year(s.[Delivery Date Key]) as 'Ano', sum(s.Quantity * s.[Unit Price]) as 'Total monetario'
from dbo.Sale s
join dbo.Customer cu
on s.[Customer Key] = cu.[Customer Key]
join dbo.City ci
on cu.Customer like '%' + ci.City + '%'
group by ci.City, year(s.[Delivery Date Key])
order by ci.City, year(s.[Delivery Date Key]);

select ci.City
from dbo.Sale s
join dbo.Customer cu
on s.[Customer Key] = cu.[Customer Key]
join dbo.City ci
on cu.Customer like '%' + ci.City + '%'
where ci.City like 'Abbottsburg'

select year(s.[Delivery Date Key]) as 'Ano', sum(s.Quantity * s.[Unit Price]) as 'Total monetario'
from dbo.Sale s
group by year(s.[Delivery Date Key])