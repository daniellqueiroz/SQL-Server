set nocount on

select distinct 'deny update on ' + a.name + ' ('+ sc.name + ') to AdmReplicacao'
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
and a.pubid = (select pubid from dbo.syspublications where name = 'corp_extra_outros')



/*
with tabrepl as 
(
	select distinct a.name as artname, sc.name as cname
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
	and a.pubid in (select pubid from dbo.syspublications where 1=1
	and name IN ('corp_extra_outros'))
	--and name IN ('corp_casasbahia_outros'))
	--and name IN ('corp_hp'))
	--and name IN ('corp_pontofrio_outros'))
	--and name IN ('corp_laselva_outros'))	
	--and name IN ('corp_barateiro_outros'))	
	--and sc.name='metatagdescription'
)
select distinct 'deny update on ' + object_name(sc.object_id) + ' ('+ sc.name + ') to AdmReplicacao'--object_name(sc.object_id) as Artigo, sc.name
from sys.columns sc inner join sys.objects so
on sc.object_id = so.object_id
where so.type = 'U' and object_name(sc.object_id) not like 'sys%'
and object_name(sc.object_id) not like 'MS%' and object_name(sc.object_id) in
(select artname from tabrepl) and sc.name not in (select cname from tabrepl where object_name(sc.object_id) = artname)
--AND object_name(sc.object_id) = 'produto'
--AND sc.NAME in ('_flagskusaldodisponivel','datasaldoindisponivel')
--order by object_name(sc.object_id)

GO
*/