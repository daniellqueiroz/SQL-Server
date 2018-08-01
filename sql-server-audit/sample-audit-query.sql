
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
SELECT OBJECT_NAME(f.object_id),a.name AS Action,c.class_type_desc AS ObjectType,f.server_principal_name,f.schema_name,f.OBJECT_NAME,f.statement, f.event_time,f.session_id,f.database_name,f.server_instance_name
--,CHECKSUM(statement)
--DISTINCT object_name
FROM fn_get_audit_file(@filepattern,NULL,NULL) AS f
JOIN sys.dm_audit_class_type_map c ON f.class_type = c.class_type
JOIN sys.dm_audit_actions a ON f.action_id = a.action_id 
AND c.securable_class_desc = a.class_desc
WHERE f.action_id <> 'AUSC'
--AND object_name='busca'
--AND ([statement] LIKE '%ArquivoBinario%' OR [statement] LIKE '%*%')
--AND database_name='db_hom_casasbahia'
--AND CHECKSUM(statement) NOT IN ('616684708','-1485335765','1210513292','1848977597','-513928784')
--AND server_principal_name ='usr_hom_web'
--ORDER BY event_time DESC,sequence_number 

--SELECT @filepattern
--SELECT * FROM sys.server_file_audits WHERE name = 'Auditoria_DMLProduto'

--SELECT * FROM sys.server_audits

