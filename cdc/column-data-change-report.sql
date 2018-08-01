--This is a query that uses fn_cdc_is_bit_set function to check wether or not a column was changed in the data captured by CDC
--Use this to get a better view of values before and after the change

DECLARE @begin_time datetime, @end_time datetime, @from_lsn binary(10) , @to_lsn binary(10); 
SET @begin_time = GETDATE() -1; -- low datetime limit
SET @end_time = GETDATE(); -- high datetime limit
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @begin_time);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

SELECT sys.fn_cdc_map_lsn_to_time(up_b.__$start_lsn) as commit_time, up_b.column_name, up_b.old_value, up_a.new_value
FROM
    ( 
		SELECT __$start_lsn, column_name, old_value
		FROM (
					SELECT __$start_lsn,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','IdParceiro'),__$update_mask) = 1) THEN CAST(IdParceiro as sql_variant) ELSE NULL END AS IdParceiro,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','IdArquivo'),__$update_mask) = 1) THEN CAST (IdArquivo as sql_variant) ELSE NULL END AS IdArquivo,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','NomeArquivo'),__$update_mask) = 1) THEN CAST (NomeArquivo as sql_variant) ELSE NULL END AS NomeArquivo,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmMedia'),__$update_mask) = 1) THEN CAST (UtmMedia as sql_variant) ELSE NULL END AS UtmMedia,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmCampanha'),__$update_mask) = 1) THEN CAST (UtmCampanha as sql_variant) ELSE NULL END AS UtmCampanha,
					CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmParceiro'),__$update_mask) = 1) THEN CAST (UtmParceiro as sql_variant) ELSE NULL END AS UtmParceiro
					FROM cdc.fn_cdc_get_all_changes_ArquivoParceiroXml(@from_lsn, @to_lsn, N'all update old') -- CDC instance here
					WHERE __$operation = 3
				) as t1
		UNPIVOT (old_value FOR column_name IN (IdParceiro, IdArquivo,NomeArquivo,UtmMedia,UtmCampanha,UtmParceiro) ) as unp -- report column list (columns that you want to check wether or not have changed)
    ) as up_b -- before update
INNER JOIN
    (
		SELECT __$start_lsn, column_name, new_value
		FROM 
		(
			SELECT __$start_lsn,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','IdParceiro'),__$update_mask) = 1) THEN CAST(IdParceiro as sql_variant) ELSE NULL END AS IdParceiro,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','IdArquivo'),__$update_mask) = 1) THEN CAST (IdArquivo as sql_variant) ELSE NULL END AS IdArquivo,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','NomeArquivo'),__$update_mask) = 1) THEN CAST (NomeArquivo as sql_variant) ELSE NULL END AS NomeArquivo,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmMedia'),__$update_mask) = 1) THEN CAST (UtmMedia as sql_variant) ELSE NULL END AS UtmMedia,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmCampanha'),__$update_mask) = 1) THEN CAST (UtmCampanha as sql_variant) ELSE NULL END AS UtmCampanha,
			CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal ('ArquivoParceiroXml','UtmParceiro'),__$update_mask) = 1) THEN CAST (UtmParceiro as sql_variant) ELSE NULL END AS UtmParceiro
			FROM cdc.fn_cdc_get_all_changes_ArquivoParceiroXml(@from_lsn, @to_lsn, N'all') -- CDC instance here
			WHERE __$operation = 4
		) as t2
		UNPIVOT (new_value FOR column_name IN (IdParceiro, IdArquivo,NomeArquivo,UtmMedia,UtmCampanha,UtmParceiro) ) as unp -- report column list (columns that you want to check wether or not have changed)
    ) as up_a -- after update
ON up_b.__$start_lsn = up_a.__$start_lsn AND up_b.column_name = up_a.column_name

