-- run this script to eliminate every object from the database that could have a negative impact on big database loads (constraints, triggers, etc)
-- note that you should back your schema(database structure) before or at least have another database with the same structure where you can get the objects from
-- this script is best used in the case you have to truncate all or some of your tables before importing data from other sources

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
	SELECT 'if exists(select * from sys.objects where name='''+Table_Name+''') and exists(select * from sys.objects where name ='''+TabelaReferenciada+''') and not exists(select * from sys.objects where name='''+ForeignKey_Name+''') ALTER table ' + Table_Name + ' with nocheck with nocheck with nocheck with nocheck with nocheck with nocheck with nocheck add constraint ' + ForeignKey_Name + ' foreign key (' + CampoChave + ') references ' + TabelaReferenciada + '(' + CamposReferenciados + ')' + '|' + CHAR(10)
	FROM #temp
	FOR XML PATH('')
	)
,'|',';');


declare @VeryLongText nvarchar(max) = ''

SELECT top 100 @VeryLongText =  @VeryLongText + @drops --+ @creates 
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('')

EXEC(@drops);
GO


DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT  'drop view ' + OBJECT_NAME(object_id) + '|' + CHAR(10)
	--,*
	FROM sys.indexes WHERE object_id IN (SELECT object_id FROM sys.views)
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)

GO

DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT  'truncate table ' + o.name + '|' + CHAR(10)
	--,*
	FROM sys.objects o 
	WHERE o.type='U'AND o.[schema_id]=SCHEMA_ID('dbo')
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)

GO

DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT  'alter table ' + OBJECT_name(parent_object_id) + ' drop constraint ' + name + '|' + CHAR(10)
	--,*
	FROM sys.check_constraints
	--ORDER BY OBJECT_name(parent_object_id)
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)

GO
DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT ' alter table ' + OBJECT_NAME(parent_object_id) + ' DROP constraint ' + name + '|' + CHAR(10) FROM sys.key_constraints WHERE type='UQ' AND OBJECT_NAME(parent_object_id) IN (SELECT name FROM sys.tables)
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)

GO
DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT 'drop index ' + name + ' on ' + OBJECT_NAME(object_id) + '|' + CHAR(10)
	--,type_desc,OBJECT_NAME(object_id) 
	FROM sys.indexes WHERE is_primary_key=0 AND type_desc = 'nonclustered'
	AND OBJECT_NAME(object_id) IN (SELECT name FROM sys.tables WHERE is_ms_shipped=0)
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)
GO

DECLARE @cmd varchar(MAX)
SELECT @cmd = REPLACE (
(
	SELECT 'drop trigger ' + name + '|' + CHAR(10)
	FROM sys.triggers WHERE 1=1
	AND OBJECT_NAME(parent_id) IN (SELECT name FROM sys.tables WHERE is_ms_shipped=0)
	FOR XML PATH('')
)
,'|',';');
EXEC(@cmd)
GO

--TRUNCATE TABLE dbo.BannerCarrosselItem
/*
SELECT TOP 10 * FROM dbo.DicionarioCaptcha WHERE Palavra='(d''Agua)'
SELECT palavra,COUNT(*) 
FROM dbo.DicionarioCaptcha
GROUP BY Palavra
HAVING	COUNT(*)>1
*/