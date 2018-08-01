-----------------------------------------------------------------
-- Course: SQL Server: Optimizing Ad Hoc Statement Performance
-- Module: Statement Caching
--   Demo: Analyzing query_hash and query_plan_hash
-----------------------------------------------------------------

----------------------------------
-- MUST BE RUN AFTER THE PRIOR DEMO
--   Demo: Ad Hoc Statements and the Plan Cache
----------------------------------

USE [Credit];
GO

-- Here's what we saw in the last demo:
EXEC [QuickCheckOnCacheWSize] N'%m_unsafe%';
EXEC [QuickCheckOnCacheWSizeAndPlan] N'%m_unsafe%';
GO

-- What's in cache for queries
SELECT [st].[text], [qs].*
FROM [sys].[dm_exec_query_stats] AS [qs] 
	CROSS APPLY [sys].[dm_exec_sql_text]
		 ([qs].[sql_handle]) AS [st]
WHERE [st].[text] LIKE N'%m_unsafe%';

-- Notice that these two new queries have the same query_hash 
-- but NOT the same query_plan_hash

-- Also, add in the database ID for the entity location
-- and/or to restrict this to only one database
-- Use: sys.dm_exec_plan_attributes

SELECT DB_NAME (CONVERT (INT, [pa].[value])) AS [Database Name]
	, [st].[text]
	, [qs].[query_hash]
	, [qs].[query_plan_hash]
	, [qs].[execution_count]
	, [qs].[plan_handle]
	, [qs].[statement_start_offset]
	, [qs].*
	, [qp].* 
FROM [sys].[dm_exec_query_stats] AS [qs] 
	CROSS APPLY [sys].[dm_exec_sql_text]
		 ([qs].[sql_handle]) AS [st]
	CROSS APPLY [sys].[dm_exec_query_plan]
		 ([qs].[plan_handle]) AS [qp]
	CROSS APPLY [sys].[dm_exec_plan_attributes]
		 ([qs].[plan_handle]) AS [pa]
WHERE [st].[text] LIKE N'%member%' 
	AND [st].[text] NOT LIKE N'%syscacheobjects%'
	AND [pa].[attribute] = N'dbid' 
	-- AND [pa].[value] = DB_ID () 
	-- This last expression should be uncommented if you 
	-- only want to see the current database's queries
ORDER BY 2, [qs].[execution_count] DESC;
GO

-- Let's get an overall picture of how many 
-- plans EACH query_hash has?
SELECT [qs].[query_hash]
    , [Distinct Plan Count] 
		= COUNT (DISTINCT [qs].[query_plan_hash])
    , [Execution Total]
		= SUM([qs].[execution_count]) 
FROM [sys].[dm_exec_query_stats] AS [qs] 
GROUP BY [qs].[query_hash]
ORDER BY [Execution Total] DESC;
GO

-- When the "Distinct Plan Count" is mostly 1 for your queries
-- then you MIGHT consider using forced parameterization.

-- However, before you turn this on - you might want to get
-- more details about the queries that have MULTIPLE plans

-- Review a sampling of the queries (grouping by the query_hash)
-- and see which have the highest *Avg* CPU Time:
SELECT [Query Hash] = [qs2].[query_hash] 
	, [Query Plan Hash]
		= [qs2].[query_plan_hash]
	, [Avg CPU Time]
		= SUM ([qs2].[total_worker_time]) /
		  SUM ([qs2].[execution_count]) 
	, [Example Statement Text]
		= MIN ([qs2].[statement_text])
 FROM (SELECT [qs].*,  
        [statement_text] = SUBSTRING ([st].[text], 
			([qs].[statement_start_offset] / 2) + 1
	    	, ((CASE [statement_end_offset] 
				WHEN - 1 THEN DATALENGTH ([st].[text]) 
				ELSE [qs].[statement_end_offset] 
				END 
		        - [qs].[statement_start_offset]) / 2) + 1) 
		FROM [sys].[dm_exec_query_stats] AS [qs] 
			CROSS APPLY [sys].[dm_exec_sql_text]
				 ([qs].[sql_handle]) AS [st]) AS [qs2]
GROUP BY [qs2].[query_hash]
	, [qs2].[query_plan_hash] 
ORDER BY [Avg CPU Time] DESC;
GO

-- Review a sampling of the queries (grouping by the query_hash)
-- and see which have the highest cumulative effect by CPU Time:
SELECT [qs2].[query_hash] AS [Query Hash]
	, SUM ([qs2].[total_worker_time])
		AS [Total CPU Time - Cumulative Effect]
	, COUNT (DISTINCT [qs2].[query_plan_hash])
		AS [Number of plans] 
	, SUM ([qs2].[execution_count]) AS [Number of executions] 
	, MIN ([qs2].[statement_text]) AS [Example Statement Text]
 FROM (SELECT [qs].*,  
        [statement_text] = SUBSTRING ([st].[text], 
			([qs].[statement_start_offset] / 2) + 1
	    	, ((CASE [statement_end_offset] 
				WHEN - 1 THEN DATALENGTH ([st].[text]) 
				ELSE [qs].[statement_end_offset] 
				END 
		        - [qs].[statement_start_offset]) / 2) + 1) 
		FROM [sys].[dm_exec_query_stats] AS [qs] 
			CROSS APPLY [sys].[dm_exec_sql_text]
				 ([qs].[sql_handle]) AS [st]) AS [qs2]
GROUP BY [qs2].[query_hash] 
ORDER BY [Total CPU Time - Cumulative Effect] DESC;
GO