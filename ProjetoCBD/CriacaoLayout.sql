 /********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1ª Fase - Criação do Layout
 *		Nuno Reis (202000753)
 *			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
USE master

--DROP DATABASE WWIGlobal
CREATE DATABASE WWIGlobal
/*ON 
( NAME = WWIGlobal_Saledat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WWIGlobalSaledat.mdf',
	SIZE = --,
	MAXSIZE = --,
	FILEGROWTH = -- ),
( NAME = WWIGlobal2_Productdat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WWIGlobalProductdat.mdf',
	SIZE = --,
	MAXSIZE = --,
	FILEGROWTH = -- ),
( NAME = WWIGlobal2_Userdat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WWIGlobalUserdat.mdf',
	SIZE = --,
	MAXSIZE = --,
	FILEGROWTH = -- )
LOG ON
( NAME = WWIGlobal_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\WWIGloballog.ldf',
	SIZE = --,
	MAXSIZE = --,
	FILEGROWTH = -- ) ;*/
GO

USE WWIGlobal
GO

 /********************************************
 *	Schemas
 ********************************************/
--DROP SCHEMA SalesInfo;
CREATE SCHEMA SalesInfo;
GO

--DROP SCHEMA ProductsInfo;
CREATE SCHEMA ProductsInfo;
GO

--DROP SCHEMA UsersInfo;
CREATE SCHEMA UsersInfo;
GO

--DROP SCHEMA OldData;
CREATE SCHEMA OldData;
GO


 /********************************************
 *	Tabelas
 ********************************************/
 --DROP TABLE UsersInfo.Country;
CREATE TABLE UsersInfo.Country (
	CouId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CouName VARCHAR(20) NOT NULL,
	CouContinent VARCHAR(20) NOT NULL
);
GO

--DROP TABLE UsersInfo.StateProvince;
CREATE TABLE UsersInfo.StateProvince (
	StaProId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	StaProName VARCHAR(50) NOT NULL,
	StaProCode VARCHAR(5)
);
GO

--DROP TABLE UsersInfo.City;
CREATE TABLE UsersInfo.City (
	CitId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CitName VARCHAR(50) NOT NULL,
	CitSalesTerritory VARCHAR(50),
	CitLasPopulationRecord INT
);
GO

--DROP TABLE UsersInfo.Category;
CREATE TABLE UsersInfo.Category (
	CatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CatName VARCHAR(20) NOT NULL
);
GO

--DROP TABLE UsersInfo.Region_Category;
CREATE TABLE UsersInfo.Region_Category (
	Reg_CatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Reg_CatCitStateProvinceId INT NOT NULL foreign key references UsersInfo.StateProvince (StaProId),
	Reg_CatCityId INT NOT NULL foreign key references UsersInfo.City (CitId),
	Reg_CatCategoryId INT NOT NULL foreign key references UsersInfo.Category (CatId),
	Reg_CatCountryId INT NOT NULL foreign key references UsersInfo.Country (CouId),
	Reg_CatPostalCode INT
);
GO

--DROP TABLE UsersInfo.BuyingGroup;
CREATE TABLE UsersInfo.BuyingGroup (
	BuyGrouId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BuyGrouName VARCHAR(20) NOT NULL
);
GO

 --DROP TABLE UsersInfo.SysUser;
CREATE TABLE UsersInfo.SysUser (
	SysUseId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SysUseEmail VARCHAR(50) UNIQUE NOT NULL,
	SysUsePassword VARCHAR(20) NOT NULL,
	SysUseName VARCHAR(50) NOT NULL
);
GO

--DROP TABLE UsersInfo.Customer;
CREATE TABLE UsersInfo.Customer (
    CusUserId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.SysUser(SysUseId),
    CusHeadquartersId INT FOREIGN KEY REFERENCES UsersInfo.Customer(CusUserId),
    CusRegion_CategoryId INT FOREIGN KEY REFERENCES UsersInfo.Region_Category(Reg_CatId),
    CusBuyingGroupId INT FOREIGN KEY REFERENCES UsersInfo.BuyingGroup(BuyGrouId),
	CusPrimaryContact VARCHAR(40),
	PRIMARY KEY(CusUserId)
);
GO

