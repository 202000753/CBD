 /********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto - Queries das tabelas da base de dados nova
*		Nuno Reis (202000753)
*		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
 USE WWIGlobal

select *
from UsersInfo.Country;

select *
from UsersInfo.City
order by CitName;

select *
from UsersInfo.StateProvince
order by StaProName;

select *
from UsersInfo.Category
order by CatName;

select *
from UsersInfo.BuyingGroup;

select *
from UsersInfo.Customer;

select *
from UsersInfo.Employee
order by EmpPreferedName;

select *
from UsersInfo.SysUser;

select *
from ProductsInfo.Package;

select *
from ProductsInfo.Brand;

select *
from ProductsInfo.ProductType;

select *
from ProductsInfo.TaxRate;

select *
from ProductsInfo.Product
order by ProdName;

select *
from ProductsInfo.Promotion;

select *
from SalesInfo.Sale;

select *
from ProductsInfo.Product_Promotion;

select *
from SalesInfo.ProductPromotion_Sale
order by ProdProm_SalSaleId;

select *
from UsersInfo.Region_Category;

select *
from UsersInfo.ErrorLog;

select *
from UsersInfo.Token;

/********************************************
 *	Queries de verificação de conformidade
 ********************************************/
-- Nº de “Customers”
select COUNT(*)
from UsersInfo.Customer;

-- Nº de “Customers” por “Category”
select ca.CatName as 'Categoria', COUNT(*) as 'Nº de Customers'
from UsersInfo.Category ca
join UsersInfo.Region_Category rc
on rc.Reg_CatCategoryId = ca.CatId
join UsersInfo.Customer cu
on rc.Reg_CatId = cu.CusRegion_CategoryId
group by ca.CatName

-- Total de vendas por “Employee”
-- Apenas deve ser contabilizada uma venda, mesmo que esta contenha vários produtos associados
select s.SysUseName as 'Funcionario', a.n as 'Nº de Vendas'
from UsersInfo.Employee e
join UsersInfo.SysUser s
on e.EmpUserId = s.SysUseId
join (select SalEmployeeId as e, COUNT(*) as n
		from SalesInfo.Sale
		group by SalEmployeeId) a
on e.EmpUserId = a.e;

-- Total monetário de vendas por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
select p.ProdName as 'Produto', sum(pps.ProdProm_SalQuantity * p.ProdUnitPrice) as 'Total monetario'
from SalesInfo.Sale s 
join SalesInfo.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join ProductsInfo.Product_Promotion pp
on pp.Prod_PromProductPromotionId = pps.ProdProm_SalProductPromotionId
join ProductsInfo.Product p
on p.ProdId = pp.Prod_PromProductId
group by p.ProdName
order by p.ProdName;

-- Total monetário de vendas por ano por “Stock Item”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
select p.ProdName as 'Produto', year(s.SalDeliveryDate) as 'Ano', sum(pps.ProdProm_SalQuantity * p.ProdUnitPrice) as 'Total monetario'
from SalesInfo.Sale s 
join SalesInfo.ProductPromotion_Sale pps
on s.SalID = pps.ProdProm_SalSaleId
join ProductsInfo.Product_Promotion pp
on pp.Prod_PromProductPromotionId = pps.ProdProm_SalProductPromotionId
join ProductsInfo.Product p
on p.ProdId = pp.Prod_PromProductId
group by p.ProdName, year(s.SalDeliveryDate)
order by p.ProdName, year(s.SalDeliveryDate);

-- Total monetário de vendas por ano por “City”
-- Valor monetário obtido por quantity*Unit Price
-- O ano deve ser retirado da coluna “Delivery Date Key”
select ci.CitName as 'Cidade', year(s.SalDeliveryDate) as 'Ano', sum(s.SalTotalPrice) as 'Total monetario'
from SalesInfo.Sale s
join UsersInfo.Customer cu
on s.SalCustomerId = cu.CusUserId
join UsersInfo.Region_Category rc
on cu.CusRegion_CategoryId = rc.Reg_CatId
join UsersInfo.City ci
on rc.Reg_CatCityId = ci.CitId
group by ci.CitName, year(s.SalDeliveryDate)
order by ci.CitName, year(s.SalDeliveryDate);

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