/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Migração das tabelas antigas para as novas
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
USE WWIGlobal
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
		IF RH.udf_countryExists (@Country, @Continent) = 0
		BEGIN
			EXEC RH.country_insert @Country, @Continent;
			
			--insert into UsersInfo.udf_Country values(@Country, @Continent)
		END

		--StateProvince
		IF RH.udf_stateProvinceExists (@StateProvince) = 0
		BEGIN
			EXEC RH.stateProvince_insert @StateProvince, '';
			
			--insert into UsersInfo.udf_StateProvince (StaProName) values(@StateProvince)
		END

		--City
		IF RH.udf_cityExists (@City) = 0
		BEGIN
			EXEC RH.city_insert @City, @SalesTerritory, @LatestRecordedPopulation;

			--insert into UsersInfo.udf_City (CitName, CitSalesTerritory, CitLasPopulationRecord) values(@City, @SalesTerritory, @LatestRecordedPopulation)
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
--Exec sp_Migrate_OldData_CityTable

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
		IF RH.udf_stateProvinceExists (@Name) = 0
		BEGIN
			EXEC RH.stateProvince_insert @Name, @Code;

			--insert into UsersInfo.StateProvince (StaProName, StaProCode) values(@Name, @Code)
		END
		--Update Code
		ELSE
		BEGIN
			declare @StateID int
			set @StateID = RH.udf_stateProvinceExists (@Name)
			
			EXEC RH.stateProvince_update @StateID, @Name, @Code;
			
			--UPDATE UsersInfo.StateProvince
			--SET StaProCode = @Code
			--WHERE StaProID = @StateID;
		END

		FETCH NEXT FROM stateCursor INTO
			@Name,
			@Code
	END 
	CLOSE stateCursor 
	DEALLOCATE stateCursor
END;
GO
--Exec sp_Migrate_OldData_StatesTable

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
		IF RH.udf_categoryExists (@Name) = 0
		BEGIN
			EXEC RH.category_insert @Name;
			
			--insert into UsersInfo.udf_Category (CatName) values(@Name)
		END

		FETCH NEXT FROM lookupCursor INTO
			@Name
	END 
	CLOSE lookupCursor 
	DEALLOCATE lookupCursor
END;
GO
--Exec sp_Migrate_OldData_lookupTable

