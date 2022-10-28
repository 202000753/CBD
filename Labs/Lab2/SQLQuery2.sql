CREATE OR ALTER PROCEDURE spListaCompra 
@SalesOrderId int 

AS 
BEGIN 
	DECLARE cur CURSOR  
		FOR SELECT p.Name, s.OrderQty, s.UnitPrice, s.UnitPriceDiscount, s.LineTotal 
			FROM SalesLT.SalesOrderDetail s 
			join SalesLT.Product p ON p.ProductID = s.ProductID 
			WHERE s.SalesOrderID = @SalesOrderId 
			ORDER BY p.Name  

	DECLARE 
		@EmailAddress varchar(50), 
		@SalesOrderNumber varchar(25), 
		@OrderDate datetime,
		@TotalDue money,
		@OrderQty smallint,
		@UnitPrice money,
		@UnitPriceDiscount money,
		@LineTotal money,
		@Name varchar(50) 

	
	SELECT @EmailAddress = sc.EmailAddress, @SalesOrderNumber = sh.SalesOrderNumber, @OrderDate = sh.OrderDate, @TotalDue = sh.TotalDue
	FROM SalesLT.SalesOrderHeader sh 
	join SalesLT.Customer sc ON sc.CustomerID = sh.CustomerID 
	WHERE SalesOrderID = @SalesOrderId; 
		

	OPEN cur 
	FETCH NEXT FROM cur INTO 
		@Name, @OrderQty, @UnitPrice, @UnitPriceDiscount, @LineTotal 

	PRINT '----------------------------------------------------------' 
	PRINT 'Customer: ' + @EmailAddress 
	PRINT 'Order: ' + @SalesOrderNumber 
	PRINT 'Date: ' + CAST(@OrderDate as varchar) -- CAST: to convert an expression of one data type to another.
	PRINT 'Total: ' + CAST(@TotalDue as varchar) 
	PRINT '----------------------------------------------------------' 

	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		PRINT 'Product: ' + @Name +  
		      ' | OrderQty: ' + CAST(@OrderQty as varchar) + 
			  ' | UnitPrice: ' + CAST(@UnitPrice as varchar) + 
			  ' | UnitPriceDiscount: ' + CAST(@UnitPriceDiscount as varchar) + 
			  ' | LineTotal: ' + CAST(@LineTotal as varchar)    

		FETCH NEXT FROM cur INTO 
			@Name, @OrderQty, @UnitPrice, @UnitPriceDiscount, @LineTotal 
	END 
	CLOSE cur 
	DEALLOCATE cur -- The data structures comprising the cursor are released by the SGBD engine (i.e., removes the cursor reference)
END 

EXEC spListaCompra 71780;

SELECT p.Name, s.OrderQty, s.UnitPrice, s.UnitPriceDiscount, s.LineTotal 
FROM SalesLT.SalesOrderDetail s 
join SalesLT.Product p ON p.ProductID = s.ProductID 
WHERE s.SalesOrderID = 71780
ORDER BY p.Name;