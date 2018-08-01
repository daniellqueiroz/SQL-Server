/*

Remarks:

1. This script leaves only the relevant data on the Customer table, getting rid of sensitive data from production customers for security reasons
2. The script generates a new customer table, while recreating all constraints and indexes aftwerwards
3. This script has a lot of space for improvement. One of them is the dynamic drop and recreation of the objects related to the base object (Customer table, in this case)

*/


BEGIN TRY
--select count(*) from Cliente where IdAdministradorTelevenda not in ( select IdAdministrador from Administrador);
--delete from Cliente where IdAdministradorTelevenda not in ( select IdAdministrador from Administrador);
IF OBJECT_ID('FK_Cliente_Administrador') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_Administrador

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where UsuarioGUID not in ( select UsuarioGUID from Carrinho);
--delete from Cliente where UsuarioGUID not in ( select UsuarioGUID from Carrinho);
IF OBJECT_ID('FK_Cliente_Carrinho') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_Carrinho

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdClienteEnderecoCobranca not in ( select IdClienteEndereco from ClienteEndereco);
--delete from Cliente where IdClienteEnderecoCobranca not in ( select IdClienteEndereco from ClienteEndereco);
IF OBJECT_ID('FK_Cliente_ClienteEndereco_Cobranca') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_ClienteEndereco_Cobranca

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdEscolaridade not in ( select IdEscolaridade from Escolaridade);
--delete from Cliente where IdEscolaridade not in ( select IdEscolaridade from Escolaridade);
IF OBJECT_ID('FK_Cliente_Escolaridade') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_Escolaridade

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdEstadoCivil not in ( select IdEstadoCivil from EstadoCivil);
--delete from Cliente where IdEstadoCivil not in ( select IdEstadoCivil from EstadoCivil);
IF OBJECT_ID('FK_Cliente_EstadoCivil') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_EstadoCivil

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdProfissao not in ( select IdProfissao from Profissao);
--delete from Cliente where IdProfissao not in ( select IdProfissao from Profissao);
IF OBJECT_ID('FK_Cliente_Profissao') IS NOT NULL ALTER TABLE Cliente DROP CONSTRAINT FK_Cliente_Profissao

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteAlimentos where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteAlimentos where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteAlimentos_Cliente') IS NOT NULL ALTER TABLE ClienteAlimentos DROP CONSTRAINT FK_ClienteAlimentos_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteArquivo where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteArquivo where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteArquivo_Cliente') IS NOT NULL ALTER TABLE ClienteArquivo DROP CONSTRAINT FK_ClienteArquivo_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteCampoClienteValor where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteCampoClienteValor where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteCampoClienteValor_Cliente') IS NOT NULL ALTER TABLE ClienteCampoClienteValor DROP CONSTRAINT FK_ClienteCampoClienteValor_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteEndereco where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteEndereco where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteEndereco_Cliente') IS NOT NULL ALTER TABLE ClienteEndereco DROP CONSTRAINT FK_ClienteEndereco_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteFormaPagamento where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteFormaPagamento where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteFormaPagamento_Cliente') IS NOT NULL ALTER TABLE ClienteFormaPagamento DROP CONSTRAINT FK_ClienteFormaPagamento_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteIA where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteIA where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteIA_Cliente') IS NOT NULL ALTER TABLE ClienteIA DROP CONSTRAINT FK_ClienteIA_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePaypal where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePaypal where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePaypal_Cliente') IS NOT NULL ALTER TABLE ClientePaypal DROP CONSTRAINT FK_ClientePaypal_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePermissao where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePermissao where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePermissao_Cliente') IS NOT NULL ALTER TABLE ClientePermissao DROP CONSTRAINT FK_ClientePermissao_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePromocaoVisa where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePromocaoVisa where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePromocaoVisa_Cliente') IS NOT NULL ALTER TABLE ClientePromocaoVisa DROP CONSTRAINT FK_ClientePromocaoVisa_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteReaction where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteReaction where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteReaction_Cliente') IS NOT NULL ALTER TABLE ClienteReaction DROP CONSTRAINT FK_ClienteReaction_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteRedeSocial where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteRedeSocial where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteRedeSocial_Cliente') IS NOT NULL ALTER TABLE ClienteRedeSocial DROP CONSTRAINT FK_ClienteRedeSocial_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Compra where IdCliente not in ( select IdCliente from Cliente);
--delete from Compra where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Compra_Cliente') IS NOT NULL ALTER TABLE Compra DROP CONSTRAINT FK_Compra_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Contrato where IdCliente not in ( select IdCliente from Cliente);
--delete from Contrato where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Contrato_Cliente') IS NOT NULL ALTER TABLE Contrato DROP CONSTRAINT FK_Contrato_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Email where IdCliente not in ( select IdCliente from Cliente);
--delete from Email where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Email_Cliente') IS NOT NULL ALTER TABLE Email DROP CONSTRAINT FK_Email_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ListaCasamentoItemComprado where IdCliente not in ( select IdCliente from Cliente);
--delete from ListaCasamentoItemComprado where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ListaCasamentoItemComprado_Cliente') IS NOT NULL ALTER TABLE ListaCasamentoItemComprado DROP CONSTRAINT FK_ListaCasamentoItemComprado_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ListaDeCompra where IdCliente not in ( select IdCliente from Cliente);
--delete from ListaDeCompra where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ListaDeCompra_Cliente') IS NOT NULL ALTER TABLE ListaDeCompra DROP CONSTRAINT FK_ListaDeCompra_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Resenha where IdCliente not in ( select IdCliente from Cliente);
--delete from Resenha where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Resenha_Cliente') IS NOT NULL ALTER TABLE Resenha DROP CONSTRAINT FK_Resenha_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ResenhaClienteAjudou where IdCliente not in ( select IdCliente from Cliente);
--delete from ResenhaClienteAjudou where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ResenhaClienteAjudou_Cliente') IS NOT NULL ALTER TABLE ResenhaClienteAjudou DROP CONSTRAINT FK_ResenhaClienteAjudou_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from TagCliente where IdCliente not in ( select IdCliente from Cliente);
--delete from TagCliente where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_TagCliente_Cliente') IS NOT NULL ALTER TABLE TagCliente DROP CONSTRAINT FK_TagCliente_Cliente

