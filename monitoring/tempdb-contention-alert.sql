USE [master]
GO

/****** Object:  Table [dbo].[checktempdb]    Script Date: 5/24/2018 5:33:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[checktempdb]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[checktempdb]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[checktempdb]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[checktempdb](
	[host_name] [nvarchar](128) NULL,
	[qblock] [nvarchar](max) NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_duration_ms] [bigint] NULL,
	[resource_description] [nvarchar](3072) NULL,
	[ResourceType] [varchar](29) NOT NULL,
	[login_name] [varchar](29) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].tempdbcheck') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].tempdbcheck AS' 
END
GO

ALTER PROCEDURE dbo.tempdbcheck
AS
BEGIN

	
	DECLARE @Destinatarios VARCHAR(500);    
	DECLARE @Assunto VARCHAR(500);    
	DECLARE @Profile VARCHAR(100);    
	DECLARE @idSkuServicoTipo INT    
	DECLARE @Loja VARCHAR(100);    
    
	SET CONCAT_NULL_YIELDS_NULL OFF    
    
	SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile);    
	--SET @Destinatarios = 'CANPARDatabaseAdministratorsStaffList@canpar.com'    
	SET @Destinatarios = 'rleandro@canpar.com'    
	SET @Assunto = 'Tempdb contention on server ' + @@SERVERNAME + '. Check for sessions stressing tempdb.' 

	TRUNCATE TABLE master.dbo.checktempdb

	INSERT INTO [dbo].[checktempdb]
			   ([host_name]
			   ,[qblock]
			   ,[wait_type]
			   ,[wait_duration_ms]
			   ,[resource_description]
			   ,[ResourceType],login_name)
	
	SELECT --wa.session_id,
	se.host_name ,
	qs.text [qblock],
	wa.wait_type,
	wa.wait_duration_ms,
	wa.resource_description,
	ResourceType = CASE
	WHEN CAST(RIGHT(resource_description, LEN(resource_description) - CHARINDEX(':', resource_description, 3)) AS INT) - 1 % 8088 = 0 THEN 'Is PFS Page'
				WHEN CAST(RIGHT(resource_description, LEN(resource_description) - CHARINDEX(':', resource_description, 3)) AS INT) - 2 % 511232 = 0 THEN 'Is GAM Page'
				WHEN CAST(RIGHT(resource_description, LEN(resource_description) - CHARINDEX(':', resource_description, 3)) AS INT) - 3 % 511232 = 0 THEN 'Is SGAM Page'
				ELSE 'Is Not PFS, GAM, or SGAM page'
				END,
	se.login_name
	FROM sys.dm_os_waiting_tasks wa INNER JOIN sys.dm_exec_sessions se ON wa.session_id=se.session_id
	INNER JOIN sys.dm_exec_connections co ON co.session_id=wa.session_id
	CROSS APPLY sys.dm_exec_sql_text (co.most_recent_sql_handle) qs
	WHERE wa.wait_type LIKE 'PAGE%LATCH_%'
	AND resource_description LIKE '2:%'
	and qs.text not like '%LongSessionReport%'
	and wait_duration_ms > 500

	DECLARE @MsgBody NVARCHAR(MAX)=''
	SET @MsgBody = '<html>  
	<head>  
	<title>Data files report</title>  
	</head>  
	<body>  
	<table border= "1">  
	<tr>  
	<td>Hostname</td>  
	<td>Query</td>  
	<td>Waittype</td>  
	<td>WaitDuration</td>  
	<td>ResourceDesc</td> 
	<td>ResourceType</td>
	<td>User</td>  	
	</tr>' +  
	CAST ((  
	SELECT   
	 td=host_name,''  
	,td=[qblock],''  
	,td=wait_type,''  
	,td=wait_duration_ms,''
	,td=resource_description,''  
	,td=ResourceType,''
	,td=login_name
	FROM master.dbo.checktempdb
  
	FOR XML PATH('tr')  
	) AS NVARCHAR(MAX) ) +  
	N'</table>'; 
	
	--SELECT COUNT(*) FROM master.dbo.checktempdb; 
	
	IF (SELECT COUNT(*) FROM master.dbo.checktempdb)>0  
	BEGIN  
  
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
