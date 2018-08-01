--retrieving definition for the views inside the database. You can use it to create backups of  your objects in the file system
SELECT  ISNULL(smsp.definition, ssmsp.definition) --AS [Definition]
FROM
sys.all_objects AS sp
LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id
LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id
WHERE
(sp.type = N'V' AND SP.TYPE_DESC = 'VIEW' AND SP.OBJECT_ID > 0 AND SP.IS_MS_SHIPPED = 0)
order by sp.name