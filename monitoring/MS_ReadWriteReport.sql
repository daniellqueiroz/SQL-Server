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
AND object_name(s.object_id)='CLUSTER'
--AND object_name(s.object_id) IN ('produto','sku')
GROUP BY object_name(s.object_id)
HAVING SUM(user_seeks + user_scans + user_lookups) <>0
ORDER BY PctEscrita DESC