
SELECT name,CHECKSUM(CamposReplicados) AS 'checksum'
FROM (
select distinct sp.pubid,sp.name
, (
	SELECT sc.name +',' AS [data()] 
	FROM dbo.sysarticlecolumns ac,sys.columns sc,dbo.sysarticles a,dbo.syspublications sp1 
	WHERE ac.colid = sc.column_id 
	AND ac.artid = a.artid 
	AND a.name = object_name(sc.object_id) 
	AND a.pubid = sp.pubid 
	AND sp.pubid = sp1.pubid 
	AND a.name='sku'  -- NOME DA TABELA AQUI!!!

	FOR XML PATH('')) +'|' AS CamposReplicados

from 
dbo.syspublications sp
where 1=1
and sp.pubid in 
(
	select pubid from dbo.syspublications 
	where 1=1
)
) AS a 
WHERE a.CamposReplicados IS NOT NULL

