/*Criação da Base de Dados
Tiago Paixão	201000625
Nuno Reis		202000753*/

use master
create database ProjectoCBD
go

use ProjectoCBD
go

create schema OldData;
go
create schema ActiveData;
go
create schema ArchiveData;
go

create table ActiveData.Subject(
	SubjectID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar(40) NOT NULL
)

create table ActiveData.Address(
	AddressID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AddressLine1 nvarchar (60) NOT NULL,
	AddressLine2 nvarchar (60),
	City nvarchar (30) NOT NULL,
	StateProvince nvarchar (30) NOT NULL,
	CountryRegion nvarchar (50) NOT NULL,
	PostalCode nvarchar (15) NOT NULL
)

create table ActiveData.Sys_User(
	UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar (60) NOT NULL,
	Mail nvarchar(70) UNIQUE NOT NULL,
	Password nvarchar (35) NOT NULL,
	LastAccess datetime
)

create table ActiveData.UserAddress(
	UserID int NOT NULL FOREIGN KEY REFERENCES ActiveData.Sys_User (UserID),
	AddressID int NOT NULL FOREIGN KEY REFERENCES ActiveData.Address (AddressID),
	IsMainAddress bit NOT NULL,
	AddressType bit NOT NULL -- Urban 0, Rural 1 
	PRIMARY KEY (UserID, AddressID)
)	

create table ActiveData.School(
	SchoolID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar(40) NOT NULL,
)

create table ActiveData.Guardian(
	GuardianID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID int NOT NULL foreign key references ActiveData.Sys_User(UserID)
)

create table ActiveData.Student (
	StudentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserID int NOT NULL foreign key references ActiveData.Sys_User (UserID),
	Gender char,
	BirthDate date NOT NULL,
	FamSize bit, --LE3 0 GT3 1
	Pstatus bit, --T 0 A 1
	Medu tinyint,
	Fedu tinyint,
	Mjob nvarchar (20),
	Fjob nvarchar (20),
	Reason nvarchar (20),
	Guardian_Relation nvarchar (20),
	TravelTime tinyint,
	StudyTime tinyint,
	Schoolsup bit, --No 0 Yes  1
	Famsup bit, --No 0 Yes  1
	Paid bit, --No 0 Yes  1
	Activities bit, --No 0 Yes  1
	Nursery bit, --No 0 Yes  1
	Higher bit, --No 0 Yes  1
	Internet bit, --No 0 Yes  1
	Romatic bit, --No 0 Yes  1
	Famrel tinyint,
	Freetime tinyint,
	Goout tinyint,
	Dalc tinyint,
	Walc tinyint,
	Health tinyint,
	SchoolID int NOT NULL foreign key references ActiveData.School (SchoolID),
	GuardianID int foreign key references ActiveData.Guardian(GuardianID)
)

create table ActiveData.Student_MultiLanguage (
	StudentID int NOT NULL,
	Lang nvarchar (5) NOT NULL,
	Mjob varchar (20),
	Fjob varchar (20),
	Reason varchar (20),
	Guardian_Relation nvarchar (20)
	PRIMARY KEY (StudentID, Lang)
)

create table ArchiveData.Cloosed_Course(
	SchoolYear smallint NOT NULL ,
	SubjectID int NOT NULL foreign key references ActiveData.Subject (SubjectID),
	StudentID int NOT NULL foreign key references ActiveData.Student (StudentID),
	Failures tinyint,
	Absences tinyint,
	P1_grade tinyint,
	P2_grade tinyint,
	P3_grade tinyint,
	PRIMARY KEY(SchoolYear, SubjectID, StudentID)
)

create table ActiveData.Current_Course(
	SubjectID int NOT NULL foreign key references ActiveData.Subject (SubjectID),
	StudentID int NOT NULL foreign key references ActiveData.Student (StudentID),
	Failures tinyint,
	Absences tinyint,
	P1_grade tinyint,
	P2_grade tinyint,
	P3_grade tinyint,
	PRIMARY KEY(SubjectID, StudentID)
)

CREATE TABLE ActiveData.ServidorMail(
	mailID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	mailReceiver nvarchar (70) NOT NULL,
	tokenNumber nvarchar (10) NOT NULL,
	mailDateTime datetime NOT NULL
)