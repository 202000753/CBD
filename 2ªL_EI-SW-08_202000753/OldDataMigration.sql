/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 1ª Fase - Migração das tabelas antigas para as novas
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
USE WWIGlobal
GO

--Função que retorna o id se existir um pais de um continente e 0 se não existir
CREATE OR ALTER FUNCTION HR.udf_countryExists (@country varchar(30))
RETURNS int
BEGIN
	declare @result int
	set @result =(select CouID
		from HR.Country
		where CouName = @country)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select RH.udf_countryExists('United States');
GO

--Função que retorna id se existir um estado e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_stateExistsByName (@StateProvince varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select StaProID
		from UsersInfo.StateProvince
		where StaProName = @StateProvince)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_stateExistsByName('Pennsylvania');
GO

--Função que retorna id se existir um estado e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_stateExistsByCode (@StateProvince varchar(30))
RETURNS int
BEGIN
	declare @result int
	set @result =(select StaProID
		from UsersInfo.StateProvince
		where StaProCode = @StateProvince)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_stateExistsByCode('PA');
GO

--Função que retorna id se existir uma cidade e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_cityExists (@City varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select CitID
					from UsersInfo.City
					where CitName = @City)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_cityExists('Abbottsburg');
GO

--Função que retorna id se existir uma categoria e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_categoryExists (@Category varchar(30))
RETURNS int
BEGIN
	declare @result int
	set @result =(select CatID
					from UsersInfo.Category
					where CatName = @Category)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_categoryExists('Kiosk');
GO

--Função que retorna id se existir um buying group e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_buyingGroupExists (@buyingGroup varchar(30))
RETURNS int
BEGIN
	declare @result int
	set @result =(select BuyGrouId
					from UsersInfo.BuyingGroup
					where BuyGrouName = @buyingGroup)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_buyingGroupExists('Tailspin Toys');
GO

CREATE or alter FUNCTION UsersInfo.udf_fnHashPassword (@password VARCHAR(20))
Returns varchar(20)
AS
BEGIN
	return HASHBYTES('SHA1', @password)
END;
--select UsersInfo.udf_fnHashPassword('Pass123');
GO

--Função que retorna id se existir um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_userExistsByName (@name varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select SysUseId
				from UsersInfo.SysUser
				where SysUseName = @name)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_userExistsByName('Tailspin Toys (Peeples Valley, AZ)');
GO

--Função que retorna id se existir uma região associada a uma categoria e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_Region_CategoryExists (@State varchar(30), @City varchar(30), @Category varchar(30))
RETURNS int
BEGIN
	declare @result int,
			@StateID int,
			@CityID int,
			@CategoryID int
		
	set @StateID = UsersInfo.udf_stateExistsByCode(@State)
	set @CityID = UsersInfo.udf_cityExists(@City)
	set @CategoryID = UsersInfo.udf_categoryExists(@Category)
	
	set @result =(select Reg_CatId
					from UsersInfo.Region_Category
					where Reg_CatCitStateProvinceId = @StateID and Reg_CatCityId = @CityID and Reg_CatCategoryId = @CategoryID)
					
	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_Region_CategoryExists('MT', 'Sylvanite', 'Kiosk ');
GO

--Função que retorna id se existir uma customer e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_CustomerExists (@UserID int)
RETURNS int
BEGIN
	declare @result int
	
	set @result =(select CusUserId
					from UsersInfo.Customer
					where CusUserId = @UserID)
					
	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_CustomerExists(1);
GO

--Função que retorna id se existir uma customer e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_EmployeeExists (@UserID int)
RETURNS int
BEGIN
	declare @result int
	
	set @result =(select EmpUserId
					from UsersInfo.Employee
					where EmpUserId = @UserID)
					
	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select UsersInfo.udf_EmployeeExists(1);
GO

--Função que retorna id se existir um package e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_packageExists (@name varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select PacId
				from ProductsInfo.Package
				where PacPackage = @name)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_packageExists('Each');
GO

--Função que retorna id se existir uma brand e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_brandExists (@name varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select BraId
				from ProductsInfo.Brand
				where BraName = @name)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_brandExists('Northwind');
GO

