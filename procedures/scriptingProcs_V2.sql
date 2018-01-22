/*
A simple query to retrieve routine code directly from SQL Server

*/

SELECT ISNULL(smsp.definition, ssmsp.definition) + CHAR(10)+CHAR(13) + 'GO' AS [Definition] 
FROM sys.all_objects AS sp LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id 
LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id WHERE 1=1 
/*(sp.type = N'P' OR sp.type = N'RF' OR sp.type='PC')*/ 
and SCHEMA_NAME(sp.schema_id)=N'dbo'
AND sp.name IN 
(
'SkuAlteracaoRegraParaBuscaCategoria',
'ExecutaAtualizarFlagSkuSaldoDisponivel_Reg02',
'ExecutaAtualizarFlagSkuSaldoDisponivel',
'ConsolidaFlagsDeProduto',
'SkuRelatorio',
'SkuAlteracaoRegraParaBuscaProdutoCategoriaSimilar',
'SkuAlteracaoRegraParaBuscaCampo',
'SkuAlteracaoRegraParaBuscaProdutoCampoValor',
'ListaProdutosFroogleGenerator',
'BuscarSkuPorEstoque',
'SkuAlteracaoRegraParaBuscaMarca',
'SkuAlteracaoRegraParaBuscaCampoValor',
'BuscarKitPorEstoque',
'AtualizaDisponibilidadeKit',
'ProdutosMaisVendidosListar',
'ListaProdutosGoogleShopping'
)
