DECLARE @bd VARCHAR(50)=DB_NAME()

-- para gerar arquivo de trace
SELECT DISTINCT  'exec sp_trace_setfilter @TraceID, 1, 1, 6, N''%'+Object+'%''' /*,object,event*/
FROM (
SELECT  *
FROM dbo.HistoricoVersaoObjeto 
WHERE Event NOT IN ('alter_table','create_table','CREATE_INDEX','ALTER_EXTENDED_PROPERTY','CREATE_EXTENDED_PROPERTY')
AND event NOT LIKE 'DROP%'
AND Object NOT LIKE 'sp_MSupd_dbo%'
AND Object NOT LIKE 'sp_MSins_dbo%'
AND Object NOT LIKE 'sp_MSdel_dbo%'
AND Object NOT LIKE 'syncobj_%'
) AS b
WHERE b.DataAlteracao>'2013-08-01'
GO


-- Para pegar da sys.objects
DECLARE @bd VARCHAR(50)=DB_NAME()

-- para gerar arquivo de trace
SELECT DISTINCT  'exec sp_trace_setfilter @TraceID, 1, 1, 6, N''%'+name+'%''' /*,object,event*/,type,modify_date
FROM (
SELECT  *
FROM sys.objects
WHERE (modify_date> '2013-11-01' OR create_date > '2013-11-01')
AND type NOT IN ('U','IT','D','PK','F','UQ','TT','TR','V','C')
AND name NOT LIKE 'sp_ms%'
AND name NOT LIKE 'syncobj%'
) AS b
GO

-- para gerar arquivo de backup
SELECT  'C:\Dropbox\SQL\backups\ScriptingProcs.bat "' + sp.name  + '"'
FROM
sys.all_objects AS sp
LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id
LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id
WHERE 1=1
--(sp.type = N'P' OR sp.type = N'RF' OR sp.type='PC')
--AND name NOT LIKE 'sp_%'
AND sp.name IN 
(
	SELECT  object
	FROM dbo.HistoricoVersaoObjeto 
	WHERE Event NOT IN ('alter_table','create_table','CREATE_INDEX','ALTER_EXTENDED_PROPERTY','CREATE_EXTENDED_PROPERTY')
	AND Object NOT LIKE 'sp_MSupd_dbo%'
	AND Object NOT LIKE 'sp_MSins_dbo%'
	AND Object NOT LIKE 'sp_MSdel_dbo%'
	AND Object NOT LIKE 'syncobj_%'
	AND DataAlteracao>'2013-07-13'
)


DECLARE @bd VARCHAR(50)=DB_NAME()
IF db_name() LIKE '%corp%' SET @bd='corp' ELSE SET @bd='loja'
--------------------------

-- para gerar pt/pr
SELECT 'PT:',1 AS ordem
UNION

SELECT DISTINCT CASE 
				WHEN type = 'P' then 'Fazer backup da procedure '
				WHEN type = 'TR' then 'Fazer backup da trigger ' 
				WHEN type = 'V' then 'Fazer backup da View ' 
				WHEN type = 'FN' then 'Fazer backup da function ' 
				WHEN type = 'IF' then 'Fazer backup da function ' 
				WHEN type = 'U' then 'Fazer backup da tabela ' 
				ELSE 'Fazer backup do objeto '
				end + Object + ' se existir no banco ' + @bd
, 2 AS ordem
FROM (
SELECT  *
FROM dbo.HistoricoVersaoObjeto 
WHERE Event NOT IN ('alter_table','create_table','CREATE_INDEX','ALTER_EXTENDED_PROPERTY','CREATE_EXTENDED_PROPERTY')
AND Object NOT LIKE 'sp_MSupd_dbo%'
AND Object NOT LIKE 'sp_MSins_dbo%'
AND Object NOT LIKE 'sp_MSdel_dbo%'
AND Object NOT LIKE 'syncobj_%'
--AND DataAlteracao>'2013-06-12'
) AS b,sys.objects o
WHERE b.DataAlteracao>'2013-08-14'
AND b.Object=o.name

UNION
SELECT 'PR:',3 AS ordem
UNION
SELECT DISTINCT CASE 
				WHEN type = 'P' then 'Fazer restore da procedure '
				WHEN type = 'TR' then 'Fazer restore da trigger ' 
				WHEN type = 'V' then 'Fazer restore da View ' 
				WHEN type = 'FN' then 'Fazer restore da function ' 
				WHEN type = 'IF' then 'Fazer restore da function ' 
				WHEN type = 'U' then 'Fazer restore da tabela ' 
				ELSE 'Fazer restore do objeto ' 
				end + Object + ' no banco ' + @bd
, 4 AS ordem
FROM (
SELECT  *
FROM dbo.HistoricoVersaoObjeto 
WHERE Event NOT IN ('alter_table','create_table','CREATE_INDEX','ALTER_EXTENDED_PROPERTY','CREATE_EXTENDED_PROPERTY','CREATE_TRIGGER','ALTER_TRIGGER')
AND Object NOT LIKE 'sp_MSupd_dbo%'
AND Object NOT LIKE 'sp_MSins_dbo%'
AND Object NOT LIKE 'sp_MSdel_dbo%'
AND Object NOT LIKE 'syncobj_%'
) AS b,sys.objects o
WHERE b.DataAlteracao>'2013-08-14'
AND b.Object=o.name

ORDER BY ordem

--SELECT * FROM sys.objects WHERE type_desc LIKE '%function%'