--Procedimento que importa os dados da tabela OldData.Customer para as novas tabelas UsersInfo.SysUser, UsersInfo.Customer, UsersInfo.Region_Category e UsersInfo.BuyingGroup
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_CustomerTable
AS
BEGIN
	declare @Pass varchar(20)
	SET @Pass = (RH.udf_fnHashPassword('Pass123'));
		
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
		@FirstCity int,
		@CountryID int

	set @FirstCity = 1

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
		IF RH.udf_categoryExists (@Category) = 0
		BEGIN
			EXEC RH.category_insert @Category;

			--insert into UsersInfo.Category (CatName) values(@Category)
		END

		--Buting Group
		IF RH.udf_buiyngGroupExists (@BuyingGroup) = 0
		BEGIN
		EXEC RH.buiyngGroup_insert @BuyingGroup;

			--insert into UsersInfo.BuyingGroup (BuyGrouName) values(@BuyingGroup)
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
				if(RH.udf_cityExists(REPLACE(@SecondSplit,')','')) != 0)
				begin
					set @City = REPLACE(REPLACE(@SecondSplit,')',''),' ','_')
				end
					
				if(RH.udf_stateProvinceExistsByCode(REPLACE(REPLACE(@SecondSplit,')',''),' ','')) != 0)
				begin
					set @State = REPLACE(REPLACE(@SecondSplit,')',''),' ','')
				end

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
				set @Mail = 'HeadOffice@' + REPLACE(@BuyingGroup,' ','_')+ '.com'
			end

			FETCH NEXT FROM splitCursor INTO
			@FirstSplit
		END 
		CLOSE splitCursor 
		DEALLOCATE splitCursor

		IF RH.udf_sysUserExists (@Mail) = 0
		BEGIN
			EXEC RH.sysUser_insert @Customer, @Mail, @Pass;
			
			--insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values(@Mail, @Pass, @Customer)
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
				if(RH.udf_cityExists(REPLACE(@SecondSplit,')','')) != 0)
				begin
					set @City = REPLACE(REPLACE(@SecondSplit,')',''),' ','_')
				end
					
				if(RH.udf_stateProvinceExistsByCode(REPLACE(REPLACE(@SecondSplit,')',''),' ','')) != 0)
				begin
					set @State = REPLACE(REPLACE(@SecondSplit,')',''),' ','')
				end

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
		
		set @CountryID = RH.udf_countryExists('United States', 'North America')

		if @State like ''
		begin
			set @StateID = 1
		end
		else
		begin
			set @StateID = RH.udf_stateProvinceExistsByCode(@State)
		end
		
		set @CityID = RH.udf_cityExists(REPLACE(@City,'_',' '))
		set @CategoryID = RH.udf_categoryExists(@Category)

		--Region Category
		IF @Customer not like '%Head Office%'
		BEGIN
			IF RH.udf_regionCategoryExists(@CountryID, @StateID, @CityID, @CategoryID) = 0
			BEGIN
				EXEC RH.regionCategory_insert @CountryID, @StateID, @CityID, @CategoryID, @PostalCode;
				
				--insert into UsersInfo.Region_Category (Reg_CatCitStateProvinceId, Reg_CatCityId, Reg_CatCategoryId, Reg_CatCountryId, Reg_CatPostalCode) values(@StateID, @CityID, @CategoryID, @CountryID, @PostalCode)
			END
		END
		ELSE IF RH.udf_regionCategoryExists (@CountryID, @StateID, @FirstCity, @CategoryID) = 0
		BEGIN
			EXEC RH.regionCategory_insert @CountryID, @StateID, @FirstCity, @CategoryID, @PostalCode;

			--insert into UsersInfo.Region_Category (Reg_CatCitStateProvinceId, Reg_CatCityId, Reg_CatCategoryId, Reg_CatCountryId, Reg_CatPostalCode) values(1, 1, @CategoryID, 1, @PostalCode)
		END
		
		--Customer
		set @UserID = RH.udf_sysUserExists (@Mail)
		
		IF RH.udf_sysUserExistsById (@UserID) != 0
		BEGIN
			IF @Customer not like '%Head Office%'
			BEGIN		
				set @BuyingGroupID = RH.udf_buiyngGroupExists(@BuyingGroup)
				set @RegionCategoryID = RH.udf_regionCategoryExists(@CountryID, @StateID, @CityID, @CategoryID)
				set @HeadquartersID = RH.udf_customerExistsById(RH.udf_sysUserExistsByName(@BillToCustomer))

				EXEC RH.customer_insert @UserID, @HeadquartersID, @RegionCategoryID, @BuyingGroupID, @PrimaryContact, 0;
				
				--insert into UsersInfo.Customer (CusUserId, CusHeadquartersId, CusRegion_CategoryId, CusBuyingGroupId, CusPrimaryContact) values(@UserID, @HeadquartersID, @RegionCategoryID, @BuyingGroupID, @PrimaryContact)
			END
			ELSE
			BEGIN
				set @BuyingGroupID = RH.udf_buiyngGroupExists(@BuyingGroup)
				set @RegionCategoryID = RH.udf_regionCategoryExists(1, 1, 1, @CategoryID)

				EXEC RH.customer_insert @UserID, @UserID, @RegionCategoryID, @BuyingGroupID, @PrimaryContact, 1;

				--insert into UsersInfo.Customer (CusUserId, CusHeadquartersId, CusRegion_CategoryId, CusBuyingGroupId, CusPrimaryContact) values(@UserID, @UserID, 1, @BuyingGroupID, @PrimaryContact)
			END
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
--Exec sp_Migrate_OldData_CustomerTable

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

	SET @Pass = (RH.udf_fnHashPassword('Pass123'));

	OPEN employeeCursor 
	FETCH NEXT FROM employeeCursor INTO 
		@Employee,
		@PreferredName,
		@IsSalesperson
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		set @Mail = REPLACE(@Employee,' ','_')+ '@employees.com'

		--User
		IF RH.udf_sysUserExists(@Mail) = 0
		BEGIN
			EXEC RH.sysUser_insert @Employee, @Mail, @Pass;

			--insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values(@Mail, @Pass, @Employee)
		END

		set @UserID = RH.udf_sysUserExists(@Mail)

		--Employee
		IF RH.udf_EmployeeExists (@UserID) = 0
		BEGIN
			EXEC RH.employee_insert @UserID, @PreferredName, @IsSalesperson;

			--insert into UsersInfo.Employee (EmpUserId, EmpPreferedName, EmpIsSalesPerson) values(@UserID, @PreferredName, @IsSalesperson)
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
--Exec sp_Migrate_OldData_EmployeeTable

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
		IF Storage.udf_packageExists (@SellingPackage) = 0
		BEGIN
			EXEC Storage.package_insert @SellingPackage;
			
			--insert into Storage.Package(PacPackage) values(@SellingPackage)
		END

		set @SellingPackageID = Storage.udf_packageExists(@SellingPackage)

		--Buying Package
		IF Storage.udf_packageExists (@BuyingPackage) = 0
		BEGIN
			EXEC Storage.package_insert @BuyingPackage;

			--insert into Storage.Package(PacPackage) values(@BuyingPackage)
		END

		set @BuyingPackageID = Storage.udf_packageExists(@BuyingPackage)

		--Brand
		IF Storage.udf_brandExists (@Brand) = 0
		BEGIN
			EXEC Storage.brand_insert @Brand;

			--insert into Storage.Brand(BraName) values(@Brand)
		END

		set @BrandID = Storage.udf_brandExists(@Brand)

		--Product Type
		IF Storage.udf_productTypeExists('Dry') = 0
		BEGIN
			EXEC Storage.productType_insert 'Dry';

			--insert into Storage.ProductType(ProTypName) values('Dry')
		END
		IF Storage.udf_productTypeExists('Chiller') = 0
		BEGIN
			EXEC Storage.productType_insert 'Chiller';

			--insert into Storage.ProductType(ProTypName) values('Chiller')
		END
		
		IF @IsChillerStock = 0
		begin
			set @ProductTypeID = Storage.udf_productTypeExists('Dry')
		end
		else
		begin
			set @ProductTypeID = Storage.udf_productTypeExists('Chiller')
		end

		--Tax Rate
		IF Storage.udf_taxRateExists (@TaxRate) = 0
		BEGIN
			EXEC Storage.taxRate_insert @TaxRate;

			--insert into Storage.TaxRate(TaxRatTaxRate) values(@TaxRate)
		END

		set @TaxRateID = Storage.udf_taxRateExists(@TaxRate)
		
		--Product
		IF Storage.udf_productExists(@StockItem) = 0
		BEGIN
			EXEC Storage.product_insert @BrandID, @TaxRateID, @ProductTypeID, @BuyingPackageID, @SellingPackageID, @StockItem, @Color, @Size, @LeadTimeDays, @QuantityPerOuter, 300000, @Barcode, @UnitPrice, @RecommendedRetailPrice, @TypicalWeightPerUnit;

			/*insert into Storage.Product(ProdBrandId,
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
			)*/
		END

		--Promotion
		IF Storage.udf_promotionExists (1) = 0
		BEGIN
			EXEC Storage.promotion_insert 'No Promotion', '2022-08-25', '2032-08-25';

			--SET IDENTITY_INSERT ProductsInfo.Promotion ON
			--insert into Storage.Promotion(PromId, PromDescription, PromStartDate, PromEndDate) values(1, 'No Promotion', GETDATE(), CAST('2032-08-25' AS date))
			--SET IDENTITY_INSERT ProductsInfo.Promotion OFF
		END

		--Product Promotion
		declare @productID int

		set @productID = Storage.udf_productExists(@StockItem)

		IF Storage.udf_productPromotionExists (@productID, 1) = 0
		BEGIN
			EXEC Storage.productPromotion_insert @productID, 1;

			--SET IDENTITY_INSERT ProductsInfo.Promotion ON
			--insert into Storage.Product_Promotion(Prod_PromProductId, Prod_PromPromotionId, ProdNewPrice) values(@productID, 1, 0)
			--SET IDENTITY_INSERT ProductsInfo.Promotion OFF
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
--Exec sp_Migrate_OldData_ItemStockTable

