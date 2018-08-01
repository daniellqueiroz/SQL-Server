USE [Credit];
GO

CREATE PROCEDURE [dbo].[CheckForPlanCachePollution]
AS 
SELECT [Cache Type] = [cp].[objtype] 
	, [Total Plans] = COUNT_BIG (*) 
	, [Total MBs]
		= SUM (CAST ([cp].[size_in_bytes] 
			AS DECIMAL (18, 2))) / 1024.0 / 1024.0 
	, [Avg Use Count] 
		= AVG ([cp].[usecounts]) 
	, [Total MBs - USE Count 1]
		= SUM (CAST ((CASE WHEN [cp].[usecounts] = 1 
		THEN [cp].[size_in_bytes] ELSE 0 END) 
			AS DECIMAL (18, 2))) / 1024.0 / 1024.0
	, [Total Plans - USE Count 1]
		= SUM (CASE WHEN [cp].[usecounts] = 1 
				THEN 1 ELSE 0 END) 
	, [Percent Wasted]
		= (SUM (CAST ((CASE WHEN [cp].[usecounts] = 1 
			THEN [cp].[size_in_bytes] ELSE 0 END) 
			AS DECIMAL (18, 2))) 
		 / SUM ([cp].[size_in_bytes])) * 100
FROM [sys].[dm_exec_cached_plans] AS [cp]
GROUP BY [cp].[objtype]
ORDER BY [Total MBs - USE Count 1] DESC;
GO

CREATE PROCEDURE [dbo].[GetDemoQueryTimes]
AS 
SELECT [qh].*, [qp].query_plan
FROM (SELECT [cp].[objtype]
		, [Query Hash] = [qs2].[query_hash] 
		, [Query Plan Hash] = [qs2].[query_plan_hash] 
		, [Total MB] = SUM ([cp].[size_in_bytes]) /
			1024.00 / 1024.00
		, [Avg CPU Time]
			= SUM ([qs2].[total_worker_time]) /
				SUM ([qs2].[execution_count])	
		, [Execution Total]
			= SUM ([qs2].[execution_count]) 
		, [Total Cost]
			= SUM ([qs2].[total_worker_time]) 
		, [Example Statement Text] 
			= MIN ([qs2].[statement_text]) 
		, [plan_handle] = MIN ([qs2].[plan_handle])
		, [statement_start_offset] =
			MIN ([qs2].[statement_start_offset]) 
	FROM (SELECT [qs].*,  
			SUBSTRING ([st].[text], 
				([qs].[statement_start_offset] / 2) + 1, 
			((CASE [statement_end_offset] WHEN -1 THEN
				DATALENGTH ([st].[text]) 
				ELSE [qs].[statement_end_offset] END - 
					[qs].[statement_start_offset]) / 2) + 1) 
					AS [statement_text]
			FROM [sys].[dm_exec_query_stats] AS [qs] 
				CROSS APPLY [sys].[dm_exec_sql_text] 
					([qs].[sql_handle]) AS [st]
			WHERE [st].[text] LIKE '%member%'
				AND [st].[text] NOT LIKE '%dm_exec%') AS [qs2]
			INNER JOIN [sys].[dm_exec_cached_plans] AS [cp]
				ON [qs2].[plan_handle] = [cp].[plan_handle]
			GROUP BY [cp].[objtype], [qs2].[query_hash],
				[qs2].[query_plan_hash]) AS [qh]
CROSS APPLY [sys].[dm_exec_query_plan] 
					([qh].[plan_handle]) AS [qp]
-- For the demo, use the ORDER BY [Example Statement Text]
ORDER BY [Example Statement Text]
-- For the real-world, use the following order by:
-- ORDER BY [qh].[Total Cost] DESC
;
GO