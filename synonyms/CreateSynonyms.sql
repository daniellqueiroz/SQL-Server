--use the following query to dinamically retrive the drop/create command for all existing synonyms
SELECT 'drop synonym ' + name + ';' + 'CREATE SYNONYM ' + name + ' FOR [db_prd_corp].[dbo].'+name  FROM sys.synonyms

drop synonym SkuSaldo;CREATE SYNONYM SkuSaldo FOR [db_prd_corp].[dbo].SkuSaldo
drop synonym RegFaixaCep;CREATE SYNONYM RegFaixaCep FOR [db_prd_corp].[dbo].RegFaixaCep
drop synonym LogSkuMudancaProduto;CREATE SYNONYM LogSkuMudancaProduto FOR [db_prd_corp].[dbo].LogSkuMudancaProduto
drop synonym SkuEstoqueSaldo;CREATE SYNONYM SkuEstoqueSaldo FOR [db_prd_corp].[dbo].SkuEstoqueSaldo
drop synonym RegGrupoEstoque;CREATE SYNONYM RegGrupoEstoque FOR [db_prd_corp].[dbo].RegGrupoEstoque
drop synonym RegGrupoSku;CREATE SYNONYM RegGrupoSku FOR [db_prd_corp].[dbo].RegGrupoSku
drop synonym EstoqueGrupoUnidadeNegocio;CREATE SYNONYM EstoqueGrupoUnidadeNegocio FOR [db_prd_corp].[dbo].EstoqueGrupoUnidadeNegocio
drop synonym RegFilialRegiaoFiltro;CREATE SYNONYM RegFilialRegiaoFiltro FOR [db_prd_corp].[dbo].RegFilialRegiaoFiltro
drop synonym RegFiltro;CREATE SYNONYM RegFiltro FOR [db_prd_corp].[dbo].RegFiltro
drop synonym RegGrupoUnidadeNegocio;CREATE SYNONYM RegGrupoUnidadeNegocio FOR [db_prd_corp].[dbo].RegGrupoUnidadeNegocio
drop synonym CSGA;CREATE SYNONYM CSGA FOR [db_prd_corp].[dbo].CSGA
drop synonym EstoqueGrupo;CREATE SYNONYM EstoqueGrupo FOR [db_prd_corp].[dbo].EstoqueGrupo
drop synonym SkuEstoqueMinimo;CREATE SYNONYM SkuEstoqueMinimo FOR [db_prd_corp].[dbo].SkuEstoqueMinimo
