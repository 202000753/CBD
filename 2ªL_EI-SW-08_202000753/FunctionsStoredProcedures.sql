/********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1ª Fase - Criar as functions
 *		Nuno Reis (202000753)
 *			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
 /********************************************
 * Stored Procedures
 ********************************************/
--Editar Utilizadores
CREATE OR ALTER PROCEDURE UsersInfo.editSysUser @userEmail VARCHAR(50), @newUserName VARCHAR(50), @newUserEmail VARCHAR(50), @newUserPassword VARCHAR(20)
AS
	declare
		@error varchar(100),
		@userID int,
		@user2ID int

	set @userID = UsersInfo.userExistsByEmail(@userEmail)
	set @user2ID = UsersInfo.userExistsByEmail(@newUserEmail)

	if @userID != 0 and @user2ID = 0
	begin
		update UsersInfo.SysUser
		set SysUseEmail = @newUserEmail, SysUseName = @newUserName, SysUsePassword = UsersInfo.fnHashPassword(@newUserPassword)
		where SysUseId = @userID
	end
	else
	begin
		print 'Já existe um utilizador com este email ' + @newUserEmail + ', ou não existe nenhum utilizador com este mail ' + @userEmail
		set @error = 'Já existe um utilizador com este email ' + @newUserEmail + ', ou não existe nenhum utilizador com este mail ' + @userEmail
		insert into UsersInfo.ErrorLog values(@userID, @error, GETDATE())
	end
GO
--EXEC UsersInfo.editSysUser N'Eva_Muirden@employees.com', N'Nuno Reis', N'nunoreis294@gmail.com', N'Pass321';
GO

--Adicionar Utilizadores
CREATE OR ALTER PROCEDURE UsersInfo.createSysUser @userName VARCHAR(50), @userEmail VARCHAR(50), @userPassword VARCHAR(20)
AS
	declare
		@userID int,
		@error varchar(100)

	set @userID = UsersInfo.userExistsByEmail(@userEmail)
	
	if @userID = 0
	begin
		insert into UsersInfo.SysUser (SysUseEmail, SysUsePassword, SysUseName) values(@userEmail, UsersInfo.fnHashPassword(@userPassword), @userName)
	end
	else
	begin
		print 'Já existe um utilizador com este email' + @userEmail
		set @error = 'Já existe um utilizador com este email' + @userEmail
		insert into UsersInfo.ErrorLog values(@userID, @error, GETDATE())
	end
GO
--EXEC UsersInfo.createSysUser N'João Sousa', N'joao@gmail.com', N'Pass321';
GO

--Remover Utilizadores
CREATE OR ALTER PROCEDURE UsersInfo.deleteSysUser @userEmail VARCHAR(50)
AS
	declare
		@error varchar(100),
		@customerID int,
		@employeeID int,
		@userID int

	set @userID = UsersInfo.userExistsByEmail(@userEmail)
	set @customerID = UsersInfo.CustomerExists(@userID)
	set @employeeID = UsersInfo.EmployeeExists(@userID)

	if @userID != 0 and @customerID = 0 and @employeeID = 0
	begin
		delete from UsersInfo.SysUser
		where SysUseId = @userID
	end
	else
	begin
		print 'Não existe nenhum utilizador com este mail ' + @userEmail + ', ou o utilizador é cliente ou funcionario'
		set @error = 'Não existe nenhum utilizador com este mail ' + @userEmail + ', ou o utilizador é cliente ou funcionario'
		insert into UsersInfo.ErrorLog values(@userID, @error, GETDATE())
	end
GO
--EXEC UsersInfo.deleteSysUser N'joao@gmail.com';
GO

--Recuperar Password
--Criar Token
CREATE OR ALTER PROCEDURE UsersInfo.createToken @userEmail VARCHAR(50)
AS
	declare
		@token int,
		@error varchar(100),
		@userID int

	set @userID = UsersInfo.userExistsByEmail(@userEmail)

	if @userID != 0
	begin
		set @token = CAST(RAND() * 1000000 AS INT)
		print 'Token ' + cast(@token as varchar(20))
		insert into UsersInfo.Token values(@userID, @userEmail, GETDATE(), DATEADD(day, +1, GETDATE()), @token)
	end
	else
	begin
		print 'Não existe nenhum utilizador com este email' + @userEmail
		set @error = 'Não existe nenhum utilizador com este email' + @userEmail
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC UsersInfo.createToken N'nunoreis294@gmail.com';
GO

