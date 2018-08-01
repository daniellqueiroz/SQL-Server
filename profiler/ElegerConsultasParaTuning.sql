DECLARE @trace VARCHAR(100)='h:\ce.trc'

/*
------------------------------------------------------------------------------
-- pegar todos os registros sem filtro
SELECT	textdata,duration/1000 AS DuracaoEmMS,cpu,reads,writes,databaseName, ROW_NUMBER() OVER(ORDER BY duration/1000 desc) AS rownum
FROM fn_trace_gettable('h:\v37.trc', 1) 
WHERE 2=2
AND CONVERT(VARCHAR(max),TextData) != N'exec spCategoriaListarMenuDepartamentos '
---AND Duration/1000 >= 100
--AND ObjectName = 'DescontoListarComFormaPagamento'
AND spid != @@spid
ORDER BY rownum 
*/
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- pegar as médias de duração por objeto
SELECT * FROM (
SELECT AVG( CAST((duration/1000) AS decimal(19,2)) ) AS TempoMedio,COUNT(*) AS QtdChamadas,ObjectName,DatabaseName
,'select * from (SELECT '' USE ''+ DATABASENAME +''; begin tran ''+CONVERT(VARCHAR(MAX),textdata) + '' rollback '' + char(10)+char(13) + ''GO'' as texto,duration/1000 AS DuracaoEmMS,cpu,reads,writes,databaseName, ROW_NUMBER() OVER(partition by DatabaseName ORDER BY duration/1000 desc) AS rownum,ROW_NUMBER() OVER (PARTITION BY DatabaseName ORDER BY StartTime ASC) AS ordemExecucao FROM fn_trace_gettable('''+@trace+''', 1) WHERE 2=2 /*AND Duration/1000 >= 100*/ AND ObjectName = '''+ObjectName+''' AND spid != @@spid) as a where rownum=1' AS query
,ROW_NUMBER() OVER(partition by ObjectName ORDER BY AVG( CAST((duration/1000) AS decimal(19,2)) ) desc) AS rownum
FROM fn_trace_gettable(@trace, 1) 
WHERE 2=2 and objectname is NOT NULL AND objectname !='sp_executesql'
GROUP BY ObjectName ,DatabaseName
--HAVING AVG( CAST((duration/1000) AS decimal(19,2)) ) > 100
--ORDER BY AVG( CAST((duration/1000) AS decimal(19,2)) ) DESC
--ORDER BY QtdChamadas desc
) AS a WHERE rownum=1
ORDER BY TempoMedio DESC
------------------------------------------------------------------------------
/*
SELECT * FROM sys.traces
*/


