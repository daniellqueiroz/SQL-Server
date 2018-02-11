-- run this script to generate a script that will recreate all your foreign keys that do not comply with your naming standards
-- you can change the standards used in this script as you see fit

IF OBJECT_ID('CorrigirFksComNomeErrado') IS NOT NULL
	DROP PROC CorrigirFksComNomeErrado
GO
CREATE PROCEDURE CorrigirFksComNomeErrado
AS  
SET CONCAT_NULL_YIELDS_NULL OFF
DECLARE @cmd					 VARCHAR(4000)
DECLARE @tblname 				VARCHAR(100)
DECLARE @cstrname 				VARCHAR(100), @fkname VARCHAR(100)
DECLARE @fkconstraintcolumnid 	VARCHAR(100)
DECLARE @cfkname 				VARCHAR(100)
DECLARE @crkname 				VARCHAR(100)
DECLARE @referenced_object_id 	VARCHAR(100)
DECLARE @varcountfkidcolumn		TINYINT
DECLARE @varauxcountfkidcolumn	TINYINT
DECLARE @update_referential_action TINYINT
DECLARE @delete_referential_action TINYINT
DECLARE @is_not_for_replication TINYINT
DECLARE fksemcheck CURSOR FOR

SELECT
tbl.name AS [Table_Name],
cstr.name AS [ForeignKey_Name],
cfk.name AS [Name],
crk.name AS [ReferencedColumn],
fk.referenced_object_id,
cstr.[update_referential_action],
cstr.[delete_referential_action],
cstr.is_not_for_replication
		FROM
	sys.tables AS tbl
	INNER JOIN sys.foreign_keys AS cstr ON cstr.parent_object_id=tbl.object_id
	INNER JOIN sys.foreign_key_columns AS fk ON fk.constraint_object_id=cstr.object_id
	INNER JOIN sys.columns AS cfk ON fk.parent_column_id = cfk.column_id AND fk.parent_object_id = cfk.object_id
	INNER JOIN sys.columns AS crk ON fk.referenced_column_id = crk.column_id AND fk.referenced_object_id = crk.object_id
	WHERE 1=1 
	AND tbl.name NOT LIKE 'AUDIT%'
	AND tbl.name NOT LIKE 'MS%'
	AND tbl.name NOT LIKE 'SYS%'
	AND tbl.name NOT LIKE 'FULLTEXT%'
	AND tbl.name NOT LIKE 'QUEUE%'
	AND cstr.name LIKE '%[123456789]' 
	AND (LEN(cstr.name) - LEN(REPLACE(cstr.name, '_', '')))>4

	ORDER BY
	[Table_Name] ASC,[ForeignKey_Name] ASC
	
OPEN fksemcheck

FETCH NEXT FROM fksemcheck INTO @tblname ,@cstrname ,@cfkname ,@crkname ,@referenced_object_id,@update_referential_action,@delete_referential_action,@is_not_for_replication

