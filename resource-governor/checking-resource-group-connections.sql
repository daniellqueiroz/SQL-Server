SELECT count(*) FROM sys.dm_exec_sessions WHERE login_name='userfast' AND status='running'
SELECT count(*) FROM sys.dm_exec_sessions WHERE login_name='userslow' AND status='running'

SELECT count(*) FROM sys.dm_exec_sessions WHERE login_name='userslow' AND status='sleeping'
SELECT count(*) FROM sys.dm_exec_sessions WHERE login_name='userfast' AND status='sleeping'