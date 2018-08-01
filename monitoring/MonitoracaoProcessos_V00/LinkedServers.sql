USE master
GO

-------------- SECUNDÁRIOS

EXEC master.dbo.sp_addlinkedserver @server = N'ExtraSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'EXTRA_PRD.DC.NOVA,1301'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=EXTRA_PRD.DC.NOVA,1301;ApplicationIntent=ReadOnly'
    ,@catalog = N'db_prd_extra'
GO
IF NOT EXISTS(select top 1000 * FROM sys.servers WHERE name='PontofrioSecundario')
EXEC master.dbo.sp_addlinkedserver @server = N'PontofrioSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'PONTOFRIO_PRD.DC.NOVA,1303'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_pontofrio;Data Source=PONTOFRIO_PRD.DC.NOVA,1303;ApplicationIntent=ReadOnly'
    ,@catalog = N'db_prd_pontofrio'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'CasasbahiaSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'CASASBAHIA_PRD.DC.NOVA,1306'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_casasbahia2;Data Source=CASASBAHIA_PRD.DC.NOVA,1306;ApplicationIntent=ReadOnly'
    ,@catalog = N'db_prd_casasbahia2'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'CorpSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'CORP_PRD.DC.NOVA,1310'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=CORP_PRD.DC.NOVA,1310;ApplicationIntent=ReadOnly'
    ,@catalog = N'db_prd_corp'
GO


IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'BarateiroSecundario')EXEC master.dbo.sp_dropserver @server=N'BarateiroSecundario', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'BarateiroSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'BARATEIRO_PRD.dc.nova,1305'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_barateiro;Data Source=BARATEIRO_PRD.dc.nova,1305;ApplicationIntent=ReadOnly'
    ,@catalog = N'db_prd_barateiro'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'AtacadoSecundario')EXEC master.dbo.sp_dropserver @server=N'AtacadoSecundario', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'AtacadoSecundario'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'ATACADO_PRD.dc.nova,1302'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=DB_PONTOFRIO_ATACADO;Data Source=ATACADO_PRD.dc.nova,1302;ApplicationIntent=ReadOnly'
    ,@catalog = N'DB_PONTOFRIO_ATACADO'
GO

-------------- PRIMÁRIOS

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'EXTRA_PRD.DC.NOVA,1301')EXEC master.dbo.sp_dropserver @server=N'EXTRA_PRD.DC.NOVA,1301', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'EXTRA_PRD.DC.NOVA,1301'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'EXTRA_PRD.DC.NOVA,1301'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=EXTRA_PRD.DC.NOVA,1301'
    ,@catalog = N'db_prd_extra'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'PONTOFRIO_PRD.DC.NOVA,1303')EXEC master.dbo.sp_dropserver @server=N'PONTOFRIO_PRD.DC.NOVA,1303', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'PONTOFRIO_PRD.DC.NOVA,1303'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'PONTOFRIO_PRD.DC.NOVA,1303'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=PONTOFRIO_PRD.DC.NOVA,1303'
    ,@catalog = N'db_prd_pontofrio'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'CORP_PRD.DC.NOVA,1310')EXEC master.dbo.sp_dropserver @server=N'CORP_PRD.DC.NOVA,1310', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'CORP_PRD.DC.NOVA,1310'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'CORP_PRD.DC.NOVA,1310'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=CORP_PRD.DC.NOVA,1310'
    ,@catalog = N'db_prd_corp'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'CASASBAHIA_PRD.DC.NOVA,1306')EXEC master.dbo.sp_dropserver @server=N'CASASBAHIA_PRD.DC.NOVA,1306', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'CASASBAHIA_PRD.DC.NOVA,1306'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'CASASBAHIA_PRD.DC.NOVA,1306'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_extra;Data Source=CASASBAHIA_PRD.DC.NOVA,1306,1301'
    ,@catalog = N'db_prd_casasbahia2'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'BARATEIRO_PRD.dc.nova,1305')EXEC master.dbo.sp_dropserver @server=N'BARATEIRO_PRD.dc.nova,1305', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'BARATEIRO_PRD.dc.nova,1305'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'BARATEIRO_PRD.dc.nova,1305'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=db_prd_barateiro;Data Source=BARATEIRO_PRD.dc.nova,1305'
    ,@catalog = N'db_prd_barateiro'
GO

IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'ATACADO_PRD.dc.nova,1302')EXEC master.dbo.sp_dropserver @server=N'ATACADO_PRD.dc.nova,1302', @droplogins='droplogins'
GO
EXEC master.dbo.sp_addlinkedserver @server = N'ATACADO_PRD.dc.nova,1302'
    ,@srvproduct = N'SQL'
    ,@provider = N'SQLNCLI11'
    ,@datasrc = N'ATACADO_PRD.dc.nova,1302'
    ,@provstr = N'Integrated Security=SSPI;Initial Catalog=DB_PONTOFRIO_ATACADO;Data Source=ATACADO_PRD.dc.nova,1302'
    ,@catalog = N'DB_PONTOFRIO_ATACADO'
GO
