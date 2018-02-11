-- run this script to generate a script containing the create command for all triggers inside the database

SET NOCOUNT ON

DECLARE @procs AS TABLE( cdrop VARCHAR(1000)
, nome VARCHAR(200)
, object_id INT
, definition NVARCHAR(MAX)
, uses_ansi_nulls BIT
, uses_quoted_identifier BIT
)
INSERT INTO @procs
SELECT 'if exists (select * from sys.objects where name =''' + o.name + ''') drop ' + CASE o.type_desc WHEN  'function' THEN ' function ' WHEN 'SQL_TRIGGER' THEN ' trigger ' ELSE ' Procedure ' END + o.name + CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10) AS CDrop
	,o.name
	 ,m.object_id
     , m.definition
     , m.uses_ansi_nulls
     , m.uses_quoted_identifier
	 --,o.type_desc
FROM sys.sql_modules AS m
INNER JOIN sys.objects AS o
    ON m.object_id = o.object_id
WHERE 1=1
--and o.type = 'P'
AND o.type='TR'
--AND m.definition LIKE '%for%'
AND o.name LIKE '%audit%'


DECLARE @endStmt NCHAR(6)
      , @object_id INT
      , @definition NVARCHAR(MAX)
      , @uses_ansi_nulls BIT
      , @uses_quoted_identifier BIT
	  , @cdrop VARCHAR(1000)    

DECLARE @crlf VARCHAR(2), @len BIGINT, @offset BIGINT, @part BIGINT

SELECT @object_id = MIN(object_id)
     , @endStmt = CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
FROM @procs

DECLARE c CURSOR FOR 
SELECT cdrop + [definition]
,  uses_ansi_nulls
,  uses_quoted_identifier
FROM @procs
ORDER BY nome ASC

OPEN c
FETCH NEXT FROM c INTO @definition,@uses_ansi_nulls,@uses_quoted_identifier

WHILE @@fetch_status<>-1
BEGIN
    IF @uses_ansi_nulls = 1
        PRINT 'SET ANSI_NULLS ON' + @endStmt;
    ELSE
        PRINT 'SET ANSI_NULLS OFF' + @endStmt;

    IF @uses_quoted_identifier = 1
        PRINT 'SET QUOTED_IDENTIFIER ON' + @endStmt;
    ELSE
        PRINT 'SET QUOTED_IDENTIFIER OFF' + @endStmt;

	--PRINT @definition;

    IF LEN(@definition) <= 4000
        PRINT @definition
    ELSE
    BEGIN

        SELECT @crlf = CHAR(13)+CHAR(10)
             , @len = LEN(@definition)
             , @offset = 1
             , @part = CHARINDEX(@crlf,@definition)-1

        WHILE @offset <= @len AND @part>=0
        BEGIN
			
			--PRINT @offset
			--PRINT @part
			--PRINT LEN(@crlf)
			--PRINT @len
			      
            PRINT SUBSTRING(@definition,@offset,@part)

            SET @offset = @offset + @part + LEN(@crlf)
            SET @part = CHARINDEX(@crlf,@definition,@offset)-@offset

			--PRINT @offset
			--PRINT @part
			--PRINT @len

			IF @part < 0 
			PRINT SUBSTRING(@definition,@offset,100)
        END
    END

	PRINT @endStmt;


FETCH NEXT FROM c INTO @definition,@uses_ansi_nulls,@uses_quoted_identifier
END
CLOSE c
DEALLOCATE c












