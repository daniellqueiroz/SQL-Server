SET CONCAT_NULL_YIELDS_NULL OFF
SELECT DISTINCT Banco , name ,Tabela ,user_lookups ,user_scans ,user_seeks ,user_updates ,Vantagem ,fill_factor
,REPLACE([CamposChave],',|','') AS 'CamposChave',REPLACE(IncludedColumns,',|','') AS 'IncludedColumns',filter_definition,b.FileGroup,IS_UNIQUE,ComandoDrop
,'CREATE '+ CASE b.IS_UNIQUE WHEN 'NOT UNIQUE' THEN '' ELSE 'UNIQUE ' end + b.type_desc COLLATE SQL_Latin1_General_CP1_CI_AS + ' INDEX ' + name COLLATE SQL_Latin1_General_CP1_CI_AS + ' ON ' + Tabela COLLATE SQL_Latin1_General_CP1_CI_AS + '('+b.CamposChave COLLATE SQL_Latin1_General_CP1_CI_AS+')' + CASE b.IncludedColumns WHEN '|' THEN '' ELSE ' include ('+b.IncludedColumns COLLATE SQL_Latin1_General_CP1_CI_AS+')' END + CASE WHEN b.filter_definition IS NOT NULL THEN ' where ' + b.filter_definition COLLATE SQL_Latin1_General_CP1_CI_AS ELSE '' + '/* ON '+ b.FileGroup + '*/;' END AS ComandoCreate 

FROM 
(
	SELECT  Banco , name ,Tabela ,user_lookups ,user_scans ,user_seeks ,user_updates ,Vantagem ,REPLACE([CamposChave],',|','') AS 'CamposChave',REPLACE(IncludedColumns,',|','') AS 'IncludedColumns',a.filter_definition,IS_UNIQUE,[FileGroup],ComandoDrop,a.type_desc,fill_factor
	FROM 
	(
		SELECT DB_NAME() AS Banco
		,si.name, OBJECT_NAME(si.object_id) AS Tabela, [user_lookups], [user_scans], [user_seeks], [user_updates]
		, CAST( (user_seeks+user_scans) / CASE WHEN user_updates=0 then CAST(1.00 AS decimal(15,2)) else CAST(user_updates AS decimal(15,2)) END AS decimal(15,2)) AS Vantagem
		,(SELECT name + CASE sc.is_descending_key WHEN 1 THEN ' DESC' END +',' AS [data()] FROM sys.index_columns sc, sys.columns scc1 WHERE 1=1 AND sc.is_included_column=0 AND sc.index_id=si.index_id AND sc.object_id=si.object_id AND scc1.column_id=sc.column_id AND scc1.object_id=sc.object_id FOR XML PATH('')) +'|' AS CamposChave
		,(SELECT name +',' AS [data()] FROM sys.index_columns sc, sys.columns scc1 WHERE 1=1 AND sc.is_included_column=1 AND sc.index_id=si.index_id AND sc.object_id=si.object_id AND scc1.column_id=sc.column_id AND scc1.object_id=sc.object_id FOR XML PATH('')) +'|' AS IncludedColumns
		,si.filter_definition,si.fill_factor,CASE WHEN si.is_unique=1 OR si.is_unique_constraint=1 THEN 'UNIQUE ' ELSE 'NOT UNIQUE ' END AS IS_UNIQUE,f.name AS [FileGroup]
		,si.type_desc
		,'IF exists(select 1 from sys.indexes where name = '''+si.NAME+''') /*and db_name()='''+DB_NAME()+'''*/ drop index ' + si.name + ' on ' + OBJECT_NAME(si.object_id) +';' AS ComandoDrop
		FROM sys.dm_db_index_usage_stats ius 
		right JOIN sys.indexes si ON ius.index_id = si.index_id AND si.object_id = ius.object_id
		inner JOIN sys.objects o ON o.OBJECT_ID=si.object_id
		INNER JOIN sys.filegroups f ON si.data_space_id = f.data_space_id
		WHERE 1=1
		AND database_id = DB_ID()
		--and user_seeks = 0 AND user_lookups = 0 AND user_scans = 0 
		AND o.is_ms_shipped=0
		--AND user_updates > 0
		--AND is_primary_key = 0
		--AND si.is_unique=0
		--AND user_updates < 5000
		--AND si.name = 'IX_CompraStatusLog_IdCompra'
		and OBJECT_NAME(si.object_id) = 'compra'
	)AS a
	WHERE 1=1
	AND (
			(a.CamposChave like '%DataAprovacao%' )
			--OR 
			--(a.IncludedColumns like '%IdFabricante%' OR a.IncludedColumns LIKE '%IdFornecedor%')
		)
	--AND vantagem < 1
) AS b
ORDER BY [user_updates] DESC, [name] DESC 

