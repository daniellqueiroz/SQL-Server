/*

Use this script to compare the final checksum of all the records within the result set returned by different versions of the same routine. This can be useful if you make a change to a routine and need to know if your change
affected the final result set in any way. This is useful only for large result sets. For small ones you can use a program like Winmerge.

Before using this, you must have collected a trace. In this trace, you should have several calls to the desired routine. Export the results of the trace to a table called trache_chamadas.

If any calls return a differet checksum, you should see a message in the messages tab on the query results

*/

--STEP 01: creating auxiliary tables
if object_id('toriginal','U') is not null
	drop TABLE toriginal
GO
SELECT * INTO toriginal
FROM OPENQUERY
(
[CL-STG-STAGE01\STAGE01], --change the linked server
'exec db_stg_extra.dbo.ObterGarantiasEnquadradas_original @IdSku=5384740,@ValorVitrine=19.9000,@FlagKit=0,@Texto=NULL'
);

if object_id('tteste','U') is not null
	drop TABLE tteste
GO
SELECT * INTO tteste
FROM OPENQUERY ([CL-STG-STAGE01\STAGE01], --change the linked server
'exec db_stg_extra.dbo.ObterGarantiasEnquadradas @IdSku=5384740,@ValorVitrine=19.9000,@FlagKit=0,@Texto=NULL'
);




--STEP 02: Updating  
-- Neste caso é necessário atualizar o schema da proc
--select top 10 * from dbo.trace_chamadas
UPDATE dbo.trace_chamadas SET TextData = REPLACE(CONVERT(NVARCHAR(max),TextData),'ObterGarantiasEnquadradas','db_stg_extra.dbo.ObterGarantiasEnquadradas') -- formating the calls within the trace for further analysis
--UPDATE dbo.trace_chamadas SET TextData = REPLACE(CONVERT(NVARCHAR(max),TextData),'ObterGarantiasEnquadradas','ObterGarantiasEnquadradas_original')
--UPDATE dbo.trace_chamadas SET TextData = REPLACE(CONVERT(NVARCHAR(max),TextData),'spSkuArquivoListar','db_hom_nike.loja.spSkuArquivoListar')



SET NOCOUNT ON
-- cursor para cálculo de checksum e relatório final
DECLARE @chamada NVARCHAR(max)='',@comando NVARCHAR(max)=''
,@NomeRotinaOriginal VARCHAR(200)='ObterGarantiasEnquadradas_original' 
,@NomeRotinaTeste VARCHAR(200)='ObterGarantiasEnquadradas'
,@checksumT BIGINT,@checksumO BIGINT,@dt DATETIME2,@toriginal int,@tteste int
DECLARE chamadas CURSOR FOR
SELECT DISTINCT CONVERT(NVARCHAR(max),textdata) FROM dbo.trace_chamadas WHERE TextData IS NOT NULL
OPEN chamadas
FETCH NEXT FROM chamadas INTO @chamada
WHILE @@FETCH_STATUS <>-1
BEGIN

	truncate table tteste;
	truncate table dbo.toriginal;

	--SET @chamada=REPLACE(@chamada,@NomeRotinaOriginal,@NomeRotinaTeste) -- ESSA LINHA SÓ É NECESSÁRIA CASO A ALTERAÇÃO JÁ TIVER SIDO APLICADA!!!

	SET @comando='insert toriginal select * FROM OPENQUERY ([CL-STG-STAGE01\STAGE01], '''+ @chamada+''');';
	SET @dt=SYSDATETIME()  
	exec (@comando);
	SET @toriginal = DATEDIFF(millisecond,@dt,SYSDATETIME())
	SELECT @checksumO=SUM(CONVERT(BIGINT,CHECKSUM(*))) FROM dbo.toriginal ORDER BY 1;
	
	SET @chamada=REPLACE(@chamada,@NomeRotinaOriginal,@NomeRotinaTeste)
	--SET @chamada=REPLACE(@chamada,@NomeRotinaOriginal,@NomeRotinaTeste)

	SET @comando='insert tteste select * FROM OPENQUERY ([CL-STG-STAGE01\STAGE01], '''+ @chamada+''');';
	SET @dt=SYSDATETIME()  
	EXEC (@comando);
	SET @tteste = DATEDIFF(millisecond,@dt,SYSDATETIME())
	SELECT @checksumT=SUM(CONVERT(BIGINT,CHECKSUM(*))) FROM dbo.tteste ORDER BY 1;
	
	--select @toriginal AS TempoOriginal,@tteste AS TempoNovo;
	
	IF @checksumO<>@checksumT
		RAISERROR('%s',10,1,@chamada) WITH nowait

	IF @tteste < @toriginal AND @tteste - @toriginal > 50
	BEGIN
		--PRINT '--chamada mais lenta';  
		--print 'tempo original:'+CAST(@toriginal AS VARCHAR(10))+ ' - tempo teste:'+ CAST(@tteste AS VARCHAR(10)) ;
		print 'tempo teste:'+CAST(@tteste AS VARCHAR(10))+ ' - tempo original:'+ CAST(@toriginal AS VARCHAR(10)) ;
		RAISERROR('%s',10,1,@chamada) WITH nowait;
	END      

	SET @comando='';
	
FETCH NEXT FROM chamadas INTO @chamada
END
CLOSE chamadas
DEALLOCATE chamadas

/*
-- cleanup
GO
if object_id('tteste','U') is not null
	drop TABLE tteste
GO
if object_id('toriginal','U') is not null
	drop TABLE toriginal
GO
if object_id('trace_chamadas','U') is not null
	drop TABLE trace_chamadas
GO


SELECT CHECKSUM(*) FROM dbo.toriginal ORDER BY 1;
SELECT CHECKSUM(*) FROM dbo.tteste ORDER BY 1;
select * FROM dbo.toriginal ORDER BY 1;
exec db_hom_casasbahia.dbo.spColecaoParametroProdutoAtualizarAuto2 @IdColecao=9272
*/

