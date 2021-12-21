Lab 4 - Transa��es e Concorr�ncia
Nome: Nuno Reis		N�mero: 202000753

SELECT * INTO Customer FROM SalesLT.Customer WHERE CustomerID < 1000
SELECT * FROM Customer

Etapa 1
--1)
/*
	Como a primeira transa��o n�o � finalizada (os dados n�o s�o efetivados) a segunda n�o consegue obter nenhuma leitura
	O nivel de isolamento da segunda transa��o devera permitir ler dados que ainda n�o sofreram efetiva��o (READ UNCOMMITTED)
*/

--2)

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
INSERT INTO dbo.Customer
VALUES (0, 'Mr.', 'FirstName', null, 'LastName', null, 'CompanyName',
'SalesPerson','EmailAdress','Phone','','',NEWID(),GETDATE());

select *
from dbo.Customer

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
	
*/

--2)
/*
	
*/

--3)
/*
	
*/

--4)
/*
	
*/