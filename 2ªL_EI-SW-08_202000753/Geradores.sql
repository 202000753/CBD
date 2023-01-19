/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Criar os stored procedures geradores
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.country_insert 'Espanha', 'Europe';
GO

CREATE OR ALTER PROCEDURE RH.country_update @countryId int, @countryName varchar(20), @continentName varchar(20)
AS
	declare
		@error varchar(300),
		@countryExistsID int,
		@oldCountryExistsID int

	set @countryExistsID = RH.udf_countryExistsById(@countryId)

	if @countryExistsID != 0
	begin
		set @oldCountryExistsID = RH.udf_countryExists(@countryName, @continentName)
		
		if @oldCountryExistsID = 0
		begin
			update RH.Country
			set CouName = @countryName, CouContinent = @continentName
			where CouId = @countryId
		end
		else
		begin
			set @error = 'RH.country_update -> Já existe um pais com este nome e continente (' + @countryName + ', ' + @continentName + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'RH.country_update -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.country_update 1, 'Portugal', 'Europe';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.country_delete 1;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.stateProvince_insert 'Faro', 'Fa';
GO

CREATE OR ALTER PROCEDURE RH.stateProvince_update @stateProvinceId int, @stateProvinceName varchar(50), @stateProvinceCode varchar(5)
AS
	declare
		@error varchar(300),
		@stateProvinceExistsID int,
		@oldStateProvinceExistsID int

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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.stateProvince_update 1, 'Setubal', 'Se';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.stateProvince_delete 1;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.city_insert 'Almada', 'North', 613;
GO

CREATE OR ALTER PROCEDURE RH.city_update @cityId int, @cityName varchar(50), @citySalesTerritory varchar(50), @cityLastPopulationRecord int
AS
	declare
		@error varchar(300),
		@cityExistsID int,
		@oldCityExistsID int

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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.city_update 1, 'Setubal', 'Center', 613;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.city_delete 1;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.category_insert 'Bike Shop';
GO

CREATE OR ALTER PROCEDURE RH.category_update @categoryId int, @categoryName varchar(50)
AS
	declare
		@error varchar(300),
		@categoryExistsID int,
		@oldCategoryExistsID int

	set @categoryExistsID = RH.udf_categoryExistsById(@categoryId)

	if @categoryExistsID != 0
	begin
		set @oldCategoryExistsID = RH.udf_categoryExists(@categoryName)
		
		if @oldCategoryExistsID = 0
		begin
			update RH.Category
			set CatName = @categoryName
			where CatId = @categoryId
		end
		else
		begin
			set @error = 'RH.category_update -> Já existe uma categoria com este nome (' + @categoryName + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'RH.category_update -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.category_update 1, 'Bike Shop';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.category_delete 2;
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
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @countryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @stateProvinceExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @cityExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @categoryExistsId = 0
		begin
			set @error = 'RH.regionCategory_insert -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.regionCategory_insert 1, 1, 1, 1, 2344;
GO

