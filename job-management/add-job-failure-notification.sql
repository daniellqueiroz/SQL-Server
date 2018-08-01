--USE [msdb]
--GO
--EXEC msdb.dbo.sp_update_job @job_id=N'8ddb323a-d169-437b-baee-b2a9d97876b3',@notify_level_email=2, @notify_level_page=2, @notify_email_operator_name=N'DBA Group'
--GO

SELECT name,enabled,job_id 
,'exec msdb.dbo.sp_update_job @job_id=N''' + CONVERT(VARCHAR(36),job_id) + ''',@notify_level_email=2, @notify_level_page=2, @notify_email_operator_name=N''DBA GROUP'''
FROM msdb.dbo.sysjobs 
WHERE 1=1
--and job_id='8ddb323a-d169-437b-baee-b2a9d97876b3'
AND name LIKE 'LS%'

