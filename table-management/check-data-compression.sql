--EXECUTE this query to check which tables have been enabled for data compression
SELECT DISTINCT ST.name, ST.object_id
--, SP.partition_id, SP.partition_number
, SP.data_compression, 
SP.data_compression_desc 
FROM sys.partitions SP
INNER JOIN sys.tables ST ON
ST.object_id = SP.object_id
WHERE data_compression <> 0