/*

Remarks:

1. This script will generate the command you should run on command prompt to extract and load data between 2 SQL Server databases. Just click on the link on the output. It will open a second tab containing the actual script.

*/

SET CONCAT_NULL_YIELDS_NULL OFF	

DECLARE @tableToBCP NVARCHAR(128)   ='administrador' -- the table you want to export/import
    , @Top          VARCHAR(10)     = 1000 -- Leave NULL for all rows
    , @Delimiter    VARCHAR(4)      = '|'
    , @UseNULL      BIT             = 1 -- to keep null values and not substitute then with spaces and such
    , @OverrideChar CHAR(1)         = '~' --obsolete. Use only if you are having trouble with collations. Uncomment the commented section below
    , @MaxDop       CHAR(1)         = '1' --number of threads that should be used by this process
	,@sorigem NVARCHAR(100)='BARATEIRO_PRD.dc.nova,1305' --put the source server here (where you are going to read the data from)
	,@sdestino NVARCHAR(100)='VLO00478\SQL2014' --put the destination server here (where you are going to write the data to)
	,@borigem VARCHAR(100)='db_hom_casasbahia_swat'
	,@bdestino NVARCHAR(100)='db_prd_barateiro' --put the destination database here
	, @Directory    VARCHAR(256)    = 'c:\temp\BCPS' --where to put the files containing the actual data
	,@qcomp varchar(MAX)=NULL; --Leave NULL for nonfiltered export. If you wish to filter the data  being exported, just write your where filter here. E.g.: 'where id=1'

DECLARE @columnList VARCHAR(MAX)='';
DECLARE @bcpStatementIn NVARCHAR(MAX)='';
DECLARE @bcpStatementIn2 NVARCHAR(MAX)='';
DECLARE @bcpStatement2 NVARCHAR(MAX)='';
DECLARE @bcpStatement NVARCHAR(MAX) = ''
    , @currentID INT
    , @firstID INT;


DECLARE c CURSOR FOR 
SELECT name 
FROM sys.tables 
WHERE 1=1
--AND name like '[a-h]%'
AND is_ms_shipped=0
AND [schema_id]=SCHEMA_ID('dbo')
AND name NOT LIKE '%bkp%'
AND name NOT LIKE '%old%'
--AND name IN ('Cliente')
AND name = @tableToBCP
ORDER BY name;

OPEN c;
FETCH NEXT FROM c INTO @tableToBCP;
WHILE @@FETCH_STATUS <> -1
BEGIN

SET @bcpStatement = @bcpStatement + 'BCP "SELECT ';
SET @bcpStatement2 = @bcpStatement2 + 'BCP ';

SELECT @columnList=REPLACE(a.v,',|','')
FROM 
(
	SELECT
	(
		SELECT name +',' AS [data()]
		FROM sys.columns 
		WHERE object_id = OBJECT_ID(@tableToBCP)
		FOR XML PATH('')
	) + '|' AS v
) AS a
 
IF @Top IS NOT NULL
    SET @bcpStatement = @bcpStatement + 'TOP (' + @Top + ') ';
 
--SELECT @firstID = MIN(columnID) FROM @columnList;
 
/*WHILE EXISTS(SELECT * FROM @columnList)
BEGIN
 
    SELECT @currentID = MIN(columnID) FROM @columnList;
 
    IF @currentID <> @firstID
        SET @bcpStatement = @bcpStatement + ',';
 
    SELECT @bcpStatement = @bcpStatement + 
                            CASE 
                                WHEN user_type_id IN (231, 167, 175, 239) 
                                THEN 'CASE WHEN ' + name + ' = '''' THEN ' 
                                    + CASE 
                                        WHEN is_nullable = 1 THEN 'NULL' 
                                        ELSE '''' + REPLICATE(@OverrideChar, max_length) + ''''
                                      END
                                    + ' WHEN ' + name + ' LIKE ''%' + @Delimiter + '%'''
                                        + ' OR ' + name + ' LIKE ''%'' + CHAR(9) + ''%''' -- tab
                                        + ' OR ' + name + ' LIKE ''%'' + CHAR(10) + ''%''' -- line feed
                                        + ' OR ' + name + ' LIKE ''%'' + CHAR(13) + ''%''' -- carriage return
                                        + ' THEN ' 
                                        + CASE 
                                            WHEN is_nullable = 1 THEN 'NULL' 
                                            ELSE '''' + REPLICATE(@OverrideChar, max_length) + ''''
                                          END
                                    + ' ELSE ' + name + ' END' 
                                ELSE name 
                            END 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID(@tableToBCP)
        AND column_id = @currentID;
 
    DELETE FROM @columnList WHERE columnID = @currentID;
 
 
END;*/
 
SET @bcpStatement = @bcpStatement + @columnList + ' FROM ' + @borigem + '.dbo.' + @tableToBCP + @qcomp
    + ' OPTION (MAXDOP 1);" queryOut '
    + @Directory + REPLACE(@tableToBCP, '.', '_') + '.dat -S' + @sorigem
    + ' -T -t"' + @Delimiter + '" -c -CRAW -q' + CHAR(10) + CHAR(13);

SET @bcpStatement2 = @bcpStatement2 + ' ' + @borigem + '.dbo.' + @tableToBCP 
    + ' out '
    + @Directory + REPLACE(@tableToBCP, '.', '_') + '.dat -S' + @sorigem
    + ' -T -n -E -q' + CHAR(10) + CHAR(13);

SET @bcpStatementIn = @bcpStatementIn + 'bcp  ' + @bdestino + '.dbo.' + @tableToBCP + ' in ' + @Directory + REPLACE(@tableToBCP, '.', '_') + '.dat -S' + @sdestino
    + ' -T -t"' + @Delimiter + '" -c -CRAW -q' + CHAR(10) + CHAR(13);

SET @bcpStatementIn2 = @bcpStatementIn2 + 'bcp  ' + @bdestino + '.dbo.' + @tableToBCP + ' in ' + @Directory + REPLACE(@tableToBCP, '.', '_') + '.dat -S' + @sdestino
    + ' -T -n -E -q' + CHAR(10) + CHAR(13);
 

FETCH NEXT FROM c INTO @tableToBCP;
END;
CLOSE c;
DEALLOCATE c;

DECLARE @VeryLongText NVARCHAR(MAX) = '';

SELECT TOP 100 @VeryLongText =  @VeryLongText + @bcpStatement2 + @bcpStatementIn2; 
SELECT @VeryLongText AS [processing-instruction(x)] FOR XML PATH('');
