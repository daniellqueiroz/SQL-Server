/*
DROP TABLE dbo.RealTimeASSAIPrim
DROP TABLE dbo.RealTimeATACPrim
DROP TABLE dbo.RealTimeBRPrim
DROP TABLE dbo.RealTimeCDPrim
DROP TABLE dbo.RealTimeNikePrim
DROP TABLE dbo.RealTimeCORPPrim
DROP TABLE dbo.RealTimeCBPrim
DROP TABLE dbo.RealTimeEXPrim
DROP TABLE dbo.RealTimePFPrim
*/
USE Monitoria
GO
INSERT dbo.RealTimeCORPPrim 
(session_id, [Database], Query, statement_text, TM, hostname, Usuario, TempoTotal, wait_time, wait_resource, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock)
SELECT 
session_id, [Database], Query, statement_text, TM, hostname, Usuario, TempoTotal, wait_time, wait_resource, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock
--INTO dbo.RealTimeCORPPrim
FROM OPENQUERY([CORP_PRD.DC.NOVA,1310],'SELECT r.session_id ,DB_NAME(sp.dbid) AS ''Database''
,CASE coalesce(object_name(st.objectid,sp.dbid),''1'') when ''1'' then st.[text] else object_name(st.objectid,sp.dbid) END AS Query 
,SUBSTRING(st.text, (r.statement_start_offset/2)+1 
,((CASE r.statement_end_offset
    WHEN -1 THEN DATALENGTH(st.text)
    ELSE r.statement_end_offset
    END - r.statement_start_offset)/2) + 1) AS statement_text
	,StatsP1.tempo_medioP1 AS TM
	,sp.hostname
	,r.user_id AS ''Usuario''
,CONVERT(TIME,DATEADD (ms, r.total_elapsed_time, 0)) AS TempoTotal,
r.wait_time 
,r.wait_resource
,r.last_wait_type AS waittype
,r.blocking_session_id AS blksid
,r.start_time 
,CASE r.transaction_isolation_level WHEN 1 THEN ''ReadUncomitted'' WHEN 2 THEN ''ReadCommitted'' WHEN 3 THEN ''Repeatable'' WHEN 4 THEN ''serializable'' WHEN 5 THEN ''Snapshot'' END AS IsolamentoVit
,PLANOVITIMA=r.plan_handle 
,CASE rb.transaction_isolation_level WHEN 1 THEN ''ReadUncomitted'' WHEN 2 THEN ''ReadCommitted'' WHEN 3 THEN ''Repeatable'' WHEN 4 THEN ''serializable'' WHEN 5 THEN ''Snapshot'' END AS IsolamentoVilao
,PLANOVILAO=rb.plan_handle 
,case coalesce(object_name(st1.objectid,sb.dbid),''1'') when ''1'' then st1.[text] else object_name(st1.objectid,sb.dbid) END AS QBlock
,sb.loginame ''UserBlock''
,sb.hostname ''hostBlock''
FROM sys.dm_exec_requests r 
INNER JOIN sys.sysprocesses sp ON sp.spid=r.session_id
LEFT JOIN sys.dm_exec_requests rb ON r.blocking_session_id=rb.session_id
LEFT JOIN sys.sysprocesses sb ON sb.spid=rb.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
OUTER APPLY sys.dm_exec_sql_text(rb.sql_handle) AS st1
OUTER APPLY (SELECT tempo_medioP1 = (total_elapsed_time/1000 / execution_count) FROM sys.dm_exec_procedure_stats ps WHERE ps.object_id=st.objectid) AS StatsP1
WHERE 1=1
--AND r.session_id&gt;50
--AND r.database_id=DB_ID()
AND r.session_id<>@@spid
AND (CASE coalesce(object_name(st.objectid),''1'') when ''1'' then LEFT(st.[text],8000) else object_name(st.objectid,sp.dbid) END) != ''sp_cdc_scan''

ORDER BY r.session_id
OPTION(RECOMPILE)
')
GO