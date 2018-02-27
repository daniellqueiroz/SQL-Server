-- pegar todos os registros sem filtro
SELECT	textdata,duration/1000,cpu,reads,writes,hostname,applicationname,loginname,databaseName, ROW_NUMBER() OVER(ORDER BY objectname) AS rownum
FROM fn_trace_gettable('D:\mytrace.trc', 1) 
WHERE 2=2
AND CONVERT(VARCHAR(max),TextData) != N'exec spCategoriaListarMenuDepartamentos '
AND HostName != 'valencia01'
---AND Duration/1000 >= 100
--AND ObjectName = 'DescontoListarComFormaPagamento'
ORDER BY rownum

-- pegar as médias de duração por objeto
SELECT	AVG( CAST((duration/1000) AS decimal(19,2)) ) AS DuracaoMedia,COUNT(*) AS QtdChamadas,ObjectName,DatabaseName
FROM fn_trace_gettable('D:\mytrace.trc', 1) 
WHERE 2=2
AND ObjectName = 'spObterSkuTabelaValorVigente'
GROUP BY ObjectName, DatabaseName
HAVING AVG( CAST((duration/1000) AS decimal(19,2)) ) > 100


-- pegar todas as chamadas cujas médias de duração são maiores que 100ms
SELECT	textdata,duration/1000,cpu,reads,writes,hostname,applicationname,loginname,databaseName, ROW_NUMBER() OVER(ORDER BY objectname) AS rownum
FROM fn_trace_gettable('D:\mytrace.trc', 1) 
WHERE 2=2
AND CONVERT(VARCHAR(max),TextData) != N'exec spCategoriaListarMenuDepartamentos '
AND HostName != 'valencia01'
AND Duration/1000 >= 100
ORDER BY rownum


-- pegar médias de duração, quantidade de chamadas por diferentes ocorrencias do mesmo objeto
SELECT	AVG( CAST((duration/1000) AS decimal(19,2)) ) AS DuracaoMedia, count(*) AS QtdChamadas, objectname
,DatabaseName
,CONVERT(VARCHAR(max),TextData)
FROM fn_trace_gettable('D:\mytrace.trc', 1) 
WHERE 2=2
AND CONVERT(VARCHAR(max),TextData) != N'exec spCategoriaListarMenuDepartamentos '
AND HostName != 'valencia01'
---AND Duration/1000 >= 100
--AND ObjectName = 'spListaDeCompraListar'
AND objectname IS NOT NULL
--AND DB_ID(DatabaseName) > 4
AND ObjectName != 'sp_executesql'
group by objectname
,DatabaseName
,CONVERT(VARCHAR(max),TextData)
having AVG( CAST((duration/1000) AS decimal(19,2)) ) > 100





SELECT
    e.name AS Event_Name, ei.eventid
    ,c.name AS Column_Name, ei.columnid
FROM fn_trace_geteventinfo(2) ei
JOIN sys.trace_events e ON ei.eventid = e.trace_event_id
JOIN sys.trace_columns c ON ei.columnid = c.trace_column_id
ORDER BY eventid,columnid;


SELECT	textdata,duration/1000,cpu,reads,writes,hostname,applicationname,loginname,databaseName, ROW_NUMBER() OVER(ORDER BY objectname) AS rownum
FROM fn_trace_gettable('D:\mytrace.trc', 1) 
WHERE 2=2
AND HostName = 'valencia01'

SELECT * FROM sys.traces