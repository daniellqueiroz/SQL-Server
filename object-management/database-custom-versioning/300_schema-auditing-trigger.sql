
if exists(select * from sys.triggers where name ='AuditAllDDL')
DROP TRIGGER [AuditAllDDL] ON DATABASE
GO

/****** Object:  DdlTrigger [AuditAllDDL]    Script Date: 25/04/2013 20:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

set ansi_padding on 
go


CREATE TRIGGER [AuditAllDDL] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
SET NOCOUNT ON;
set ansi_padding on;
IF OBJECT_ID('dbo.HistoricoVersaoObjeto') IS NOT NULL
BEGIN
DECLARE @data XML;
DECLARE @schema sysname;
DECLARE @object sysname;
DECLARE @eventType sysname;
declare @Texto xml,@UltimaVersao bigint,@ProximaVersao bigint,@TextoAnterior xml,@TextoAnteriorAux nvarchar(max), @TextoAux nvarchar(max)
SET @data = EVENTDATA();
SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 

if @eventType in ('alter_table','create_table','drop_table') and @object='HistoricoVersaoObjeto' and ORIGINAL_LOGIN() not in ('sa') and CONVERT(sysname, CURRENT_USER) != 'dbo'
begin
	raiserror('Apenas administradores do banco podem alterar a tabela de auditoria.',16,1)
	rollback
end

declare @table table (string nvarchar(max))
insert into @table values (@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'))

select @Texto=(select convert(nvarchar(max),string) from @table for xml path(''))

select top 1 @UltimaVersao=versao,@TextoAnterior=Texto from dbo.HistoricoVersaoObjeto where Object=@object order by DataAlteracao desc

set @TextoAnteriorAux=cast(@TextoAnterior as nvarchar(max))
set @TextoAux=cast(@Texto as nvarchar(max))

if @UltimaVersao is null set @UltimaVersao=1
	set @ProximaVersao=@UltimaVersao+1

if @TextoAnteriorAux is null
	set @TextoAnteriorAux=''

IF @TextoAnteriorAux<>@TextoAux and OBJECT_ID('dbo.HistoricoVersaoObjeto') IS NOT NULL AND 
@eventtype NOT IN ('CREATE_USER','ADD_ROLE_MEMBER','DROP_USER','UPDATE_STATISTICS','ALTER_INDEX','GRANT_DATABASE','DENY_DATABASE','DROP_ROLE_MEMBER','DROP_ROLE') 
AND (@object NOT LIKE 'sp_MS%' OR @object NOT LIKE 'AUDIT%' OR @object NOT LIKE 'syncobj_%' or @object not like '%ConsolidadoSecundario%') 
and ORIGINAL_LOGIN() not in ('sa','DCNOVA\srv_dsqlweb01') --and CONVERT(sysname, CURRENT_USER) != 'dbo'
BEGIN

	INSERT dbo.HistoricoVersaoObjeto
	(
	[DatabaseName],
	[LoginName],
	DataAlteracao, 
	[DatabaseUser], 
	[Event], 
	[Schema], 
	[Object], 
	Texto,
	[HostName]
	,Versao
	
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
	@Texto
	,host_name()
	,@ProximaVersao
);

	print 'objeto alterado e versionado'
END 
END
END;
ENABLE TRIGGER [AuditAllDDL] ON DATABASE
GO