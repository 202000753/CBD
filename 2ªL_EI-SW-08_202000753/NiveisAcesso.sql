/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2� Fase - Niveis de Acesso
*	Nuno Reis (202000753)
*			Turma: 2�L_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
--1. Administrador: Tem acesso a toda a informa��o.
CREATE ROLE administrador;
go

grant control to administrador;
grant select to administrador;
grant insert to administrador;
grant update to administrador;
grant create table to administrador;
grant delete to administrador;
go

CREATE LOGIN Admi with password = 'PASSWORD';
CREATE USER Adminis FOR LOGIN Admi;
EXEC sp_addrolemember 'administrador', 'Adminis';
go

/*2. EmployeeSalesPerson: Tem acesso total �s tabelas de suporte �s vendas, e apenas acesso em 
modo de consulta �s restantes tabelas.*/
CREATE ROLE employeeSalesPerson;
go

grant select, insert, update, delete on [Sales].[Sale] to employeeSalesPerson
grant select, insert, update, delete on [Sales].[ProductPromotion_Sale] to employeeSalesPerson
go

grant select on [RH].[BuyingGroup] to employeeSalesPerson
grant select on [RH].[Category] to employeeSalesPerson
grant select on [RH].[City] to employeeSalesPerson
grant select on [RH].[Country] to employeeSalesPerson
grant select on [RH].[Customer] to employeeSalesPerson
grant select on [RH].[Employee] to employeeSalesPerson
grant select on [RH].[Region_Category] to employeeSalesPerson
grant select on [RH].[StateProvince] to employeeSalesPerson
grant select on [RH].[SysUser] to employeeSalesPerson
grant select on [RH].[ErrorLog] to employeeSalesPerson
grant select on [Storage].[Brand] to employeeSalesPerson
grant select on [Storage].[Package] to employeeSalesPerson
grant select on [Storage].[Product] to employeeSalesPerson
grant select on [Storage].[Product_Promotion] to employeeSalesPerson
grant select on [Storage].[ProductType] to employeeSalesPerson
grant select on [Storage].[Promotion] to employeeSalesPerson
grant select on [Storage].[TaxRate] to employeeSalesPerson
go

CREATE LOGIN EmployeeSales with password = 'PASSWORD';
CREATE USER EmpSalPerson FOR LOGIN EmployeeSales;
EXEC sp_addrolemember 'employeeSalesPerson', 'EmpSalPerson';
go

/*3. SalesTerritory: Apenas pode consultar a informa��o relativa ao seu territ�rio. Considere 
apenas o territ�rio �Rocky Mountain� (nota: podem ser criadas views auxiliares).*/
CREATE ROLE salesTerritory;
go

create or alter view [viewSalesTerritory_SalesInfo] as
select s.SalID as 'N� Venda', suCu.SysUseName as 'Cliente', suEm.SysUseName as 'Funcionario', s.SalDate as 'Data da Venda', s.SalDeliveryDate as 'Data Prevista de Entrega', s.SalDescription as 'Descri��o', s.SalProfit as 'Lucro', s.SalTotalPrice as 'Pre�o Total', s.SalTotalExcludingTax as 'Pre�o Total sem Taxas', s.SalTaxAmount as 'Pre�o Total de Taxas', ci.CitName as 'Cidade', ci.CitSalesTerritory as 'Territ�rio'
from Sales.Sale s
join RH.Customer cu
on s.SalCustomerId = cu.CusUserId
join RH.Region_Category rc
on cu.CusRegion_CategoryId = rc.Reg_CatId
join RH.City ci
on rc.Reg_CatCityId = ci.CitId
join RH.SysUser suCu
on cu.CusUserId = suCu.SysUseId
join RH.SysUser suEm
on s.SalEmployeeId = suEm.SysUseId
where ci.CitSalesTerritory like 'Rocky Mountain';
go

create or alter view [viewSalesTerritory_ProductsInfo] as
select s.SalID as 'N� Venda', suCu.SysUseName as 'Cliente', suEm.SysUseName as 'Funcionario', s.SalDescription as 'Descri��o', p.ProdName as 'Produto', pps.ProdProm_SalQuantity as 'Quantidade', b.BraName as 'Marca', paSp.PacPackage as 'Pacote de Venda', paBp.PacPackage as 'Pacote de Compra', pt.ProTypName as 'Tipo de Produto', t.TaxRatTaxRate as 'Taxa', p.ProdColor as 'Cor', p.ProdSize as 'Tamanho', p.ProdLeadTimeDays as 'Dias de Entrega', p.ProdQuantityPerOuter as 'Quantidade por Pacote', p.ProdStock as 'Stock', p.ProdBarCode as 'Codigo de Barras', p.ProdUnitPrice as 'Pre�o', p.ProdRecommendedRetailPrice as 'Pre�o Recomendado para Venda', p.ProdTypicalWeightPerUnit as 'Peso', ci.CitName as 'Cidade', ci.CitSalesTerritory as 'Territ�rio'
from Sales.Sale s
join RH.Customer cu
on s.SalCustomerId = cu.CusUserId
join RH.Region_Category rc
on cu.CusRegion_CategoryId = rc.Reg_CatId
join RH.City ci
on rc.Reg_CatCityId = ci.CitId
join RH.SysUser suCu
on cu.CusUserId = suCu.SysUseId
join RH.SysUser suEm
on s.SalEmployeeId = suEm.SysUseId
join Sales.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join Storage.Product_Promotion pp
on pps.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
join Storage.Product p
on pp.Prod_PromProductId = p.ProdId
join Storage.Brand b
on p.ProdBrandId = b.BraId
join Storage.Package paSp
on p.ProdSellingPackageId = paSp.PacId
join Storage.Package paBp
on p.ProdBuyingPackageId = paBp.PacId
join Storage.ProductType pt
on p.ProdProductTypeId = pt.ProTypId
join Storage.TaxRate t
on p.ProdTaxRateId = t.TaxRatId
where ci.CitSalesTerritory like 'Rocky Mountain';
go

grant select on [dbo].[viewSalesTerritory_SalesInfo] to salesTerritory
grant select on [dbo].[viewSalesTerritory_ProductsInfo] to salesTerritory
go

CREATE LOGIN SalesTer with password = 'PASSWORD';
CREATE USER SalTerri FOR LOGIN SalesTer;
EXEC sp_addrolemember 'salesTerritory', 'SalTerri';
go