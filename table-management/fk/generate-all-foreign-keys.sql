-- run this script to generate a script that will drop and then recreate all your foreign keys
-- this can be useful to generate backups of your constraints allowing you to perform clean up tasks
-- this can also be useful to port your constraints to other environments


IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp
GO

DECLARE @drops VARCHAR(MAX),@creates VARCHAR(MAX),@truncs VARCHAR(MAX)

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
) AS a
ORDER BY Table_Name

SELECT @drops = REPLACE (
	(
	SELECT 'if exists(select * from sys.objects where name='''+ForeignKey_Name+''') alter table ' + Table_Name + ' drop constraint ' + ForeignKey_Name + '|' + CHAR(10)
	FROM #temp
	FOR XML PATH('')
	)
,'|',';');

SELECT @creates = REPLACE (
	(
	SELECT 'if exists(select * from sys.objects where name='''+Table_Name+''') and exists(select * from sys.objects where name ='''+TabelaReferenciada+''') and not exists(select * from sys.objects where name='''+ForeignKey_Name+''') ALTER table ' + Table_Name + ' with nocheck add constraint ' + ForeignKey_Name + ' foreign key (' + CampoChave + ') references ' + TabelaReferenciada + '(' + CamposReferenciados + ')' + '|' + CHAR(10)
	FROM #temp
	FOR XML PATH('')
	)
,'|',';');


declare @VeryLongText nvarchar(max) = ''

SELECT top 100 @VeryLongText =  @VeryLongText + @drops + @creates 
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('')