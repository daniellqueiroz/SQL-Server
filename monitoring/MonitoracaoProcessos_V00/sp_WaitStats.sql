--ALTER TABLE dbo.WaitsCBPrimario ADD DataHora DATETIME2(0) DEFAULT GETDATE()
--ALTER TABLE dbo.WaitsEXPrimario ADD DataHora DATETIME2(0) DEFAULT GETDATE()
--ALTER TABLE dbo.WaitsPFPrimario ADD DataHora DATETIME2(0) DEFAULT GETDATE()

INSERT INTO dbo.WaitsPFPrimario 
(session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4)

SELECT  
session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4
FROM OPENQUERY([PONTOFRIO_PRD.DC.NOVA,1303],'SELECT wt.session_id,wt.wait_duration_ms,wt.wait_type
,case coalesce(object_name(st.objectid),''1'') when ''1'' then st.[text] else object_name(st.objectid) END AS Query
--,StatsP1.tempo_medioP1
--,DB_NAME(sp.dbid) AS Banco
,sp.hostname
,sp.loginame
,sp.blocked
,case coalesce(object_name(st1.objectid),''1'') when ''1'' then st1.[text] else object_name(st1.objectid) END AS Query2
,sp1.loginame as LoginQ2
,sp1.hostname as HostQ2
,sp1.blocked as BlockQ2
,sp1.lastwaittype as WaitQ2
,case coalesce(object_name(st2.objectid),''1'') when ''1'' then st2.[text] else object_name(st2.objectid) END AS Query3
,sp2.loginame as LoginQ3
,sp2.hostname HostQ3
,sp2.blocked BlockQ3
,sp2.lastwaittype WaitQ3
,case coalesce(object_name(st3.objectid),''1'') when ''1'' then st3.[text] else object_name(st3.objectid) END AS Query4
,sp3.loginame as LoginQ4
,sp3.hostname HostQ4
,sp3.blocked BlockQ4
,sp3.lastwaittype WaitQ4
FROM sys.dm_os_wait_stats  ws
right join sys.dm_os_waiting_tasks wt on ws.wait_type = wt.wait_type
left join sys.sysprocesses sp on sp.spid = wt.session_id
LEFT JOIN sys.sysprocesses sp1 ON sp1.spid=sp.blocked
LEFT JOIN sys.sysprocesses sp2 ON sp2.spid=sp1.blocked
LEFT JOIN sys.sysprocesses sp3 ON sp3.spid=sp2.blocked
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) AS st
outer APPLY sys.dm_exec_sql_text(sp1.sql_handle) AS st1
outer APPLY sys.dm_exec_sql_text(sp2.sql_handle) AS st2
outer APPLY sys.dm_exec_sql_text(sp3.sql_handle) AS st3
--OUTER APPLY (SELECT tempo_medioP1 = (total_elapsed_time/1000 / execution_count) FROM sys.dm_exec_procedure_stats ps WHERE ps.object_id=st.objectid)  StatsP1
WHERE 1=1 
--and wt.session_id > 50
and wt.session_id != @@spid
and sp.status !=''sleeping''
AND ws.wait_type NOT IN (''BACKUPIO'',''BACKUPTHREAD'',''SP_SERVER_DIAGNOSTICS_SLEEP'')
ORDER BY wait_time_ms DESC
')

GO

INSERT INTO dbo.WaitsCBPrimario 
(session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4)

