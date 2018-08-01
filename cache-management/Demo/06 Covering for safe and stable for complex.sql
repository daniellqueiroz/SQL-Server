-----------------------------------------------------------------
-- Course: SQL Server: Optimizing Ad Hoc Statement Performance
-- Module: Statement Execution Methods
--   Demo: Covering can make simple statements safe 
--         and complex statements stable (but not safe)
-----------------------------------------------------------------

-- First, run the Sample Database Setup script for Credit
-- Script: CreditDemoDatabaseSetup.sql

USE [Credit];
GO

----------------------------------
--   Demo: Covering can make simple statements safe 
--         and complex statements stable (but not safe)
----------------------------------

-- These procedures are just so that we can easily see
-- information from cache without having to run the same
-- queries over and over again...

-- And, if you want to dive into the sizes and amount of
-- data in the cache:
CREATE PROCEDURE [QuickCheckOnCacheWSize]
    @StringToFind   NVARCHAR (4000)
AS
SELECT [cp].[objtype]
	, [cp].[cacheobjtype]
	, [cp].[size_in_bytes]
	, [cp].[refcounts]
	, [cp].[usecounts]
	, [st].[text]
FROM sys.dm_exec_cached_plans AS [cp]
CROSS APPLY sys.dm_exec_sql_text ([cp].[plan_handle]) AS [st]
WHERE [cp].[objtype] IN (N'Adhoc', N'Prepared')
	AND [st].[text] LIKE @StringToFind 
	AND ([st].[text] NOT LIKE '%syscacheobjects%' 
		OR [st].[text] NOT LIKE '%SELECT%cp.objecttype%')
ORDER BY [cp].[objtype], [cp].[size_in_bytes];
GO 

-- 2008 adds query_hash and query_plan_hash
CREATE PROCEDURE [QuickCheckOnCacheWHashSizeAndPlan]
    @StringToFind   NVARCHAR (4000)
AS
SELECT [st].[text]
	, [qs].[query_hash]
	, [qs].[query_plan_hash]
	, [qs].[execution_count]
	, [qs].[plan_handle]
	, [qs].[statement_start_offset]
	, [qs].*
	, [qp].* 
FROM sys.dm_exec_query_stats AS [qs] 
	CROSS APPLY sys.dm_exec_sql_text ([qs].[sql_handle]) AS [st]
	CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
WHERE [st].[text] LIKE @StringToFind 
	AND ([st].[text] NOT LIKE '%syscacheobjects%'
		OR [st].[text] NOT LIKE '%SELECT%cp.objecttype%')
ORDER BY 1, [qs].[execution_count] DESC;
GO

-- Some quick setup for the example
UPDATE [member]	
SET [lastname] = 'Tripp' 
WHERE [member_no] = 1234;
GO

-- Index on lastnames
CREATE INDEX [LastNameInd] 
ON [dbo].[member] 
	([lastname]);
GO

-- What if we have a query that has different plans?
-- And, it's run frequently...

-- Run a few select statements:
DBCC FREEPROCCACHE;
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Tripp';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Jones';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Smith';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Anderson';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Test';
GO

-- Before showing cache (through the sps)
-- review the inconsistent plans (some use an index,
-- others do a scan)

EXEC [QuickCheckOnCacheWSize] N'%phone_no%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan] N'%phone_no%lastname%';
-- See that the query_hash is the same
-- But, check out the query_plan_hash; this statement
-- has two plans...
-- It's definitely NOT safe!
GO

--------------------------------------------------------
-- What if we can create a "SAFE" and consistent plan?
-- In this case, we might have single plan because of a
-- covering index...
--------------------------------------------------------

-- DROP INDEX [member].[FullNameIndex]
CREATE INDEX [FullNameIndex] 
ON [dbo].[member] 
	([lastname], [firstname])
INCLUDE ([phone_no]);
GO

sp_recompile [member]; -- Sch-M on that table!
GO

-- Re-run the same select statements:
SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Tripp';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Jones';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Smith';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Anderson';
GO

SELECT [m].[lastname], [m].[firstname], [m].[phone_no]
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Test';
GO
-- Before showing cache (through the sps)
-- review the CONSISTENT plans (all use the nonclustered, 
-- covering, seekable index)

EXEC [QuickCheckOnCacheWSize] N'%phone_no%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan] N'%phone_no%lastname%';

-- See that the query_hash is the same
-- And, now there's ONLY one plan is cache... 
-- Wait, why only one?
-- This is ONLY one table... 
-- It's pretty simple and (NOW) we actually
-- meet the definition of SAFE (wow, shocking! :))

-- **THIS** query is NOW safe!
GO

-- But, what if we had a bit more complicated statement:

-- Create an index to make it a very stable/consistent plan:
CREATE INDEX [ChargesByMember] 
ON [charge] ([member_no], [charge_amt]);
GO

