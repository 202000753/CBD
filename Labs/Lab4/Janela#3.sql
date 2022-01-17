Etapa 4
--1)
SELECT -- use * to explore
 request_session_id AS spid,
 resource_type AS restype,
 resource_database_id AS dbid,
 resource_description AS res,
 resource_associated_entity_id AS resid,
 request_mode AS mode,
 request_status AS status
FROM sys.dm_tran_locks;

--2)
SELECT *
 /*session_id AS spid,
 blocking_session_id,
 command,
 sql_handle,
 database_id,
 wait_type,
 wait_time,
 wait_resource*/
FROM sys.dm_exec_requests
--WHERE blocking_session_id > 0;

--3)
SELECT session_id, text
FROM sys.dm_exec_connections
 CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST
WHERE session_id IN (51, 70);