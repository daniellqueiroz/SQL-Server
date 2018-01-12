/*
	NÃO ESQUECER DE CARREGAR A TABELA CARRINHOSKU APÓS CRIAÇÃO
*/



-- Criar no CRM
if object_id('[CarrinhoSkuCarga]') is not null
	drop TABLE [dbo].[CarrinhoSkuCarga]
GO
CREATE TABLE [dbo].[CarrinhoSkuCarga](
	StartLSN binary(10) NOT NULL,
	Operacao INT,
	UpdateMask VARBINARY(128) NULL,
	[IdCarrinhoSku] [bigint] NOT NULL ,
	[UsuarioGUID] [nchar](36) NOT NULL,
	[IdSku] [int] NOT NULL,
	[Valor] [money] NOT NULL,
	[IdLojista] [int] NOT NULL,
	Parceiro VARCHAR(100) NULL,
	Midia VARCHAR(100) NULL,
	Campanha varchar(100) NULL,
	DATA SMALLDATETIME NULL,
	IdListaDeCompra INT NULL,
	DataCriacao DateTime NULL
	,FlagNews bit null
	,Email varchar(100) null
	
)
GO
ALTER TABLE dbo.CarrinhoSkuCarga ADD CONSTRAINT PK_CarrinhoSkuCarga PRIMARY KEY (IdCarrinhoSku)
GO

-- Criar no CRM
if object_id('[CarrinhoSku]') is not null
	drop TABLE [dbo].[CarrinhoSku]
GO
CREATE TABLE [dbo].[CarrinhoSku](
	[IdCarrinhoSku] [bigint] NOT NULL ,
	[UsuarioGUID] [nchar](36) NOT NULL,
	[IdSku] [int] NOT NULL,
	[Valor] [money] NOT NULL,
	[IdLojista] [int] NOT NULL,
	Parceiro VARCHAR(100) NULL,
	Midia VARCHAR(100) NULL,
	Campanha varchar(100) NULL,
	DATA SMALLDATETIME NULL,
	IdListaDeCompra INT NULL,
	DataCriacao DateTime NULL
	,FlagNews bit null
	,Email varchar(100) null
	
)
GO
ALTER TABLE dbo.[CarrinhoSku] ADD CONSTRAINT PK_CarrinhoSku PRIMARY KEY (IdCarrinhoSku)
GO


if object_id('SincronizacaoCarrinhoSku') is not null
	drop PROCEDURE SincronizacaoCarrinhoSku
GO
CREATE PROCEDURE SincronizacaoCarrinhoSku
AS
BEGIN
SET NOCOUNT ON

BEGIN TRY

DECLARE @erro VARCHAR(max)
DECLARE @DataOriginalExtracao DATETIME,@end_time DATETIME;
select @DataOriginalExtracao=DataHoraUltimaExtracao from openquery([10.128.65.28,1104],'select top 1 DataHoraUltimaExtracao from db_prd_casasbahia.dbo.ControleExtracao where tabela=''CarrinhoSku''');
select @end_time=NextEndTime from openquery([10.128.65.28,1104],'select DATEADD(minute,-1,MAX(db_prd_casasbahia.sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) as NextEndTime FROM db_prd_casasbahia.cdc.dbo_CarrinhoSku_CT');

INSERT INTO [CarrinhoSkuCarga] ( StartLSN ,Operacao ,UpdateMask ,IdCarrinhoSku ,UsuarioGUID ,IdSku ,Valor ,IdLojista ,Parceiro ,Midia ,Campanha ,DATA ,IdListaDeCompra ,DataCriacao,FlagNews,Email)
select * from openquery([10.128.65.28,1104],'EXEC db_prd_casasbahia.dbo.ListarMudancasCarrinhoSku');

UPDATE OPENQUERY ([10.128.65.28,1104],'select * from db_prd_casasbahia.dbo.ControleExtracao') SET DataHoraUltimaExtracao=@end_time WHERE tabela='CarrinhoSku'

DECLARE @Operacao INT,@IdCarrinhoSku [bigint] ,
	@UsuarioGUID [nchar](36),
	@IdSku [int],
	@Valor [money],
	@IdLojista [int],
	@Parceiro VARCHAR(100),
	@Midia VARCHAR(100),
	@Campanha varchar(100),
	@DATA SMALLDATETIME,
	@IdListaDeCompra INT,
	@DataCriacao DateTime
	,@FlagNews bit
	,@Email varchar(100)
	
DECLARE c CURSOR FAST_FORWARD FOR 
SELECT  Operacao ,IdCarrinhoSku ,UsuarioGUID ,IdSku ,Valor ,IdLojista ,Parceiro ,Midia ,Campanha ,DATA ,IdListaDeCompra,DataCriacao,FlagNews,Email FROM dbo.CarrinhoSkuCarga
OPEN c
FETCH NEXT FROM c INTO @Operacao ,@IdCarrinhoSku  ,@UsuarioGUID, @IdSku ,@Valor ,@IdLojista ,@Parceiro ,@Midia ,@Campanha ,@DATA ,@IdListaDeCompra,@DataCriacao,@FlagNews,@Email
WHILE @@FETCH_STATUS <> -1
BEGIN
	IF @Operacao=4 --AND EXISTS(SELECT TOP 1 1 FROM dbo.CarrinhoSku WHERE IdCarrinhoSku=@IdCarrinhoSku)
		UPDATE dbo.CarrinhoSku SET Campanha=@campanha, DATA=@data,IdListaDeCompra=@IdListaDeCompra,IdLojista=@IdLojista,IdSku=@IdSku,Midia=@midia,Parceiro=@parceiro,UsuarioGUID=@UsuarioGUID,valor=@Valor,DataCriacao=@DataCriacao,FlagNews=@FlagNews,Email=@Email WHERE IdCarrinhoSku=@IdCarrinhoSku
	ELSE IF @Operacao=2 AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.CarrinhoSku WHERE IdCarrinhoSku=@IdCarrinhoSku)
		INSERT INTO dbo.CarrinhoSku( IdCarrinhoSku ,UsuarioGUID ,IdSku ,Valor ,IdLojista ,Parceiro ,Midia ,Campanha ,DATA ,IdListaDeCompra,DataCriacao,FlagNews,Email)
		VALUES  ( @IdCarrinhoSku ,@UsuarioGUID ,@idsku ,@valor ,@idlojista ,@Parceiro ,@midia ,@campanha ,@data ,@IdListaDeCompra,@DataCriacao,@FlagNews,@Email )
	ELSE IF @Operacao=1
		DELETE FROM dbo.CarrinhoSku WHERE IdCarrinhoSku=@IdCarrinhoSku
FETCH NEXT FROM c INTO @Operacao ,@IdCarrinhoSku  ,@UsuarioGUID, @IdSku ,@Valor ,@IdLojista ,@Parceiro ,@Midia ,@Campanha ,@DATA ,@IdListaDeCompra ,@DataCriacao,@FlagNews,@Email
END
CLOSE c 
DEALLOCATE c
END TRY
BEGIN CATCH
	UPDATE OPENQUERY ([10.128.65.28,1104],'select * from db_prd_casasbahia.dbo.ControleExtracao') SET DataHoraUltimaExtracao=@DataOriginalExtracao WHERE tabela='CarrinhoSku';
	DECLARE

        @ERROR_SEVERITY INT,

        @ERROR_STATE INT,

        @ERROR_NUMBER INT,

        @ERROR_LINE INT,

        @ERROR_MESSAGE VARCHAR(245)



    SELECT

        @ERROR_SEVERITY = ERROR_SEVERITY(),

        @ERROR_STATE = ERROR_STATE(),

        @ERROR_NUMBER = ERROR_NUMBER(),

        @ERROR_LINE = ERROR_LINE(),

        @ERROR_MESSAGE = ERROR_MESSAGE()



     IF @ERROR_NUMBER = 313

            RAISERROR(

                 'Either a range parameter or the row filter option is not valid.', 

                 @ERROR_SEVERITY, @ERROR_STATE)

     ELSE

     IF @ERROR_NUMBER = 229

            RAISERROR(

                 'The caller is not authorized to perform the query.', 

                 @ERROR_SEVERITY, @ERROR_STATE)

     ELSE

            RAISERROR('Msg %d, Line %d: %s',

                 @ERROR_SEVERITY, @ERROR_STATE, @ERROR_NUMBER,

                 @ERROR_LINE, @ERROR_MESSAGE) 
END catch

END


-- Procedimento de atualização (Rodar a cada 10 minutos)
--step 02
EXEC SincronizacaoCarrinhoSku
--step 3 (Só deve executar caso o step acima for ok
DELETE FROM  dbo.CarrinhoSkuCarga


