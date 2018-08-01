-- Examine buffer pool usage (run in the target database)
-- use this to see the amount of free space on the index. This can help see if you need to tweak the fillfactor property of your index
SELECT
	[s].[name] AS [Schema],
    [o].[name] AS [Object],
    [p].[index_id],
    [i].[name] AS [Index],
    [i].[type_desc] AS [Type],
    (DPCount + CPCount) * 8 / 1024 AS [TotalMB],
    ([DPFreeSpace] + [CPFreeSpace]) / 1024 / 1024 AS [FreeSpaceMB],
    CAST (ROUND (100.0 * (([DPFreeSpace] + [CPFreeSpace]) / 1024) /
		(([DPCount] + [CPCount]) * 8), 1) AS DECIMAL (4, 1)) AS [FreeSpacePC]
FROM
    (SELECT
        allocation_unit_id,
        SUM (CASE WHEN ([is_modified] = 1)
            THEN 1 ELSE 0 END) AS [DPCount], 
        SUM (CASE WHEN ([is_modified] = 1)
            THEN 0 ELSE 1 END) AS [CPCount],
        SUM (CASE WHEN ([is_modified] = 1)
            THEN CAST ([free_space_in_bytes] AS BIGINT) ELSE 0 END) AS [DPFreeSpace], 
        SUM (CASE WHEN ([is_modified] = 1)
            THEN 0 ELSE CAST ([free_space_in_bytes] AS BIGINT) END) AS [CPFreeSpace]
    FROM sys.dm_os_buffer_descriptors
    WHERE [database_id] = DB_ID()
    GROUP BY [allocation_unit_id]) AS [buffers]
INNER JOIN sys.allocation_units AS [au]
    ON [au].[allocation_unit_id] = [buffers].[allocation_unit_id]
INNER JOIN sys.partitions AS [p]
    ON [au].[container_id] = [p].[partition_id]
INNER JOIN sys.indexes AS [i]
    ON [i].[index_id] = [p].[index_id] AND [p].[object_id] = [i].[object_id]
INNER JOIN sys.objects AS [o]
    ON [o].[object_id] = [i].[object_id]
INNER JOIN sys.schemas AS [s]
    ON [s].[schema_id] = [o].[schema_id]
WHERE [o].[is_ms_shipped] = 0
--AND [p].[object_id] > 100 AND ([DPCount] + [CPCount]) > 12800 -- Taking up more than 100MB
AND o.object_id = (SELECT object_id('CompraFormaPagamento'))
ORDER BY [FreeSpaceMB] DESC
OPTION(RECOMPILE);
GO

--Storing the desired object id
DECLARE @obid BIGINT = (SELECT object_id('CompraFormaPagamento'));

-- Look at the fragmentation again
SELECT
	OBJECT_NAME ([ips].[object_id]) AS [Object Name],
	[si].[name] AS [Index Name],
	ROUND ([ips].[avg_fragmentation_in_percent], 2) AS [Fragmentation],
	[ips].[page_count] AS [Pages],
	ROUND ([ips].[avg_page_space_used_in_percent], 2) AS [Page Density]
FROM sys.dm_db_index_physical_stats (
	DB_ID(),
	@obid,
	NULL,
	NULL,
	N'DETAILED') [ips]
CROSS APPLY [sys].[indexes] [si]
WHERE
	[si].[object_id] = [ips].[object_id]
	AND [si].[index_id] = [ips].[index_id]
	AND [ips].[index_level] = 0 -- Just the leaf level
	AND [ips].[alloc_unit_type_desc] = N'IN_ROW_DATA'
	--AND si.object_id=object_id('CompraFormaPagamento')
	--AND ips.object_id=object_id('CompraFormaPagamento')
OPTION(RECOMPILE);
GO



--Trace flag is required for undocumented DBCC output
DBCC TRACEON (3604);
GO

-- Undocumented command to list interesting pages
DBCC SEMETADATA (N'CompraFormaPagamento');
GO

