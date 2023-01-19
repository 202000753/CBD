/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Criar os triggers
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
 --Trigger que altera avalidade de um token repetido
 CREATE or alter TRIGGER RH.tr_validade_token
 ON RH.Token
 AFTER INSERT
 AS
	declare
		@ID int,
		@userID int,
		@tokenID int,
		@token int,
		@tID int

	set @ID = (select TokUserId from inserted)
	set @tID = (select TokId from inserted)
		
	DECLARE tokenCursor CURSOR  
		FOR SELECT TokUserId, TokToken
		FROM RH.Token;
	
	OPEN tokenCursor 
	FETCH NEXT FROM tokenCursor INTO 
		@userID,
		@token
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		if RH.udf_tokenExists(@token) != 0
		begin
			set @tokenID = RH.udf_tokenExists(@token)
			
			if @userID = @ID and @tokenID != @tID
			begin
				Exec RH.token_update @tokenID
				
				/*update RH.Token
				set TokEndDateTime = GETDATE()
				where TokId = @tokenID*/
			end
		end

		FETCH NEXT FROM tokenCursor INTO
		@userID,
		@token
	END 
	CLOSE tokenCursor 
	DEALLOCATE tokenCursor
 GO
 
 --Trigger que elimina uma venda se forem removidos todos os produtos
 CREATE or alter TRIGGER Sales.tr_eliminateSale
 ON Sales.ProductPromotion_Sale
 AFTER DELETE
 AS
	declare
		@sID int,
		@ppID int,
		@n int

	set @sID = (select ProdProm_SalSaleId from deleted)

	set @n = (select COUNT(*)
			  from Sales.ProductPromotion_Sale
			  where ProdProm_SalSaleId = @sID)
		
	if @n = 0
	begin
		EXEC Sales.sale_delete @sID;

		--DELETE FROM Sales.Sale WHERE SalID = @sID
	end
 GO
 
--Trigger que calcula a data prevista de entrega e os valores associados a uma venda finalizada
CREATE or alter TRIGGER Sales.tr_calculateSaleInfo
ON Sales.Sale
FOR UPDATE
AS
	declare 
		@salID int,
		@salDate Datetime,
		@salProfit float,
		@salTotalPrice float,
		@salTotalExculdingTax float,
		@salTaxAmount float

	set @salProfit = 0
	set @salTotalPrice = 0
	set @salTotalExculdingTax = 0
	set @salTaxAmount = 0
	
	declare 
		@maxLeadTimeDays int,
		@prodLeadTimeDays int,
		@prodQuantity int,
		@unitPrice int,
		@prodRecommendePrice float,
		@prodTaxRate float

	set @maxLeadTimeDays = 0

	set @salID = (select SalID from inserted)

	DECLARE productsCursor CURSOR  
		for select p.ProdLeadTimeDays, p.ProdUnitPrice, pps.ProdProm_SalQuantity, p.ProdRecommendedRetailPrice, tr.TaxRatTaxRate
			from Sales.ProductPromotion_Sale pps
			join Sales.Sale s
			on pps.ProdProm_SalSaleId = s.SalID
			join Storage.Product_Promotion pp
			on pps.ProdProm_SalProductPromotionId = pp.Prod_PromProductPromotionId
			join Storage.Product p
			on pp.Prod_PromProductId = p.ProdId
			join Storage.TaxRate tr
			on p.ProdTaxRateId = tr.TaxRatId
			where s.SalID = @salID

	OPEN productsCursor 
	FETCH NEXT FROM productsCursor INTO 
		@prodLeadTimeDays,
		@unitPrice,
		@prodQuantity,
		@prodRecommendePrice,
		@prodTaxRate

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		if @prodLeadTimeDays > @maxLeadTimeDays
		begin
			set @maxLeadTimeDays = @prodLeadTimeDays
		end

		set @salTotalExculdingTax += @unitPrice * @prodQuantity
		set @salProfit += @prodRecommendePrice * @prodQuantity
		set @salTotalPrice += @unitPrice * (@prodTaxRate / 10) * @prodQuantity
	
		FETCH NEXT FROM productsCursor INTO
		@prodLeadTimeDays,
		@unitPrice,
		@prodQuantity,
		@prodRecommendePrice,
		@prodTaxRate
	END 
	CLOSE productsCursor 
	DEALLOCATE productsCursor

	--update
	set @salDate = DATEADD(day, @maxLeadTimeDays, GETDATE())
	set @salTaxAmount = @salTotalPrice - @salTotalExculdingTax

	update Sales.Sale
	set SalDeliveryDate = @salDate, SalTotalExcludingTax = @salTotalExculdingTax, SalProfit = @salProfit, SalTotalPrice = @salTotalPrice, SalTaxAmount = @salTaxAmount
	where SalID = @salID
go