/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Criar as functions
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
/********************************************
* Stored Procedures
********************************************/
--Recuperar Password
CREATE OR ALTER PROCEDURE RH.sp_recuperarPassword @userEmail VARCHAR(50), @token int, @newUserPassword VARCHAR(20)
AS
	declare
		@tokenID int,
		@error varchar(100),
		@userID int

	set @userID = RH.udf_sysUserExists(@userEmail)

	if @userID != 0
	begin
		set @tokenID = RH.udf_tokenExistsByUser(@token, @userID)

		if @tokenID != 0
		begin
			update RH.SysUser
			set SysUsePassword = RH.udf_fnHashPassword(@newUserPassword)
			where SysUseId = @userID
		end
		else
		begin
			set @error = 'Token Invalido'
			RAISERROR (@error, 1, 1);
			EXEC RH.errorLog_insert @error
		end
	end
	else
	begin
		set @error = 'Não existe nenhum utilizador com este email' + @userEmail
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC RH.sp_recuperarPassword N'nunoreis294@gmail.com', 357487, 'Pass333';
GO

--Finalizar uma venda
CREATE OR ALTER PROCEDURE Sales.sp_finishSale @id int
AS
	declare
		@saleID int,
		@error varchar(100)

	set @saleID = Sales.udf_saleExistsById(@id)

	if @saleID != 0
	begin		
		update Sales.Sale
		set SalIsFinished = 1
		where SalID = @saleID
	end
	else
	begin
		set @error = 'Não existe nenhuma venda com este id (' + cast(@id as varchar(10)) + ')'
		RAISERROR (@error, 1, 1);
		EXEC RH.errorLog_insert @error
	end
GO
--EXEC Sales.sp_finishSale '1';
GO

 /********************************************
 * Functions
 ********************************************//*
--Função que retorna id se existir um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_userExistsByEmail (@email varchar(50))
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
--select UsersInfo.udf_userExistsByEmail('nunoreis294@gmail.com');
GO


--Função que retorna um numero se existirem erros associados um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_userHasErrors (@id int)
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
--select UsersInfo.udf_userHasErrors(420);
GO

--Função que retorna o id se existir um token valido associado um user e 0 se não existir
CREATE OR ALTER FUNCTION UsersInfo.udf_tokenExists (@userID int, @token int)
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
--select UsersInfo.udf_tokenExists(421, 446969);
GO*/

--Função que retorna id se existir um product associado a uma pormoção e 0 se não existir
CREATE OR ALTER FUNCTION Storage.udf_productPromotionExistsByName (@name varchar(100), @promotion varchar(100))
RETURNS int
BEGIN
	declare @result int,
		@promotionID int,
		@productID int

	set @productID = Storage.udf_productExists(@name)
	set @promotionID = Storage.udf_promotionExists((select PromId from Storage.Promotion where PromDescription = @promotion))

	set @result =(select Prod_PromProductPromotionId
				from Storage.Product_Promotion
				where Prod_PromProductId = @productID and Prod_PromPromotionId = @promotionID)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productPromotionExistsByName('Void fill 400 L bag (White) 400L', 'No Promotion');
GO

--Função que retorna id se existir uma venda e 0 se não existir
CREATE OR ALTER FUNCTION Sales.udf_saleExistsByDescription (@description varchar(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select s.SalID
				  from Sales.Sale s
				  where SalDescription = @description)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select SalesInfo.udf_saleExistsByDescription('Nova Venda1');
GO

--Função que retorna o stock de um produto e 0 se não existir esse produto
CREATE OR ALTER FUNCTION Storage.udf_productStock (@product varchar(100))
RETURNS int
BEGIN
	declare @result int

	set @result =(select ProdStock
				  from Storage.Product
				  where ProdName = @product)

	if @result is null
	begin
		return 0
	end
	
	return @result
END;
--select Storage.udf_productStock('Void fill 400 L bag (White) 400L');
GO

--Função que retorna o tipo de venda e 0 se não existir essa venda
CREATE OR ALTER FUNCTION Sales.udf_saleType (@sale varchar(100))
RETURNS varchar(20)
BEGIN
	declare @result varchar(20)

	set @result =(select top 1 pt.ProTypName
				  from Sales.Sale s
				  join Sales.ProductPromotion_Sale pps
				  on s.SalID = pps.ProdProm_SalSaleId
				  join Storage.Product_Promotion pp
				  on pps.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
				  join Storage.Product p
				  on pp.Prod_PromProductId = p.ProdId
				  join Storage.ProductType pt
				  on p.ProdProductTypeId = pt.ProTypId
				  where s.SalDescription = @sale)

	if @result is null
	begin
		return 'notype'
	end
	
	return @result
END;
--select Sales.udf_saleType('Nova Venda1');
GO