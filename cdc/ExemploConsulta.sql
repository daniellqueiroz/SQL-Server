DECLARE @begin_time datetime, @end_time datetime, @from_lsn binary(10) , @to_lsn binary(10); 
SET @begin_time = GETDATE() -1; -- coloque a hora inicial aqui
SET @end_time = GETDATE(); -- coloque a hora final aqui
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @begin_time);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

--SELECT sys.fn_cdc_get_column_ordinal('ArquivoParceiroXml','idparceiro');

SELECT sys.fn_cdc_map_lsn_to_time(__$start_lsn) 'hora alteração'
--,DATEDIFF(mi,sys.fn_cdc_map_lsn_to_time(__$start_lsn),GETDATE()),
,CASE [__$operation] WHEN 4 THEN 'update - valor novo' WHEN 2 THEN 'insert' WHEN 1 THEN 'delete' WHEN 3 THEN 'update - valor antigo' END AS 'operação'
,[__$update_mask] ,IdArquivo, IdParceiro, NomeArquivo, UtmMedia, UtmCampanha, UtmParceiro, IdColecao, Desconto, ValidaEstoque, IdAdministrador, DataCadastro
FROM cdc.fn_cdc_get_all_changes_ArquivoParceiroXml(@from_lsn, @to_lsn, 'all update old')
--WHERE IdParceiro = 4
--AND sys.fn_cdc_map_lsn_to_time(__$start_lsn) > '2012-10-10 12:55:00'
ORDER BY [__$seqval];


--select top 10 * from dbo.ArquivoParceiroXml

