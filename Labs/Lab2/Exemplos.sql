EXEC sp_helpserver; -- Reports information about a particular remote or replication server

EXEC sp_Databases -- returns the metadata list of databases from SQL Server

EXEC sp_helpdb AdventureWorksLT2019 -- returns information (Metadata) for the specified Database

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, COLUMN_DEFAULT​
FROM AdventureWorksLT2019.INFORMATION_SCHEMA.COLUMNS​
WHERE TABLE_NAME = 'Product';

SELECT *
FROM AdventureWorksLT2019.INFORMATION_SCHEMA.COLUMNS​
WHERE TABLE_NAME = 'Product';


CREATE or alter TRIGGER salesLT.tr_Customer_Update
ON SalesLT.Customer 
FOR UPDATE, DELETE
AS
Begin
	declare @id int = 0;
	set @id = (select count(*) from SalesLT.Customer) + 1;

	print N'ID ' + CAST(@id AS VARCHAR);
	print N'ID ' + convert(varchar(25), CURRENT_TIMESTAMP, 120) ;
	select CustomerID from deleted;
End;

UPDATE SalesLT.Customer set FirstName='Betty' where customerID=38;

delete from SalesLT.Customer where CustomerID=1
select *
from SalesLT.Customer














































