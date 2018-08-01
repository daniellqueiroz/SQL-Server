--cleaning auditing objects. There are not needed in non production environments and generally occupy a lot of space on disk

DECLARE audit CURSOR FOR
SELECT 'if object_id('''+name+''') is not null ' +
'drop ' + CASE [type] WHEN 'U' THEN + ' table ' + name
WHEN 'V' THEN ' view ' + name
WHEN 'FN' THEN ' function ' + name
WHEN 'tr' THEN ' trigger ' + name
WHEN 'p' THEN ' procedure ' + name
END
FROM sys.objects WHERE name LIKE '%audit%'
AND type IN ('u','v','p','tr','fn')
ORDER BY name
--and parent_object_id <> 0
OPEN audit
DECLARE @audit VARCHAR(500)
FETCH NEXT FROM audit INTO @audit
WHILE @@fetch_status <> -1
BEGIN
	BEGIN TRY
	PRINT(@audit)
	EXEC(@audit)
	END TRY
	BEGIN CATCH
	PRINT ERROR_MESSAGE()
	END CATCH
FETCH NEXT FROM audit INTO @audit
END
CLOSE audit
DEALLOCATE audit