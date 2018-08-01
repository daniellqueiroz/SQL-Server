--RUN IT ON THE DATABASE THAT YOU WANT TO AFFECT
USE DHLWebShip
GO

DECLARE @hora VARCHAR(12)=(SELECT REPLACE(CONVERT(VARCHAR(21),CONVERT(TIME(7),GETDATE())),':','')),@tot BIGINT;
DECLARE @data VARCHAR(10)=(SELECT REPLACE(CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE())),'-',''));
DECLARE @path VARCHAR(4000)='s:\DB_Backups\',@bkdbcmd VARCHAR(4000),@bklogcmd VARCHAR(4000),@shrinkcmd VARCHAR(4000),@bkpandshrink VARCHAR(MAX)--,@option VARCHAR(1000) = 'bkp log and truncate';
DECLARE @dname sysname='master',@copy_only BIT = 0,@compression BIT=1, @truncateLog BIT = 1,@logReuseDesc VARCHAR(50);
DECLARE c CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
SELECT d.name FROM sys.databases d
WHERE d.name = DB_NAME();
OPEN c;
FETCH NEXT FROM c INTO @dname;
WHILE @@FETCH_STATUS <> -1
BEGIN

	SELECT @tot = [Total Size in MB] 
	FROM 
	(
		SELECT 
		DB_NAME() AS Banco
		,[Total Size in MB]
		FROM 
		(
			SELECT CAST((f.size/128.0) AS DECIMAL(15,2)) AS [Total Size in MB]
			FROM sys.database_files AS f WITH (NOLOCK) 
			LEFT OUTER JOIN sys.data_spaces AS fg WITH (NOLOCK) 
			ON f.data_space_id = fg.data_space_id 
			WHERE f.type_desc='LOG'  AND f.name!='LogSec'
			
		) AS a
		
	) AS B

	WHILE @tot > 10000
	BEGIN
	
		SET @logReuseDesc = (SELECT log_reuse_wait_desc FROM sys.databases WHERE name = @dname);
		PRINT @logReuseDesc;

		IF @logReuseDesc = 'LOG_BACKUP'
		BEGIN
        
			SET @bklogcmd = 'use ' + @dname + '; BACKUP LOG '+@dname+' TO DISK = '''+@path+@dname+'_'+@data+'_'+@hora+'.trn'' WITH NOUNLOAD' + CASE @compression WHEN 1 THEN + ',COMPRESSION' ELSE '' END + ';';
			SET @shrinkcmd = (SELECT 'DBCC SHRINKFILE('''+af.name+''', 0, TRUNCATEONLY)' + ';' AS [data()] FROM sys.sysaltfiles af WHERE af.dbid = DB_ID(@dname) AND af.groupid=0 AND af.name!='LogSec' FOR XML PATH(''))
			SET @bkpandshrink = @bklogcmd + @shrinkcmd;
		
			--PRINT @recoveryDesc;
			EXEC (@bkpandshrink);
		
			SET @hora = (SELECT REPLACE(CONVERT(VARCHAR(21),CONVERT(TIME(7),GETDATE())),':',''));
			SET @data = (SELECT REPLACE(CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE())),'-',''));
		
			SELECT @tot = [Total Size in MB] FROM 
			(
				SELECT 
				DB_NAME() AS Banco
				,[Total Size in MB]
				FROM 
				(
					SELECT CAST((f.size/128.0) AS DECIMAL(15,2)) AS [Total Size in MB]
					--,*
					FROM sys.database_files AS f WITH (NOLOCK) 
					LEFT OUTER JOIN sys.data_spaces AS fg WITH (NOLOCK) 
					ON f.data_space_id = fg.data_space_id 
					WHERE f.type_desc='LOG' AND f.name!='LogSec'
				) AS a
		
			) AS B
		END
		ELSE	
			WAITFOR DELAY '00:01:00'
	END
	FETCH NEXT FROM c INTO @dname;
END;
CLOSE c;
DEALLOCATE c;
