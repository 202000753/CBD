/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto - Criação de Views
*		Nuno Reis (202000753)
*		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
create or alter view UsersInfo.viewNorthAmericaCountry as
select *
from UsersInfo.Country
where CouContinent = 'North America';
go
select *
from UsersInfo.viewNorthAmericaCountry;
go

create or alter view UsersInfo.viewCitySalesTerritory as
select distinct CitSalesTerritory
from UsersInfo.City;
go
select *
from UsersInfo.viewCitySalesTerritory;
go

create or alter view UsersInfo.viewRegion_Category as
select rc.Reg_CatId, co.CouName, co.CouContinent, s.StaProName, s.StaProCode, ci.CitName, ci.CitSalesTerritory, ci.CitLasPopulationRecord, ca.CatName, rc.Reg_CatPostalCode
from UsersInfo.Region_Category rc
join UsersInfo.StateProvince s
on rc.Reg_CatCitStateProvinceId = s.StaProId
join UsersInfo.City ci
on rc.Reg_CatCityId = ci.CitId
join UsersInfo.Category ca
on rc.Reg_CatCategoryId = ca.CatId
join UsersInfo.Country co
on rc.Reg_CatCountryId = co.CouId;
go
select *
from UsersInfo.viewRegion_Category;
go

create or alter view UsersInfo.viewCustomer as
select s.SysUseName, s.SysUseEmail, c.CusPrimaryContact, sy.SysUseName as 'Headquarters', ca.CatName, rc.Reg_CatPostalCode
from UsersInfo.Customer c
join UsersInfo.SysUser s
on c.CusUserId = s.SysUseId
join UsersInfo.Customer cu
on c.CusHeadquartersId = cu.CusUserId
join UsersInfo.SysUser sy
on cu.CusUserId = sy.SysUseId
join UsersInfo.Region_Category rc
on c.CusRegion_CategoryId = rc.Reg_CatId
join UsersInfo.Category ca
on rc.Reg_CatCategoryId = ca.CatId;
go
select *
from UsersInfo.viewCustomer;
go

create or alter view UsersInfo.viewEmployee as
select s.SysUseName, s.SysUseEmail, e.EmpPreferedName, CAST(CASE WHEN e.EmpIsSalesPerson = 1 THEN 'Yes' ELSE 'No' END AS varchar(20)) as 'Is Sales Person'
from UsersInfo.Employee e
join UsersInfo.SysUser s
on e.EmpUserId = s.SysUseId;
go
select *
from UsersInfo.viewEmployee;
go

create or alter view ProductsInfo.viewProduct as
select p.ProdName, b.BraName, t.TaxRatTaxRate, pt.ProTypName, ps.PacPackage as 'Selling Package', pb.PacPackage as 'Buying Package', p.ProdSize, p.ProdLeadTimeDays, p.ProdQuantityPerOuter, p.ProdUnitPrice, p.ProdRecommendedRetailPrice, p.ProdTypicalWeightPerUnit
from ProductsInfo.Product p
join ProductsInfo.Brand b
on p.ProdBrandId = b.BraId
join ProductsInfo.TaxRate t
on p.ProdTaxRateId = t.TaxRatId
join ProductsInfo.ProductType pt
on p.ProdProductTypeId = pt.ProTypId
join ProductsInfo.Package ps
on p.ProdSellingPackageId = ps.PacId
join ProductsInfo.Package pb
on p.ProdBuyingPackageId = pb.PacId;
go
select *
from ProductsInfo.viewProduct;
go

create or alter view ProductsInfo.viewProductPromotion as
select p.ProdName, p.ProdUnitPrice, p.ProdRecommendedRetailPrice, pp.ProdNewPrice, pr.PromDescription, pr.PromStartDate as 'Start Date', pr.PromEndDate as 'End Date'
from ProductsInfo.Product p
join ProductsInfo.Product_Promotion pp
on p.ProdId = pp.Prod_PromProductId
join ProductsInfo.Promotion pr
on pp.Prod_PromPromotionId = pr.PromId;
go
select *
from ProductsInfo.viewProductPromotion;
go

create or alter view SalesInfo.viewProductPromotionSale as
select s.SalID, s.SalDate, s.SalDeliveryDate, s.SalTotalPrice, s.SalTotalExcludingTax, sc.SysUseName as 'Customer', se.SysUseName as 'Employee', p.ProdName, prs.ProdProm_SalQuantity, p.ProdUnitPrice, pr.PromDescription, pr.PromStartDate as 'Start Date', pr.PromEndDate as 'End Date'
from ProductsInfo.Product p
join ProductsInfo.Product_Promotion pp
on p.ProdId = pp.Prod_PromProductId
join ProductsInfo.Promotion pr
on pp.Prod_PromPromotionId = pr.PromId
join SalesInfo.ProductPromotion_Sale prs
on prs.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
join SalesInfo.Sale s
on prs.ProdProm_SalSaleId = s.SalID
join UsersInfo.SysUser sc
on s.SalCustomerId = sc.SysUseId
join UsersInfo.SysUser se
on s.SalEmployeeId = se.SysUseId;
go
select *
from SalesInfo.viewProductPromotionSale;
go