Lab 4 - Transações e Concorrência
Nome: Nuno Reis		Número: 202000753

SELECT * INTO Customer FROM SalesLT.Customer WHERE CustomerID < 1000
SELECT * FROM Customer

Etapa 1
--1)
/*
	Como a primeira transação não é finalizada (os dados não são efetivados) a segunda não consegue obter nenhuma leitura
	O nivel de isolamento da segunda transação devera permitir ler dados que ainda não sofreram efetivação (READ UNCOMMITTED)
*/

--2)

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
	O resultado é parecido com o obtido na etapa 2
	O resultado das duas queries é igual, apesar do email ser alterado entre estas duas
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