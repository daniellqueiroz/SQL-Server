/*
EXEC sys.sp_cdc_disable_table
@source_schema = 'dbo',
@source_name = 'CarrinhoSku',
@capture_instance='dbo_CarrinhoSku'
GO
*/

/*
UPDATE dbo.CarrinhoSku SET Valor=2.00,idlojista=16 WHERE IdCarrinhoSku=14993948
UPDATE dbo.CarrinhoSku SET DataCriacao='2013-08-01',PresenteDe='rafael',PresentePara='jose' WHERE IdCarrinhoSku=14994434
UPDATE dbo.Carrinho SET Parceiro='rafael',Midia='jose' WHERE UsuarioGUID='91dd6fe9-d68b-4caf-9554-da9a242af78c'

SELECT TOP 10 * FROM dbo.CarrinhoSku nolock
select * from controleextracao
SELECT DATEADD(minute,-1,MAX(sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) FROM cdc.dbo_CarrinhoSku_CT

select sys.fn_cdc_map_lsn_to_time(sys.fn_cdc_get_max_lsn())
select sys.fn_cdc_map_lsn_to_time(sys.fn_cdc_get_min_lsn('dbo_CarrrinhoSku'))

INSERT INTO dbo.CarrinhoSku
        ( UsuarioGUID ,
          IdSku ,
          Valor ,
          PresenteMensagem ,
          PresenteDe ,
          PresentePara ,
          IdCarrinhoSkuPai ,
          IdLojista
        )
VALUES  ( '7af588fc-bc87-4a96-9e87-619a877db616' ,
          195036 ,
          50.00 ,
          '' ,
          '' ,
          '' ,
          NULL ,
          15
        );
carrinho*/
--DELETE FROM carrinhosku WHERE IdCarrinhoSku=14994237

select * from controleextracao
--UPDATE dbo.ControleExtracao SET DataHoraUltimaExtracao='2013-08-06 05:25:42.630'
--2013-08-06 05:25:42.630

SELECT TOP 100 __$start_lsn,
__$operation,
__$update_mask, sys.fn_cdc_map_lsn_to_time([__$start_lsn])
,cs.IdCarrinhoSku,cs.UsuarioGUID,cs.IdSku,cs.Valor,cs.IdLojista,cs.DataCriacao
FROM cdc.dbo_CarrinhoSku_CT cs INNER JOIN dbo.Carrinho c ON cs.UsuarioGUID = c.UsuarioGUID
WHERE sys.fn_cdc_map_lsn_to_time([__$start_lsn])>'2013-08-06 20:06:00.943'
AND __$operation=4
ORDER BY __$start_lsn;

SELECT DATEADD(minute,-1,MAX(sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) FROM cdc.dbo_CarrinhoSku_CT cs





/*
DECLARE @FromTime datetime2
DECLARE @LastTime DATETIME2=SYSDATETIME();
select top 1 @FromTime=DataHoraUltimaExtracao from DB_STG_EXTRA.dbo.ControleExtracao where tabela='CarrinhoSku'
EXEC dbo.ListarMudancasCarrinhoSku @FromTime

select datediff(minute,SYSDATETIME(),DataHoraUltimaExtracao) from ControleExtracao
SELECT SYSDATETIME()


*/
--UPDATE dbo.ControleExtracao set DataHoraUltimaExtracao=DATEADD(DAY,-1,SYSDATETIME()) where tabela='carrinhosku'
