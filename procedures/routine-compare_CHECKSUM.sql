/*

Use this script to return the hash of a given routine. This hash can then be compared to the hash of the same routine on another database. This method is useful when you have several databases and you want to perform
a quick check wether you have the same version of an object.

*/

SET NOCOUNT ON

DECLARE @procs AS TABLE( nome varchar(200),object_id INT
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
AND o.name IN ('spListarFlagsDestaqueColecao') -- put your routine here



DECLARE @endStmt NCHAR(6)
,@cmd varchar(MAX)=''
      , @object_id INT
      , @definition NVARCHAR(MAX)
      , @uses_ansi_nulls BIT
      , @uses_quoted_identifier BIT

DECLARE @crlf VARCHAR(2), @len BIGINT, @offset BIGINT, @part BIGINT

SELECT @object_id = MIN(object_id)
     , @endStmt = CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
FROM @procs

declare c cursor for SELECT definition
,  uses_ansi_nulls
,  uses_quoted_identifier
FROM @procs
order by nome asc

open c
fetch next from c into @definition,@uses_ansi_nulls,@uses_quoted_identifier

while @@fetch_status<>-1
begin
    IF @uses_ansi_nulls = 1
        select @cmd=@cmd+ 'SET ANSI_NULLS ON' + @endStmt;
    ELSE
        select @cmd=@cmd+ 'SET ANSI_NULLS OFF' + @endStmt;

    IF @uses_quoted_identifier = 1
        select @cmd=@cmd+ 'SET QUOTED_IDENTIFIER ON' + @endStmt;
    ELSE
        select @cmd=@cmd+ 'SET QUOTED_IDENTIFIER OFF' + @endStmt;

	--PRINT @definition;

    IF LEN(@definition) <= 4000
        select @cmd=@cmd+ @definition
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
			      
            select @cmd=@cmd+ SUBSTRING(@definition,@offset,@part)

            SET @offset = @offset + @part + LEN(@crlf)
            SET @part = CHARINDEX(@crlf,@definition,@offset)-@offset

			--PRINT @offset
			--PRINT @part
			--PRINT @len

			IF @part < 0 
			select @cmd=@cmd+ SUBSTRING(@definition,@offset,100)
        END
    END

	SELECT CHECKSUM(LTRIM(RTRIM(REPLACE(REPLACE(@cmd,CHAR(13),''),char(10),''))))--,@cmd;


fetch next from c into @definition,@uses_ansi_nulls,@uses_quoted_identifier
end
close c
deallocate c
