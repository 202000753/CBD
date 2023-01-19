/********************************************
*	UC: Complementos de Bases de Dados 2022/2023
*
*	Projeto 2� Fase - Backup e Recupera��o
*	Nuno Reis (202000753)
*			Turma: 2�L_EI-SW-08 - sala F155 (14:30h - 16:30h)
*
********************************************/
--Backup Completo
BACKUP DATABASE [WWIGlobal]
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WWIGlobal.bak'
WITH NOFORMAT, NOINIT,  NAME = N'WWIGlobal-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--Backup Diferencial
BACKUP DATABASE [WWIGlobal]
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WWIGlobal_Differential.bak'
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'WWIGlobal-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--Recupera��o 
USE master
BACKUP LOG [WWIGlobal] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WWIGlobal_log.bak' WITH NOFORMAT, NOINIT,  NAME = N'WWIGlobal', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [WWIGlobal] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WWIGlobal.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [WWIGlobal] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WWIGlobal_Differential.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO