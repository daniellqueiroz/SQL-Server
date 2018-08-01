SELECT TOP 50 usecounts, cacheobjtype, objtype, [text]
,tempo_medio = (qs.total_elapsed_time/1000 / qs.execution_count)
FROM sys.dm_exec_cached_plans P
JOIN sys.dm_exec_query_stats qs 
ON qs.plan_handle = p.plan_handle
CROSS APPLY sys.dm_exec_sql_text (p.plan_handle)
WHERE cacheobjtype = 'Compiled Plan'
--AND objtype NOT IN ('proc','Trigger')
AND objtype='Prepared'
AND [text] NOT LIKE '%dm_exec_cached_plans%'
AND usecounts>50000
ORDER BY qs.total_worker_time DESC