-- Next, run a few statements:
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Test' 
	AND [m].[firstname] = 'Bob'
GROUP BY [m].[lastname], [m].[firstname];
GO
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Tripp' 
	AND [m].[firstname] = 'RFCLXE'
GROUP BY [m].[lastname], [m].[firstname];
GO
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Anderson'
	AND [m].[firstname] = 'ITZMOIWZGCSQLO'
GROUP BY [m].[lastname], [m].[firstname];
GO

-- Before showing cache (through the sps)
-- review the CONSISTENT plans (all use the TWO nonclustered, 
-- covering, seekable index)

EXEC [QuickCheckOnCacheWSize] N'%min%charge_amt%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan]
	N'%min%charge_amt%lastname%';

-- See that the query_hash is the same
-- OK, this one IS STABLE but it's not "safe" 
-- How do we deal with this??

-- Will Forced Parameterization save the day?!
ALTER DATABASE [Credit]
	SET PARAMETERIZATION FORCED;
GO

EXEC [QuickCheckOnCacheWSize] N'%min%charge_amt%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan]
	N'%min%charge_amt%lastname%';
GO

-- Next, run those same statements:
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Test' 
	AND [m].[firstname] = 'Bob'
GROUP BY [m].[lastname], [m].[firstname];
GO
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Tripp' 
	AND [m].[firstname] = 'RFCLXE'
GROUP BY [m].[lastname], [m].[firstname];
GO
SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = 'Anderson'
	AND [m].[firstname] = 'ITZMOIWZGCSQLO'
GROUP BY [m].[lastname], [m].[firstname];
GO

EXEC [QuickCheckOnCacheWSize] N'%min%charge_amt%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan]
	N'%min%charge_amt%lastname%';
GO

-- What does forced parameterization do for UNSAFE statements?

SET STATISTICS IO ON;
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Tripp';
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Anderson';
GO

EXEC [QuickCheckOnCacheWSize] N'%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan] N'%lastname%';
GO

-- What's really optimal?
-- Can use OPTION (RECOMPILE) for testing
-- (to see if the plan changes?)
SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Tripp'
OPTION (RECOMPILE);
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Anderson'
OPTION (RECOMPILE);
GO

-- So, what if the Anderson execution
-- runs first?

DBCC FREEPROCCACHE;
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Anderson';
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE [m].[lastname] = 'Tripp';
GO

EXEC [QuickCheckOnCacheWSize] N'%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan] N'%lastname%';
GO

-- SIMPLE isn't good for everthing
--	some statements should be cached
-- FORCED isn't good for everything
--  some statements shouldn't be cached

-- Can use a hybrid approach
--  Ad hoc when it varies
--  sp_executesql when it doesn't

-- The end result - it's often better
-- to keep the database SIMPLE and 
-- force only those statements that are
-- stable

-- Let's go back to SIMPLE parameterization and look
-- at a better option!
ALTER DATABASE [Credit]
	SET PARAMETERIZATION SIMPLE;
GO

-- Next, run those same statements:
DECLARE @ExecStr NVARCHAR (4000);
SELECT @ExecStr = 
'SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = @lastname
	AND [m].[firstname] = @firstname
GROUP BY [m].[lastname], [m].[firstname]'
EXEC [sp_executesql] @ExecStr
	, N'@lastname VARCHAR (15), @firstname VARCHAR (15)'
	, 'Test', 'Bob'
GO
DECLARE @ExecStr NVARCHAR (4000);
SELECT @ExecStr = 
'SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = @lastname
	AND [m].[firstname] = @firstname
GROUP BY [m].[lastname], [m].[firstname]'
EXEC [sp_executesql] @ExecStr
	, N'@lastname VARCHAR (15), @firstname VARCHAR (15)'
	, 'Tripp', 'RFCLXE' 
GO
DECLARE @ExecStr NVARCHAR (4000);
SELECT @ExecStr = 
'SELECT [m].[lastname]
	, [m].[firstname]
	, MIN ([c].[charge_amt])
FROM [dbo].[member] AS [m]
	JOIN [dbo].[charge] AS [c]
		ON [m].[member_no] = [c].[member_no]
WHERE [m].[lastname] = @lastname
	AND [m].[firstname] = @firstname
GROUP BY [m].[lastname], [m].[firstname]'
EXEC [sp_executesql] @ExecStr
	, N'@lastname VARCHAR (15), @firstname VARCHAR (15)'
	, 'Anderson', 'ITZMOIWZGCSQLO'
GO

EXEC [QuickCheckOnCacheWSize] N'%min%charge_amt%lastname%';
EXEC [QuickCheckOnCacheWHashSizeAndPlan]
	N'%min%charge_amt%lastname%';
GO