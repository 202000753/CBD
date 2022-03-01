/*Backup e Recuperação
Tiago Paixão	201000625
Nuno Reis		202000753*/

use master

--Backup Completo
BACKUP DATABASE [ProjectoCBD]
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ProjectoCBD.bak'
WITH NOFORMAT, NOINIT,  NAME = N'ProjectoCBD-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--Backup Diferencial
BACKUP DATABASE [ProjectoCBD]
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ProjectoCBD_Differential.bak'
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'ProjectoCBD-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--Recuperação 
USE master
BACKUP LOG [ProjectoCBD] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ProjectoCBD_LogBackup_2022-01-18_16-33-40.bak' WITH NOFORMAT, NOINIT,  NAME = N'ProjectoCBD_LogBackup_2022-01-18_16-33-40', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [ProjectoCBD] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ProjectoCBD.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [ProjectoCBD] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ProjectoCBD_Differential.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO