/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 1ª Fase - Criar os stored procedures geradores
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
/********************************************
* ErrorLog
********************************************/
CREATE OR ALTER PROCEDURE RH.errorLog_insert @error varchar(300)
AS
	insert into RH.ErrorLog values(@error, GETDATE())
GO
--EXEC RH.errorLog_insert 'Teste de Erro';
GO

/********************************************
* Country
********************************************/
CREATE OR ALTER PROCEDURE RH.country_insert @countryName varchar(20), @continentName varchar(20)
AS
	declare
		@error varchar(300),
		@countryExistsID int

	set @countryExistsID = RH.udf_countryExists(@countryName, @continentName)


	if @countryExistsID = 0
	begin
		insert into RH.Country values(@countryName, @continentName)
	end
	else
	begin
		set @error = 'RH.country_insert -> Já existe um pais com este nome e continente (' + @countryName + ', ' + @continentName + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.country_insert 'Portugal', 'Europe';
--EXEC RH.country_insert 'United States', 'North America';
GO

CREATE OR ALTER PROCEDURE RH.country_update @countryId int, @countryName varchar(20), @continentName varchar(20)
AS
	declare
		@error varchar(300),
		@countryExistsID int

	set @countryExistsID = RH.udf_countryExistsById(@countryId)

	if @countryExistsID != 0
	begin
		update RH.Country
		set CouName = @countryName, CouContinent = @continentName
		where CouId = @countryId
	end
	else
	begin
		set @error = 'RH.country_update -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.country_update 2, 'United States', 'South America';
--EXEC RH.country_update 3, 'United States', 'North America';
--EXEC RH.country_update 2, 'United States', 'South America';
GO

CREATE OR ALTER PROCEDURE RH.country_delete @countryId int
AS
	declare
		@error varchar(300),
		@countryExistsID int

	set @countryExistsID = RH.udf_countryExistsById(@countryId)

	if @countryExistsID != 0
	begin
		delete from RH.Country
		where CouId = @countryId
	end
	else
	begin
		set @error = 'RH.country_delete -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.country_delete 2;
--EXEC RH.country_delete 3;
GO

/********************************************
* StateProvince
********************************************/
CREATE OR ALTER PROCEDURE RH.stateProvince_insert @stateProvinceName varchar(50), @stateProvinceCode varchar(5)
AS
	declare
		@error varchar(300),
		@stateProvinceExistsID int

	set @stateProvinceExistsID = RH.udf_stateProvinceExists(@stateProvinceName)


	if @stateProvinceExistsID = 0
	begin
		insert into RH.StateProvince values(@stateProvinceName, @stateProvinceCode)
	end
	else
	begin
		set @error = 'RH.stateProvince_insert -> Já existe um estado com este nome (' + @stateProvinceName + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.stateProvince_insert 'Setubal', 'Se';
--EXEC RH.stateProvince_insert 'Alabama', 'AL';
GO

CREATE OR ALTER PROCEDURE RH.stateProvince_update @stateProvinceId int, @stateProvinceName varchar(50), @stateProvinceCode varchar(5)
AS
	declare
		@error varchar(300),
		@stateProvinceExistsID int

	set @stateProvinceExistsID = RH.udf_stateProvinceExistsById(@stateProvinceId)

	if @stateProvinceExistsID != 0
	begin
		update RH.StateProvince
		set StaProName = @stateProvinceName, StaProCode = @stateProvinceCode
		where StaProId = @stateProvinceId
	end
	else
	begin
		set @error = 'RH.stateProvince_update -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.stateProvince_update 3, 'Alabama', 'AL';
--EXEC RH.stateProvince_update 2, 'Alabama', 'AL';
--EXEC RH.stateProvince_update 2, 'Alabama', 'AK';
GO

CREATE OR ALTER PROCEDURE RH.stateProvince_delete @stateProvinceId int
AS
	declare
		@error varchar(300),
		@stateProvinceExistsID int
		
	set @stateProvinceExistsID = RH.udf_stateProvinceExistsById(@stateProvinceId)

	if @stateProvinceExistsID != 0
	begin
		delete from RH.StateProvince
		where StaProId = @stateProvinceId
	end
	else
	begin
		set @error = 'RH.stateProvince_delete -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.stateProvince_delete 2;
--EXEC RH.stateProvince_delete 3;
GO