--Procedimento que importa os dados da tabela OldData.Sale para as novas tabelas SalesInfo.Sale e SalesInfo.ProductPromotion_Sale
CREATE OR ALTER PROCEDURE sp_Migrate_OldData_SaleTable
AS
BEGIN
	DECLARE saleCursor CURSOR  
		FOR SELECT [WWI Invoice ID], [Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key], [Salesperson Key], Quantity, Profit, [Tax Amount], [Total Excluding Tax], [Total Including Tax]
		FROM OldData.Sale;

	DECLARE
		@WWIInvoiceID int,
		@CustomerKey int,
		@StockItemKey int,
		@InvoiceDateKey date,
		@DeliveryDateKey date,
		@SalespersonKey int,
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
		@productID int,
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
		@Quantity,
		@Profit,
		@TaxAmount,
		@TotalExcludingTax,
		@TotalIncludingTax
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		declare @product varchar(100)
		set @product = (select ProdName from Storage.Product where ProdId = @StockItemKey)

		set @productID = Storage.udf_productExists(@product)

		set @productPromotionID = Storage.udf_productPromotionExists(@productID, 1)
		
		set @customer = (select Customer from OldData.Customer where [Customer Key] = @CustomerKey)
		set @employee  = (select Employee from OldData.Employee where [Employee Key] = @SalespersonKey)
		
		set @customerID = RH.udf_sysUserExistsByName(@customer)
		set @employeeID = RH.udf_sysUserExistsByName(@employee)
		
		set @newDescription = 'Sale' + cast(@WWIInvoiceID as varchar(10))

		--Sale
		IF Sales.udf_saleExistsById (@WWIInvoiceID) = 0
		BEGIN
			EXEC Sales.sale_insert @WWIInvoiceID, @customerID, @employeeID, @newDescription;

			update Sales.Sale
			set SalDate = @InvoiceDateKey
			where SalID = @WWIInvoiceID

			/*SET IDENTITY_INSERT Sales.Sale ON
			insert into Sales.Sale (SalID,
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
			SET IDENTITY_INSERT SalesInfo.Sale OFF*/
		END
		
		set @saleID = Sales.udf_saleExistsById(@WWIInvoiceID)
		
		--ProductPromotion_Venda
		IF Sales.udf_productPromotionSaleExists(@saleID, @productPromotionID) = 0
		BEGIN
			EXEC Sales.productPromotionSale_insert @productPromotionID, @saleID, @Quantity;
			
			--insert into Sales.productPromotion_Sale (ProdProm_SalProductPromotionId, ProdProm_SalSaleId, ProdProm_SalQuantity) values(@productPromotionID, @saleID, @Quantity)
		END

		FETCH NEXT FROM saleCursor INTO
		@WWIInvoiceID,
		@CustomerKey,
		@StockItemKey,
		@InvoiceDateKey,
		@DeliveryDateKey,
		@SalespersonKey,
		@Quantity,
		@Profit,
		@TaxAmount,
		@TotalExcludingTax,
		@TotalIncludingTax
	END 
	CLOSE saleCursor 
	DEALLOCATE saleCursor

	--Fechar todas as vendas
	DECLARE salesCursor CURSOR  
		FOR SELECT SalID
			FROM Sales.Sale;

	OPEN salesCursor 
	FETCH NEXT FROM salesCursor INTO 
		@saleID

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		Sales.sp_finishSale @saleID
		/*update Sales.Sale
		set SalIsFinished = 1
		where SalID = @saleID*/

		FETCH NEXT FROM salesCursor INTO 
			@saleID
	END 
	CLOSE salesCursor 
	DEALLOCATE salesCursor
END;
GO
--Exec sp_Migrate_OldData_SaleTable

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
END;
GO
--Exec sp_MigrateAll;