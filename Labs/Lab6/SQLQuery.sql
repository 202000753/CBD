select p.ProductID, p.Name, pc.Name
from SalesLT.Product p
join SalesLT.ProductCategory pc
on p.ProductCategoryID=pc.ProductCategoryID;

select c.EmailAddress, a.CountryRegion
from SalesLT.Customer c
join SalesLT.CustomerAddress ca
on c.CustomerID=ca.CustomerID
join SalesLT.Address a
on ca.AddressID=a.AddressID
order by c.CustomerID

join SalesLT.Address a
on ca.AddressID=a.AddressID

select CountryRegion
from SalesLT.Address
 
select CustomerID, EmailAddress
from SalesLT.Customer
order by CustomerID

select *
from SalesLT.CustomerAddress

DECLARE @vid TABLE(a INT, b VARCHAR(40), c VARCHAR(40))
DECLARE @querytextNoVid VARCHAR(100)
DECLARE @querytext TABLE(a INT, b VARCHAR(40), c VARCHAR(40))
DECLARE @filelocation VARCHAR(100)
DECLARE @cmd VARCHAR(255)

DECLARE vid_cursor CURSOR FOR select p.ProductID, p.Name, pc.Name
								from SalesLT.Product p
								join SalesLT.ProductCategory pc
								on p.ProductCategoryID=pc.ProductCategoryID
OPEN vid_cursor
FETCH NEXT FROM vid_cursor INTO @vid


WHILE @@FETCH_STATUS = 0
BEGIN

    SET @querytext = @vid
    SET @filelocation = '"c:\out_vid.dat"'
    SET @cmd = 'bcp ' + @querytext + ' queryout ' + @filelocation + ' -T -c'
    EXEC master..XP_CMDSHELL @cmd

    FETCH NEXT FROM vid_cursor INTO @vid
END
CLOSE vid_cursor
DEALLOCATE vid_cursor