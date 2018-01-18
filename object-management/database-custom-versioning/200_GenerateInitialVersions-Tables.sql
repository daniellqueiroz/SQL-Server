--TRUNCATE TABLE [HistoricoVersaoObjeto]
/*
select * from HistoricoVersaoObjeto 
where event='create_table'
and object='compra'
order by object


delete from HistoricoVersaoObjeto 
where event='create_table'
*/


declare Versaotabela cursor for
select name,schema_name(schema_id) from sys.tables where 1=1 and type='U' order by name
open versaotabela
declare @tabela varchar(200),@schema varchar(50)
declare @outp xml;
fetch next from versaotabela into @tabela,@schema
while @@FETCH_STATUS<>-1
begin
	exec sp_ScriptTable @tabela,@includeindexes=1,@out=@outp output; 


	INSERT INTO [dbo].[HistoricoVersaoObjeto]
           ([DatabaseName],[LoginName],[DataAlteracao],[DatabaseUser],[Event],[Schema],[Object],[Texto],[HostName],[Versao])
     VALUES
           (DB_NAME(),ORIGINAL_LOGIN(),GETDATE(), CONVERT(sysname, CURRENT_USER),'CREATE_TABLE', @schema, @tabela, @outp,host_name(),1)

fetch next from versaotabela into @tabela,@schema
end

close versaotabela
deallocate versaotabela