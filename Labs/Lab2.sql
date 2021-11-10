Lab 2 - Funções, Stored Procedures, Triggers e Metadados
Nome: Nuno Reis		Número: 202000753
Etapa 1
--a)
create or alter function dbo.fnTotalVendasProduto (@product_id int)
returns int
AS
begin
	declare @total int;

	select @total=sum(OrderQty*UnitPrice)
	from SalesLT.SalesOrderDetail
	where ProductID = @product_id;

	return @total;
end;

select dbo.fnTotalVendasProduto(976) as Total;

--b)
select Name, dbo.fnTotalVendasProduto(ProductID) as Total
from SalesLT.Product
where dbo.fnTotalVendasProduto(ProductID) is not null;

--c)
create or alter function dbo.fnTotalVendas ()
returns int
as
begin
	declare @total int =0;

	select @total += dbo.fnTotalVendasProduto(ProductID)
	from SalesLT.Product
	where dbo.fnTotalVendasProduto(ProductID) is not null

	return @total;
end;

select dbo.fnTotalVendas() as Total;

--d)
create or alter procedure dbo.spClientesCidade @city nvarchar(30)
as
	select *
	from SalesLT.Address
	where SalesLT.Address.City=@City;
go

exec dbo.spClientesCidade @City = "Las Vegas";

--e) AAAAA
create or alter procedure dbo.spListaCompra @SalesOID int
as
	declare @costumerEmail nvarchar(50);
	declare @orderID int;
	declare @date datetime;
	declare @total int;

	--Costumer
	declare CostumerEmail_Cursor cursor
	for select c.EmailAddress
		from [SalesLT].[SalesOrderHeader] as h
		left join [SalesLT].[Customer] as c
		on h.CustomerID=c.CustomerID
		where h.SalesOrderID=@SalesOID;
	open CostumerEmail_Cursor
	fetch next from CostumerEmail_Cursor into @costumerEmail;
	close CostumerEmail_Cursor;
	deallocate CostumerEmail_Cursor;
	
	--Order
	declare OrderID_Cursor cursor
	for select h.SalesOrderID
		from [SalesLT].[SalesOrderHeader] as h
		where h.SalesOrderID=@SalesOID;
	open OrderID_Cursor
	fetch next from OrderID_Cursor into @orderID;
	close OrderID_Cursor;
	deallocate OrderID_Cursor;

	--Date
	declare Date_Cursor cursor
	for select h.OrderDate
		from [SalesLT].[SalesOrderHeader] as h
		where h.SalesOrderID=@SalesOID;
	open Date_Cursor
	fetch next from Date_Cursor into @date;
	close Date_Cursor;
	deallocate Date_Cursor;

	--Total
	declare Total_Cursor cursor
	for select sum(OrderQty*UnitPrice)
		from SalesLT.SalesOrderDetail as h
		where h.SalesOrderID=@SalesOID;
	open Total_Cursor
	fetch next from Total_Cursor into @total;
	close Total_Cursor;
	deallocate Total_Cursor;

	--Print do cabeçalho
	print '--------------------------------------------'
	print 'Costumer: '  + @costumerEmail;
	print 'Order: SO'  + cast(@orderID as varchar(10));
	print 'Date: '  + CONVERT( VARCHAR(24), @date, 121);
	print 'Total: '  + cast(@total as varchar(10));

	--Print da lista de produtos
	print '--------------------------------------------'
	declare @salesCount int;
	
	set @salesCount = (select COUNT(*)
						from [SalesLT].[SalesOrderDetail] as d
						where d.SalesOrderID = @SalesOID
						group by d.SalesOrderID);

	while @salesCount > 0
	begin
		declare @productName nvarchar(50);
		declare @saleOrderQty int;
		declare @saleUnitPrice float;
		declare @saleUnitPriceDiscount float;
		declare @saleLineTotal float;

		--Product name
		declare ProductName_Cursor cursor
		for select p.Name--
			from [SalesLT].[SalesOrderDetail] as d
			left join [SalesLT].Product as p
			on d.ProductID=p.ProductID
			where d.SalesOrderID=@SalesOID;
		open ProductName_Cursor
		fetch next from ProductName_Cursor into @productName;

		--Sale Order Qty
		declare SaleOrderQty_Cursor cursor
		for select d.OrderQty
			from [SalesLT].[SalesOrderDetail] as d
			left join [SalesLT].Product as p
			on d.ProductID=p.ProductID
			where d.SalesOrderID=@SalesOID;
		open SaleOrderQty_Cursor
		fetch next from SaleOrderQty_Cursor into @saleOrderQty;

		--Sale Unit Price
		declare SaleUnitPrice_Cursor cursor
		for select d.UnitPrice
			from [SalesLT].[SalesOrderDetail] as d
			left join [SalesLT].Product as p
			on d.ProductID=p.ProductID
			where d.SalesOrderID=@SalesOID;
		open SaleUnitPrice_Cursor
		fetch next from SaleUnitPrice_Cursor into @saleUnitPrice;

		--Sale Unit Price Discount
		declare SaleUnitPriceDiscount_Cursor cursor
		for select d.UnitPriceDiscount
			from [SalesLT].[SalesOrderDetail] as d
			left join [SalesLT].Product as p
			on d.ProductID=p.ProductID
			where d.SalesOrderID=@SalesOID;
		open SaleUnitPriceDiscount_Cursor
		fetch next from SaleUnitPriceDiscount_Cursor into @saleUnitPriceDiscount;

		--Sale Line Total
		declare SaleLineTotal_Cursor cursor
		for select d.LineTotal
			from [SalesLT].[SalesOrderDetail] as d
			left join [SalesLT].Product as p
			on d.ProductID=p.ProductID
			where d.SalesOrderID=@SalesOID;
		open SaleLineTotal_Cursor
		fetch next from SaleLineTotal_Cursor into @saleLineTotal;
		
		print 'Product: ' + @productName + ' / OrderQty: ' + cast(@saleOrderQty as varchar(10)) + ' / UnitPrice: ' + cast(@saleUnitPrice as varchar(10)) + ' / UnitPriceDiscount: ' + cast(@saleUnitPriceDiscount as varchar(10)) + ' / Line Total: ' + cast(@saleLineTotal as varchar(10));		
		close ProductName_Cursor;
		close SaleOrderQty_Cursor;
		close SaleUnitPrice_Cursor;
		close SaleUnitPriceDiscount_Cursor;
		close SaleLineTotal_Cursor;
		deallocate ProductName_Cursor;
		deallocate SaleOrderQty_Cursor;
		deallocate SaleUnitPrice_Cursor;
		deallocate SaleUnitPriceDiscount_Cursor;
		deallocate SaleLineTotal_Cursor;

		set @salesCount = @salesCount  - 1;
	end
