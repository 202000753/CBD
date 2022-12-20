/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 1ª Fase - Criação do Layout
*	Nuno Reis (202000753)
*			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
*
********************************************/
USE master

--DROP DATABASE WWIGlobal
CREATE DATABASE WWIGlobal
go
/*ON 
( NAME = WWIGlobal_Readdat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WWIGlobalReaddat.mdf',
	SIZE = 2 MB,
	MAXSIZE = 10 MB,
	FILEGROWTH = 1 MB ),
( NAME = WWIGlobal2_Writedat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WWIGlobal2Writedat.mdf',
	SIZE = 2 MB,
	MAXSIZE = 10 MB,
	FILEGROWTH = 1 MB )
LOG ON
( NAME = WWIGlobal_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WWIGloballog.ldf',
	SIZE = 2 MB,
	MAXSIZE = 10 MB,
	FILEGROWTH = 1 MB ) ;
GO*/

USE WWIGlobal
GO

/********************************************
*	Schemas
********************************************/
--DROP SCHEMA Sales;
CREATE SCHEMA Sales;
GO

--DROP SCHEMA Storage;
CREATE SCHEMA Storage;
GO

--DROP SCHEMA RH;
CREATE SCHEMA RH;
GO

--DROP SCHEMA OldData;
CREATE SCHEMA OldData;
GO


/********************************************
*	Tabelas
********************************************/
--DROP TABLE RH.Country;
CREATE TABLE RH.Country (
	CouId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CouName VARCHAR(20) NOT NULL,
	CouContinent VARCHAR(20) NOT NULL
);
GO

--DROP TABLE RH.StateProvince;
CREATE TABLE RH.StateProvince (
	StaProId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	StaProName VARCHAR(50) NOT NULL,
	StaProCode VARCHAR(5)
);
GO

--DROP TABLE RH.City;
CREATE TABLE RH.City (
	CitId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CitName VARCHAR(50) NOT NULL,
	CitSalesTerritory VARCHAR(50),
	CitLasPopulationRecord INT
);
GO

--DROP TABLE RH.Category;
CREATE TABLE RH.Category (
	CatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CatName VARCHAR(20) NOT NULL
);
GO

--DROP TABLE RH.Region_Category;
CREATE TABLE RH.Region_Category (
	Reg_CatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Reg_CatStateProvinceId INT NOT NULL foreign key references RH.StateProvince (StaProId),
	Reg_CatCityId INT NOT NULL foreign key references RH.City (CitId),
	Reg_CatCategoryId INT NOT NULL foreign key references RH.Category (CatId),
	Reg_CatCountryId INT NOT NULL foreign key references RH.Country (CouId),
	Reg_CatPostalCode INT
);
GO

--DROP TABLE RH.BuyingGroup;
CREATE TABLE RH.BuyingGroup (
	BuyGrouId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BuyGrouName VARCHAR(20) NOT NULL
);
GO

--DROP TABLE RH.SysUser;
CREATE TABLE RH.SysUser (
	SysUseId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SysUseEmail VARCHAR(50) UNIQUE NOT NULL,
	SysUsePassword VARCHAR(20) NOT NULL,
	SysUseName VARCHAR(50) NOT NULL
);
GO

--DROP TABLE RH.Customer;
CREATE TABLE RH.Customer (
    CusUserId INT NOT NULL FOREIGN KEY REFERENCES RH.SysUser(SysUseId),
    CusHeadquartersId INT FOREIGN KEY REFERENCES RH.Customer(CusUserId),
    CusRegion_CategoryId INT FOREIGN KEY REFERENCES RH.Region_Category(Reg_CatId),
    CusBuyingGroupId INT FOREIGN KEY REFERENCES RH.BuyingGroup(BuyGrouId),
	CusPrimaryContact VARCHAR(40),
	PRIMARY KEY(CusUserId)
);
GO

--DROP TABLE RH.Employee;
CREATE TABLE RH.Employee (
    EmpUserId INT NOT NULL FOREIGN KEY REFERENCES RH.SysUser(SysUseId),
	EmpPreferedName VARCHAR(10),
	EmpIsSalesPerson BIT NOT NULL,
	PRIMARY KEY(EmpUserId)
);
GO

