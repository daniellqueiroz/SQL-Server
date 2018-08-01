-- use this script to generate the commands to recreate all foreign keys that are non-trusted within the database
--usage: exec PegarFksTabelaSemCheck

IF OBJECT_ID('fncountfkid') IS NOT NULL
	DROP FUNCTION fncountfkid
GO
CREATE FUNCTION dbo.fncountfkid (@name VARCHAR(1000))
RETURNS INT
AS
BEGIN
	RETURN(
	SELECT COUNT(fkc.constraint_column_id)
	FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
	WHERE fk.name=@name
	)
END
GO
IF OBJECT_ID('fnpeganmcampoporid') IS NOT NULL
	DROP FUNCTION fnpeganmcampoporid
GO
CREATE FUNCTION dbo.fnpeganmcampoporid(@name VARCHAR(1000),@varauxcountfkidcolumn INT)
RETURNS VARCHAR(1000)
AS
BEGIN
	RETURN(
	SELECT name FROM sys.columns WHERE column_id = (SELECT fkc.constraint_column_id
	FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
	WHERE fk.name=@name)
	)
END 


SELECT TOP 10 * FROM sys.foreign_key_columns
SELECT *
	FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
	WHERE fk.name='FK_Email_Sku'

SELECT dbo.fncountfkid('FK_Email_Sku')

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PegarFksTabelaSemCheck') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].PegarFksTabelaSemCheck AS' 
END
GO
ALTER PROCEDURE PegarFksTabelaSemCheck
AS 
BEGIN    
	DECLARE @cmd VARCHAR(4000)    
	DECLARE @tblname VARCHAR(100)    
	DECLARE @cstrname VARCHAR(100)    
	DECLARE @fkconstraintcolumnid VARCHAR(100)    
	DECLARE @cfkname VARCHAR(100)    
	DECLARE @crkname VARCHAR(100)    
	DECLARE @referenced_object_id VARCHAR(100)    
	DECLARE @varcountfkidcolumn TINYINT    
	DECLARE @varauxcountfkidcolumn TINYINT    
	DECLARE @update_referential_action TINYINT    
	DECLARE @delete_referential_action TINYINT    

	DECLARE fksemcheck CURSOR
	FOR
		SELECT    
--SCHEMA_NAME(tbl.schema_id) AS [Table_Schema],    
				tbl.name AS [Table_Name] ,
				cstr.name AS [ForeignKey_Name] ,
				cfk.name AS [Name] ,
				crk.name AS [ReferencedColumn] ,
				fk.referenced_object_id ,
				cstr.[update_referential_action] ,
				cstr.[delete_referential_action]
		FROM    sys.tables AS tbl
				INNER JOIN sys.foreign_keys AS cstr ON cstr.parent_object_id = tbl.object_id
				INNER JOIN sys.foreign_key_columns AS fk ON fk.constraint_object_id = cstr.object_id
				INNER JOIN sys.columns AS cfk ON fk.parent_column_id = cfk.column_id
												 AND fk.parent_object_id = cfk.object_id
				INNER JOIN sys.columns AS crk ON fk.referenced_column_id = crk.column_id
												 AND fk.referenced_object_id = crk.object_id
		WHERE   1 = 1
				AND tbl.name NOT LIKE 'AUDIT%'
				AND tbl.name NOT LIKE 'MS%'
				AND tbl.name NOT LIKE 'SYS%'
				AND tbl.name NOT LIKE 'FULLTEXT%'
				AND tbl.name NOT LIKE 'QUEUE%'    
--AND (OBJECT_NAME(fk.referenced_object_id)=@tabela OR OBJECT_NAME(fk.parent_object_id)=@tabela)    
				AND cstr.[is_not_trusted] = 1
				AND [cstr].[is_not_for_replication] = 0  
  
--(tbl.name=N'DominioFiltro' and SCHEMA_NAME(tbl.schema_id)=N'dbo')    
		ORDER BY    
--[Table_Schema] ASC,    
				[Table_Name] ASC ,
				[ForeignKey_Name] ASC    
  
	OPEN fksemcheck    

	FETCH NEXT FROM fksemcheck INTO @tblname, @cstrname, @cfkname,
		@crkname, @referenced_object_id, @update_referential_action,
		@delete_referential_action    

	WHILE @@FETCH_STATUS <> -1 
		BEGIN    
			SET @varcountfkidcolumn = dbo.fncountfkid(@cstrname)    
