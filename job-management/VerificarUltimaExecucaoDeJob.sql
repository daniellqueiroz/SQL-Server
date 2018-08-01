
declare @tmp_sp_help_jobhistory table
(
    instance_id int null, 
    job_id uniqueidentifier null, 
    job_name sysname null, 
    step_id int null, 
    step_name sysname null, 
    sql_message_id int null, 
    sql_severity int null, 
    message nvarchar(4000) null, 
    run_status int null, 
    run_date int null, 
    run_time int null, 
    run_duration int null, 
    operator_emailed sysname null, 
    operator_netsent sysname null, 
    operator_paged sysname null, 
    retries_attempted int null, 
    server sysname null  
)

declare @qtdstep tinyint
declare @jobname varchar(100)

set @jobname = 'PosRestore_CASASBAHIA'

select @qtdstep = count(*) from msdb.dbo.sysjobsteps where job_id = (select job_id from msdb.dbo.sysjobs where name = @jobname)

insert into @tmp_sp_help_jobhistory 
exec msdb.dbo.sp_help_jobhistory 
	@job_name = @jobname,
	@mode='FULL' 
		
SELECT top (@qtdstep)
    tshj.instance_id AS [InstanceID],
    tshj.sql_message_id AS [SqlMessageID],
    tshj.message AS [Message],
    tshj.step_id AS [StepID],
    tshj.step_name AS [StepName],
    tshj.sql_severity AS [SqlSeverity],
    tshj.job_id AS [JobID],
    tshj.job_name AS [JobName],
    tshj.run_status AS [RunStatus],
    CASE tshj.run_date WHEN 0 THEN NULL ELSE
    convert(datetime, 
            stuff(stuff(cast(tshj.run_date as nchar(8)), 7, 0, '-'), 5, 0, '-') + N' ' + 
            stuff(stuff(substring(cast(1000000 + tshj.run_time as nchar(7)), 2, 6), 5, 0, ':'), 3, 0, ':'), 
            120) END AS [RunDate],
    tshj.run_duration AS [RunDuration],
    tshj.operator_emailed AS [OperatorEmailed],
    tshj.operator_netsent AS [OperatorNetsent],
    tshj.operator_paged AS [OperatorPaged],
    tshj.retries_attempted AS [RetriesAttempted],
    tshj.server AS [Server],
    getdate() as [CurrentDate]
FROM @tmp_sp_help_jobhistory as tshj
where step_id = 0
ORDER BY [InstanceID] desc



--------------------------------

/*
SELECT * 
FROM msdb.dbo.sysjobhistory WHERE job_id = 'AB1B199E-CDD3-4D8F-9359-C34F6AAABF50'
AND 
convert(datetime, 
stuff(stuff(cast(run_date as nchar(8)), 7, 0, '-'), 5, 0, '-') + N' ' + 
stuff(stuff(substring(cast(1000000 + run_time as nchar(7)), 2, 6), 5, 0, ':'), 3, 0, ':'),120) > '2012-05-23T00:00:00'
--AND step_id = 0 
*/
