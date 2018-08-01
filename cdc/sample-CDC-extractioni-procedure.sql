
IF OBJECT_ID('dbo.ListarMudancasCarrinhoSku','P') IS NOT NULL
DROP PROCEDURE dbo.ListarMudancasCarrinhoSku
GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.ListarMudancasCarrinhoSku
--@FromTime datetime
AS
DECLARE @FromTime DATETIME,@end_time DATETIME
DECLARE @From_LSN binary(10), @to_lsn binary(10)

SELECT @end_time=DATEADD(minute,-1,MAX(sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) FROM cdc.dbo_CarrinhoSku_CT
select top 1 @FromTime=DataHoraUltimaExtracao from dbo.ControleExtracao where tabela='CarrinhoSku';

SET @From_LSN = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @FromTime);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

SELECT __$start_lsn,
__$operation,
__$update_mask
,cs.IdCarrinhoSku,cs.UsuarioGUID,cs.IdSku,cs.Valor,cs.IdLojista,c.Parceiro,c.Midia,c.Campanha,c.Data,c.IdListaDeCompra,cs.DataCriacao
,CL.FLAGNEWS,CL.EMAIL
FROM cdc.fn_cdc_get_net_changes_dbo_CarrinhoSku (@From_LSN,@To_LSN,'all') AS cs
INNER JOIN dbo.Carrinho c ON c.UsuarioGUID = cs.UsuarioGUID
INNER JOIN DBO.CLIENTE CL ON cL.UsuarioGUID = cS.UsuarioGUID;

GO

