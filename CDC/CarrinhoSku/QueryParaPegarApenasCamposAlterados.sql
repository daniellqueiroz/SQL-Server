
DECLARE @FromTime DATETIME,@end_time DATETIME
DECLARE @From_LSN binary(10), @to_lsn binary(10)

--SELECT DataHoraUltimaExtracao from dbo.ControleExtracao where tabela='CarrinhoSku';
--SELECT DATEADD(minute,-1,MAX(sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) FROM cdc.dbo_CarrinhoSku_CT

SELECT @end_time=DATEADD(minute,-1,MAX(sys.fn_cdc_map_lsn_to_time([__$start_lsn]))) FROM cdc.dbo_CarrinhoSku_CT
select top 1 @FromTime=DataHoraUltimaExtracao from dbo.ControleExtracao where tabela='CarrinhoSku';

SET @From_LSN = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @FromTime);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);


SELECT --sys.fn_cdc_map_lsn_to_time(up_a.__$start_lsn) as commit_time
up_a.column_name,
/*, up_b.old_value*/ 
up_a.new_value
,idcarrinhosku

FROM
    /*( SELECT __$start_lsn, column_name, old_value
    FROM (SELECT __$start_lsn,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','Valor'),__$update_mask) = 1) THEN CAST(Valor as sql_variant) ELSE NULL END AS Valor,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdLojista'),__$update_mask) = 1) THEN CAST (IdLojista as sql_variant) ELSE NULL END AS IdLojista,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdLojista'),__$update_mask) = 1) THEN CAST (IdSku as sql_variant) ELSE NULL END AS IdSku,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdLojista'),__$update_mask) = 1) THEN CAST (UsuarioGUID as sql_variant) ELSE NULL END AS UsuarioGUID,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdLojista'),__$update_mask) = 1) THEN CAST (DataCriacao as sql_variant) ELSE NULL END AS DataCriacao
    FROM cdc.fn_cdc_get_all_changes_dbo_CarrinhoSku(@from_lsn, @to_lsn, N'all update old')
    WHERE __$operation = 3) as t1
    UNPIVOT (old_value FOR column_name IN (IdLojista, Valor,IdSku,UsuarioGUID,DataCriacao) ) as unp) as up_b -- before update
INNER JOIN*/
    (SELECT TOP 1000 __$start_lsn, column_name, new_value,idcarrinhosku
    FROM (SELECT __$start_lsn,idcarrinhosku,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','Valor'),__$update_mask) = 1) THEN CAST(Valor as sql_variant) ELSE NULL END AS Valor,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdLojista'),__$update_mask) = 1) THEN CAST (IdLojista as sql_variant) ELSE NULL END AS IdLojista,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','IdSku'),__$update_mask) = 1) THEN CAST (IdSku as sql_variant) ELSE NULL END AS IdSku,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','UsuarioGUID'),__$update_mask) = 1) THEN CAST (UsuarioGUID as sql_variant) ELSE NULL END AS UsuarioGUID,
    CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('dbo_CarrinhoSku','DataCriacao'),__$update_mask) = 1) THEN CAST (DataCriacao as sql_variant) ELSE NULL END AS DataCriacao
    FROM cdc.fn_cdc_get_all_changes_dbo_CarrinhoSku(@from_lsn, @to_lsn, N'all') -- 'all update old' is not necessary here
    WHERE __$operation = 4) as t2
    UNPIVOT (new_value FOR column_name IN (IdLojista, Valor,IdSku,UsuarioGUID,DataCriacao) ) as unp ) as up_a -- after update
--ON up_b.__$start_lsn = up_a.__$start_lsn AND up_b.column_name = up_a.column_name

-- See more at: http://www.pythian.com/blog/cdc-and-unpivot/#sthash.vp4XEepM.dpuf