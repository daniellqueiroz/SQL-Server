
create table #tmp_sp_get_sqlagent_properties
(auto_start int null, msx_server_name sysname null, sqlagent_type int null, startup_account nvarchar(255) null, sqlserver_restart int null, jobhistory_max_rows int null, jobhistory_max_rows_per_job int null, errorlog_file nvarchar(255) null, errorlogging_level int null, error_recipient nvarchar(30) null, monitor_autostart int null, local_host_server sysname null, job_shutdown_timeout int null, cmdexec_account varbinary(64) null, regular_connections int null, host_login_name sysname null, host_login_password varbinary(512) null, login_timeout int null, idle_cpu_percent int null, idle_cpu_duration int null, oem_errorlog int null, sysadmin_only int null, email_profile nvarchar(64) null, email_save_in_sent_folder int null, cpu_poller_enabled int null, replace_alert_tokens_enabled int null)
insert into #tmp_sp_get_sqlagent_properties(auto_start, msx_server_name, sqlagent_type, startup_account, sqlserver_restart, jobhistory_max_rows, jobhistory_max_rows_per_job, errorlog_file, errorlogging_level, error_recipient, monitor_autostart, local_host_server, job_shutdown_timeout, cmdexec_account, regular_connections, host_login_name, host_login_password, login_timeout, idle_cpu_percent, idle_cpu_duration, oem_errorlog, sysadmin_only, email_profile, email_save_in_sent_folder, cpu_poller_enabled, replace_alert_tokens_enabled)
exec msdb.dbo.sp_get_sqlagent_properties
      


declare @DatabaseMailProfile nvarchar(255)
exec master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', @param = @DatabaseMailProfile OUT, @no_output = N'no_output'
      


declare @AgentMailType int
exec master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', @param = @AgentMailType OUT, @no_output = N'no_output'
      


declare @ServiceStartMode int = 2
EXEC master.sys.xp_instance_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT', N'Start', @ServiceStartMode OUTPUT
      


declare @ServiceAccount nvarchar(512)
EXEC master.sys.xp_instance_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT', N'ObjectName', @ServiceAccount OUTPUT
      


declare @AgtGroup nvarchar(512)
exec master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\Setup', N'AGTGroup', @AgtGroup OUTPUT
      


SELECT
CAST(serverproperty(N'Servername') AS sysname) AS [Name],
ISNULL(tsgsp.msx_server_name,N'') AS [MsxServerName],
tsgsp.sqlagent_type AS [JobServerType],
CAST(tsgsp.sqlserver_restart AS bit) AS [SqlServerRestart],
CAST(tsgsp.monitor_autostart AS bit) AS [SqlAgentRestart],
tsgsp.jobhistory_max_rows AS [MaximumHistoryRows],
tsgsp.jobhistory_max_rows_per_job AS [MaximumJobHistoryRows],
tsgsp.errorlog_file AS [ErrorLogFile],
tsgsp.errorlogging_level AS [AgentLogLevel],
ISNULL(tsgsp.error_recipient,N'') AS [NetSendRecipient],
tsgsp.job_shutdown_timeout AS [AgentShutdownWaitTime],
ISNULL(tsgsp.email_profile,N'') AS [SqlAgentMailProfile],
CAST(tsgsp.email_save_in_sent_folder AS bit) AS [SaveInSentFolder],
CAST(tsgsp.oem_errorlog AS bit) AS [WriteOemErrorLog],
CAST(tsgsp.cpu_poller_enabled AS bit) AS [IsCpuPollingEnabled],
tsgsp.idle_cpu_percent AS [IdleCpuPercentage],
tsgsp.idle_cpu_duration AS [IdleCpuDuration],
tsgsp.login_timeout AS [LoginTimeout],
ISNULL(tsgsp.host_login_name,N'') AS [HostLoginName],
ISNULL(tsgsp.local_host_server,N'') AS [LocalHostAlias],
CAST(tsgsp.auto_start AS bit) AS [SqlAgentAutoStart],
CAST(tsgsp.replace_alert_tokens_enabled AS bit) AS [ReplaceAlertTokensEnabled],
ISNULL(@DatabaseMailProfile,N'') AS [DatabaseMailProfile],
ISNULL(@AgentMailType, 0) AS [AgentMailType],
CAST(1 AS bit) AS [SysAdminOnly],
@ServiceStartMode AS [ServiceStartMode],
ISNULL(@ServiceAccount,N'') AS [ServiceAccount],
ISNULL(suser_sname(sid_binary(ISNULL(@AgtGroup,N''))),N'') AS [AgentDomainGroup]
FROM
#tmp_sp_get_sqlagent_properties AS tsgsp

drop table #tmp_sp_get_sqlagent_properties
        
