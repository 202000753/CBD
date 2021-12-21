Etapa 1
--1)
BEGIN TRANSACTION
UPDATE dbo.Customer
SET EmailAddress = 'new@estsetubal.ips.pt.pt'
WHERE CustomerId = 5

--2)
ROLLBACK

--3)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT ON
GO

BEGIN TRAN

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

WAITFOR DELAY '00:00:10'

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

COMMIT TRAN
-- obs.: se necessário, poderá aumentar o delay para 15 ou 20 segundos

Etapa 2
--1)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET NOCOUNT ON
GO
BEGIN TRAN

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

WAITFOR DELAY '00:00:10'

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

COMMIT TRAN

Etapa 3
--1)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET NOCOUNT ON
GO
BEGIN TRAN

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

WAITFOR DELAY '00:00:10'

SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

COMMIT TRAN