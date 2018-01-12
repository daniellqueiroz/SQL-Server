/*

Remarks:

1. Assorted scripts for job report and administration

*/

SELECT * FROM msdb.dbo.sysjobsteps WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = 'RN - Limpa Dados Obsoletos') -- getting the steps of a specific job

SELECT (SELECT name + ' - ' + CASE enabled WHEN 1 THEN 'ENABLE' ELSE 'DISABLE' END FROM msdb.dbo.sysjobs WHERE job_id=js.job_id) AS name,* FROM msdb.dbo.sysjobsteps js WHERE command LIKE '%RelatorioProdutosAtivosSite%' -- getting the steps of any job, given a specif command

-- run the script below to get the execution history of a specific job
SELECT TOP 100  sj.name,step_name ,
run_status ,
message ,
run_duration,
CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjh.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjh.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  AS runtime
FROM msdb.dbo.sysjobhistory sjh 
INNER JOIN msdb.dbo.sysjobs sj ON sj.job_id = sjh.job_id
WHERE 1=1
--and job_id in (select job_id from msdb.dbo.sysjobs where name LIKE '%extraswat%') 
AND step_name='(Job outcome)'
AND sj.name LIKE '%extraswat%'
--AND sjh.run_status=0
ORDER BY instance_id DESC

-- getting all the jobs with their respective last run status
select sj.name,sj.enabled,a.run_duration,a.run_date,a.run_time
FROM msdb.dbo.sysjobs sj
CROSS APPLY (SELECT TOP 1 run_duration,sjh.run_date,sjh.run_time FROM msdb.dbo.sysjobhistory sjh WHERE sj.job_id = sjh.job_id ORDER by instance_id desc) AS a
ORDER BY name


-- run the script below to get the execution history of a specific job (more friendly output)
;WITH jobhistory AS
(
	SELECT js.job_id,js.step_id,js.step_name
	,stuff(stuff(replace(str(run_duration,6,0),' ','0'),3,0,':'),6,0,':') AS run_duration
	,CAST(STUFF(STUFF(REPLACE(STR(run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':') AS time(0)) AS runtime
	,CONVERT(DATE, CONVERT(CHAR(8), run_date, 112)) AS rundate
	,jh.run_duration+jh.run_time AS endtime
	FROM msdb.dbo.sysjobhistory jh,msdb.dbo.sysjobsteps js 
	WHERE 1=1
	--and run_duration&gt;1000 
	AND jh.step_id=js.step_id AND jh.job_id=js.job_id AND js.database_name NOT IN ('distribution','master')
)
,jobs AS
(
	SELECT j.NAME,jobhistory.step_name,jobhistory.run_duration,runtime,rundate,jobhistory.step_id
	,stuff(stuff(replace(str(endtime,6,0),' ','0'),3,0,':'),6,0,':') AS endtime,[sCAT].[name] CatName
	FROM msdb.dbo.sysjobs j INNER join jobhistory  ON jobhistory.job_id=j.job_id
	 LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON j.[category_id] = [sCAT].[category_id]
)

SELECT * FROM jobs 
WHERE NAME NOT LIKE 'TI_BANCO%' 
AND NAME NOT LIKE '%CL-BOCA-PSQL03\PSQL03%'
AND jobs.step_name <> 'Change Data Capture Collection Agent'
AND jobs.step_name NOT LIKE 'collection[_]set[_]%'
AND name <> 'sysutility_get_views_data_into_cache_tables'
--AND rundate&gt; DATEADD(DAY,-3,GETDATE())
--AND (runtime > '06:00:00' OR endtime &gt;'06:00:00')
--AND name='RN - Limpa Dados Obsoletos'
--AND jobs.rundate=CONVERT(DATE,GETDATE())
--AND jobs.runtime BETWEEN '06:00:00' AND '08:31:00'
AND CatName NOT LIKE 'REPL%'
AND CatName NOT LIKE 'Data Collector'
ORDER BY rundate DESC,runtime DESC




-- Altering the command run by a job step (only works for steps that run TSQL commands)
select (SELECT name + ' - ' + CASE enabled WHEN 1 THEN 'ENABLE' ELSE 'DISABLE' END FROM msdb.dbo.sysjobs WHERE job_id=js.job_id) AS name
,'EXEC msdb.dbo.sp_update_jobstep @job_id=N'''+CONVERT(VARCHAR(100),job_id)+'''
, @step_id=1 , 
		@command=N''DECLARE @check VARCHAR(100) = (select
        ars.role_desc
    from sys.dm_hadr_availability_replica_states ars
    inner join sys.availability_groups ag
    on ars.group_id = ag.group_id
    where  ars.is_local = 1)


 
IF @check = ''''PRIMARY'''' OR @check IS NULL
begin
    -- this server is the primary replica, do something here
 print ''''primario''''
end
else
begin
    -- this server is not the primary replica, (optional) do something here
 RAISERROR(''''Instância secundaria'''',15,1)
end'''
,* 

FROM msdb.dbo.sysjobsteps js 
WHERE js.step_name LIKE '%always%'



/*
-- Monitoria de jobs

SELECT * FROM (
SELECT TOP 100  sj.name,sjh.step_name ,
sjh.run_status ,
sjh.message ,
sjh.run_duration
,CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjh.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjh.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  AS runtime
FROM msdb.dbo.sysjobhistory sjh 
INNER JOIN msdb.dbo.sysjobs sj ON sj.job_id = sjh.job_id
WHERE 1=1
--and job_id in (select job_id from msdb.dbo.sysjobs where name LIKE '%extraswat%') 
AND sjh.step_name='(Job outcome)'
AND sj.name LIKE '%extraswat%'
AND sjh.run_status=0
ORDER BY sjh.instance_id desc
) AS a
WHERE a.runtime > CONVERT(DATE,GETDATE())
AND NOT EXISTS
(

	SELECT TOP 1 1 
	FROM msdb.dbo.sysjobhistory sjhb 
	INNER JOIN msdb.dbo.sysjobs sjb ON sjb.job_id = sjhb.job_id
	WHERE 1=1
	AND sjb.name LIKE '%extraswat%'
	AND sjhb.step_name='(Job outcome)'
	AND sjhb.run_status=1
	AND sjb.name = a.name
	AND CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjhb.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjhb.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  >= a.runtime
)


*/