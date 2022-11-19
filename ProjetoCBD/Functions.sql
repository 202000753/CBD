/********************************************
 *	UC: Complementos de Bases de Dados 2022/2023
 *
 *	Projeto 1� Fase - Criar as functions
 *		Nuno Reis (202000753)
 *			Turma: 2�L_EI-SW-08 - sala F155 (12:30h - 16:30h)
 *
 ********************************************/
--Editar Utilizadores
CREATE FUNCTION Sales.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO
SELECT * FROM Sales.ufn_SalesByStore (602);

--Adicionar Utilizadores


--Remover Utilizadores


--Recuperar Password


--Alterar a data de inicio de uma promo��o


--Alterar a data de fim de uma promo��o


--Alterar as datas de inicio e fim de uma promo��o


--Criar uma venda


--Adicionar um produto a uma venda


--Alterar a quantidade de um produto numa venda


--Remover um produto de uma venda (se s� existir esse produto na venda remove a venda)


--Calcular o pre�o total de uma venda

