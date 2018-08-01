--DELETE FROM [HistoricoVersaoObjeto] WHERE EVENT='CREATE_TRIGGER'

declare Versaotabela cursor for
select name from sys.triggers where name not like '%audit%' and name not like 'tr_ms%' order by name
open versaotabela
declare @tabela varchar(200),@schema varchar(50),@nomeCompleto varchar(150),@texto xml
declare @outp nvarchar(max);
fetch next from versaotabela into @tabela--,@schema
while @@FETCH_STATUS<>-1
begin
	
	set @nomeCompleto =  @tabela

	exec RetornaTextoTrigger @nomeCompleto,@cmd=@texto output

	--select @texto

	INSERT INTO [dbo].[HistoricoVersaoObjeto] ([DatabaseName],[LoginName],[DataAlteracao],[DatabaseUser],[Event],[Schema],[Object],[Texto],[HostName],[Versao])
    VALUES (DB_NAME(),ORIGINAL_LOGIN(),GETDATE(), CONVERT(sysname, CURRENT_USER),'CREATE_TRIGGER', @schema, @tabela, convert(nvarchar(max),@texto),host_name(),1)

fetch next from versaotabela into @tabela--,@schema
end

close versaotabela
deallocate versaotabela