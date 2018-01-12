-- Query to extract data captured by the [statement_completed] Extended Event (see previous scripts on the same folder for more information on the Event itself)

SELECT * FROM (
SELECT
    theNodes.event_data.value('(data/value)[1]', 'bigint') AS source_database_id,
    theNodes.event_data.value('(data/value)[2]', 'bigint') AS object_id,
    theNodes.event_data.value('(data/value)[3]', 'bigint') AS object_type,
    theNodes.event_data.value('(data/value)[4]', 'bigint') AS cpu,
    theNodes.event_data.value('(data/value)[5]', 'bigint') AS duration,
    theNodes.event_data.value('(data/value)[6]', 'bigint') AS reads,
    theNodes.event_data.value('(data/value)[7]', 'bigint') AS writes,
    theNodes.event_data.value('(action/value)[1]', 'nvarchar(max)') AS sql_text,
    CAST(theNodes.event_data.value('(action/value)[2]', 'nvarchar(max)') AS XML) AS tsql_stack,
    theNodes.event_data.value('(action/value)[3]', 'bigint') AS transaction_id,
    theNodes.event_data.value('(action/value)[4]', 'bigint') AS database_id,
    theNodes.event_data.value('(action/value)[5]', 'nvarchar(max)') AS username
FROM 
(
    SELECT
        CONVERT(XML, st.target_data) AS ring_buffer
    FROM sys.dm_xe_sessions s
    JOIN sys.dm_xe_session_targets st ON
        s.address = st.event_session_address
    WHERE
        s.name = 'statement_completed'
) AS theData
CROSS APPLY theData.ring_buffer.nodes('//RingBufferTarget/event') theNodes (event_data)
) AS tab
WHERE source_database_id=5
and OBJECT_ID=1387567250
--SELECT DB_ID()



---------------------------------------------------------------------------------------------

-- Query to extract data captured by the [error_reported] Extended Event (see previous scripts on the same folder for more information on the Event itself)
SELECT
    theNodes.event_data.value('(data/value)[1]', 'bigint') AS error,
    theNodes.event_data.value('(data/value)[2]', 'bigint') AS severity,
    theNodes.event_data.value('(data/value)[3]', 'bigint') AS state,
    theNodes.event_data.value('(data/value)[4]', 'bit') AS user_defined,
    theNodes.event_data.value('(data/value)[8]', 'nvarchar(max)') AS message,
	theNodes.event_data.value('(action/value)[5]', 'nvarchar(max)') AS sql_text,
    --theNodes.event_data.value('(action/value)[3]', 'nvarchar(max)') AS tsql_stack,
    theNodes.event_data.value('(action/value)[3]', 'nvarchar(max)') AS database_name,
    theNodes.event_data.value('(action/value)[1]', 'nvarchar(max)') AS hostname,
	theNodes.event_data.value('(action/value)[2]', 'nvarchar(max)') AS username

FROM 
(
    SELECT
        CONVERT(XML, st.target_data) AS ring_buffer
    FROM sys.dm_xe_sessions s
    JOIN sys.dm_xe_session_targets st ON
        s.address = st.event_session_address
    WHERE
        s.name = 'error_reported'
) AS theData
CROSS APPLY theData.ring_buffer.nodes('//RingBufferTarget/event') theNodes (event_data)
WHERE 1=1
--AND theNodes.event_data.value('(action/value)[1]', 'nvarchar(max)') LIKE '%Person%'
--AND theNodes.event_data.value('(data/value)[5]', 'nvarchar(max)') LIKE '%invalid%'


---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------

-- Query to extract data captured by the [SortWarning] Extended Event (see previous scripts on the same folder for more information on the Event itself)
SELECT
x.object_name AS event_name,
DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), CURRENT_TIMESTAMP), vent_data.value('(event/@timestamp)[1]', 'datetime')) AS timestamp,
event_data.value('(event/data[@name="sort_warning_type"]/text)[1]', 'varchar(20)') AS sort_warning_type,
event_data.value('(event/action[@name="sql_text"]/value)[1]', 'varchar(max)') AS sql_text,
frame_data.value('./@level','int') AS frame_level,
OBJECT_NAME(st.objectid, st.dbid) AS objectname,
SUBSTRING(st.text, (frame_data.value('./@offsetStart','int')/2)+1,
((CASE frame_data.value('./@offsetEnd','int')
WHEN -1 THEN DATALENGTH(st.text)
ELSE frame_data.value('./@offsetEnd','int')
END - frame_data.value('./@offsetStart','int'))/2) + 1) AS sort_warning_statement
FROM (SELECT object_name, CAST(event_data AS XML) AS event_data
FROM sys.fn_xe_file_target_read_file('C:\Log\SortWarning*.xel',null,null,null)) x
CROSS APPLY x.event_data.nodes('event/action[@name="tsql_frame"]/value/frame') Frame(frame_data)
OUTER APPLY sys.dm_exec_sql_text(CONVERT(varbinary(max), frame_data.value('./@handle','varchar(max)'),1)) st



---------------------------------------------------------------------------------------------