--Função que retorna id se existir um product type e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_productTypeExists (@name varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select ProTypId
				from ProductsInfo.ProductType
				where ProTypName = @name)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_productTypeExists('Dry');
GO

--Função que retorna id se existir uma taxRate e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_taxRateExists (@tax float)
RETURNS int
BEGIN
	declare @result int
	set @result =(select TaxRatId
				from ProductsInfo.TaxRate
				where TaxRatTaxRate = @tax)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_taxRateExists(14.00);
GO

--Função que retorna id se existir um product e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_productExists (@name varchar(100))
RETURNS int
BEGIN
	declare @result int
	set @result =(select ProdId
				from ProductsInfo.Product
				where ProdName = @name)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_productExists('Void fill 400 L bag (White) 400L');
GO

--Função que retorna id se existir uma promoção e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_promotionExists (@id int)
RETURNS int
BEGIN
	declare @result int
	set @result =(select PromId
				from ProductsInfo.Promotion
				where PromId = @id)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_promotionExists(1);
GO

--Função que retorna id se existir um product associado a uma pormoção e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.udf_productPromotionExists (@name varchar(100), @id int)
RETURNS int
BEGIN
	declare @result int,
		@productID int

	set @productID = ProductsInfo.udf_productExists(@name)

	set @result =(select Prod_PromProductPromotionId
				from ProductsInfo.Product_Promotion
				where Prod_PromProductId = @productID and Prod_PromPromotionId = @id)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.udf_productPromotionExists('Void fill 400 L bag (White) 400L', 1);
GO

--Função que retorna id se existir uma venda  e 0 se não existir
CREATE OR ALTER FUNCTION SalesInfo.udf_vendaExists (@saleID int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SalID
				  from SalesInfo.Sale s
				  where SalID = @saleID)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select SalesInfo.udf_vendaExists(1);
GO

--Função que retorna id se existir uma venda associado a um produto/promoção e 0 se não existir
CREATE OR ALTER FUNCTION SalesInfo.udf_productPromotion_VendaExists (@saleID int, @productPromotionID int)
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SalID
				  from SalesInfo.Sale s 
				  join SalesInfo.ProductPromotion_Sale pps
				  on s.SalID = pps.ProdProm_SalSaleId
				  where SalID = @saleID and pps.ProdProm_SalProductPromotionId = @productPromotionID)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select SalesInfo.udf_productPromotion_VendaExists(1, 1);
GO

