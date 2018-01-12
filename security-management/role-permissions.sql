/*

remarks:

1. Use this script to return all the permissions related to a role within the database. Run on the target database.

*/

SET NOCOUNT ON;

DECLARE @userid VARCHAR(50);
SET @userid = 'aplicacao';

--SELECT USER_ID(@userid)

DECLARE c CURSOR FOR
SELECT name FROM sys.database_principals 
WHERE [type] = 'R' AND is_fixed_role = 0 AND name NOT LIKE 'msrepl%' AND name NOT LIKE 'mstran%' AND name NOT IN ('public') 
AND name=@userid
ORDER BY name
OPEN c
FETCH NEXT FROM c INTO @userid
WHILE @@FETCH_STATUS <> -1
BEGIN	
	SELECT comando FROM (
	SELECT 'if user_id('''+@userid+''') is null create role ['  + @userid + '] authorization dbo' AS comando,1 AS ordem

	UNION

	SELECT 'if user_id('''+name+''') is not null exec sp_addrolemember @membername = '''+ dp.name +''', @rolename = ''' + @userid + ''' ' AS comando,2 AS ordem
	--,* 
	FROM sys.database_role_members drm 
	INNER JOIN sys.database_principals dp ON dp.principal_id = drm.member_principal_id
	WHERE drm.role_principal_id  = USER_ID(@userid)

	UNION

	-- PEGAR PERMISSÕES DE SCHEMAS
	SELECT 'grant ' + permission_name + ' on ' + class_desc + '::' + ss.name COLLATE SQL_Latin1_General_CP1_CI_AS + ' to ' + @userid AS comando,3 AS ordem
	--,dp.* 
	FROM sys.database_permissions dp
	INNER JOIN sys.schemas ss ON ss.schema_id = dp.major_id
	WHERE dp.grantee_principal_id = (SELECT USER_ID(@userid))
	) AS a
	ORDER BY ordem;
	FETCH NEXT FROM c INTO @userid
END
CLOSE c
DEALLOCATE c

/*
SELECT *
FROM sys.database_permissions dp
INNER JOIN sys.schemas ss ON ss.schema_id = dp.major_id
WHERE dp.grantee_principal_id = 9
*/