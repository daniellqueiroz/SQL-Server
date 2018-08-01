/*

Remarks:

1. These scripts will create Extended Events for the purpose of monitoring

*/

CREATE EVENT SESSION [statement_completed]
ON SERVER
ADD EVENT sqlserver.sp_statement_completed 
    (
        ACTION (sqlserver.sql_text, sqlserver.tsql_stack, sqlserver.transaction_id, 
		sqlserver.database_id, sqlserver.username)
        WHERE sqlserver.session_id = 215
    )  
    ADD TARGET package0.ring_buffer    
        (SET max_memory = 4096) 
WITH (max_dispatch_latency = 1 seconds);

ALTER EVENT SESSION statement_completed
ON SERVER STATE =START

ALTER EVENT SESSION [statement_completed]
ON SERVER STATE=STOP;

DROP EVENT SESSION [statement_completed] ON SERVER;

-------------------------------- stack trace ------------------------------------------------------------------------------------------------

CREATE EVENT SESSION RingBufferExampleSession ON SERVER 
    ADD EVENT sqlserver.sp_statement_completed 
    (
        ACTION (sqlserver.sql_text, sqlserver.tsql_stack, sqlserver.transaction_id, 
		sqlserver.database_id, sqlserver.username)
        WHERE sqlserver.database_id = 8
    )  
    ADD TARGET package0.ring_buffer    
        (SET max_memory = 4096) 
WITH (max_dispatch_latency = 1 seconds)


ALTER EVENT SESSION RingBufferExampleSession ON SERVER STATE =START
DROP EVENT SESSION RingBufferExampleSession ON SERVER;
ALTER EVENT SESSION RingBufferExampleSession ON SERVER STATE=STOP;

------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------- error reported ------------------------------------------------------------------------------------------------

CREATE EVENT SESSION [error_reported] ON SERVER 
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_hostname,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack,sqlserver.username)
    WHERE ([package0].[equal_uint64]([sqlserver].[database_id],(7)) AND [package0].[not_equal_int64]([error_number],(313)) AND [package0].[greater_than_int64]([severity],(10)) AND [error_number]<>(22803))) 
ADD TARGET package0.ring_buffer(SET max_memory=(4096))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=1 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


ALTER EVENT SESSION error_reported ON SERVER STATE =START
ALTER EVENT SESSION error_reported ON SERVER STATE=STOP;
DROP EVENT SESSION error_reported ON SERVER;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------- LongRunning Sessions
CREATE EVENT SESSION LongDuration 
ON SERVER 
    ADD EVENT sqlserver.sql_statement_completed 
        ( 
            ACTION (sqlserver.sql_text, sqlserver.tsql_stack, sqlserver.username) 
            WHERE sqlserver.database_id = 8 
		AND sqlserver.sql_statement_completed.duration > 500000 
        ) 
    ADD TARGET package0.ring_buffer    
        (SET max_memory = 4096) 
WITH (max_dispatch_latency = 1 seconds) ;


ALTER EVENT SESSION LongDuration ON SERVER STATE =START
ALTER EVENT SESSION LongDuration ON SERVER STATE=STOP;
DROP EVENT SESSION LongDuration ON SERVER;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------- SortWarning
IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='SortWarning')
DROP EVENT SESSION [MultipleDataFiles] ON SERVER;
-- Create Event Session SortWarning
CREATE EVENT SESSION SortWarning ON SERVER
ADD EVENT sqlserver.sort_warning(
ACTION(sqlserver.sql_text,sqlserver.tsql_frame)
WHERE (sqlserver.database_id=(7))) -- replace database_id
ADD TARGET package0.event_file(SET filename = N'C:\Log\SortWarning.xel',max_file_size=(100))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS)
GO
-- Start the Event Session
ALTER EVENT SESSION SortWarning
ON SERVER
STATE=START
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------- Querying the Default Extended Events
SELECT  CAST(event_data.value('(event/data/value)[1]', 'varchar(max)') AS XML) AS DeadlockGraph,*
FROM    
( 
	SELECT XEvent.query('.') AS event_data
	FROM 
	( -- Cast the target_data to XML
		SELECT CAST(target_data AS XML) AS TargetData
		FROM sys.dm_xe_session_targets st
		JOIN sys.dm_xe_sessions s
		ON s.address = st.event_session_address
		WHERE name = 'system_health'
		AND target_name = 'ring_buffer'
	) AS Data -- Split out the Event Nodes
	CROSS APPLY TargetData.nodes('RingBufferTarget/event[@name="xml_deadlock_report"]')
	AS XEventData ( XEvent )
) AS tab ( event_data )
WHERE event_data.exist('deadlock/process-list/process[@status="background"]') = 0

----------------------------------------------------------------------------------------------------------------------------------------------------------------