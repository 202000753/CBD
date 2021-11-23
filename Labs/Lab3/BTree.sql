/***************************
Mostrar Exemplo de B+ Tree no SQL Server
****************************/
-- Criar tabela em que 1 registo
-- ocupa uma p�gina
Create table TesteIndices (
	id int identity(1,1),
	desc1	char(4000),
	desc2	char(4000),
	num int)
go

-- N�o existem indices
-- A tabela � um Heap
select object_name(object_id) tabela,
		isnull(name, object_name(object_id)) NomeIndice,
		Index_id,
		type_desc
from sys.indexes
where object_name(object_id) ='TesteIndices'
go

-- inser��o de 1 registo
insert into TesteIndices Values (
	'reg1'	,
	'reg1a',
	100 )
go

-- N�o existem indices
-- A tabela � um Heap com 1 registo, uma p�gina e 1 nivel da B+-tree
select object_name(object_id) tabela,
		index_type_desc , -- tipo de ficheiro/indice
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,	-- profundidade da B+-tree
		Index_level,	-- nivel da B+-tree
		record_count,	-- nr de registos no nivel
		page_count		-- nr de paginas no nivel
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go

-- sys.dm_db_index_physical_stats
-- Returns size and fragmentation information for the data and indexes of the specified 
-- table or view. For an index, one row is returned for each level of the B-tree in each 
-- partition. For a heap, one row is returned for the IN_ROW_DATA allocation unit of each partition. 

----------------------------------
----------------------------------
--Ponto 1
----------------------------------
----------------------------------
-- inser��o de 2 registos

insert into TesteIndices Values (
	'reg2'	,
	'reg2a',
	200 )
go
insert into TesteIndices Values (
	'reg3'	,
	'reg3a',
	300 )
go


-- verificar estado do indice
-- A tabela � um Heap com 3 registo, 3 p�ginas e 1 nivel da B+-tree
select object_name(object_id) tabela,
		index_type_desc ,
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,
		Index_level,
		record_count,
		page_count
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go
----------------------------------
----------------------------------
--Ponto 2
----------------------------------
----------------------------------

-- inser��o de 100 registos
insert into TesteIndices Values (
	'reg100'	,
	'reg100a',
	100000 )
go 100

-- verificar estado do indice
-- Nivel 0: 103 registos, 103 p�ginas
select object_name(object_id) tabela,
		index_type_desc ,
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,
		Index_level,
		record_count,
		page_count
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go

-- cria��o de um �ndice clustered
create clustered index IC_TesteIndices on TesteIndices (id)
go

-- verificar estado do indice
select object_name(object_id) tabela,
		index_type_desc ,
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,
		Index_level,
		record_count,
		page_count
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go
----------------------------------
----------------------------------
--Ponto 3
----------------------------------
----------------------------------

-- inser��o de 700 registos
insert into TesteIndices Values (
	'reg700'	,
	'reg700a',
	700000 )
go 700

-- verificar estado do indice

select object_name(object_id) tabela,
		index_type_desc ,
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,
		Index_level,
		record_count,
		page_count
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go

-- Verifica��o das estatisticas dos indices
-- Tamanho da chave, valores distintos
dbcc show_statistics ('TesteIndices',IC_TesteIndices)
go

-- cria��o de um �ndice n�oclustered
create nonclustered index INC_TesteIndices on TesteIndices (num)
go

-- verificar estado do indice
-- Existe na tabela um indice nonclustered com  2 niveis da B+-tree:
-- Nivel 0: 803 registos, 2 p�ginas (803 * (4+8)bytes= 9.636 bytes) 
-- Nivel 1: 2 registos, 1 p�gina 
select object_name(object_id) tabela,
		index_type_desc ,
		alloc_unit_type_desc as data_type, -- registo cabe na p�gina?
		Index_id,
		Index_depth,
		Index_level,
		record_count,
		page_count
		--,fragment_count
from sys.dm_db_index_physical_stats(db_id(),object_id('TesteIndices'), NULL, NULL , 'DETAILED')
go

--//////////////////////////////////////
-- Verifica��o das estatisticas do indice criado
-- Tamanho da chave (8 bytes: num, id), valores distintos
dbcc show_statistics ('TesteIndices',INC_TesteIndices)
go