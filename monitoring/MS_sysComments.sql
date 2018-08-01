SELECT DISTINCT 'exec sp_helptext '+ object_name(id)
from sys.syscomments sc
INNER JOIN sys.objects o ON sc.id=o.object_id
where text like '%ClienteEnderecoListaV2%'
--where text like '%PedidosSige%''%update%[^a-z0-9]IX_Compra_IdListaDeCompraData[^a-z0-9]%IdEndereco%'
--AND o.type<>'TR'
--AND name NOT LIKE 'audit_%'
--AND name <> 'atualizaskualteracao'

--select * from sys.objects where name like 'data_stage%'
