--Colunas
--Information_Schema
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME,  COLUMN_NAME, COLUMN_DEFAULT
FROM AdventureWorksLT2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'Product';SELECT TABLE_CATALOG, TABLE_SCHEMA, 
TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'Product';

--Sys Schema
select s.name as 'SchemaName' , o.name as 'TableName' , c.name as 'ColumnName'
from sys.schemas as s
inner join sys.all_objects as o
on s.schema_id = o.schema_id
inner join sys.all_columns as c
on c.object_id = o.object_id
where o.name like N'Product' and o.type = 'U'
order by SchemaName,TableName,ColumnName;-- ObjetosSELECT *
FROM sys.all_objects;SELECT
distinct ot.type, ot.type_desc
FROM sys.all_objects ot;

--Exercicio
--A
select * from INFORMATION_SCHEMA.TABLES;
--B
select * from INFORMATION_SCHEMA.TABLES t
where t.TABLE_TYPE=upper('base table');
--C
select * from sys.tables;

--D
select count(*)
from sys.tables t ;
--E
select c.TABLE_NAME, count(c.COLUMN_NAME)
from INFORMATION_SCHEMA.COLUMNS c 
join INFORMATION_SCHEMA.TABLES t
on t.TABLE_NAME=c.TABLE_NAME 
where t.TABLE_TYPE='base table'
group by c.TABLE_NAME;
--F
select t.name, count(*)
from sys.all_columns as c 
inner join sys.tables t 
on c.object_id=t.object_id
group by t.name;

--sps
SELECT name
FROM sys.all_objects
WHERE type = 'U';

EXEC sp_tables;

EXEC sp_columns 'customer';

--functions
SELECT DB_NAME();

SELECT DB_ID(N'AdventureWorksLT2019');

SELECT DB_NAME(database_id)
FROM sys.databases
WHERE database_id = DB_ID();

SELECT OBJECT_ID(N'SalesLT.Product');SELECT OBJECT_NAME(OBJECT_ID(N'SalesLT.Product'));SELECT OBJECT_NAME(c.object_id)
FROM sys.columns c
join sys.tables t
on t.object_id=c.object_id
WHERE c.is_nullable = 1 
GROUP BY c.object_id;--ExemploSELECT name, column_id
FROM sys.columns
WHERE object_id = OBJECT_ID(N'SalesLT.ProductModel');SELECT c.COLUMN_NAME, c.ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME='ProductModel';

SELECT name, max_column_id_used as 'Numero de colunas'
FROM sys.tables st
WHERE schema_id = SCHEMA_ID(N'SalesLT');

SELECT st.name, count(sc.name) as 'Numero de colunas'
FROM sys.columns sc
join sys.tables st
on sc.object_id=st.object_id
WHERE st.schema_id= schema_ID(N'SalesLT')
GROUP BY st.name;SELECT ct.TABLE_NAME, COUNT(*) as 'Numero de colunas'
FROM INFORMATION_SCHEMA.COLUMNS ct
WHERE ct.TABLE_SCHEMA = 'SalesLT'
group by ct.TABLE_NAME;

SELECT ct.TABLE_NAME, COUNT(*) as 'Numero de colunas'
FROM INFORMATION_SCHEMA.COLUMNS ct
WHERE ct.TABLE_SCHEMA = 'SalesLT' AND
ct.TABLE_NAME not in (
					 SELECT v.TABLE_NAME
					 FROM INFORMATION_SCHEMA.VIEWS v
					 )
group by ct.TABLE_NAME;

SELECT col.table_name, COUNT(col.column_name) 'Numero de colunas'
FROM information_schema.columns col
JOIN information_schema.tables tbl
ON tbl.table_name = col.table_name
AND tbl.table_schema = col.table_schema
AND tbl.table_catalog = col.table_catalog
AND tbl.table_type <> 'VIEW'
WHERE tbl.TABLE_SCHEMA = 'Person'
GROUP BY col.table_name
--Exercicio
--A
exec sp_tables;

--B
select schema_name(t.schema_id), t.name,
t.type_desc
from sys.tables t;

--C
select *
from INFORMATION_SCHEMA.TABLES;

SELECT isv.TABLE_NAME, isv.VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS isv
where isv.TABLE_NAME in
						(
						SELECT
						OBJECT_NAME(sv.object_id)
						FROM sys.views sv
						where sv.is_replicated = 0 
						);

SELECT OBJECTPROPERTY(OBJECT_ID(N'SalesLT.Product'),'HasDeleteTrigger');
SELECT OBJECTPROPERTY(OBJECT_ID(N'SalesLT.Customer'),'IsUserTable');
SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.uspLogError'));

SELECT name, object_id, type_desc
FROM sys.all_objects
WHERE OBJECTPROPERTY(object_id, N'SchemaId') = SCHEMA_ID(N'SalesLT')
AND OBJECTPROPERTY(object_id, N'ISTABLE')=1
ORDER BY type_desc, name;SELECT name, is_nullable
FROM sys.columns sc
WHERE object_id = OBJECT_ID(N'SalesLT.Product')
and is_nullable =1;SELECT name ColumnName, TYPE_NAME(system_type_id) SystemType
FROM sys.columns
WHERE object_id = OBJECT_ID(N'SalesLT.Customer');SELECT DISTINCT Constraint_Name AS [Constraint], Table_Schema AS [Schema], Table_Name AS [TableName]
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME='Product';

SELECT OBJECT_NAME(OBJECT_ID) AS NameofConstraint, SCHEMA_NAME(schema_id) AS SchemaName, OBJECT_NAME(parent_object_id) AS TableName, type_desc AS ConstraintType
FROM sys.objects
WHERE type_desc IN ('FOREIGN_KEY_CONSTRAINT','PRIMARY_KEY_CONSTRAINT')
AND OBJECT_NAME(parent_object_id)='Product';SELECT object_name(parent_object_id) Origem, object_name(referenced_object_id) Referenciado, name
FROM sys.foreign_keys
WHERE parent_object_id = object_id('SalesLT.Product');

SELECT c.name 'Column Name', t.Name 'Data type', c.max_length 'Max Length', c.precision , c.scale , c.is_nullable, ISNULL(i.is_primary_key, 0) 'Primary Key'
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN sys.index_columns ic
ON ic.object_id = c.object_id
AND ic.column_id = c.column_id
LEFT OUTER JOIN sys.indexes i 
ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE c.object_id = OBJECT_ID('SalesLT.Customer');