CREATE OR ALTER PROCEDURE UsersInfo.recuperarPassword @userEmail VARCHAR(50), @token int, @newUserPassword VARCHAR(20)
AS
	declare
		@tokenID int,
		@error varchar(100),
		@userID int

	set @userID = UsersInfo.userExistsByEmail(@userEmail)

	if @userID != 0
	begin
		set @tokenID = UsersInfo.tokenExists(@userID, @token)

		if @tokenID != 0
		begin
			update UsersInfo.SysUser
			set SysUsePassword = UsersInfo.fnHashPassword(@newUserPassword)
			where SysUseId = @userID
		end
		else
		begin
			print 'Token Invalido'
			set @error = 'Token Invalido'
			insert into UsersInfo.ErrorLog values(@userID, @error, GETDATE())
		end
	end
	else
	begin
		print 'Não existe nenhum utilizador com este email' + @userEmail
		set @error = 'Não existe nenhum utilizador com este email' + @userEmail
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC UsersInfo.recuperarPassword N'nunoreis294@gmail.com', 357487, 'Pass333';
GO

--Alterar a data de inicio de uma promoção
CREATE OR ALTER PROCEDURE ProductsInfo.cangePromotionDatesStart @product VARCHAR(100), @promotion VARCHAR(100), @startDate date
AS
	declare
		@productPromotionID int,
		@productID int,
		@error varchar(100),
		@promotionID int

	set @productID = ProductsInfo.productExists (@product)
	set @promotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productPromotionID = ProductsInfo.productPromotionExists(@product, @promotionID)

	if @productID != 0 and @promotionID != 0 and @productPromotionID != 0
	begin
		update ProductsInfo.Promotion
		set PromStartDate = @startDate
		where PromId = @promotionID
	end
	else
	begin
		print 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		set @error = 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC UsersInfo.cangePromotionDatesStart 'Void fill 400 L bag (White) 400L', 'No Promotion', '2022-08-26';
GO

--Alterar a data de fim de uma promoção
CREATE OR ALTER PROCEDURE ProductsInfo.cangePromotionDatesEnd @product VARCHAR(100), @promotion VARCHAR(100), @endDate date
AS
	declare
		@productPromotionID int,
		@productID int,
		@error varchar(100),
		@promotionID int

	set @productID = ProductsInfo.productExists (@product)
	set @promotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productPromotionID = ProductsInfo.productPromotionExists(@product, @promotionID)

	if @productID != 0 and @promotionID != 0 and @productPromotionID != 0
	begin
		update ProductsInfo.Promotion
		set PromEndDate = @endDate
		where PromId = @promotionID
	end
	else
	begin
		print 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		set @error = 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC UsersInfo.cangePromotionDatesEnd 'Void fill 400 L bag (White) 400L', 'No Promotion', '2032-08-27';
GO

--Alterar as datas de inicio e fim de uma promoção
CREATE OR ALTER PROCEDURE ProductsInfo.cangePromotionDates @product VARCHAR(100), @promotion VARCHAR(100), @startDate date, @endDate date
AS
	declare
		@productPromotionID int,
		@productID int,
		@error varchar(100),
		@promotionID int

	set @productID = ProductsInfo.productExists (@product)
	set @promotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productPromotionID = ProductsInfo.productPromotionExists(@product, @promotionID)

	if @productID != 0 and @promotionID != 0 and @productPromotionID != 0
	begin
		update ProductsInfo.Promotion
		set PromStartDate = @startDate, PromEndDate = @endDate
		where PromId = @promotionID
	end
	else
	begin
		print 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		set @error = 'Não existe nenhum produto com este nome' + @product + 'ou não existe nenhuma promução com esta descrição' + @promotion
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC UsersInfo.cangePromotionDates 'Void fill 400 L bag (White) 400L', 'No Promotion', '2022-08-25', '2032-08-25';
GO

