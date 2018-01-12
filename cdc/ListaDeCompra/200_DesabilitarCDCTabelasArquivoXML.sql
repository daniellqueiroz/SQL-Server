IF EXISTS(SELECT * FROM cdc.change_tables WHERE capture_instance='ArquivoParceiroXml')
EXEC sys.sp_cdc_disable_table
@source_schema = N'dbo',
@source_name   = N'ArquivoParceiroXml',
@capture_instance = N'ArquivoParceiroXml'
GO
IF EXISTS(SELECT * FROM cdc.change_tables WHERE capture_instance='AgendamentoParceiroXml')
EXEC sys.sp_cdc_disable_table
@source_schema = N'dbo',
@source_name   = N'AgendamentoParceiroXml',
@capture_instance = N'AgendamentoParceiroXml'
GO
IF EXISTS(SELECT * FROM cdc.change_tables WHERE capture_instance='FtpXml')
EXEC sys.sp_cdc_disable_table
@source_schema = N'dbo',
@source_name   = N'FtpXml',
@capture_instance = N'FtpXml'
GO


ENABLE TRIGGER [AuditAllDDL] ON DATABASE
GO