--Procedimento que importa os dados da tabela OldData.City para as novas tabelas UsersInfo.Country, UsersInfo.StateProvince, UsersInfo.City
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_CityTable
AS
BEGIN
	DECLARE cityCursor CURSOR  
		FOR SELECT City, [State Province], Country, Continent, [Sales Territory], [Latest Recorded Population]
			FROM OldData.City;

	DECLARE 
		@City varchar(50),
		@StateProvince varchar(50),
		@Country varchar(50),
		@Continent varchar(50),
		@SalesTerritory varchar(50),
		@LatestRecordedPopulation int

	OPEN cityCursor 
	FETCH NEXT FROM cityCursor INTO 
		@City,
		@StateProvince,
		@Country,
		@Continent,
		@SalesTerritory,
		@LatestRecordedPopulation

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		--Country
		IF UsersInfo.udf_countryExists (@Country) = 0
		BEGIN
			insert into UsersInfo.udf_Country values(@Country, @Continent)
		END
		ELSE
		BEGIN
			print 'Este pais já existe - Migrate_OldData_CityTable'
		END

		--StateProvince
		IF UsersInfo.udf_stateExistsByName (@StateProvince) = 0
		BEGIN
			insert into UsersInfo.udf_StateProvince (StaProName) values(@StateProvince)
		END
		ELSE
		BEGIN
			print 'Este estado já existe - Migrate_OldData_CityTable'
		END

		--City
		IF UsersInfo.udf_cityExists (@City) = 0
		BEGIN
			insert into UsersInfo.udf_City (CitName, CitSalesTerritory, CitLasPopulationRecord) values(@City, @SalesTerritory, @LatestRecordedPopulation)
		END
		ELSE
		BEGIN
			print 'Este estado já existe - Migrate_OldData_CityTable'
		END

		FETCH NEXT FROM cityCursor INTO 
			@City,
			@StateProvince,
			@Country,
			@Continent,
			@SalesTerritory,
			@LatestRecordedPopulation
	END 
	CLOSE cityCursor 
	DEALLOCATE cityCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.States para a nova tabela UsersInfo.StateProvince
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_StatesTable
AS
BEGIN
	DECLARE stateCursor CURSOR  
		FOR SELECT Name, Code
		FROM OldData.States;

	DECLARE 
		@Name varchar(50),
		@Code varchar(50)

	OPEN stateCursor 
	FETCH NEXT FROM stateCursor INTO 
		@Name,
		@Code
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		--State
		IF UsersInfo.udf_stateExistsByName (@Name) = 0 and UsersInfo.udf_stateExistsByCode (@Code) = 0
		BEGIN
			insert into UsersInfo.StateProvince (StaProName, StaProCode) values(@Name, @Code)
		END
		--Update Code
		ELSE
		BEGIN
			declare @StateID int
			set @StateID = UsersInfo.udf_stateExistsByName (@Name)
			
			UPDATE UsersInfo.StateProvince
			SET StaProCode = @Code
			WHERE StaProID = @StateID;
			print 'Este estado já existe - Migrate_OldData_StatesTable'
		END

		FETCH NEXT FROM stateCursor INTO
			@Name,
			@Code
	END 
	CLOSE stateCursor 
	DEALLOCATE stateCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.lookup para a nova tabela UsersInfo.Category
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_lookupTable
AS
BEGIN
	DECLARE lookupCursor CURSOR  
		FOR SELECT Name
		FROM OldData.lookup;

	DECLARE 
		@Name varchar(50)

	OPEN lookupCursor 
	FETCH NEXT FROM lookupCursor INTO 
		@Name
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		--Category
		IF UsersInfo.udf_categoryExists (@Name) = 0
		BEGIN
			insert into UsersInfo.udf_Category (CatName) values(@Name)
		END
		ELSE
		BEGIN
			print 'Esta categoria já existe - Migrate_OldData_lookupTable'
		END

		FETCH NEXT FROM lookupCursor INTO
			@Name
	END 
	CLOSE lookupCursor 
	DEALLOCATE lookupCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.Customer para as novas tabelas UsersInfo.SysUser, UsersInfo.Customer, UsersInfo.Region_Category e UsersInfo.BuyingGroup
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_CustomerTable
AS
BEGIN
	declare @Pass varchar(20)
	SET @Pass = (UsersInfo.udf_fnHashPassword('Pass123'));

	insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values('admin@WWWIGlobal.com', @Pass, 'Admin')
		
	DECLARE customerCursor CURSOR  
		FOR SELECT Customer, [Bill To Customer], Category, [Buying Group], [Primary Contact], [Postal Code]
		FROM OldData.Customer;

	DECLARE 
		@Customer varchar(50),
		@BillToCustomer varchar(50),
		@Category varchar(50),
		@BuyingGroup varchar(50),
		@PrimaryContact varchar(50),
		@PostalCode int

	DECLARE
		@FirstSplit varchar(50),
		@SecondSplit varchar(50),
		@City varchar(50),
		@State varchar(50),
		@Mail varchar(50)

	declare
		@result int, 
		@StateID int,
		@CityID int,
		@UserID int,
		@BuyingGroupID int,
		@RegionCategoryID int,
		@HeadquartersID int,
		@CategoryID int,
		@FirstCity varchar(50),
		@FirstStateCode varchar(50),
		@CountryID int

	set @FirstCity = (select CitName
					  from UsersInfo.City
					  where CitId = 1)
					  
	set @FirstStateCode = (select StaProCode
					  from UsersInfo.StateProvince
					  where StaProId = 1)

	OPEN customerCursor 
	FETCH NEXT FROM customerCursor INTO 
		@Customer,
		@BillToCustomer,
		@Category,
		@BuyingGroup,
		@PrimaryContact,
		@PostalCode
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		--Category
		IF UsersInfo.udf_categoryExists (@Category) = 0
		BEGIN
			insert into UsersInfo.Category (CatName) values(@Category)
		END
		ELSE
		BEGIN
			print 'Esta categoria já existe - Migrate_OldData_CustomerTable'
		END

		--Buting Group
		IF UsersInfo.udf_buyingGroupExists (@BuyingGroup) = 0
		BEGIN
			insert into UsersInfo.BuyingGroup (BuyGrouName) values(@BuyingGroup)
		END
		ELSE
		BEGIN
			print 'Este buying group já existe - Migrate_OldData_CustomerTable'
		END

		IF UsersInfo.udf_userExistsByName (@Customer) = 0
		BEGIN
			DECLARE splitCursor CURSOR  
				FOR SELECT * from string_split(@Customer, '(');

			OPEN splitCursor 
			FETCH NEXT FROM splitCursor INTO 
				@FirstSplit

			WHILE @@FETCH_STATUS = 0 
			BEGIN
				set @State = ''
				set @City = ''

				DECLARE SecondSplitCursor CURSOR  
				FOR SELECT * from string_split(@FirstSplit, ',');

				OPEN SecondSplitCursor 
				FETCH NEXT FROM SecondSplitCursor INTO 
					@SecondSplit
				
				WHILE @@FETCH_STATUS = 0 
				BEGIN
					if(UsersInfo.udf_cityExists(REPLACE(@SecondSplit,')','')) != 0)
					begin
						set @City = REPLACE(REPLACE(@SecondSplit,')',''),' ','_')
					end
					ELSE
					BEGIN
						print 'Não existe nenhuma cidade com este nome - Migrate_OldData_CustomerTable'
					END
					
					if(UsersInfo.udf_stateExistsByCode(REPLACE(REPLACE(@SecondSplit,')',''),' ','')) != 0)
					begin
						set @State = REPLACE(REPLACE(@SecondSplit,')',''),' ','')
					end
					ELSE
					BEGIN
						print 'Não existe nenhum estado com este nome - Migrate_OldData_CustomerTable'
					END

					FETCH NEXT FROM SecondSplitCursor INTO
						@SecondSplit
				END 
				CLOSE SecondSplitCursor 
				DEALLOCATE SecondSplitCursor

				--User
				if(@State != '' and @City != '')
				begin
					set @Mail = REPLACE(@Category,' ','_') + '' + @City + '' + @State + '@' + REPLACE(@BuyingGroup,' ','_')+ '.com'
				end
				else
				begin
					print 'HeadOffice user - Migrate_OldData_CustomerTable'
					set @Mail = 'HeadOffice@' + REPLACE(@BuyingGroup,' ','_')+ '.com'
				end

				FETCH NEXT FROM splitCursor INTO
				@FirstSplit
			END 
			CLOSE splitCursor 
			DEALLOCATE splitCursor
			
			insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values(@Mail, @Pass, @Customer)
		END
		ELSE
		BEGIN
			print 'Este utilizador já existe - Migrate_OldData_CustomerTable'
		END

		DECLARE splitCursor CURSOR  
			FOR SELECT * from string_split(@Customer, '(');

		OPEN splitCursor 
		FETCH NEXT FROM splitCursor INTO 
			@FirstSplit

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			set @State = ''
			set @City = ''

			DECLARE SecondSplitCursor CURSOR  
			FOR SELECT * from string_split(@FirstSplit, ',');

			OPEN SecondSplitCursor 
			FETCH NEXT FROM SecondSplitCursor INTO 
				@SecondSplit
				
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				if(UsersInfo.udf_cityExists(REPLACE(@SecondSplit,')','')) != 0)
				begin
					set @City = REPLACE(REPLACE(@SecondSplit,')',''),' ','_')
				end
				ELSE
				BEGIN
					print 'Não existe nenhuma cidade com este nome - Migrate_OldData_CustomerTable'
				END
					
				if(UsersInfo.udf_stateExistsByCode(REPLACE(REPLACE(@SecondSplit,')',''),' ','')) != 0)
				begin
					set @State = REPLACE(REPLACE(@SecondSplit,')',''),' ','')
				end
				ELSE
				BEGIN
					print 'Não existe nenhum estado com este nome - Migrate_OldData_CustomerTable'
				END

				FETCH NEXT FROM SecondSplitCursor INTO
					@SecondSplit
			END 
			CLOSE SecondSplitCursor 
			DEALLOCATE SecondSplitCursor

			FETCH NEXT FROM splitCursor INTO
			@FirstSplit
		END 
		CLOSE splitCursor 
		DEALLOCATE splitCursor
		
		set @CategoryID = UsersInfo.udf_categoryExists(@Category)

		--Region Category
		IF @Customer not like '%Head Office%'
		BEGIN
			IF UsersInfo.udf_Region_CategoryExists (@State, REPLACE(@City,'_',' '), @Category) = 0
			BEGIN
				set @StateID = UsersInfo.udf_stateExistsByCode(@State)
				set @CityID = UsersInfo.udf_cityExists(REPLACE(@City,'_',' '))
				set @CountryID = UsersInfo.udf_countryExists('United States')
			
				insert into UsersInfo.Region_Category (Reg_CatCitStateProvinceId, Reg_CatCityId, Reg_CatCategoryId, Reg_CatCountryId, Reg_CatPostalCode) values(@StateID, @CityID, @CategoryID, @CountryID, @PostalCode)
			END
		END
		ELSE IF UsersInfo.udf_Region_CategoryExists (@FirstStateCode, @FirstCity, @Category) = 0
		BEGIN
			print 'Esta relação entre customer e region category já existe - Migrate_OldData_CustomerTable'
			set @CategoryID = UsersInfo.udf_categoryExists(@Category)

			insert into UsersInfo.Region_Category (Reg_CatCitStateProvinceId, Reg_CatCityId, Reg_CatCategoryId, Reg_CatCountryId, Reg_CatPostalCode) values(1, 1, @CategoryID, 1, @PostalCode)
		END
		
		--Customer
		set @UserID = UsersInfo.udf_userExistsByName(@Customer)
		IF UsersInfo.udf_CustomerExists (@UserID) = 0
		BEGIN
			IF @Customer not like '%Head Office%'
			BEGIN		
				set @BuyingGroupID = UsersInfo.udf_buyingGroupExists(@BuyingGroup)
				set @RegionCategoryID = UsersInfo.udf_Region_CategoryExists(@State, REPLACE(@City,'_',' '), @Category)
				set @HeadquartersID = UsersInfo.udf_userExistsByName(@BillToCustomer)
				
				insert into UsersInfo.Customer (CusUserId, CusHeadquartersId, CusRegion_CategoryId, CusBuyingGroupId, CusPrimaryContact) values(@UserID, @HeadquartersID, @RegionCategoryID, @BuyingGroupID, @PrimaryContact)
			END
			ELSE
			BEGIN
				print 'HeadOffice user - Migrate_OldData_CustomerTable'
				set @BuyingGroupID = UsersInfo.udf_buyingGroupExists(@BuyingGroup)

				insert into UsersInfo.Customer (CusUserId, CusHeadquartersId, CusRegion_CategoryId, CusBuyingGroupId, CusPrimaryContact) values(@UserID, @UserID, 1, @BuyingGroupID, @PrimaryContact)
			END
		END
		ELSE
		BEGIN
			print 'Este customer já existe - Migrate_OldData_CustomerTable'
		END

		FETCH NEXT FROM customerCursor INTO
			@Customer,
			@BillToCustomer,
			@Category,
			@BuyingGroup,
			@PrimaryContact,
			@PostalCode
	END 
	CLOSE customerCursor 
	DEALLOCATE customerCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.Employee para as novas tabelas UsersInfo.SysUser e UsersInfo.Employee
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_EmployeeTable
AS
BEGIN
	DECLARE employeeCursor CURSOR  
		FOR SELECT Employee, [Preferred Name], [Is Salesperson]
		FROM OldData.Employee;

	DECLARE 
		@Employee varchar(50),
		@PreferredName varchar(50),
		@IsSalesperson bit

	declare
		@UserID int,
		@Pass varchar(50),
		@Mail varchar(50)

	SET @Pass = (UsersInfo.udf_fnHashPassword('Pass123'));

	OPEN employeeCursor 
	FETCH NEXT FROM employeeCursor INTO 
		@Employee,
		@PreferredName,
		@IsSalesperson
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		set @Mail = REPLACE(@Employee,' ','_')+ '@employees.com'

		--User
		IF UsersInfo.udf_userExistsByName (@Employee) = 0
		BEGIN
			insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values(@Mail, @Pass, @Employee)
		END
		ELSE
		BEGIN
			print 'Este utilizador já existe - Migrate_OldData_EmployeeTable'
		END

		set @UserID = UsersInfo.udf_userExistsByName(@Employee)

		--Employee
		IF UsersInfo.udf_EmployeeExists (@UserID) = 0
		BEGIN
			insert into UsersInfo.Employee (EmpUserId, EmpPreferedName, EmpIsSalesPerson) values(@UserID, @PreferredName, @IsSalesperson)
		END
		ELSE
		BEGIN
			print 'Este employee já existe - Migrate_OldData_EmployeeTable'
		END

		FETCH NEXT FROM employeeCursor INTO
		@Employee,
		@PreferredName,
		@IsSalesperson
	END 
	CLOSE employeeCursor 
	DEALLOCATE employeeCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.Item Stock para as novas tabelas ProductsInfo.Package, ProductsInfo.Brand, ProductsInfo.TaxRate, ProductsInfo.ProductType, ProductsInfo.Product e ProductsInfo.Product_Promotion
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_ItemStockTable
AS
BEGIN
	DECLARE productCursor CURSOR  
		FOR SELECT [Stock Item], Color, [Selling Package], [Buying Package], Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock], Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit]
		FROM OldData.[Stock Item];

	DECLARE
		@StockItem  varchar(100),
		@Color varchar(50),
		@SellingPackage varchar(50),
		@BuyingPackage varchar(50),
		@Brand varchar(50),
		@Size varchar(50),
		@LeadTimeDays int,
		@QuantityPerOuter int,
		@IsChillerStock bit,
		@Barcode varchar(50),
		@TaxRate float,
		@UnitPrice float,
		@RecommendedRetailPrice float,
		@TypicalWeightPerUnit float

	declare
		@BrandID int,
		@TaxRateID int,
		@ProductTypeID int,
		@BuyingPackageID int,
		@SellingPackageID int

	OPEN productCursor 
	FETCH NEXT FROM productCursor INTO 
		@StockItem,
		@Color,
		@SellingPackage,
		@BuyingPackage,
		@Brand,
		@Size,
		@LeadTimeDays,
		@QuantityPerOuter,
		@IsChillerStock,
		@Barcode,
		@TaxRate,
		@UnitPrice,
		@RecommendedRetailPrice,
		@TypicalWeightPerUnit
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		--Selling Package
		IF ProductsInfo.udf_packageExists (@SellingPackage) = 0
		BEGIN
			insert into ProductsInfo.Package(PacPackage) values(@SellingPackage)
		END
		ELSE
		BEGIN
			print 'Este package já existe - Migrate_OldData_ItemStockTable'
		END

		set @SellingPackageID = ProductsInfo.udf_packageExists(@SellingPackage)

		--Buying Package
		IF ProductsInfo.udf_packageExists (@BuyingPackage) = 0
		BEGIN
			insert into ProductsInfo.Package(PacPackage) values(@BuyingPackage)
		END
		ELSE
		BEGIN
			print 'Este package já existe - Migrate_OldData_ItemStockTable'
		END

		set @BuyingPackageID = ProductsInfo.udf_packageExists(@BuyingPackage)

		--Brand
		IF ProductsInfo.udf_brandExists (@Brand) = 0
		BEGIN
			insert into ProductsInfo.Brand(BraName) values(@Brand)
		END
		ELSE
		BEGIN
			print 'Esta brand já existe - Migrate_OldData_ItemStockTable'
		END

		set @BrandID = ProductsInfo.udf_brandExists(@Brand)

		--Product Type
		IF ProductsInfo.udf_productTypeExists('Dry') = 0
		BEGIN
			insert into ProductsInfo.ProductType(ProTypName) values('Dry')
		END
		IF ProductsInfo.udf_productTypeExists('Chiller') = 0
		BEGIN
			insert into ProductsInfo.ProductType(ProTypName) values('Chiller')
		END
		
		IF @IsChillerStock = 0
		begin
			set @ProductTypeID = ProductsInfo.udf_productTypeExists('Dry')
		end
		else
		begin
			set @ProductTypeID = ProductsInfo.udf_productTypeExists('Chiller')
		end

		--Tax Rate
		IF ProductsInfo.udf_taxRateExists (@TaxRate) = 0
		BEGIN
			insert into ProductsInfo.TaxRate(TaxRatTaxRate) values(@TaxRate)
		END
		ELSE
		BEGIN
			print 'Esta tax rate já existe - Migrate_OldData_ItemStockTable'
		END

		set @TaxRateID = ProductsInfo.udf_taxRateExists(@TaxRate)
		
		--Product
		IF ProductsInfo.udf_productExists(@StockItem) = 0
		BEGIN
			insert into ProductsInfo.Product(ProdBrandId,
			ProdTaxRateId,
			ProdProductTypeId,
			ProdBuyingPackageId,
			ProdSellingPackageId,
			ProdName,
			ProdColor,
			ProdSize,
			ProdLeadTimeDays,
			ProdQuantityPerOuter,
			ProdStock,
			ProdBarCode,
			ProdUnitPrice,
			ProdRecommendedRetailPrice,
			ProdTypicalWeightPerUnit)

			values(@BrandID,
			@TaxRateID,
			@ProductTypeID,
			@BuyingPackageID,
			@SellingPackageID,
			@StockItem,
			@Color,
			@Size,
			@LeadTimeDays,
			@QuantityPerOuter,
			30,
			@Barcode,
			@UnitPrice,
			@RecommendedRetailPrice,
			@TypicalWeightPerUnit
			)
		END
		ELSE
		BEGIN
			print 'Este produto já existe - Migrate_OldData_ItemStockTable'
		END

		--Promotion
		IF ProductsInfo.udf_promotionExists (1) = 0
		BEGIN
			SET IDENTITY_INSERT ProductsInfo.Promotion ON
			insert into ProductsInfo.Promotion(PromId, PromDescription, PromStartDate, PromEndDate) values(1, 'No Promotion', GETDATE(), CAST('2032-08-25' AS date))
			SET IDENTITY_INSERT ProductsInfo.Promotion OFF
		END

		--Product Promotion
		IF ProductsInfo.udf_productPromotionExists (@StockItem, 1) = 0
		BEGIN
			declare @productID int

			set @productID = ProductsInfo.productExists(@StockItem)

			SET IDENTITY_INSERT ProductsInfo.Promotion ON
			insert into ProductsInfo.Product_Promotion(Prod_PromProductId, Prod_PromPromotionId, ProdNewPrice) values(@productID, 1, 0)
			SET IDENTITY_INSERT ProductsInfo.Promotion OFF
		END
		ELSE
		BEGIN
			print 'Este relação entre a promoção e o produto já existe - Migrate_OldData_ItemStockTable'
		END

		FETCH NEXT FROM productCursor INTO
		@StockItem,
		@Color,
		@SellingPackage,
		@BuyingPackage,
		@Brand,
		@Size,
		@LeadTimeDays,
		@QuantityPerOuter,
		@IsChillerStock,
		@Barcode,
		@TaxRate,
		@UnitPrice,
		@RecommendedRetailPrice,
		@TypicalWeightPerUnit
	END 
	CLOSE productCursor 
	DEALLOCATE productCursor