--Criar uma venda
CREATE OR ALTER PROCEDURE SalesInfo.createSale @customer VARCHAR(100), @employee VARCHAR(100), @description VARCHAR(100)
AS
	declare
		@saleID int,
		@customerID int,
		@employeeID int,
		@error varchar(100)

	set @saleID = SalesInfo.saleExistsByDescription(@description)
	set @customerID = UsersInfo.CustomerExists(UsersInfo.userExists(@customer))
	set @employeeID = UsersInfo.EmployeeExists(UsersInfo.userExists(@employee))

	if @customerID != 0 and @EmployeeID != 0 and @saleID = 0
	begin
		insert into SalesInfo.Sale(SalCustomerId, SalEmployeeId, SalDate, SalDescription, SalIsFinished) values(@customerID, @employeeID, GETDATE(), @description, 0)
	end
	else
	begin
		print 'Já existe uma venda com essa descrição' + @description + 'ou não existe nenhum customer com esse nome' + @customer + 'ou não existe nenhum funcionario com esse nome' + @employee
		set @error = 'Já existe uma venda com essa descrição' + @description + 'ou não existe nenhum customer com esse nome' + @customer + 'ou não existe nenhum funcionario com esse nome' + @employee
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC SalesInfo.createSale 'Tailspin Toys (Sylvanite, MT)', 'Eva Muirden', 'Nova Venda2';
GO

--Adicionar um produto a uma venda
CREATE OR ALTER PROCEDURE SalesInfo.addProductToSale @product VARCHAR(100), @promotion VARCHAR(100), @description VARCHAR(100), @quantity int
AS
	declare
		@saleID int,
		@productID int,
		@promotionID int,
		@productPromotionID int,
		@productStock int,
		@productType varchar(100),
		@saleType varchar(100),
		@saleIsFinished bit,
		@error varchar(100)

	set @saleID = SalesInfo.saleExistsByDescription(@description)
	set @productID = ProductsInfo.productExists(@product)
	set @promotionID = ProductsInfo.promotionExists((select PromId from ProductsInfo.Promotion where PromDescription = @promotion))
	set @productPromotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productStock = ProductsInfo.productStock(@product)
	set @saleType = SalesInfo.saleType(@description)

	set @productType = (select pt.ProTypName
						from ProductsInfo.Product p
						join ProductsInfo.ProductType pt
						on p.ProdProductTypeId = pt.ProTypId
						where p.ProdName = @product)

	set @saleIsFinished = (select SalIsFinished from SalesInfo.Sale where SalID = @saleID)

	if @saleID != 0 and @productPromotionID != 0 and @productStock - @quantity >=0 and @promotionID != 0 and (@saleType = @productType or @saleType = 'notype') and @saleIsFinished = 0
	begin
		insert into SalesInfo.ProductPromotion_Sale values(@productPromotionID, @saleID, @quantity)
		
		update ProductsInfo.Product
		set ProdStock = @productStock - @quantity
		where ProdId = @productID
	end
	else
	begin
		print 'Não existe nenhuma venda com essa descrição' + @description
		set @error = 'Não existe nenhuma venda com essa descrição' + @description
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC SalesInfo.addProductToSale 'Large  replacement blades 18mm', 'No Promotion', 'Nova Venda2', 5;
--EXEC SalesInfo.addProductToSale 'USB food flash drive - chocolate bar', 'No Promotion', 'Nova Venda2', 5;
GO

--Alterar a quantidade de um produto numa venda
CREATE OR ALTER PROCEDURE SalesInfo.changeProductQuantitySale @product VARCHAR(100), @promotion VARCHAR(100), @description VARCHAR(100), @quantity int
AS
	declare
		@saleID int,
		@productID int,
		@promotionID int,
		@productPromotionID int,
		@productStock int,
		@productQuantity int,
		@productType varchar(100),
		@saleType varchar(100),
		@saleIsFinished bit,
		@error varchar(100)

	set @saleID = SalesInfo.saleExistsByDescription(@description)
	set @productID = ProductsInfo.productExists(@product)
	set @promotionID = ProductsInfo.promotionExists((select PromId from ProductsInfo.Promotion where PromDescription = @promotion))
	set @productPromotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productStock = ProductsInfo.productStock(@product)
	set @saleType = SalesInfo.saleType(@description)
	
	set @productType = (select pt.ProTypName
						from ProductsInfo.Product p
						join ProductsInfo.ProductType pt
						on p.ProdProductTypeId = pt.ProTypId
						where p.ProdName = @product)

	set @productQuantity = (select ProdProm_SalQuantity
						    from ProductPromotion_Sale
						    where ProdProm_SalSaleId = @saleID and ProdProm_SalProductPromotionId = @productPromotionID)

	set @saleIsFinished = (select SalIsFinished from SalesInfo.Sale where SalID = @saleID)

	if @saleID != 0 and @productPromotionID != 0 and @productStock + @productQuantity - @quantity >= 0 and @promotionID != 0 and (@saleType = @productType or @saleType = 'notype') and @saleIsFinished = 0
	begin
		update SalesInfo.ProductPromotion_Sale
		set ProdProm_SalQuantity = @quantity
		where ProdProm_SalSaleId = @saleID and ProdProm_SalProductPromotionId = @productPromotionID
		
		update ProductsInfo.Product
		set ProdStock = @productStock + @productQuantity - @quantity
		where ProdId = @productID
	end
	else
	begin
		print 'Não existe nenhuma venda com essa descrição' + @description
		set @error = 'Não existe nenhuma venda com essa descrição' + @description
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC SalesInfo.changeProductQuantitySale 'Large  replacement blades 18mm', 'No Promotion', 'Nova Venda2', 3;
GO

