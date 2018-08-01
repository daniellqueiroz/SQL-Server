SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- check the execution plan of your statement to see which hypothetical indexes should be considered
SELECT TOP 10 c.IdCompra FROM Compra c (NOLOCK)
JOIN CompraEntrega ce (NOLOCK) ON c.IdCompra = ce.IdCompra
WHERE FlagCompraSige = 1

-- drop index if exists
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].LogTrocaPagamento') AND name = N'IX_LogTrocaPagamento_DataLog') 
AND OBJECT_ID(N'[dbo].LogTrocaPagamento') IS NOT NULL 
AND COL_LENGTH('LogTrocaPagamento','DataLog')>0
	DROP INDEX IX_Compra_FlagCompraSige ON dbo.Compra
GO

-- create index with the STATISTICS_ONLY clause
CREATE NONCLUSTERED INDEX IX_Compra_FlagCompraSige ON dbo.Compra(FlagCompraSige)
WHERE FlagCompraSige=1
WITH STATISTICS_ONLY = -1
GO

-- cleaning up dbcc autopilot usage for the current database
DBCC AUTOPILOT(5, 5, 0, 0)
GO

-- check the existence of any hypothetical indexes
SELECT dbid = DB_ID(),
       objectid = 
object_id,
       indid = index_id
  FROM sys.indexes
 WHERE 
object_id = 
OBJECT_ID('dbo.compra')
   AND is_hypothetical = 1

-- get the results from the query above and pass them to DBCC AUTOPILOT
DBCC AUTOPILOT(0, 5, 1120723045, 9)
GO

--testing the hypothetical index to see if is actually going to be used
SET AUTOPILOT ON
GO
SELECT TOP 10 c.IdCompra FROM Compra c (NOLOCK)
JOIN CompraEntrega ce (NOLOCK) ON c.IdCompra = ce.IdCompra
WHERE FlagCompraSige = 1
GO
SET AUTOPILOT OFF

