/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto - Criação de Views
*		Nuno Reis (202000753)
*		Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
create or alter view RH.viewNorthAmericaCountry as
select *
from RH.Country
where CouContinent = 'North America';
go
select *
from RH.viewNorthAmericaCountry;
go

create or alter view RH.viewCitySalesTerritory as
select distinct CitSalesTerritory
from RH.City;
go
select *
from RH.viewCitySalesTerritory;
go

create or alter view RH.viewRegion_Category as
select rc.Reg_CatId, co.CouName, co.CouContinent, s.StaProName, s.StaProCode, ci.CitName, ci.CitSalesTerritory, ci.CitLasPopulationRecord, ca.CatName, rc.Reg_CatPostalCode
from RH.Region_Category rc
join RH.StateProvince s
on rc.Reg_CatStateProvinceId = s.StaProId
join RH.City ci
on rc.Reg_CatCityId = ci.CitId
join RH.Category ca
on rc.Reg_CatCategoryId = ca.CatId
join RH.Country co
on rc.Reg_CatCountryId = co.CouId;
go
select *
from RH.viewRegion_Category;
go

create or alter view RH.viewCustomer as
select s.SysUseName, s.SysUseEmail, c.CusPrimaryContact, sy.SysUseName as 'Headquarters', ca.CatName, rc.Reg_CatPostalCode
from RH.Customer c
join RH.SysUser s
on c.CusUserId = s.SysUseId
join RH.Customer cu
on c.CusHeadquartersId = cu.CusUserId
join RH.SysUser sy
on cu.CusUserId = sy.SysUseId
join RH.Region_Category rc
on c.CusRegion_CategoryId = rc.Reg_CatId
join RH.Category ca
on rc.Reg_CatCategoryId = ca.CatId;
go
select *
from RH.viewCustomer;
go

create or alter view RH.viewEmployee as
select s.SysUseName, s.SysUseEmail, e.EmpPreferedName, CAST(CASE WHEN e.EmpIsSalesPerson = 1 THEN 'Yes' ELSE 'No' END AS varchar(20)) as 'Is Sales Person'
from RH.Employee e
join RH.SysUser s
on e.EmpUserId = s.SysUseId;
go
select *
from RH.viewEmployee;
go

create or alter view Storage.viewProduct as
select p.ProdName, b.BraName, t.TaxRatTaxRate, pt.ProTypName, ps.PacPackage as 'Selling Package', pb.PacPackage as 'Buying Package', p.ProdSize, p.ProdLeadTimeDays, p.ProdQuantityPerOuter, p.ProdUnitPrice, p.ProdRecommendedRetailPrice, p.ProdTypicalWeightPerUnit
from Storage.Product p
join Storage.Brand b
on p.ProdBrandId = b.BraId
join Storage.TaxRate t
on p.ProdTaxRateId = t.TaxRatId
join Storage.ProductType pt
on p.ProdProductTypeId = pt.ProTypId
join Storage.Package ps
on p.ProdSellingPackageId = ps.PacId
join Storage.Package pb
on p.ProdBuyingPackageId = pb.PacId;
go
select *
from Storage.viewProduct;
go

create or alter view Storage.viewProductPromotion as
select p.ProdName, p.ProdUnitPrice, p.ProdRecommendedRetailPrice, pp.ProdNewPrice, pr.PromDescription, pr.PromStartDate as 'Start Date', pr.PromEndDate as 'End Date'
from Storage.Product p
join Storage.Product_Promotion pp
on p.ProdId = pp.Prod_PromProductId
join Storage.Promotion pr
on pp.Prod_PromPromotionId = pr.PromId;
go
select *
from Storage.viewProductPromotion;
go

create or alter view Sales.viewProductPromotionSale as
select s.SalID, s.SalDate, s.SalDeliveryDate, s.SalTotalPrice, s.SalTotalExcludingTax, sc.SysUseName as 'Customer', se.SysUseName as 'Employee', p.ProdName, prs.ProdProm_SalQuantity, p.ProdUnitPrice, pr.PromDescription, pr.PromStartDate as 'Start Date', pr.PromEndDate as 'End Date'
from Storage.Product p
join Storage.Product_Promotion pp
on p.ProdId = pp.Prod_PromProductId
join Storage.Promotion pr
on pp.Prod_PromPromotionId = pr.PromId
join Sales.ProductPromotion_Sale prs
on prs.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
join Sales.Sale s
on prs.ProdProm_SalSaleId = s.SalID
join RH.SysUser sc
on s.SalCustomerId = sc.SysUseId
join RH.SysUser se
on s.SalEmployeeId = se.SysUseId;
go
select *
from Sales.viewProductPromotionSale;
go