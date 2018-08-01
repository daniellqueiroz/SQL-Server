-- use this technique to slowly delete data from big tables.
-- this strategy is preferrable since it reduces the likelyhood of causing contention and concurrency problems in the database
-- note that the scripts uses a limit of 4000 records affected based on the behavior of Lock Escalation within SQL Server

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @count INT=1,@top INT=4000;
--select @count = count(*) from dbo.Email WHERE EmailDestino NOT LIKE '%_@__%.__%'
WHILE @count > 0
BEGIN
	DELETE TOP (@top) FROM dbo.ColecaoParametroProduto INNER JOIN dbo.Produto
	ON Produto.IdProduto = ColecaoParametroProduto.IdProduto WHERE FlagAtiva=0
	SET @count = @@ROWCOUNT;
	RAISERROR('faltam %d registros',0,1,@count) WITH NOWAIT	;
	WAITFOR DELAY '00:00:01';
END



-- example of usage of such technique is a more large scale process

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if object_id('LimpaCarrinhosObsoletos') is not null
drop procedure LimpaCarrinhosObsoletos
go
create procedure [dbo].[LimpaCarrinhosObsoletos] (@HoraLimite varchar(8)='06:00:00')
as
begin

set transaction isolation level read uncommitted

declare @erro varchar(max)
declare @hora varchar(8)
declare @count INT
DECLARE @decremento INT=10000
SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
DECLARE @colation VARCHAR(50),@delay varchar(8)
set @delay='00:00:02'


if @hora < @HoraLimite
begin

	------------ cria e popula tabelas auxiliares 
	
	SELECT @colation=collation_name FROM sys.databases WHERE database_id=DB_ID()
	
	CREATE TABLE #CarrinhoObs (UsuarioGUID NCHAR(36) COLLATE SQL_Latin1_General_CP1_CI_AS UNIQUE)
	CREATE TABLE #CarrinhoObsAux (UsuarioGUID NCHAR(36) COLLATE SQL_Latin1_General_CP1_CI_AS UNIQUE)
	
		
	INSERT INTO #CarrinhoObs ( UsuarioGUID )
	SELECT TOP (3500000) UsuarioGUID FROM carrinho with (nolock) 
	WHERE Data < dateadd(day,-45,convert(date,getdate()))
	AND NOT EXISTS (SELECT 1 FROM dbo.Cliente (NOLOCK) WHERE cliente.UsuarioGUID = carrinho.UsuarioGUID)




	---***************** CARRINHOSKU *******************
	SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
	select @count = count(*) from dbo.carrinhosku cbcs with (nolock)  inner JOIN #CarrinhoObs dbacs on dbacs.UsuarioGUID = cbcs.UsuarioGUID
	set nocount on
	while @count > 0 and @hora < @HoraLimite
	begin
		DELETE TOP (@decremento) dbo.carrinhosku from dbo.carrinhosku cbcs  with (nolock) inner join
		#CarrinhoObs dbacs on dbacs.UsuarioGUID = cbcs.UsuarioGUID
		waitfor delay @delay
		set @count = @count - @decremento
		SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
		raiserror('faltando %d na carrinhosku em %s',0,1,@count,@hora) with nowait
	end


	---***************** CARRINHOFORMAPAGAMENTO *******************
	SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
	select @count = count(*) from #CarrinhoObs dbacf, carrinhoformapagamento cf with (nolock) where dbacf.usuarioguid  = cf.usuarioguid
	while @count > 0 and @hora < @HoraLimite
	begin
		DELETE TOP (@decremento) dbo.carrinhoformapagamento from dbo.carrinhoformapagamento cbc with (nolock) inner join
		#CarrinhoObs dbac on dbac.usuarioguid  = cbc.usuarioguid
		waitfor delay @delay
		set @count = @count - @decremento
		SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
		raiserror('faltando %d na carrinhoformapagamento',0,1,@count) with nowait
	end


	---***************** CarrinhoGarantiaAvulsA *******************
	SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
	select @count = count(*) from #CarrinhoObs dbacf, CarrinhoGarantiaAvulsA cf with (nolock) where dbacf.usuarioguid  = cf.usuarioguid
	while @count > 0 and @hora < @HoraLimite
	begin
		DELETE TOP (@decremento) dbo.CarrinhoGarantiaAvulsA from dbo.CarrinhoGarantiaAvulsA cbc with (nolock) inner join
		#CarrinhoObs dbac on dbac.usuarioguid  = cbc.usuarioguid
		waitfor delay @delay
		set @count = @count - @decremento
		SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
		raiserror('faltando %d na carrinhogarantiaavulsa em %s',0,1,@count,@hora) with nowait
	end

	---***************** ClusterCarrinho *******************
	SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
	select @count = count(*) from #CarrinhoObs dbacf, ClusterCarrinho cf with (nolock) where dbacf.usuarioguid  = cf.usuarioguid
	while @count > 0 and @hora < @HoraLimite
	begin
		DELETE TOP (@decremento) dbo.ClusterCarrinho from dbo.ClusterCarrinho cbc with (nolock) inner join
		#CarrinhoObs dbac on dbac.usuarioguid  = cbc.usuarioguid
		waitfor delay @delay
		set @count = @count - @decremento
		SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
		raiserror('faltando %d na clustercarrinho em %s',0,1,@count,@hora) with nowait
	end


	---***************** CARRINHO *******************
	SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
	select @count = count(*) from dbo.carrinho cbc with (nolock) inner JOIN #CarrinhoObs dbac on dbac.usuarioguid  = cbc.usuarioguid
	while @count > 0 and @hora < @HoraLimite
	begin
		begin try
			DELETE TOP (@decremento) dbo.carrinho output deleted.usuarioguid into #CarrinhoObsAux(UsuarioGuid) from dbo.carrinho cbc inner join	#CarrinhoObs dbac on dbac.usuarioguid  = cbc.usuarioguid
			
			delete from #CarrinhoObs where UsuarioGUID in (select UsuarioGUID from #CarrinhoObsAux)
			delete from #CarrinhoObsAux

			waitfor delay @delay
			set @count = @count - @decremento
			SELECT @hora = CONVERT(VARCHAR(8),GETDATE(),108) 
			raiserror('faltando %d na carrinho em %s',0,1,@count,@hora) with nowait
		end try
		begin catch
			set @erro = error_message()
			raiserror(@erro,0,1) with nowait
		
		end catch
		
	end


	DROP TABLE #CarrinhoObs
end

end
GO

/*
SELECT COUNT(UsuarioGUID) UsuarioGUID FROM carrinho (nolock) 
WHERE Data > dateadd(day,-45,convert(date,getdate()))
AND EXISTS (SELECT 1 FROM dbo.Cliente (NOLOCK) WHERE cliente.UsuarioGUID = carrinho.UsuarioGUID)

--SELECT * FROM db_prd_conexao.dbo.Conexao


SELECT  dateadd(day,-45,convert(date,getdate()))
*/