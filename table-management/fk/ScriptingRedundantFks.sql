-- run this script to drop redundant foreign keys present in your database
-- the script will see which foreign keys have the same definition and leave only one in the end

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
DROP TABLE #temp
GO

SELECT [ForeignKey_Name],[Table_Name],REPLACE([CamposChave],',|','') AS CampoChave,TabelaReferenciada,REPLACE([CamposReferencia],',|','') AS CamposReferenciados,[update_referential_action],[delete_referential_action]
INTO #temp
FROM (
SELECT DISTINCT
--SCHEMA_NAME(tbl.schema_id) AS [Table_Schema],
cstr.name AS [ForeignKey_Name],  
tbl.name AS [Table_Name],  
(SELECT name + ',' AS [data()] FROM sys.foreign_key_columns AS fk1,sys.columns AS cfk1 WHERE 1=1 AND fk1.constraint_object_id=cstr.object_id AND fk1.parent_column_id = cfk1.column_id AND fk1.parent_object_id = cfk1.object_id  FOR XML PATH('')) +'|' AS [CamposChave],  
OBJECT_NAME(fk.referenced_object_id) AS TabelaReferenciada,  
(SELECT name + ',' AS [data()] FROM sys.foreign_key_columns AS fk1,sys.columns AS crk1 WHERE 1=1 AND fk1.constraint_object_id=cstr.object_id AND fk1.referenced_column_id = crk1.column_id AND fk1.referenced_object_id = crk1.object_id  FOR XML PATH('')) +'|' AS [CamposReferencia],  
cstr.[update_referential_action],  
cstr.[delete_referential_action]  
FROM  
sys.tables AS tbl  
INNER JOIN sys.foreign_keys AS cstr ON cstr.parent_object_id=tbl.object_id  
INNER JOIN sys.foreign_key_columns AS fk ON fk.constraint_object_id=cstr.object_id  
WHERE 1=1
AND tbl.name NOT LIKE 'MS%'  
AND tbl.name NOT LIKE 'SYS%'  
AND tbl.name NOT LIKE 'FULLTEXT%'  
AND tbl.name NOT LIKE 'QUEUE%'  
--AND (OBJECT_NAME(fk.referenced_object_id)=@tabela OR OBJECT_NAME(fk.parent_object_id)=@tabela)  
--(tbl.name=N'DominioFiltro' and SCHEMA_NAME(tbl.schema_id)=N'dbo')  
--AND cstr.name = 'FK_Dominio_Regra'
) AS a
order by Table_Name


DECLARE @cmd VARCHAR(8000)
SELECT @cmd = replace (
	(
SELECT 'alter table '+Table_Name+ ' drop constraint '+ ForeignKey_Name + '|' FROM (
SELECT *,ROW_NUMBER() OVER (PARTITION BY [table_name],CampoChave,TabelaReferenciada,CamposReferenciados ORDER BY ForeignKey_Name DESC) AS rn FROM #temp
--WHERE 1=1 AND table_name='Sku'
) AS a
WHERE a.rn>1
FOR XML PATH('')
	)
,'|',';')

--PRINT @cmd;
EXEC (@cmd);
