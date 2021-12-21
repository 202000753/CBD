Etapa 1
--1)
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

--2)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
GO
SELECT EmailAddress
FROM dbo.Customer
WHERE CustomerId = 5

SELECT EmailAddress
FROM dbo.Customer (NOLOCK)
WHERE CustomerId = 5

--3)
BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'new@estsetubal.ips.pt.pt'
WHERE CustomerId = 5
COMMIT

Etapa 2
--1)
BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'aaaaaaa@aaaaa.aaaaaaaa'
WHERE CustomerId = 5
COMMIT

Etapa 3
--1)
BEGIN TRAN
UPDATE dbo.Customer
SET EmailAddress = 'new@estsetubal.ips.pt.pt'
WHERE CustomerId = 5
COMMIT