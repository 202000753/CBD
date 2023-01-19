/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto - Queries das tabelas da base de dados nova
*		Nuno Reis (202000753)
*		Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
 USE WWIGlobal

/********************************************
*	Queries de verificação de conformidade
********************************************/
-- Nº de “Customers”
--Nova
select COUNT(*)
from RH.Customer;

--Velha
select count(*) as 'Nº de Customers'
from OldData.Customer;

-- Nº de “Customers” por “Category”
--Nova
select ca.CatName as 'Categoria', COUNT(*) as 'Nº de Customers'
from RH.Category ca
join RH.Region_Category rc
on rc.Reg_CatCategoryId = ca.CatId
join RH.Customer cu
on rc.Reg_CatId = cu.CusRegion_CategoryId
group by ca.CatName
order by ca.CatName;

--Velha
select Category as 'Categoria', count(*) as 'Nº de Customers'
from OldData.Customer
group by Category
order by Category;

-- Total de vendas por “Employee”
-- Apenas deve ser contabilizada uma venda, mesmo que esta contenha vários produtos associados
--Nova
select s.SysUseName as 'Funcionario', a.n as 'Nº de Vendas'
from RH.Employee e
join RH.SysUser s
on e.EmpUserId = s.SysUseId
join (select SalEmployeeId as e, COUNT(*) as n
		from Sales.Sale
		group by SalEmployeeId) a
on e.EmpUserId = a.e
order by s.SysUseName;

--Velha
select employee as 'Funcionario', SUM(n) as 'Nº de Vendas'
from (
	select e.Employee as employee, COUNT(distinct[WWI Invoice ID]) as n
	from OldData.Sale s
	join OldData.Employee e
	on s.[Salesperson Key] = e.[Employee Key]
	group by s.[Salesperson Key], e.Employee) as employees
group by employee
order by employee;

-- Total monetário de vendas por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
--Nova
select p.ProdName as 'Produto', sum(pps.ProdProm_SalQuantity * p.ProdUnitPrice) as 'Total monetario'
from Sales.Sale s 
join Sales.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join Storage.Product_Promotion pp
on pp.Prod_PromProductPromotionId = pps.ProdProm_SalProductPromotionId
join Storage.Product p
on p.ProdId = pp.Prod_PromProductId
group by p.ProdName
order by p.ProdName;

--Velha
select so.[Stock Item] as 'Produto', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from OldData.Sale sa
join OldData.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item]
order by so.[Stock Item];

-- Total monetário de vendas por ano por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
--Nova
select p.ProdName as 'Produto', year(s.SalDate) as 'Ano', sum(pps.ProdProm_SalQuantity * p.ProdUnitPrice) as 'Total monetario'
from Sales.Sale s 
join Sales.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join Storage.Product_Promotion pp
on pp.Prod_PromProductPromotionId = pps.ProdProm_SalProductPromotionId
join Storage.Product p
on p.ProdId = pp.Prod_PromProductId
group by p.ProdName, year(s.SalDate)
order by p.ProdName, year(s.SalDate);

--Velha
select so.[Stock Item] as 'Produto', year(sa.[Invoice Date Key]) as 'Ano', sum(sa.Quantity * sa.[Unit Price]) as 'Total monetario'
from OldData.Sale sa
join OldData.[Stock Item] so
on sa.[Stock Item Key] = so.[Stock Item Key]
group by so.[Stock Item], year(sa.[Invoice Date Key])
order by so.[Stock Item], year(sa.[Invoice Date Key]);

-- Total monetário de vendas por ano por “City”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
--Nova
select ci.CitName as 'Cidade', year(s.SalDate) as 'Ano', sum(s.SalTotalPrice) as 'Total monetario'
from Sales.Sale s
join RH.Customer cu
on s.SalCustomerId = cu.CusUserId
join RH.Region_Category rc
on cu.CusRegion_CategoryId = rc.Reg_CatId
join RH.City ci
on rc.Reg_CatCityId = ci.CitId
group by ci.CitName, year(s.SalDate)
order by ci.CitName, year(s.SalDate);

--Velha
select ci.City as 'Cidade', year(s.[Invoice Date Key]) as 'Ano', sum(s.Quantity * s.[Unit Price]) as 'Total monetario'
from OldData.Sale s
join OldData.Customer cu
on s.[Customer Key] = cu.[Customer Key]
join OldData.City ci
on cu.Customer like '%' + ci.City + '%'
group by ci.City, year(s.[Invoice Date Key])
order by ci.City, year(s.[Invoice Date Key]);

select ci.City
from OldData.Sale s
join OldData.Customer cu
on s.[Customer Key] = cu.[Customer Key]
join OldData.City ci
on cu.Customer like '%' + ci.City + '%'
where ci.City like 'Abbottsburg'

select year(s.[Delivery Date Key]) as 'Ano', sum(s.Quantity * s.[Unit Price]) as 'Total monetario'
from OldData.Sale s
group by year(s.[Delivery Date Key])

/********************************************
********************************************/
select *
from RH.ErrorLog;

select *
from RH.Country;

select *
from RH.StateProvince;

select *
from RH.City;

select *
from RH.Category;

select *
from RH.Region_Category;

select *
from RH.BuyingGroup;

select *
from RH.SysUser;

select *
from RH.Customer;

select *
from RH.Employee;

select *
from RH.Token;

select *
from Storage.TaxRate;

select *
from Storage.ProductType;

select *
from Storage.Package;

select *
from Storage.Brand;

select *
from Storage.Product;

select *
from Storage.Promotion;

select *
from Storage.Product_Promotion;

select *
from Sales.Sale;

select *
from Sales.ProductPromotion_Sale;

/********************************************
********************************************/
--City
select distinct Country
from OldData.City
order by Country;

select distinct Continent
from OldData.City
order by Continent;

select distinct City
from OldData.City
order by City;

select distinct [State Province]
from OldData.City
order by [State Province];

select *
from OldData.City
order by City;

--States
select *
from OldData.States
order by name;

--lookup
select *
from OldData.lookup
order by name;

--Customer
select distinct Category
from OldData.Customer
order by Category;

select distinct [Buying Group]
from OldData.Customer
order by [Buying Group];

select distinct Customer
from OldData.Customer
order by Customer;

select *
from OldData.Customer;

--Employee
select distinct [Preferred Name]
from OldData.Employee
order by [Preferred Name];

select distinct Employee
from OldData.Employee
order by Employee;

select *
from OldData.Employee;

--Sale
select distinct Package
from OldData.Sale
order by Package;

select distinct [WWI Invoice ID]
from OldData.Sale
order by [WWI Invoice ID];

select *
from OldData.Sale
order by [Description];

select [Description], sum(Quantity) as quantidade
from OldData.Sale
group by [Description]
order by quantidade;

--Stock Item
select distinct [Selling Package]
from OldData.[Stock Item]
order by [Selling Package];

select distinct [Buying Package]
from OldData.[Stock Item]
order by [Buying Package];

select distinct Brand
from OldData.[Stock Item]
order by Brand;

select distinct [Is Chiller Stock]
from OldData.[Stock Item]
order by [Is Chiller Stock];

select distinct [Tax Rate]
from OldData.[Stock Item]
order by [Tax Rate];

select distinct [Stock Item]
from OldData.[Stock Item]
order by [Stock Item];

select *
from OldData.[Stock Item]
order by [Stock Item];