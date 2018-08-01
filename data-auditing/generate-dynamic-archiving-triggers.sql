--use this script to dinamycally generate triggers that will move/copy changed data to a archiving database (or other destination) in real time
--this can be used as a solution to create a history of changes in your data
--use this solution with caution (you do not want to create to many triggers with too much logic in high volatile tables)

DECLARE @tabelas VARCHAR(100), @campos VARCHAR(2000),@comando VARCHAR(MAX)='';
DECLARE c CURSOR FAST_FORWARD FOR
SELECT 
--TOP 1 
name,REPLACE([Campos],',|','') AS 'Campos' 
FROM (
SELECT t.name
,(SELECT name + ',' AS [data()] FROM sys.columns sc WHERE 1=1 AND sc.object_id=t.object_id FOR XML PATH('')) +'|' AS Campos
FROM sys.tables t
WHERE name LIKE 'Reg%'
) AS a
--RegChaveGrupoFiltro

OPEN c
FETCH NEXT FROM c INTO @tabelas, @campos
WHILE @@FETCH_STATUS <> -1 
BEGIN
	SET @comando = @comando + 'IF OBJECT_ID(''tr_'+@tabelas+'_UpdateDelete'') IS NOT NULL'+ CHAR(10)+ 'DROP TRIGGER '+ 'tr_'+@tabelas+'_UpdateDelete' + CHAR(10) + 'GO'+ CHAR(10)
	SET @comando = @comando + 'CREATE TRIGGER ' + 'tr_'+@tabelas+'_UpdateDelete ON ' + @tabelas + CHAR(10) + 'FOR UPDATE,DELETE' + CHAR(10) + 'AS' + CHAR(10) + 'BEGIN' + CHAR(10)
	SET @comando = @comando + 'BEGIN TRY' + CHAR(10)
	SET @comando = @comando + 'INSERT INTO db_hom_corp_hist.dbo.'+@tabelas+'('+@campos+')' + CHAR(10) + 'SELECT ' +@campos+ ' FROM deleted' + CHAR(10) 
	SET @comando = @comando + 'END TRY' + CHAR(10)
	SET @comando = @comando + 'BEGIN CATCH' + CHAR(10)
	SET @comando = @comando + '--A EXCESSAO E IGNORADA PARA QUE NAO HAJA ERRO NA APLICACAO. A AUDITORIA E SECUNDARIA NESTE CASO.' + CHAR(10)
	SET @comando = @comando + 'RETURN;' + CHAR(10)
	SET @comando = @comando + 'END CATCH' + CHAR(10) + 'END' + CHAR(10)+ 'GO'+ CHAR(10)+ CHAR(10)

FETCH NEXT FROM c INTO @tabelas, @campos
END
CLOSE c
DEALLOCATE c

declare @VeryLongText nvarchar(max) = ''

SELECT top 100 @VeryLongText =  @VeryLongText + @comando
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('')

GO



SELECT 
--TOP 1 
'update top (1) '+ name + ' set ' + REPLACE([Campos],',|','') AS 'Campos' 
,'select * from db_hom_corp_hist.dbo.'+a.name
,'truncate table '+a.name
--name,REPLACE([Campos],',|','') AS 'Campos' 
FROM (
SELECT t.name
,(SELECT name + ' = ' + name + ' ,' AS [data()] FROM sys.columns sc WHERE 1=1 AND sc.is_identity=0 AND sc.object_id=t.object_id FOR XML PATH('')) +'|' AS Campos
FROM sys.tables t
WHERE name LIKE 'Reg%'
) AS a