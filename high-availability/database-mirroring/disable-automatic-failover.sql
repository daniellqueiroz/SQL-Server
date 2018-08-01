--ALTER DATABASE SQLSCANNERDB_lm SET WITNESS off

USE master
GO

SELECT 'alter database ' + QUOTENAME(d.name) + ' set witness off' 
FROM sys.databases d INNER JOIN sys.database_mirroring dm ON dm.database_id = d.database_id
WHERE mirroring_guid IS not null
ORDER BY d.name
