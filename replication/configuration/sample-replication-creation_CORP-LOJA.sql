SET TRANSACTION ISOLATION LEVEL READ COMMITTED
-- Enabling the replication database
USE master
EXEC sp_replicationdboption @dbname = N'db_prd_corp', @optname = N'publish', @value = N'true'
GO

EXEC [db_prd_corp].sys.sp_addlogreader_agent @job_login = NULL, @job_password = NULL, @publisher_security_mode = 1
GO
-- Adding the transactional publication
USE [db_prd_corp]
EXEC sp_addpublication @publication = N'CORP_OUTROS_NPC', @description = N'Transactional publication of database ''db_prd_corp'' from Publisher ''CL-HL-DSQLWEB01\WSQLWEB01''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'false', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'false', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


EXEC sp_addpublication_snapshot @publication = N'CORP_OUTROS_NPC', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = NULL, @job_password = NULL, @publisher_security_mode = 1
EXEC sp_grant_publication_access @publication = N'CORP_OUTROS_NPC', @login = N'sa'
GO

-- Adding the transactional articles
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @source_owner = N'dbo', @source_object = N'Administrador', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Administrador', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboAdministrador]', @del_cmd = N'CALL [sp_MSdel_dboAdministrador]', @upd_cmd = N'SCALL [sp_MSupd_dboAdministrador]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'IdAdministrador', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'IdParceiro', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Email', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Login', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Senha', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Status', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'SenhaHash', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'IdCanalVenda', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'QuantidadeTentativas', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'DataUltimaAlteracaoSenha', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'DataUltimoAcesso', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Cpf', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @column = N'Origem', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Administrador', @view_name = N'syncobj_0x3545454131443946', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Campo', @source_owner = N'dbo', @source_object = N'Campo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Campo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCampo]', @del_cmd = N'CALL [sp_MSdel_dboCampo]', @upd_cmd = N'SCALL [sp_MSupd_dboCampo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CampoValor', @source_owner = N'dbo', @source_object = N'CampoValor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CampoValor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCampoValor]', @del_cmd = N'CALL [sp_MSdel_dboCampoValor]', @upd_cmd = N'SCALL [sp_MSupd_dboCampoValor]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CanalVenda', @source_owner = N'dbo', @source_object = N'CanalVenda', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'CanalVenda', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCanalVenda]', @del_cmd = N'CALL [sp_MSdel_dboCanalVenda]', @upd_cmd = N'SCALL [sp_MSupd_dboCanalVenda]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @source_owner = N'dbo', @source_object = N'Categoria', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Categoria', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboCategoria]', @del_cmd = N'CALL [sp_MSdel_dboCategoria]', @upd_cmd = N'SCALL [sp_MSupd_dboCategoria]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'IdCategoria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'IdCategoriaPai', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'idDepartamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'MargemLucro', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'PalavraChave', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'TituloSite', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'_FlagExisteProduto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'NomeUrl', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'NomeUrlAnterior', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'FlagExibeSegundaImagem', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @column = N'FlagCompraRestricaoIdade', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Categoria', @view_name = N'syncobj_0x3041433445423130', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CategoriaArvoreFilho', @source_owner = N'dbo', @source_object = N'CategoriaArvoreFilho', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CategoriaArvoreFilho', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCategoriaArvoreFilho]', @del_cmd = N'CALL [sp_MSdel_dboCategoriaArvoreFilho]', @upd_cmd = N'SCALL [sp_MSupd_dboCategoriaArvoreFilho]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CategoriaArvorePai', @source_owner = N'dbo', @source_object = N'CategoriaArvorePai', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CategoriaArvorePai', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCategoriaArvorePai]', @del_cmd = N'CALL [sp_MSdel_dboCategoriaArvorePai]', @upd_cmd = N'SCALL [sp_MSupd_dboCategoriaArvorePai]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CategoriaSimilar', @source_owner = N'dbo', @source_object = N'CategoriaSimilar', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'CategoriaSimilar', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCategoriaSimilar]', @del_cmd = N'CALL [sp_MSdel_dboCategoriaSimilar]', @upd_cmd = N'SCALL [sp_MSupd_dboCategoriaSimilar]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ColecaoModelo', @source_owner = N'dbo', @source_object = N'ColecaoModelo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'ColecaoModelo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboColecaoModelo]', @del_cmd = N'CALL [sp_MSdel_dboColecaoModelo]', @upd_cmd = N'SCALL [sp_MSupd_dboColecaoModelo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ColecaoTipo', @source_owner = N'dbo', @source_object = N'ColecaoTipo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ColecaoTipo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboColecaoTipo]', @del_cmd = N'CALL [sp_MSdel_dboColecaoTipo]', @upd_cmd = N'SCALL [sp_MSupd_dboColecaoTipo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @source_owner = N'dbo', @source_object = N'CompraEntregaStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'CompraEntregaStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboCompraEntregaStatus]', @del_cmd = N'CALL [sp_MSdel_dboCompraEntregaStatus]', @upd_cmd = N'SCALL [sp_MSupd_dboCompraEntregaStatus]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'IdCompraEntregaStatus', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'IdCompraStatusOrigem', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'NomeAcao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'NomeParaCliente', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'Link', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'Titulo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'DescricaoDetalhada', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @column = N'IdFasePedido', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'CompraEntregaStatus', @view_name = N'syncobj_0x4439373645343434', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Controle', @source_owner = N'dbo', @source_object = N'Controle', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Controle', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboControle]', @del_cmd = N'CALL [sp_MSdel_dboControle]', @upd_cmd = N'SCALL [sp_MSupd_dboControle]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'DicionarioCaptcha', @source_owner = N'dbo', @source_object = N'DicionarioCaptcha', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'DicionarioCaptcha', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboDicionarioCaptcha]', @del_cmd = N'CALL [sp_MSdel_dboDicionarioCaptcha]', @upd_cmd = N'SCALL [sp_MSupd_dboDicionarioCaptcha]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @source_owner = N'dbo', @source_object = N'Estoque', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Estoque', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboEstoque]', @del_cmd = N'CALL [sp_MSdel_dboEstoque]', @upd_cmd = N'SCALL [sp_MSupd_dboEstoque]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'IdEstoque', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'IdEndereco', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'Sinal', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'RazaoSocial', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'InscEst', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'Cnpj', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'FlagAtiva', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'PrazoEntrega', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'Codigo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'Prioridade', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'FlagConsolidadoLoja', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @column = N'IdFilial', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Estoque', @view_name = N'syncobj_0x4530344637304437', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Fabricante', @source_owner = N'dbo', @source_object = N'Fabricante', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Fabricante', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFabricante]', @del_cmd = N'CALL [sp_MSdel_dboFabricante]', @upd_cmd = N'SCALL [sp_MSupd_dboFabricante]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FaixaPreco', @source_owner = N'dbo', @source_object = N'FaixaPreco', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'FaixaPreco', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFaixaPreco]', @del_cmd = N'CALL [sp_MSdel_dboFaixaPreco]', @upd_cmd = N'SCALL [sp_MSupd_dboFaixaPreco]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FasePedido', @source_owner = N'dbo', @source_object = N'FasePedido', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'FasePedido', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFasePedido]', @del_cmd = N'CALL [sp_MSdel_dboFasePedido]', @upd_cmd = N'SCALL [sp_MSupd_dboFasePedido]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Feriado', @source_owner = N'dbo', @source_object = N'Feriado', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Feriado', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFeriado]', @del_cmd = N'CALL [sp_MSdel_dboFeriado]', @upd_cmd = N'SCALL [sp_MSupd_dboFeriado]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @source_owner = N'dbo', @source_object = N'FormaPagamento', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'FormaPagamento', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboFormaPagamento]', @del_cmd = N'CALL [sp_MSdel_dboFormaPagamento]', @upd_cmd = N'SCALL [sp_MSupd_dboFormaPagamento]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'IdFormaPagamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'Tipo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'DiasExpira', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'Prioridade', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'TextoFinalizacao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'FlagGPA', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @column = N'PathImg', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamento', @view_name = N'syncobj_0x3338413130443238', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FormaPagamentoSige', @source_owner = N'dbo', @source_object = N'FormaPagamentoSige', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'FormaPagamentoSige', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFormaPagamentoSige]', @del_cmd = N'CALL [sp_MSdel_dboFormaPagamentoSige]', @upd_cmd = N'SCALL [sp_MSupd_dboFormaPagamentoSige]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Fornecedor', @source_owner = N'dbo', @source_object = N'Fornecedor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Fornecedor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFornecedor]', @del_cmd = N'CALL [sp_MSdel_dboFornecedor]', @upd_cmd = N'SCALL [sp_MSupd_dboFornecedor]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FreteEntregaTipo', @source_owner = N'dbo', @source_object = N'FreteEntregaTipo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'FreteEntregaTipo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFreteEntregaTipo]', @del_cmd = N'CALL [sp_MSdel_dboFreteEntregaTipo]', @upd_cmd = N'SCALL [sp_MSupd_dboFreteEntregaTipo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'FreteModalTipo', @source_owner = N'dbo', @source_object = N'FreteModalTipo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'FreteModalTipo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboFreteModalTipo]', @del_cmd = N'CALL [sp_MSdel_dboFreteModalTipo]', @upd_cmd = N'SCALL [sp_MSupd_dboFreteModalTipo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Grupo', @source_owner = N'dbo', @source_object = N'Grupo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Grupo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboGrupo]', @del_cmd = N'CALL [sp_MSdel_dboGrupo]', @upd_cmd = N'SCALL [sp_MSupd_dboGrupo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'GrupoItem', @source_owner = N'dbo', @source_object = N'GrupoItem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'GrupoItem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboGrupoItem]', @del_cmd = N'CALL [sp_MSdel_dboGrupoItem]', @upd_cmd = N'SCALL [sp_MSupd_dboGrupoItem]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'GuiaVisual', @source_owner = N'dbo', @source_object = N'GuiaVisual', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'GuiaVisual', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboGuiaVisual]', @del_cmd = N'CALL [sp_MSdel_dboGuiaVisual]', @upd_cmd = N'SCALL [sp_MSupd_dboGuiaVisual]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaborador', @source_owner = N'dbo', @source_object = N'LojaColaborador', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'LojaColaborador', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboLojaColaborador]', @del_cmd = N'CALL [sp_MSdel_dboLojaColaborador]', @upd_cmd = N'SCALL [sp_MSupd_dboLojaColaborador]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @source_owner = N'dbo', @source_object = N'LojaColaboradorUtm', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'LojaColaboradorUtm', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboLojaColaboradorUtm]', @del_cmd = N'CALL [sp_MSdel_dboLojaColaboradorUtm]', @upd_cmd = N'SCALL [sp_MSupd_dboLojaColaboradorUtm]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @column = N'UtmParceiro', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @column = N'UtmCampanha', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @column = N'UtmMidia', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @column = N'IdLojaColaborador', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'LojaColaboradorUtm', @view_name = N'syncobj_0x4132374134303842', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @source_owner = N'dbo', @source_object = N'Marca', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Marca', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboMarca]', @del_cmd = N'CALL [sp_MSdel_dboMarca]', @upd_cmd = N'SCALL [sp_MSupd_dboMarca]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'IdMarca', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'TituloSite', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'FlagAtiva', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'Contatos', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'Telefone', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'EmailSite', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'ObsSAC', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'FlagExibirContato', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'PalavraChave', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @column = N'TextoLink', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Marca', @view_name = N'syncobj_0x4436363244314638', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'NomenclaturaBrasileiraMercadoria', @source_owner = N'dbo', @source_object = N'NomenclaturaBrasileiraMercadoria', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'NomenclaturaBrasileiraMercadoria', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboNomenclaturaBrasileiraMercadoria]', @del_cmd = N'CALL [sp_MSdel_dboNomenclaturaBrasileiraMercadoria]', @upd_cmd = N'SCALL [sp_MSupd_dboNomenclaturaBrasileiraMercadoria]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Perfil', @source_owner = N'dbo', @source_object = N'Perfil', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Perfil', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboPerfil]', @del_cmd = N'CALL [sp_MSdel_dboPerfil]', @upd_cmd = N'SCALL [sp_MSupd_dboPerfil]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'PerfilRecursoSeguro', @source_owner = N'dbo', @source_object = N'PerfilRecursoSeguro', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'PerfilRecursoSeguro', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboPerfilRecursoSeguro]', @del_cmd = N'CALL [sp_MSdel_dboPerfilRecursoSeguro]', @upd_cmd = N'SCALL [sp_MSupd_dboPerfilRecursoSeguro]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @source_owner = N'dbo', @source_object = N'Produto', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Produto', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboProduto]', @del_cmd = N'CALL [sp_MSdel_dboProduto]', @upd_cmd = N'SCALL [sp_MSupd_dboProduto]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdProduto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdProdutoEdicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'PalavraChave', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'TextoLink', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdAdministradorEdicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdAdministradorAprovado', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdFabricante', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdFornecedor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdDepartamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdCategoria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdMarca', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'IdLinha', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'DataEdicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'DataAprovado', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'FlagSorteiaSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'Prioridade', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'PalavraChaveMarca', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'Ordenacao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'_TextoMarca', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'_TextoCategoria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'_TextoDepartamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'DataLancamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'_MaisVendidos', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'LabelSelecao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'ValorLucroLiquido', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'MetaTagDescription', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'DataAtualizacao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'FlagPrecoDiferentePorSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @column = N'FlagNaoIndexar', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Produto', @view_name = N'syncobj_0x4643363845364134', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ProdutoCampoValor', @source_owner = N'dbo', @source_object = N'ProdutoCampoValor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ProdutoCampoValor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboProdutoCampoValor]', @del_cmd = N'CALL [sp_MSdel_dboProdutoCampoValor]', @upd_cmd = N'SCALL [sp_MSupd_dboProdutoCampoValor]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ProdutoCategoriaSimilar', @source_owner = N'dbo', @source_object = N'ProdutoCategoriaSimilar', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'ProdutoCategoriaSimilar', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboProdutoCategoriaSimilar]', @del_cmd = N'CALL [sp_MSdel_dboProdutoCategoriaSimilar]', @upd_cmd = N'SCALL [sp_MSupd_dboProdutoCategoriaSimilar]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @source_owner = N'dbo', @source_object = N'RecursoSeguro', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'RecursoSeguro', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboRecursoSeguro]', @del_cmd = N'CALL [sp_MSdel_dboRecursoSeguro]', @upd_cmd = N'SCALL [sp_MSupd_dboRecursoSeguro]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @column = N'IdRecursoSeguro', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @column = N'Pagina', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'RecursoSeguro', @view_name = N'syncobj_0x4441423336433135', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'RegDepartamento', @source_owner = N'dbo', @source_object = N'RegDepartamento', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'RegDepartamento', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboRegDepartamento]', @del_cmd = N'CALL [sp_MSdel_dboRegDepartamento]', @upd_cmd = N'SCALL [sp_MSupd_dboRegDepartamento]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'RegFamilia', @source_owner = N'dbo', @source_object = N'RegFamilia', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'RegFamilia', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboRegFamilia]', @del_cmd = N'CALL [sp_MSdel_dboRegFamilia]', @upd_cmd = N'SCALL [sp_MSupd_dboRegFamilia]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'RegSetor', @source_owner = N'dbo', @source_object = N'RegSetor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'RegSetor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboRegSetor]', @del_cmd = N'CALL [sp_MSdel_dboRegSetor]', @upd_cmd = N'SCALL [sp_MSupd_dboRegSetor]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'RegSubFamilia', @source_owner = N'dbo', @source_object = N'RegSubFamilia', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'RegSubFamilia', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboRegSubFamilia]', @del_cmd = N'CALL [sp_MSdel_dboRegSubFamilia]', @upd_cmd = N'SCALL [sp_MSupd_dboRegSubFamilia]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ResenhaInteresse', @source_owner = N'dbo', @source_object = N'ResenhaInteresse', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'ResenhaInteresse', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboResenhaInteresse]', @del_cmd = N'CALL [sp_MSdel_dboResenhaInteresse]', @upd_cmd = N'SCALL [sp_MSupd_dboResenhaInteresse]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @source_owner = N'dbo', @source_object = N'Sku', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'Sku', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboSku]', @del_cmd = N'CALL [sp_MSdel_dboSku]', @upd_cmd = N'SCALL [sp_MSupd_dboSku]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSKU', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSKUEdicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdAdministradorEdicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdAdministradorAprovado', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdProduto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdFreteModalTipo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'flagKit', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PrecoCusto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Peso', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Altura', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Largura', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Comprimento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PesoCubico', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'DataPrevisaoChegada', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'DataCadastro', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PesoReal', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'AlturaReal', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'LarguraReal', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'ComprimentoReal', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'CodigoReferencia', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'GerencialDepto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'GerencialSetor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'idSkuCondicaoComercial', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'FlagAtivaERP', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PrazoGarantiaFornecedor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PIS', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'Cofins', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'ICMS', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PctReducaoBase', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IndicadorSubstituicaoTributaria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'TipoABC', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSKUOrigemKit', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'PisMP', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'CofinsMP', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'ValorMaximoVendaMP', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdCnpjFilialVendaPrioritaria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'DataAtualizacaoEstoque', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'FlagSkuProduzido', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'idNbm', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'FlagPrecifAbaixoCusto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'TipoSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'OrdemExibicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdTipoNaoProduto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSkuReferencia', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'CodigoMktp', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdDepartamento', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSetor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdFamilia', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdSubFamilia', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdFilialVendaPrioritaria', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'DataAtualizacaoPrecoCusto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'FlagBrinde', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'IdTipoMontagem', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'TipoItem', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @column = N'FlagSkuAdesaoFidelizacao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'Sku', @view_name = N'syncobj_0x4544384246324131', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @source_owner = N'dbo', @source_object = N'SkuCampoValor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'SkuCampoValor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboSkuCampoValor]', @del_cmd = N'CALL [sp_MSdel_dboSkuCampoValor]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuCampoValor]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @column = N'IdSkuCampoValor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @column = N'IdSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @column = N'IdCampo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @column = N'IdCampoValor', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @column = N'Texto', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'SkuCampoValor', @view_name = N'syncobj_0x4143424134333436', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuCondicaoComercial', @source_owner = N'dbo', @source_object = N'SkuCondicaoComercial', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'SkuCondicaoComercial', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboSkuCondicaoComercial]', @del_cmd = N'CALL [sp_MSdel_dboSkuCondicaoComercial]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuCondicaoComercial]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @source_owner = N'dbo', @source_object = N'SkuEan', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'SkuEan', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboSkuEan]', @del_cmd = N'CALL [sp_MSdel_dboSkuEan]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuEan]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @column = N'IdSkuEan', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @column = N'IdSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @column = N'Ean13', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @column = N'FlagEanPadrao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'SkuEan', @view_name = N'syncobj_0x3042454632324242', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuGrupoItem', @source_owner = N'dbo', @source_object = N'SkuGrupoItem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'SkuGrupoItem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboSkuGrupoItem]', @del_cmd = N'CALL [sp_MSdel_dboSkuGrupoItem]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuGrupoItem]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @source_owner = N'dbo', @source_object = N'SkuKitFilho', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'SkuKitFilho', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboSkuKitFilho]', @del_cmd = N'CALL [sp_MSdel_dboSkuKitFilho]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuKitFilho]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'idSkuKitFilho', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'idSkuPai', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'idSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'Quantidade', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'flagExibeDetalhes', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'Ordenacao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'IdSkuKitSige', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'FlagAcompanhaPrecoAvulso', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @column = N'DataUltimaComposicao', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'SkuKitFilho', @view_name = N'syncobj_0x3139393434453631', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @source_owner = N'dbo', @source_object = N'SkuServico', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'SkuServico', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'true', @ins_cmd = N'CALL [sp_MSins_dboSkuServico]', @del_cmd = N'CALL [sp_MSdel_dboSkuServico]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuServico]'

