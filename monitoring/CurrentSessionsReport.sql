USE master
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].CurrentSessionReport') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].CurrentSessionReport AS' 
END
GO

ALTER PROCEDURE dbo.CurrentSessionReport    
AS    

DECLARE @Destinatarios VARCHAR(500);    
DECLARE @Assunto VARCHAR(500);    
DECLARE @Profile VARCHAR(100);    
DECLARE @idSkuServicoTipo INT;    
DECLARE @Loja VARCHAR(100);    
    
SET CONCAT_NULL_YIELDS_NULL OFF;    
    
SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile); 
--SET @Destinatarios = 'CANPARDatabaseAdministratorsStaffList@canpar.com'    
SET @Destinatarios = 'rleandro@canpar.com';    
SET @Assunto = 'Current sessions running on '+ @@SERVERNAME +'! Use this data to get more information about any received alerts around this same time.'; 
    
IF OBJECT_ID('tempdb..#ProcessoLongo') IS NOT NULL  
DROP TABLE #ProcessoLongo;  
  
SELECT  DISTINCT 
DB_NAME(er.database_id) AS Banco
,er.session_id  
,CASE WHEN sp.program_name LIKE '%SQLAgent%' THEN 'YES' ELSE 'NO' END AS FlagJob  
,er.start_time  
,er.status  
,COALESCE(er.blocking_session_id,0) AS blocking_session_id  
,COALESCE(er.wait_type,'NENHUM') AS wait_type  
,er.total_elapsed_time  
,er.plan_handle  
,sp.program_name
,sp.host_name
,sp.login_name
,(CASE COALESCE(OBJECT_NAME(qt.objectid,qt.dbid),'1') WHEN '1' THEN qt.[text] ELSE OBJECT_NAME(qt.objectid,qt.dbid) END) AS texto  
INTO #ProcessoLongo  
FROM sys.dm_exec_requests er 
INNER JOIN sys.dm_exec_sessions sp  ON er.session_id=sp.session_id  
OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt  
WHERE er.session_id>50  
AND er.session_id<>@@spid;  
    
DECLARE @MsgBody NVARCHAR(MAX);  
SET @MsgBody = '<html>  
<head>  
<title>Data files report</title>  
</head>  
<body>  
<table border= "1">  
<tr>  
<td>Database</td>  
<td>session_id</td>  
<td>JOB?</td>  
<td>Query</td> 
<td>start_time</td>  
<td>status</td>  
<td>blocking_session_id</td>  
<td>wait_type</td>  
<td>Total_Exec_Time</td>  
<td>plan_handle</td>  
<td>program_name</td>  
<td>hostname</td>  
 <td>user</td>  
</tr>' +  
CAST ((  
SELECT   
td=Banco,''  
,td=session_id,''  
,td=FlagJob,''  
,td=CONVERT(VARCHAR(MAX),ISNULL(texto,'N/A'),1),''  
,td=start_time,'',  
td=status,''  
,td=COALESCE(blocking_session_id,0),''  
,td=COALESCE(wait_type,'NENHUM'),''  
,td=CAST(CAST (DATEDIFF(s,start_time,GETDATE()) AS INT)/86400 AS VARCHAR(50))+':'+ CONVERT(VARCHAR, DATEADD(S, CAST (DATEDIFF(s,start_time,GETDATE()) AS INT), 0), 108) ,'',  
td=ISNULL(CONVERT(VARCHAR(MAX),plan_handle,1),'N/A'),''  
,td=ISNULL([program_name],'N/A'),''
,td=ISNULL(host_name,'N/A'),''
,td=ISNULL(login_name,'N/A')
  
FROM #ProcessoLongo  
  
FOR XML PATH('tr')  
) AS NVARCHAR(MAX) ) +  
N'</table>';  
  
IF (SELECT COUNT(*) FROM #ProcessoLongo)>0  
BEGIN  
  
 EXEC msdb.dbo.sp_send_dbmail    
 @profile_name = @Profile    
 ,@body = @MsgBody    
 ,@body_format = 'HTML'    
 ,@recipients = @Destinatarios    
 ,@subject = @Assunto    
 ,@query_result_no_padding = 1    
 ,@query_result_header = 0;    
  
END;  
    
GO
