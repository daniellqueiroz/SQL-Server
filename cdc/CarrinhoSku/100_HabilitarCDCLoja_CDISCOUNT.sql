-- É NECESSÁRIO DESABILITAR A TRIGGER DE AUDITORIA DDL PARA QUE SEJA POSSÍVEL HABILITAR O CDC. CASO CONTRÁRIO OS COMANDOS A SEGUIR APRESENTARÃO ERRO
DISABLE TRIGGER [AuditAllDDL] ON DATABASE
GO


IF (SELECT is_cdc_enabled FROM sys.databases WHERE database_id=DB_ID())=0
EXEC sys.sp_cdc_enable_db
GO

EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'CarrinhoSku',
@supports_net_changes = 0,
@role_name = NULL;
GO

--EXEC sp_cdc_change_job @job_type='cleanup', @retention=1440
--GO
