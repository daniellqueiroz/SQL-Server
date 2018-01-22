/*
Use this script to see the different offset ranges of the given stored procedure. This can be used to know which exact part of a procedure is performing badly

*/

SELECT  sql_handle ,
        execution_count ,
        total_worker_time ,
        last_elapsed_time ,
        max_elapsed_time ,
        min_elapsed_time
		,min_rows
		,max_rows 
		,plan_handle
		,CAST (qs.execution_count/CASE DATEDIFF(second, qs.creation_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(second, qs.creation_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Second]
		,CAST (qs.execution_count/CASE DATEDIFF(minute, qs.creation_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(minute, qs.creation_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Minute]
		, (qs.total_elapsed_time/qs.execution_count )/1000 AS [avg_elapsed_time_ms]
		,statement_start_offset
		,statement_end_offset
FROM sys.dm_exec_query_stats qs
WHERE CONVERT(VARCHAR(1000),plan_handle,1)='0x0500050018D3DA014021718F040000000000000000000000' --change the plan_handle for the stored procedure here. You can get this handle from sys.dm_exec_requests, sys.sysprocesses or sys.dm_exec_query_stats itself
ORDER BY statement_start_offset asc