
if object_id('criaindices') is not null
drop procedure criaindices
go
CREATE procedure [dbo].[criaindices]
(@nome varchar(8000))
as
begin
set nocount on
DECLARE @indices TABLE (nome varchar(1000))          
        
SET @nome = @nome + ','        
          
WHILE CHARINDEX(',',@nome) > 0          
BEGIN          
           
 INSERT INTO @indices          
 VALUES(SUBSTRING(@nome,0,CHARINDEX(',',@nome)))          
           
 SET @nome = RIGHT(@nome,LEN(@nome) - CHARINDEX(',',@nome))          
END  

-- Get all existing indexes, but NOT the primary keys
DECLARE cIX CURSOR FOR
SELECT OBJECT_NAME(SI.Object_ID), SI.Object_ID, SI.Name, SI.Index_ID,si.fill_factor,si.is_primary_key,si.type_desc,SI.IS_UNIQUE_CONSTRAINT
FROM Sys.Indexes SI 
LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC ON SI.Name = TC.CONSTRAINT_NAME AND OBJECT_NAME(SI.Object_ID) = TC.TABLE_NAME
WHERE 1=1
AND OBJECTPROPERTY(SI.Object_ID, 'IsUserTable') = 1 and object_name(SI.object_id) not like 'sys%'
and object_name(SI.object_id) not like '%audit%' 
and object_name(SI.object_id) in (select * from @indices)
AND type_desc != 'heap'
AND is_primary_key = 0
ORDER BY OBJECT_NAME(SI.Object_ID), SI.Index_ID

DECLARE @IxTable SYSNAME
DECLARE @PKSQL SYSNAME
DECLARE @IxTableID INT
DECLARE @IxName SYSNAME
DECLARE @IxID INT
declare @IXincludeSQL NVARCHAR(4000)
DECLARE @fillfactor TINYINT
declare @isprimarykey tinyint
declare @pk bit
declare @typedesc varchar(20)
DECLARE @ISUNIQUE TINYINT
set @IXincludeSQL = ') include (' 

