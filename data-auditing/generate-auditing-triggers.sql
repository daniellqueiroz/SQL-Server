-- replace the name of the table to generate the audit trigger for that table
-- check the output for better understading (adjust the output as needed)
-- do not use this script for tables with composite primaky keys

-- PARA INSERT
DECLARE @tabela VARCHAR(100)='Administrador',@pk VARCHAR(100)

SET @pk = (SELECT sc.name 
FROM sys.index_columns ic INNER join sys.columns sc ON sc.object_id = ic.object_id AND sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON i.object_id = ic.object_id
AND i.index_id=ic.index_id
WHERE OBJECT_NAME(i.object_id)=@tabela
AND i.is_primary_key=1)

;WITH cte AS (
SELECT 'SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tr_i_AUDIT_'+@tabela+']
ON [dbo].'+@tabela+'
FOR INSERT
NOT FOR REPLICATION
As
BEGIN
	DECLARE
		@IDENTITY_SAVE			varchar(50),
		@AUDIT_LOG_TRANSACTION_ID	Int,
		@PRIM_KEY			nvarchar(4000),
		@ROWS_COUNT				int

	SET NOCOUNT ON

	Select @ROWS_COUNT=count(*) from inserted
	SET @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))

	INSERT
	INTO dbo.AUDIT_LOG_TRANSACTIONS
	(
		TABLE_NAME,
		TABLE_SCHEMA,
		AUDIT_ACTION_ID,
		HOST_NAME,
		APP_NAME,
		MODIFIED_BY,
		MODIFIED_DATE,
		AFFECTED_ROWS,
		[DATABASE]
	)
	values(
		'''+@tabela+''',
		''dbo'',
		2,	--	ACTION ID For insert
		CASE
		  WHEN LEN(HOST_NAME()) < 1 THEN '' ''
		  ELSE HOST_NAME()
		END,
		CASE
		  WHEN LEN(APP_NAME()) < 1 THEN '' ''
		  ELSE APP_NAME()
		END,
		SUSER_SNAME(),
		GETDATE(),
		@ROWS_COUNT,
		db_name()
	)

	Set @AUDIT_LOG_TRANSACTION_ID = SCOPE_IDENTITY()' + CHAR(10)+CHAR(13) AS cabecalho,1 as ordem

union	
	
SELECT '	INSERT INTO dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		NEW_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		convert(nvarchar(1500), IsNull('''+@pk+'=''+CONVERT(nvarchar(4000), NEW.['+@pk+'], 0), ''['+@pk+'] Is Null'')),
		'''+name+''',
		CONVERT(nvarchar(4000), NEW.'+name+', 0),
		''A''
		, CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.['+@pk+'], 0))
	FROM inserted NEW
	WHERE NEW.'+name+' Is Not Null;' + CHAR(10)+CHAR(13) AS cabecalho,2 as ordem
	FROM sys.columns 
	WHERE object_id=object_id(''+@tabela+'')
	
union

select CHAR(10)+CHAR(13) + 'End'  AS cabecalho,3 as ordem

)
select cte.cabecalho from cte order by ordem

GO

-- PARA UPDATE
GO

DECLARE @tabela VARCHAR(100)='Administrador',@pk VARCHAR(100)

SET @pk = (SELECT sc.name 
FROM sys.index_columns ic INNER join sys.columns sc ON sc.object_id = ic.object_id AND sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON i.object_id = ic.object_id
AND i.index_id=ic.index_id
WHERE OBJECT_NAME(i.object_id)=@tabela
AND i.is_primary_key=1)

;WITH cte AS (
SELECT 'SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tr_u_AUDIT_'+@tabela+']
ON [dbo].'+@tabela+'
FOR UPDATE
NOT FOR REPLICATION
As
BEGIN
	DECLARE
		@IDENTITY_SAVE			varchar(50),
		@AUDIT_LOG_TRANSACTION_ID	Int,
		@PRIM_KEY			nvarchar(4000),
		@Inserted	    		bit,
 		@ROWS_COUNT				int

	SET NOCOUNT ON

	Select @ROWS_COUNT=count(*) from inserted
	SET @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))

	INSERT
	INTO dbo.AUDIT_LOG_TRANSACTIONS
	(
		TABLE_NAME,
		TABLE_SCHEMA,
		AUDIT_ACTION_ID,
		HOST_NAME,
		APP_NAME,
		MODIFIED_BY,
		MODIFIED_DATE,
		AFFECTED_ROWS,
		[DATABASE]
	)
	values(
		'''+@tabela+''',
		''dbo'',
		1,	--	ACTION ID For UPDATE
		CASE
		  WHEN LEN(HOST_NAME()) < 1 THEN '' ''
		  ELSE HOST_NAME()
		END,
		CASE
		  WHEN LEN(APP_NAME()) < 1 THEN '' ''
		  ELSE APP_NAME()
		END,
		SUSER_SNAME(),
		GETDATE(),
		@ROWS_COUNT,
		db_name()
	)


	Set @AUDIT_LOG_TRANSACTION_ID = SCOPE_IDENTITY()


	SET @Inserted = 0' + CHAR(10)+CHAR(13) AS cabecalho,1 as ordem

union

