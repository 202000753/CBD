Lab 4 - Transações e Concorrência
Nome: Nuno Reis		Número: 202000753

SELECT * INTO Customer FROM SalesLT.Customer WHERE CustomerID < 1000
SELECT * FROM Customer

Etapa 1
--1)
/*
	Como a primeira transação não é finalizada (os dados não são efetivados) a segunda obtem os dados anteriores
	O nivel de isolamento da segunda transação devera permitir ler dados que ainda não sofreram efetivação (READ UNCOMMITTED)
*/

--2)
/*
	
*/

--3)
/*
	Na primeira transação a primeira query lê um email e a segunda lê outro email diferente
	Entre as duas queries o email é alterado pela segunda transação, logo as duas queries leem dados diferentes
*/

Etapa 2
--1)
/*
	O resultado das duas queries é igual
	Entre as duas queries o email é alterado pela segunda transação, mas como o nivel de isolamento da primeira transação
	apenas permite ler dados efetivados mas outras transações podem criar dados no intervalo lido pela transação, logo as
	duas queries leem dados iguais
*/

--2)
/*
	O nível de isolamento REPEATABLE READ deve ser utilizado em situações que possa haver efeitos secundários nos dados
	(dirty-read e nonrepetable read)
*/

--3)
/*
	
*/

Estapa 3
--1)
/*
	O resultado é parecido com o obtido na etapa 2
	O resultado das duas queries é igual, apesar do email ser alterado entre estas duas
*/


Estapa 4
--1)
/*
	Janela #1-> 51
	Janela #2-> 70
*/

--2)
/*
	Esta query mostra as sessões que estão ativas (sleeping, bakground, suspended e running)
	Usando a condição blocking_session_id > 0 não são apresentadas nenhumas sessões
	Enquanto a janela #1 faz um WAITFOR DELAY a sessão está suspended
*/

--3)
/*
	session_id	text
	51			BEGIN TRAN    SELECT EmailAddress  FROM dbo.Customer  WHERE CustomerId = 5    WAITFOR DELAY '00:00:10'    SELECT EmailAddress  FROM dbo.Customer  WHERE CustomerId = 5
	70			BEGIN TRAN  UPDATE dbo.Customer  SET EmailAddress = 'new@estsetubal.ips.pt.pt'  WHERE CustomerId = 5  COMMIT

	session_id são os numero de sessão associado às janelas #1 e #2
	text é as queryies executadas nas sessões
*/

--4)
exec sp_who2
kill 70
exec sp_who2

/*
	A sessão passa de suspended para dormant
*/