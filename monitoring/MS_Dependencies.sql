SELECT DISTINCT ''''+ OBJECT_NAME(object_id) + ''','--,* 
FROM sys.sql_dependencies 
WHERE referenced_major_id=OBJECT_ID('AdministradorSistema') 
--AND referenced_minor_id=(SELECT column_id FROM sys.columns WHERE object_id=OBJECT_ID('BlocoAnuncio') AND name='IdControle') ORDER BY OBJECT_NAME(object_id)

/*

SELECT sm.object_id, OBJECT_NAME(sm.object_id) AS object_name, o.type, o.type_desc, sm.definition 
FROM sys.sql_modules  sm
INNER JOIN sys.objects o ON sm.object_id=o.object_id
WHERE definition LIKE '%[^a-z0-9]IX_Sku_FlagKitFlagAtualizarGarantiaIdSKU[^a-z0-9]%'

select top 10000 * 
FROM dbo.Campo
WHERE '.' + Nome + '.' LIKE '%[^a-z]idade[^a-z]%'

*/