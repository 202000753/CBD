Lab 1 - Introdução ao SQL Server 2019
Nome: Nuno Reis		Número: 202000753
Etapa 1
 

Etapa 2
a)
select concat(FirstName, ' ', MiddleName, ' ', LastName) as 'Nome Completo', EmailAddress
from SalesLT.Customer

b)
select concat(FirstName, ' ', MiddleName, ' ', LastName) as 'Nome Completo', EmailAddress
from SalesLT.Customer
order by LastName desc

c)
select Customer.CustomerID, FirstName
from SalesLT.Customer left join SalesLT.SalesOrderHeader
on Customer.CustomerID = SalesOrderHeader.CustomerID
where SalesOrderNumber is null

Etapa 3
a)
select ProductID, sum(OrderQty*UnitPrice) as 'Total de Vendas'
from SalesLT.SalesOrderDetail
group by ProductID
order by ProductID

b)
select top 1 ProductID, sum(OrderQty*UnitPrice) as 'Total de Vendas'
from SalesLT.SalesOrderDetail
group by ProductID
order by 2 DESC

c)
select p.Name, (tabela.Vendas/(select sum(OrderQty*(UnitPrice-UnitPriceDiscount)) from SalesLT.SalesOrderDetail))*100 as '%Vendas'
from SalesLT.Product p
join (select ProductID, sum(OrderQty*(UnitPrice-UnitPriceDiscount)) as Vendas
			from SalesLT.SalesOrderDetail
			group by ProductID) Tabela
on p.ProductID=Tabela.ProductID
where Vendas is not null
order by Vendas DESC

d)
select [Name], [Description]
from [SalesLT].[vProductAndDescription]

e)
select Product.Name, [ProductCategoryName], [ParentProductCategoryName]
from SalesLT.Product
join [SalesLT].[vGetAllCategories]
on Product.ProductCategoryID=[vGetAllCategories].[ProductCategoryID]

f)
select Product.Name, Product.ListPrice
from SalesLT.Product
join [SalesLT].[vGetAllCategories]
on Product.ProductCategoryID=[vGetAllCategories].[ProductCategoryID]
where [vGetAllCategories].[ParentProductCategoryName] = 'Bikes'

g)
select [vGetAllCategories].[ProductCategoryName], Tabela.Number
from [SalesLT].[vGetAllCategories]
left join (select ProductCategoryID, count(*) as Number
			from SalesLT.Product
			group by Product.ProductCategoryID) as Tabela
on [vGetAllCategories].[ProductCategoryID]=Tabela.ProductCategoryID
where Tabela.Number IS NOT NULL
order by Number;

h)
select [vGetAllCategories].[ProductCategoryName], Tabela.Number
from [SalesLT].[vGetAllCategories]
left join (select ProductCategoryID, count(*) as Number
			from SalesLT.Product
			group by Product.ProductCategoryID) as Tabela
on [vGetAllCategories].[ProductCategoryID]=Tabela.ProductCategoryID
where Tabela.Number>20
order by Number;

Etapa 4
Criar a tabela:
CREATE TABLE Estatisticas (
	NomeTabela varchar(50),
	NumRegistos int
);

Query que calcula o número de registos criado por cada ano da tabela Customer:
select Year(ModifiedDate), count(*)
from SalesLT.Customer
group by Year(ModifiedDate)
order by Year(ModifiedDate)

Insert com base no comando select:
INSERT INTO Estatisticas(NomeTabela, NumRegistos)
VALUES ('Customer', (select count(*)
					from SalesLT.Customer));
