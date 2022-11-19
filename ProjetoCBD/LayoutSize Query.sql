/********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1ª Fase - Queries da dimeñsão do layout da base de dados
 *		Nuno Reis (202000753)
 *			Turma: 2ºL_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
 
exec sp_spaceused '[UsersInfo].[Country]'
exec sp_spaceused '[UsersInfo].[City]'
exec sp_spaceused '[UsersInfo].[StateProvince]'



/*select name, max_length from sys.columns where object_NAME(object_id) = 'NOME DA TABELA'
CREATE TABLE #SpaceUsed ( TableName sysname ,NumRows BIGINT ,ReservedSpace VARCHAR(50) 
,DataSpace VARCHAR(50) ,IndexSize VARCHAR(50) ,UnusedSpace VARCHAR(50) )
DECLARE @str VARCHAR(500) SET @str = 'exec sp_spaceused ''?''' INSERT INTO #SpaceUsed EXEC 
sp_msforeachtable @command1=@str
SELECT * FROM #SpaceUsed ORDER BY TableName

SELECT TableName, NumRows,
CONVERT(numeric(18,0),REPLACE(ReservedSpace,' KB','')) / 1024 as ReservedSpace_MB,
CONVERT(numeric(18,0),REPLACE(DataSpace,' KB','')) / 1024 as DataSpace_MB,
CONVERT(numeric(18,0),REPLACE(IndexSize,' KB','')) / 1024 as IndexSpace_MB,
CONVERT(numeric(18,0),REPLACE(UnusedSpace,' KB','')) / 1024 as UnusedSpace_MB
FROM #SpaceUsed
ORDER BY ReservedSpace_MB desc*/