--DROP TABLE UsersInfo.Employee;
CREATE TABLE UsersInfo.Employee (
    EmpUserId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.SysUser(SysUseId),
	EmpPreferedName VARCHAR(10),
	EmpIsSalesPerson BIT NOT NULL,
	PRIMARY KEY(EmpUserId)
);
GO

--DROP TABLE ProductsInfo.Package;
CREATE TABLE ProductsInfo.Package (
	PacId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PacPackage VARCHAR(25) NOT NULL
);
GO

--DROP TABLE ProductsInfo.Brand;
CREATE TABLE ProductsInfo.Brand (
	BraId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BraName VARCHAR(25) NOT NULL
);
GO

--DROP TABLE ProductsInfo.ProductType;
CREATE TABLE ProductsInfo.ProductType (
	ProTypId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProTypName VARCHAR(25) NOT NULL
);
GO

--DROP TABLE ProductsInfo.TaxRate;
CREATE TABLE ProductsInfo.TaxRate (
	TaxRatId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TaxRatTaxRate FLOAT NOT NULL
);
GO

--DROP TABLE ProductsInfo.Product;
CREATE TABLE ProductsInfo.Product (
	ProdId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProdBrandId INT FOREIGN KEY REFERENCES ProductsInfo.Brand(BraId),
    ProdTaxRateId INT FOREIGN KEY REFERENCES ProductsInfo.TaxRate(TaxRatId),
    ProdProductTypeId INT FOREIGN KEY REFERENCES ProductsInfo.ProductType(ProTypId),
    ProdBuyingPackageId INT FOREIGN KEY REFERENCES ProductsInfo.Package(PacId),
    ProdSellingPackageId INT FOREIGN KEY REFERENCES ProductsInfo.Package(PacId),
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

--DROP TABLE ProductsInfo.Promotion;
CREATE TABLE ProductsInfo.Promotion (
	PromId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PromDescription VARCHAR(100),
	PromStartDate DATE NOT NULL,
	PromEndDate DATE NOT NULL
);
GO

--DROP TABLE ProductsInfo.Product_Promotion;
CREATE TABLE ProductsInfo.Product_Promotion (
	Prod_PromProductPromotionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Prod_PromProductId INT  NOT NULL foreign key references ProductsInfo.Product (ProdId),
	Prod_PromPromotionId INT NOT NULL foreign key references ProductsInfo.Promotion (PromId),
	ProdNewPrice FLOAT NOT NULL
);
GO

--DROP TABLE SalesInfo.Sale;
CREATE TABLE SalesInfo.Sale (
	SalID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SalCustomerId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.Customer(CusUserId),
    SalEmployeeId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.Employee(EmpUserId),
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

--DROP TABLE SalesInfo.ProductPromotion_Sale;
CREATE TABLE SalesInfo.ProductPromotion_Sale (
	ProdProm_SalProductPromotionId INT NOT NULL foreign key references ProductsInfo.Product_Promotion (Prod_PromProductPromotionId),
	ProdProm_SalSaleId INT NOT NULL foreign key references SalesInfo.Sale (SalID),
	ProdProm_SalQuantity INT NOT NULL,
	PRIMARY KEY(ProdProm_SalProductPromotionId, ProdProm_SalSaleID)
);
GO

--DROP TABLE UsersInfo.Token;
CREATE TABLE UsersInfo.Token (
	TokId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TokUserId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.SysUser(SysUseId),
    TokMail VARCHAR(30) NOT NULL,
	TokDate TIMESTAMP NOT NULL,
	TokToken INT UNIQUE NOT NULL
);
GO

--DROP TABLE UsersInfo.ErrorLog;
CREATE TABLE UsersInfo.ErrorLog (
	ErrLogId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ErrLogUserId INT NOT NULL FOREIGN KEY REFERENCES UsersInfo.SysUser(SysUseId),
    ErrLogError VARCHAR(100) NOT NULL,
	ErrLogDate Date NOT NULL
);
GO