--Remover um produto de uma venda
CREATE OR ALTER PROCEDURE SalesInfo.removeProductSale @product VARCHAR(100), @promotion VARCHAR(100), @description VARCHAR(100)
AS
	declare
		@saleID int,
		@productID int,
		@promotionID int,
		@productPromotionID int,
		@productStock int,
		@productQuantity int,
		@productType varchar(100),
		@saleType varchar(100),
		@saleIsFinished bit,
		@error varchar(100)

	set @saleID = SalesInfo.saleExistsByDescription(@description)
	set @productID = ProductsInfo.productExists(@product)
	set @promotionID = ProductsInfo.promotionExists((select PromId from ProductsInfo.Promotion where PromDescription = @promotion))
	set @productPromotionID = ProductsInfo.productPromotionExistsByName(@product, @promotion)
	set @productStock = ProductsInfo.productStock(@product)
	set @saleType = SalesInfo.saleType(@description)
	
	set @productType = (select pt.ProTypName
						from ProductsInfo.Product p
						join ProductsInfo.ProductType pt
						on p.ProdProductTypeId = pt.ProTypId
						where p.ProdName = @product)

	set @productQuantity = (select ProdProm_SalQuantity
						    from ProductPromotion_Sale
						    where ProdProm_SalSaleId = @saleID and ProdProm_SalProductPromotionId = @productPromotionID)

	set @saleIsFinished = (select SalIsFinished from SalesInfo.Sale where SalID = @saleID)

	if @saleID != 0 and @productPromotionID != 0 and @promotionID != 0 and (@saleType = @productType or @saleType = 'notype') and @saleIsFinished = 0
	begin
		DELETE FROM SalesInfo.ProductPromotion_Sale WHERE ProdProm_SalSaleId = @saleID and ProdProm_SalProductPromotionId = @productPromotionID;
		
		update ProductsInfo.Product
		set ProdStock = @productStock + @productQuantity
		where ProdId = @productID
	end
	else
	begin
		print 'Não existe nenhuma venda com essa descrição' + @description
		set @error = 'Não existe nenhuma venda com essa descrição' + @description
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC SalesInfo.addProductToSale 'Large  replacement blades 18mm', 'No Promotion', 'Nova Venda2', 5;
--EXEC SalesInfo.removeProductSale 'Large  replacement blades 18mm', 'No Promotion', 'Nova Venda2';
--EXEC SalesInfo.addProductToSale 'USB food flash drive - chocolate bar', 'No Promotion', 'Nova Venda2', 5;
--EXEC SalesInfo.removeProductSale 'USB food flash drive - chocolate bar', 'No Promotion', 'Nova Venda2';
GO

--Finalizar uma venda
CREATE OR ALTER PROCEDURE SalesInfo.finishSale @description VARCHAR(100)
AS
	declare
		@saleID int,
		@error varchar(100)

	set @saleID = SalesInfo.saleExistsByDescription(@description)

	if @saleID != 0
	begin		
		update SalesInfo.Sale
		set SalIsFinished = 1
		where SalID = @saleID
	end
	else
	begin
		print 'Não existe nenhuma venda com essa descrição' + @description
		set @error = 'Não existe nenhuma venda com essa descrição' + @description
		insert into UsersInfo.ErrorLog values(1, @error, GETDATE())
	end
