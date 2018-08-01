USE master
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].sp_monitorErrorLog') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].sp_monitorErrorLog AS' 
END
GO
ALTER PROCEDURE sp_monitorErrorLog AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Destinatarios VARCHAR(500);    
	DECLARE @Assunto VARCHAR(500);    
	DECLARE @Profile VARCHAR(100);    
	
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
		DROP TABLE #temp;
	   
	SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile);    
	SET @Destinatarios = 'CANPARDatabaseAdministratorsStaffList@canpar.com'    
	--SET @Destinatarios = 'rleandro@canpar.com'    
	SET @Assunto = 'Errors found in SQL Server log server ' + @@SERVERNAME + '\' + @@SERVICENAME + '.' 

	DECLARE	@low DATETIME=DATEADD(MINUTE,-10,GETDATE()), @high DATETIME=GETDATE()
	CREATE TABLE #temp (logdate DATETIME, processinfo VARCHAR(500),[message] VARCHAR(MAX))

	INSERT INTO #temp
	EXEC master.dbo.xp_readerrorlog 0, 1, NULL, NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "fail", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "error", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "SECONDS", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "fatal", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "consistency", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "I/O", NULL, @low, @high, N'desc' 

	--INSERT INTO #temp
	--EXEC master.dbo.xp_readerrorlog 0, 1, "suspect", NULL, @low, @high, N'desc' 

	delete from #temp 
	where message like '%finished without errors%'
	or message like 'BACKUP DATABASE successfully processed%'
	or message like '%found 0 errors and repaired 0 errors%'
	or message like 'I/O is frozen on database%'
	or message like 'I/O was resumed on database%'
	or message like '%NT AUTHORITY\ANONYMOUS LOGON%'
	or message like '%Failed to open the explicitly specified database%'
	or message like 'Error: 18456, Severity: 14, State: 38.'
	or message like 'Error: %, Severity: %, State: %.'
	or message like 'Log was backed up%'
	or message like 'DBCC TRACEON 3604%'
	or message like '%This is an informational message%'
	or message like 'Starting up database %'
	or message like 'Setting database option %'
	or message like 'DBCC TRACEOFF 3604%'
	or message like '%changed from 0 to 0%'
	or message like 'FILESTREAM: effective level = 0%'
	--or message like 'Login failed. The login is from an untrusted domain%'
	

	IF EXISTS(SELECT * FROM #temp)
	BEGIN
		DECLARE @MsgBody NVARCHAR(MAX)  
		SET @MsgBody = '<html>  
		<head>  
		<title>Data files report</title>  
		</head>  
		<body>  
		<table border= "1">  
		<tr>  
		<td>logDate</td>  
		<td>Process Info</td>  
		<td>Message</td>  
		</tr>' +  
		CAST ((  
		SELECT  distinct 
		td=logdate,''  
		,td=processinfo,''  
		,td=[message]
		
		FROM #temp  
  
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

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
		DROP TABLE #temp
END
GO

--EXEC master.dbo.xp_readerrorlog 0, 1, NULL, NULL, NULL, NULL, N'desc' 

--Login failed for user 'crmuser'. Reason: Could not find a login matching the name provided. [CLIENT: 10.3.1.207]
--Login failed for user 'CANPARNT\Automan_2000'. Reason: Token-based server access validation failed with an infrastructure error. Check for previous errors. [CLIENT: 10.3.1.223]
