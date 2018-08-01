set nocount on

select distinct  'deny insert,delete on ' + a.name + ' to AdmReplicacao'
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

