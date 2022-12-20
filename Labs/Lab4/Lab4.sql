 /********************************************
 *	UC: Complementos de Bases de Dados 2020/2021 
 *
 *	Laborat�rio 4 �  Transa��es e Concorr�ncia
 *		Nuno Reis (202000753)
 *		Turma: 2�L_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *	
 ********************************************/
 --Crie a tabela Customer:
SELECT * INTO Customer FROM SalesLT.Customer WHERE CustomerID < 1000;

--============================================================================= 
-- Etapa 1
--============================================================================= 
/*1.1. � poss�vel obter os valores que ainda est�o bloqueados ou n�o confirmados por altera��es de 
outra transa��o. No SSMS, abra duas janelas e execute as seguintes instru��es:*/
--Janela #1: Execute a seguinte transa��o, sem a finalizar:
BEGIN TRANSACTION
	update dbo.Customer
	SET EmailAddress = 'new@estsetubal.ips.pt.pt'
	WHERE CustomerId = 6
	
--Janela #2: Tente obter a leitura do valor:
	SELECT EmailAddress
	FROM dbo.Customer
	WHERE CustomerId = 6

/*Analise os resultados obtidos, ir� constatar que N�O consegue obter nenhuma leitura.
Apresente uma resposta devidamente fundamentada?*/

/*1.2. Na Janela #2 do ponto anterior, tente novamente obter o valor, mas executando a seguinte 
instru��o:*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
GO
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6

--OU
SELECT EmailAddress
FROM dbo.Customer (NOLOCK)
WHERE CustomerId = 6

/*Comente este procedimento. Apresente uma resposta devidamente fundamentada?
Termine a transa��o na Janela #1 executando a instru��o*/
ROLLBACK

/*1.3. As seguintes instru��es pretendem demonstrar a import�ncia das transa��es em execu��es 
concorrenciais. Abra duas janelas e execute as seguintes fun��es de seguida:*/
--Janela #1: execute as seguintes queries, separadas por 10 segundos, � mesma tabela
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT ON
GO
BEGIN TRAN
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
WAITFOR DELAY '00:00:10'
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
COMMIT TRAN

-- obs.: se necess�rio, poder� aumentar o delay para 15 ou 20 segundos

BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'new@estsetubal.ips.pt.pt'
WHERE CustomerId = 6
COMMIT
--Qual o resultado das duas queries na Janela #1? Comente.

--============================================================================= 
-- Etapa 2
--============================================================================= 
/*Este n�vel de isolamento ultrapassa as limita��es dos isolamentos anteriores. Abra duas janelas e 
execute as seguintes fun��es de seguida:*/
--Janela #1: execute as seguintes queries, separadas por 10 segundos, � mesma tabela
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET NOCOUNT ON
GO
BEGIN TRAN
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
WAITFOR DELAY '00:00:10'
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
COMMIT TRAN

/*Janela #2: alterar o valor do EmailAddress enquanto o procedimento anterior est� em 
execu��o*/
BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'update@estsetubal.ips.pt.pt'
WHERE CustomerId = 6
COMMIT

--2.1) Qual o resultado das duas queries na Janela #1? Comente.

/*2.2) Em que situa��es se deve utilizar o n�vel de isolamento REPEATABLE READ, apresente 
uma resposta devidamente fundamentada?*/

--2.3) Altere o comando do ponto 2 para inserir uma nova linha na mesma tabela.
INSERT INTO dbo.Customer 
VALUES (0, 'Mr.', 'FirstName', null, 'LastName', null, 'CompanyName',
'SalesPerson','EmailAdress','Phone','','',NEWID(),GETDATE());
--Execute novamente as instru��es acima (i.e., Janela #1 & Janela #2) e comente o resultado.

--============================================================================= 
-- Etapa 3
--============================================================================= 
/*Para ultrapassar o problema das leituras fantasma, � necess�rio um n�vel de isolamento 
SERIALIZABLE. Este n�vel, para al�m de assegurar o isolamento do READ COMMITED e 
REPEATABLE READ, permite tamb�m que transa��es concorrentes executem como se fosse em 
s�rie. Contudo, o impacto � a redu��o da concorr�ncia do SGBD e portanto, menor performance.*/
--Tendo por base as instru��es executadas na Etapa 2, fa�a as seguintes altera��es:
--� Substituir: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
--� Por: SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
--Comente o resultado obtido.
--Janela #1: execute as seguintes queries, separadas por 10 segundos, � mesma tabela
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET NOCOUNT ON
GO
BEGIN TRAN
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
WAITFOR DELAY '00:00:10'
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 6
COMMIT TRAN

/*Janela #2: alterar o valor do EmailAddress enquanto o procedimento anterior est� em 
execu��o*/
BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'new@estsetubal.ips.pt.pt'
WHERE CustomerId = 6
COMMIT

--============================================================================= 
-- Etapa 4
--============================================================================= 
--Views de sistema sobre concorr�ncia
--4.1) Identifique o n�mero de sess�o associado �s janelas #1 e #2 da Etapa 1.
/*Dever� executar de novo ambas e numa terceira janela (i.e., janela #3), executar a seguinte 
query:*/
SELECT -- use * to explore
 request_session_id AS spid,
 resource_type AS restype,
 resource_database_id AS dbid,
 resource_description AS res,
 resource_associated_entity_id AS resid,
 request_mode AS mode,
 request_status AS status
FROM sys.dm_tran_locks;
--Comente os resultados obtidos

--4.2) Observe e explore o resultado da seguinte query, comente os resultados obtidos.
SELECT -- use * to explore
 session_id AS spid, -- session ID (SPID)
 blocking_session_id,
 command,
 sql_handle,
 database_id,
 wait_type,
 wait_time,
 wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;

/*4.3) Execute a seguinte query, substituindo X e Y pelos n�meros de sess�o identificados no 
ponto 4.1; comente os resultados obtidos.*/
SELECT session_id, text
FROM sys.dm_exec_connections
 CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST 
WHERE session_id IN (X, Y);

/*4.4) Execute as duas queries da Etapa 1 (i.e., janelas #1 e #2) e identifique os processos 
bloqueados utilizando o procedimento de sistema: */
EXEC sp_who2

/*Parar a sess�o que est� a criar o bloqueio aplique o m�todo KILL. Comente os resultados 
obtidos.*/
-- Example: checking the status of a query using the sp_who2
-- Use the KILL command to KILL SPID. 
-- Example: execute this command in a new query window to kill SPID 84
KILL 84

-- After executing the KILL SPID command, SQL Server starts the ROLLBACK process 
for the selected query. 
-- Check the �Status� using the sp_who2