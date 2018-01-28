/*
Use this script to change configuration for the articles within a publication. For more information on each of the parameters and procedures, check MS documentation

*/

-- use the following command to change the default way the commands are delivered to the subscriber. This can be useful in case you have more than one replication pointing to the same subscriber database
EXEC sp_changearticle @publication = N'marketplace_corp', @article = N'Sku',@property = 'upd_cmd',  @value = 'SQL'
EXEC sp_changearticle @publication = N'marketplace_corp', @article = N'Sku',@property = 'ins_cmd',  @value = 'SQL'
EXEC sp_changearticle @publication = N'marketplace_corp', @article = N'Sku',@property = 'del_cmd',  @value = 'SQL'


--generating configuration comands for all articles of a publication
DECLARE @pub VARCHAR(100)
SET @pub = 'corp_extra_outros'
select distinct a.name as artname
,'exec sp_changearticle @publication = corp_extra_outros, @article = N'''+a.name+''', @property = ''status'',  @value = ''parameters'''
,'exec sp_changearticle @publication = corp_pontofrio_outros, @article = N'''+a.name+''', @property = ''status'',  @value = ''parameters'''
,'exec sp_changearticle @publication = corp_casasbahia_outros, @article = N'''+a.name+''', @property = ''status'',  @value = ''parameters'''
from dbo.sysarticlecolumns ac
inner join sys.columns sc
on ac.colid = sc.column_id
inner join dbo.sysarticles a
on ac.artid = a.artid
inner join sys.columns
on a.name = object_name(sc.object_id)
inner join dbo.syspublications sp
on sp.pubid = a.pubid
where 1=1
and a.pubid = (select pubid from dbo.syspublications where name = @pub)
ORDER BY a.name


-- configuration publication synchronization behavior
EXEC sp_changepublication
@publication = 'corp_extra_outros',
@property = 'allow_anonymous', 
@value = 'false' 
GO 

EXEC sp_changepublication 
@publication = 'corp_extra_outros',
@property = 'immediate_sync', 
@value = 'false' 
GO 


/*


SELECT sc.name,OBJECT_NAME(sc.object_id), ROW_NUMBER() OVER(PARTITION BY OBJECT_NAME(sc.object_id) ORDER BY OBJECT_NAME(sc.object_id) ) rownum
FROM sys.index_columns sic INNER JOIN sys.columns sc
ON sic.index_column_id = sc.column_id
AND sic.object_id = sc.object_id
INNER JOIN sys.indexes si ON sc.object_id = si.object_id
AND si.index_id = sic.index_id
WHERE OBJECT_NAME(sc.object_id) IN (SELECT a.NAME from dbo.sysarticlecolumns ac
inner join sys.columns sc
on ac.colid = sc.column_id
inner join dbo.sysarticles a
on ac.artid = a.artid
inner join sys.columns
on a.name = object_name(sc.object_id)
inner join dbo.syspublications sp
on sp.pubid = a.pubid
where 1=1
and a.pubid = (select pubid from dbo.syspublications where name = 'corp_extra_outros'))
AND si.is_primary_key = 1

*/