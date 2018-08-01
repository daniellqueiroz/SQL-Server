/*
Remarks:

1. You should be sysadmin to run this script
2. This script will help you determine if you suffer from cache bloating by plans used only once. You also have an option of creating a automated process to clean the ad-hoc cache to reclaim memory space for more important processes.
3. You should enable advanced options with sp_configure. For that run the code below
	exec sp_configure 'show advanced options',1
	reconfigure

4. For more information, read the information on the links by the end of this script
*/


USE [master];
GO

IF OBJECTPROPERTY (OBJECT_ID ('sp_SQLskills_CheckPlanCache'),
		'IsProcedure') = 1
	DROP PROCEDURE [sp_SQLskills_CheckPlanCache];
GO

CREATE PROCEDURE [dbo].[sp_SQLskills_CheckPlanCache]
	(@Percent	DECIMAL (6,3) OUTPUT,
	 @WastedMB	DECIMAL (19,3) OUTPUT)
AS
SET NOCOUNT ON;

DECLARE @ConfiguredMemory	DECIMAL (19,3)
	, @PhysicalMemory		DECIMAL (19,3)
	, @MemoryInUse			DECIMAL (19,3)
	, @SingleUsePlanCount	BIGINT;

CREATE TABLE #ConfigurationOptions
(
	[name]				NVARCHAR (35)
	, [minimum]			INT
	, [maximum]			INT
	, [config_value]	INT				-- in bytes
	, [run_value]		INT				-- in bytes
);
INSERT #ConfigurationOptions 
	EXEC ('sp_configure ''max server memory''');

SELECT @ConfiguredMemory 
		= [c].[run_value]/1024/1024 
FROM #ConfigurationOptions AS [c]
WHERE [c].[name] = 'max server memory (MB)'

SELECT @PhysicalMemory 
		= [omem].[total_physical_memory_kb] / 1024 
FROM [sys].[dm_os_sys_memory] AS [omem]

SELECT @MemoryInUse 
	= [pmem].[physical_memory_in_use_kb] / 1024 
FROM [sys].[dm_os_process_memory] AS [pmem]

SELECT @WastedMB 
			= SUM (CAST ((CASE 
				WHEN [cp].[usecounts] = 1 
					AND [cp].[objtype] 
						IN ('Adhoc', 'Prepared') 
				THEN [cp].[size_in_bytes] ELSE 0 END) 
					AS DECIMAL (18,2))) / 1024 / 1024 
	, @SingleUsePlanCount 
			= SUM (CASE 
				WHEN [cp].[usecounts] = 1 
					AND [cp].[objtype] 
						IN ('Adhoc', 'Prepared') 
				THEN 1 ELSE 0 END)
	, @Percent = @WastedMB/@MemoryInUse * 100
FROM [sys].[dm_exec_cached_plans] AS [cp]

SELECT	[TotalPhysicalMemory (MB)] = @PhysicalMemory
	, [TotalConfiguredMemory (MB)] = @ConfiguredMemory
	, [MaxMemoryAvailableToSQLServer (%)] =
		@ConfiguredMemory / @PhysicalMemory * 100
	, [MemoryInUseBySQLServer (MB)] = @MemoryInUse
	, [TotalSingleUsePlanCache (MB)] = @WastedMB
	, [TotalNumberOfSingleUsePlans] = @SingleUsePlanCount
	, [PercentOfConfiguredCacheWastedForSingleUsePlans (%)] 
		= @Percent
GO

/**** begining of optional command. This is to make the procedure you just created a system object so you don't have to be connected to master database when you run it ****/
EXEC [sys].[sp_MS_marksystemobject] 
	'sp_SQLskills_CheckPlanCache';
GO
/**** end of optional command ****/

-----------------------------------------------------------------
-- Next put this logic in an Agent job, set the values
-- to define when cache should be cleared, and then
-- automate it to run every so often (based on how fast 
-- your cache fills with useless single-use plans). 
-- It's an inexpensive check so checking every few hours
-- is reasonable.
-----------------------------------------------------------------

DECLARE @Percent		DECIMAL (6, 3)
		, @WastedMB		DECIMAL (19,3)
		, @StrMB		NVARCHAR (20)
		, @StrPercent	NVARCHAR (20);

EXEC [sp_SQLskills_CheckPlanCache] 
	  @Percent OUTPUT
	, @WastedMB OUTPUT;

SELECT @StrMB = CONVERT (NVARCHAR (20), @WastedMB)
		, @StrPercent = CONVERT (NVARCHAR (20), @Percent);

IF @Percent > 10 OR @WastedMB > 2000 -- 2GB
	BEGIN
		DBCC FREESYSTEMCACHE('SQL Plans') 
		RAISERROR ('%s MB (%s percent) was allocated to single-use plan cache. Single-use plans have been cleared.'
			, 10, 1, @StrMB, @StrPercent)
	END
ELSE
	BEGIN
		RAISERROR ('Only %s MB (%s percent) is allocated to single-use plan cache - no need to clear cache now.'
			, 10, 1, @StrMB, @StrPercent)
			-- Note: this is only a warning message and not an actual error.
	END;
GO

-- Blog post for more options
-- http://bit.ly/18fKtDE