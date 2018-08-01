--Execute this to get a detailed view about queries impacting tempdb the most

-- general tempdb consumption
select sum(user_object_reserved_page_count)*8 as usr_obj_kb
,sum(internal_object_reserved_page_count)*8 as internal_obj_kb
,sum(version_store_reserved_page_count)*8 as version_store_kb
,sum(unallocated_extent_page_count)*8 as freespace_kb
,sum(mixed_extent_page_count)*8 as mixedextent_kb
from sys.dm_db_file_space_usage

-- executed in the past
select top 5 ssu.* from sys.dm_db_session_space_usage ssu
order by (user_objects_alloc_page_count + internal_objects_alloc_page_count) desc

-- executing now
SELECT t1.session_id, t1.request_id, t1.task_alloc,
  t1.task_dealloc
  --, object_name(st.objectid)
  ,st.text
  , t2.statement_start_offset, 
  t2.statement_end_offset
  --, qp.query_plan
FROM 
(
	Select session_id, request_id,
	SUM(internal_objects_alloc_page_count) AS task_alloc,
	SUM (internal_objects_dealloc_page_count) AS task_dealloc 
	FROM sys.dm_db_task_space_usage 
	GROUP BY session_id, request_id
) AS t1, 
sys.dm_exec_requests AS t2
CROSS APPLY sys.dm_exec_sql_text(t2.sql_handle) AS st
CROSS apply sys.dm_exec_query_plan (t2.plan_handle) AS qp
WHERE t1.session_id = t2.session_id
AND (t1.request_id = t2.request_id)
and t2.session_id > 50  
and t2.session_id <> @@spid
ORDER BY t1.task_alloc DESC


-- queries longas que podem impedir o armazenamento de versão de ser limpo (monitorar)
-- queries preventing tempdb versioning from being cleaned
SELECT top 5 acsd.transaction_id, acsd.transaction_sequence_num, 
acsd.elapsed_time_seconds , st.text
FROM sys.dm_tran_active_snapshot_database_transactions acsd, sys.dm_exec_requests er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS st
where er.session_id <> @@spid
ORDER BY elapsed_time_seconds DESC

select * FROM sys.dm_tran_active_snapshot_database_transactions

select st.text,t2.* from sys.dm_exec_requests t2 
CROSS APPLY sys.dm_exec_sql_text(t2.sql_handle) AS st
--CROSS apply sys.dm_exec_query_plan (t2.plan_handle) AS qp
where session_id > 50 and total_elapsed_time > 5000
and status = 'running'


-- retrieving tempdb contention
Select --wa.session_id,
se.host_name [Bloqueador],
qs.text [bloqueador],
wa.wait_type,
wa.wait_duration_ms,
wa.blocking_session_id,
wa.resource_description,
      ResourceType = Case
When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 1 % 8088 = 0 Then 'Is PFS Page'
            When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 2 % 511232 = 0 Then 'Is GAM Page'
            When Cast(Right(resource_description, Len(resource_description) - Charindex(':', resource_description, 3)) As Int) - 3 % 511232 = 0 Then 'Is SGAM Page'
            Else 'Is Not PFS, GAM, or SGAM page'
            End
From sys.dm_os_waiting_tasks wa inner join sys.dm_exec_sessions se on wa.session_id=se.session_id
inner join sys.dm_exec_connections co on co.session_id=wa.session_id
cross apply sys.dm_exec_sql_text (co.most_recent_sql_handle) qs
Where wa.wait_type Like 'PAGE%LATCH_%'
And resource_description Like '2:%'


-- capturar queries que fazem mais IO
-- capture IO intensive queries
SELECT top 10 (total_logical_reads/execution_count) as media_leitura_logica,
  (total_logical_writes/execution_count) as media_escrita_logica,
  (total_physical_reads/execution_count) as media_leitura_fisica,
  Execution_count, sql_handle, plan_handle
FROM sys.dm_exec_query_stats  
ORDER BY (total_logical_reads + total_logical_writes) Desc

