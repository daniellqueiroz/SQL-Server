select * from [dbo].[HistoricoVersaoObjeto] 
where 1=1
--AND Object='HistoricoVersaoObjeto'
AND Event='CREATE_FUNCTION'

select * from [dbo].[HistoricoVersaoObjeto] 
where 1=1
AND Object='trg_DataAtualizacaoSku_Sku'
AND Event='CREATE_trigger'


exec sp_helptext '[dbo].[ColecoesdoSku]'

