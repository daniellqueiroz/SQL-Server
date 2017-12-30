/*
Remarks:

1. You can create one trigger per database within an instance, if you need more granularity. In this case, I'm assuming you wish to audit all changes of all databases within an instance.
2. You can disable this trigger at will
3. Script must be executed on master database

*/

USE [master]
GO

IF EXISTS(SELECT TOP 10 * FROM sys.server_triggers WHERE name='AuditAllDDL')
  DROP TRIGGER [AuditAllDDL] ON ALL SERVER
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [AuditAllDDL] ON ALL SERVER
WITH EXECUTE AS 'sa'
FOR DDL_EVENTS
AS
BEGIN
    
    SET NOCOUNT ON;
    
    IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL
    BEGIN

        DECLARE @data XML;
        DECLARE @schema sysname;
        DECLARE @object sysname;
        DECLARE @eventType sysname;

        SET @data = EVENTDATA();
        SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
        SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
        SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname');

        IF @object IS NOT NULL
            PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
        ELSE
            PRINT '  ' + @eventType + ' - ' + @schema;
        
        IF @eventType IS NULL
            PRINT CONVERT(NVARCHAR(MAX), @data);


        IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL AND @eventtype NOT IN ('UPDATE_STATISTICS') AND @object NOT LIKE 'sp_MS%' AND @object NOT LIKE '%Secundario'
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
	        ) 
	        VALUES 
	        (
				CONVERT(VARCHAR(100), @data.query('data(/EVENT_INSTANCE/DatabaseName)')),
				HOST_NAME(),
				ORIGINAL_LOGIN(),
				GETDATE(), 
				CONVERT(sysname, CURRENT_USER), 
				@eventType, 
				CONVERT(sysname, @schema), 
				CONVERT(sysname, @object), 
				@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')
	        );
        END 
    END
END

GO

--DISABLE TRIGGER [AuditAllDDL] ON ALL SERVER
ENABLE TRIGGER [AuditAllDDL] ON ALL SERVER
GO


