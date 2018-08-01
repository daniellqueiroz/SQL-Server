USE master
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].LongSessionReport') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].LongSessionReport AS' 
END
GO    
ALTER PROCEDURE dbo.LongSessionReport    
AS    
BEGIN
	DECLARE @MsgBody NVARCHAR(MAX)  
	DECLARE @Destinatarios VARCHAR(500);    
	DECLARE @Assunto VARCHAR(500);    
	DECLARE @Profile VARCHAR(100);    
	DECLARE @idSkuServicoTipo INT    
	DECLARE @Loja VARCHAR(100);    
    
	SET CONCAT_NULL_YIELDS_NULL OFF    
    
	SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile where profile_id = (SELECT profile_id FROM msdb.dbo.sysmail_principalprofile where is_default=1));    
	--SET @Destinatarios = 'CANPARDatabaseAdministratorsStaffList@canpar.com'    
	SET @Destinatarios = 'rleandro@canpar.com'    
	SET @Assunto = 'Long running sessions alert! Check the server ' + @@SERVERNAME + ' for rogue sessions.' 
    
	IF OBJECT_ID('tempdb..#ProcessoLongo') IS NOT NULL  
	DROP TABLE #ProcessoLongo  
  
	SELECT  DISTINCT 
	DB_NAME(er.database_id) AS Banco
	,er.session_id  
	,CASE WHEN es.program_name LIKE '%SQLAgent%' THEN 'YES' ELSE 'NO' END AS FlagJob  
	,er.start_time  
	,er.status  
	,COALESCE(er.blocking_session_id,0) AS blocking_session_id  
	,COALESCE(er.last_wait_type,'NENHUM') AS wait_type  
	,er.reads + er.logical_reads + er.writes AS Total_IO
	,er.cpu_time
	,er.total_elapsed_time  
	,er.plan_handle  
	,es.program_name
	,es.[host_name],
	(CASE COALESCE(OBJECT_NAME(qt.objectid,qt.dbid),'1') WHEN '1' THEN qt.text ELSE OBJECT_NAME(qt.objectid,qt.dbid) END) AS Query  
	INTO #ProcessoLongo  
	FROM sys.dm_exec_requests er 
	INNER JOIN sys.dm_exec_sessions es ON er.session_id = es.session_id
	INNER JOIN sys.dm_exec_requests ert ON ert.session_id = er.session_id
	CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt  
	WHERE 1=1
	AND er.database_id NOT IN (SELECT database_id FROM master.sys.databases WHERE name IN ('distribution','master','tempdb','msdb','model'))  
	AND er.total_elapsed_time > 30000 
	AND (er.reads + er.logical_reads + er.writes) >= 100000
	--AND ert.command NOT LIKE '%BACKUP%'  
	AND er.session_id<>@@spid  

   
	IF @@ROWCOUNT>0  
	BEGIN 

		SET @MsgBody = '<html>  
		<head>  
		<title>Data files report</title>  
		</head>  
		<body>  
		<table border= "1">  
		<tr>  
		<td>Database</td>  
		<td>SPID</td>  
		<td>JOB?</td>  
		<td>start_time</td>  
		<td>STATUS</td>  
		<td>BLK_SPID</td>  
		<td>WAIT TYPE</td>  
		<td>Total IO</td>
		<td>Duration(sec)</td>  
		<td>PLAN</td>  
		<td>PROGRAM</td>  
		<td>HOST</td>  
		<td>QUERY</td>  
		</tr>' +  
		CAST ((  
			SELECT   
			td=Banco,''  
			,td=session_id,''  
			,td=FlagJob,''  
			,td=start_time,'',  
			td=status,''  
			,td=COALESCE(blocking_session_id,0),''  
			,td=COALESCE(wait_type,'NENHUM'),''  
			,td=Total_IO,''
			--,td=CAST(CAST (DATEDIFF(s,start_time,GETDATE()) AS INT)/86400 AS VARCHAR(50))+':'+ CONVERT(VARCHAR, DATEADD(S, CAST (DATEDIFF(s,start_time,GETDATE()) AS INT), 0), 108) ,'',  
			,td=total_elapsed_time/1000,'',
			td=CONVERT(VARCHAR(MAX),plan_handle,1),''  
			,td=[program_name],''
			,td=[host_name],''
			,td=CONVERT(VARCHAR(MAX),Query,1)  
  
			FROM #ProcessoLongo  
  
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
/********** OP CREATION **********/
USE [msdb]
GO

/****** Object:  Operator [Rafael Leandro]    Script Date: 4/19/2018 3:31:19 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'Rafael Leandro')
EXEC msdb.dbo.sp_add_operator @name=N'Rafael Leandro', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'rleandro@canpar.com', 
		@category_name=N'[Uncategorized]'
GO



/********** JOB CREATION **********/

USE [msdb]
GO

/****** Object:  Job [DBA_LongRuningSessions]    Script Date: 4/19/2018 2:43:17 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 4/19/2018 2:43:17 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
select @jobId = job_id from msdb.dbo.sysjobs where (name = N'DBA_LongRuningSessions')
if (@jobId is NULL)
BEGIN
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA_LongRuningSessions', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'Rafael Leandro', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END
/****** Object:  Step [check sessions]    Script Date: 4/19/2018 2:43:18 PM ******/
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobsteps WHERE job_id = @jobId and step_id = 1)
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'check sessions', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec LongSessionReport', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'each 3 minutes', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180322, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'ff35c297-4fb9-4fd6-aa84-6f1355fcd778'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO





/********* DESCOMENTE A ?REA ABAIXO SE DESEJAR QUE O A PROC MATE OS PROCESSOS AUTOMATICAMENTE ***********/    
    
----declare @TempoLimite int = 3600000    
--DECLARE @cmd VARCHAR(max)    
--SELECT @cmd = replace (    
-- (    
-- select 'KILL ' + CAST(ER.session_id AS VARCHAR(50)) + '|'    
-- from sys.dm_exec_requests er inner join [CL-BOCA-PSQL03\PSQL03].db_prd_extra.sys.sysprocesses sp    
-- on er.session_id=sp.spid    
-- outer APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt    
-- where session_id>50    
-- and sp.dbid<>4    
-- and sp.dbid NOT IN (select database_id from [CL-BOCA-PSQL03\PSQL03].master.sys.databases where NAME IN ('distribution','master','tempdb','msdb','model'))    
-- and total_elapsed_time>@TempoLimite    
-- and command not like '%BACKUP%'    
-- FOR XML PATH('')    
-- )    
--,'|',';')    
    
--EXEC (@cmd)    
----SELECT @cmd    
