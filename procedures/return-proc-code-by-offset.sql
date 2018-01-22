/*

Remarks:

1. This script will give will the code of an object contained between the offsets specified. This is good for troubleshooting situations where you have to get to the specific parts of a routine that are causing trouble.
2. You can get the offsets from management views like sys.dm_exec_sessions, sys.sysprocesses among others

*/

SET NOCOUNT ON

DECLARE @procs AS TABLE( nome VARCHAR(200),object_id INT
                        , definition NVARCHAR(MAX)
                        , uses_ansi_nulls BIT
                        , uses_quoted_identifier BIT
                        )
INSERT INTO @procs
SELECT o.name
	 ,m.object_id
     , m.definition
     , m.uses_ansi_nulls
     , m.uses_quoted_identifier
FROM sys.sql_modules AS m
INNER JOIN sys.objects AS o
    ON m.object_id = o.object_id
WHERE 1=1
--and o.type = 'P'
AND o.name IN ('spprodutolistar') -- put the procedure you want to check here



DECLARE @endStmt NCHAR(6)
,@cmd VARCHAR(MAX)=''
      , @object_id INT
      , @definition NVARCHAR(MAX)
      , @uses_ansi_nulls BIT
      , @uses_quoted_identifier BIT

DECLARE @crlf VARCHAR(2), @len BIGINT, @offset BIGINT, @part BIGINT

SELECT @object_id = MIN(object_id)
     , @endStmt = CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
FROM @procs

DECLARE c CURSOR FOR SELECT definition
,  uses_ansi_nulls
,  uses_quoted_identifier
FROM @procs
ORDER BY nome ASC

OPEN c
FETCH NEXT FROM c INTO @definition,@uses_ansi_nulls,@uses_quoted_identifier

WHILE @@fetch_status<>-1
BEGIN
    
    IF LEN(@definition) <= 4000
        SELECT @cmd=@cmd+ @definition
    ELSE
    BEGIN

        SELECT @crlf = CHAR(13)+CHAR(10)
             , @len = LEN(@definition)
             , @offset = 1
             , @part = CHARINDEX(@crlf,@definition)-1

        WHILE @offset <= @len AND @part>=0
        BEGIN
			
			IF @offset BETWEEN 18868 AND 21490 -- specify the offsets here
			BEGIN          
				PRINT @offset
				PRINT @part
				--PRINT LEN(@crlf)
				--PRINT @len
			      
				SELECT @cmd=@cmd+ SUBSTRING(@definition,@offset,@part)

				SET @offset = @offset + @part + LEN(@crlf)
				SET @part = CHARINDEX(@crlf,@definition,@offset)-@offset

				--PRINT @offset
				--PRINT @part
				--PRINT @len

				IF @part < 0 
					SELECT @cmd=@cmd+ SUBSTRING(@definition,@offset,100)
			END
			ELSE
			BEGIN          
				PRINT @offset
				PRINT @part
				SET @offset = @offset + @part + LEN(@crlf)
				SET @part = CHARINDEX(@crlf,@definition,@offset)-@offset  
				IF @part < 0 
					SELECT @cmd=@cmd+ SUBSTRING(@definition,@offset,100)        
			END
        END
    END

	SELECT CHECKSUM(LTRIM(RTRIM(REPLACE(REPLACE(@cmd,CHAR(13),''),CHAR(10),'')))),@cmd;


FETCH NEXT FROM c INTO @definition,@uses_ansi_nulls,@uses_quoted_identifier
END
CLOSE c
DEALLOCATE c
