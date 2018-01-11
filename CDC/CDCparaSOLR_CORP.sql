--select top 10 name,	is_tracked_by_cdc FROM sys.tables WHERE is_tracked_by_cdc=1

IF (SELECT is_cdc_enabled FROM sys.databases WHERE database_id=DB_ID())=0
EXEC sys.sp_cdc_enable_db
GO

IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='Marca')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'Marca',
@supports_net_changes = 0
,@captured_column_list='IdMarca,Nome'
,@role_name = NULL;
GO
IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='ProdutoCampoValor')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'ProdutoCampoValor',
@supports_net_changes = 0
,@role_name = NULL;
GO
IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='ProdutoCategoriaSimilar')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'ProdutoCategoriaSimilar',
@supports_net_changes = 0
,@role_name = NULL;
GO
IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='Categoria')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'Categoria',
@supports_net_changes = 0
,@captured_column_list='IdCategoria,Nome'
,@role_name = NULL;
GO

EXEC sp_cdc_change_job @job_type='cleanup', @retention=2880
GO