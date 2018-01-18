--DELETE FROM [HistoricoVersaoObjeto] WHERE EVENT='CREATE_PROCEDURE'
SET NOCOUNT ON
declare Versaotabela cursor for
select name,schema_name(schema_id) from sys.procedures where 1=1 
--AND name='DescontoProgressivo_Insere'
order by name
open versaotabela
declare @tabela varchar(200),@schema varchar(50),@nomeCompleto varchar(150),@texto XML,@scemadup VARCHAR(10)
declare @outp nvarchar(max);
fetch next from versaotabela into @tabela,@schema
while @@FETCH_STATUS<>-1
begin
	
	SET @scemadup=@schema+'.'
	
	set @nomeCompleto = @schema + '.' + REPLACE(@tabela,@scemadup,'')
	
	exec RetornaTextoProc @nomeCompleto,@cmd=@texto output

	INSERT INTO [dbo].[HistoricoVersaoObjeto] ([DatabaseName],[LoginName],[DataAlteracao],[DatabaseUser],[Event],[Schema],[Object],[Texto],[HostName],[Versao])
    VALUES (DB_NAME(),ORIGINAL_LOGIN(),GETDATE(), CONVERT(sysname, CURRENT_USER),'CREATE_PROCEDURE', @schema, @tabela, convert(nvarchar(max),@texto),host_name(),1)

fetch next from versaotabela into @tabela,@schema
end

close versaotabela
deallocate versaotabela