-- Dump the root page
DBCC PAGE (N'db_prd_loja', 1, 19919, 3); -- first parameter should be the name of your database
GO


-- Investigate the transaction_log Extended Event (for future XE creation)
SELECT 
    [oc].[name], 
    [oc].[type_name], 
    [oc].[description]
FROM sys.dm_xe_packages AS [p]
INNER JOIN sys.dm_xe_objects AS [o]
    ON [p].[guid] = [o].[package_guid]
INNER JOIN sys.dm_xe_object_columns AS [oc]
    ON [oc].[object_name] = [o].[name]
		AND [oc].[object_package_guid] = [o].[package_guid]
WHERE [o].[name] = N'transaction_log'
	AND [oc].[column_type] = N'data';
GO

SELECT *
FROM sys.dm_xe_map_values
WHERE [name] = N'log_op'
	AND [map_value] like N'%SPLIT%';
GO

DROP EVENT SESSION [TrackPageSplits] ON SERVER;
GO

-- Create the Event Session to track LOP_DELETE_SPLIT transaction_log
-- operations in the server
CREATE EVENT SESSION [TrackPageSplits] ON SERVER
ADD EVENT [sqlserver].[transaction_log] (
    WHERE [operation] = 11  -- LOP_DELETE_SPLIT 
		AND [database_id] = 5 -- CHANGE THIS BASED ON TOP SPLITTING DATABASE!
)
ADD TARGET [package0].[histogram] (
    SET filtering_event_name = 'sqlserver.transaction_log',
        source_type = 0, -- Event Column
        source = 'alloc_unit_id');
GO

-- Start the Event Session again
ALTER EVENT SESSION [TrackPageSplits] ON SERVER
STATE = START;
GO


-- Query Target Data to get the top splitting objects in the database:
SELECT
	[s].[name] AS [schema_name],
    [o].[name] AS [table_name],
    [i].[name] AS [index_name],
    [tab].[split_count],
    [i].[fill_factor]
FROM (
	SELECT 
		[n].[value] ('(value)[1]', 'bigint') AS [alloc_unit_id],
		[n].[value] ('(@count)[1]', 'bigint') AS [split_count]
	FROM (
		SELECT CAST ([target_data] as XML) [target_data]
		FROM sys.dm_xe_sessions AS [s] 
		JOIN sys.dm_xe_session_targets [t]
			ON [s].[address] = [t].[event_session_address]
		WHERE [s].[name] = 'TrackPageSplits'
		AND [t].[target_name] = 'histogram'
	) as [tab]
	CROSS APPLY [target_data].[nodes] ('HistogramTarget/Slot') AS [q] ([n])
) AS [tab]
JOIN sys.allocation_units AS [au]
    ON [tab].[alloc_unit_id] = [au].[allocation_unit_id]
JOIN sys.partitions AS [p]
    ON [au].[container_id] = [p].[partition_id]
JOIN sys.indexes AS [i]
    ON [p].[object_id] = [i].[object_id]
        AND [p].[index_id] = [i].[index_id]
JOIN sys.objects AS [o]
    ON [p].[object_id] = [o].[object_id]
JOIN sys.schemas AS [s]
    ON [o].[schema_id] = [s].[schema_id]
WHERE [o].[is_ms_shipped] = 0;
GO


-- Now look in the transaction log
SELECT
    [AllocUnitName] AS N'Index',
    (CASE [Context]
        WHEN N'LCX_INDEX_LEAF' THEN N'Nonclustered'
        WHEN N'LCX_CLUSTERED' THEN N'Clustered'
        ELSE N'Non-Leaf'
    END) AS [SplitType],
    COUNT (1) AS [SplitCount]
FROM
    fn_dblog (NULL, NULL)
WHERE
    [Operation] = N'LOP_DELETE_SPLIT'
GROUP BY [AllocUnitName], [Context];
GO
