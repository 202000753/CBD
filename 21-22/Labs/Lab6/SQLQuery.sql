select p.ProductID, p.Name, pc.Name
from SalesLT.Product p
join SalesLT.ProductCategory pc
on p.ProductCategoryID=pc.ProductCategoryID;

select top 1 1 as CustomerID, 'email' as email, 'country' as country from SalesLT.Customer c  
union 
select c.CustomerID, c.EmailAddress, a.CountryRegion
from SalesLT.Customer c
join SalesLT.CustomerAddress ca
on c.CustomerID=ca.CustomerID
join SalesLT.Address a
on ca.AddressID=a.AddressID
order by CustomerID ASC
