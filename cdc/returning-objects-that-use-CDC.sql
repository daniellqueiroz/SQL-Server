--return all the routines that use CDC logic to capture data changes

SELECT DISTINCT 'exec sp_helptext '+ object_name(id)
from sys.syscomments sc
INNER JOIN sys.objects o ON sc.id=o.object_id
where text like '%cdc%'
--AND o.type<>'TR'
--AND name NOT LIKE 'audit_%'
AND name IN
('SkuAlteracaoRegraParaBuscaCampo',
'SkuAlteracaoRegraParaDescontoFidelizacao',
'SkuAlteracaoRegraParaBuscaCampoValor',
'SkuAlteracaoRegraParaBuscaProdutoRank',
'SkuAlteracaoRegraParaBuscaMarca',
'SkuAlteracaoRegraParaSku',
'SkuAlteracaoRegraParaBuscaCategoriaMarcaSideBar',
'SkuAlteracaoRegraParaBuscaCategoria',
'SkuAlteracaoRegraParaProdutoSemSku',
'SkuAlteracaoRegraParaSkuLojista',
'SkuAlteracaoRegraParaDesconto',
'SkuAlteracaoRegraParaColecaoParametroProduto',
'SkuAlteracaoRegraParaLojistaDoArquivoParceiroXML',
'SkuAlteracaoRegraParaBuscaProdutoCategoriaSimilar',
'SkuAlteracaoRegraParaDescontoSemColecao',
'SkuAlteracaoRegraParaKitFilhoAcompanhaPrecoLojista',
'SkuAlteracaoRegraParaProduto',
'SkuAlteracaoRegraParaSkuTributacaoPrecoCalculado',
'SkuAlteracaoRegraParaColecaoParametroProdutoPorParceiro',
'SkuAlteracaoRegraParaSkuLojistaSemColecao',
'SkuAlteracaoRegraParaColecaoParametroProdutoSemColecao',
'SkuAlteracaoRegraParaSkuLojistaInventario',
'SkuAlteracaoRegraParaEntregaFidelizacao',
'SkuAlteracaoRegraParaSkuSemColecao',
'SkuAlteracaoRegraParaProdutoSemColecao',
'SkuAlteracaoRegraParaBuscaResultadoPowerReviews',
'SkuAlteracaoRegraParaBuscaProdutoCampoValor')


SELECT [retention]
  FROM [msdb].[dbo].[cdc_jobs]
  WHERE [database_id] = DB_ID()
  AND [job_type] = 'cleanup'
