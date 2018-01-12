--TRUNCATE TABLE carrinhoskucarga

if object_id('SincronizacaoCarrinhoSkuMerge') is not null
	drop PROCEDURE SincronizacaoCarrinhoSkuMerge
GO
CREATE PROCEDURE SincronizacaoCarrinhoSkuMerge
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

UPDATE OPENQUERY ([10.128.65.28,1104],'select * from db_prd_casasbahia.dbo.ControleExtracao') SET DataHoraUltimaExtracao=@end_time WHERE tabela='CarrinhoSku';

with cte
as
(select * from CarrinhoSkuCarga where Operacao=4)
UPDATE [dbo].[CarrinhoSku]
   SET [IdCarrinhoSku] = cte.[IdCarrinhoSku]
      ,[UsuarioGUID] = cte.[UsuarioGUID]
      ,[IdSku] = cte.[IdSku]
      ,[Valor] = cte.[Valor]
      ,[IdLojista] = cte.[IdLojista]
      ,[Parceiro] = cte.[Parceiro]
      ,[Midia] = cte.[Midia]
      ,[Campanha] = cte.[Campanha]
      ,[DATA] = cte.[DATA]
      ,[IdListaDeCompra] = cte.[IdListaDeCompra]
      ,[DataCriacao] = cte.[DataCriacao]
      ,[FlagNews] = cte.[FlagNews]
      ,[Email] = cte.[Email]
from CarrinhoSku c inner join cte on cte.IdCarrinhoSku=c.IdCarrinhoSku;

with cte as 
(select [IdCarrinhoSku]
,[UsuarioGUID]
,[IdSku]
,[Valor]
,[IdLojista]
,[Parceiro]
,[Midia]
,[Campanha]
,[DATA]
,[IdListaDeCompra]
,[DataCriacao]
,[FlagNews]
,[Email] from CarrinhoSkuCarga where Operacao=2)
insert into CarrinhoSku ([IdCarrinhoSku]
,[UsuarioGUID]
,[IdSku]
,[Valor]
,[IdLojista]
,[Parceiro]
,[Midia]
,[Campanha]
,[DATA]
,[IdListaDeCompra]
,[DataCriacao]
,[FlagNews]
,[Email])
select [IdCarrinhoSku]
,[UsuarioGUID]
,[IdSku]
,[Valor]
,[IdLojista]
,[Parceiro]
,[Midia]
,[Campanha]
,[DATA]
,[IdListaDeCompra]
,[DataCriacao]
,[FlagNews]
,[Email] from cte where not exists(select top 1 1 from CarrinhoSku cs where cs.IdCarrinhoSku=cte.IdCarrinhoSku);

with cte as (select idcarrinhosku from CarrinhoSkuCarga where Operacao=1)
delete carrinhosku from CarrinhoSku inner join cte on CarrinhoSku.IdCarrinhoSku=cte.IdCarrinhoSku;



  
END TRY
BEGIN CATCH
	UPDATE OPENQUERY ([10.128.65.28,1104],'select * from db_prd_casasbahia.dbo.ControleExtracao') SET DataHoraUltimaExtracao=@DataOriginalExtracao WHERE tabela='CarrinhoSku';
	TRUNCATE TABLE CarrinhoSkuCarga;
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