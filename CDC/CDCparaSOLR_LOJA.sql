--select top 10 name,	is_tracked_by_cdc FROM sys.tables WHERE is_tracked_by_cdc=1

IF (SELECT is_cdc_enabled FROM sys.databases WHERE database_id=DB_ID())=0
EXEC sys.sp_cdc_enable_db
GO

IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='CategoriaMarcaSidebar')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'CategoriaMarcaSideBar',
@supports_net_changes = 1,
@role_name = NULL;
GO

IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='Categoria')
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'Categoria',
@supports_net_changes = 0
,@captured_column_list='IdCategoria,FlagAtiva'
,@role_name = NULL;
GO

IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='ArquivoParceiroLojistaXml') and object_id('ArquivoParceiroLojistaXml') is not null
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'ArquivoParceiroLojistaXml',
@supports_net_changes = 1,
@role_name = NULL;
GO

IF NOT EXISTS(SELECT * FROM cdc.change_tables WHERE object_name(source_object_id)='SkuTributacaoPrecoCalculado') and object_id('SkuTributacaoPrecoCalculado') is not null
EXEC sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'SkuTributacaoPrecoCalculado',
@supports_net_changes = 0,
@role_name = NULL;
GO

EXEC sp_cdc_change_job @job_type='cleanup', @retention=2880
GO