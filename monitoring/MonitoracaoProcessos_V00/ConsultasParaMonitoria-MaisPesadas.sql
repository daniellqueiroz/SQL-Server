USE Monitoria
--SELECT TOP 100 percent * FROM dbo.MaisPesadasPF ORDER BY DataHora DESC, query_rank asc
/*
CREATE VIEW TopConsultasMaisPesadas
AS

	SELECT a.DataHora,a.query_rank,a.execution_count,a.DBName,a.text,CONVERT(TIME,DATEADD(ms, a.tempo_medio,0)) TempoMedio,a.[Calls/Second],a.[Calls/Minute]
	,CONVERT(TIME,DATEADD(ms, a.DuracaoDaUltimaChamada,0)) DuracaoDaUltimaChamada,a.last_execution_time
	,a.last_logical_reads,a.last_physical_reads
	,a.plan_handle,a.last_worker_time,a.total_worker_time,a.modify_date 
	FROM (
	SELECT *,'PF-Prim' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasPF ORDER BY DataHora DESC, query_rank ASC) AS b
	UNION 
	SELECT *,'CB-Prim' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasCB ORDER BY DataHora DESC, query_rank ASC) AS c
	UNION
	SELECT *,'EX-Prim' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasEX ORDER BY DataHora DESC, query_rank ASC) AS a
	UNION
	SELECT *,'CORP-Prim' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasCORP ORDER BY DataHora DESC, query_rank ASC) AS d
	UNION
	SELECT *,'B2B2C-Prim' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasB2B2C ORDER BY DataHora DESC, query_rank ASC) AS e
	UNION
	SELECT *,'PF-Sec' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasPFSecundario ORDER BY DataHora DESC, query_rank ASC) AS f
	UNION 
	SELECT *,'CB-Sec' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasCBSecundario ORDER BY DataHora DESC, query_rank ASC) AS g
	UNION
	SELECT *,'EX-Sec' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasEXSecundario ORDER BY DataHora DESC, query_rank ASC) AS h
	UNION
	SELECT *,'CORP-Sec' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasCORPSecundario ORDER BY DataHora DESC, query_rank ASC) AS i
	UNION
	SELECT *,'B2B2C-Sec' AS loja FROM (SELECT TOP 100 percent * FROM dbo.MaisPesadasB2B2CSecundario ORDER BY DataHora DESC, query_rank ASC) AS d
	) AS a 

WHERE 1=1
--and a.tempo_medio > 100
AND text='AjusteDisponibilidadeProduto'
--ORDER BY a.DBName,DataHora DESC,a.query_rank
*/


--SELECT TOP 100 percent * FROM dbo.MaisPesadasCORP WHERE text LIKE '%Monitoria%' ORDER BY DataHora DESC, query_rank ASC


SELECT	 DataHora,query_rank,execution_count,DBName
,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),''),8000)
,TempoMedio,[Calls/Second],[Calls/Minute],DuracaoDaUltimaChamada,last_execution_time,last_logical_reads,last_physical_reads,plan_handle,last_worker_time,total_worker_time,modify_date
FROM dbo.TopConsultasMaisPesadas 
--WHERE text='AjusteDisponibilidadeProduto'
--WHERE last_logical_reads > 1000
ORDER BY DBName,DataHora DESC,query_rank

