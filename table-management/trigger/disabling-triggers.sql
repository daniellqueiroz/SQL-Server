declare @trigger varchar(50),@cmd varchar(4000),@tabela varchar(50)
declare trigg cursor  for
select name,OBJECT_NAME(parent_id) from sys.triggers 
where 1=1
--AND parent_id = object_id('sku') or parent_id = object_id('produto')
AND name LIKE '%audit%'
open trigg
fetch next from trigg into @trigger,@tabela
while @@FETCH_STATUS <> -1
begin
	set @cmd = 'disable trigger ' + @trigger + ' on ' + @tabela + ';'
	print(@cmd)
fetch next from trigg into @trigger,@tabela
end
close trigg
deallocate trigg

--select is_disabled,* from sys.triggers where parent_id = object_id('sku') or parent_id = object_id('produto')

 /*
disable trigger tr_u_AUDIT_Sku on Sku;
disable trigger tr_d_AUDIT_Categoria on Categoria;
disable trigger tr_d_AUDIT_Produto on Produto;
disable trigger tr_d_AUDIT_Sku on Sku;
disable trigger tr_i_AUDIT_Categoria on Categoria;
disable trigger tr_i_AUDIT_Produto on Produto;
disable trigger tr_i_AUDIT_Sku on Sku;
disable trigger tr_u_AUDIT_Categoria on Categoria;
disable trigger tr_u_AUDIT_Produto on Produto;
*/

