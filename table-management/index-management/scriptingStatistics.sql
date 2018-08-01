
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].pegarStats') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].pegarStats AS' 
END
GO
ALTER PROCEDURE pegarStats (@tabela VARCHAR(100))
AS
BEGIN
	SELECT DISTINCT OBJECT_NAME(sys.stats.object_id) AS Table_Name,
	sys.columns.name AS Column_Name
	,sys.stats.name AS Stats_Name
	FROM sys.stats
	INNER JOIN sys.stats_columns
	ON stats.object_id = stats_columns.object_id
	AND stats.stats_id = stats_columns.stats_id
	INNER JOIN sys.columns
	ON stats_columns.object_id = COLUMNS.object_id
	AND stats_columns.column_id = COLUMNS.column_id
	INNER JOIN sys.objects
	ON stats.object_id = objects.object_id
	LEFT OUTER JOIN sys.indexes
	ON sys.stats.name = sys.indexes.name
	WHERE sys.objects.type = 'U'
	AND sys.objects.name =@tabela
	ORDER BY Column_Name
	--GROUP BY sys.columns.name,Schema_name(sys.objects.schema_id) + '.' + Object_Name(sys.stats.object_id)--,sys.stats.Name
	--HAVING COUNT(*) > 1
END

-- run this to get the space used by all tables inside the database. This temp table will be used in the next scripts
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
DROP TABLE #temp
BEGIN
	CREATE TABLE #temp (
	table_name sysname ,
	row_count INT,
	reserved_size VARCHAR(50),
	data_size VARCHAR(50),
	index_size VARCHAR(50),
	unused_size VARCHAR(50))
	SET NOCOUNT ON
	INSERT #temp
	EXEC sp_MSforeachtable 'sp_spaceused ''?'''
END
GO

-- run this to get a list of all automatically created statistics for tables that have less than 20000 rows
-- You can specify your own threshold and custom filters
-- I created those to analyse statistics that are unnecessary and that did not comply with internal naming standars (one of the columns in the result set will have the command to create the stats with the proper name)
WITH tab1 (Table_Name,column_name,Stats_Name) AS
(

	SELECT DISTINCT OBJECT_NAME(sys.stats.object_id) AS Table_Name,
	sys.columns.name AS Column_Name
	,sys.stats.name AS Stats_Name
	FROM sys.stats
	INNER JOIN sys.stats_columns
	ON stats.object_id = stats_columns.object_id
	AND stats.stats_id = stats_columns.stats_id
	INNER JOIN sys.columns
	ON stats_columns.object_id = COLUMNS.object_id
	AND stats_columns.column_id = COLUMNS.column_id
	INNER JOIN sys.objects
	ON stats.object_id = objects.object_id
	LEFT OUTER JOIN sys.indexes
	ON sys.stats.name = sys.indexes.name
	WHERE sys.objects.type = 'U'
	--AND sys.objects.name = 'Arquivo'
	--ORDER BY Table_Name
	--GROUP BY sys.columns.name,Schema_name(sys.objects.schema_id) + '.' + Object_Name(sys.stats.object_id)--,sys.stats.Name
	--HAVING COUNT(*) > 1
),
tab2  AS
(
	SELECT Table_Name,column_name FROM tab1
	--WHERE Stats_Name LIKE '_WA%'
	GROUP BY Table_Name,column_name
	HAVING COUNT(*) > 1
)


SELECT DISTINCT sys.stats.name AS Stats_Name, tab2.column_name, tab2.Table_Name, 'drop statistics ' + tab2.Table_Name + '.' + sys.stats.name
,'select count(*) from ' + tab2.Table_Name, 'exec pegarstats '''+ tab2.Table_Name + ''''
,'create statistics ' + tab2.Table_Name + '_' + tab2.column_name + ' on ' + tab2.Table_Name + '(' + tab2.column_name + ')'
FROM tab2, #temp, sys.stats
INNER JOIN sys.stats_columns
ON stats.object_id = stats_columns.object_id
AND stats.stats_id = stats_columns.stats_id
INNER JOIN sys.columns
ON stats_columns.object_id = COLUMNS.object_id
AND stats_columns.column_id = COLUMNS.column_id
INNER JOIN sys.objects
ON stats.object_id = objects.object_id
LEFT OUTER JOIN sys.indexes
ON sys.stats.name = sys.indexes.name
WHERE tab2.Table_Name = sys.objects.name
AND sys.columns.name = column_name
AND sys.stats.name LIKE '_WA%'
AND tab2.Table_Name NOT LIKE 'sys%'
AND tab2.Table_Name NOT LIKE 'MS%' 
AND #temp.table_name = tab2.Table_Name
AND #temp.row_count < 200000 --specify your rowcount threshold here
ORDER BY tab2.Table_Name

GO


--- QUERY PARA PEGAR A DATA DA ÚLTIMA ATUALIZAÇÃO DE ESTATÍSTICAS
--- query to get the last statistics update date
SELECT name AS index_name,
STATS_DATE(object_id, index_id) AS StatsUpdated
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.compraentrega') --specify your table here
ORDER BY name
GO

