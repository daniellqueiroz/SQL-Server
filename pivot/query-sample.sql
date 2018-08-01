/*
SELECT TOP 10 * FROM CompraEntrega ce WITH(NOLOCK)
INNER JOIN Compra c ON c.IdCompra = ce.IdCompra
WHERE ce.IdFreteEntregaTipo = 12
AND c.Data < '2016-11-25 00:00:00'
ORDER BY c.Data DESC


SELECT * FROM dbo.CompraEntregaStatusLog WHERE IdCompraEntrega = 67489418 ORDER BY DataIntegracaoHotLine

/*
IdCompra | IdCompraEntrega | PEI | ACR | AMC | AAP | CAP
1 | 2 | 00:00 | 00:01 | 00:03 | 005 | 
*/
*/

SELECT * FROM dbo.CompraEntregaStatusLog WHERE IdCompraEntrega = 67489418 ORDER BY DataIntegracaoHotLine

SELECT IdCompra,IdCompraEntrega
,CAST(CAST (DATEDIFF(s,"PEI","ETL") AS INT)/86400 AS VARCHAR(50))+':'+ CONVERT(VARCHAR, DATEADD(S, CAST (DATEDIFF(s,"PEI","ETL") AS INT), 0), 108) PEI_to_ENT
,CAST(CAST (DATEDIFF(s,"PEI","ENT") AS INT)/86400 AS VARCHAR(50))+':'+ CONVERT(VARCHAR, DATEADD(S, CAST (DATEDIFF(s,"PEI","ENT") AS INT), 0), 108) PEI_to_ENT
,"PEI","ACR","AMC","AAP","CAP","_PAP","_ETM","_RCE","PAP","WMS","BES","NFS","ETR","PRT","ROT","TRN","ETL","ENT" 
FROM 
(
	SELECT ce.IdCompra,cesl.IdCompraEntrega,cesl.IdCompraEntregaStatus,DataIntegracaoHotLine 
	FROM dbo.CompraEntregaStatusLog cesl INNER JOIN dbo.CompraEntrega ce ON ce.IdCompraEntrega = cesl.IdCompraEntrega
	WHERE cesl.IdCompraEntregaStatus IN ('PEI','ACR','AMC','AAP','CAP','_PAP','_ETM','_RCE','PAP','WMS','BES','NFS','ETR','TRN','ETL','PRT','ROT','ARL','ENT')
	AND cesl.IdCompraEntrega = 67489418
)	AS SourceTable
PIVOT (MAX([DataIntegracaoHotLine]) FOR [IdCompraEntregaStatus] IN ("PEI","ACR","AMC","AAP","CAP","_PAP","_ETM","_RCE","PAP","WMS","BES","NFS","ETR","PRT","ROT","TRN","ETL","ENT")) AS PivotTable


