SELECT DISTINCT t.name
FROM sys.partitions p
INNER JOIN sys.tables t
ON p.object_id = t.object_id
WHERE p.partition_number <> 1