/********************************************
* City
********************************************/
CREATE OR ALTER PROCEDURE RH.city_insert @cityName varchar(50), @citySalesTerritory varchar(50), @cityLastPopulationRecord int
AS
	declare
		@error varchar(300),
		@cityExistsID int

	set @cityExistsID = RH.udf_cityExists(@cityName)


	if @cityExistsID = 0
	begin
		insert into RH.City values(@cityName, @citySalesTerritory, @cityLastPopulationRecord)
	end
	else
	begin
		set @error = 'RH.city_insert -> Já existe uma cidade com este nome (' + @cityName + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.city_insert 'Setubal', 'Mideast', 613;
--EXEC RH.city_insert 'Aaronsburg', 'Mideast', 613;
GO

CREATE OR ALTER PROCEDURE RH.city_update @cityId int, @cityName varchar(50), @citySalesTerritory varchar(50), @cityLastPopulationRecord int
AS
	declare
		@error varchar(300),
		@cityExistsID int

	set @cityExistsID = RH.udf_cityExistsById(@cityId)

	if @cityExistsID != 0
	begin
		update RH.City
		set CitName = @cityName, CitSalesTerritory = @citySalesTerritory, CitLasPopulationRecord = @cityLastPopulationRecord
		where CitId = @cityId
	end
	else
	begin
		set @error = 'RH.city_update -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.city_update 3, 'Aaronsburg', 'Mideast', 613;
--EXEC RH.city_update 2, 'Aaronsburg', 'Southeast', 613;
--EXEC RH.city_update 2, 'Aaronsburg', 'Mideast', 613;
GO

CREATE OR ALTER PROCEDURE RH.city_delete @cityId int
AS
	declare
		@error varchar(300),
		@cityExistsID int

	set @cityExistsID = RH.udf_cityExistsById(@cityId)

	if @cityExistsID != 0
	begin
		delete from RH.City
		where CitId = @cityId
	end
	else
	begin
		set @error = 'RH.city_delete -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.city_delete 2;
--EXEC RH.city_delete 3;
GO

/********************************************
* Category
********************************************/
CREATE OR ALTER PROCEDURE RH.category_insert @categoryName varchar(50)
AS
	declare
		@error varchar(300),
		@categoryExistsID int

	set @categoryExistsID = RH.udf_categoryExists(@categoryName)


	if @categoryExistsID = 0
	begin
		insert into RH.Category values(@categoryName)
	end
	else
	begin
		set @error = 'RH.category_insert -> Já existe uma categoria com este nome (' + @categoryName + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.category_insert 'Bike Shop';
--EXEC RH.category_insert '24H Shop';
GO

CREATE OR ALTER PROCEDURE RH.category_update @categoryId int, @categoryName varchar(50)
AS
	declare
		@error varchar(300),
		@categoryExistsID int

	set @categoryExistsID = RH.udf_categoryExistsById(@categoryId)

	if @categoryExistsID != 0
	begin
		update RH.Category
		set CatName = @categoryName
		where CatId = @categoryId
	end
	else
	begin
		set @error = 'RH.category_update -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.category_update 3, '24H Shop';
--EXEC RH.category_update 2, 'Quiosk';
--EXEC RH.category_update 2, '24H Shop';
GO

CREATE OR ALTER PROCEDURE RH.category_delete @categoryId int
AS
	declare
		@error varchar(300),
		@categoryExistsID int

	set @categoryExistsID = RH.udf_categoryExistsById(@categoryId)

	if @categoryExistsID != 0
	begin
		delete from RH.Category
		where CatId = @categoryId
	end
	else
	begin
		set @error = 'RH.category_delete -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.category_delete 2;
--EXEC RH.category_delete 3;
GO

