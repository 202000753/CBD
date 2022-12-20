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
				  where SysUseName like @customerName)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_customerExists('Tailspin Toys (Head Office)');
--select RH.udf_customerExists('Tailspin Toys (Sylvanite, MT)');
GO

--Função que retorna o id do grupo e 0 se não existir o grupo com o id passado
CREATE OR ALTER FUNCTION RH.udf_customerExistsById (@customerId int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select CusUserId
				  from RH.Customer
				  where CusUserId like @customerId)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_customerExistsById(1);
--select RH.udf_customerExistsById(2);
GO