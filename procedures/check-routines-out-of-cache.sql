/*
Use this script to check which procedures are not contained within the database cache. This may indicate that a particular routine might have turned obsolete.
*/

SELECT name 
FROM sys.procedures 
WHERE name not IN(
SELECT DISTINCT p.name AS [SP Name]	
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK) ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
AND p.schema_id=schema_id('loja')
)
AND schema_id=schema_id('loja')
ORDER BY name
GO

SELECT name 
FROM sys.procedures 
WHERE name not IN(
SELECT DISTINCT p.name AS [SP Name]	
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK) ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
AND p.schema_id=schema_id('corp')
)
AND schema_id=schema_id('corp')
ORDER BY name

