/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Indices
*	Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
/********************************************
*	Views
********************************************/
/*Pesquisa de vendas por cidade. Deve ser retornado o nome da cidade, o nome do vendedor, o total de vendas (nota: cidades com o mesmo nome mas de diferentes
estão deverão ser consideradas distintas);*/
create or alter view dbo.viewSalesPerCity_OldData as
select c.City as Cidade, e.Employee as Vendedor, SUM(s.[Total Including Tax]) as 'Total de Vendas'
from OldData.Sale s
join OldData.City c
on c.[City Key] = c.[City Key]
join OldData.Employee e
on s.[Salesperson Key] = e.[Employee Key]
group by c.City, e.Employee;
go
select *
from dbo.viewSalesPerCity_OldData;
go

create or alter view dbo.viewSalesPerCity as
select ct.CitName as Cidade, st.StaProName as Estado, u.SysUseName as Vendedor, SUM(s.SalTotalPrice) as 'Total de Vendas'
from Sales.Sale s
join RH.Customer c
on s.SalCustomerId = c.CusUserId
join RH.Region_Category rc
on c.CusRegion_CategoryId = rc.Reg_CatId
join RH.City ct
on rc.Reg_CatCityId = ct.CitId
join RH.StateProvince st
on rc.Reg_CatStateProvinceId = st.StaProId
join RH.Employee e
on s.SalEmployeeId = e.EmpUserId
join RH.SysUser u
on e.EmpUserId = u.SysUseId
group by ct.CitName, st.StaProName, u.SysUseName;
go
select *
from dbo.viewSalesPerCity;
go

--Para as vendas calcular a taxa de crescimento de cada ano, face ao ano anterior, por categoria de cliente;
create or alter view dbo.viewYearGrowthPerSale_OldData as
select cu.Category as Categoria, year(s.[Invoice Date Key]) as Ano, COUNT(s.[WWI Invoice ID]) as Numero
from OldData.Sale s
join OldData.Customer cu
on s.[Customer Key] = cu.[Customer Key]
group by cu.Category, year(s.[Invoice Date Key])
go
select *
from dbo.viewYearGrowthPerSale_OldData;
go

create or alter view dbo.viewYearGrowthPerSale as
select ca.CatName as Categoria, year(s.SalDate) as Ano, COUNT(s.SalID) as Numero
from Sales.Sale s
join RH.Customer c
on s.SalCustomerId = c.CusUserId
join RH.Region_Category rc
on c.CusRegion_CategoryId = rc.Reg_CatId
join RH.Category ca
on rc.Reg_CatCategoryId = ca.CatId
group by ca.CatName,  year(s.SalDate);
go
select *
from dbo.viewYearGrowthPerSale;
go

--Nº de produtos (stockItem) nas vendas por cor
create or alter view dbo.viewNProductsPerColor_OldData as
select si.Color as Cor, COUNT(s.Quantity) as 'Nº de Produtos'
from OldData.Sale s
join OldData.[Stock Item] si
on s.[Stock Item Key] = si.[Stock Item Key]
group by si.Color
go
select *
from dbo.viewNProductsPerColor_OldData;
go

create or alter view dbo.viewNProductsPerColor as
select p.ProdColor as Cor, COUNT(pps.ProdProm_SalQuantity) as 'Nº de Produtos'
from Sales.Sale s
join Sales.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join Storage.Product_Promotion pp
on pps.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
join Storage.Product p
on pp.Prod_PromProductId = p.ProdId
group by p.ProdColor;
go
select *
from dbo.viewNProductsPerColor;
go

/********************************************
*	Indices
********************************************/
--Com vista à otimização da execução das consultas propostas, defina, justificadamente, os índices pertinentes. Inclua no relatório a justificação apresentada.


--SQL Profiler e Tunning Advisor
/*Contraste os planos de execução das queries anteriores sobre a base de dados que otimizou e as 
queries equivalentes sobre a base de dados original. No caso da nova base de dados devem ser 
apresentados os planos de execução com e sem índices. Inclua no relatório o comentário ao que 
observa.*/
