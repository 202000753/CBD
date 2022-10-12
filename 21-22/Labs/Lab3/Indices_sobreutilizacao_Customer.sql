/***************************
12 - Mostrar o efeito da sobreutiliza��o de indices
****************************/
-- Replicar a estrutura da tabela [Customer]
/* CREATE TABLE */


USE [AdventureWorksLT2019]
GO


DROP TABLE IF EXISTS [SalesLT].[SobreCustomer];

CREATE TABLE [SalesLT].[SobreCustomer](
    [CustomerID] [int] NOT NULL,
	[NameStyle] [dbo].[NameStyle] NOT NULL CONSTRAINT [DF_Customer_NameStyle_2]  DEFAULT ((0)),
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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Customer_rowguid_2]  DEFAULT (newid()),
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_ModifiedDate_2]  DEFAULT (getdate()))
GO


-- Medi��o do Tempo de execu��o
set statistics time on
go

-- Inserir Dados em [SobreCustomer]


INSERT INTO [AdventureWorksLT2019].[SalesLT].[SobreCustomer]
select * 
from [AdventureWorksLT2019].[SalesLT].[Customer]
-- Remover os dados da tabela 
TRUNCATE TABLE [AdventureWorksLT2019].[SalesLT].[SobreCustomer]
GO

-- Criar um numero excessivo de indices 
-- Cria��p PK (sem Clustered especificado)
-- Ver Tables / Keys e Indexes (PK e indice clustered criado automaticamente)
ALTER TABLE [AdventureWorksLT2019].[SalesLT].[SobreCustomer] 
ADD CONSTRAINT PK_CustomerID2 PRIMARY KEY  clustered (CustomerID asc)
GO

CREATE NONCLUSTERED INDEX SobreCustomer_Title ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (Title)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_FirstName ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (FirstName)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_MiddleName ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (MiddleName)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_LastName ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (LastName)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_CompanyName ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (CompanyName)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_EmailAddress ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (EmailAddress)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_PasswordHash ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (PasswordHash)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_PasswordSalt ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (PasswordSalt)
	
GO

CREATE NONCLUSTERED INDEX SobreCustomer_ModifiedDate ON [AdventureWorksLT2019].[SalesLT].[SobreCustomer] (ModifiedDate)
	
GO


-- Inserir Novamente Dados em [SobreCustomer]

INSERT INTO [AdventureWorksLT2019].[SalesLT].[SobreCustomer]
select *
from [AdventureWorksLT2019].[SalesLT].[Customer]


-- Remover os dados da tabela 
TRUNCATE TABLE  [AdventureWorksLT2019].[SalesLT].[SobreCustomer]
GO

-- Remover  tabela 
DROP TABLE  [AdventureWorksLT2019].[SalesLT].[SobreCustomer]
GO


-- Medi��o do Tempo de execu��o
set statistics time off
go