GO
--EXEC SalesInfo.finishSale 'Nova Venda1';
GO

 /********************************************
 * Functions
 ********************************************/
--Função que retorna id se existir um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.userExistsByEmail (@email varchar(50))
RETURNS int
BEGIN
	declare @result int
	set @result =(select SysUseId
				from UsersInfo.SysUser
				where SysUseEmail = @email)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
GO
--select UsersInfo.userExistsByEmail('nunoreis294@gmail.com');
GO


--Função que retorna um numero se existirem erros associados um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.userHasErrors (@id int)
RETURNS int
BEGIN
	declare @result int
	set @result =(select COUNT(*)
				from UsersInfo.ErrorLog
				where ErrLogUserId = @id)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
GO
--select UsersInfo.userHasErrors(420);
GO

--Função que retorna o id se existir um token valido associado um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.tokenExists (@userID int, @token int)
RETURNS int
BEGIN
	declare @result int
	set @result =(select TokId
				from UsersInfo.Token
				where TokToken = @token and TokUserId = @userID and DATEDIFF(second, GETDATE(), TokDateTime) < 0 and DATEDIFF(second, GETDATE(), TokEndDateTime) > 0)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
GO
--select UsersInfo.tokenExists(421, 446969);
GO

--Função que retorna id se existir um product associado a uma pormoção e 0 se não existir
CREATE OR ALTER FUNCTION ProductsInfo.productPromotionExistsByName (@name varchar(100), @promotion varchar(100))
RETURNS int
BEGIN
	declare @result int,
		@promotionID int,
		@productID int

	set @productID = ProductsInfo.productExists(@name)
	set @promotionID = ProductsInfo.promotionExists((select PromId from ProductsInfo.Promotion where PromDescription = @promotion))

	set @result =(select Prod_PromProductPromotionId
				from ProductsInfo.Product_Promotion
				where Prod_PromProductId = @productID and Prod_PromPromotionId = @promotionID)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.productPromotionExistsByName('Void fill 400 L bag (White) 400L', 'No Promotion');
GO

--Função que retorna id se existir uma venda e 0 se não existir
CREATE OR ALTER FUNCTION SalesInfo.saleExistsByDescription (@description varchar(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SalID
				  from SalesInfo.Sale s
				  where SalDescription = @description)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select SalesInfo.saleExistsByDescription('Nova Venda1');
GO

--Função que retorna o stock de um produto e 0 se não existir esse produto
CREATE OR ALTER FUNCTION ProductsInfo.productStock (@product varchar(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProdStock
				  from ProductsInfo.Product
				  where ProdName = @product)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select ProductsInfo.productStock('Void fill 400 L bag (White) 400L');
GO

--Função que retorna o tipo de venda e 0 se não existir essa venda
CREATE OR ALTER FUNCTION SalesInfo.saleType (@sale varchar(100))
RETURNS varchar(20)
BEGIN
	declare @result varchar(20)

	set @result =(select top 1 pt.ProTypName
				  from SalesInfo.Sale s
				  join SalesInfo.ProductPromotion_Sale pps
				  on s.SalID = pps.ProdProm_SalSaleId
				  join ProductsInfo.Product_Promotion pp
				  on pps.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
				  join ProductsInfo.Product p
				  on pp.Prod_PromProductId = p.ProdId
				  join ProductsInfo.ProductType pt
				  on p.ProdProductTypeId = pt.ProTypId
				  where s.SalDescription = @sale)

	if @result is null
	begin
		return 'notype'
	end
	
	return @result
END;
--select SalesInfo.saleType('Nova Venda1');
GO

/*CREATE FUNCTION UserInfo.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO
SELECT * FROM Sales.ufn_SalesByStore (602);*/

/*CREATE PROCEDURE HumanResources.uspGetEmployeesTest2 @LastName nvarchar(50), @FirstName nvarchar(50)   
AS   

    SET NOCOUNT ON;  
    SELECT FirstName, LastName, Department  
    FROM HumanResources.vEmployeeDepartmentHistory  
    WHERE FirstName = @FirstName AND LastName = @LastName  
    AND EndDate IS NULL;  
GO  
EXECUTE HumanResources.uspGetEmployeesTest2 N'Ackerman', N'Pilar'; */