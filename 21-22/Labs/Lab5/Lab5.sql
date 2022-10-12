Lab 5 - Backup e Segurança
Nome: Nuno Reis		Número: 202000753
Etapa 1
--1)
use master
drop database Lista_Cliente
create database Lista_Cliente on primary
( name = N'a',
filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\a.mdf' ,
SIZE = 50MB , FILEGROWTH = 1024KB )
LOG ON
( NAME = N'_log',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\_log.ldf' ,
SIZE = 20MB , FILEGROWTH = 10%)

--2)
ALTER DATABASE Lista_Cliente SET RECOVERY FULL

--3)
use Lista_Cliente
drop table dbo.Cliente
CREATE TABLE Cliente (
 ClienteID INTEGER NOT NULL IDENTITY(1, 1),
 CliPrimeiroNome VARCHAR(50) NOT NULL,
 CliUltimoNome VARCHAR(100) NOT NULL,
 CliEmail VARCHAR(255) NOT NULL,
 CliDataNasc DATETIME NULL,
 CliTelem VARCHAR(20) NULL,
 CliEmpresa VARCHAR(150) NULL,
 PRIMARY KEY (ClienteID)
);

--4)
CREATE PROCEDURE InserirVarios (@Inicio int, @Fim int)
AS
BEGIN
	DECLARE @Contador INT = @Inicio
	WHILE (@Contador <= @Fim)
	BEGIN
		INSERT INTO
		Cliente
		(
			[CliPrimeiroNome], [CliUltimoNome], [CliEmail],
			[CliDataNasc], [CliTelem], [CliEmpresa]
		)
		VALUES
		(
			'Primeiro' + convert(varchar, @Contador),
			'Ultimo' + convert(varchar, @Contador),
			'email' + convert(varchar, @Contador) + '@dominio.pt',
			'19850611',
			'919191919',
			'Empresa' + + convert(varchar, @Contador)
		)
		SET @Contador = @Contador + 1
	END
END
GO

--5)
exec InserirVarios @Inicio=1, @Fim=100

Etapa 2
--1.2)
--6)
use master
BACKUP DATABASE [Lista_Cliente] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Lista_Cliente.bak' WITH NOFORMAT, NOINIT,  NAME = N'Lista_Cliente-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--7)
use Lista_Cliente
exec InserirVarios @Inicio=101, @Fim=120

--8)
use master
BACKUP DATABASE [Lista_Cliente] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Lista_Cliente__Differential.bak' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'Lista_Cliente-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
--a) full-10.572KB differential-2.164KB
--b)

--9)

--10)
/*
	Foram recuperados todos os dados que foram inseridos nos bakups
*/

--1.3)
--11)
use Lista_Cliente
exec InserirVarios @Inicio=121, @Fim=140

--12)


--13)
use Lista_Cliente
exec InserirVarios @Inicio=141, @Fim=160

--14)

--15)
--a)
/*
	Foram recuperados todos os dados que foram inseridos até ao backup do transational log
*/

--b)
/*
	Fazer um novo backup depois de inserir os ultimos 20 registos
*/

Etapa 3
use Faturacao
drop table dbo.Cliente
CREATE TABLE Cliente (
 ClienteID INTEGER NOT NULL IDENTITY(1, 1),
 CliPrimeiroNome VARCHAR(50) NOT NULL,
 CliUltimoNome VARCHAR(100) NOT NULL,
 CliEmail VARCHAR(255) NOT NULL,
 CliDataNasc DATETIME NULL,
 CliTelem VARCHAR(20) NULL,
 CliEmpresa VARCHAR(150) NULL,
 PRIMARY KEY (ClienteID)
);

--3.1)
--1)
drop schema Developer_Schema
CREATE SCHEMA Developer_Schema;
GO

--2)
CREATE TABLE table1 (
 id INTEGER NOT NULL IDENTITY(1, 1),
 name VARCHAR(50) NULL
);

CREATE TABLE Developer_Schema.table2 (
 id INTEGER NOT NULL IDENTITY(1, 1),
 name VARCHAR(50) NULL
);

--3)
CREATE LOGIN UserS1 with password = '123';

CREATE LOGIN UserS2 with password = '123';
CREATE LOGIN UserS3 with password = '123';

--4)
CREATE USER User1 FOR LOGIN UserS1   
    WITH DEFAULT_SCHEMA = Developer_Schema;  
GO  
CREATE USER User2 FOR LOGIN UserS2   
    WITH DEFAULT_SCHEMA = Developer_Schema;  
GO  
CREATE USER User3 FOR LOGIN UserS3   
    WITH DEFAULT_SCHEMA = Developer_Schema;  
GO

--3.2)
--5)
CREATE ROLE developer;  
GO 

CREATE ROLE client;  
GO 

CREATE ROLE reader;  
GO 

grant control to developer;


grant select to developer;
grant insert to developer;
grant update to developer;
grant create table to developer;
grant delete to developer;

grant select to client;
grant insert to client;
grant update to client;

grant select to reader;

--6)
EXEC sp_addrolemember 'developer', 'User1';
EXEC sp_addrolemember 'client', 'User2';
EXEC sp_addrolemember 'reader', 'User3';

--3.3)
--7)

--8)
insert into


--9)


--10)


Etapa 4
--11)

--12)


--13)


--14)


--15)


--16)


--17)


--18)