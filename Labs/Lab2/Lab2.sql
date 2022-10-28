 /********************************************
 *	UC: Complementos de Bases de Dados 2020/2021 
 *
 *	Laboratório 2 – T-SQL: Funções, Stored Procedures,Triggers e Metadados
 *		Nuno Reis (202000753)
 *		Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *	
 ********************************************/
use AdventureWorksLT2019

--============================================================================= 
-- Etapa I. Resumo Matéria T-SQL
--============================================================================= 
/*a. Criar a função fnTotalVendasProduto que calcule o valor total monetário das vendas para um 
determinado produto (recebendoID).*/
CREATE OR ALTER FUNCTION salesLT.fnTotalVendasProduto (@product_id int)
RETURNS float  
AS 
BEGIN 
	DECLARE @total float; 

	SELECT @total= SUM(OrderQty*UnitPrice) 
	FROM SalesLT.SalesOrderDetail p 
	WHERE ProductID = @product_id;  

	RETURN @total;
END; 

select salesLT.fnTotalVendasProduto(707) as 'Total de Vendas'

/*b. Utilizando a função anterior, faça uma query que apresente o nome dos produtos e o respetivo 
total monetário de vendas;*/
select Name as Nome, salesLT.fnTotalVendasProduto(ProductID)as 'Total de Vendas'
from SalesLT.Product
order by Name

/*c. Criar o procedimento spClientesCidade que recebe uma cidade (ex: Las Vegas) e lista os clientes 
residentes na respetiva cidade.*/
CREATE OR ALTER PROCEDURE salesLT.spClientesCidade @cidade nvarchar(20)
AS
SELECT *
	FROM SalesLT.Customer as c
	LEFT JOIN SalesLT.CustomerAddress ca
	ON c.CustomerID = ca.CustomerID
	LEFT JOIN SalesLT.Address as a
	ON ca.AddressID = a.AddressID
	WHERE a.City like @cidade

EXEC salesLT.spClientesCidade 'Bothell'

--d.
--Crie um schema Logs e nesse schema uma tabela CustomerLog.
/*
DROP SCHEMA schema_Logs;
drop table schema_Logs.CustomerLog
*/
CREATE SCHEMA schema_Logs
GO
CREATE TABLE schema_Logs.CustomerLog (CustomerLogId int NOT NULL PRIMARY KEY, CustomerID int NOT NULL, tipo nvarchar(50) NOT NULL, timestamp date NOT NULL);

/*Quando se altera ou se apaga um registo da tabela Customer, deve ser executada uma 
cópia do registo que sofreu as alterações para a tabela de CustomerLog, explicitando o 
tipo de operação e o timestamp*/
--Crie o trigger que implemente a lógica descrita
CREATE OR ALTER TRIGGER salesLT.tr_Customer_UpdateOrDelete
ON SalesLT.Customer
FOR UPDATE, DELETE
AS
BEGIN
	DECLARE @id int = 0;
	DECLARE @action nvarchar(50) = ' ';
	DECLARE @cID int = 0;

    SET @action = (CASE WHEN EXISTS(SELECT * FROM INSERTED)
                        THEN 'U'  -- Set Action to Updated.
                        WHEN EXISTS(SELECT * FROM DELETED)
                        THEN 'D'  -- Set Action to Deleted.
                    END)

					print N' ' + @action;
	-- For Getting the ID
	if  @action = 'D'
	BEGIN
		SET @cID = (select CustomerID from deleted);
		set @action = 'Deleted'
	END
	if  @action = 'U'
	BEGIN
		SET @cID =(select CustomerID from inserted);
		set @action = 'updated'
	END

	SET @id = (select count(*) from schema_Logs.CustomerLog) + 1;

	if (@cID != 0)
	BEGIN
		INSERT INTO schema_Logs.CustomerLog
		VALUES (@id, @cID, @action, CURRENT_TIMESTAMP);
	END 
END;

UPDATE SalesLT.Customer set FirstName='Betty' where customerID=38;

select *
from schema_Logs.CustomerLog;


--============================================================================= 
-- Etapa II. Resumo Matéria de Metadados
--============================================================================= 
-- a. Crie um conjunto de queries para uma determinada tabela (e.g. Customer), que:
--i. Visualize a(s) coluna(s) que constituem a chave primária
SELECT Col.TABLE_NAME as 'Tabela', Col.Column_Name as 'Coluna'
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name AND Constraint_Type = 'PRIMARY KEY' AND Col.Table_Name = 'Customer';

/*ii. Visualize para as chaves estrangeiras, o nome da coluna e a tabela/coluna que 
é referenciada*/
--**** A tabela Customer não tem Foreign Keys. Fiz da tabela Product ****
--**** Não consegui ver qual a tabela/coluna referenciada ****
SELECT Col.TABLE_NAME as 'Tabela', Col.Column_Name as 'Coluna'
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name and Constraint_Type = 'FOREIGN KEY' and Col.Table_Name = 'Product';

/*b. Crie o stored procedure sp_disable_FK que recebe como argumento o nome de uma tabela 
(@p_table_name), e gera como saída um script (lista de comandos sql) que permite fazer 
disable a todas as chaves estrangeiras que fazem referência à tabela.
[Poderá ter de consultar o anexo B sobre cursores]*/

CREATE OR ALTER PROCEDURE salesLT.sp_disable_FK @p_table_name nvarchar(20)
AS
BEGIN
	DECLARE cur CURSOR  
		FOR SELECT col.COLUMN_NAME
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
			WHERE Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name and Constraint_Type = 'FOREIGN KEY' and Col.Table_Name = 'Product';

	DECLARE 
		@ColumnName varchar(50)

	OPEN cur 
	FETCH NEXT FROM cur INTO 
		@ColumnName

	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		--Criar um print com o script que faz disable ás chaves estrangeiras
		PRINT 'Column Name: ' + @ColumnName

		FETCH NEXT FROM cur INTO 
			@ColumnName
	END 
	CLOSE cur 
	DEALLOCATE cur
END

EXEC salesLT.sp_disable_FK 'Product';


SELECT *
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE Col.Constraint_Name = Tab.Constraint_Name AND Col.Table_Name = Tab.Table_Name and Constraint_Type = 'FOREIGN KEY' and Col.Table_Name = 'Product';
