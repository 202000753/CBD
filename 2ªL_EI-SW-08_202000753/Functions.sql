/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 1ª Fase - Criar as functions
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
--Função que retorna o id do pais e 0 se não existir o pais com o nome e continente passados
CREATE OR ALTER FUNCTION RH.udf_countryExists (@countryName varchar(20), @continentName varchar(20))
RETURNS int
BEGIN
	declare @result int

	set @result =(select CouId
				  from RH.Country
				  where CouName = @countryName and CouContinent = @continentName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_countryExists('United States', 'North America');
--select RH.udf_countryExists('United States', 'South America');
GO

--Função que retorna o id do pais e 0 se não existir o pais com o id passado
CREATE OR ALTER FUNCTION RH.udf_countryExistsById (@countryId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select CouId
				  from RH.Country
				  where CouId = @countryId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_countryExistsById(1);
--select RH.udf_countryExistsById(2);
GO

--Função que retorna o id do estado e 0 se não existir o estado com o nome passado
CREATE OR ALTER FUNCTION RH.udf_stateProvinceExists (@stateProvinceName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select StaProId
				  from RH.StateProvince
				  where StaProName = @stateProvinceName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_stateProvinceExists('Alabama');
--select RH.udf_stateProvinceExists('Alaska');
GO

--Função que retorna o id do estado e 0 se não existir o estado com o id passado
CREATE OR ALTER FUNCTION RH.udf_stateProvinceExistsById (@stateProvinceId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select StaProId
				  from RH.StateProvince
				  where StaProId = @stateProvinceId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_stateProvinceExistsById(1);
--select RH.udf_stateProvinceExistsById(2);
GO

--Função que retorna o id da cidade e 0 se não existir a cidade com o nome passado
CREATE OR ALTER FUNCTION RH.udf_cityExists (@cityName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select CitId
				  from RH.City
				  where CitName = @cityName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_cityExists('Aaronsburg');
--select RH.udf_cityExists('Abanda');
GO

--Função que retorna o id da cidade e 0 se não existir a cidade com o id passado
CREATE OR ALTER FUNCTION RH.udf_cityExistsById (@cityId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select CitId
				  from RH.City
				  where CitId = @cityId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_cityExistsById(1);
--select RH.udf_cityExistsById(2);
GO

--Função que retorna o id da categoria e 0 se não existir a categoria com o nome passado
CREATE OR ALTER FUNCTION RH.udf_categoryExists (@categoryName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select CatId
				  from RH.Category
				  where CatName = @categoryName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_categoryExists('Gas Station Shop');
--select RH.udf_categoryExists('24H Shop');
GO

--Função que retorna o id da categoria e 0 se não existir a categoria com o id passado
CREATE OR ALTER FUNCTION RH.udf_categoryExistsById (@categoryId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select CatId
				  from RH.Category
				  where CatId = @categoryId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_categoryExistsById(1);
--select RH.udf_categoryExistsById(2);
GO

--Função que retorna o id da relação entre pais, estado, cidade e categoria e 0 se não existir a relação com os ids passados
CREATE OR ALTER FUNCTION RH.udf_regionCategoryExists (@countryId int, @stateProvinceId int, @cityId int, @categoryId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select Reg_CatId
				  from RH.Region_Category
				  where Reg_CatCategoryId = @categoryId and Reg_CatStateProvinceId = @stateProvinceId and Reg_CatCityId = @cityId and Reg_CatCountryId = @countryId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_regionCategoryExists(1, 2, 2, 2);
GO

--Função que retorna o id da relação entre pais, estado, cidade e categoria e 0 se não existir a relação com o id passado
CREATE OR ALTER FUNCTION RH.udf_regionCategoryExistsById (@regionCategoryId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select Reg_CatId
				  from RH.Region_Category
				  where Reg_CatId = @regionCategoryId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_regionCategoryExistsById(4);
GO

--Função que retorna o id do grupo e 0 se não existir o grupo com o nome passado
CREATE OR ALTER FUNCTION RH.udf_buiyngGroupExists (@buiyngGroupName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select BuyGrouId
				  from RH.BuyingGroup
				  where BuyGrouName = @buiyngGroupName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_buiyngGroupExists('Tailspin Toys');
--select RH.udf_buiyngGroupExists('Wingtip Toys');
GO

--Função que retorna o id do grupo e 0 se não existir o grupo com o id passado
CREATE OR ALTER FUNCTION RH.udf_buiyngGroupExistsById (@buiyngGroupId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select BuyGrouId
				  from RH.BuyingGroup
				  where BuyGrouId = @buiyngGroupId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_buiyngGroupExistsById(1);
--select RH.udf_buiyngGroupExistsById(2);
GO

--Função que retorna o id do utilizador e 0 se não existir o utilizador com o email passado
CREATE OR ALTER FUNCTION RH.udf_sysUserExists (@sysUserEmail varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select SysUseId
				  from RH.SysUser
				  where SysUseEmail = @sysUserEmail)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_sysUserExists('HeadOffice@Tailspin_Toys.com');
--select RH.udf_sysUserExists('Kiosk_SylvaniteMT@Tailspin_Toys.com');
GO

--Função que retorna o id do grupo e 0 se não existir o grupo com o id passado
CREATE OR ALTER FUNCTION RH.udf_sysUserExistsById (@sysUserId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select SysUseId
				  from RH.SysUser
				  where SysUseId = @sysUserId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_sysUserExistsById(1);
--select RH.udf_sysUserExistsById(2);
GO

CREATE or alter FUNCTION RH.udf_fnHashPassword (@password VARCHAR(20))
Returns varchar(20)
AS
BEGIN
	return HASHBYTES('SHA1', @password)
END;
--select RH.udf_fnHashPassword('Pass123');
GO

--Função que retorna o id do cliente e 0 se não existir o cliente com o nome passado
CREATE OR ALTER FUNCTION RH.udf_customerExists (@customerName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SysUseId
				  from RH.Customer c
				  join RH.SysUser s
				  on c.CusUserId = s.SysUseId
				  where SysUseName = @customerName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_customerExists('Tailspin Toys (Head Office)');
--select RH.udf_customerExists('Tailspin Toys (Sylvanite, MT)');
GO

--Função que retorna o id do cliente e 0 se não existir o cliente com o id passado
CREATE OR ALTER FUNCTION RH.udf_customerExistsById (@customerId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select CusUserId
				  from RH.Customer
				  where CusUserId = @customerId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_customerExistsById(1);
--select RH.udf_customerExistsById(2);
GO

--Função que retorna o id do funcionario e 0 se não existir o funcionario com o nome passado
CREATE OR ALTER FUNCTION RH.udf_employeeExists (@employeeName varchar(50))
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SysUseId
				  from RH.Employee e
				  join RH.SysUser s
				  on e.EmpUserId = s.SysUseId
				  where SysUseName = @employeeName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_employeeExists('Eva Muirden');
--select RH.udf_employeeExists('Jack');
GO

--Função que retorna o id do funcionario e 0 se não existir o funcionario com o id passado
CREATE OR ALTER FUNCTION RH.udf_employeeExistsById (@employeeId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select EmpUserId
				  from RH.Employee
				  where EmpUserId = @employeeId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_employeeExistsById(1);
--select RH.udf_employeeExistsById(2);
GO

--Função que retorna o id do token e 0 se não existir o token com o token passado
CREATE OR ALTER FUNCTION RH.udf_tokenExists (@token int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select TokId
				  from RH.Token
				  where TokToken = @token)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_tokenExists(66873);
--select RH.udf_tokenExists(66874);
GO

--Função que retorna o id do token e 0 se não existir o token com o id passado
CREATE OR ALTER FUNCTION RH.udf_tokenExistsById (@tokenId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select TokId
				  from RH.Token
				  where TokId = @tokenId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_tokenExistsById(1);
--select RH.udf_tokenExistsById(5);
GO

--Função que retorna o id da taxa e 0 se não existir a taxa com a taxa passado
CREATE OR ALTER FUNCTION Storage.udf_taxRateExists (@taxRate float)
RETURNS int
BEGIN
	declare @result int

	set @result =(select TaxRatId
				  from Storage.TaxRate
				  where TaxRatTaxRate = @taxRate)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_taxRateExists(2.3);
--select Storage.udf_taxRateExists(3.3);
GO

--Função que retorna o id da taxa e 0 se não existir a taxa com o id passado
CREATE OR ALTER FUNCTION Storage.udf_taxRateExistsById (@taxRateId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select TaxRatId
				  from Storage.TaxRate
				  where TaxRatId = @taxRateId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_taxRateExistsById(1);
--select Storage.udf_taxRateExistsById(2);
GO

--Função que retorna o id do tipo de produto e 0 se não existir o tipo de produto com o nome passado
CREATE OR ALTER FUNCTION Storage.udf_productTypeExists (@productType VARCHAR(25))
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProTypId
				  from Storage.ProductType
				  where ProTypName = @productType)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productTypeExists('Chiller');
--select Storage.udf_productTypeExists('Dry');
GO

--Função que retorna o id do tipo de produto e 0 se não existir o tipo de produto com o id passado
CREATE OR ALTER FUNCTION Storage.udf_productTypeExistsById (@productTypeId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProTypId
				  from Storage.ProductType
				  where ProTypId = @productTypeId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productTypeExistsById(1);
--select Storage.udf_productTypeExistsById(2);
GO

--Função que retorna o id do pacote e 0 se não existir o pacote com o nome passado
CREATE OR ALTER FUNCTION Storage.udf_packageExists (@package VARCHAR(25))
RETURNS int
BEGIN
	declare @result int

	set @result =(select PacId
				  from Storage.Package
				  where PacPackage = @package)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_packageTypeExists('Bag');
--select Storage.udf_packageTypeExists('Each');
GO

--Função que retorna o id do pacote e 0 se não existir o pacote com o id passado
CREATE OR ALTER FUNCTION Storage.udf_packageExistsById (@packageId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select PacId
				  from Storage.Package
				  where PacId = @packageId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_packageExistsById(1);
--select Storage.udf_packageExistsById(2);
GO

--Função que retorna o id da marca e 0 se não existir a marca com o nome passado
CREATE OR ALTER FUNCTION Storage.udf_brandExists (@brand VARCHAR(25))
RETURNS int
BEGIN
	declare @result int

	set @result =(select BraId
				  from Storage.Brand
				  where BraName = @brand)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_brandExists('Northwind');
--select Storage.udf_brandExists('N/A');
GO

--Função que retorna o id da marca e 0 se não existir a marca com o id passado
CREATE OR ALTER FUNCTION Storage.udf_brandExistsById (@brandId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select BraId
				  from Storage.Brand
				  where BraId = @brandId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_brandExistsById(1);
--select Storage.udf_brandExistsById(2);
GO

--Função que retorna o id do produto e 0 se não existir o produto com o nome passado
CREATE OR ALTER FUNCTION Storage.udf_productExists (@productName VARCHAR(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProdId
				  from Storage.Product
				  where ProdName = @productName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productExists('"The Gu" red shirt XML tag t-shirt (Black) 3XL');
--select Storage.udf_productExists('"The Gu" red shirt XML tag t-shirt (Black) 3XS');
GO

--Função que retorna o id do produto e 0 se não existir o produto com o id passado
CREATE OR ALTER FUNCTION Storage.udf_productExistsById (@productId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProdId
				  from Storage.Product
				  where ProdId = @productId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productExistsById(1);
--select Storage.udf_productExistsById(2);
GO

--Função que retorna o id da promoção e 0 se não existir a promoção com o nome passado
CREATE OR ALTER FUNCTION Storage.udf_promotionExists (@promotionDescription VARCHAR(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select PromId
				  from Storage.Promotion
				  where PromDescription = @promotionDescription)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_promotionExists('No promotion');
--select Storage.udf_promotionExists('Promotion1');
GO

--Função que retorna o id da promoção e 0 se não existir a promoção com o id passado
CREATE OR ALTER FUNCTION Storage.udf_promotionExistsById (@promotionId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select PromId
				  from Storage.Promotion
				  where PromId = @promotionId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_promotionExistsById(1);
--select Storage.udf_promotionExistsById(2);
GO

--Função que retorna o id da relação entre produto e promoção e 0 se não existir a relação entre produto e promoção com os ids passado
CREATE OR ALTER FUNCTION Storage.udf_productPromotionExists (@productId int, @promotionId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select Prod_PromProductPromotionId
				  from Storage.Product_Promotion
				  where Prod_PromProductId = @productId and Prod_PromPromotionId = @promotionId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productPromotionExists(3, 3);
--select Storage.udf_productPromotionExists(2, 1);
GO

--Função que retorna o id da relação entre produto e promoção e 0 se não existir a relação entre produto e promoção com o id passado
CREATE OR ALTER FUNCTION Storage.udf_productPromotionExistsById (@productPromotionId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select Prod_PromProductPromotionId
				  from Storage.Product_Promotion
				  where Prod_PromProductPromotionId like @productPromotionId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productPromotionExistsById(1);
--select Storage.udf_productPromotionExistsById(2);
GO

--Função que retorna o id dvenda e 0 se não existir a venda com o id passado
CREATE OR ALTER FUNCTION Sales.udf_saleExistsById (@saleId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select SalID
				  from Sales.Sale
				  where SalID like @saleId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Sales.udf_saleExistsById(1);
--select Sales.udf_saleExistsById(2);
GO

--Função que retorna o id da relação entre produto-promoção e venda e 0 se não existir a relação entre produto-promoção e venda com os ids passado
CREATE OR ALTER FUNCTION Sales.udf_productPromotionSaleExists (@productPromotionId int, @saleId int)
RETURNS bit
BEGIN
	declare @result int

	set @result =(select ProdProm_SalProductPromotionId
				  from Sales.ProductPromotion_Sale
				  where ProdProm_SalProductPromotionId = @productPromotionId and ProdProm_SalSaleId = @saleId)

	if @result is null
	begin
		return 0
	end
	
	return 1
END;
--select Sales.udf_productPromotionSaleExists(1, 1);
--select Sales.udf_productPromotionSaleExists(4, 2);
GO