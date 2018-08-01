SELECT TOP 10  [SP Name] ,execution_count ,[Calls/Second]	 [Calls/Second],[Calls/Minute]	 [Calls/Minute],[Calls/Hour]	 [Calls/Hour],[Calls/dia]		 [Calls/dia]
,avg_elapsed_time_ms 
,TmpUltimaChamada ,last_execution_time,last_logical_reads,last_worker_time ,modify_date,query_plan ,DBCCFreeProcChache ,plan_handle
FROM 
(
	SELECT p.name AS [SP Name]
	,qs.execution_count 
	,CAST (qs.execution_count/CASE DATEDIFF(second, qs.cached_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(second, qs.cached_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Second]
	,CAST (qs.execution_count/CASE DATEDIFF(minute, qs.cached_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(minute, qs.cached_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Minute]
	,CAST (qs.execution_count/CASE DATEDIFF(hour, qs.cached_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(hour, qs.cached_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Hour]
	,CAST (qs.execution_count/CASE DATEDIFF(day, qs.cached_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(day, qs.cached_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/dia]
	--, ((qs.total_elapsed_time/qs.execution_count )/1000) AS [avg_elapsed_time_ms]
	,CONVERT(TIME,DATEADD (ms, (qs.total_elapsed_time/qs.execution_count )/1000, 0)) [avg_elapsed_time_ms]
	,CONVERT(TIME,DATEADD (ms, last_elapsed_time/1000, 0)) AS TmpUltimaChamada
	,last_execution_time
	, qs.cached_time
	,total_worker_time
	,o.modify_date
	,'dbcc freeproccache('+CONVERT(VARCHAR(max),qs.sql_handle,1)+')' AS 'DBCCFreeProcChache'
	,qs.plan_handle
	,plano.query_plan
	,qs.last_logical_reads
	,qs.last_worker_time
	
	FROM sys.procedures AS p WITH (NOLOCK)
	INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK) ON p.[object_id] = qs.[object_id]
	INNER JOIN sys.objects as o WITH (NOLOCK) ON o.OBJECT_ID=p.object_id 
	OUTER APPLY (SELECT * FROM  sys.dm_exec_query_plan(qs.plan_handle)) AS plano
	WHERE qs.database_id = DB_ID()
) AS a

WHERE 1=1
--AND [Calls/Minute]&gt;0 AND [Calls/Second]&gt;0
--AND [SP Name]=''
AND [SP Name] IN ('LogTrocaPagamentoObter','DescontoCompreJuntoSkuListaListar','AtualizaCompraMarketPlacePendenteEnvio','CompraEntregaListarMarketPlacePendenteConversao')
ORDER BY a.total_worker_time DESC OPTION (RECOMPILE);
