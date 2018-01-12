IF OBJECT_ID('dbo.ListarMudancasListaDeCompra','P') IS NOT NULL
DROP PROCEDURE dbo.ListarMudancasListaDeCompra
GO
CREATE PROCEDURE dbo.ListarMudancasListaDeCompra
@FromTime datetime,
@LastTime datetime OUTPUT
AS

DECLARE @From_LSN binary(10);
SET @From_LSN = sys.fn_cdc_map_time_to_lsn(
'smallest greater than or equal', @FromTime);

DECLARE @To_LSN binary(10);
SET @To_LSN = sys.fn_cdc_get_max_lsn();
SET @LastTime = sys.fn_cdc_map_lsn_to_time(@To_LSN);

SELECT  CASE [__$operation] WHEN 4 THEN 'Update' WHEN 1 THEN 'Delete' WHEN 2 THEN 'Insert' END AS Operacao
		--,[__$operation]
		,IdListaDeCompra ,
        IdCliente ,
        Nome ,
        Texto ,
        Mensagem ,
        QuantidadeVisitas ,
        DataEvento ,
        Visibilidade ,
        FlagAtivo ,
        FlagEnviadoSIGE ,
        DataCriacao ,
        IdCanalVenda ,
        IdAdministradorTelevenda ,
        IdTipoListaDeCompra
FROM cdc.fn_cdc_get_net_changes_dbo_ListaDeCompra (@From_LSN,@To_LSN,'all') AS cs



GO


-- Chamada
DECLARE @FromTime datetime = DATEADD(DAY,-1,SYSDATETIME());
DECLARE @LastTime datetime;
EXEC dbo.ListarMudancasListaDeCompra @FromTime, @LastTime OUTPUT;

select @LastTime;

