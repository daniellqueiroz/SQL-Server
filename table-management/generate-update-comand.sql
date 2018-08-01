-- run this script to generate a update statement that will synchronize the same table between two databases
-- make sure to specify the proper database names and linked servers

DECLARE @TABELA VARCHAR(100)= 'lojista',@pk VARCHAR(100)
SELECT @pk = c.name
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND c.column_id=1

SELECT * FROM (
SELECT 'update t set' AS comando,1 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND c.column_id=1

UNION
SELECT /*CASE ROW_NUMBER() OVER(ORDER BY c.name) WHEN 1 THEN '' ELSE ',' END +*/ ',t.'+c.name + '= source.'+c.name AS comando,2 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND name NOT IN (@pk,'DataAtualizacao')

UNION
SELECT 'from ' + @TABELA + ' AS t INNER JOIN [EXTRA_PRD.DC.NOVA,1301].db_prd_extra.dbo.produto AS source ON source.'+@pk+ '=t.'+@pk + ' where 1=1 and (' AS comando,3 AS ordem

UNION

SELECT CASE ROW_NUMBER() OVER(ORDER BY c.name) WHEN 1 THEN '' ELSE 'or' END + ' ((t.'+name + '<> source.'+c.name + ' or (t.'+name+ ' is null and source.'+name + ' is not null) or (t.'+name+ ' is not null and source.'+name+ ' is null )' + '))' AS comando,4 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA AND name NOT IN (@pk,'DataAtualizacao')

UNION

SELECT ');  ' AS comando,10 AS ordem
) AS a

ORDER BY ordem 