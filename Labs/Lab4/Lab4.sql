Lab 4 - Transa��es e Concorr�ncia
Nome: Nuno Reis		N�mero: 202000753

SELECT * INTO Customer FROM SalesLT.Customer WHERE CustomerID < 1000
SELECT * FROM Customer

Etapa 1
--1)
/*
	Como a primeira transa��o n�o � finalizada (os dados n�o s�o efetivados) a segunda obtem os dados anteriores
	O nivel de isolamento da segunda transa��o devera permitir ler dados que ainda n�o sofreram efetiva��o (READ UNCOMMITTED)
*/

--2)
/*
	
*/

--3)
/*
	Na primeira transa��o a primeira query l� um email e a segunda l� outro email diferente
	Entre as duas queries o email � alterado pela segunda transa��o, logo as duas queries leem dados diferentes
*/

Etapa 2
--1)
/*
	O resultado das duas queries � igual
	Entre as duas queries o email � alterado pela segunda transa��o, mas como o nivel de isolamento da primeira transa��o
	apenas permite ler dados efetivados mas outras transa��es podem criar dados no intervalo lido pela transa��o, logo as
	duas queries leem dados iguais
*/

--2)
/*
	O n�vel de isolamento REPEATABLE READ deve ser utilizado em situa��es que possa haver efeitos secund�rios nos dados
	(dirty-read e nonrepetable read)
*/

--3)
/*
	
*/

Estapa 3
--1)
/*
	O resultado � parecido com o obtido na etapa 2
	O resultado das duas queries � igual, apesar do email ser alterado entre estas duas
*/


Estapa 4
--1)
/*
	Janela #1-> 51
	Janela #2-> 70
*/

--2)
/*
	Esta query mostra as sess�es que est�o ativas (sleeping, bakground, suspended e running)
	Usando a condi��o blocking_session_id > 0 n�o s�o apresentadas nenhumas sess�es
	Enquanto a janela #1 faz um WAITFOR DELAY a sess�o est� suspended
*/

--3)
/*
	session_id	text
	51			BEGIN TRAN    SELECT EmailAddress  FROM dbo.Customer  WHERE CustomerId = 5    WAITFOR DELAY '00:00:10'    SELECT EmailAddress  FROM dbo.Customer  WHERE CustomerId = 5
	70			BEGIN TRAN  UPDATE dbo.Customer  SET EmailAddress = 'new@estsetubal.ips.pt.pt'  WHERE CustomerId = 5  COMMIT

	session_id s�o os numero de sess�o associado �s janelas #1 e #2
	text � as queryies executadas nas sess�es
*/

--4)
exec sp_who2
kill 70
exec sp_who2

/*
	A sess�o passa de suspended para dormant
*/