END;
GO

--Procedimento que importa os dados da tabela OldData.Sale para as novas tabelas SalesInfo.Sale e SalesInfo.ProductPromotion_Sale
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_SaleTable
AS
BEGIN
	DECLARE saleCursor CURSOR  
		FOR SELECT [WWI Invoice ID], [Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key], [Salesperson Key], Description, Quantity, Profit, [Tax Amount], [Total Excluding Tax], [Total Including Tax]
		FROM OldData.Sale;

	DECLARE
		@WWIInvoiceID int,
		@CustomerKey int,
		@StockItemKey int,
		@InvoiceDateKey date,
		@DeliveryDateKey date,
		@SalespersonKey int,
		@Description varchar(100),
		@Quantity int,
		@Profit decimal(18, 2),
		@TaxAmount decimal(18, 2),
		@TotalExcludingTax decimal(18, 2),
		@TotalIncludingTax decimal(18, 2)

	
	DECLARE
		@customer varchar(100),
		@employee varchar(100),
		@newDescription varchar(100),
		@customerID int,
		@employeeID int,
		@productPromotionID int,
		@saleID int

	OPEN saleCursor 
	FETCH NEXT FROM saleCursor INTO 
		@WWIInvoiceID,
		@CustomerKey,
		@StockItemKey,
		@InvoiceDateKey,
		@DeliveryDateKey,
		@SalespersonKey,
		@Description,
		@Quantity,
		@Profit,
		@TaxAmount,
		@TotalExcludingTax,
		@TotalIncludingTax
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		declare @product varchar(100)
		set @product = (select ProdName from ProductsInfo.Product where ProdId = @StockItemKey)

		set @productPromotionID = ProductsInfo.productPromotionExists(@product, 1)
		
		set @customer = (select Customer from OldData.Customer where [Customer Key] = @CustomerKey)
		set @employee  = (select Employee from OldData.Employee where [Employee Key] = @SalespersonKey)
		
		set @customerID = UsersInfo.userExistsByName(@customer)
		set @employeeID = UsersInfo.userExistsByName(@employee)
		
		set @newDescription = 'Sale' + cast(@WWIInvoiceID as varchar(10))

		--Sale
		IF SalesInfo.vendaExists (@WWIInvoiceID) = 0
		BEGIN
			SET IDENTITY_INSERT SalesInfo.Sale ON
			insert into SalesInfo.Sale (SalID,
			SalCustomerId,
			SalEmployeeId,
			SalDate,
			SalDeliveryDate,
			SalDescription,
			SalProfit,
			SalTotalPrice,
			SalTotalExcludingTax,
			SalTaxAmount,
			SalIsFinished)
	
			values(@WWIInvoiceID,
			@customerID,
			@employeeID,
			@InvoiceDateKey,
			@DeliveryDateKey,
			@newDescription,
			@Profit,
			@TaxAmount,
			@TotalExcludingTax,
			@TotalIncludingTax,
			0)
			SET IDENTITY_INSERT SalesInfo.Sale OFF
		END
		ELSE
		BEGIN
			print 'Esta venda já existe - Migrate_OldData_SaleTable'
		END
		
		set @saleID = SalesInfo.vendaExists (@WWIInvoiceID)
		
		--ProductPromotion_Venda
		IF SalesInfo.productPromotion_VendaExists (@saleID, @productPromotionID) = 0
		BEGIN
			insert into SalesInfo.productPromotion_Sale (ProdProm_SalProductPromotionId, ProdProm_SalSaleId, ProdProm_SalQuantity) values(@productPromotionID, @saleID, @Quantity)
		END
		ELSE
		BEGIN
			print 'Este relação entre a relação do produto com a promoção e a venda já existe - Migrate_OldData_SaleTable'
		END

		update SalesInfo.Sale
		set SalIsFinished = 1
		where SalID = @WWIInvoiceID

		FETCH NEXT FROM saleCursor INTO
		@WWIInvoiceID,
		@CustomerKey,
		@StockItemKey,
		@InvoiceDateKey,
		@DeliveryDateKey,
		@SalespersonKey,
		@Description,
		@Quantity,
		@Profit,
		@TaxAmount,
		@TotalExcludingTax,
		@TotalIncludingTax
	END 
	CLOSE saleCursor 
	DEALLOCATE saleCursor
END;
GO

--Procedimento que importa os dados das tabelas OldData.Tabela para as novas tabelas SalesInfo.Tabela
CREATE OR ALTER PROCEDURE sp_MigrateAll
AS
BEGIN
	print 'Importar' 
	Exec sp_Migrate_OldData_CityTable
	Exec sp_Migrate_OldData_StatesTable
	Exec sp_Migrate_OldData_lookupTable
	Exec sp_Migrate_OldData_CustomerTable
	Exec sp_Migrate_OldData_EmployeeTable
	Exec sp_Migrate_OldData_ItemStockTable
	Exec sp_Migrate_OldData_SaleTable

	/*DROP SCHEMA OldData;
	DROP TABLE OldData.City
	DROP TABLE OldData.Customer
	DROP TABLE OldData.Employee
	DROP TABLE OldData.lookup
	DROP TABLE OldData.Sale
	DROP TABLE OldData.States
	DROP TABLE OldData.[Stock Item]*/
END;
GO
Exec MigrateAll;