go

exec dbo.spListaCompra @SalesOID = 71863;
Etapa 2
--a)
create or alter function dbo.fnCodificaPassword (@password nvarchar(10))
returns nvarchar(255)
AS
begin
	declare @newPassword nvarchar(255);

	set @newPassword = hashbytes('SHA1',@password);

	return @newPassword;
end;

select dbo.fnCodificaPassword('123abc.') as Password;

--b
CREATE TABLE CustomerPW (
	ID int,
	Password nvarchar(255)
);

--c AAAAAAAAA
create or alter procedure dbo.spNovoCliente @ID int, @NameStyle bit, @FirstName nvarchar(50), @LastName nvarchar(50), @email nvarchar(50), @Password nvarchar(10)
as
	SET IDENTITY_INSERT SalesLT.Customer ON
	insert into SalesLT.Customer (CustomerID, NameStyle, FirstName, LastName, EmailAddress, PasswordHash, PasswordSalt) values (@ID, @NameStyle, @FirstName, @LastName, @email, ' ', ' ');  
	SET IDENTITY_INSERT SalesLT.Customer off
	
	insert into dbo.CustomerPW (ID, Password) values (@ID, (select dbo.fnCodificaPassword(@Password)));
go

exec dbo.spNovoCliente @ID=5000, @NameStyle=0, @FirstName='Nuno', @LastName='Reis', @email='nunoreis294@gmail.com', @Password='123abc.';

--d
create or alter function dbo.fnAutenticar (@email nvarchar(50), @password nvarchar(10))
returns int
AS
begin
	declare @id int;

	set @id = (select c.CustomerID
			from SalesLT.Customer as c
			join dbo.CustomerPW as cp
			on c.CustomerID=cp.ID
			where c.EmailAddress=@email and cp.Password=(select dbo.fnCodificaPassword(@password)));

	return @id;
end;

select dbo.fnAutenticar('nunoreis294@gmail.com', '123abc.');

Etapa 3
--a)
create schema Logs;

create or alter table Logs.CustomerLog ([CustomerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [dbo].[Name] NOT NULL,
	[MiddleName] [dbo].[Name] NULL,
	[LastName] [dbo].[Name] NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[CompanyName] [nvarchar](128) NULL,
	[SalesPerson] [nvarchar](256) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Phone] [dbo].[Phone] NULL,
	[PasswordHash] [varchar](128) NOT NULL,
	[PasswordSalt] [varchar](10) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	Log_Data timestamp,
	Log_Operacao char
 CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED 
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE Logs.CustomerLog ADD  CONSTRAINT [DF_Customer_NameStyle]  DEFAULT ((0)) FOR [NameStyle]
GO

ALTER TABLE Logs.CustomerLog ADD  CONSTRAINT [DF_Customer_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

ALTER TABLE Logs.CustomerLog ADD  CONSTRAINT [DF_Customer_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO



Crie a tabela CustomerLog no schema “Logs” (deve ser criado previamente) e os Triggers
necessários, de modo a implementar um mecanismo de auditoria sobre a tabela Customer. A
tabela CustomerLog para além dos atributos da tabela Customer, devem ser adicionados os
seguintes atributos:
• Log_Data: timestamp da alteração;
• Log_Operacao: ‘U’ – update, ‘D’ – delete
• Quando se altera ou se apaga um registo da tabela Customer, deve ser executada uma
cópia do registo que sofreu as alterações para a tabela de log, adicionando o
rowversion e o tipo de operação.


--b)
create trigger trig_name
on all server
{ for| after }
logon
as { sql_statement [ ; ] }
go

Crie os Triggers necessários para implementar as seguintes funcionalidades:
• Quando se atualiza a password de um cliente, esta deve ser guardada na tabela
CustomerPW com codificação em SHA1;
• Verifica a restrição de não poderem existir utilizadores com o mesmo login
(EmailAddress).

Etapa 4
--a)


Crie um conjunto de queries que para uma determinada tabela (e.g., Customer) permita:
• Visualizar para todas as colunas, o nome e se essa coluna tem a restrição NOT NULL;
• Visualizar o atributo IDENTITY;
• Visualizar a(s) coluna(s) que constituem a chave primária;
• Visualizar para as chaves estrangeiras, qual o nome da coluna e a tabela/coluna que é
referenciada;

--b)


Crie o stored procedure sp_disable_FK que recebe como argumento o nome de uma tabela
(@p_table_name), e gera como saída um script (i.e., lista de comandos SQL) que permite
fazer disable a todas as chaves estrangeiras que fazem referência à tabela.
