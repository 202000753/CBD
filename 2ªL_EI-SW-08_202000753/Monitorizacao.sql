/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2ª Fase - Criar os stored procedures de monitorização
*		Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
--drop table dbo.MonitorizacaoColunas
CREATE TABLE dbo.MonitorizacaoColunas (
	MonColId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	MonColVersion INT NOT NULL,
	MonColTableName VARCHAR(20) NOT NULL,
	MonColColumnName VARCHAR(20) NOT NULL,
	MonColColumnType VARCHAR(20) NOT NULL,
	MonColColumnSize int NOT NULL,
	MonColConstraintName VARCHAR(20) NOT NULL,
	MonColConstraintTipe VARCHAR(20) NOT NULL
);
GO

CREATE or alter PROCEDURE dbo.sp_monitorizacaoColuna 
AS   
	declare
		@n int,
		@tblname VARCHAR(20),
		@cname VARCHAR(20),
		@tname VARCHAR(20), 
		@cmax_length int,
		@oname VARCHAR(20),
		@otype_desc VARCHAR(20)

	set @n = (select top 1 MonColVersion
				from dbo.MonitorizacaoColunas
				ORDER BY MonColVersion DESC) + 1

	if(@n is null)
	begin
		set @n = 1
	end

	DECLARE selectCursor CURSOR  
		for select tbl.name, c.name, t.name, c.max_length, o.name, o.type_desc
			from sys.columns c
			join sys.types t
			on c.system_type_id = t.system_type_id
			join sys.all_objects o
			on c.object_id = o.parent_object_id
			join sys.tables tbl
			on c.object_id = tbl.object_id
			where c.object_id = object_id('[RH].[Token]')
					or c.object_id = object_id('[RH].[SysUser]')
					or c.object_id = object_id('[RH].[StateProvince]')
					or c.object_id = object_id('[RH].[Region_Category]')
					or c.object_id = object_id('[RH].[ErrorLog]')
					or c.object_id = object_id('[RH].[Employee]')
					or c.object_id = object_id('[RH].[Customer]')
					or c.object_id = object_id('[RH].[Country]')
					or c.object_id = object_id('[RH].[City]')
					or c.object_id = object_id('[RH].[Category]')
					or c.object_id = object_id('[RH].[BuyingGroup]')
					or c.object_id = object_id('[Sales].[Sale]')
					or c.object_id = object_id('[Sales].[ProductPromotion_Sale]')
					or c.object_id = object_id('[Storage].[TaxRate]')
					or c.object_id = object_id('[Storage].[Promotion]')
					or c.object_id = object_id('[Storage].[ProductType]')
					or c.object_id = object_id('[Storage].[Product_Promotion]')
					or c.object_id = object_id('[Storage].[Product]')
					or c.object_id = object_id('[Storage].[Package]')
					or c.object_id = object_id('[Storage].[Brand]')

	OPEN selectCursor 
	FETCH NEXT FROM selectCursor INTO 
		@tblname,
		@cname,
		@tname, 
		@cmax_length,
		@oname,
		@otype_desc

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		insert into dbo.MonitorizacaoColunas(MonColVersion, MonColTableName, MonColColumnName, MonColColumnType, MonColColumnSize, MonColConstraintName, MonColConstraintTipe) values(@n, @tblname, @cname, @tname, @cmax_length, @oname, @otype_desc)

	FETCH NEXT FROM selectCursor INTO
		@tblname,
		@cname,
		@tname, 
		@cmax_length,
		@oname,
		@otype_desc
	END 
	CLOSE selectCursor 
	DEALLOCATE selectCursor
GO  
EXECUTE dbo.sp_monitorizacaoColuna;
go
create or alter view dbo.v_LastMonitorizacaoColunas as
select *
from dbo.MonitorizacaoColunas
where MonColVersion = (select top 1 MonColVersion
						from dbo.MonitorizacaoColunas
						ORDER BY MonColVersion DESC);
go
select *
from dbo.v_LastMonitorizacaoColunas;
go

