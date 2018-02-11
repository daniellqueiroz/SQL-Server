-- use this to list all redundant indexes in your database. Get rid of these redundancies by consolidating indexes

SET CONCAT_NULL_YIELDS_NULL OFF
SELECT Banco , name ,Tabela ,user_lookups ,user_scans ,user_seeks ,user_updates ,Vantagem 
,REPLACE([CamposChave],',|','') AS 'CamposChave',REPLACE(IncludedColumns,',|','') AS 'IncludedColumns',filter_definition,b.FileGroup,IS_UNIQUE,ComandoDrop
,'CREATE '+ CASE b.IS_UNIQUE WHEN 'NOT UNIQUE' THEN '' ELSE 'UNIQUE ' END + b.type_desc COLLATE SQL_Latin1_General_CP1_CI_AS + ' INDEX ' + name COLLATE SQL_Latin1_General_CP1_CI_AS + ' ON ' + Tabela COLLATE SQL_Latin1_General_CP1_CI_AS + '('+b.CamposChave COLLATE SQL_Latin1_General_CP1_CI_AS+')' + CASE b.IncludedColumns WHEN '|' THEN '' ELSE ' include ('+b.IncludedColumns COLLATE SQL_Latin1_General_CP1_CI_AS+')' END + CASE WHEN b.filter_definition IS NOT NULL THEN ' where ' + b.filter_definition COLLATE SQL_Latin1_General_CP1_CI_AS ELSE '' + '/* ON '+ b.FileGroup + '*/;' END AS ComandoCreate 

FROM 
(
	SELECT  Banco , name ,Tabela ,user_lookups ,user_scans ,user_seeks ,user_updates ,Vantagem 
	,REPLACE([CamposChave],',|','') AS 'CamposChave',REPLACE(IncludedColumns,',|','') AS 'IncludedColumns',a.filter_definition,IS_UNIQUE,[FileGroup]
	,ComandoDrop,a.type_desc,fill_factor,a.column_id
	FROM 
	(
		SELECT DB_NAME() AS Banco
		,si.name, OBJECT_NAME(si.object_id) AS Tabela, [user_lookups], [user_scans], [user_seeks], [user_updates]
		, CAST( (user_seeks+user_scans) / CASE WHEN user_updates=0 THEN CAST(1.00 AS DECIMAL(15,2)) ELSE CAST(user_updates AS DECIMAL(15,2)) END AS DECIMAL(15,2)) AS Vantagem
		,(SELECT name + CASE sc.is_descending_key WHEN 1 THEN ' DESC' END +',' AS [data()] FROM sys.index_columns sc, sys.columns scc1 WHERE 1=1 AND sc.is_included_column=0 AND sc.index_id=si.index_id AND sc.object_id=si.object_id AND scc1.column_id=sc.column_id AND scc1.object_id=sc.object_id FOR XML PATH('')) +'|' AS CamposChave
		,(SELECT name +',' AS [data()] FROM sys.index_columns sc, sys.columns scc1 WHERE 1=1 AND sc.is_included_column=1 AND sc.index_id=si.index_id AND sc.object_id=si.object_id AND scc1.column_id=sc.column_id AND scc1.object_id=sc.object_id FOR XML PATH('')) +'|' AS IncludedColumns
		,si.filter_definition,si.fill_factor,CASE WHEN si.is_unique=1 OR si.is_unique_constraint=1 THEN 'UNIQUE ' ELSE 'NOT UNIQUE ' END AS IS_UNIQUE,f.name AS [FileGroup]
		,si.type_desc,sic.column_id
		,'IF exists(select 1 from sys.indexes where name = '''+si.name+''') /*and db_name()='''+DB_NAME()+'''*/ drop index ' + si.name + ' on ' + OBJECT_NAME(si.object_id) +';' AS ComandoDrop
		FROM sys.dm_db_index_usage_stats ius 
		RIGHT JOIN sys.indexes si ON ius.index_id = si.index_id AND si.object_id = ius.object_id
		INNER JOIN sys.objects o ON o.object_id=si.object_id
		INNER JOIN sys.filegroups f ON si.data_space_id = f.data_space_id
		INNER JOIN sys.index_columns sic ON sic.object_id = si.object_id AND sic.index_id = si.index_id
		INNER JOIN (
			SELECT sic2.object_id,sic2.column_id
			FROM sys.index_columns sic2 
			WHERE sic2.object_id=OBJECT_ID('Sku')
			AND sic2.is_included_column=0
			AND sic2.key_ordinal=1
			GROUP BY sic2.object_id,sic2.column_id
			HAVING COUNT(*)>1
		) AS a ON a.column_id = sic.column_id
		WHERE 1=1
		AND database_id = DB_ID()
		AND sic.is_included_column=0
		AND sic.key_ordinal=1
		AND o.is_ms_shipped=0
		--AND si.name = 'IX_CompraStatusLog_IdCompra'
		AND OBJECT_NAME(si.object_id) = 'Sku'
		
	)AS a
	WHERE 1=1
) AS b
ORDER BY b.column_id