WHILE @@FETCH_STATUS <> - 1
BEGIN
	SET @varcountfkidcolumn = (SELECT COUNT(constraint_column_id) FROM sys.foreign_key_columns WHERE constraint_object_id=OBJECT_ID(@cstrname))
	SET @fkname='FK_' +@tblname+'_'+OBJECT_NAME(@referenced_object_id)
	
	IF @varcountfkidcolumn = 1
	BEGIN
		SET @cmd = ''
		+ 'BEGIN TRY' + CHAR(13) + CHAR(10)
		+ 'if object_id('''+@cstrname+''') is not null alter table ' +@tblname + ' drop constraint ' + @cstrname + CHAR(13) + CHAR(10) 
		+ 'END TRY'
		+ CHAR(13) + CHAR(10) 
		+ 'BEGIN CATCH'
		+ CHAR(13) + CHAR(10) 
		+ 'PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)'
		+ CHAR(13) + CHAR(10) 
		+ 'END CATCH'
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		PRINT @cmd
		
		SET @cmd = ''
		+ 'BEGIN TRY' + CHAR(13) + CHAR(10)
		+ 'if object_id('''+@fkname+''') is  null and object_id('''+@tblname+''') is not null alter table ' +@tblname
		+ ' with check add constraint '+@fkname
		+ ' foreign key (' + @cfkname + ') references ' 
		+ OBJECT_NAME(@referenced_object_id) + ' (' + @crkname + ') ' 
		+ CASE @is_not_for_replication WHEN 0 THEN ' on update ' END 
		+ CASE @is_not_for_replication WHEN 0 THEN 
			CASE @update_referential_action WHEN 0 THEN ' no action ' WHEN 1 THEN ' Cascade ' WHEN 2 THEN ' Set null ' WHEN 3 THEN ' Set default ' END 
		  END 
		+ CASE @is_not_for_replication WHEN 0 THEN ' on delete ' END 
		+ CASE @is_not_for_replication WHEN 0 THEN 
			CASE @delete_referential_action WHEN 0 THEN ' no action ' WHEN 1 THEN ' Cascade ' WHEN 2 THEN ' Set null ' WHEN 3 THEN ' Set default ' END 
		  ELSE ' not for replication ' 
		END
		+ CHAR(13) + CHAR(10) 
		+ 'END TRY'
		+ CHAR(13) + CHAR(10) 
		+ 'BEGIN CATCH'
		+ CHAR(13) + CHAR(10) 
		+ 'PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)'
		+ CHAR(13) + CHAR(10) 
		+ 'END CATCH'
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		PRINT @cmd
	END
	ELSE
	BEGIN
		SET @cmd = ''
		+ 'BEGIN TRY' + CHAR(13) + CHAR(10)
		+ 'if object_id('''+@fkname+''') is not null alter table ' +@tblname + ' drop constraint ' + @cstrname + CHAR(13) + CHAR(10) 
		+ 'END TRY'
		+ CHAR(13) + CHAR(10) 
		+ 'BEGIN CATCH'
		+ CHAR(13) + CHAR(10) 
		+ 'PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)'
		+ CHAR(13) + CHAR(10) 
		+ 'END CATCH'
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		PRINT @cmd
	
		SET @cmd = ''
		+ 'BEGIN TRY' + CHAR(13) + CHAR(10)
		+ 'if object_id('''+@cstrname+''') is  null alter table ' + @tblname
		+ ' with check add constraint '+@fkname
		+ ' foreign key ('
		SET @varauxcountfkidcolumn = 1
		WHILE @varauxcountfkidcolumn < @varcountfkidcolumn + 1
		BEGIN
			IF @varauxcountfkidcolumn > 1 AND @varauxcountfkidcolumn < @varcountfkidcolumn + 1
			BEGIN
				SET @cmd = @cmd + ','
			END
			SET @cmd = @cmd + dbo.fnpeganmcampoporid(@cstrname,@varauxcountfkidcolumn)
--			PRINT @varauxcountfkidcolumn
			SET @varauxcountfkidcolumn = @varauxcountfkidcolumn + 1
		END
		SET @cmd = @cmd + ') references ' + OBJECT_NAME(@referenced_object_id) + ' ('
		
		SET @varauxcountfkidcolumn = 1
		WHILE @varauxcountfkidcolumn < @varcountfkidcolumn + 1
		BEGIN
			IF @varauxcountfkidcolumn > 1 AND @varauxcountfkidcolumn < @varcountfkidcolumn + 1
			SET @cmd = @cmd + ','
			SET @cmd = @cmd + dbo.fnpeganmcampoporid(@cstrname,@varauxcountfkidcolumn)
--			PRINT @varauxcountfkidcolumn
			SET @varauxcountfkidcolumn = @varauxcountfkidcolumn + 1
		END
	
		SET @cmd = @cmd + + ') ' +
		' on update ' +
		CASE @update_referential_action WHEN 0 THEN ' no action ' WHEN 1 THEN ' Cascade ' WHEN 2 THEN ' Set null ' WHEN 3 THEN ' Set default ' END +
		' on delete ' +
		CASE @delete_referential_action WHEN 0 THEN ' no action ' WHEN 1 THEN ' Cascade ' WHEN 2 THEN ' Set null ' WHEN 3 THEN ' Set default ' END 
		+ CHAR(13) + CHAR(10) 
		+ 'END TRY'
		+ CHAR(13) + CHAR(10) 
		+ 'BEGIN CATCH'
		+ CHAR(13) + CHAR(10) 
		+ 'PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)'
		+ CHAR(13) + CHAR(10) 
		+ 'END CATCH'
		+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		PRINT @cmd
	END
	
	FETCH NEXT FROM fksemcheck INTO @tblname ,@cstrname,@cfkname ,@crkname ,@referenced_object_id,@update_referential_action,@delete_referential_action,@is_not_for_replication
END
CLOSE fksemcheck
DEALLOCATE fksemcheck
GO


