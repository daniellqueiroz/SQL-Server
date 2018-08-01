SELECT TOP 10000 * 
FROM dbo.MonRealTime
WHERE start_time >= DATEADD(MINUTE,-15,GETDATE())
ORDER BY [Database],session_id

SELECT DISTINCT TOP 100  query,waittype,TM 
FROM dbo.MonRealTime
WHERE 1=1
--and start_time >= DATEADD(MINUTE,-15,GETDATE())
AND start_time >= CONVERT(DATE,GETDATE())
AND tm >= 1000
AND waittype NOT IN ('BROKER_RECEIVE_WAITFOR','SLEEP_TASK')
AND Query NOT IN ('spColecaoParametroProdutoAtualizarAuto')
--ORDER BY tm desc


SELECT TOP 100 * 
FROM dbo.MonRealTime
WHERE 1=1
--and start_time >= DATEADD(MINUTE,-15,GETDATE())
AND Query='EnderecoLojaFisicaListarPorListaLojistas'


SELECT TOP 100 * 
FROM dbo.MonRealTime
WHERE start_time >= DATEADD(MINUTE,-15,GETDATE())
AND TempoTotal > DATEADD(MILLISECOND,tm,CAST('00:00:00.000' AS TIME))
AND waittype='ASYNC_NETWORK_IO'

SELECT TOP 100 * 
FROM dbo.MonRealTime
WHERE start_time >= DATEADD(MINUTE,-15,GETDATE())
AND waittype like 'LCK%'
--ORDER BY 

SELECT * FROM dbo.MonRealTime 
WHERE SnapTime = '2017-11-29 17:00:00.9714823'

