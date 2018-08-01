--PROCEDURE TO ALERT IN CASE THE CPU LOAD GOES ABOVE THE SPECIFIED THRESHOLD

USE master
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].CheckCPU') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].CheckCPU AS' 
END
GO
ALTER PROCEDURE dbo.CheckCPU
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL ON;

	DECLARE @Destinatarios VARCHAR(500);    
	DECLARE @Assunto VARCHAR(500);    
	DECLARE @Profile VARCHAR(100);    
	DECLARE @idSkuServicoTipo INT    
	DECLARE @Loja VARCHAR(100);    

	if object_id('tempdb..#temp') is not null
		drop table #temp;
	   
	SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile);    
	--SET @Destinatarios = 'CANPARDatabaseAdministratorsStaffList@canpar.com'    
	SET @Destinatarios = 'rleandro@canpar.com'    
	SET @Assunto = 'High CPU Load alert! Check the server ' + @@SERVERNAME + ' for heavy processes.' 

	DECLARE @ts_now BIGINT
	SELECT @ts_now = cpu_ticks / CONVERT(FLOAT, ms_ticks) FROM sys.dm_os_sys_info

	SELECT TOP 1 record_id,
		SQLProcessUtilization,
		SystemIdle,
		100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
		INTO #temp
	FROM (
		SELECT 
			record.value('(./Record/@id)[1]', 'int') AS record_id,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle,
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization,
			timestamp
		FROM (
			SELECT timestamp, CONVERT(XML, record) AS record 
			FROM sys.dm_os_ring_buffers 
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '%<SystemHealth>%') AS x
		) AS y 
	ORDER BY record_id DESC

	IF EXISTS(SELECT * FROM #temp WHERE (SQLProcessUtilization + OtherProcessUtilization)>70)
	BEGIN


		SELECT TOP 10 r.session_id ,DB_NAME(sp.database_id) AS 'Database'
		,CASE coalesce(object_name(st.objectid,sp.database_id),'1') when '1' then st.[text] else object_name(st.objectid,sp.database_id) END AS Query 
		--,StatsP1.AvgTime 
		,CONVERT(TIME,DATEADD (ms, r.total_elapsed_time, 0)) AS ElapsedTime,
		r.wait_time ,
		r.last_wait_type AS waittype
		,r.blocking_session_id AS blksid
		,r.start_time 
		--,CASE r.transaction_isolation_level WHEN 1 THEN 'ReadUncomitted' WHEN 2 THEN 'ReadCommitted' WHEN 3 THEN 'Repeatable' WHEN 4 THEN 'serializable' WHEN 5 THEN 'Snapshot' END AS IsolamentoVit

		INTO #HeavyProcess  

		FROM sys.dm_exec_requests r 
		INNER JOIN sys.dm_exec_sessions sp ON sp.session_id=r.session_id
		LEFT JOIN sys.dm_exec_requests rb ON r.blocking_session_id=rb.session_id
		LEFT JOIN sys.dm_exec_sessions sb ON sb.session_id=rb.session_id
		CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
		OUTER APPLY sys.dm_exec_sql_text(rb.sql_handle) AS st1
		--OUTER APPLY (SELECT AvgTime = (total_elapsed_time/1000 / execution_count) FROM sys.dm_exec_procedure_stats ps WHERE ps.object_id=st.objectid) AS StatsP1
		WHERE 1=1
		AND r.session_id<>@@spid
		AND (CASE coalesce(object_name(st.objectid),'1') when '1' then LEFT(st.[text],8000) else object_name(st.objectid,sp.database_id) END) != 'sp_cdc_scan'
		ORDER BY r.cpu_time desc
		OPTION(RECOMPILE)

		DECLARE @MsgBody NVARCHAR(MAX)  
		SET @MsgBody = '<html>  
		<head>  
		<title>Data files report</title>  
		</head>  
		<body>  
		<table border= "1">  
		<tr>  
		<td>session_id</td>  
		<td>Database</td>  
		<td>Query</td>  
		<td>ElapsedTime</td>  
		<td>wait_time</td>  
		<td>waittype</td>  
		<td>blksid</td>  
		<td>start_time</td>  
		 
		</tr>' +  
		CAST ((  
		SELECT   
		td=session_id,''  
		,td=[Database],''  
		,td=Query,''  
		--,td=AvgTime,''
		,td=ElapsedTime,''  
		,td=COALESCE(wait_time,0),''  
		,td=COALESCE(waittype,'NENHUM'),''  
		,td=COALESCE(blksid,0),'' 
		,td=start_time  
		
  
		FROM #HeavyProcess  
  
		FOR XML PATH('tr')  
		) AS NVARCHAR(MAX) ) +  
		N'</table>';  


		EXEC msdb.dbo.sp_send_dbmail    
		@profile_name = @Profile    
		,@body = @MsgBody    
		,@body_format = 'HTML'    
		,@recipients = @Destinatarios    
		,@subject = @Assunto    
		,@query_result_no_padding = 1    
		,@query_result_header = 0    
  
	END

END
GO