END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_SenhaHash]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_SenhaHash]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagSMSNews]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_FlagSMSNews]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagPedidoSiteAnt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_FlagPedidoSiteAnt]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagListaSiteAnt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_FlagListaSiteAnt]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagEmailInvalido]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_FlagEmailInvalido]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_flagclienteatribuimailmktspam]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_flagclienteatribuimailmktspam]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_DataUltimaAtualizacao]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_DataUltimaAtualizacao]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_DataAtualizacaoFLagNews]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT [DF_Cliente_DataAtualizacaoFLagNews]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_DataAtualizacaoFLagNews]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_DataAtualizacaoFLagNews]  DEFAULT (GETDATE()) FOR [DataAtualizacaoFlagNews]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_DataUltimaAtualizacao]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_DataUltimaAtualizacao]  DEFAULT (GETDATE()) FOR [DataUltimaAtualizacao]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_flagclienteatribuimailmktspam]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_flagclienteatribuimailmktspam]  DEFAULT ((0)) FOR [flagclienteatribuimailmktspam]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagEmailInvalido]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_FlagEmailInvalido]  DEFAULT ((0)) FOR [FlagEmailInvalido]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagListaSiteAnt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_FlagListaSiteAnt]  DEFAULT ((0)) FOR [FlagListaSiteAnt]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagPedidoSiteAnt]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_FlagPedidoSiteAnt]  DEFAULT ((0)) FOR [FlagPedidoSiteAnt]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_FlagSMSNews]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_FlagSMSNews]  DEFAULT ((0)) FOR [FlagSMSNews]
END

GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Cliente_SenhaHash]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Cliente] ADD  CONSTRAINT [DF_Cliente_SenhaHash]  DEFAULT ('576ACB8B4B40DBBE4157440D65899B9AACDB73F68385453002523C2ACEC731A6DA3EFA87') FOR [SenhaHash]
END

GO

IF OBJECT_ID('clientetmp') IS NOT NULL
DROP TABLE clientetmp
GO

SELECT * INTO clientetmp FROM cliente WHERE 1=2
ALTER TABLE [dbo].clientetmp ADD  CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SSD_PF_01]
GO

INSERT INTO clientetmp WITH(TABLOCK)
SELECT * FROM cliente WHERE (email LIKE '%@corp.pontofrio.com' OR email LIKE '%@stress.com' OR email LIKE '%@teste%')