-- Loop through all indexes
OPEN cIX
FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID, @fillfactor,@isprimarykey,@typedesc,@ISUNIQUE
WHILE (@@FETCH_STATUS = 0)
BEGIN
   DECLARE @IXSQL NVARCHAR(max) SET @PKSQL = ''
   set @pk = @isprimarykey
   if @pk = 0 AND @ISUNIQUE = 0
   begin
	   SET @IXSQL = 'if not exists(select * from sys.indexes where name = ''' + @IxName + ''') CREATE '

	   -- Check if the index is unique
	   IF (@ISUNIQUE = 1)
		  SET @IXSQL = @IXSQL + 'UNIQUE '
	   
	   SET @IXSQL = @IXSQL + @typedesc + ' INDEX ' + @IxName + ' ON ' + @IxTable + '('
	end
	
	if @pk = 0 AND @ISUNIQUE = 1
	begin
		SET @IXSQL = 'if not exists(select * from sys.indexes where name = ''' + @IxName + ''') alter table ' + @IxTable
		SET @IXSQL = @IXSQL + ' add constraint ' + @IxName + ' UNIQUE ' + @typedesc + ' ('
	
	end
	
	if @pk = 1
	begin
		SET @IXSQL = 'if not exists(select * from sys.indexes where name = ''' + @IxName + ''') alter table ' + @IxTable
		SET @IXSQL = @IXSQL + ' add constraint ' + @IxName + ' primary key ' + @typedesc + ' ('
	
	end
	
   -- Get all columns of the index
   DECLARE cIxColumn CURSOR FOR 
      SELECT SC.Name, is_included_column
      FROM Sys.Index_Columns IC
         JOIN Sys.Columns SC ON IC.Object_ID = SC.Object_ID AND IC.Column_ID = SC.Column_ID
      WHERE IC.Object_ID = @IxTableID AND Index_ID = @IxID and ic.is_included_column = 0
      ORDER BY IC.Index_Column_ID

   declare @included bit
   set @included = 0
   DECLARE @IxColumn SYSNAME
   DECLARE @IxFirstColumn BIT SET @IxFirstColumn = 1

   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   WHILE (@@FETCH_STATUS = 0)
   BEGIN
      IF (@IxFirstColumn = 1)
         SET @IxFirstColumn = 0
      ELSE
         SET @IXSQL = @IXSQL + ', '

      SET @IXSQL = @IXSQL + @IxColumn
      
      

      FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn

	SET @IXSQL = @IXSQL + ')'
	
	
	if (SELECT count(*)
      FROM Sys.Index_Columns IC
         JOIN Sys.Columns SC ON IC.Object_ID = SC.Object_ID AND IC.Column_ID = SC.Column_ID
      WHERE IC.Object_ID = @IxTableID AND Index_ID = @IxID and ic.is_included_column = 1) > 0
		begin
		
		SET @IXSQL = @IXSQL + ' include ('
		
		DECLARE cIxColumn CURSOR FOR 
      SELECT SC.Name, is_included_column
      FROM Sys.Index_Columns IC
         JOIN Sys.Columns SC ON IC.Object_ID = SC.Object_ID AND IC.Column_ID = SC.Column_ID
      WHERE IC.Object_ID = @IxTableID AND Index_ID = @IxID and ic.is_included_column = 1
      ORDER BY IC.Index_Column_ID
	
   --declare @included bit
   set @included = 0
   --DECLARE @IxColumn SYSNAME
   --DECLARE @IxFirstColumn BIT 
   SET @IxFirstColumn = 1

   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   WHILE (@@FETCH_STATUS = 0)
   BEGIN
   
		
      IF (@IxFirstColumn = 1)
         SET @IxFirstColumn = 0
      ELSE
         SET @IXSQL = @IXSQL + ', '

      SET @IXSQL = @IXSQL + @IxColumn
		
		
		
      FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
      
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn
	   
	   SET @IXSQL = @IXSQL + ') with (fillfactor = '+CASE CAST(@fillfactor AS VARCHAR) WHEN 0 THEN '100' ELSE CAST(@fillfactor AS VARCHAR) END +')'
	   end
	   
   -- Print out the CREATE statement for the index
   PRINT @IXSQL

   FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID, @fillfactor,@isprimarykey,@typedesc,@ISUNIQUE
END

CLOSE cIX
DEALLOCATE cIX
end
GO

if object_id('sp_ScriptTable') is not null
drop procedure sp_ScriptTable
go
create PROCEDURE sp_ScriptTable 
(     
@TableName SYSNAME,     
@IncludeConstraints BIT = 1,     
@IncludeIndexes BIT = 0,     
@NewTableName SYSNAME = NULL,     
@UseSystemDataTypes BIT = 0 ) 
AS BEGIN     

set concat_null_yields_null off

DECLARE @MainDefinition TABLE     (         FieldValue VARCHAR(200)     )     
DECLARE @DBName SYSNAME     
DECLARE @ClusteredPK BIT     
DECLARE @TableSchema NVARCHAR(255)     

SET @DBName = DB_NAME(DB_ID())     
SELECT @TableName = name FROM sysobjects WHERE id = OBJECT_ID(@TableName)  
   
DECLARE @ShowFields TABLE     (         FieldID INT IDENTITY(1,1),         DatabaseName VARCHAR(100),         TableOwner VARCHAR(100),         TableName VARCHAR(100),         FieldName VARCHAR(100),         ColumnPosition INT,         ColumnDefaultValue VARCHAR(100),         ColumnDefaultName VARCHAR(100),         IsNullable BIT,         DataType VARCHAR(100),         MaxLength INT,         NumericPrecision INT,         NumericScale INT,         DomainName VARCHAR(100),         FieldListingName VARCHAR(110),         FieldDefinition CHAR(1),         IdentityColumn BIT,         IdentitySeed INT,         IdentityIncrement INT,         IsCharColumn BIT     )     
DECLARE @HoldingArea TABLE     (         FldID SMALLINT IDENTITY(1,1),         Flds VARCHAR(4000),         FldValue CHAR(1) DEFAULT(0)     )     
DECLARE @PKObjectID TABLE     (         ObjectID INT     )     DECLARE @Uniques TABLE     (         ObjectID INT     )     
DECLARE @HoldingAreaValues TABLE     (         FldID SMALLINT IDENTITY(1,1),         Flds VARCHAR(4000),         FldValue CHAR(1) DEFAULT(0)     )     
DECLARE @Definition TABLE     (         DefinitionID SMALLINT IDENTITY(1,1),         FieldValue VARCHAR(200)     )     

INSERT INTO @ShowFields     (                DatabaseName,         TableOwner,         TableName,         FieldName,         ColumnPosition,         ColumnDefaultValue,         ColumnDefaultName,         IsNullable,         DataType,         MaxLength,         NumericPrecision,         NumericScale,         DomainName,         FieldListingName,         FieldDefinition,         IdentityColumn,         IdentitySeed,         IdentityIncrement,         IsCharColumn     )     
SELECT   DB_NAME(),         TABLE_SCHEMA,         TABLE_NAME,         COLUMN_NAME,         CAST(ORDINAL_POSITION AS INT),         COLUMN_DEFAULT,         dobj.name AS ColumnDefaultName,         CASE WHEN c.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END,         DATA_TYPE,         CAST(CHARACTER_MAXIMUM_LENGTH AS INT),         CAST(NUMERIC_PRECISION AS INT),         CAST(NUMERIC_SCALE AS INT),         DOMAIN_NAME,         COLUMN_NAME + ',',         '' AS FieldDefinition,         CASE WHEN ic.object_id IS NULL THEN 0 ELSE 1 END AS IdentityColumn,         CAST(ISNULL(ic.seed_value,0) AS INT) AS IdentitySeed,         CAST(ISNULL(ic.increment_value,0) AS INT) AS IdentityIncrement,         CASE WHEN st.collation_name IS NOT NULL THEN 1 ELSE 0 END AS IsCharColumn     
FROM         INFORMATION_SCHEMA.COLUMNS c         JOIN sys.columns sc ON  c.TABLE_NAME = OBJECT_NAME(sc.object_id) AND c.COLUMN_NAME = sc.Name         LEFT JOIN sys.identity_columns ic ON c.TABLE_NAME = OBJECT_NAME(ic.object_id) AND c.COLUMN_NAME = ic.Name         JOIN sys.types st ON COALESCE(c.DOMAIN_NAME,c.DATA_TYPE) = st.name         LEFT OUTER JOIN sys.objects dobj ON dobj.object_id = sc.default_object_id AND dobj.type = 'D'     
WHERE c.TABLE_NAME = @TableName     
ORDER BY         c.TABLE_NAME, c.ORDINAL_POSITION     

SELECT TOP 1 @TableSchema = TableOwner     FROM @ShowFields     
INSERT INTO @HoldingArea (Flds) VALUES('(')     
INSERT INTO @Definition(FieldValue)     VALUES('if object_id('''+@tablename+''') is null ' + CHAR(10) + CHAR(13) + ' CREATE TABLE ' + CASE WHEN @NewTableName IS NOT NULL THEN @NewTableName ELSE + @TableSchema + '.' + @TableName END)     
INSERT INTO @Definition(FieldValue)     VALUES('(')     
INSERT INTO @Definition(FieldValue)         
SELECT      CHAR(10) + FieldName + ' ' +                                     
			CASE WHEN DomainName IS NOT NULL AND @UseSystemDataTypes = 0 THEN DomainName + 
			CASE WHEN IsNullable = 1 THEN ' NULL ' ELSE ' NOT NULL ' END                                         ELSE UPPER(DataType) +                                             
			CASE WHEN IsCharColumn = 1 and DataType <> 'text' THEN '(' + replace(CAST(MaxLength AS VARCHAR(10)),'-1','max') + ')' ELSE '' END +                                             
			CASE WHEN IsCharColumn = 1 and DataType = 'text' THEN '' END +                                             
			CASE WHEN IdentityColumn = 1 THEN ' IDENTITY(' + CAST(IdentitySeed AS VARCHAR(5))+ ',' + CAST(IdentityIncrement AS VARCHAR(5)) + ')' ELSE '' END +                                             
			CASE WHEN IsNullable = 1 THEN ' NULL ' ELSE ' NOT NULL ' END +                                             
			CASE WHEN ColumnDefaultName IS NOT NULL AND @IncludeConstraints = 1 THEN 'CONSTRAINT [' + ColumnDefaultName + '] DEFAULT' + UPPER(ColumnDefaultValue) ELSE '' END                                     END +                                     
			CASE WHEN FieldID = (SELECT MAX(FieldID) FROM @ShowFields) THEN '' ELSE ',' END         
FROM    @ShowFields         

IF @IncludeConstraints = 1         
BEGIN             
INSERT INTO @Definition(FieldValue)             
	SELECT             ',CONSTRAINT [' + name + '] FOREIGN KEY (' + ParentColumns + ') REFERENCES [' + ReferencedObject + '](' + ReferencedColumns + ')'             FROM             (                 SELECT                 ReferencedObject = OBJECT_NAME(fk.referenced_object_id), ParentObject = OBJECT_NAME(parent_object_id),fk.name,                 REVERSE(SUBSTRING(REVERSE((                 SELECT cp.name + ','                 FROM                 sys.foreign_key_columns fkc                 JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id                 WHERE fkc.constraint_object_id = fk.object_id                 FOR XML PATH('')                 )), 2, 8000)) ParentColumns,                 REVERSE(SUBSTRING(REVERSE((                 SELECT cr.name + ','                 FROM                 sys.foreign_key_columns fkc                 JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id                 WHERE fkc.constraint_object_id = fk.object_id                 FOR XML PATH('')                 )), 2, 8000)) ReferencedColumns                 FROM sys.foreign_keys fk             ) a             WHERE ParentObject = @TableName             INSERT INTO @Definition(FieldValue)             SELECT',CONSTRAINT [' + name + '] CHECK ' + definition FROM sys.check_constraints             WHERE OBJECT_NAME(parent_object_id) = @TableName         INSERT INTO @PKObjectID(ObjectID)         SELECT DISTINCT             PKObject = cco.object_id         FROM             sys.key_constraints cco             JOIN sys.index_columns cc ON cco.parent_object_id = cc.object_id AND cco.unique_index_id = cc.index_id             JOIN sys.indexes i ON cc.object_id = i.object_id AND cc.index_id = i.index_id         WHERE             OBJECT_NAME(parent_object_id) = @TableName    AND                i.type = 1 AND             is_primary_key = 1         INSERT INTO @Uniques(ObjectID)         SELECT DISTINCT             PKObject = cco.object_id         FROM             sys.key_constraints cco             JOIN sys.index_columns cc ON cco.parent_object_id = cc.object_id AND cco.unique_index_id = cc.index_id             JOIN sys.indexes i ON cc.object_id = i.object_id AND cc.index_id = i.index_id         WHERE             OBJECT_NAME(parent_object_id) = @TableName AND                    i.type = 2 AND             is_primary_key = 0 AND             is_unique_constraint = 1         
	SET @ClusteredPK = CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END         
	INSERT INTO @Definition(FieldValue)         
	SELECT    ',CONSTRAINT ' + name + CASE type WHEN 'PK' THEN ' PRIMARY KEY ' + CASE WHEN pk.ObjectID IS NULL THEN ' NONCLUSTERED ' ELSE ' CLUSTERED ' END                             WHEN 'UQ' THEN ' UNIQUE ' END + CASE WHEN u.ObjectID IS NOT NULL THEN ' NONCLUSTERED ' ELSE '' END + '(' +         REVERSE(SUBSTRING(REVERSE((             SELECT                 c.name +  + CASE WHEN cc.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END + ','             
	FROM                 sys.key_constraints ccok                 LEFT JOIN sys.index_columns cc ON ccok.parent_object_id = cc.object_id AND cco.unique_index_id = cc.index_id                 LEFT JOIN sys.columns c ON cc.object_id = c.object_id AND cc.column_id = c.column_id                 LEFT JOIN sys.indexes i ON cc.object_id = i.object_id AND cc.index_id = i.index_id             
	WHERE                 i.object_id = ccok.parent_object_id AND                 ccok.object_id = cco.object_id             FOR XML PATH('')         )), 2, 8000)) + ')'         
	FROM             sys.key_constraints cco             LEFT JOIN @PKObjectID pk ON cco.object_id = pk.ObjectID             LEFT JOIN @Uniques u ON cco.object_id = u.objectID         
	WHERE             OBJECT_NAME(cco.parent_object_id) = @TableName         
END         

INSERT INTO @Definition(FieldValue)         VALUES(')' + char(10) +char(13)+ 'GO')         



IF @IncludeIndexes = 1         
BEGIN             
	INSERT INTO @Definition(FieldValue)             
	SELECT                 'CREATE ' + type_desc + ' INDEX [' + [name] COLLATE SQL_Latin1_General_CP1_CI_AS + '] ON [' +  OBJECT_NAME(object_id) + '] (' +                 REVERSE(SUBSTRING(REVERSE((                     SELECT name + CASE WHEN sc.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END + ','                     
	FROM                         sys.index_columns sc                         JOIN sys.columns c ON sc.object_id = c.object_id AND sc.column_id = c.column_id                     WHERE                         OBJECT_NAME(sc.object_id) = @TableName AND                         sc.object_id = i.object_id AND                         sc.index_id = i.index_id                     ORDER BY index_column_id ASC                     FOR XML PATH('')             )), 2, 8000)) + ')'             FROM sys.indexes i             WHERE                 OBJECT_NAME(object_id) = @TableName                 AND CASE WHEN @ClusteredPK = 1 AND is_primary_key = 1 AND type = 1 THEN 0 ELSE 1 END = 1                 AND is_unique_constraint = 0                 AND is_primary_key = 0         END             INSERT INTO @MainDefinition(FieldValue)             SELECT FieldValue FROM @Definition             
	ORDER BY DefinitionID ASC         
	SELECT * FROM @MainDefinition 
	
	
END 

EXEC criaindices @tablename



GO



select 'exec sp_scripttable '''+name+''',1,0' from staples.sys.tables where name not in
(select name from pedalav3.sys.tables)