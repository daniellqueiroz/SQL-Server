DECLARE @BinVar varbinary(128)
SET @BinVar = CAST('WI-8963' AS varbinary(128) )
SET CONTEXT_INFO @BinVar

SELECT CONTEXT_INFO() AS MyContextInfo;
GO

SELECT CONVERT(VARCHAR(50),context_info) FROM master.dbo.SYSPROCESSES WHERE SPID=@@SPID

IF NOT EXISTS (SELECT * FROM SYS.columns WHERE NAME = 'testeLog' AND object_id=object_id('Desconto'))
ALTER TABLE dbo.Desconto ADD testeLog CHAR(1)

IF EXISTS (SELECT * FROM SYS.columns WHERE NAME = 'testeLog' AND object_id=object_id('Desconto'))
ALTER TABLE dbo.Desconto DROP COLUMN testeLog 

SELECT top 1000 * FROM dba.dbo.auditddloperations 
WHERE 1=1 
--and LoginName like '%%'
--and object like '%%'
AND DatabaseName='BDTesteDesempenho_Bahia'
ORDER BY posttime DESC

--DELETE FROM dba.dbo.AuditDDLOperations WHERE Object LIKE 'syncobj%'
--DELETE FROM dba.dbo.AuditDDLOperations WHERE [schema] is null
--DELETE FROM dba.dbo.AuditDDLOperations WHERE DatabaseLogID=11727

/*
DELETE FROM dba.dbo.auditddloperations 
WHERE 1=1 
and HostName = host_name()
*/