SELECT 'If UPDATE(['+name+'])
	BEGIN
    
		INSERT
		INTO dbo.AUDIT_LOG_DATA 
		(
			AUDIT_LOG_TRANSACTION_ID,
			PRIMARY_KEY_DATA,
			COL_NAME,
			OLD_VALUE_LONG,
			NEW_VALUE_LONG,
			DATA_TYPE
			, KEY1
		)
		SELECT
			@AUDIT_LOG_TRANSACTION_ID,
		    convert(nvarchar(1500), IsNull('''+@pk+'=''+CONVERT(nvarchar(4000), IsNull(OLD.'+@pk+', NEW.'+@pk+'), 0), '''+@pk+' Is Null'')),
		    '''+name+''',
			CONVERT(nvarchar(4000), OLD.'+name+', 0),
			CONVERT(nvarchar(4000), NEW.'+name+', 0),
			''A''
			, IsNULL( CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.'+@pk+', 0)), CONVERT(nvarchar(500), CONVERT(nvarchar(4000), NEW.'+@pk+', 0)))
			
		FROM deleted OLD Inner Join inserted NEW On 
			(CONVERT(nvarchar(4000), NEW.'+@pk+', 0)=CONVERT(nvarchar(4000), OLD.'+@pk+', 0) or (NEW.'+@pk+' Is Null and OLD.'+@pk+' Is Null))
			where (
			
			
				(
					NEW.'+name+' <>
					OLD.'+name+'
				) Or
			
				(
					NEW.'+name+' Is Null And
					OLD.'+name+' Is Not Null
				) Or
				(
					NEW.'+name+' Is Not Null And
					OLD.'+name+' Is Null
				)
				)
        
		SET @Inserted = CASE WHEN @@ROWCOUNT > 0 Then 1 Else @Inserted End
	END' + CHAR(10)+CHAR(13)  AS cabecalho,2 as ordem

	


FROM sys.columns WHERE object_id=object_id(@tabela)

	--AND NAME IN ('NOME','FlagAtiva','Posicao')
	--AND NAME IN ('NOME','FlagFiltro')
	--AND NAME IN ('NOME')

union

select 'IF @Inserted = 0
	BEGIN
		DELETE FROM dbo.AUDIT_LOG_TRANSACTIONS WHERE AUDIT_LOG_TRANSACTION_ID = @AUDIT_LOG_TRANSACTION_ID
	END' + CHAR(10)+CHAR(13) + 'End'  AS cabecalho,3 as ordem

)

SELECT cte.cabecalho FROM cte ORDER BY ordem

GO

-- PARA DELETE

DECLARE @tabela VARCHAR(100)='Administrador',@pk VARCHAR(100)

SET @pk = (SELECT sc.name 
FROM sys.index_columns ic INNER join sys.columns sc ON sc.object_id = ic.object_id AND sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON i.object_id = ic.object_id
AND i.index_id=ic.index_id
WHERE OBJECT_NAME(i.object_id)=@tabela
AND i.is_primary_key=1)

;WITH cte AS (
SELECT 'SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tr_d_AUDIT_'+@tabela+']
ON [dbo].'+@tabela+'
FOR DELETE
NOT FOR REPLICATION
AS
BEGIN
	DECLARE 
		@IDENTITY_SAVE				varchar(50),
		@AUDIT_LOG_TRANSACTION_ID		Int,
		@PRIM_KEY				nvarchar(4000),
 		@ROWS_COUNT				int
 
	SET NOCOUNT ON

	Select @ROWS_COUNT=count(*) from deleted
	Set @IDENTITY_SAVE = CAST(IsNull(@@IDENTITY,1) AS varchar(50))

	INSERT
	INTO dbo.AUDIT_LOG_TRANSACTIONS
	(
		TABLE_NAME,
		TABLE_SCHEMA,
		AUDIT_ACTION_ID,
		HOST_NAME,
		APP_NAME,
		MODIFIED_BY,
		MODIFIED_DATE,
		AFFECTED_ROWS,
		[DATABASE]
	)
	values(
		'''+@tabela+''',
		''dbo'',
		3,	--	ACTION ID For DELETE
		CASE 
		  WHEN LEN(HOST_NAME()) < 1 THEN '' ''
		  ELSE HOST_NAME()
		END,
		CASE 
		  WHEN LEN(APP_NAME()) < 1 THEN '' ''
		  ELSE APP_NAME()
		END,
		SUSER_SNAME(),
		GETDATE(),
		@ROWS_COUNT,
		db_name()
	)

	
	Set @AUDIT_LOG_TRANSACTION_ID = SCOPE_IDENTITY()'+ CHAR(10)+CHAR(13) AS cabecalho,1 as ordem

UNION

SELECT 'INSERT
	INTO dbo.AUDIT_LOG_DATA
	(
		AUDIT_LOG_TRANSACTION_ID,
		PRIMARY_KEY_DATA,
		COL_NAME,
		OLD_VALUE_LONG,
		DATA_TYPE
		, KEY1
	)
	SELECT
		@AUDIT_LOG_TRANSACTION_ID,
		convert(nvarchar(1500), IsNull('''+@pk+'=''+CONVERT(nvarchar(4000), OLD.'+@pk+', 0), '''+@pk+' Is Null'')),
		'''+name+''',
		CONVERT(nvarchar(4000), OLD.'+name+', 0),
		''A''
		,  CONVERT(nvarchar(500), CONVERT(nvarchar(4000), OLD.'+@pk+', 0))
	FROM deleted OLD
	WHERE
		OLD.'+name+' Is Not Null'+ CHAR(10)+CHAR(13)  AS cabecalho,2 as ordem

FROM sys.columns WHERE object_id=object_id(@tabela)
	--AND NAME IN ('NOME','FlagAtiva','Posicao')
	--AND NAME IN ('NOME','FlagFiltro')
	--AND NAME IN ('NOME')

UNION

SELECT + 'End' AS cabecalho,3 as ordem

)
SELECT cte.cabecalho FROM cte ORDER BY ordem

