--run at the principal server

USE master
GO

SELECT 'alter database ' + d.name + ' set partner failover' 
FROM sys.databases d INNER JOIN sys.database_mirroring dm ON dm.database_id = d.database_id
WHERE mirroring_guid IS not null
ORDER BY d.name
