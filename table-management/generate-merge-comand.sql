-- run this script to generate a merge comand for a table. This can be useful to deploy MERGE statements
-- after runing it and generating the MERGE comand, make sure to get rid of any unecessary commas

DECLARE @TABELA VARCHAR(100)= 'Lojista'

SELECT * FROM (
SELECT TOP 1 'MERGE ' + OBJECT_NAME(c.object_id) + ' AS TARGET USING () AS SOURCE ON (TARGET.' + c.name + '=source.'+c.name + ')' AS comando,1 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA
UNION
SELECT 'WHEN MATCHED 
	and 
	(',2 AS ordem

UNION
SELECT 'or ((target.'+name + '<> source.'+c.name + ' or (target.'+name+ ' is null and source.'+name + ' is not null) or (target.'+name+ ' is not null and source.'+name+ ' is null )' + '))' AS comando,3 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION
SELECT ') THEN UPDATE SET ' AS comando,4 AS ordem

UNION

SELECT ',TARGET.'+name+'=source.'+name  AS comando,5 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION

SELECT 'WHEN NOT MATCHED THEN   
	INSERT (' AS comando,6 AS ordem
UNION

SELECT c.name + ',',7 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION

SELECT ') VALUES (' AS comando, 8 AS ordem

UNION

SELECT ',source.'+c.name AS comando,9 AS ordem
FROM 
sys.columns c
WHERE OBJECT_NAME(c.object_id)=@TABELA

UNION

SELECT ');  ' AS comando,10 AS ordem
) AS a

ORDER BY ordem 