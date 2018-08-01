-- Good basic information about OS memory amounts and state  (Query 34) (System Memory)
SELECT total_physical_memory_kb/1024 AS [Physical Memory (MB)], 
       available_physical_memory_kb/1024 AS [Available Memory (MB)], 
       total_page_file_kb/1024 AS [Total Page File (MB)], 
	   available_page_file_kb/1024 AS [Available Page File (MB)], 
	   system_cache_kb/1024 AS [System Cache (MB)],
       system_memory_state_desc AS [System Memory State]
FROM sys.dm_os_sys_memory WITH (NOLOCK) OPTION (RECOMPILE);
-- You want to see "Available physical memory is high"
-- This indicates that you are not under external memory pressure

SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1048576 AS [Physical Memory (MB)], 
sqlserver_start_time, affinity_type_desc 
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);


-- Focus on
-- backup compression default
-- cost threshold for parallelism
-- clr enabled (only enable if it is needed)
-- lightweight pooling (should be zero)
-- max degree of parallelism (depends on your workload)
-- max server memory (MB) (set to an appropriate value)
-- optimize for ad hoc workloads (should be 1)
-- priority boost (should be zero)
-- Get information on location, time and size of any memory dumps from SQL Server (SQL Server 2008 R2 SP1 or greater)  (Query 15) (Memory Dump Info)
SELECT [filename], creation_time, size_in_bytes/1048576.0 AS [Size (MB)]
FROM sys.dm_server_memory_dumps WITH (NOLOCK) 
ORDER BY creation_time DESC OPTION (RECOMPILE);


-- Get total buffer usage by database for current instance  (Query 26) (Total Buffer Usage by Database)
-- This make take some time to run on a busy instance
WITH AggregateBufferPoolUsage
AS
(SELECT DB_NAME(database_id) AS [Database Name],
CAST(COUNT(*) * 8/1024.0 AS DECIMAL (10,2))  AS [CachedSize]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
WHERE database_id <> 32767 -- ResourceDB
GROUP BY DB_NAME(database_id))

SELECT ROW_NUMBER() OVER(ORDER BY CachedSize DESC) AS [Buffer Pool Rank], [Database Name], CachedSize AS [Cached Size (MB)],
       CAST(CachedSize / SUM(CachedSize) OVER() * 100.0 AS DECIMAL(5,2)) AS [Buffer Pool Percent]
FROM AggregateBufferPoolUsage
ORDER BY [Buffer Pool Rank] OPTION (RECOMPILE);
-- Tells you how much memory (in the buffer pool) 
-- is being used by each database on the instance


-- SQL Server Process Address space info  (Query 35) (Process Memory) 
-- (shows whether locked pages is enabled, among other things)
SELECT physical_memory_in_use_kb/1024 AS [SQL Server Memory Usage (MB)],
       large_page_allocations_kb, locked_page_allocations_kb, page_fault_count, 
	   memory_utilization_percentage, available_commit_limit_kb, 
	   process_physical_memory_low, process_virtual_memory_low
FROM sys.dm_os_process_memory WITH (NOLOCK) OPTION (RECOMPILE);
-- You want to see 0 for process_physical_memory_low
-- You want to see 0 for process_virtual_memory_low
-- This indicates that you are not under internal memory pressure



-- Page Life Expectancy (PLE) value for each NUMA node in current instance  (Query 36) (PLE by NUMA Node)
SELECT @@SERVERNAME AS [Server Name], [object_name], instance_name, cntr_value AS [Page Life Expectancy]
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] LIKE N'%Buffer Node%' -- Handles named instances
AND counter_name = N'Page life expectancy' OPTION (RECOMPILE);
-- PLE is a good measurement of memory pressure.
-- Higher PLE is better. Watch the trend over time, not the absolute value.
-- This will only return one row for non-NUMA systems.


-- Memory Grants Pending value for current instance  (Query 37) (Memory Grants Pending)
SELECT @@SERVERNAME AS [Server Name], [object_name], cntr_value AS [Memory Grants Pending]                                                                                                       
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] LIKE N'%Memory Manager%' -- Handles named instances
AND counter_name = N'Memory Grants Pending' OPTION (RECOMPILE);
-- Memory Grants Pending above zero for a sustained period is a very strong indicator of memory pressure


-- Memory Clerk Usage for instance  (Query 38) (Memory Clerk Usage)
-- Look for high value for CACHESTORE_SQLCP (Ad-hoc query plans)
SELECT TOP(10) [type] AS [Memory Clerk Type], SUM(single_pages_kb)/1024 AS [SPA Memory Usage (MB)] 
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
GROUP BY [type]  
ORDER BY SUM(single_pages_kb) DESC OPTION (RECOMPILE);
-- CACHESTORE_SQLCP  SQL Plans         
-- These are cached SQL statements or batches that aren't in stored procedures, functions and triggers
-- Watch out for high values for CACHESTORE_SQLCP
-- CACHESTORE_OBJCP  Object Plans      
-- These are compiled plans for stored procedures, functions and triggers


-- Memory Object Usage for instance (Query 39) (Memory Object Usage)
SELECT TOP(20) mo.[type] AS [Memory Object Type], 
COUNT(*) AS [Memory Object Count],
CAST((SUM (mo.page_size_in_bytes) / 1048576.0) AS DECIMAL (15,2)) AS [Memory Usage (MB)], 
mc.[type] AS [Memory Clerk Type]
FROM sys.dm_os_memory_objects AS mo WITH (NOLOCK)
INNER JOIN sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
ON mo.page_allocator_address = mc.page_allocator_address
GROUP BY mc.type, mo.[type]
ORDER BY [Memory Usage (MB)] DESC OPTION (RECOMPILE);
-- This query gives you more insight about your memory usage by object


-- Find single-use, ad-hoc and prepared queries that are bloating the plan cache  (Query 40) (Ad hoc Queries)
SELECT TOP(50) [text] AS [QueryText], cp.cacheobjtype, cp.objtype, cp.size_in_bytes/1024 AS [Plan Size in KB]
FROM sys.dm_exec_cached_plans AS cp WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cp.cacheobjtype = N'Compiled Plan' 
AND cp.objtype IN (N'Adhoc', N'Prepared') 
AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC OPTION (RECOMPILE);

-- Gives you the text, type and size of single-use ad-hoc and prepared queries that waste space in the plan cache
-- Enabling 'optimize for ad hoc workloads' for the instance can help (SQL Server 2008 and above only)
-- Running DBCC FREESYSTEMCACHE ('SQL Plans') periodically may be required to better control this.
-- Enabling forced parameterization for the database can help, but test first!