-- Adding the article's partition column(s)
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'IdSkuServico', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'IdSkuServicoTipo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'IdSku', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'Nome', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'GerencialId', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
EXEC sp_articlecolumn @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @column = N'Prazo', @operation = N'add', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1

-- Adding the article synchronization object
EXEC sp_articleview @publication = N'CORP_OUTROS_NPC', @article = N'SkuServico', @view_name = N'syncobj_0x3630373338363941', @filter_clause = N'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuServicoPrefixoExcecao', @source_owner = N'dbo', @source_object = N'SkuServicoPrefixoExcecao', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'SkuServicoPrefixoExcecao', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboSkuServicoPrefixoExcecao]', @del_cmd = N'CALL [sp_MSdel_dboSkuServicoPrefixoExcecao]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuServicoPrefixoExcecao]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'SkuServicoTipo', @source_owner = N'dbo', @source_object = N'SkuServicoTipo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'SkuServicoTipo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboSkuServicoTipo]', @del_cmd = N'CALL [sp_MSdel_dboSkuServicoTipo]', @upd_cmd = N'SCALL [sp_MSupd_dboSkuServicoTipo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'TipoCampo', @source_owner = N'dbo', @source_object = N'TipoCampo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TipoCampo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTipoCampo]', @del_cmd = N'CALL [sp_MSdel_dboTipoCampo]', @upd_cmd = N'SCALL [sp_MSupd_dboTipoCampo]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'TipoProgramaRecompensa', @source_owner = N'dbo', @source_object = N'TipoProgramaRecompensa', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TipoProgramaRecompensa', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTipoProgramaRecompensa]', @del_cmd = N'CALL [sp_MSdel_dboTipoProgramaRecompensa]', @upd_cmd = N'SCALL [sp_MSupd_dboTipoProgramaRecompensa]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'TipoSku', @source_owner = N'dbo', @source_object = N'TipoSku', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'TipoSku', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTipoSku]', @del_cmd = N'CALL [sp_MSdel_dboTipoSku]', @upd_cmd = N'SCALL [sp_MSupd_dboTipoSku]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'TipoTermoAceite', @source_owner = N'dbo', @source_object = N'TipoTermoAceite', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'TipoTermoAceite', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTipoTermoAceite]', @del_cmd = N'CALL [sp_MSdel_dboTipoTermoAceite]', @upd_cmd = N'SCALL [sp_MSupd_dboTipoTermoAceite]'
GO
USE [db_prd_corp]
EXEC sp_addarticle @publication = N'CORP_OUTROS_NPC', @article = N'ValeStatus', @source_owner = N'dbo', @source_object = N'ValeStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'none', @destination_table = N'ValeStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboValeStatus]', @del_cmd = N'CALL [sp_MSdel_dboValeStatus]', @upd_cmd = N'SCALL [sp_MSupd_dboValeStatus]'
GO

-- Adding the transactional subscriptions
USE [db_prd_corp]
EXEC sp_addsubscription @publication = N'CORP_OUTROS_NPC', @subscriber = N'ASPIREVXRBL', @destination_db = N'db_prd_loja', @subscription_type = N'Push', @sync_type = N'replication support only', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
EXEC sp_addpushsubscription_agent @publication = N'CORP_OUTROS_NPC', @subscriber = N'ASPIREVXRBL', @subscriber_db = N'db_prd_loja', @job_login = NULL, @job_password = NULL, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO

