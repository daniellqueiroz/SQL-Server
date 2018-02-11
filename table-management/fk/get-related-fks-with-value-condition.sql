-- run this script to generate a delete script that points to specific conditions that can be a problem when dealing with foreign key constraints
-- example: say that you want to delete a record from table [Produto] but, due to foreign keys, the deletion is not possible
-- you can run this script pointing to the table, foreign key column (in this case IdProduto) and value that needs to be excluded
-- in the sample usage below we are pointing to table [Produto], field IdProduto and value 89999 for the IdProduto column
-- this will generate delete commands for all related tables for that specified value, so you can delete the desired record

-- sample usage
EXEC dbo.PegarFksTabelaComCondicao @tabela = 'produto', @campo = 'idproduto', @Condicao = '89999'


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PegarFksTabelaComCondicao') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].PegarFksTabelaComCondicao AS' 
END
GO
ALTER PROCEDURE PegarFksTabelaComCondicao(@tabela VARCHAR(100), @campo VARCHAR(200), @Condicao VARCHAR(MAX))  
AS  
BEGIN  
 DECLARE @cmd      VARCHAR(4000)  
 DECLARE @tblname     VARCHAR(100)  
 DECLARE @cstrname     VARCHAR(100)  
 DECLARE @fkconstraintcolumnid  VARCHAR(100)  
 DECLARE @cfkname     VARCHAR(100)  
 DECLARE @crkname     VARCHAR(100)  
 DECLARE @referenced_object_id  VARCHAR(100)  
 DECLARE @varcountfkidcolumn  TINYINT  
 DECLARE @varauxcountfkidcolumn TINYINT  
 DECLARE @update_referential_action TINYINT  
 DECLARE @delete_referential_action TINYINT  
  
 DECLARE fksemcheck CURSOR FOR  
  
  SELECT  
 --SCHEMA_NAME(tbl.schema_id) AS [Table_Schema],  
 tbl.name AS [Table_Name],  
 cstr.name AS [ForeignKey_Name],  
 cfk.name AS [Name],  
 crk.name AS [ReferencedColumn],  
 fk.referenced_object_id,  
 cstr.[update_referential_action],  
 cstr.[delete_referential_action]  
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
  AND OBJECT_NAME(fk.referenced_object_id)=@tabela
    
  --(tbl.name=N'DominioFiltro' and SCHEMA_NAME(tbl.schema_id)=N'dbo')  
  ORDER BY  
  --[Table_Schema] ASC,  
  [Table_Name] ASC,[ForeignKey_Name] ASC  
    
 OPEN fksemcheck  
  
 FETCH NEXT FROM fksemcheck INTO @tblname ,@cstrname ,@cfkname ,@crkname ,@referenced_object_id,@update_referential_action,@delete_referential_action  
  
 WHILE @@FETCH_STATUS <> - 1  
 BEGIN  
  SET @varcountfkidcolumn = (SELECT COUNT(constraint_column_id) FROM sys.foreign_key_columns WHERE constraint_object_id=OBJECT_ID(@cstrname))
  IF @varcountfkidcolumn = 1  
  BEGIN  
   SET @cmd = ''  
   
   + '--select count(*) from ' + @tblname + ' where ' + @cfkname + ' in ( select ' + @crkname + ' from ' + OBJECT_NAME(@referenced_object_id) + ' where ' + @campo + ' = ' + '''' + @Condicao + ''');' + CHAR(13) + CHAR(10)   
   + 'delete from ' + @tblname + ' where ' + @cfkname + ' in ( select ' + @crkname + ' from ' + OBJECT_NAME(@referenced_object_id) + ' where ' + @campo + ' = ' + '''' + @Condicao + ''');' + CHAR(13) + CHAR(10)   
   + CHAR(13) + CHAR(10)  + CHAR(13) + CHAR(10)  
   PRINT @cmd  
  END  
  ELSE  
  BEGIN  
   SET @cmd = ''  
   
   + '--select count(*) from ' + @tblname + ' where ' + @cfkname + ' in ( select ' + @cstrname + ' from ' + OBJECT_NAME(@referenced_object_id) + ' where ' + @campo + ' = ' + '''' + @Condicao + ''');' + CHAR(13) + CHAR(10)   
   + 'delete from ' + @tblname + ' where ' + @cfkname + ' in ( select ' + @crkname + ' from ' + OBJECT_NAME(@referenced_object_id) + ' where ' + @campo + ' = ' + '''' + @Condicao + ''');' + CHAR(13) + CHAR(10)   
   SET @cmd = @cmd   
   SET @cmd = @cmd + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)  
   PRINT @cmd  
  END  
    
  FETCH NEXT FROM fksemcheck INTO @tblname ,@cstrname,@cfkname ,@crkname ,@referenced_object_id,@update_referential_action,@delete_referential_action  
 END 
 CLOSE fksemcheck  
 DEALLOCATE fksemcheck
END