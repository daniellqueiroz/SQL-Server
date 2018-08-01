 select top 1  sj.name,step_name ,
 run_status ,
 message ,
 run_duration,
 CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjh.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjh.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  AS runtime
 FROM msdb.dbo.sysjobhistory sjh 
 INNER JOIN msdb.dbo.sysjobs sj ON sj.job_id = sjh.job_id
 WHERE 1=1
 --and job_id in (select job_id from msdb.dbo.sysjobs where name LIKE '%extraswat%') 
 AND step_name='(Job outcome)'
 AND sj.name LIKE '%RN - Limpa Dados Obsoletos - Tabela Log%'
 --AND sjh.run_status=0
 ORDER by instance_id desc
