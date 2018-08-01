--DELETE FROM [HistoricoVersaoObjeto] WHERE EVENT='CREATE_FUNCTION'

declare Versaotabela cursor for
select ROUTINE_NAME,ROUTINE_SCHEMA--, * 
from INFORMATION_SCHEMA.ROUTINES where 1=1 and ROUTINE_TYPE='FUNCTION' order by routine_name
open versaotabela
declare @tabela varchar(200),@schema varchar(50),@nomeCompleto varchar(150),@texto xml
declare @outp nvarchar(max);
fetch next from versaotabela into @tabela,@schema
while @@FETCH_STATUS<>-1
begin
	
	set @nomeCompleto = @schema + '.' + @tabela

	exec RetornaTextoFunc @nomeCompleto,@cmd=@texto output

	--select @texto

	INSERT INTO [dbo].[HistoricoVersaoObjeto] ([DatabaseName],[LoginName],[DataAlteracao],[DatabaseUser],[Event],[Schema],[Object],[Texto],[HostName],[Versao])
    VALUES (DB_NAME(),ORIGINAL_LOGIN(),GETDATE(), CONVERT(sysname, CURRENT_USER),'CREATE_FUNCTION', @schema, @tabela, convert(nvarchar(max),@texto),host_name(),1)

fetch next from versaotabela into @tabela,@schema
end

close versaotabela
deallocate versaotabela