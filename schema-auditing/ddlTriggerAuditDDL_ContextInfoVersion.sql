IF NOT EXISTS (SELECT * FROM dba.SYS.columns WHERE NAME = 'Escopo' AND object_id=object_id('dba.dbo.AuditDDLOperations'))
ALTER TABLE dba.dbo.AuditDDLOperations ADD Escopo VARCHAR(100)
GO

IF NOT EXISTS (SELECT * FROM dba.SYS.columns WHERE NAME = 'Programa' AND object_id=object_id('dba.dbo.AuditDDLOperations'))
ALTER TABLE dba.dbo.AuditDDLOperations ADD Programa VARCHAR(1000)
GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF (SELECT count(*) FROM sys.triggers where name = 'AuditAllDDL') > 0
	DROP TRIGGER [AuditAllDDL] ON DATABASE 
GO

CREATE TRIGGER [AuditAllDDL] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
SET NOCOUNT ON;
IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL
BEGIN
DECLARE @data XML;
DECLARE @schema sysname;
DECLARE @object sysname;
DECLARE @eventType sysname,@context_info VARCHAR(100);
SET @data = EVENTDATA();
SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 


IF @object IS NOT NULL
PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
ELSE
PRINT '  ' + @eventType + ' - ' + @schema;

IF @eventType IS NULL
PRINT CONVERT(nvarchar(max), @data);

SELECT @context_info=CONVERT(VARCHAR(50),context_info) FROM master.dbo.SYSPROCESSES WHERE SPID=@@SPID

IF ORIGINAL_LOGIN() LIKE 'usr%'
BEGIN
	RAISERROR('Essa operação não pode ser feita com usuários de aplicação.',16,1)
	ROLLBACK;
END


IF @context_info IS NULL OR (@context_info NOT LIKE 'WI%' AND @context_info NOT LIKE 'Germud%' AND @context_info NOT LIKE 'Chamado%')
BEGIN
	RAISERROR('As informações relacionadas a alteração não foram especificadas no script ou não estão no formato correto. Alteração não realizada.',16,1);
	ROLLBACK;
END
ELSE
BEGIN
IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL 
AND @eventtype NOT IN ('UPDATE_STATISTICS','ALTER_INDEX') 
AND @object NOT LIKE 'sp_MS%' AND @object NOT LIKE '%Secundario' AND @object NOT LIKE 'syncobj%'
AND @schema IS NOT NULL
BEGIN

	INSERT dba.dbo.AuditDDLOperations
	(
	[DatabaseName],
	[HostName],
	[LoginName],
	[PostTime], 
	[DatabaseUser], 
	[Event], 
	[Schema], 
	[Object], 
	[TSQL]
	,Escopo
	,Programa
	--[XmlEvent]
	) 
	VALUES 
	(
	DB_NAME(),
	HOST_NAME(),
	ORIGINAL_LOGIN(),
	GETDATE(), 
	CONVERT(sysname, CURRENT_USER), 
	@eventType, 
	CONVERT(sysname, @schema), 
	CONVERT(sysname, @object), 
	@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')
	,@context_info
	,APP_NAME()
	--@data
	);
END 
END
END
END;




GO
