USE master
GO
CREATE SERVER AUDIT [Auditoria_ChamadasDominio]
TO FILE
(	FILEPATH = N'd:\audits\' -- ALTERAR O CAMINHO DO ARQUIVO AQUI
	,MAXSIZE = 5000 MB
	,MAX_ROLLOVER_FILES = 2
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
)
GO

USE db_prd_loja
--the below comand must be ran on the database that you want to audit
CREATE DATABASE AUDIT SPECIFICATION ChamadasDominio
FOR SERVER AUDIT Auditoria_ChamadasDominio
--ADD (EXECUTE ON dbo.spcarrinholistar BY PUBLIC)
--ADD (INSERT,DELETE ON dbo.skualteracao BY PUBLIC)
ADD (UPDATE ON dbo.CompraFormaPagamento BY PUBLIC)
--,add (execute on dbo.DominioIncluirNovasSubCategorias by public)
--,add (execute on dbo.spDominioIncluir by public)
WITH (STATE = ON)
GO

ALTER SERVER AUDIT Auditoria_ChamadasDominio WITH (STATE = ON) --run to turn the audit ON
--ALTER SERVER AUDIT [Auditoria_ChamadasDominio] WITH (STATE = Off) --run to turn the audit OFF
--DROP SERVER AUDIT [Auditoria_ChamadasDominio]
GO

--geting metadata on existing audits
SELECT * FROM sys.server_audits

--querying the entries on the specified audit
USE master
GO
-- get the audit file
DECLARE @filepattern VARCHAR(300)
DECLARE @folder VARCHAR(255)
DECLARE @auditguid VARCHAR(36)
SELECT @auditguid = audit_guid,@folder = log_file_path
FROM sys.server_file_audits WHERE name = 'Auditoria_ChamadasDominio'

SELECT @filepattern = @folder + '*_' + @auditguid + '*'
--SELECT @filepattern

-- view the results
SELECT OBJECT_NAME(f.object_id),a.name AS Action,c.class_type_desc AS ObjectType,f.server_principal_name,f.schema_name,f.object_name,f.statement, f.event_time,f.session_id,f.database_name,f.server_instance_name
--,CHECKSUM(statement)
--DISTINCT object_name
FROM fn_get_audit_file(@filepattern,NULL,NULL) AS f
JOIN sys.dm_audit_class_type_map c ON f.class_type = c.class_type
JOIN sys.dm_audit_actions a ON f.action_id = a.action_id
AND c.securable_class_desc = a.class_desc
WHERE f.action_id <> 'AUSC'




