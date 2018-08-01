SELECT * FROM sys.triggers WHERE name LIKE '%audit%'




declare audit cursor for
select 
'drop ' + case [type] when 'U' then + ' table ' + name
when 'V' then ' view ' + name
when 'FN' then ' function ' + name
when 'tr' then ' trigger ' + name
when 'p' then ' procedure ' + name
end
from sys.objects where name like '%audit%'
and type in ('u','v','p','tr','fn')
order by name
--and parent_object_id <> 0
open audit
declare @audit varchar(500)
fetch next from audit into @audit
while @@fetch_status <> -1
begin
	begin try
	print(@audit)
	end try
	begin catch
	print error_message()
	end catch
fetch next from audit into @audit
end
close audit
deallocate audit

SELECT 'drop trigger ' + NAME + ' on database' FROM sys.triggers WHERE 1=1 AND name LIKE '%audit%' AND parent_class_desc = 'database'
SELECT 'drop table ' + table_NAME FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME LIKE '%audit%'

