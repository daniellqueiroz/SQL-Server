--use this script to dinamycally generate procedures that will move data to a archiving database (or other destination)
-- this can be usefull when you have tons and tons of tables that need to be archived due to space constraints

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

SET @comando = @comando + 'IF OBJECT_ID(''GeraHistoricoRegionalizacao'') IS NOT NULL'+ CHAR(10)+ 'DROP PROCEDURE GeraHistoricoRegionalizacao' + CHAR(10) + 'GO'+ CHAR(10)
SET @comando = @comando + 'CREATE PROCEDURE ' + 'GeraHistoricoRegionalizacao AS ' + CHAR(10) + 'BEGIN' + CHAR(10)

OPEN c
FETCH NEXT FROM c INTO @tabelas, @campos
WHILE @@FETCH_STATUS <> -1 
BEGIN
	
	
	SET @comando = @comando + 'INSERT INTO db_hom_corp_hist.dbo.'+@tabelas+'('+@campos+')' + CHAR(10) + 'SELECT ' +@campos+ ' FROM db_hom_corp_swat.dbo.'+@tabelas + CHAR(10) + CHAR(10) 
	

FETCH NEXT FROM c INTO @tabelas, @campos
END
CLOSE c
DEALLOCATE c

SET @comando = @comando + 'END' + CHAR(10)+ 'GO'+ CHAR(10)+ CHAR(10)

declare @VeryLongText nvarchar(max) = ''

SELECT top 100 @VeryLongText =  @VeryLongText + @comando
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('')

GO


/*
SELECT 
--TOP 1 
'update top (1) '+ name + ' set ' + REPLACE([Campos],',|','') AS 'Campos' 
,'select * from db_hom_corp_hist.dbo.'+a.name
,'truncate table '+a.name
,'select count(*) from '+a.name
--name,REPLACE([Campos],',|','') AS 'Campos' 
FROM (
SELECT t.name
,(SELECT name + ' = ' + name + ' ,' AS [data()] FROM sys.columns sc WHERE 1=1 AND sc.is_identity=0 AND sc.object_id=t.object_id FOR XML PATH('')) +'|' AS Campos
FROM sys.tables t
WHERE name LIKE 'Reg%'
) AS a
*/