--drop table dbo.MonitorizacaoTabelas
exec sp_MSForEachTable 'exec sp_spaceused [?]'
/*CREATE TABLE dbo.MonitorizacaoTabelas (
	MonTabId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	MonTabVersion INT NOT NULL,
	MonTabTableName VARCHAR(20) NOT NULL,
	MonTabNRows int NOT NULL,
	MonTabData VARCHAR(20) NOT NULL
);
GO

CREATE or alter PROCEDURE dbo.sp_monitorizacaoTabela
AS   
	declare
		@n int,
		@tblname VARCHAR(20),
		@nrows int,
		@data VARCHAR(20)

	set @n = (select top 1 MonTabVersion
				from dbo.MonitorizacaoTabelas
				ORDER BY MonTabVersion DESC)

	if(@n is null)
	begin
		set @n = 1
	end

	DECLARE tableCursor CURSOR  
		for select name
			from sys.tables
			where object_id = object_id('[UsersInfo].[Token]')
					or object_id = object_id('[UsersInfo].[SysUser]')
					or object_id = object_id('[UsersInfo].[StateProvince]')
					or object_id = object_id('[UsersInfo].[Region_Category]')
					or object_id = object_id('[UsersInfo].[ErrorLog]')
					or object_id = object_id('[UsersInfo].[Employee]')
					or object_id = object_id('[UsersInfo].[Customer]')
					or object_id = object_id('[UsersInfo].[Country]')
					or object_id = object_id('[UsersInfo].[City]')
					or object_id = object_id('[UsersInfo].[Category]')
					or object_id = object_id('[UsersInfo].[BuyingGroup]')
					or object_id = object_id('[SalesInfo].[Sale]')
					or object_id = object_id('[SalesInfo].[ProductPromotion_Sale]')
					or object_id = object_id('[ProductsInfo].[TaxRate]')
					or object_id = object_id('[ProductsInfo].[Promotion]')
					or object_id = object_id('[ProductsInfo].[ProductType]')
					or object_id = object_id('[ProductsInfo].[Product_Promotion]')
					or object_id = object_id('[ProductsInfo].[Product]')
					or object_id = object_id('[ProductsInfo].[Package]')
					or object_id = object_id('[ProductsInfo].[Brand]')

	OPEN tableCursor 
	FETCH NEXT FROM tableCursor INTO 
		@tblname

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		DECLARE selectCursor CURSOR  
			for select name
				from sys.tables
				where object_id = object_id('[UsersInfo].[Token]')
						or object_id = object_id('[UsersInfo].[SysUser]')
						or object_id = object_id('[UsersInfo].[StateProvince]')
						or object_id = object_id('[UsersInfo].[Region_Category]')
						or object_id = object_id('[UsersInfo].[ErrorLog]')
						or object_id = object_id('[UsersInfo].[Employee]')
						or object_id = object_id('[UsersInfo].[Customer]')
						or object_id = object_id('[UsersInfo].[Country]')
						or object_id = object_id('[UsersInfo].[City]')
						or object_id = object_id('[UsersInfo].[Category]')
						or object_id = object_id('[UsersInfo].[BuyingGroup]')
						or object_id = object_id('[SalesInfo].[Sale]')
						or object_id = object_id('[SalesInfo].[ProductPromotion_Sale]')
						or object_id = object_id('[ProductsInfo].[TaxRate]')
						or object_id = object_id('[ProductsInfo].[Promotion]')
						or object_id = object_id('[ProductsInfo].[ProductType]')
						or object_id = object_id('[ProductsInfo].[Product_Promotion]')
						or object_id = object_id('[ProductsInfo].[Product]')
						or object_id = object_id('[ProductsInfo].[Package]')
						or object_id = object_id('[ProductsInfo].[Brand]')

		OPEN selectCursor 
		FETCH NEXT FROM selectCursor INTO 
			@tblname

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			insert into dbo.MonitorizacaoTabelas(MonColVersion, MonColTableName, MonColColumnName, MonColColumnType, MonColColumnSize, MonColConstraintName, MonColConstraintTipe) values(@n, @tblname, @cname, @tname, @cmax_length, @oname, @otype_desc)

			FETCH NEXT FROM selectCursor INTO
				@tblname
		END 
		CLOSE selectCursor 
		DEALLOCATE selectCursor

		exec sp_spaceused @tblname

		FETCH NEXT FROM tableCursor INTO
			@tblname
	END 
	CLOSE tableCursor 
	DEALLOCATE tableCursor
GO  
EXECUTE dbo.sp_monitorizacaoTabela;
go
create or alter view dbo.v_LastMonitorizacaoTabelas as
select *
from dbo.MonitorizacaoTabelas
where MonTabVersion = (select top 1 MonTabVersion
						from dbo.MonitorizacaoTabelas
						ORDER BY MonTabVersion DESC);
go
select *
from dbo.v_LastMonitorizacaoTabelas;
go*/