SELECT  
session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4
FROM OPENQUERY([CASASBAHIA_PRD.DC.NOVA,1306],'SELECT wt.session_id,wt.wait_duration_ms,wt.wait_type
,case coalesce(object_name(st.objectid),''1'') when ''1'' then st.[text] else object_name(st.objectid) END AS Query
--,StatsP1.tempo_medioP1
--,DB_NAME(sp.dbid) AS Banco
,sp.hostname
,sp.loginame
,sp.blocked
,case coalesce(object_name(st1.objectid),''1'') when ''1'' then st1.[text] else object_name(st1.objectid) END AS Query2
,sp1.loginame as LoginQ2
,sp1.hostname as HostQ2
,sp1.blocked as BlockQ2
,sp1.lastwaittype as WaitQ2
,case coalesce(object_name(st2.objectid),''1'') when ''1'' then st2.[text] else object_name(st2.objectid) END AS Query3
,sp2.loginame as LoginQ3
,sp2.hostname HostQ3
,sp2.blocked BlockQ3
,sp2.lastwaittype WaitQ3
,case coalesce(object_name(st3.objectid),''1'') when ''1'' then st3.[text] else object_name(st3.objectid) END AS Query4
,sp3.loginame as LoginQ4
,sp3.hostname HostQ4
,sp3.blocked BlockQ4
,sp3.lastwaittype WaitQ4
FROM sys.dm_os_wait_stats  ws
right join sys.dm_os_waiting_tasks wt on ws.wait_type = wt.wait_type
left join sys.sysprocesses sp on sp.spid = wt.session_id
LEFT JOIN sys.sysprocesses sp1 ON sp1.spid=sp.blocked
LEFT JOIN sys.sysprocesses sp2 ON sp2.spid=sp1.blocked
LEFT JOIN sys.sysprocesses sp3 ON sp3.spid=sp2.blocked
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) AS st
outer APPLY sys.dm_exec_sql_text(sp1.sql_handle) AS st1
outer APPLY sys.dm_exec_sql_text(sp2.sql_handle) AS st2
outer APPLY sys.dm_exec_sql_text(sp3.sql_handle) AS st3
--OUTER APPLY (SELECT tempo_medioP1 = (total_elapsed_time/1000 / execution_count) FROM sys.dm_exec_procedure_stats ps WHERE ps.object_id=st.objectid)  StatsP1
WHERE 1=1 
--and wt.session_id > 50
and wt.session_id != @@spid
and sp.status !=''sleeping''
AND ws.wait_type NOT IN (''BACKUPIO'',''BACKUPTHREAD'',''SP_SERVER_DIAGNOSTICS_SLEEP'')
ORDER BY wait_time_ms DESC
')

GO

INSERT INTO dbo.WaitsEXPrimario 
(session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4)

SELECT  
session_id,wait_duration_ms,wait_type,Query,hostname,loginame,blocked,Query2,LoginQ2,HostQ2,BlockQ2,WaitQ2,Query3,LoginQ3,HostQ3,BlockQ3,WaitQ3,Query4,LoginQ4,HostQ4,BlockQ4,WaitQ4
FROM OPENQUERY([EXTRA_PRD.DC.NOVA,1301],'SELECT wt.session_id,wt.wait_duration_ms,wt.wait_type
,case coalesce(object_name(st.objectid),''1'') when ''1'' then st.[text] else object_name(st.objectid) END AS Query
--,StatsP1.tempo_medioP1
--,DB_NAME(sp.dbid) AS Banco
,sp.hostname
,sp.loginame
,sp.blocked
,case coalesce(object_name(st1.objectid),''1'') when ''1'' then st1.[text] else object_name(st1.objectid) END AS Query2
,sp1.loginame as LoginQ2
,sp1.hostname as HostQ2
,sp1.blocked as BlockQ2
,sp1.lastwaittype as WaitQ2
,case coalesce(object_name(st2.objectid),''1'') when ''1'' then st2.[text] else object_name(st2.objectid) END AS Query3
,sp2.loginame as LoginQ3
,sp2.hostname HostQ3
,sp2.blocked BlockQ3
,sp2.lastwaittype WaitQ3
,case coalesce(object_name(st3.objectid),''1'') when ''1'' then st3.[text] else object_name(st3.objectid) END AS Query4
,sp3.loginame as LoginQ4
,sp3.hostname HostQ4
,sp3.blocked BlockQ4
,sp3.lastwaittype WaitQ4
FROM sys.dm_os_wait_stats  ws
right join sys.dm_os_waiting_tasks wt on ws.wait_type = wt.wait_type
left join sys.sysprocesses sp on sp.spid = wt.session_id
LEFT JOIN sys.sysprocesses sp1 ON sp1.spid=sp.blocked
LEFT JOIN sys.sysprocesses sp2 ON sp2.spid=sp1.blocked
LEFT JOIN sys.sysprocesses sp3 ON sp3.spid=sp2.blocked
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) AS st
outer APPLY sys.dm_exec_sql_text(sp1.sql_handle) AS st1
outer APPLY sys.dm_exec_sql_text(sp2.sql_handle) AS st2
outer APPLY sys.dm_exec_sql_text(sp3.sql_handle) AS st3
--OUTER APPLY (SELECT tempo_medioP1 = (total_elapsed_time/1000 / execution_count) FROM sys.dm_exec_procedure_stats ps WHERE ps.object_id=st.objectid)  StatsP1
WHERE 1=1 
--and wt.session_id > 50
and wt.session_id != @@spid
and sp.status !=''sleeping''
AND ws.wait_type NOT IN (''BACKUPIO'',''BACKUPTHREAD'',''SP_SERVER_DIAGNOSTICS_SLEEP'')
ORDER BY wait_time_ms DESC
')
