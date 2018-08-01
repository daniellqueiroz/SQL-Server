/*
Remarks:

1. This script will give you the procedure/function so you can recreate it later. It works as a backup method for your routines

*/

SET NOCOUNT ON

DECLARE @procs AS TABLE( cdrop VARCHAR(1000)
, nome varchar(200)
, object_id INT
, definition NVARCHAR(MAX)
, uses_ansi_nulls BIT
, uses_quoted_identifier BIT
)
INSERT INTO @procs
SELECT 'if exists (select * from sys.objects where name =''' + o.name + ''') drop ' + CASE WHEN o.type_desc LIKE '%function%' THEN ' function ' ELSE ' Procedure ' END + o.name + CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10) AS CDrop
	,o.name
	 ,m.object_id
     , m.definition
     , m.uses_ansi_nulls
     , m.uses_quoted_identifier
FROM sys.sql_modules AS m
INNER JOIN sys.objects AS o
    ON m.object_id = o.object_id
WHERE 1=1
--and o.type = 'P'
AND o.name IN 
(
'AdministradorAltera'
,'AdministradorAlterar',
'AdministradorAlteraSenha',
'AdministradorAtiva',
'AdministradorDesativa',
'AdministradorExcluir',
'AdministradorInclui',
'AdministradorIncluir',
'AdministradorLista',
'AdministradorListar',
'AdministradorObter',
'AdministradorPerfilLista',
'AgendamentoXmlListar',
'ArquivoCampoXmlListar',
'ArquivoParceiroLojistaXmlIncluir',
'ArquivoXmlStatusExecucaoListar',
'AtualizarStatusEnvioXml',
'AtualizaStatusFilaXML',
'BuscarAgendamentoParceiroXml',
'BuscarAgendamentoXml',
'BuscarArquivoCampoXml',
'BuscarArquivoParceiroAgendadoXml',
'BuscarArquivoParceiroXml',
'BuscarCampoXml',
'BuscarDadosFtpXml',
'BuscarHistoricoGeracaoXml',
'BuscarParceiroXml',
'CampoXmlListar',
'CancelarPedidoManualmente',
'CompraInteracaoLista',
'CompraStatusLogLista',
'dbo.GravarArquivoParceiroXml',
'ExcluiArquivoGerado',
'ExcluirAgendamentoParceiroXml',
'ExcluirArquivoCampoXml',
'ExcluirLojistasParceiroXml',
'ExisteArquivoParceiroXML',
'GerarConteudoCSV',
'GerarConteudoTXT',
'GerarConteudoXslt',
'GravarArquivoParceiroXml',
'HistoricoGeracaoParceiroXmlListar',
'IncluirAgendamentoParceiroXml',
'IncluirArquivoCampoXml',
'IncluirErroEnvioArquivoXml',
'IncluirErroGeracaoArquivoXml',
'IncluirHistoricoGeracaoXml',
'InsereArquivoXmlNaFila',
'ListaAgendamentosXmlPendentes',
'ListaFilaArquivos',
'ListaProdutosFroogleCSV',
'ListaProdutosFroogleGenerator',
'ListarCamposArquivo',
'ListarItensParceiro',
'ListarProdutoParceiro',
'ListarProdutoParceiroCriteo',
'ListarProdutoSLI',
'ListarProdutoSLI_V2',
'LojistaListar',
'NotaListaCompleto',
'ParceiroXmlGravar',
'ParceiroXmlListar',
'PriorizaArquivoXmlNaFila',
'spAdministradorListar',
'TemplateXmlListar',
'fn_CalculaParcelamento',
'fn_CalculaParcelamento_DreamGenarator',
'fn_CalculaValorBoleto',
'fn_CalculaValorVitrine',
'fn_FormataValorMoeda',
'fn_FormataValorMoedaInline',
'fn_RetornaLinkImagem',
'fn_RetornaLinkImagensSecundarias',
'fn_RetornaLinkProduto',
'fn_RetornaLinkProduto_DreamGenerator',
'fn_ToBase64String',
'fnCaminhoArquivoHistoricoXml',
'IsNullOrEmpty',
'RemoverCaracteresEspeciais'
)


DECLARE @endStmt NCHAR(6)
      , @object_id INT
      , @definition NVARCHAR(MAX)
      , @uses_ansi_nulls BIT
      , @uses_quoted_identifier BIT
	  , @cdrop VARCHAR(1000)    

DECLARE @crlf VARCHAR(2), @len BIGINT, @offset BIGINT, @part BIGINT

SELECT @object_id = MIN(object_id)
     , @endStmt = CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
FROM @procs

declare c cursor for 
SELECT cdrop + [definition]
,  uses_ansi_nulls
,  uses_quoted_identifier
FROM @procs
order by nome asc

open c
fetch next from c into @definition,@uses_ansi_nulls,@uses_quoted_identifier

while @@fetch_status<>-1
begin
    IF @uses_ansi_nulls = 1
        PRINT 'SET ANSI_NULLS ON' + @endStmt;
    ELSE
        PRINT 'SET ANSI_NULLS OFF' + @endStmt;

    IF @uses_quoted_identifier = 1
        PRINT 'SET QUOTED_IDENTIFIER ON' + @endStmt;
    ELSE
        PRINT 'SET QUOTED_IDENTIFIER OFF' + @endStmt;

	--PRINT @definition;

    IF LEN(@definition) <= 4000
        PRINT @definition
    ELSE
    BEGIN

        SELECT @crlf = CHAR(13)+CHAR(10)
             , @len = LEN(@definition)
             , @offset = 1
             , @part = CHARINDEX(@crlf,@definition)-1

        WHILE @offset <= @len AND @part>=0
        BEGIN
			
			--PRINT @offset
			--PRINT @part
			--PRINT LEN(@crlf)
			--PRINT @len
			      
            PRINT SUBSTRING(@definition,@offset,@part)

            SET @offset = @offset + @part + LEN(@crlf)
            SET @part = CHARINDEX(@crlf,@definition,@offset)-@offset

			--PRINT @offset
			--PRINT @part
			--PRINT @len

			IF @part < 0 
			PRINT SUBSTRING(@definition,@offset,100)
        END
    END

	PRINT @endStmt;


fetch next from c into @definition,@uses_ansi_nulls,@uses_quoted_identifier
end
close c
deallocate c
