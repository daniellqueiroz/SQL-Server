SELECT r.session_id 
	   ,CASE coalesce(object_name(st.objectid),'1') when '1' then LEFT(REPLACE(REPLACE(REPLACE(REPLACE(st.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),''),8000) else object_name(st.objectid) END AS Query 
	   ,SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
        ((CASE r.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE r.statement_end_offset
         END - r.statement_start_offset)/2) + 1) AS statement_text
       ,r.start_time ,
	   r.cpu_time ,
       r.total_elapsed_time ,
       r.status ,
	   r.wait_type ,
       r.wait_time ,
       r.last_wait_type ,
	   r.wait_resource ,
	   r.blocking_session_id
	   ,case coalesce(object_name(st1.objectid),'1') when '1' then LEFT(REPLACE(REPLACE(REPLACE(REPLACE(st1.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),''),8000) else object_name(st1.objectid) END AS QBlock,
	   r.reads ,
       r.writes ,
       r.logical_reads ,
	   8*r.granted_query_memory AS [Memoria(KB)],
	   r.command ,
       r.statement_start_offset ,
       r.statement_end_offset ,
       r.plan_handle ,
       r.context_info ,
       r.percent_complete ,
       r.lock_timeout ,
       r.row_count 
	   ,CASE r.transaction_isolation_level WHEN 1 THEN 'ReadUncomitted' WHEN 2 THEN 'ReadCommitted' WHEN 3 THEN 'Repeatable' WHEN 4 THEN 'serializable' WHEN 5 THEN 'Snapshot' END AS Isolamento
       FROM sys.dm_exec_requests r 
	   LEFT JOIN sys.dm_exec_requests rb ON r.blocking_session_id=rb.session_id
	   CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
	   OUTER APPLY sys.dm_exec_sql_text(rb.sql_handle) AS st1
	   WHERE 1=1
	   AND r.session_id>50
	   AND r.database_id=DB_ID()
	   AND r.session_id<>@@spid
	   OPTION(RECOMPILE)
	   
