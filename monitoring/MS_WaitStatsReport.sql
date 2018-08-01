SELECT wt.session_id,wt.wait_duration_ms,wt.wait_type
,case coalesce(object_name(st.objectid),'1') when '1' then (REPLACE(REPLACE(REPLACE(REPLACE(st.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),'')) else object_name(st.objectid) END AS Query
--,DB_NAME(sp.dbid) AS Banco
,sp.hostname
,sp.loginame
,sp.blocked
,case coalesce(object_name(st1.objectid),'1') when '1' then (REPLACE(REPLACE(REPLACE(REPLACE(st1.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),'')) else object_name(st1.objectid) END AS Query2
,sp1.loginame
,sp1.hostname
,sp1.blocked
,sp1.lastwaittype
,case coalesce(object_name(st2.objectid),'1') when '1' then (REPLACE(REPLACE(REPLACE(REPLACE(st2.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),'')) else object_name(st2.objectid) END AS Query3
,sp2.loginame
,sp2.hostname
,sp2.blocked
,sp2.lastwaittype
,case coalesce(object_name(st3.objectid),'1') when '1' then (REPLACE(REPLACE(REPLACE(REPLACE(st3.[text],CHAR(13),''),CHAR(10),''),'-',''),CHAR(9),'')) else object_name(st3.objectid) END AS Query4
,sp3.loginame
,sp3.hostname
,sp3.blocked
,sp3.lastwaittype
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
WHERE 1=1 
--and wt.session_id > 50
and wt.session_id != @@spid
and sp.status !='sleeping'
AND ws.wait_type NOT IN ('BACKUPIO','BACKUPTHREAD','SP_SERVER_DIAGNOSTICS_SLEEP','WAITFOR')
--AND ws.wait_type like 'LCK%'
--AND object_name(st.objectid) NOT IN ('SkuAlteracaoListarV2','SkuAlteracaoIncluirV2')
ORDER BY wait_time_ms DESC


/*

WITH [Waits] 
AS (SELECT wait_type, wait_time_ms/ 1000.0 AS [WaitS],
          (wait_time_ms - signal_wait_time_ms) / 1000.0 AS [ResourceS],
           signal_wait_time_ms / 1000.0 AS [SignalS],
           waiting_tasks_count AS [WaitCount],
           100.0 *  wait_time_ms / SUM (wait_time_ms) OVER() AS [Percentage],
           ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats WITH (NOLOCK)
    WHERE [wait_type] NOT IN (
        N'BROKER_EVENTHANDLER', N'BROKER_RECEIVE_WAITFOR', N'BROKER_TASK_STOP',
		N'BROKER_TO_FLUSH', N'BROKER_TRANSMITTER', N'CHECKPOINT_QUEUE',
        N'CHKPT', N'CLR_AUTO_EVENT', N'CLR_MANUAL_EVENT', N'CLR_SEMAPHORE',
        N'DBMIRROR_DBM_EVENT', N'DBMIRROR_EVENTS_QUEUE', N'DBMIRROR_WORKER_QUEUE',
		N'DBMIRRORING_CMD', N'DIRTY_PAGE_POLL', N'DISPATCHER_QUEUE_SEMAPHORE',
        N'EXECSYNC', N'FSAGENT', N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'FT_IFTSHC_MUTEX',
        N'HADR_CLUSAPI_CALL', N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', N'HADR_LOGCAPTURE_WAIT', 
		N'HADR_NOTIFICATION_DEQUEUE', N'HADR_TIMER_TASK', N'HADR_WORK_QUEUE',
        N'KSOURCE_WAKEUP', N'LAZYWRITER_SLEEP', N'LOGMGR_QUEUE', N'ONDEMAND_TASK_QUEUE',
        N'PWAIT_ALL_COMPONENTS_INITIALIZED', N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', N'REQUEST_FOR_DEADLOCK_SEARCH',
		N'RESOURCE_QUEUE', N'SERVER_IDLE_CHECK', N'SLEEP_BPOOL_FLUSH', N'SLEEP_DBSTARTUP',
		N'SLEEP_DCOMSTARTUP', N'SLEEP_MASTERDBREADY', N'SLEEP_MASTERMDREADY',
        N'SLEEP_MASTERUPGRADED', N'SLEEP_MSDBSTARTUP', N'SLEEP_SYSTEMTASK', N'SLEEP_TASK',
        N'SLEEP_TEMPDBSTARTUP', N'SNI_HTTP_ACCEPT', N'SP_SERVER_DIAGNOSTICS_SLEEP',
		N'SQLTRACE_BUFFER_FLUSH', N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', N'SQLTRACE_WAIT_ENTRIES',
		N'WAIT_FOR_RESULTS', N'WAITFOR', N'WAITFOR_TASKSHUTDOWN', N'WAIT_XTP_HOST_WAIT',
		N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', N'WAIT_XTP_CKPT_CLOSE', N'XE_DISPATCHER_JOIN',
        N'XE_DISPATCHER_WAIT', N'XE_TIMER_EVENT')
    AND waiting_tasks_count > 0)
SELECT
    MAX (W1.wait_type) AS [WaitType],
    CAST (MAX (W1.WaitS) AS DECIMAL (16,2)) AS [Wait_Sec],
    CAST (MAX (W1.ResourceS) AS DECIMAL (16,2)) AS [Resource_Sec],
    CAST (MAX (W1.SignalS) AS DECIMAL (16,2)) AS [Signal_Sec],
    MAX (W1.WaitCount) AS [Wait Count],
    CAST (MAX (W1.Percentage) AS DECIMAL (5,2)) AS [Wait Percentage],
    CAST ((MAX (W1.WaitS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgWait_Sec],
    CAST ((MAX (W1.ResourceS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgRes_Sec],
    CAST ((MAX (W1.SignalS) / MAX (W1.WaitCount)) AS DECIMAL (16,4)) AS [AvgSig_Sec]
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.RowNum <= W1.RowNum
GROUP BY W1.RowNum
HAVING SUM (W2.Percentage) - MAX (W1.Percentage) < 99 -- percentage threshold
OPTION (RECOMPILE);


SELECT CAST(100.0 * SUM(signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) AS [% Signal (CPU) Waits],
CAST(100.0 * SUM(wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) AS NUMERIC(20,2)) AS [% Resource Waits]
FROM sys.dm_os_wait_stats WITH (NOLOCK)
WHERE wait_type NOT IN (
        N'BROKER_EVENTHANDLER', N'BROKER_RECEIVE_WAITFOR', N'BROKER_TASK_STOP',
		N'BROKER_TO_FLUSH', N'BROKER_TRANSMITTER', N'CHECKPOINT_QUEUE',
        N'CHKPT', N'CLR_AUTO_EVENT', N'CLR_MANUAL_EVENT', N'CLR_SEMAPHORE',
        N'DBMIRROR_DBM_EVENT', N'DBMIRROR_EVENTS_QUEUE', N'DBMIRROR_WORKER_QUEUE',
		N'DBMIRRORING_CMD', N'DIRTY_PAGE_POLL', N'DISPATCHER_QUEUE_SEMAPHORE',
        N'EXECSYNC', N'FSAGENT', N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'FT_IFTSHC_MUTEX',
        N'HADR_CLUSAPI_CALL', N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', N'HADR_LOGCAPTURE_WAIT', 
		N'HADR_NOTIFICATION_DEQUEUE', N'HADR_TIMER_TASK', N'HADR_WORK_QUEUE',
        N'KSOURCE_WAKEUP', N'LAZYWRITER_SLEEP', N'LOGMGR_QUEUE', N'ONDEMAND_TASK_QUEUE',
        N'PWAIT_ALL_COMPONENTS_INITIALIZED', N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', N'REQUEST_FOR_DEADLOCK_SEARCH',
		N'RESOURCE_QUEUE', N'SERVER_IDLE_CHECK', N'SLEEP_BPOOL_FLUSH', N'SLEEP_DBSTARTUP',
		N'SLEEP_DCOMSTARTUP', N'SLEEP_MASTERDBREADY', N'SLEEP_MASTERMDREADY',
        N'SLEEP_MASTERUPGRADED', N'SLEEP_MSDBSTARTUP', N'SLEEP_SYSTEMTASK', N'SLEEP_TASK',
        N'SLEEP_TEMPDBSTARTUP', N'SNI_HTTP_ACCEPT', N'SP_SERVER_DIAGNOSTICS_SLEEP',
		N'SQLTRACE_BUFFER_FLUSH', N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', N'SQLTRACE_WAIT_ENTRIES',
		N'WAIT_FOR_RESULTS', N'WAITFOR', N'WAITFOR_TASKSHUTDOWN', N'WAIT_XTP_HOST_WAIT',
		N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', N'WAIT_XTP_CKPT_CLOSE', N'XE_DISPATCHER_JOIN',
        N'XE_DISPATCHER_WAIT', N'XE_TIMER_EVENT') OPTION (RECOMPILE);
*/