/********************************************
* Region Category
********************************************/
CREATE OR ALTER PROCEDURE RH.regionCategory_insert @countryId int, @stateProvinceId int, @cityId int, @categoryId int, @postalCode int
AS
	declare
		@error varchar(300),
		@regionCategoryExistsID int,
		@countryExistsId int, 
		@stateProvinceExistsId int, 
		@cityExistsId int, 
		@categoryExistsId int

	set @regionCategoryExistsID = RH.udf_regionCategoryExists(@countryId, @stateProvinceId, @cityId, @categoryId)
	set @countryExistsId = RH.udf_countryExistsById(@countryId)
	set @stateProvinceExistsId = RH.udf_stateProvinceExistsById(@stateProvinceId) 
	set @cityExistsId = RH.udf_cityExistsById(@cityId)
	set @categoryExistsId = RH.udf_categoryExistsById(@categoryId)


	if @regionCategoryExistsID = 0 and @countryExistsId != 0 and @stateProvinceExistsId != 0 and @cityExistsId != 0 and @categoryExistsId != 0
	begin
		insert into RH.Region_Category values(@stateProvinceId, @cityId, @categoryId, @countryId, @postalCode)
	end
	else
	begin
		if @regionCategoryExistsID != 0
		begin
			set @error = 'RH.regionCategory_insert -> Já existe uma relação entre este pais, estado, cidade e categoria (' + cast(@countryId as varchar(10)) + ', ' + cast(@stateProvinceId as varchar(10)) + ', ' + cast(@cityId as varchar(10)) + ', ' + cast(@categoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @countryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @stateProvinceExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @cityExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @categoryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
	end
GO
EXEC RH.regionCategory_insert 1, 1, 1, 1, 2344;
--EXEC RH.regionCategory_insert 3, 3, 3, 3, 2344;
GO

CREATE OR ALTER PROCEDURE RH.regionCategory_update @regionCategoryId int, @countryId int, @stateProvinceId int, @cityId int, @categoryId int, @postalCode int
AS
	declare
		@error varchar(300),
		@regionCategoryExistsID int,
		@countryExistsId int, 
		@stateProvinceExistsId int, 
		@cityExistsId int, 
		@categoryExistsId int

	set @regionCategoryExistsID = RH.udf_regionCategoryExistsById(@regionCategoryId)
	set @countryExistsId = RH.udf_countryExistsById(@countryId)
	set @stateProvinceExistsId = RH.udf_stateProvinceExistsById(@stateProvinceId) 
	set @cityExistsId = RH.udf_cityExistsById(@cityId)
	set @categoryExistsId = RH.udf_categoryExistsById(@categoryId)

	if @regionCategoryExistsID != 0 and @countryExistsId != 0 and @stateProvinceExistsId != 0 and @cityExistsId != 0 and @categoryExistsId != 0
	begin
		update RH.Region_Category
		set Reg_CatCategoryId = @categoryId, Reg_CatStateProvinceId = @stateProvinceId, Reg_CatCityId = @cityId, Reg_CatCountryId = @countryId, Reg_CatPostalCode = @postalCode
		where Reg_CatId = @regionCategoryId
	end
	else
	begin
		if @regionCategoryExistsID = 0
		begin
			set @error = 'RH.regionCategory_update -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @countryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @stateProvinceExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @cityExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end

		if @categoryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.regionCategory_update 2, 1, 1, 1, 1, 2344;
--EXEC RH.regionCategory_update 2, 3, 3, 3, 3, 2346;
--EXEC RH.regionCategory_update 3, 1, 1, 1, 1, 2344;
GO

CREATE OR ALTER PROCEDURE RH.regionCategory_delete @regionCategoryId int
AS
	declare
		@error varchar(300),
		@regionCategoryExistsID int

	set @regionCategoryExistsID = RH.udf_regionCategoryExistsById(@regionCategoryId)

	if @regionCategoryExistsID != 0
	begin
		delete from RH.Region_Category
		where Reg_CatId = @regionCategoryId
	end
	else
	begin
		set @error = 'RH.regionCategory_delete -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.regionCategory_delete 2;
--EXEC RH.regionCategory_delete 3;
GO

/********************************************
* Buiyng Group
********************************************/
CREATE OR ALTER PROCEDURE RH.buiyngGroup_insert @buiyngGroupName varchar(50)
AS
	declare
		@error varchar(300),
		@buiyngGroupExistsID int

	set @buiyngGroupExistsID = RH.udf_buiyngGroupExists(@buiyngGroupName)


	if @buiyngGroupExistsID = 0
	begin
		insert into RH.BuyingGroup values(@buiyngGroupName)
	end
	else
	begin
		set @error = 'RH.buiyngGroup_insert -> Já existe um grupo com este nome (' + @buiyngGroupName + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.buiyngGroup_insert 'IPS';
--EXEC RH.buiyngGroup_insert 'Tailspin Toys';
GO

CREATE OR ALTER PROCEDURE RH.buiyngGroup_update @buiyngGroupId int, @buiyngGroupName varchar(50)
AS
	declare
		@error varchar(300),
		@buiyngGroupExistsID int

	set @buiyngGroupExistsID = RH.udf_buiyngGroupExistsById(@buiyngGroupId)

	if @buiyngGroupExistsID != 0
	begin
		update RH.BuyingGroup
		set BuyGrouName = @buiyngGroupName
		where BuyGrouId = @buiyngGroupId
	end
	else
	begin
		set @error = 'RH.buiyngGroup_update -> Não existe nenhum grupo com este id (' + cast(@buiyngGroupId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.buiyngGroup_update 3, 'Tailspin Toys';
--EXEC RH.buiyngGroup_update 2, 'Wingtip Toys';
--EXEC RH.buiyngGroup_update 2, 'Tailspin Toys';
GO

CREATE OR ALTER PROCEDURE RH.buiyngGroup_delete @buiyngGroupId int
AS
	declare
		@error varchar(300),
		@buiyngGroupExistsID int

	set @buiyngGroupExistsID = RH.udf_buiyngGroupExistsById(@buiyngGroupId)

	if @buiyngGroupExistsID != 0
	begin
		delete from RH.BuyingGroup
		where BuyGrouId = @buiyngGroupId
	end
	else
	begin
		set @error = 'RH.buiyngGroup_delete -> Não existe nenhum grupo com este id (' + cast(@buiyngGroupId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.buiyngGroup_delete 2;
--EXEC RH.buiyngGroup_delete 3;
GO

/********************************************
* Sys User
********************************************/
CREATE OR ALTER PROCEDURE RH.sysUser_insert @sysUserName varchar(50), @sysUserEmail varchar(50), @sysUserPassword varchar(50) 
AS
	declare
		@error varchar(300),
		@sysUserExistsID int

	set @sysUserExistsID = RH.udf_sysUserExists(@sysUserEmail)


	if @sysUserExistsID = 0
	begin
		insert into RH.SysUser values(@sysUserEmail, (RH.udf_fnHashPassword(@sysUserPassword)), @sysUserName)
	end
	else
	begin
		set @error = 'RH.sysUser_insert -> Já existe um utilizador com este email (' + @sysUserEmail + ')'
		EXEC RH.errorLog_insert @error
	end
GO
EXEC RH.sysUser_insert 'IPS (Head Office)', 'ips@ips.com', 'Pass123';
EXEC RH.sysUser_insert 'EST', 'est@ips.com', 'Pass123';
EXEC RH.sysUser_insert 'Nuno Reis', 'nunoreis@ips.com', 'Pass123';
--EXEC RH.sysUser_insert 'Tailspin Toys (Head Office)', 'HeadOffice@Tailspin_Toys.com', 'Pass123';
--EXEC RH.sysUser_insert 'Eva Muirden', 'Eva_Muirden@employees.com', 'Pass123';
GO

CREATE OR ALTER PROCEDURE RH.sysUser_update @sysUserId int, @sysUserName varchar(50), @sysUserEmail varchar(50), @sysUserPassword varchar(50) 
AS
	declare
		@error varchar(300),
		@sysUserExistsID int

	set @sysUserExistsID = RH.udf_sysUserExistsById(@sysUserId)

	if @sysUserExistsID != 0
	begin
		update RH.SysUser
		set SysUseName = @sysUserName, SysUseEmail = @sysUserEmail, SysUsePassword = RH.udf_fnHashPassword(@sysUserPassword)
		where SysUseId = @sysUserId
	end
	else
	begin
		set @error = 'RH.sysUser_update -> Não existe nenhum utilizador com este id (' + cast(@sysUserId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sysUser_update 5, 'Tailspin Toys (Head Office)', 'HeadOffice@Tailspin_Toys.com', 'Pass123';
--EXEC RH.sysUser_update 4, 'Tailspin Toys', 'HeadOffice@Tailspin_Toys.com', 'Pass123';
--EXEC RH.sysUser_update 4, 'Tailspin Toys (Head Office)', 'HeadOffice@Tailspin_Toys.com', 'Pass123';
GO

CREATE OR ALTER PROCEDURE RH.sysUser_delete @sysUserId int
AS
	declare
		@error varchar(300),
		@sysUserExistsID int

	set @sysUserExistsID = RH.udf_sysUserExistsById(@sysUserId)

	if @sysUserExistsID != 0
	begin
		delete from RH.SysUser
		where SysUseId = @sysUserId
	end
	else
	begin
		set @error = 'RH.sysUser_delete -> Não existe nenhum utilizador com este id (' + cast(@sysUserId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sysUser_delete 4;
--EXEC RH.sysUser_delete 5;
GO

/********************************************
* Customer
********************************************/
CREATE OR ALTER PROCEDURE RH.customer_insert @userId int, @headquartersId int, @regionCategoryId int, @buyingGroupId int, @primaryContact varchar(40)
AS
	declare
		@error varchar(300),
		@customerExistsID int,
		@userExistsId int,
		@headquartersExistsId int,
		@regionCategoryExistsId int,
		@buyingGroupExistsId int

	set @customerExistsID = RH.udf_customerExistsById(@userId)
	set @userExistsId = RH.udf_sysUserExistsById(@userId)
	set @headquartersExistsId = RH.udf_customerExistsById(@headquartersId)
	set @regionCategoryExistsId = RH.udf_regionCategoryExistsById(@regionCategoryId)
	set @buyingGroupExistsId = RH.udf_buiyngGroupExistsById(@buyingGroupId)

	if @customerExistsID = 0 and @userExistsId != 0 and @headquartersExistsId != 0 and @regionCategoryExistsId != 0 and @buyingGroupExistsId != 0
	begin
		insert into RH.Customer values(@userId, @headquartersId, @regionCategoryId, @buyingGroupId, @primaryContact)
	end
	else
	begin
		if @customerExistsID != 0
		begin
			set @error = 'RH.customer_insert -> Já existe um cliente com este id de utilizador (' + @userId + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @userExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum utilizador com este id (' + cast(@userId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @headquartersExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum cliente com este id (' + cast(@headquartersId as varchar(10)) + ') - headquarters'
			EXEC RH.errorLog_insert @error
		end
		
		if @regionCategoryExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @buyingGroupExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum grupo com este id (' + cast(@buyingGroupId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
	end
GO
insert into RH.Customer values(1, 1, 1, 1, 'João Sousa')
go
EXEC RH.customer_insert 2, 1, 1, 1, 'João Sousa';
--EXEC RH.customer_insert 5, 1, 3, 3, 'Nuno Reis';
--EXEC RH.customer_insert 7, 1, 1, 1, 'Nuno Reis';
GO

CREATE OR ALTER PROCEDURE RH.customer_update @userId int, @headquartersId int, @regionCategoryId int, @buyingGroupId int, @primaryContact varchar(40)
AS
	declare
		@error varchar(300),
		@customerExistsID int,
		@userExistsId int,
		@headquartersExistsId int,
		@regionCategoryExistsId int,
		@buyingGroupExistsId int

	set @customerExistsID = RH.udf_customerExistsById(@userId)
	set @userExistsId = RH.udf_sysUserExistsById(@userId)
	set @headquartersExistsId = RH.udf_customerExistsById(@headquartersId)
	set @regionCategoryExistsId = RH.udf_regionCategoryExistsById(@regionCategoryId)
	set @buyingGroupExistsId = RH.udf_buiyngGroupExistsById(@buyingGroupId)

	if @customerExistsID != 0 and @userExistsId != 0 and @headquartersExistsId != 0 and @regionCategoryExistsId != 0 and @buyingGroupExistsId != 0
	begin
		update RH.Customer
		set CusUserId = @userId, CusHeadquartersId = @headquartersId, CusRegion_CategoryId = @regionCategoryId, CusBuyingGroupId = @buyingGroupId, CusPrimaryContact = @primaryContact
		where CusUserId = @userId
	end
	else
	begin
		if @customerExistsID = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum cliente com este id (' + cast(@userId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @userExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum utilizador com este id (' + cast(@userId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @headquartersExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum cliente com este id (' + cast(@headquartersId as varchar(10)) + ') - headquarters'
			EXEC RH.errorLog_insert @error
		end
		
		if @regionCategoryExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
		
		if @buyingGroupExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum grupo com este id (' + cast(@buyingGroupId as varchar(10)) + ')'
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.customer_update 6, 2, 10, 2, 'Nuno Reis';
--EXEC RH.customer_update 5, 1, 3, 1, 'Nuno Reis';
--EXEC RH.customer_update 5, 1, 3, 3, 'Nuno Reis';
GO

CREATE OR ALTER PROCEDURE RH.customer_delete @userId int
AS
	declare
		@error varchar(300),
		@customerExistsID int
		
	set @customerExistsID = RH.udf_customerExistsById(@userId)

	if @customerExistsID != 0
	begin
		delete from RH.Customer
		where CusUserId = @userId
	end
	else
	begin
		set @error = 'RH.customer_delete -> Não existe nenhum cliente com este id (' + cast(@userId as varchar(10)) + ')'
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.customer_delete 5;
--EXEC RH.customer_delete 6;
GO

/********************************************
* Employee
********************************************/
