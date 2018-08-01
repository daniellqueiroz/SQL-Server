/*
Remarks:

1. Use this script to check what were the connection properties of a particular object
2. Usage: SQL Server 2005 onwards
*/

SELECT o.name
FROM   sys.sql_modules m
JOIN   sys.objects o ON m.object_id = o.object_id
WHERE  (m.uses_quoted_identifier = 0 or
m.uses_ansi_nulls = 0)
AND  o.type NOT IN ('R', 'D')
--AND definition LIKE '%[produto]%'

