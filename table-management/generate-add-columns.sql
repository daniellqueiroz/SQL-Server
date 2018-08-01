-- use this script to generate the add column comand to synchronize columns between two databases

--connect to source db here

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp;

SELECT 'if not exists (SELECT * FROM SYS.columns WHERE NAME = '''+sc.name+ ''' AND object_id=object_id('''+OBJECT_NAME(sc.object_id)+''')) and object_id('''+OBJECT_NAME(sc.object_id)+''') is not null alter table '+OBJECT_NAME(sc.object_id)+ ' add [' + sc.name + '] ' + st.name 
+ CASE st.name 
WHEN 'BIT' THEN ' NULL ' 
WHEN 'INT' THEN ' NULL ' 
WHEN 'BIGINT' THEN ' NULL ' 
WHEN 'SMALLINT' THEN ' NULL ' 
WHEN 'TINYINT' THEN ' NULL ' 
WHEN 'Money' THEN ' NULL ' 
WHEN 'smalldatetime' THEN ' NULL ' 
WHEN 'datetime' THEN ' NULL ' 
WHEN 'sysname' THEN ' NULL ' 
WHEN 'XML' THEN ' NULL ' 
WHEN 'Datetime2' THEN '(' + CAST(sc.scale AS VARCHAR(50)) + ')'
WHEN 'decimal' THEN '(' + CAST(sc.precision AS VARCHAR(50)) + ',' + CAST(sc.scale AS VARCHAR(50)) + ')'
WHEN 'numeric' THEN '(' + CAST(sc.precision AS VARCHAR(50)) + ',' + CAST(sc.scale AS VARCHAR(50)) + ')'
ELSE '('+ CASE CAST(sc.max_length AS VARCHAR(50)) WHEN -1 THEN 'max' ELSE CAST(sc.max_length AS VARCHAR(50)) END +')'  END AS CREATEC
--,SC.scale
,OBJECT_NAME(sc.object_id) AS Tabela
,sc.name
,sc.column_id

INTO #temp
FROM [CPRDC1VOPSSQL1].DHLWebShip.sys.columns sc,[CPRDC1VOPSSQL1].DHLWebShip.sys.types st ,[CPRDC1VOPSSQL1].DHLWebShip.sys.tables o

WHERE 1=1
--AND OBJECT_NAME(sc.object_id)='IntegracaoEstoqueTemp'
AND sc.system_type_id=st.system_type_id
AND st.is_user_defined=0
AND sc.object_id=o.object_id
AND o.is_ms_shipped=0


-- connect to destination db here

--SELECT TOP 10 * FROM #temp

DECLARE @cmd VARCHAR(MAX)
SELECT @cmd = REPLACE (
	(
	SELECT CREATEC + ' | ' 
	FROM #temp a
	INNER JOIN sys.objects o ON a.Tabela = o.name AND o.type='U'
	WHERE 1=1
	AND NOT EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela AND sc1.name = a.name)
	AND EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela )
	ORDER BY a.Tabela,a.column_id
	FOR XML PATH('')
	)
,'|',';')


--EXEC (@cmd) /*uncomment this to automatically execute the command*/
SELECT @cmd

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp;
GO




-- deleting columns that do not exist in the source db

USE db_prd_loja; --put source db here

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp;

SELECT 'if exists (SELECT * FROM SYS.columns WHERE NAME = '''+sc.name+ ''' AND object_id=object_id('''+OBJECT_NAME(sc.object_id)+''')) alter table '+OBJECT_NAME(sc.object_id)+ ' drop column [' + sc.name + '] ' AS DROPC
--,SC.scale
,OBJECT_NAME(sc.object_id) AS Tabela
,sc.name
,sc.column_id

INTO #temp
FROM sys.columns sc,sys.types st ,sys.tables o

WHERE 1=1
--AND OBJECT_NAME(object_id)='FreteValorAtacado'
AND sc.system_type_id=st.system_type_id
AND st.is_user_defined=0
AND sc.object_id=o.object_id
AND o.is_ms_shipped=0

USE db_prd_corp; --put destination db here
--SELECT DROPC FROM #temp a
--WHERE 1=1
--AND NOT EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela AND sc1.name = a.name)
--AND EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela )


DECLARE @cmd VARCHAR(MAX)
SELECT @cmd = REPLACE (
	(
	SELECT DROPC + ' | ' FROM #temp a
	WHERE 1=1
	AND NOT EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela AND sc1.name = a.name)
	AND EXISTS (SELECT OBJECT_NAME(sc1.object_id) FROM sys.columns sc1 WHERE OBJECT_NAME(sc1.object_id) = a.Tabela )
	ORDER BY a.Tabela,a.column_id
	FOR XML PATH('')
	)
,'|',';')

USE db_stg_extra_hist;
EXEC (@cmd)
--SELECT @cmd

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp;
GO