DROP TABLE dbo.Cliente
EXEC sp_rename 'clientetmp','Cliente'


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_TECH4B_CLIENTE')
DROP INDEX [IX_TECH4B_CLIENTE] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_UsuarioGUID')
DROP INDEX [IX_Cliente_UsuarioGUID] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'ix_cliente_tel')
DROP INDEX [ix_cliente_tel] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_Nome')
DROP INDEX [IX_Cliente_Nome] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_IdCliente')
DROP INDEX [IX_Cliente_IdCliente] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_Email')
DROP INDEX [IX_Cliente_Email] ON [dbo].[Cliente]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_CPFCNPJ')
DROP INDEX [IX_Cliente_CPFCNPJ] ON [dbo].[Cliente]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_CPFCNPJ')
CREATE NONCLUSTERED INDEX [IX_Cliente_CPFCNPJ] ON [dbo].[Cliente]
(
	[CpfCnpj] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_Email')
CREATE NONCLUSTERED INDEX [IX_Cliente_Email] ON [dbo].[Cliente]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_IdCliente')
CREATE NONCLUSTERED INDEX [IX_Cliente_IdCliente] ON [dbo].[Cliente]
(
	[IdCliente] ASC
)
INCLUDE ( 	[Sexo],
	[Nome],
	[Sobrenome],
	[Email],
	[FlagPj],
	[RazaoSocial]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_Nome')
CREATE NONCLUSTERED INDEX [IX_Cliente_Nome] ON [dbo].[Cliente]
(
	[Nome] ASC,
	[Sobrenome] ASC
)
INCLUDE ( 	[IdCliente]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'ix_cliente_tel')
CREATE NONCLUSTERED INDEX [ix_cliente_tel] ON [dbo].[Cliente]
(
	[TelefoneResidencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_Cliente_UsuarioGUID')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Cliente_UsuarioGUID] ON [dbo].[Cliente]
(
	[UsuarioGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND name = N'IX_TECH4B_CLIENTE')
CREATE NONCLUSTERED INDEX [IX_TECH4B_CLIENTE] ON [dbo].[Cliente]
(
	[DataCriacao] ASC
)
INCLUDE ( 	[CpfCnpj],
	[DataNascimento],
	[Email],
	[IdCliente],
	[Nome],
	[Sexo],
	[Sobrenome]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

BEGIN TRY
--select count(*) from Cliente where IdAdministradorTelevenda not in ( select IdAdministrador from Administrador);
--delete from Cliente where IdAdministradorTelevenda not in ( select IdAdministrador from Administrador);
IF OBJECT_ID('FK_Cliente_Administrador') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_Administrador FOREIGN KEY (IdAdministradorTelevenda) REFERENCES Administrador (IdAdministrador)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where UsuarioGUID not in ( select UsuarioGUID from Carrinho);
--delete from Cliente where UsuarioGUID not in ( select UsuarioGUID from Carrinho);
IF OBJECT_ID('FK_Cliente_Carrinho') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_Carrinho FOREIGN KEY (UsuarioGUID) REFERENCES Carrinho (UsuarioGUID)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdClienteEnderecoCobranca not in ( select IdClienteEndereco from ClienteEndereco);
--delete from Cliente where IdClienteEnderecoCobranca not in ( select IdClienteEndereco from ClienteEndereco);
IF OBJECT_ID('FK_Cliente_ClienteEndereco_Cobranca') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_ClienteEndereco_Cobranca FOREIGN KEY (IdClienteEnderecoCobranca) REFERENCES ClienteEndereco (IdClienteEndereco)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdEscolaridade not in ( select IdEscolaridade from Escolaridade);
--delete from Cliente where IdEscolaridade not in ( select IdEscolaridade from Escolaridade);
IF OBJECT_ID('FK_Cliente_Escolaridade') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_Escolaridade FOREIGN KEY (IdEscolaridade) REFERENCES Escolaridade (IdEscolaridade)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdEstadoCivil not in ( select IdEstadoCivil from EstadoCivil);
--delete from Cliente where IdEstadoCivil not in ( select IdEstadoCivil from EstadoCivil);
IF OBJECT_ID('FK_Cliente_EstadoCivil') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_EstadoCivil FOREIGN KEY (IdEstadoCivil) REFERENCES EstadoCivil (IdEstadoCivil)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Cliente where IdProfissao not in ( select IdProfissao from Profissao);
--delete from Cliente where IdProfissao not in ( select IdProfissao from Profissao);
IF OBJECT_ID('FK_Cliente_Profissao') IS  NULL ALTER TABLE Cliente WITH NOCHECK ADD CONSTRAINT FK_Cliente_Profissao FOREIGN KEY (IdProfissao) REFERENCES Profissao (IdProfissao)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteAlimentos where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteAlimentos where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteAlimentos_Cliente') IS  NULL ALTER TABLE ClienteAlimentos WITH NOCHECK ADD CONSTRAINT FK_ClienteAlimentos_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteArquivo where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteArquivo where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteArquivo_Cliente') IS  NULL ALTER TABLE ClienteArquivo WITH NOCHECK ADD CONSTRAINT FK_ClienteArquivo_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteCampoClienteValor where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteCampoClienteValor where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteCampoClienteValor_Cliente') IS  NULL ALTER TABLE ClienteCampoClienteValor WITH NOCHECK ADD CONSTRAINT FK_ClienteCampoClienteValor_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteEndereco where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteEndereco where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteEndereco_Cliente') IS  NULL ALTER TABLE ClienteEndereco WITH NOCHECK ADD CONSTRAINT FK_ClienteEndereco_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteFormaPagamento where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteFormaPagamento where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteFormaPagamento_Cliente') IS  NULL ALTER TABLE ClienteFormaPagamento WITH NOCHECK ADD CONSTRAINT FK_ClienteFormaPagamento_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteIA where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteIA where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteIA_Cliente') IS  NULL ALTER TABLE ClienteIA WITH NOCHECK ADD CONSTRAINT FK_ClienteIA_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePaypal where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePaypal where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePaypal_Cliente') IS  NULL ALTER TABLE ClientePaypal WITH NOCHECK ADD CONSTRAINT FK_ClientePaypal_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePermissao where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePermissao where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePermissao_Cliente') IS  NULL ALTER TABLE ClientePermissao WITH NOCHECK ADD CONSTRAINT FK_ClientePermissao_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClientePromocaoVisa where IdCliente not in ( select IdCliente from Cliente);
--delete from ClientePromocaoVisa where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClientePromocaoVisa_Cliente') IS  NULL ALTER TABLE ClientePromocaoVisa WITH NOCHECK ADD CONSTRAINT FK_ClientePromocaoVisa_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteReaction where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteReaction where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteReaction_Cliente') IS  NULL ALTER TABLE ClienteReaction WITH NOCHECK ADD CONSTRAINT FK_ClienteReaction_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ClienteRedeSocial where IdCliente not in ( select IdCliente from Cliente);
--delete from ClienteRedeSocial where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ClienteRedeSocial_Cliente') IS  NULL ALTER TABLE ClienteRedeSocial WITH NOCHECK ADD CONSTRAINT FK_ClienteRedeSocial_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Compra where IdCliente not in ( select IdCliente from Cliente);
--delete from Compra where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Compra_Cliente') IS  NULL ALTER TABLE Compra WITH NOCHECK ADD CONSTRAINT FK_Compra_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Contrato where IdCliente not in ( select IdCliente from Cliente);
--delete from Contrato where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Contrato_Cliente') IS  NULL ALTER TABLE Contrato WITH NOCHECK ADD CONSTRAINT FK_Contrato_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Email where IdCliente not in ( select IdCliente from Cliente);
--delete from Email where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Email_Cliente') IS  NULL ALTER TABLE Email WITH NOCHECK ADD CONSTRAINT FK_Email_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ListaCasamentoItemComprado where IdCliente not in ( select IdCliente from Cliente);
--delete from ListaCasamentoItemComprado where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ListaCasamentoItemComprado_Cliente') IS  NULL ALTER TABLE ListaCasamentoItemComprado WITH NOCHECK ADD CONSTRAINT FK_ListaCasamentoItemComprado_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ListaDeCompra where IdCliente not in ( select IdCliente from Cliente);
--delete from ListaDeCompra where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ListaDeCompra_Cliente') IS  NULL ALTER TABLE ListaDeCompra WITH NOCHECK ADD CONSTRAINT FK_ListaDeCompra_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from Resenha where IdCliente not in ( select IdCliente from Cliente);
--delete from Resenha where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_Resenha_Cliente') IS  NULL ALTER TABLE Resenha WITH NOCHECK ADD CONSTRAINT FK_Resenha_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from ResenhaClienteAjudou where IdCliente not in ( select IdCliente from Cliente);
--delete from ResenhaClienteAjudou where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_ResenhaClienteAjudou_Cliente') IS  NULL ALTER TABLE ResenhaClienteAjudou WITH NOCHECK ADD CONSTRAINT FK_ResenhaClienteAjudou_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

BEGIN TRY
--select count(*) from TagCliente where IdCliente not in ( select IdCliente from Cliente);
--delete from TagCliente where IdCliente not in ( select IdCliente from Cliente);
IF OBJECT_ID('FK_TagCliente_Cliente') IS  NULL ALTER TABLE TagCliente WITH NOCHECK ADD CONSTRAINT FK_TagCliente_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)  ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()
END CATCH