-- PRINT @varcountfkidcolumn    
			IF @varcountfkidcolumn = 1 
				BEGIN    
					SET @cmd = '' + 'BEGIN TRY' + CHAR(13) + CHAR(10)
						+ '--select count(*) from ' + @tblname + ' where '
						+ @cfkname + ' not in ( select ' + @crkname
						+ ' from ' + OBJECT_NAME(@referenced_object_id)
						+ ');' + CHAR(13) + CHAR(10) + '--delete from '
						+ @tblname + ' where ' + @cfkname
						+ ' not in ( select ' + @crkname + ' from '
						+ OBJECT_NAME(@referenced_object_id) + ');'
						+ CHAR(13) + CHAR(10)     
				  
							SET @cmd = @cmd + 'if object_id('''
								+ @cstrname
								+ ''') is not null alter table '
								+ @tblname + ' drop constraint '
								+ @cstrname + CHAR(13) + CHAR(10)     
							SET @cmd = @cmd + 'if object_id('''
								+ @cstrname + ''') is  null alter table '
								+ @tblname + ' with check add constraint '
								+ @cstrname + ' foreign key (' + @cfkname
								+ ') references '
								+ OBJECT_NAME(@referenced_object_id)
								+ ' (' + @crkname + ') ' + ' on update '
								+ CASE @update_referential_action
									WHEN 0 THEN ' no action '
									WHEN 1 THEN ' Cascade '
									WHEN 2 THEN ' Set null '
									WHEN 3 THEN ' Set default '
								  END + ' on delete '
								+ CASE @delete_referential_action
									WHEN 0 THEN ' no action '
									WHEN 1 THEN ' Cascade '
									WHEN 2 THEN ' Set null '
									WHEN 3 THEN ' Set default '
								  END     
					   
					SET @cmd = @cmd + CHAR(13) + CHAR(10) + 'END TRY'
						+ CHAR(13) + CHAR(10) + 'BEGIN CATCH' + CHAR(13)
						+ CHAR(10) + 'PRINT  ERROR_MESSAGE()' + CHAR(13)
						+ CHAR(10) + 'END CATCH' + CHAR(13) + CHAR(10)
						+ CHAR(13) + CHAR(10)    
					PRINT @cmd    
				END    
			ELSE 
				BEGIN    
					SET @cmd = '' + 'BEGIN TRY' + CHAR(13) + CHAR(10)
						+ '--select count(*) from ' + @tblname + ' where '
						+ @cfkname + ' not in ( select ' + @cstrname
						+ ' from ' + OBJECT_NAME(@referenced_object_id)
						+ ');' + CHAR(13) + CHAR(10) + '--delete from '
						+ @tblname + ' where ' + @cfkname
						+ ' not in ( select ' + @crkname + ' from '
						+ OBJECT_NAME(@referenced_object_id) + ');'
						+ CHAR(13) + CHAR(10)     
					SET @cmd = @cmd     
							SET @cmd = @cmd + 'if object_id('''
								+ @cstrname
								+ ''') is not null alter table '
								+ @tblname + ' drop constraint '
								+ @cstrname + CHAR(13) + CHAR(10)     
							SET @cmd = @cmd + 'if object_id('''
								+ @cstrname + ''') is null alter table '
								+ @tblname + ' with check add constraint '
								+ @cstrname + ' foreign key ('    

							SET @varauxcountfkidcolumn = 1    

							WHILE @varauxcountfkidcolumn < @varcountfkidcolumn
								+ 1 
								BEGIN    
									IF @varauxcountfkidcolumn > 1
										AND @varauxcountfkidcolumn < @varcountfkidcolumn
										+ 1 
										BEGIN    
											SET @cmd = @cmd + ','    
										END    
									SET @cmd = @cmd
										+ dbo.fnpeganmcampoporid(@cstrname,
														  @varauxcountfkidcolumn)    

									SET @varauxcountfkidcolumn = @varauxcountfkidcolumn
										+ 1    
								END    
							SET @cmd = @cmd + ') references '
								+ OBJECT_NAME(@referenced_object_id)
								+ ' ('    
	
							SET @varauxcountfkidcolumn = 1    
							WHILE @varauxcountfkidcolumn < @varcountfkidcolumn
								+ 1 
								BEGIN    
									IF @varauxcountfkidcolumn > 1
										AND @varauxcountfkidcolumn < @varcountfkidcolumn
										+ 1 
										SET @cmd = @cmd + ','    
									SET @cmd = @cmd
										+ dbo.fnpeganmcampoporid(@cstrname,
														  @varauxcountfkidcolumn) 
								+ CHAR(10) + 'END CATCH'    
						
					SET @cmd = @cmd + CHAR(13) + CHAR(10) + CHAR(13)+ CHAR(10)    
					PRINT @cmd    
				END    
  
			FETCH NEXT FROM fksemcheck INTO @tblname, @cstrname, @cfkname,
				@crkname, @referenced_object_id,
				@update_referential_action, @delete_referential_action    
		END    
	CLOSE fksemcheck    
	DEALLOCATE fksemcheck    
END
							  @varauxcountfkidcolumn)    
--   PRINT @varauxcountfkidcolumn    
									SET @varauxcountfkidcolumn = @varauxcountfkidcolumn
										+ 1    
								END    
   
							SET @cmd = @cmd + +') ' + ' on update '
								+ CASE @update_referential_action
									WHEN 0 THEN ' no action '
									WHEN 1 THEN ' Cascade '
									WHEN 2 THEN ' Set null '
									WHEN 3 THEN ' Set default '
								  END + ' on delete '
								+ CASE @delete_referential_action
									WHEN 0 THEN ' no action '
									WHEN 1 THEN ' Cascade '
									WHEN 2 THEN ' Set null '
									WHEN 3 THEN ' Set default '
								  END + CHAR(13) + CHAR(10) + 'END TRY'
								+ CHAR(13) + CHAR(10) + 'BEGIN CATCH'
								+ CHAR(13) + CHAR(10)
								+ 'PRINT  ERROR_MESSAGE()' + CHAR(13)
							
--------------------
