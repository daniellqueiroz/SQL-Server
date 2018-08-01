USE master
GO

IF OBJECT_ID('db_users') IS NULL
	CREATE TABLE db_users (dbname VARCHAR(200), username VARCHAR(250),PRIMARY KEY(dbname,username));

TRUNCATE TABLE master.dbo.db_users

DECLARE @nome VARCHAR(200),@cmd VARCHAR(max)=''
DECLARE c CURSOR FOR
SELECT name FROM sys.databases WHERE name not in ('distribution') and database_id>4 and name not like 'ReportServer%' AND state_desc='ONLINE'
OPEN c
FETCH NEXT FROM c INTO @nome
WHILE @@FETCH_STATUS <> -1
BEGIN
	SET @cmd = 'use ' + QUOTENAME(@nome) + ';INSERT INTO master.dbo.db_users SELECT DB_NAME(),name FROM sys.database_principals WHERE type NOT IN (''R'',''C'',''G'') AND name NOT IN (''dbo'',''guest'',''INFORMATION_SCHEMA'',''sys'')'
	EXEC (@cmd);
FETCH NEXT FROM c INTO @nome
END
CLOSE c
DEALLOCATE c

SELECT DB_NAME(),name FROM sys.database_principals WHERE type NOT IN ('R','C','G') AND name NOT IN ('dbo','guest','INFORMATION_SCHEMA','sys')

--INSERT INTO master.dbo.db_users SELECT DB_NAME(),name FROM sys.database_principals WHERE type NOT IN ('R','C','G') AND name NOT IN ('dbo','guest','INFORMATION_SCHEMA','sys')

