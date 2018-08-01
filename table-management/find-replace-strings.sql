/*

run this script to create a procedure that will look for a string inside the database, replacing it for another string. 

single table usage: EXEC buscarStringsNobanco 'newsletter','freg','cliente'
multiple table usage: EXEC sp_msforeachtable 'exec buscarStringsNobanco ''?'',''privalia'',''privália'''
multiple table usage (option two below):

PRINT 'set nocount off' + CHAR(13) + CHAR(10)
DECLARE @tab VARCHAR(400)
DECLARE TAB CURSOR FOR 
SELECT name FROM sys.tables
WHERE 1=1
and type_desc = 'USER_TABLE'
AND name NOT LIKE '%bkp%'
AND name NOT LIKE '%backup%'
AND name NOT LIKE 'MS%'
AND name NOT LIKE 'sys%'
AND name <> 'strings'
--and name = 'paginafisicaconfig'
ORDER BY name
OPEN TAB
FETCH NEXT FROM TAB INTO @tab
WHILE @@fetch_status <> -1
BEGIN
	--RAISERROR (@tab, 0, 1) WITH NOWAIT
	EXEC buscarStringsNobanco @tab,'caminhão','carrinho'
	FETCH NEXT FROM TAB INTO @tab
END 
CLOSE TAB
DEALLOCATE tab

*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].buscarStringsNobanco') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].buscarStringsNobanco AS' 
END
GO
ALTER PROCEDURE buscarStringsNobanco (@tabela VARCHAR(200),@string VARCHAR(1000), @stringnova VARCHAR(1000))
AS
BEGIN
--DECLARE @string VARCHAR(1000)
--SET @string = 'leader'
SET @string = LOWER(@string)
DECLARE @count INT
DECLARE @comando NVARCHAR(4000)
DECLARE @tipo SMALLINT
DECLARE @printselect VARCHAR(4000)
DECLARE @printupdate VARCHAR(4000)
DECLARE curcampos CURSOR
FOR 
SELECT DISTINCT sta.name, sc.name, st.system_type_id FROM sys.columns sc, sys.types st, sys.tables sta 
WHERE sc.system_type_id  = st.system_type_id
AND sc.[object_id] = sta.[object_id]
AND OBJECT_NAME(sta.[object_id]) = @tabela
AND st.system_type_id IN (35,99,167,175,231,239)
AND sta.type_desc = 'USER_TABLE'
AND sta.name NOT LIKE '%bkp%'
AND sta.name NOT LIKE '%backup%'
OPEN curcampos
DECLARE @table VARCHAR(100), @campo VARCHAR(100)
FETCH NEXT FROM curcampos INTO @table, @campo, @tipo
WHILE @@FETCH_STATUS <> -1
BEGIN
	SET @printselect = ''
	SET @printupdate = ''
	
	SET @string = LOWER(@string)
	SET @stringnova = LOWER(@stringnova)
	
	SET @comando = N'select @x = count(*) from ' + @tabela + ' where ' + @campo + ' like ''%' + @string + '%'''
	EXEC sp_executesql @comando, N'@x int output',@count OUTPUT
	
	--IF @count > 0
	--BEGIN 
	--	PRINT CHAR(13) + CHAR(10) + 'set nocount off' + CHAR(13) + CHAR(10)
	--END 
	
	IF @count > 0
	BEGIN 
		SET @printselect = 'select ' + @campo + ' from ' + @tabela + ' where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
		IF @tipo = 35
			SET @printupdate = 'UPDATE ' + @tabela + ' set ' + @campo + ' = replace(cast(' + @campo + ' as varchar(max)) collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%''' 
		ELSE
			SET @printupdate = 'UPDATE ' + @tabela + ' set ' + @campo + ' = replace(' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%''' 
	END 	
	
	
	SET @string = UPPER(@string)
	SET @stringnova = UPPER(@stringnova)
	
	SET @comando = N'select @x = count(*) from ' + @tabela + ' where ' + @campo + ' like ''%' + @string + '%'''
	EXEC sp_executesql @comando, N'@x int output',@count OUTPUT
	
	IF @count > 0
	BEGIN 
		SET @printselect = @printselect + CHAR(13) + CHAR(10) + ' select ' + @campo + ' from ' + @tabela + ' where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
		IF @tipo = 35
			SET @printupdate = @printupdate  + CHAR(13) + CHAR(10) + ' UPDATE ' + @tabela + ' set ' + @campo + ' = replace(cast(' + @campo + ' as varchar(max)) collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
		ELSE
			SET @printupdate = @printupdate  + CHAR(13) + CHAR(10) + ' UPDATE ' + @tabela + ' set ' + @campo + ' = replace(' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
	END 
	
	SET @string = LOWER(@string)
	SET @stringnova = LOWER(@stringnova)	
	SET @string = UPPER(LEFT(@string,1)) + SUBSTRING(@string,2,4000)
	SET @stringnova = UPPER(LEFT(@stringnova,1)) + SUBSTRING(@stringnova,2,4000)
	
	SET @comando = N'select @x = count(*) from ' + @tabela + ' where ' + @campo + ' like ''%' + @string + '%'''
	EXEC sp_executesql @comando, N'@x int output',@count OUTPUT
	IF @count > 0
	BEGIN
		SET @printselect = @printselect + CHAR(13) + CHAR(10) + ' select ' + @campo + ' from ' + @tabela + ' where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
		IF @tipo = 35
			SET @printupdate = @printupdate  + CHAR(13) + CHAR(10) + ' UPDATE ' + @tabela + ' set ' + @campo + ' = replace(cast(' + @campo + ' as varchar(max)) collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
		ELSE
			SET @printupdate = @printupdate  + CHAR(13) + CHAR(10) + ' UPDATE ' + @tabela + ' set ' + @campo + ' = replace(' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS , ''' + @string + ''',' + '''' + @stringnova + ''') where ' + @campo + ' collate SQL_Latin1_General_CP1_CS_AS like ''%' + @string + '%'''
	END 
	
	--RAISERROR (@printselect, 0, 1) WITH NOWAIT 
	--RAISERROR (@printupdate, 0, 1) WITH NOWAIT 
	
	IF @printselect <> '' AND @printupdate <> ''
	BEGIN
		PRINT @printselect + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		PRINT @printupdate + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
	END
	
FETCH NEXT FROM curcampos INTO @table, @campo, @tipo
END
CLOSE curcampos
DEALLOCATE curcampos

END