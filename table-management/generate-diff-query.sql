-- run this script to generate a command that will compare the same table between two databases. This can be useful to spot synchronization problems between two bases
-- this script will not work on tables that have composite  primary keys

DECLARE @TABELA VARCHAR(100)= 'lojista', --specify you table here
@pk VARCHAR(100)

SELECT @pk = c.name
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND c.column_id=1

SELECT * FROM (
SELECT 'select TOP 10 target.' +c.name AS comando,1 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND c.column_id=1

UNION
SELECT ',case when ((target.'+name + '<> source.'+c.name + ' or (target.'+name+ ' is null and source.'+name + ' is not null) or (target.'+name+ ' is not null and source.'+name+ ' is null )' + ')) then ''diff'' else ''not diff'' end as ' + c.name AS comando,2 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION
SELECT 'from ' + @TABELA + ' AS target INNER JOIN [EXTRA_PRD.DC.NOVA,1301].db_prd_extra.dbo.lojista AS source ON source.'+@pk+ '=target.'+@pk + ' where 1=1 and (' AS comando,3 AS ordem

UNION

SELECT CASE ROW_NUMBER() OVER(ORDER BY c.name) WHEN 1 THEN '' ELSE 'or' END + ' ((target.'+name + '<> source.'+c.name + ' or (target.'+name+ ' is null and source.'+name + ' is not null) or (target.'+name+ ' is not null and source.'+name+ ' is null )' + '))' AS comando,4 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION

SELECT ');  ' AS comando,10 AS ordem
) AS a

ORDER BY ordem 