CREATE OR ALTER PROCEDURE RH.regionCategory_update @regionCategoryId int, @countryId int, @stateProvinceId int, @cityId int, @categoryId int, @postalCode int
AS
	declare
		@error varchar(300),
		@regionCategoryExistsID int,
		@countryExistsId int, 
		@stateProvinceExistsId int, 
		@cityExistsId int, 
		@categoryExistsId int,
		@oldRegionCategoryExistsID int

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
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @countryExistsId = 0
		begin
			set @error = 'RH.regionCategory_update -> Não existe nenhum pais com este id (' + cast(@countryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @stateProvinceExistsId = 0
		begin
			set @error = 'RH.regionCategory_update -> Não existe nenhum estado com este id (' + cast(@stateProvinceId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @cityExistsId = 0
		begin
			set @error = 'RH.regionCategory_update -> Não existe nenhuma cidade com este id (' + cast(@cityId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @categoryExistsId = 0
		begin
			set @error = 'RH.regionCategory_update -> Não existe nenhuma categoria com este id (' + cast(@categoryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.regionCategory_update 2, 1, 1, 1, 1, 2344;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.regionCategory_delete 2;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.buiyngGroup_insert 'P';
GO

CREATE OR ALTER PROCEDURE RH.buiyngGroup_update @buiyngGroupId int, @buiyngGroupName varchar(50)
AS
	declare
		@error varchar(300),
		@buiyngGroupExistsID int,
		@oldBuiyngGroupExistsID int

	set @buiyngGroupExistsID = RH.udf_buiyngGroupExistsById(@buiyngGroupId)

	if @buiyngGroupExistsID != 0
	begin
		set @oldBuiyngGroupExistsID = RH.udf_buiyngGroupExists(@buiyngGroupName)

		if @oldBuiyngGroupExistsID = 0
		begin
			update RH.BuyingGroup
			set BuyGrouName = @buiyngGroupName
			where BuyGrouId = @buiyngGroupId
		end
		else
		begin
			set @error = 'RH.buiyngGroup_update -> Já existe um grupo com este nome (' + @buiyngGroupName + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'RH.buiyngGroup_update -> Não existe nenhum grupo com este id (' + cast(@buiyngGroupId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.buiyngGroup_update 2, 'P';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.buiyngGroup_delete 2;
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sysUser_insert 'IPS', 'ips@ips.com', 'Pass123';
GO

CREATE OR ALTER PROCEDURE RH.sysUser_update @sysUserId int, @sysUserName varchar(50), @sysUserEmail varchar(50), @sysUserPassword varchar(50) 
AS
	declare
		@error varchar(300),
		@sysUserExistsID int,
		@oldSysUserExistsID int

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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sysUser_update 1, 'IPS(Head Office)', 'ips@ips.com', 'Pass123';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sysUser_delete 2;
GO

/********************************************
* Customer
********************************************/
CREATE OR ALTER PROCEDURE RH.customer_insert @userId int, @headquartersId int, @regionCategoryId int, @buyingGroupId int, @primaryContact varchar(40), @isHeadOficce bit
AS
	declare
		@error varchar(300),
		@customerExistsID int,
		@userExistsId int,
		@headquartersExistsId int,
		@regionCategoryExistsId int,
		@buyingGroupExistsId int,
		@employeeExistsID int

	set @customerExistsID = RH.udf_customerExistsById(@userId)
	set @userExistsId = RH.udf_sysUserExistsById(@userId)
	set @headquartersExistsId = RH.udf_customerExistsById(@headquartersId)
	set @regionCategoryExistsId = RH.udf_regionCategoryExistsById(@regionCategoryId)
	set @buyingGroupExistsId = RH.udf_buiyngGroupExistsById(@buyingGroupId)
	set @employeeExistsID = RH.udf_employeeExistsById(@userId)

	if @isHeadOficce = 1
	begin
		set @headquartersId = @userId
		set @headquartersExistsId = @userId
	end

	if @customerExistsID = 0 and @userExistsId != 0 and @headquartersExistsId != 0 and @regionCategoryExistsId != 0 and @buyingGroupExistsId != 0 and @employeeExistsID = 0
	begin
		insert into RH.Customer values(@userId, @headquartersId, @regionCategoryId, @buyingGroupId, @primaryContact)
	end
	else
	begin
		if @customerExistsID != 0
		begin
			set @error = 'RH.customer_insert -> Já existe um cliente com este id de utilizador (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @userExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum utilizador com este id (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @headquartersExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum cliente com este id (' + cast(@headquartersId as varchar(10)) + ') - headquarters'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @regionCategoryExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @buyingGroupExistsId = 0
		begin
			set @error = 'RH.customer_insert -> Não existe nenhum grupo com este id (' + cast(@buyingGroupId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @employeeExistsID != 0
		begin
			set @error = 'RH.customer_insert -> O utilizador com este id é um funcionario (' + cast(@userId as varchar(10)) + ', ' + cast(@employeeExistsID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.customer_insert 10, 1, 1, 1, 'João Sousa', 1;
GO

CREATE OR ALTER PROCEDURE RH.customer_update @userId int, @headquartersId int, @regionCategoryId int, @buyingGroupId int, @primaryContact varchar(40)
AS
	declare
		@error varchar(300),
		@customerExistsID int,
		@userExistsId int,
		@headquartersExistsId int,
		@regionCategoryExistsId int,
		@buyingGroupExistsId int,
		@employeeExistsID int,
		@oldCustomerExistsID int

	set @customerExistsID = RH.udf_customerExistsById(@userId)
	set @userExistsId = RH.udf_sysUserExistsById(@userId)
	set @headquartersExistsId = RH.udf_customerExistsById(@headquartersId)
	set @regionCategoryExistsId = RH.udf_regionCategoryExistsById(@regionCategoryId)
	set @buyingGroupExistsId = RH.udf_buiyngGroupExistsById(@buyingGroupId)
	set @employeeExistsID = RH.udf_employeeExistsById(@userId)

	if @customerExistsID != 0 and @userExistsId != 0 and @headquartersExistsId != 0 and @regionCategoryExistsId != 0 and @buyingGroupExistsId != 0 and @employeeExistsID = 0
	begin
		update RH.Customer
		set CusHeadquartersId = @headquartersId, CusRegion_CategoryId = @regionCategoryId, CusBuyingGroupId = @buyingGroupId, CusPrimaryContact = @primaryContact
		where CusUserId = @userId
	end
	else
	begin
		if @customerExistsID = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum cliente com este id (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @userExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum utilizador com este id (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @headquartersExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum cliente com este id (' + cast(@headquartersId as varchar(10)) + ') - headquarters'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @regionCategoryExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhuma relação entre este pais, estado, cidade e categoria com este id (' + cast(@regionCategoryId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @buyingGroupExistsId = 0
		begin
			set @error = 'RH.customer_update -> Não existe nenhum grupo com este id (' + cast(@buyingGroupId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @employeeExistsID != 0
		begin
			set @error = 'RH.customer_update -> O utilizador com este id é um funcionario (' + cast(@userId as varchar(10)) + ', ' + cast(@employeeExistsID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.customer_update 1, 10, 1, 1, 'João Sousa';
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
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.customer_delete 1;
GO

/********************************************
* Employee
********************************************/
CREATE OR ALTER PROCEDURE RH.employee_insert @userId int, @employeePreferedName VARCHAR(10), @employeeIsSalesPerson BIT
AS
	declare
		@error varchar(300),
		@employeeExistsID int,
		@customerExistsID int

	set @employeeExistsID = RH.udf_employeeExistsById(@userId)
	set @customerExistsID = RH.udf_customerExistsById(@userId)

	if @employeeExistsID = 0 and @customerExistsID = 0
	begin
		insert into RH.Employee values(@userId, @employeePreferedName, @employeeIsSalesPerson)
	end
	else
	begin
		if @employeeExistsID != 0
		begin
			set @error = 'RH.employee_insert -> Já existe um funcionario com este id de utilizador (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @customerExistsID != 0
		begin
			set @error = 'RH.employee_insert -> O utilizador com este id é um cliente (' + cast(@userId as varchar(10)) + ', ' + cast(@customerExistsID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.employee_insert 4, 'Nuno', 1;
GO

CREATE OR ALTER PROCEDURE RH.employee_update @userId int, @employeePreferedName VARCHAR(10), @employeeIsSalesPerson BIT
AS
	declare
		@error varchar(300),
		@employeeExistsID int,
		@customerExistsID int

	set @employeeExistsID = RH.udf_employeeExistsById(@userId)
	set @customerExistsID = RH.udf_customerExistsById(@userId)

	if @employeeExistsID != 0 and @customerExistsID = 0
	begin
		update RH.Employee
		set EmpPreferedName = @employeePreferedName, EmpIsSalesPerson = @employeeIsSalesPerson
		where EmpUserId = @userId
	end
	else
	begin
		if @employeeExistsID = 0
		begin
			set @error = 'RH.employee_update -> Não existe nenhum funcionario com este id (' + cast(@userId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @customerExistsID != 0
		begin
			set @error = 'RH.employee_update -> O utilizador com este id é um cliente (' + cast(@userId as varchar(10)) + ', ' + cast(@customerExistsID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.employee_update 4, 'Nuno', 1;
GO

CREATE OR ALTER PROCEDURE RH.employee_delete @userId int
AS
	declare
		@error varchar(300),
		@employeeExistsID int

	set @employeeExistsID = RH.udf_employeeExistsById(@userId)

	if @employeeExistsID != 0
	begin
		delete from RH.Employee
		where EmpUserId = @userId
	end
	else
	begin
		set @error = 'RH.employee_delete -> Não existe nenhum funcionario com este id (' + cast(@userId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.employee_delete 5;
GO

/********************************************
* Token
********************************************/
CREATE OR ALTER PROCEDURE RH.token_insert @tokenUserId INT
AS
	declare
		@error varchar(300),
		@token int,
		@tokenDateTime datetime,
		@tokenEndDateTime datetime,
		@userExistsID int,
		@tokenExistsID int

	set @userExistsID = RH.udf_sysUserExistsById(@tokenUserId)

	set @token = CAST(RAND() * 1000000 AS INT)

	set @tokenExistsID = RH.udf_tokenExists(@token)

	if @tokenExistsID = 0 and @userExistsID != 0
	begin
		set @tokenDateTime = GETDATE()
		set @tokenEndDateTime = DATEADD(day, +1, GETDATE())
		insert into RH.Token values(@tokenUserId, @tokenDateTime, @tokenEndDateTime, @token)
	end
	else
	begin
		if @tokenExistsID != 0
		begin
			set @error = 'RH.token_insert -> Já existe um token com este token (' + cast(@token as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @userExistsID = 0
		begin
			set @error = 'RH.token_insert -> Não existe nenhum cliente com este id (' + cast(@tokenUserId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC RH.token_insert 4;
GO

CREATE OR ALTER PROCEDURE RH.token_update @tokenId int
AS
	declare
		@error varchar(300),
		@tokenExistsID int
		
	set @tokenExistsID = RH.udf_tokenExistsById(@tokenId)

	if @tokenExistsID != 0
	begin
		update RH.Token
		set TokEndDateTime = GETDATE()
		where TokId = @tokenId
	end
	else
	begin
		set @error = 'RH.token_update -> Não existe nenhum token com este id (' + cast(@tokenExistsID as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.token_update 3;
GO

/********************************************
* Tax Rate
********************************************/
CREATE OR ALTER PROCEDURE Storage.taxRate_insert @taxRate float
AS
	declare
		@error varchar(300),
		@taxRateExistsID int

	set @taxRateExistsID = Storage.udf_taxRateExists(@taxRate)

	if @taxRateExistsID = 0
	begin
		insert into Storage.TaxRate values(@taxRate)
	end
	else
	begin
		set @error = 'Storage.taxRate_insert -> Já existe uma taxa com este valor (' + cast(@taxRate as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.taxRate_insert 3.2;
GO

CREATE OR ALTER PROCEDURE Storage.taxRate_update @taxRateId int, @taxRate float
AS
	declare
		@error varchar(300),
		@taxRateExistsID int,
		@oldTaxRateExistsID int

	set @taxRateExistsID = Storage.udf_taxRateExistsById(@taxRateId)

	if @taxRateExistsID != 0
	begin
		set @oldTaxRateExistsID = Storage.udf_taxRateExists(@taxRate)

		if @oldTaxRateExistsID = 0
		begin
			update Storage.TaxRate
			set TaxRatTaxRate = @taxRate
			where TaxRatId = @taxRateId
		end
		else
		begin
			set @error = 'Storage.taxRate_update -> Já existe uma taxa com este valor (' + cast(@taxRate as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.taxRate_update -> Não existe nenhuma taxa com este id (' + cast(@taxRateId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.taxRate_update 2, 3.2;
GO

CREATE OR ALTER PROCEDURE Storage.taxRate_delete @taxRateId int
AS
	declare
		@error varchar(300),
		@taxRateExistsID int

	set @taxRateExistsID = Storage.udf_taxRateExistsById(@taxRateId)

	if @taxRateExistsID != 0
	begin
		delete from Storage.TaxRate
		where TaxRatId = @taxRateId
	end
	else
	begin
		set @error = 'Storage.taxRate_delete -> Não existe nenhuma taxa com este id (' + cast(@taxRateId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.taxRate_delete 2;
GO

/********************************************
* Product Type
********************************************/
CREATE OR ALTER PROCEDURE Storage.productType_insert @productType VARCHAR(25)
AS
	declare
		@error varchar(300),
		@productTypeExistsID int

	set @productTypeExistsID = Storage.udf_productTypeExists(@productType)

	if @productTypeExistsID = 0
	begin
		insert into Storage.ProductType values(@productType)
	end
	else
	begin
		set @error = 'Storage.productType_insert -> Já existe um tipo de produto com este nome (' + @productType + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.productType_insert 'Molhado';
GO

CREATE OR ALTER PROCEDURE Storage.productType_update @productTypeId int, @productType VARCHAR(25)
AS
	declare
		@error varchar(300),
		@productTypeExistsID int,
		@oldProductTypeExistsID int

	set @productTypeExistsID = Storage.udf_productTypeExistsById(@productTypeId)

	if @productTypeExistsID != 0
	begin
		set @oldProductTypeExistsID = Storage.udf_productTypeExists(@productType)

		if @oldProductTypeExistsID = 0
		begin
			update Storage.ProductType
			set ProTypName = @productType
			where ProTypId = @productTypeId
		end
		else
		begin
			set @error = 'Storage.productType_update -> Já existe um tipo de produto com este nome (' + @productType + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.productType_update -> Não existe nenhum tipo de produto com este id (' + cast(@productTypeId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.productType_update 1, 'Congelado';
GO

CREATE OR ALTER PROCEDURE Storage.productType_delete @productTypeId int
AS
	declare
		@error varchar(300),
		@productTypeExistsID int

	set @productTypeExistsID = Storage.udf_productTypeExistsById(@productTypeId)

	if @productTypeExistsID != 0
	begin
		delete from Storage.ProductType
		where ProTypId = @productTypeId
	end
	else
	begin
		set @error = 'Storage.productType_delete -> Não existe nenhum tipo de produto com este id (' + cast(@productTypeId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.productType_delete 2;
GO

/********************************************
* Package
********************************************/
CREATE OR ALTER PROCEDURE Storage.package_insert @package VARCHAR(25)
AS
	declare
		@error varchar(300),
		@packageExistsID int

	set @packageExistsID = Storage.udf_packageExists(@package)

	if @packageExistsID = 0
	begin
		insert into Storage.Package values(@package)
	end
	else
	begin
		set @error = 'Storage.package_insert -> Já existe um pacote com este nome (' + @package + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.package_insert 'Pacote';
GO

CREATE OR ALTER PROCEDURE Storage.package_update @packageId int, @package VARCHAR(25)
AS
	declare
		@error varchar(300),
		@packageExistsID int,
		@oldPackageExistsID int

	set @packageExistsID = Storage.udf_packageExistsById(@packageId)

	if @packageExistsID != 0
	begin
		set @oldPackageExistsID = Storage.udf_packageExists(@package)

		if @oldPackageExistsID = 0
		begin
			update Storage.Package
			set PacPackage = @package
			where PacId = @packageId
		end
		else
		begin
			set @error = 'Storage.package_update -> Já existe um pacote com este nome (' + @package + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.package_update -> Não existe nenhum pacote com este id (' + cast(@packageId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.package_update 1, 'Saco';
GO

CREATE OR ALTER PROCEDURE Storage.package_delete @packageId int
AS
	declare
		@error varchar(300),
		@packageExistsID int

	set @packageExistsID = Storage.udf_packageExistsById(@packageId)

	if @packageExistsID != 0
	begin
		delete from Storage.Package
		where PacId = @packageId
	end
	else
	begin
		set @error = 'Storage.package_delete -> Não existe nenhum pacote com este id (' + cast(@packageId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.package_delete 2;
GO

/********************************************
* Brand
********************************************/
CREATE OR ALTER PROCEDURE Storage.brand_insert @brand VARCHAR(25)
AS
	declare
		@error varchar(300),
		@brandExistsID int

	set @brandExistsID = Storage.udf_brandExists(@brand)

	if @brandExistsID = 0
	begin
		insert into Storage.Brand values(@brand)
	end
	else
	begin
		set @error = 'Storage.brand_insert -> Já existe uma marca com este nome (' + @brand + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.brand_insert 'Nike';
GO

CREATE OR ALTER PROCEDURE Storage.brand_update @brandId int, @brand VARCHAR(25)
AS
	declare
		@error varchar(300),
		@brandExistsID int,
		@oldBrandExistsID int

	set @brandExistsID = Storage.udf_brandExistsById(@brandId)

	if @brandExistsID != 0
	begin
		set @oldBrandExistsID = Storage.udf_brandExists(@brand)

		if @oldBrandExistsID = 0
		begin
			update Storage.Brand
			set BraName = @brand
			where BraId = @brandId
		end
		else
		begin
			set @error = 'Storage.brand_update -> Já existe uma marca com este nome (' + @brand + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.brand_update -> Não existe nenhuma marca com este id (' + cast(@brandId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.brand_update 1, 'New Balance';
GO

CREATE OR ALTER PROCEDURE Storage.brand_delete @brandId int
AS
	declare
		@error varchar(300),
		@brandExistsID int
		
	set @brandExistsID = Storage.udf_brandExistsById(@brandId)

	if @brandExistsID != 0
	begin
		delete from Storage.Brand
		where BraId = @brandId
	end
	else
	begin
		set @error = 'Storage.brand_delete -> Não existe nenhuma marca com este id (' + cast(@brandId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.brand_delete 2;
GO

/********************************************
* Product
********************************************/
CREATE OR ALTER PROCEDURE Storage.product_insert @brandId int, @taxRateId int, @productTypeId int, @buyingPackageId int, @sellingPackageId int, @productName varchar(100), @productColor varchar(50), @productSize varchar(20), @productLeadTimeDays int, @productQuantityPerOuter int, @productStock int, @productBarCode varchar(20), @productUnitPrice float, @productRecommendedRetailPrice float, @productTypicalWeightPerUnit float
AS
	declare
		@error varchar(300),
		@productExistsID int,
		@brandExistsId int, 
		@taxRateExistsId int, 
		@productTypeExistsId int, 
		@buyingPackageExistsId int, 
		@sellingPackageExistsId int

	set @productExistsID = Storage.udf_productExists(@productName)
	set @brandExistsId = Storage.udf_brandExistsById(@brandId)
	set @taxRateExistsId = Storage.udf_taxRateExistsById(@taxRateId) 
	set @productTypeExistsId = Storage.udf_productTypeExistsById(@productTypeId)
	set @buyingPackageExistsId = Storage.udf_packageExistsById(@buyingPackageId)
	set @sellingPackageExistsId = Storage.udf_packageExistsById(@sellingPackageId)

	if @productExistsID = 0 and @brandExistsId != 0 and @taxRateExistsId != 0 and @productTypeExistsId != 0 and @buyingPackageExistsId != 0 and @sellingPackageExistsId != 0
	begin
		insert into Storage.Product values(@brandId, @taxRateId, @productTypeId, @buyingPackageId, @sellingPackageId, @productName, @productColor, @productSize, @productLeadTimeDays, @productQuantityPerOuter, @productStock, @productBarCode, @productUnitPrice, @productRecommendedRetailPrice, @productTypicalWeightPerUnit)
	end
	else
	begin
		if @productExistsID != 0
		begin
			set @error = 'Storage.product_insert -> Já existe um produto com este nome (' + @productName + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @brandExistsId = 0
		begin
			set @error = 'Storage.product_insert -> Não existe nenhuma marca com este id (' + cast(@brandId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @taxRateExistsId = 0
		begin
			set @error = 'Storage.product_insert -> Não existe nenhuma taxa com este id (' + cast(@taxRateId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @productTypeExistsId = 0
		begin
			set @error = 'Storage.product_insert -> Não existe nenhum tipo de produto com este id (' + cast(@productTypeId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @buyingPackageExistsId = 0
		begin
			set @error = 'Storage.product_insert -> Não existe nenhum pacote com este id (Buying Package - ' + cast(@buyingPackageId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @sellingPackageExistsId = 0
		begin
			set @error = 'Storage.product_insert -> Não existe nenhum pacote com este id (Selling Package - ' + cast(@sellingPackageId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Storage.product_insert 1, 1, 1, 1, 1, 'Tenís AirForce', 'Preto', '46', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
GO

CREATE OR ALTER PROCEDURE Storage.product_update @productId int, @brandId int, @taxRateId int, @productTypeId int, @buyingPackageId int, @sellingPackageId int, @productName varchar(100), @productColor varchar(50), @productSize varchar(20), @productLeadTimeDays int, @productQuantityPerOuter int, @productStock int, @productBarCode varchar(20), @productUnitPrice float, @productRecommendedRetailPrice float, @productTypicalWeightPerUnit float
AS
	declare
		@error varchar(300),
		@productExistsID int,
		@brandExistsId int, 
		@taxRateExistsId int, 
		@productTypeExistsId int, 
		@buyingPackageExistsId int, 
		@sellingPackageExistsId int

	set @productExistsID = Storage.udf_productExistsById(@productId)
	set @brandExistsId = Storage.udf_brandExistsById(@brandId)
	set @taxRateExistsId = Storage.udf_taxRateExistsById(@taxRateId) 
	set @productTypeExistsId = Storage.udf_productTypeExistsById(@productTypeId)
	set @buyingPackageExistsId = Storage.udf_packageExistsById(@buyingPackageId)
	set @sellingPackageExistsId = Storage.udf_packageExistsById(@sellingPackageId)

	if @productExistsID != 0 and @brandExistsId != 0 and @taxRateExistsId != 0 and @productTypeExistsId != 0 and @buyingPackageExistsId != 0 and @sellingPackageExistsId != 0
	begin
		update Storage.Product
		set ProdBrandId = @brandId, ProdTaxRateId = @taxRateId, ProdProductTypeId = @productTypeId, ProdBuyingPackageId = @buyingPackageId, ProdSellingPackageId = @sellingPackageId, ProdName = @productName, ProdColor = @productColor, ProdSize = @productSize, ProdLeadTimeDays = @productLeadTimeDays, ProdQuantityPerOuter = @productQuantityPerOuter, ProdStock = @productStock, ProdBarCode = @productBarCode, ProdUnitPrice = @productUnitPrice, ProdRecommendedRetailPrice = @productRecommendedRetailPrice, ProdTypicalWeightPerUnit = @productTypicalWeightPerUnit
		where ProdId = @productId
	end
	else
	begin
		if @productExistsID = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhum produto com este id (' + cast(@productId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @brandExistsId = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhuma marca com este id (' + cast(@brandId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @taxRateExistsId = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhuma taxa com este id (' + cast(@taxRateId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @productTypeExistsId = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhum tipo de produto com este id (' + cast(@productTypeId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @buyingPackageExistsId = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhum pacote com este id (Buying Package - ' + cast(@buyingPackageId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end

		if @sellingPackageExistsId = 0
		begin
			set @error = 'Storage.product_update -> Não existe nenhum pacote com este id (Selling Package - ' + cast(@sellingPackageId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Storage.product_update 1, 1, 1, 1, 1, 1, 'Calções', 'Preto', 'L', 7, 12, 30, 'N/A', 18.00, 26.91, 0.400;
GO

CREATE OR ALTER PROCEDURE Storage.product_delete @productId int
AS
	declare
		@error varchar(300),
		@productExistsID int
		
	set @productExistsID = Storage.udf_productExistsById(@productId)

	if @productExistsID != 0
	begin
		delete from Storage.Product
		where ProdId = @productId
	end
	else
	begin
		set @error = 'Storage.product_delete -> Não existe nenhum produto com este id (' + cast(@productId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.product_delete 2;
GO

/********************************************
* Promotion
********************************************/
CREATE OR ALTER PROCEDURE Storage.promotion_insert @promotionDescription VARCHAR(100), @promotionStartDate VARCHAR(20), @promotionEndDate VARCHAR(20)
AS
	declare
		@error varchar(300),
		@promotionExistsID int

	set @promotionExistsID = Storage.udf_promotionExists(@promotionDescription)

	if @promotionExistsID = 0
	begin
		if CAST(@promotionStartDate AS date) < CAST(@promotionEndDate AS date)
		begin
			insert into Storage.Promotion values(@promotionDescription, CAST(@promotionStartDate AS date), CAST(@promotionEndDate AS date))
		end
		else
		begin
			set @error = 'Storage.promotion_insert -> Data de inicio maior que data de fim (' + @promotionStartDate + ' > ' + @promotionEndDate + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.promotion_insert -> Já existe uma promoção com esta descrição (' + @promotionDescription + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.promotion_insert 'Nova Promoção', '2022-08-25', '2032-08-25';
GO

CREATE OR ALTER PROCEDURE Storage.promotion_update @promotionId int, @promotionDescription VARCHAR(100), @promotionStartDate VARCHAR(20), @promotionEndDate VARCHAR(20)
AS
	declare
		@error varchar(300),
		@promotionExistsID int,
		@oldPromotionExistsID int

	set @promotionExistsID = Storage.udf_promotionExistsById(@promotionId)

	if @promotionExistsID != 0
	begin
		if CAST(@promotionStartDate AS date) < CAST(@promotionEndDate AS date)
		begin
			update Storage.Promotion
			set PromDescription = @promotionDescription, PromStartDate = @promotionStartDate, PromEndDate = @promotionEndDate
			where PromId = @promotionId
		end
		else
		begin
			set @error = 'Storage.promotion_insert -> Data de inicio maior que data de fim (' + @promotionStartDate + ' > ' + @promotionEndDate + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Storage.promotion_update -> Não existe nenhuma promoção com este id (' + cast(@promotionId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.promotion_update 1, 'No Promotion', '2022-08-25', '2032-03-25';
GO

CREATE OR ALTER PROCEDURE Storage.promotion_delete @promotionId int
AS
	declare
		@error varchar(300),
		@promotionExistsID int
		
	set @promotionExistsID = Storage.udf_promotionExistsById(@promotionId)

	if @promotionExistsID != 0
	begin
		delete from Storage.Promotion
		where PromId = @promotionId
	end
	else
	begin
		set @error = 'Storage.promotion_delete -> Não existe nenhuma promoção com este id (' + cast(@promotionId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.promotion_delete 1;
GO

/********************************************
* Product Promotion
********************************************/
CREATE OR ALTER PROCEDURE Storage.productPromotion_insert @productId int, @promotionId int
AS
	declare
		@error varchar(300),
		@productPromotionExistsID int,
		@productExistsID int,
		@promotionExistsID int
		
	set @productPromotionExistsID = Storage.udf_productPromotionExists(@productId, @promotionId)
	set @productExistsID = Storage.udf_productExistsById(@productId)
	set @promotionExistsID = Storage.udf_promotionExistsById(@promotionId)

	if @productPromotionExistsID = 0 and @productExistsID != 0 and @promotionExistsID != 0
	begin
		insert into Storage.Product_Promotion(Prod_PromProductId, Prod_PromPromotionId) values(@productId, @promotionId)
	end
	else
	begin
		if @productpromotionExistsID != 0
		begin
			set @error = 'Storage.productPromotion_insert -> Já existe uma relação entre produto e promoção (' + cast(@productId as varchar(10)) + ', ' + cast(@promotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @productExistsID = 0
		begin
			set @error = 'Storage.productPromotion_insert -> Não existe nenhum produto com este id (' + cast(@productId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @promotionExistsID = 0
		begin
			set @error = 'Storage.productPromotion_insert -> Não existe nenhuma promoção com este id (' + cast(@promotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Storage.productPromotion_insert 1, 1;
GO

CREATE OR ALTER PROCEDURE Storage.productPromotion_update @productPromotionId int, @productId int, @promotionId int
AS
	declare
		@error varchar(300),
		@productPromotionExistsID int,
		@productExistsID int,
		@promotionExistsID int,
		@oldProductPromotionExistsID int
		
	set @productPromotionExistsID = Storage.udf_productPromotionExistsById(@productPromotionId)
	set @productExistsID = Storage.udf_productExistsById(@productId)
	set @promotionExistsID = Storage.udf_promotionExistsById(@promotionId)

	if @productPromotionExistsID != 0 and @productExistsID != 0 and @promotionExistsID != 0
	begin
		set @oldProductPromotionExistsID = Storage.udf_productPromotionExists(@productId, @promotionId)
		
		if @oldProductPromotionExistsID = 0
		begin
			update Storage.Product_Promotion
			set Prod_PromProductId = @productId, Prod_PromPromotionId = @promotionId
			where Prod_PromProductPromotionId = @productpromotionId
		end
		else
		begin
			set @error = 'Storage.productPromotion_update -> Já existe uma relação entre produto e promoção (' + cast(@productId as varchar(10)) + ', ' + cast(@promotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		if @productpromotionExistsID = 0
		begin
			set @error = 'Storage.productPromotion_update -> Não existe nenhuma relação entre produto e promoção este id (' + cast(@productPromotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @productExistsID = 0
		begin
			set @error = 'Storage.productPromotion_update -> Não existe nenhum produto com este id (' + cast(@productId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @promotionExistsID = 0
		begin
			set @error = 'Storage.productPromotion_update -> Não existe nenhuma promoção com este id (' + cast(@promotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Storage.productPromotion_update 1, 1, 1;
GO

CREATE OR ALTER PROCEDURE Storage.productPromotion_delete @productPromotionId int
AS
	declare
		@error varchar(300),
		@productPromotionExistsID int
		
	set @productPromotionExistsID = Storage.udf_productpromotionExistsById(@productPromotionId)

	if @productPromotionExistsID != 0
	begin
		delete from Storage.Product_Promotion
		where Prod_PromProductPromotionId = @productPromotionId
	end
	else
	begin
		set @error = 'Storage.productpromotion_delete -> Não existe nenhuma relação entre produto e promoção este id (' + cast(@productPromotionId as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Storage.productPromotion_delete 1;
GO

/********************************************
* Sale
********************************************/
CREATE OR ALTER PROCEDURE Sales.sale_insert @saleID int, @customerId int, @employeeId int, @saleDescription VARCHAR(100)
AS
	declare
		@error varchar(300),
		@saleExistsID int,
		@customerExistsID int,
		@employeeExistsID int,
		@employeeType bit

	set @saleExistsID = Sales.udf_saleExistsById(@saleID)
	set @customerExistsID = RH.udf_customerExistsById(@customerId)
	set @employeeExistsID = RH.udf_employeeExistsById(@employeeId)

	if @saleExistsID = 0 and @customerExistsID != 0 and @employeeExistsID != 0
	begin
		set @employeeType = (select EmpIsSalesPerson from RH.Employee where EmpUserId = @employeeId)
		
		if @employeeType = 1
		begin
			SET IDENTITY_INSERT Sales.Sale ON 
			insert into Sales.Sale(SalID, SalCustomerId, SalEmployeeId, SalDescription, SalDate, SalIsFinished) values(@saleID, @customerId, @employeeId, @saleDescription, GETDATE(), 0)
			SET IDENTITY_INSERT Sales.Sale OFF
		end
		else
		begin
			set @error = 'Sales.sale_insert -> O funcionario não pode fazer vendas (' + cast(@employeeId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		if @saleExistsID != 0
		begin
			set @error = 'Sales.sale_insert -> Já existe uma venda com este id (' + cast(@saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @customerExistsID = 0
		begin
			set @error = 'Sales.sale_insert -> Não existe nenhum cliente com este id (' + cast(@customerId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @employeeExistsID = 0
		begin
			set @error = 'Sales.sale_insert -> Não existe nenhum funcionario com este id (' +cast( @employeeId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Sales.sale_insert 1, 3, 4, 'Nova Venda';
GO

CREATE OR ALTER PROCEDURE Sales.sale_update @saleID int, @customerId int, @employeeId int, @saleDescription VARCHAR(100)
AS
	declare
		@error varchar(300),
		@isFinished bit,
		@saleExistsID int,
		@customerExistsID int,
		@employeeExistsID int,
		@employeeType bit
		
	set @saleExistsID = Sales.udf_saleExistsById(@saleID)
	set @customerExistsID = RH.udf_customerExistsById(@customerId)
	set @employeeExistsID = RH.udf_employeeExistsById(@employeeId)

	if @saleExistsID != 0 and @customerExistsID != 0 and @employeeExistsID != 0
	begin
		set @isFinished = (select SalIsFinished from Sales.Sale where SalID = @saleID)
		
		if @isFinished = 0 
		begin
			set @employeeType = (select EmpIsSalesPerson from RH.Employee where EmpUserId = @employeeId)
		
			if @employeeType = 1
			begin
				update Sales.Sale
				set SalCustomerId = @customerId, SalEmployeeId = @employeeId, SalDescription = @saleDescription
				where SalID = @saleID
			end
			else
			begin
				set @error = 'Sales.sale_insert -> O funcionario não pode fazer vendas (' + cast(@employeeId as varchar(10)) + ')'
				RAISERROR (@error, 1, 1);
				EXEC RH.errorLog_insert @error
			end
		end
		else
		begin
			set @error = 'Sales.sale_update -> A venda com este id já está fechada (' + cast(@saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		if @saleExistsID = 0
		begin
			set @error = 'Sales.sale_update -> Não existe nenhuma venda com este id (' + cast(@saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @customerExistsID = 0
		begin
			set @error = 'Sales.sale_update -> Não existe nenhum cliente com este id (' + cast(@customerId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @employeeExistsID = 0
		begin
			set @error = 'Sales.sale_update -> Não existe nenhum funcionario com este id (' +cast( @employeeId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Sales.sale_update 1, 3, 4, 'Sale4';
GO

CREATE OR ALTER PROCEDURE Sales.sale_delete @saleID int
AS
	declare
		@error varchar(300),
		@saleExistsID int
		
	set @saleExistsID = Sales.udf_saleExistsById(@saleID)

	if @saleExistsID != 0
	begin
		delete from Sales.Sale
		where SalID = @saleID
	end
	else
	begin
		set @error = 'Sales.sale_delete -> Não existe nenhuma venda com este id (' + cast(@saleID as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Sales.sale_delete 1;
GO

/********************************************
* Product-Promotion Sale
********************************************/
CREATE OR ALTER PROCEDURE Sales.productPromotionSale_insert @productPromotionId int, @saleID int, @quantity int
AS
	declare
		@error varchar(300),
		@productId int,
		@productStock int,
		@productPromotionSaleExistsID int,
		@productPromotionExistsID int,
		@saleExistsID int

	set @productPromotionSaleExistsID = Sales.udf_productPromotionSaleExists(@productPromotionId, @saleID)
	set @productPromotionExistsID = Storage.udf_productPromotionExistsById(@productPromotionId)
	set @saleExistsID = Sales.udf_saleExistsById(@saleID)

	if @productPromotionSaleExistsID = 0 and @productPromotionExistsID != 0 and @saleExistsID != 0
	begin
		set @productStock = (select p.ProdStock from Storage.Product p join Storage.Product_Promotion pp on p.ProdId = pp.Prod_PromProductId where pp.Prod_PromProductPromotionId = @productPromotionExistsID)
		set @productId = (select Prod_PromProductId from Storage.Product_Promotion where Prod_PromProductPromotionId = @productPromotionExistsID)
		
		if @quantity <= @productStock
		begin
			update Storage.Product
			set ProdStock = (@productStock - @quantity)
			where ProdId = @productId
			
			insert into Sales.ProductPromotion_Sale values(@productPromotionId, @saleID, @quantity)
		end
		else
		begin
			set @error = 'Sales.productPromotionSale_insert -> Quantidade maior que numero de produtos em stock (' + cast(@quantity as varchar(10)) + ' > '  + cast(@productStock as varchar(10)) +  ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		if @productPromotionSaleExistsID != 0
		begin
			set @error = 'Sales.productPromotionSale_insert -> Já existe uma relação entre produto-promoção e venda estes ids (' + cast(@productPromotionId as varchar(10)) + ', ' +cast( @saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @productPromotionExistsID = 0
		begin
			set @error = 'Sales.productPromotionSale_insert -> Não existe nenhuma relação entre produto e promoção com este id (' + cast(@productPromotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @saleExistsID = 0
		begin
			set @error = 'Sales.productPromotionSale_insert -> Não existe nenhuma venda com este id (' +cast( @saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Sales.productPromotionSale_insert 1, 1, 1;
GO

CREATE OR ALTER PROCEDURE Sales.productPromotionSale_update @productPromotionId int, @saleID int, @quantity int
AS
	declare
		@error varchar(300),
		@productId int,
		@productStock int,
		@oldQuantity int,
		@productPromotionSaleExistsID int,
		@productPromotionExistsID int,
		@saleExistsID int,
		@oldProductPromotionSaleExistsID int

	set @productPromotionSaleExistsID = Sales.udf_productPromotionSaleExists(@productPromotionId, @saleID)
	set @productPromotionExistsID = Storage.udf_productPromotionExistsById(@productPromotionId)
	set @saleExistsID = Sales.udf_saleExistsById(@saleID)

	if @productPromotionSaleExistsID != 0 and @productPromotionExistsID != 0 and @saleExistsID != 0
	begin
		set @productStock = (select p.ProdStock from Storage.Product p join Storage.Product_Promotion pp on p.ProdId = pp.Prod_PromProductId where pp.Prod_PromProductPromotionId = @productPromotionExistsID)
		set @oldQuantity = (select ProdProm_SalQuantity from Sales.ProductPromotion_Sale where ProdProm_SalProductPromotionId = @productPromotionId and ProdProm_SalSaleId = @saleId)
		set @productId = (select Prod_PromProductId from Storage.Product_Promotion where Prod_PromProductPromotionId = @productPromotionExistsID)

		if @quantity <= @productStock + @oldQuantity
		begin
			update Storage.Product
			set ProdStock = ((@productStock + @oldQuantity) - @quantity)
			where ProdId = @productId

			update Sales.ProductPromotion_Sale
			set ProdProm_SalQuantity = @quantity
			where ProdProm_SalProductPromotionId = @productPromotionId and ProdProm_SalSaleId = @saleId
		end
		else
		begin
			set @error = 'Sales.productPromotionSale_update -> Quantidade maior que numero de produtos em stock (' + cast(@quantity as varchar(10)) + ' > '  + cast((@productStock + @oldQuantity) as varchar(10)) +  ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		if @productPromotionSaleExistsID = 0
		begin
			set @error = 'Sales.productPromotionSale_update -> Não existe nenhuma relação entre produto-promoção e venda estes ids (' + cast(@productPromotionId as varchar(10)) + ', ' +cast( @saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @productPromotionExistsID = 0
		begin
			set @error = 'Sales.productPromotionSale_update -> Não existe nenhuma relação entre produto e promoção com este id (' + cast(@productPromotionId as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
		
		if @saleExistsID = 0
		begin
			set @error = 'Sales.productPromotionSale_update -> Não existe nenhuma venda com este id (' +cast( @saleID as varchar(10)) + ')'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
GO
--EXEC Sales.productPromotionSale_update 1, 1, 1;
GO

CREATE OR ALTER PROCEDURE Sales.productPromotionSale_delete @productPromotionId int, @saleID int
AS
	declare
		@error varchar(300),
		@productPromotionSaleExistsID int,
		@productId int,
		@productStock int,
		@oldQuantity int
		
	set @productPromotionSaleExistsID = Sales.udf_productPromotionSaleExists(@productPromotionId, @saleID)

	if @productPromotionSaleExistsID != 0
	begin
		set @productStock = (select p.ProdStock from Storage.Product p join Storage.Product_Promotion pp on p.ProdId = pp.Prod_PromProductId where pp.Prod_PromProductPromotionId = @productPromotionId)
		set @oldQuantity = (select ProdProm_SalQuantity from Sales.ProductPromotion_Sale where ProdProm_SalProductPromotionId = @productPromotionId and ProdProm_SalSaleId = @saleId)
		set @productId = (select Prod_PromProductId from Storage.Product_Promotion where Prod_PromProductPromotionId = @productPromotionId)

		update Storage.Product
		set ProdStock = @productStock + @oldQuantity
		where ProdId = @productId

		delete from Sales.ProductPromotion_Sale
		where ProdProm_SalProductPromotionId = @productPromotionId and ProdProm_SalSaleId = @saleId
	end
	else
	begin
		set @error = 'Sales.productPromotionSale_delete -> Não existe nenhuma relação entre produto-promoção e venda estes ids (' + cast(@productPromotionId as varchar(10)) + ', ' +cast( @saleID as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Sales.productPromotionSale_delete 1, 1;
GO