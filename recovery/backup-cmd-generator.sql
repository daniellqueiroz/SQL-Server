/*
DECLARE @hora VARCHAR(8)=(SELECT REPLACE(CONVERT(VARCHAR(8),convert(time,GETDATE())),':',''))
DECLARE @data VARCHAR(10)=(SELECT REPLACE(CONVERT(VARCHAR(10),convert(date,GETDATE())),'-',''))
DECLARE @db VARCHAR(1000)='CCMStatisticalData'
DECLARE @path VARCHAR(4000)='S:\DB_Backups\'+@db+'_'+@data+'_'+@hora

BACKUP DATABASE @db TO DISK = @path WITH COMPRESSION,STATS=10
GO

DECLARE @hora VARCHAR(8)=(SELECT REPLACE(CONVERT(VARCHAR(8),convert(time,GETDATE())),':',''))
DECLARE @data VARCHAR(10)=(SELECT REPLACE(CONVERT(VARCHAR(10),convert(date,GETDATE())),'-',''))
DECLARE @db VARCHAR(1000)='CCMData'
DECLARE @path VARCHAR(4000)='S:\DB_Backups\'+@db+'_'+@data+'_'+@hora

BACKUP DATABASE @db TO DISK = @path WITH COMPRESSION,STATS=10
GO
*/

DECLARE @hora VARCHAR(8)=(SELECT REPLACE(CONVERT(VARCHAR(8),convert(time,GETDATE())),':',''))
DECLARE @data VARCHAR(10)=(SELECT REPLACE(CONVERT(VARCHAR(10),convert(date,GETDATE())),'-',''))
DECLARE @path VARCHAR(4000)='S:\DB_Backups\'
DECLARE @dname sysname='master',@copy_only BIT = 0,@compression BIT=1
DECLARE c CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT name FROM sys.databases WHERE name IN ('ccmdata','CCMStatisticalData')
OPEN c
FETCH NEXT FROM c INTO @dname
WHILE @@FETCH_STATUS <> -1
BEGIN
	PRINT 'BACKUP DATABASE '+@dname+' TO DISK = '''+@path+@dname+'_'+@data+'_'+@hora+'.bak'' WITH STATS=10' + CASE @copy_only WHEN 1 THEN + ',COPY_ONLY' ELSE '' END + CASE @compression WHEN 1 THEN + ',COMPRESSION' ELSE '' END
	FETCH NEXT FROM c INTO @dname
END
CLOSE c
DEALLOCATE c

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