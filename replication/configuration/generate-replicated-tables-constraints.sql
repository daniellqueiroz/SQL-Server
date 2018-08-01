/*
use this script to generate all foreign keys for all replicated tables. This can be useful for synchronization, troubleshooting and migration purposes. 
Note that the databases (publisher and subscriber) must be on the same instance for this to work

*/

USE db_prd_corp

SET NOCOUNT ON
GO
IF OBJECT_ID('tempdb..#inserts') IS NOT NULL
	DROP TABLE #inserts
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp
GO
IF OBJECT_ID('tempdb..#tabelas') IS NOT NULL
	DROP TABLE #tabelas
GO

DECLARE @drops VARCHAR(MAX),@creates VARCHAR(MAX),@truncs VARCHAR(MAX), @tabelas VARCHAR(MAX)= 'audit_log_data';
DECLARE @tabela NVARCHAR(200)='',@campo NVARCHAR(300)='',@insert VARCHAR(MAX)='',@select VARCHAR(MAX)=''
,@cmd1 VARCHAR(MAX)='',@count VARCHAR(MAX)='',@campo1 VARCHAR(200)='',@countcampo TINYINT=0,@i TINYINT=0,@identity BIT=0
,@publicacao VARCHAR(50)='corp_outros_npc',@servidor VARCHAR(100),@banco VARCHAR(50)='db_prd_Corp'

SET @servidor =(SELECT QUOTENAME(@@servername))
IF @@servername ='CL-HL-HSQLWEB01\HSQLWEB01' SET @banco='DB_HOM_CORP_NPC' ELSE IF @@servername ='CL-HL-DSQLWEB01\DSQLWEB01' SET @banco='db_des_corp' ELSE IF @@servername ='swat-hlg001' SET @banco='db_hom_corp_swat' 

CREATE TABLE #inserts (tabela VARCHAR(200),comando VARCHAR(MAX),inserti VARCHAR(MAX),Ordem TINYINT IDENTITY(1,1))
CREATE TABLE #temp (
ForeignKey_Name	sysname	NOT NULL,
Table_Name	sysname	NOT NULL,
CampoChave	VARCHAR(1000)	NULL,
TabelaReferenciada	VARCHAR(1000)	NULL,
CamposReferenciados	VARCHAR(1000)	NULL,
update_referential_action	TINYINT	NULL,
delete_referential_action	TINYINT	NULL)


SELECT DISTINCT
a.name tabela 
INTO #tabelas
FROM dbo.sysarticlecolumns ac
INNER JOIN sys.columns sc
ON ac.colid = sc.column_id
INNER JOIN dbo.sysarticles a
ON ac.artid = a.artid
AND a.name = OBJECT_NAME(sc.object_id)
INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
AND  i.object_id = sc.object_id
AND i.is_primary_key=1
--AND a.name='Produto'
WHERE 1=1
AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
AND a.name NOT IN 
	(
	SELECT DISTINCT tabela 
	FROM 
	(
		SELECT *,ROW_NUMBER() OVER(PARTITION BY tabela ORDER BY campo) AS rn
		FROM 
		(
			SELECT DISTINCT a.name tabela,sc.name campo
			FROM dbo.sysarticlecolumns ac
			INNER JOIN sys.columns sc
			ON ac.colid = sc.column_id
			INNER JOIN dbo.sysarticles a
			ON ac.artid = a.artid
			AND a.name = OBJECT_NAME(sc.object_id)
			INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
			INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
			INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
			AND  i.object_id = sc.object_id
			AND i.is_primary_key=1
			WHERE 1=1
			AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
			--and a.pubid = (select pubid from dbo.syspublications where name = 'corp_b2c')
		
		) AS a 
	) AS b WHERE rn>1
	)

USE db_prd_loja

INSERT INTO #temp
	        ( ForeignKey_Name ,
	          Table_Name ,
	          CampoChave ,
	          TabelaReferenciada ,
	          CamposReferenciados ,
	          update_referential_action ,
	          delete_referential_action
	        )
	
	SELECT [ForeignKey_Name],[Table_Name],REPLACE([CamposChave],',|','') AS CampoChave,TabelaReferenciada,REPLACE([CamposReferencia],',|','') AS CamposReferenciados,[update_referential_action],[delete_referential_action]
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
	AND (
			OBJECT_NAME(fk.referenced_object_id) IN (SELECT * FROM #tabelas)
			OR 
			OBJECT_NAME(fk.parent_object_id)  IN (SELECT * FROM #tabelas)
		)  
	--(tbl.name=N'DominioFiltro' and SCHEMA_NAME(tbl.schema_id)=N'dbo')  
	--AND cstr.name = 'FK_Dominio_Regra'
	) AS a
	ORDER BY Table_Name

	SELECT @drops = REPLACE (
		(
		SELECT 'if exists(select * from sys.objects where name='''+ForeignKey_Name+''') alter table ' + Table_Name + ' drop constraint ' + ForeignKey_Name + '|'+ CHAR(10)
		FROM #temp
		FOR XML PATH('')
		)
	,'|',';');

	

		SELECT @creates = REPLACE (
		(
		SELECT  'if exists(select * from sys.objects where name='''+Table_Name+''') and exists(select * from sys.objects where name ='''+TabelaReferenciada+''') and not exists(select * from sys.objects where name='''+ForeignKey_Name+''') ALTER table ' + Table_Name + ' with nocheck add constraint ' + ForeignKey_Name + ' foreign key (' + CampoChave + ') references ' + TabelaReferenciada + '(' + CamposReferenciados + ')' + '|' +CHAR(10) 
		FROM #temp
		FOR XML PATH('')
		)
	,'|',';');

	--select @drops +CHAR(10) + CHAR(13)
	--UNION
	--SELECT @creates


DECLARE @VeryLongText NVARCHAR(MAX) = ''

SELECT TOP 100 @VeryLongText =  @VeryLongText + @drops + @creates 
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('')

