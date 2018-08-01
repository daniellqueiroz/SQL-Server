SET NOCOUNT ON;

DECLARE @userid VARCHAR(50),@tipo CHAR(1);

--SELECT USER_ID(@userid)

DECLARE c CURSOR FOR
SELECT name,[type] FROM sys.database_principals 
WHERE [type] IN ('U','S') AND owning_principal_id IS NULL AND principal_id > 4 AND name NOT LIKE 'msrepl%' AND name NOT LIKE 'mstran%' AND name NOT IN ('public') 
ORDER BY name
OPEN c
FETCH NEXT FROM c INTO @userid,@tipo
WHILE @@FETCH_STATUS <> -1
BEGIN	
	SELECT comando FROM (
	
	--SELECT 'if user_id('''+@userid+''') is not null EXEC sys.sp_change_users_login @Action = ''Auto_Fix'', @UserNamePattern = '''+@userid+''', @LoginName = '''+@userid+'''' AS comando,-1 AS ordem WHERE @tipo='S'
	
	--union

	SELECT 'if user_id('''+@userid+''') is null and exists(SELECT TOP 10 * FROM sys.syslogins WHERE name='''+(@userid)+''') create user ' + QUOTENAME(@userid) + ' FOR LOGIN ' + QUOTENAME(@userid) + ' with default_schema=dbo;' AS comando,0 AS ordem

	UNION
    
	SELECT 'if user_id('''+@userid+''') is not null and exists(SELECT TOP 10 * FROM sys.syslogins WHERE name='''+(@userid)+''') EXEC sys.sp_change_users_login @Action = ''Update_One'', @UserNamePattern = '''+@userid+''', @LoginName = '''+@userid+'''' AS comando,1 AS ordem WHERE @tipo='S'

	UNION

	SELECT 'if user_id('''+dp.name+''') is not null exec sp_addrolemember @membername = '''+ @userid +''', @rolename = ''' + dp2.name + ''' ' AS comando,2 AS ordem
	--,* 
	FROM sys.database_role_members drm 
	INNER JOIN sys.database_principals dp ON dp.principal_id = drm.member_principal_id
	INNER JOIN sys.database_principals dp2 ON dp2.principal_id = drm.role_principal_id
	WHERE drm.member_principal_id  = USER_ID(@userid)

	UNION

	-- PEGAR PERMISSÕES DE SCHEMAS
	SELECT 'if user_id('''+@userid+''') is not null grant ' + permission_name + ' on ' + class_desc + '::' + ss.name COLLATE SQL_Latin1_General_CP1_CI_AS + ' to ' + QUOTENAME(@userid) AS comando,3 AS ordem
	--,dp.* 
	FROM sys.database_permissions dp
	INNER JOIN sys.schemas ss ON ss.schema_id = dp.major_id
	WHERE dp.grantee_principal_id = (SELECT USER_ID(@userid))
	) AS a
	ORDER BY ordem;
	FETCH NEXT FROM c INTO @userid,@tipo
END
CLOSE c
DEALLOCATE c

/*
SELECT *
FROM sys.database_permissions dp
INNER JOIN sys.schemas ss ON ss.schema_id = dp.major_id
WHERE dp.grantee_principal_id = 9
*/