--AUDITING TRIGGER TO RECORD EVERY DDL OPERATION INSIDE THE DATABASE
--USE IT AS A AUDITING TOOL AND AS A OBJECT DEFINITION BACKUP
--TESTED ON SQL SERVER 2008,2012 AND 2014

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists(select * from sys.triggers where name = 'AuditAllDDL')
DROP TRIGGER [AuditAllDDL] ON DATABASE 
GO

CREATE TRIGGER [AuditAllDDL] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
SET NOCOUNT ON;
set ansi_padding on;
IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL
BEGIN
DECLARE @data XML;
DECLARE @schema sysname;
DECLARE @object sysname;
DECLARE @eventType sysname;
SET @data = EVENTDATA();
SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 
IF @object IS NOT NULL
PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
ELSE
PRINT '  ' + @eventType + ' - ' + @schema;

--IF @eventType IS NULL
--PRINT CONVERT(nvarchar(max), @data);


IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL AND @eventtype NOT IN ('CREATE_USER','ADD_ROLE_MEMBER','DROP_USER','UPDATE_STATISTICS','ALTER_INDEX') AND (@object NOT LIKE 'sp_MS%' OR @object NOT LIKE 'AUDIT%') and ORIGINAL_LOGIN() not in ('sa','DCNOVA\srv_dsqlweb01') and CONVERT(sysname, CURRENT_USER) != 'dbo'
BEGIN

	INSERT dba.dbo.AuditDDLOperations
	(
	[DatabaseName],
	[LoginName],
	[PostTime], 
	[DatabaseUser], 
	[Event], 
	[Schema], 
	[Object], 
	[TSQL],
	[HostName],
	FlagOrigem
	--[XmlEvent]
	) 
	VALUES 
	(
	DB_NAME(),
	ORIGINAL_LOGIN(),
	GETDATE(), 
	CONVERT(sysname, CURRENT_USER), 
	@eventType, 
	CONVERT(sysname, @schema), 
	CONVERT(sysname, @object), 
	@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'),
	host_name(),
	'A'
	--@data
	);
END 
END
END;



ENABLE TRIGGER [AuditAllDDL] ON DATABASE