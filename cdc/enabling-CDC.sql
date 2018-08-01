--Enabling CDC for both the database and some tables. FOr more information about the parameters, consult Microsoft documentation
--COnfigure the retention period according to your storage/reporting needs
--Also, be sure to check the requirements and caveats of using CDC (nothing comes free you know)
--Beaware that you might need to disable any database level triggers before enabling CDC. You can reenable them after enabling the feature.

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