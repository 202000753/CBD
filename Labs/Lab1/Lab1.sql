/********************************************
 *	UC: Complementos de Bases de Dados 2020/2021 
 *
 *	Laboratório 1 – Introdução ao SQL Server 2019
 *		Nuno Reis (202000753)
 *		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *	
 ********************************************/
use AdventureWorksLT2019

--============================================================================= 
-- Etapa 1
--============================================================================= 

/* 1. Listar todos os clientes (Nome Completo: primeiro, meio, último nome e email) ordenados 
descendentemente pelo último nome – 847 linhas;*/
select FirstName as 'Primeiro Nome', MiddleName as 'Nome do Meio', LastName as 'Ultimo Nome', EmailAddress as 'Email'
from SalesLT.Customer
order by LastName;

select CONCAT_WS(' ', FirstName, isnull(MiddleName, ''), LastName) as 'Nome Completo', EmailAddress as 'Email'
from SalesLT.Customer
order by LastName;

/* 2. Listar os clientes que não têm nenhuma ordem de compra (SalesLT.SalesOrderHeader) – 815 
linhas;*/
select CONCAT_WS(' ', c.FirstName, isnull(c.MiddleName, ''), c.LastName) as 'Nome Completo', c.EmailAddress as 'Email'
from SalesLT.Customer as c
left join SalesLT.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID
where soh.SalesOrderID is null
order by c.FirstName;

-- 3. Total monetário de vendas por Produto (somatório de OrderQty*UnitPrice);
select p.Name as 'Produto', sod.OrderQty*sod.UnitPrice as 'Total monetario de vendas'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID;

select distinct Name as 'Produto', SUM(tmv)as 'Total monetario de vendas'
from (
		select p.ProductID, p.Name, sod.OrderQty*sod.UnitPrice as tmv
		from SalesLT.SalesOrderDetail as sod
		left join SalesLT.Product as p
		on sod.ProductID = p.ProductID) tbl
group by Name;

select p.Name as 'Produto', sum(sod.OrderQty*sod.UnitPrice) as 'Total monetario de vendas'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID
group by p.Name;

-- 4. O Produto com o maior valor monetário de vendas;
select p.Name as 'Produto', sod.OrderQty*sod.UnitPrice as 'Total monetario de vendas'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID
where sod.OrderQty*sod.UnitPrice = (select max(sod.OrderQty*sod.UnitPrice) as tmv
									from SalesLT.SalesOrderDetail as sod
									left join SalesLT.Product as p
									on sod.ProductID = p.ProductID);

/*select p.Name as 'Produto', sum(sod.OrderQty*sod.UnitPrice) as 'Total monetario de vendas'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID
group by p.Name
having sum(sod.OrderQty*sod.UnitPrice) = max((select p.ProductID, sum(sod.OrderQty*sod.UnitPrice) as tmv
										 from SalesLT.SalesOrderDetail as sod
										 left join SalesLT.Product as p
										 on sod.ProductID = p.ProductID
										 group by p.ProductID).tmv);

select p.Name as 'Produto', max(sum(sod.OrderQty*sod.UnitPrice)) as 'Total monetario de vendas'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID
group by p.Name;*/

-- 5. Listagem de produtos (nome e preço) da categoria “Bikes” – 97 linhas;
select p.Name as 'Produto', p.ListPrice as 'Preço', pc.Name as 'Categoria'
from SalesLt.Product as p
left join SalesLT.ProductCategory as pc
on p.ProductCategoryID = pc.ProductCategoryID
where pc.ParentProductCategoryID = (select ProductCategoryID
									from  SalesLT.ProductCategory
									where Name  like 'Bikes');

-- 6. Listar apenas as categorias com mais de 20 produtos – 5 linhas
select pc.Name as 'Categoria', count(distinct p.Name) as 'Numero de produtos'
from SalesLt.Product as p
left join SalesLT.ProductCategory as pc
on p.ProductCategoryID = pc.ProductCategoryID
group by pc.Name
having count(distinct p.Name) > 20;

/* 7. Quantidades de produtos por categoria (mostrando o nome da categoria e o número de
produtos associados), ordenados por número de produtos – 37 linhas;*/
select pc.Name as 'Categoria', count(distinct p.Name) as 'Numero de produtos'
from SalesLt.Product as p
left join SalesLT.ProductCategory as pc
on p.ProductCategoryID = pc.ProductCategoryID
group by pc.Name;

/* 8. A percentagem que o valor monetário de vendas representa em cada produto face ao valor total
de vendas, ordenado pela % descendente (Obs: no cálculo do valor retirar o valor de desconto
ao preço do produto);*/
select p.Name as 'Produto', sum(sod.OrderQty*sod.UnitPrice) as 'Total monetario de vendas', sum(sod.OrderQty*sod.UnitPrice)/100 as 'Percentagem'
from SalesLT.SalesOrderDetail as sod
left join SalesLT.Product as p
on sod.ProductID = p.ProductID
group by p.Name
order by sum(sod.OrderQty*sod.UnitPrice)/100;

select * from SalesLT.SalesOrderDetail