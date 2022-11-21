 /********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto - Queries das tabelas da base de dados antiga
 *		Nuno Reis (202000753)
 *		Turma: 2�L_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
 USE WWI_DS
 
 --City
select *
from dbo.City;

--Customer
select *
from dbo.Customer;

--Employee
select *
from dbo.Employee;

--Sale
select *
from dbo.Sale
order by [WWI Invoice ID];

--Stock Item
select *
from dbo.[Stock Item];

--States
select *
from dbo.States;

--lookup
select *
from dbo.lookup;


 /********************************************
 *	Queries de verifica��o de conformidade
 ********************************************/
-- N� de �Customers�
select count(*) as 'N� de Customers'
from dbo.Customer;

-- N� de �Customers� por �Category�
select Category as 'Categoria', count(*) as 'N� de Customers'
from dbo.Customer
group by Category;

-- Total de vendas por �Employee�
-- Apenas deve ser contabilizada uma venda, mesmo que esta contenha v�rios produtos associados
select employee as 'Funcionario', SUM(n) as 'N� de Vendas'
from (
	select e.Employee as employee, COUNT(distinct[WWI Invoice ID]) as n
	from dbo.Sale s
	join dbo.Employee e
	on s.[Salesperson Key] = e.[Employee Key]
	group by s.[Salesperson Key], e.Employee) as employees
group by employee;

-- Total monet�rio de vendas por �Stock Item�
-- Valor monet�rio obtido por quantity*Unit Price
select so.[Stock Item] as 'Produto', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from dbo.Sale sa
join dbo.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item]
order by so.[Stock Item];

-- Total monet�rio de vendas por ano por �Stock Item�
-- Valor monet�rio obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna �Delivery Date Key�
select so.[Stock Item] as 'Produto', year(sa.[Delivery Date Key]) as 'Ano', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from dbo.Sale sa
join dbo.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item], year(sa.[Delivery Date Key])
order by so.[Stock Item], year(sa.[Delivery Date Key]);

-- Total monet�rio de vendas por ano por �City�
-- Valor monet�rio obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna �Delivery Date Key�
select c.City as 'Cidade', year(s.[Delivery Date Key]) as 'Ano', sum(s.Quantity * s.[Unit Price]) as 'Total monetario'
from dbo.Sale s
join dbo.City c
on s.[City Key] = c.[City Key]
group by c.City, year(s.[Delivery Date Key])
order by c.City, year(s.[Delivery Date Key]);