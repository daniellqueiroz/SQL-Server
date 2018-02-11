--USE db_prd_loja

-- use this script to drop any auto_created statistics. Before droping, you should check statistics usage to see if any of them are actually useful
-- I created this scripts to get rid of statistics that were slowing down statistics update processes
DECLARE @RETORNO VARCHAR(3000)
SET @RETORNO =    REPLACE(
       REPLACE(
          (
			SELECT 'drop statistics ' + OBJECT_NAME(sys.columns.object_id) + '.' + sys.stats.name --,sys.stats.*
			FROM  sys.stats
			INNER JOIN sys.stats_columns
			ON stats.object_id = stats_columns.object_id
			AND stats.stats_id = stats_columns.stats_id
			INNER JOIN sys.columns
			ON stats_columns.object_id = COLUMNS.object_id
			AND stats_columns.column_id = COLUMNS.column_id
			INNER JOIN sys.objects
			ON stats.object_id = objects.object_id
			WHERE sys.columns.name = 'idproduto'
			AND sys.columns.object_id = OBJECT_ID('produto')
			AND (sys.stats.name LIKE '%dta%' OR sys.stats.auto_created = 1)
			  FOR XML PATH
             ),'</row>', ';'
           ),'<row>',''
       )

--SELECT @RETORNO

IF @RETORNO IS NOT NULL
BEGIN
	SELECT LEFT(@RETORNO,LEN(@RETORNO)- 2) AS idcolecoes
	EXEC (@retorno)
END
