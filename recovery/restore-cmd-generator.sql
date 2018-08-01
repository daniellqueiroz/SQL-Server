
/*
RESTORE DATABASE db_hom_extra_swat 
FROM  DISK = 'j:\dados03\pad.bak' 
WITH 
MOVE 'Plataforma' TO 'J:\DADOS05\db_hom_extra_swat\Plataforma.mdf',
MOVE 'ftrow_e-Plataforma' TO 'J:\DADOS05\db_hom_extra_swat\ftrow_e-Plataforma.mdf',
MOVE 'ftrow_e-Plataforma-Busca' TO 'J:\DADOS05\db_hom_extra_swat\ftrow_e-Plataforma-Busca.mdf',
MOVE 'ftrow_e-Plataforma-Cliente' TO 'J:\DADOS05\db_hom_extra_swat\ftrow_e-Plataforma-Cliente.mdf',
MOVE 'Plataforma_log' TO 'J:\DADOS05\db_hom_extra_swat\Plataforma_log.ldf',
stats=10,REPLACE

*/


USE master
GO

DECLARE @Moves sysname,@dname sysname
DECLARE c CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT DISTINCT
--af.name,
--af.filename,
(SELECT 'MOVE ''' + scc1.name + ''' TO ''' + scc1.filename +''',' AS [data()] FROM sys.sysaltfiles scc1 WHERE 1=1 AND scc1.dbid=d.database_id FOR XML PATH('')) AS Moves
,d.name
FROM sys.databases d 
WHERE 1=1
AND d.name IN ('ccmdata','CCMStatisticalData')
OPEN c
FETCH NEXT FROM c INTO	@Moves,@dname
WHILE @@FETCH_STATUS <> -1
BEGIN
	
	PRINT 'RESTORE DATABASE ' + @dname + ' FROM DISK = ''S:\DB_Backups\NameOfFileHere.bak'' WITH ' + @Moves + ' REPLACE, STATS=10'
	FETCH NEXT FROM c INTO	@Moves,@dname
END
CLOSE c
DEALLOCATE c