--DROP TABLE Storage.Package;
CREATE TABLE Storage.Package (
	PacId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PacPackage VARCHAR(25) NOT NULL
);
GO

--DROP TABLE Storage.Brand;
CREATE TABLE Storage.Brand (
	BraId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BraName VARCHAR(25) NOT NULL
);
GO

--DROP TABLE Storage.ProductType;
CREATE TABLE Storage.ProductType (
	ProTypId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProTypName VARCHAR(25) NOT NULL
);
GO

--DROP TABLE Storage.TaxRate;
CREATE TABLE Storage.TaxRate (
	TaxRatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TaxRatTaxRate FLOAT NOT NULL
);
GO

--DROP TABLE Storage.Product;
CREATE TABLE Storage.Product (
	ProdId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProdBrandId INT FOREIGN KEY REFERENCES Storage.Brand(BraId),
    ProdTaxRateId INT FOREIGN KEY REFERENCES Storage.TaxRate(TaxRatId),
    ProdProductTypeId INT FOREIGN KEY REFERENCES Storage.ProductType(ProTypId),
    ProdBuyingPackageId INT FOREIGN KEY REFERENCES Storage.Package(PacId),
    ProdSellingPackageId INT FOREIGN KEY REFERENCES Storage.Package(PacId),
	ProdName VARCHAR(100) NOT NULL,
	ProdColor VARCHAR(50),
	ProdSize VARCHAR(20),
	ProdLeadTimeDays INT,
	ProdQuantityPerOuter INT NOT NULL,
	ProdStock INT,
	ProdBarCode VARCHAR(20),
	ProdUnitPrice FLOAT NOT NULL,
	ProdRecommendedRetailPrice FLOAT,
	ProdTypicalWeightPerUnit FLOAT
);
GO

--DROP TABLE Storage.Promotion;
CREATE TABLE Storage.Promotion (
	PromId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PromDescription VARCHAR(100),
	PromStartDate DATE NOT NULL,
	PromEndDate DATE NOT NULL
);
GO

--DROP TABLE Storage.Product_Promotion;
CREATE TABLE Storage.Product_Promotion (
	Prod_PromProductPromotionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Prod_PromProductId INT  NOT NULL foreign key references Storage.Product (ProdId),
	Prod_PromPromotionId INT NOT NULL foreign key references Storage.Promotion (PromId),
	ProdNewPrice FLOAT NOT NULL
);
GO

--DROP TABLE Sales.Sale;
CREATE TABLE Sales.Sale (
	SalID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SalCustomerId INT NOT NULL FOREIGN KEY REFERENCES RH.Customer(CusUserId),
    SalEmployeeId INT NOT NULL FOREIGN KEY REFERENCES RH.Employee(EmpUserId),
	SalDate DATE NOT NULL,
	SalDeliveryDate DATE,
	SalDescription VARCHAR(100),
	SalProfit decimal(18, 2),
	SalTotalPrice decimal(18, 2),
	SalTotalExcludingTax decimal(18, 2),
	SalTaxAmount decimal(18, 2),
	SalIsFinished BIT NOT NULL
);
GO

--DROP TABLE Sales.ProductPromotion_Sale;
CREATE TABLE Sales.ProductPromotion_Sale (
	ProdProm_SalProductPromotionId INT NOT NULL foreign key references Storage.Product_Promotion (Prod_PromProductPromotionId),
	ProdProm_SalSaleId INT NOT NULL foreign key references Sales.Sale (SalID),
	ProdProm_SalQuantity INT NOT NULL,
	PRIMARY KEY(ProdProm_SalProductPromotionId, ProdProm_SalSaleID)
);
GO

--DROP TABLE RH.Token;
CREATE TABLE RH.Token (
	TokId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TokUserId INT NOT NULL FOREIGN KEY REFERENCES RH.SysUser(SysUseId),
    TokMail VARCHAR(30) NOT NULL,
	TokDateTime DATETIME NOT NULL,
	TokEndDateTime DATETIME NOT NULL,
	TokToken INT UNIQUE NOT NULL
);
GO

--DROP TABLE RH.ErrorLog;
CREATE TABLE RH.ErrorLog (
	ErrLogId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ErrLogError VARCHAR(300) NOT NULL,
	ErrLogDate datetime NOT NULL
);
GO