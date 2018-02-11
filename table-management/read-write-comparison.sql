-- run this statement to get an overview of the amount of writes and reads
SELECT TableName = OBJECT_NAME(s.object_id),
       Reads = SUM(user_seeks + user_scans + user_lookups)
       , Writes =  SUM(user_updates)
       , CONVERT(NUMERIC(18, 5),(SUM(CONVERT(NUMERIC(18, 5),user_updates))/(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))+SUM(CONVERT(NUMERIC(18, 5),user_updates)))*100)) AS PctEscrita
       , CONVERT(NUMERIC(18, 5),(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))/(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))+SUM(CONVERT(NUMERIC(18, 5),user_updates)))*100)) AS PctLeitura
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i
ON s.object_id = i.object_id
AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.object_id,'IsUserTable') = 1
AND s.database_id = DB_ID()
--AND object_name(s.object_id) IN ('produto','sku')
GROUP BY OBJECT_NAME(s.object_id)
HAVING SUM(user_seeks + user_scans + user_lookups) <>0
ORDER BY PctEscrita DESC


-- index statistics analysis
-- índices inúteis (sem atualização)
SELECT si.name, OBJECT_NAME(si.object_id), [user_lookups], [user_scans], [user_seeks], [user_updates], [last_user_update] 
,'if exists(select 1 from sys.indexes where name = '''+name+''') drop index ' + si.name + ' on ' + OBJECT_NAME(si.object_id)
FROM sys.dm_db_index_usage_stats, sys.indexes si WHERE database_id = DB_ID()
--and ((user_seeks = 0 AND user_scans > user_updates) OR (user_seeks < user_scans AND user_scans > user_updates))
AND sys.dm_db_index_usage_stats.index_id = si.index_id
AND sys.dm_db_index_usage_stats.object_id = si.object_id
--AND is_primary_key = 0
AND OBJECT_NAME(si.object_id) NOT LIKE 'fulltext_index_map%'
--AND user_updates < 5000
AND OBJECTPROPERTY(si.[object_id],'IsUserTable') = 1 
--AND si.name = 'IX_FK_Carrinho_FreteEntregaTipo'
AND OBJECT_NAME(si.object_id) = 'ColecaoParametroProduto'
ORDER BY [user_updates] DESC, si.[name] DESC 

-- checking procedure cache for index usage
-- Pesquisar no plano de Procs
SELECT TOP(25) p.name AS [SP Name], qs.total_worker_time AS [TotalWorkerTime], 
qs.total_worker_time/qs.execution_count AS [AvgWorkerTime], qs.execution_count, 
ISNULL(qs.execution_count/DATEDIFF(SECOND, qs.cached_time, GETDATE()), 0) AS [Calls/Second],
qs.total_elapsed_time, (qs.total_elapsed_time/qs.execution_count )/1000
AS [avg_elapsed_time], qs.cached_time
,'dbcc freeproccache('+CONVERT(VARCHAR(MAX),qs.sql_handle,1)+')'
--,qp.query_plan
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
ON p.[object_id] = qs.[object_id]
INNER JOIN sys.syscomments sc ON p.object_id=sc.id
OUTER APPLY sys.dm_exec_query_plan (plan_handle) AS qp
WHERE qs.database_id = DB_ID()
--AND p.name='ajustedisponibilidadeproduto'
AND sc.text LIKE '%skuservico%'
AND CAST(qp.query_plan AS NVARCHAR(MAX)) LIKE '%IX_SkuServico_IdSkuServicoTipoIdSkuIdSkuServico%'
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);

-- checking ad-hoc cache for index usage
-- Pesquisar no plano de Ad Hoc
SELECT TOP 1000 usecounts, cacheobjtype, objtype
, [text]
,qp.query_plan
FROM sys.dm_exec_cached_plans P
OUTER APPLY sys.dm_exec_sql_text (plan_handle)
OUTER APPLY sys.dm_exec_query_plan (plan_handle) AS qp
WHERE cacheobjtype = 'Compiled Plan'
AND [text] LIKE '%skuservico%'
AND [text] NOT LIKE '%dm_exec_cached_plans%'
AND objtype='Adhoc'
AND usecounts>50
AND CAST(qp.query_plan AS NVARCHAR(MAX)) LIKE '%IX_t4b%'




-- tables with no read operation
-- Tabelas sem Read
SELECT TableName = object_name(s.object_id),
       Reads = SUM(user_seeks + user_scans + user_lookups)
       , Writes =  SUM(user_updates)
       --, CONVERT(NUMERIC(18, 5),(SUM(CONVERT(NUMERIC(18, 5),user_updates))/SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))))
       
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i
ON s.object_id = i.object_id
AND i.index_id = s.index_id
WHERE objectproperty(s.object_id,'IsUserTable') = 1
AND s.database_id = DB_ID()
--AND object_name(s.object_id)='skuservico'
GROUP BY object_name(s.object_id)
HAVING SUM(user_seeks + user_scans + user_lookups)=0
ORDER BY writes DESC


-- tables with more write operations than read operations
-- Tabelas com mais Write do que Read
SELECT TableName = object_name(s.object_id),
       Reads = SUM(user_seeks + user_scans + user_lookups)
       , Writes =  SUM(user_updates)
       , CONVERT(NUMERIC(18, 5),(SUM(CONVERT(NUMERIC(18, 5),user_updates))/(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))+SUM(CONVERT(NUMERIC(18, 5),user_updates)))*100)) AS PctEscrita
       , CONVERT(NUMERIC(18, 5),(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))/(SUM(CONVERT(NUMERIC(18, 5),user_seeks) + CONVERT(NUMERIC(18, 5),user_scans) + CONVERT(NUMERIC(18, 5),user_lookups))+SUM(CONVERT(NUMERIC(18, 5),user_updates)))*100)) AS PctLeitura
FROM sys.dm_db_index_usage_stats AS s
INNER JOIN sys.indexes AS i
ON s.object_id = i.object_id
AND i.index_id = s.index_id
WHERE objectproperty(s.object_id,'IsUserTable') = 1
AND s.database_id = DB_ID()
--AND object_name(s.object_id)='skuservico'
GROUP BY object_name(s.object_id)
HAVING SUM(user_seeks + user_scans + user_lookups)<SUM(CONVERT(NUMERIC(18, 5),user_updates))
ORDER BY writes DESC,pctescrita DESC
