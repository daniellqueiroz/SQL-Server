
declare @OrderBy_Criteria varchar(128),@dbid INT=db_id()
--set @OrderBy_Criteria = 'Logical Reads'
set @OrderBy_Criteria = 'cpu'
--set @OrderBy_Criteria = 'cps'
--set @OrderBy_Criteria = 'execution_count'
--set @OrderBy_Criteria = 'duration'
--set @OrderBy_Criteria = 'Physical Reads'

SELECT  
query_rank,
execution_count
,DBName
,text
,tempo_medio
,[Calls/Second]
,[Calls/Minute]
,DuracaoDaUltimaChamada
,last_execution_time
,last_logical_reads
,last_physical_reads
,plan_handle
--,statement_start_offset
--,statement_end_offset
,last_worker_time
,a.total_worker_time
,modify_date
FROM (
select 
query_rank,
execution_count
,tempo_medio = CONVERT(TIME,DATEADD (ms, (qs.total_elapsed_time/qs.execution_count )/1000, 0)),
 CONVERT(TIME,DATEADD (ms, last_elapsed_time/1000, 0)) AS DuracaoDaUltimaChamada,
last_physical_reads,
last_logical_reads
,last_execution_time
,plan_handle
,[Calls/Second]
,[Calls/Minute]
,statement_start_offset
,statement_end_offset
,last_worker_time
,qs.total_worker_time
,DBName
,text
,modify_date
from 
(
	select s.*, row_number() over(order BY (charted_value) DESC) as query_rank,o.modify_date
	from
	(
		SELECT *,
			CASE @OrderBy_Criteria
				WHEN 'Logical Reads' then total_logical_reads
				WHEN 'Physical Reads' then x.total_physical_reads
				WHEN 'Logical Writes' then total_logical_writes
				WHEN 'CPU' then total_worker_time / 1000
				WHEN 'Duration' then total_elapsed_time / 1000
				WHEN 'CLR Time' then total_clr_time / 1000
				WHEN 'execution_count' then execution_count
				WHEN 'cps' THEN [Calls/Second]
			END as charted_value 
			FROM
			(          
				select sys.dm_exec_query_stats.*
				,DB_NAME(qt.dbid) as DBName
				,CASE WHEN coalesce(object_name(qt.objectid),'1')='1' AND DB_ID()=qt.dbid THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE([text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),''),8000)
					when coalesce(object_name(qt.objectid),'1')!='1' AND DB_ID()=qt.dbid then object_name(qt.objectid)
					else LEFT(REPLACE(REPLACE(REPLACE(REPLACE([text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),''),8000)
				end as text
				,qt.objectid AS oid
				,CAST (execution_count/CASE DATEDIFF(second, creation_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(second, creation_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Second]
				,CAST (execution_count/CASE DATEDIFF(minute, creation_time, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(minute, creation_time, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Minute]

				from sys.dm_exec_query_stats
				outer APPLY sys.dm_exec_sql_text(sys.dm_exec_query_stats.sql_handle) AS	qt
				outer apply sys.dm_exec_query_plan (sys.dm_exec_query_stats.plan_handle) AS qp 
				
				WHERE 1=1
				AND DB_NAME(qt.dbid) NOT IN ('master','model','msdb','perfwh','distribution')
			) AS x
	) as s 
	LEFT OUTER JOIN sys.objects o ON s.oid=o.object_id
	WHERE 1=1
	AND s.charted_value > 0 
		
) as qs

where 1=1
AND query_rank <= 10
--AND text='SkusTodosElegiveisGarantiaAvulsaPorCliente'
) AS a 
WHERE 1=1
ORDER BY a.query_rank  
OPTION(RECOMPILE)

