IF EXISTS(SELECT * FROM sys.triggers WHERE name ='AuditAllDDL' AND parent_id=0)
	DISABLE TRIGGER [AuditAllDDL] ON DATABASE
GO


IF (SELECT is_cdc_enabled FROM sys.databases WHERE database_id=DB_ID())=0
EXEC sys.sp_cdc_enable_db
GO


EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'ListaDeCompra',
@supports_net_changes = 1,
@role_name = NULL;
GO

EXEC sp_cdc_change_job @job_type='cleanup', @retention=1440
GO
--SELECT * FROM cdc.change_tables