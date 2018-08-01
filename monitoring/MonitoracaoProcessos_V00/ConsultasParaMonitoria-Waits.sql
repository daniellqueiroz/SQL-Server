use Monitoria
go
SELECT Banco,DataHora,session_id,last_wait_type,Query,TempoTotal,
CONVERT(TIME,DATEADD (ms, tempo_medioP1, 0)) AS tempo_medioP1,wait_time,hostname,Usuario,start_time,cpu_time,status
,reads,writes,logical_reads,[Memoria(KB)],command,blocking_session_id
,IsolamentoVit,PLANOVITIMA,IsolamentoVilao,PLANOVILAO,QBlock,BLKlogin,BLKhost
,statement_text
FROM dbo.[MonRealTime] 
WHERE query NOT LIKE '%sp_jobhistory%' 
--AND Banco LIKE 'Ex%'
--AND loginame ='srv_corp_fichaprodutomktp'
--AND wait_type LIKE 'LCK%'
--and query LIKE '%atualizacao%'
AND DataHora >= DATEADD(HOUR,6,CONVERT(DATETIME2(0),CONVERT(DATE,GETDATE())))
--DATEADD(HOUR,-3,GETDATE())
AND tempototal > '00:00:01.000'
--AND Query NOT in 'fn_cdc_map_time_to_lsn'
ORDER BY DataHora DESC,cpu_time desc


/*
-- Para esperas durante a madrugada, rode o comando abaixo
SELECT * FROM dbo.[MonRealTime] 
WHERE query NOT LIKE '%sp_jobhistory%' 
--AND Banco LIKE 'Ex%'
--AND loginame ='srv_corp_fichaprodutomktp'
--AND wait_type LIKE 'LCK%'
--and query LIKE 'SkuAlteracaoLimparExecutados'
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora < DATEADD(HOUR,6,CONVERT(DATETIME2(0),CONVERT(DATE,GETDATE())))
--DATEADD(HOUR,-3,GETDATE())
AND CONVERT(TIME,DataHora) BETWEEN '00:00:00' AND '00:06:00'
ORDER BY DataHora DESC,banco

-- Para esperas durante outro perído qualquer, rode o comando abaixo
SELECT Banco,DataHora,session_id,last_wait_type,Query,TempoTotal,tempo_medioP1,wait_time,hostname,Usuario,start_time,cpu_time,status
,reads,writes,logical_reads,[Memoria(KB)],command,blocking_session_id
,IsolamentoVit,PLANOVITIMA,IsolamentoVilao,PLANOVILAO,QBlock,BLKlogin,BLKhost
,statement_text
FROM dbo.[MonRealTime] 
WHERE query NOT LIKE '%sp_jobhistory%' 
--AND Banco LIKE 'Ex%'
--AND loginame ='srv_corp_fichaprodutomktp'
--AND wait_type LIKE 'LCK%'
--and query LIKE 'SkuAlteracaoLimparExecutados'
AND DataHora >= DATEADD(day,-7,GETDATE())
--DATEADD(HOUR,-3,GETDATE())
ORDER BY DataHora DESC,banco

*/
/*
SELECT DataHora,session_id,wait_duration_ms,wait_type,CONVERT(TIME,DATEADD(ms,TempoMedio ,0)) AS TempoMedio
,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4
--FROM dbo.WaitsCorpPrimario 
FROM dbo.WaitsCBPrimario 
--FROM dbo.WaitsExPrimario 
--FROM dbo.WaitsPFPrimario 
--FROM dbo.WaitsB2B2CPrimario 
--FROM dbo.WaitsPFSecundario
--FROM dbo.WaitsCBSecundario
--FROM dbo.WaitsEXSecundario
--FROM dbo.WaitsCORPSecundario
--FROM dbo.WaitsB2B2CSecundario
WHERE 1=1
--and DataHora >= CONVERT(DATE,GETDATE())
and DataHora < CONVERT(DATE,GETDATE())
AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
--AND DataHora >= '2016-08-11 02:00:00'
AND CONTAINS((Query,Query2,Query3,Query4), '"*SkuLojistaListar*"')
--AND Query LIKE '%THOR_CompraExtrair%'
AND Query NOT LIKE 'sp_cdc_scan'
--AND wait_duration_ms > 1000
and query NOT LIKE '%sp_jobhistory%' 
--AND CONVERT(TIME,DataHora) BETWEEN '00:00:00' AND '00:06:00'
ORDER BY DataHora DESC
*/

/*

--- WAITS QUE NÃO SÃO LOCKS

SELECT wait_type,Query,COUNT(*)
FROM dbo.WaitsCBPrimario 
WHERE 1=1
AND TempoMedio>1000
AND wait_type NOT LIKE 'LCK%'
AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
--AND DataHora >= CONVERT(DATE,GETDATE())
AND NOT CONTAINS((Query,Query2,Query3,Query4), 'TrInserUpdateFlagERP')
GROUP BY wait_type,Query
--ORDER BY DataHora desc


------------------ LOCKS

SELECT last_wait_type,Query,QBlock,COUNT(*)
FROM dbo.[MonRealTime] 
WHERE last_wait_type LIKE 'LCK%'
AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora >= '2016-08-11 02:00:00'
--AND Query NOT LIKE '%sp_jobhistory_row_limiter%'
--AND NOT CONTAINS((Query,Query2,Query3,Query4), 'TrInserUpdateFlagERP')
--AND CONTAINS((Query,Query2,Query3,Query4), 'TrInserUpdateFlagERP')
AND wait_time > 1000
GROUP BY last_wait_type,Query,QBlock--,Query3,Query4

SELECT wait_type,Query,Query2,Query3,Query4,COUNT(*)
FROM dbo.WaitsEXPrimario 
WHERE wait_type LIKE 'LCK%'
--AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
AND DataHora >= '2016-08-11 02:00:00'
AND Query NOT LIKE '%sp_jobhistory_row_limiter%'
AND CONTAINS((Query,Query2,Query3,Query4), 'ListarProdutoParceiro')
GROUP BY wait_type,Query,Query2,Query3,Query4

SELECT wait_type,Query,Query2,Query3,Query4,COUNT(*)
FROM dbo.WaitsPFPrimario
WHERE wait_type LIKE 'LCK%'
--AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
AND DataHora >= '2016-08-11 02:00:00'
AND Query NOT LIKE '%sp_jobhistory_row_limiter%'
AND CONTAINS((Query,Query2,Query3,Query4), 'ListarProdutoParceiro')
GROUP BY wait_type,Query,Query2,Query3,Query4

SELECT wait_type,Query,Query2,Query3,Query4,COUNT(*)
FROM dbo.WaitsCorpPrimario 
WHERE wait_type LIKE 'LCK%'
AND DataHora >= DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))
AND Query NOT LIKE '%sp_jobhistory_row_limiter%'
--AND wait_duration_ms > 20000
--AND CONTAINS((Query,Query2,Query3,Query4), 'ListarProdutoParceiro')
GROUP BY wait_type,Query,Query2,Query3,Query4
--ORDER BY DataHora DESC


*/