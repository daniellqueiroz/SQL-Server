-- Exclui OS USUÁRIOS DE UMA ROLE
declare @userid varchar(50), @cmddrop varchar(5000), @cmdadd varchar(5000); set @userid = 'AdmReplicacao'

if exists(select * from sys.database_principals where name = @userid)
BEGIN
	declare limparole cursor for
	select 'exec sp_droprolemember ''' + @userid + ''',[' + name + ']' from sys.database_principals where principal_id in 
			(
				select drm.member_principal_id
				from sys.database_principals dp, sys.database_role_members drm
				where 1=1 
				and dp.principal_id = drm.member_principal_id
				and drm.role_principal_id = (select principal_id from sys.database_principals where name = @userid)
			) 

	open limparole
	fetch next from limparole into @cmddrop
	while @@fetch_status <> -1
	begin
		exec (@cmddrop)
	fetch next from limparole into @cmddrop
	end
	close limparole
	deallocate limparole
END

--declare @userid varchar(50), @cmddrop varchar(5000), @cmdadd varchar(5000); set @userid = 'AdmReplicacao'
if exists(select * from sys.database_principals where name = @userid)
exec ('drop role ' + @userid)
GO

create role [AdmReplicacao]
GO


-- READICIONA USUÁRIOS NA ROLE
declare @userid varchar(50), @cmddrop varchar(5000), @cmdadd varchar(5000); set @userid = 'AdmReplicacao'
declare poprole cursor for
SELECT 'exec sp_addrolemember ''' + @userid + ''',[' + name + ']'
from sys.database_principals 
WHERE principal_id > 5 AND name NOT LIKE 'MStran%' AND name NOT LIKE 'MSrepl%' AND is_fixed_role = 0
AND name != @userid
ORDER BY name
open poprole
fetch next from poprole into @cmdadd
while @@fetch_status <> -1
begin
	exec (@cmdadd)
fetch next from poprole into @cmdadd
end
close poprole
deallocate poprole



/*
SELECT *
from sys.database_principals 
WHERE 1=1
--and principal_id > 5 
AND name NOT LIKE 'MStran%' AND name NOT LIKE 'MSrepl%' AND is_fixed_role = 0
ORDER BY name
*/