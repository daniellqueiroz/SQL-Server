USE [db_controle_ddl_procedures]
GO


exec sp_changepublication @publication = 'ControleDDLProcedures'
, @property = 'replicate_ddl'
, @value = '0'
, @force_invalidate_snapshot = 0
, @force_reinit_subscription = 0

/****** Object:  DdlTrigger [AdicaoDeProcAutomatica]    Script Date: 07/13/2011 22:14:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [AdicaoDeProcAutomatica] ON DATABASE 
FOR CREATE_PROCEDURE, 
    ALTER_PROCEDURE, 
    DROP_PROCEDURE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @data XML;
	SET @data = EVENTDATA();
	DECLARE @TipoObjeto 	[VARCHAR](50)
	SET @TipoObjeto 	= @DATA.value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')
	DECLARE	@return_value int
	
	DECLARE @schema sysname;
	DECLARE @object sysname;
	DECLARE @eventType sysname;
	
	SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
	SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
	SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 
	IF @object IS NOT NULL
	PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
	ELSE
	PRINT '  ' + @eventType + ' - ' + @schema;
	IF @eventType IS NULL
	PRINT CONVERT(nvarchar(max), @data);

	IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL and @eventtype IN ('CREATE_PROCEDURE') AND (@object NOT LIKE 'sp_MS%' OR @object NOT LIKE 'AUDIT%')
	begin
		print 'Adicionando nova proc na publicação'
		EXEC	@return_value = sp_addarticle @publication = N'ControleDDLProcedures', @article = @object, @source_owner = N'dbo', @source_object = @object, @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = @object, @destination_owner = N'dbo', @status = 16, @force_invalidate_snapshot = 1
		IF  @return_value = 0
		begin
			print 'Artigo Incluído na publicação'
			print 'Gerando snapshot para novo artigo'
			exec msdb.dbo.sp_start_job @job_id = 'B9CA19E1-02C6-4F73-8B86-95F0BD5A0322', @step_name = 'Snapshot Agent startup message.'
			print 'Snapshot Iniciado. Dentro de 2 minutos verifique se a(s) procedure(s) foi criada nas lojas.'
		end
		else
		begin
			print 'O artigo não pôde ser incluído na publicação dessa vez. Excluindo procedure ' + @object + '. Tente a criação desse objeto novamente após 2 minutos.'
			exec('drop procedure [' + @object + ']')
		end
		
		print 'Auditando alteração na procedure'
		INSERT dba.dbo.AuditDDLOperations	(	[DatabaseName],	[LoginName],	[PostTime], 	[DatabaseUser], 	[Event], 	[Schema], 	[Object], 	[TSQL], 	[XmlEvent]	) 	VALUES 	(	DB_NAME(),	ORIGINAL_LOGIN(),	GETDATE(), 	CONVERT(sysname, CURRENT_USER), 	@eventType, 	CONVERT(sysname, @schema), 	CONVERT(sysname, @object), 	@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), 	@data	);
		print 'Alteração Auditada'
		print '' + char(13)
	end
	IF OBJECT_ID('dba.dbo.AuditDDLOperations') IS NOT NULL and @eventtype IN ('ALTER_PROCEDURE') AND (@object NOT LIKE 'sp_MS%' OR @object NOT LIKE 'AUDIT%')
	begin
		print 'Auditando alteração na procedure'
		INSERT dba.dbo.AuditDDLOperations	
		(	
		[DatabaseName],	[LoginName], HostName,	[PostTime], 	[DatabaseUser], 	[Event], 	[Schema], 	[Object], ObjectType, 	[TSQL]--, 	[XmlEvent]	
		) 	VALUES 	
		(	
		DB_NAME(),	ORIGINAL_LOGIN(), HOST_NAME(),	GETDATE(), 	CONVERT(sysname, CURRENT_USER), 	@eventType, 	CONVERT(sysname, @schema), 	CONVERT(sysname, @object), @TipoObjeto, 	@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')--, 	@data
		);
		print 'Alteração Auditada'
		print '' + char(13)
	end
END;



GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ENABLE TRIGGER [AdicaoDeProcAutomatica] ON DATABASE
GO

exec sp_changepublication @publication = 'ControleDDLProcedures'
, @property = 'replicate_ddl'
, @value = '1'
, @force_invalidate_snapshot = 0
, @force_reinit_subscription = 0

